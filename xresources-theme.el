;;; xresources-theme.el --- Use your .Xresources as your emacs theme

;; Copyright (C) 2014-2017 Marten Lienen <marten.lienen@gmail.com>, Tudor Roman <tudor@tudorr.xyz>

;; Author: Marten Lienen <marten.lienen@gmail.com>, Tudor Roman <tudor@tudorr.xyz>
;; Keywords: xresources, theme
;; Version: 0.2.1

;; This file is not part of GNU Emacs.

;; This program is free software; you can redistribute it and/or modify it under
;; the terms of the GNU General Public License as published by the Free Software
;; Foundation; either version 3, or (at your option) any later version.
;;
;; This program is distributed in the hope that it will be useful, but WITHOUT
;; ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
;; FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more
;; details.
;;
;; You should have received a copy of the GNU General Public License along with
;; GNU Emacs; see the file COPYING.  If not, write to the Free Software
;; Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301,
;; USA.

;;; Commentary:

;; Use the colors defined in your .Xresources as your Emacs theme

;;; Code:

(defun terminal-color-to-emacs-color (color)
  "Return the Emacs color name of a given X resource terminal color."
  (let ((colormap
         '(("color0" . "black")
           ("color1" . "red")
           ("color2" . "green")
           ("color3" . "yellow")
           ("color4" . "blue")
           ("color5" . "magenta")
           ("color6" . "cyan")
           ("color7" . "white")

           ("color8" . "brightblack")
           ("color9" . "brightred")
           ("color10" . "brightgreen")
           ("color11" . "brightyellow")
           ("color12" . "brightblue")
           ("color13" . "brightmagenta")
           ("color14" . "brightcyan")
           ("color15" . "brightwhite"))))
    (cdr (assoc color colormap))))

(defun get-resource (name)
  "Get X resource value."
  (replace-regexp-in-string "\n$" ""
                            (shell-command-to-string
                             (concat "xrq '" name "'"))))

(defun xresources-theme-color (name)
  "Read the color NAME (e.g. color5) from the X resources."
  (if (display-graphic-p)
      (get-resource name)
    (terminal-color-to-emacs-color name)))

(defun colort (amount color)
  "Tint color using colort"
  (shell-command-to-string
   (concat "colort -l " (number-to-string amount) " '" color "'")))

(deftheme xresources "~/.Xresources as a theme")

(set-face-attribute 'default nil :font (get-resource "Emacs.font"))
(set-frame-font (get-resource "Emacs.font") nil t)

(let* ((foreground (xresources-theme-color "foreground"))
       (background (xresources-theme-color "background"))
       (black (xresources-theme-color "color0"))
       (red (xresources-theme-color "color1"))
       (green (xresources-theme-color "color2"))
       (yellow (xresources-theme-color "color3"))
       (blue (xresources-theme-color "color4"))
       (magenta (xresources-theme-color "color5"))
       (cyan (xresources-theme-color "color6"))
       (gray (xresources-theme-color "color7"))
       (light-gray (xresources-theme-color "color8"))
       (light-red (xresources-theme-color "color9"))
       (light-green (xresources-theme-color "color10"))
       (light-yellow (xresources-theme-color "color11"))
       (light-blue (xresources-theme-color "color12"))
       (light-magenta (xresources-theme-color "color13"))
       (light-cyan (xresources-theme-color "color14"))
       (white (xresources-theme-color "color15"))

       (mode-line-darker-bg (colort -2 background))
       (mode-line-darker-bg-inactive (colort -5 background))
       (vertical-border-darker (colort -1 black)))
  (custom-theme-set-faces
   'xresources

   ;; Built-in
   ;; basic coloring
   '(button ((t (:underline t))))
   `(link ((t (:foreground ,yellow :underline t :weight bold))))
   `(link-visited ((t (:foreground ,yellow :underline t :weight normal))))
   `(default ((t (:foreground ,foreground :background ,background))))
   `(cursor ((t (:foreground ,foreground :background ,foreground))))
   `(escape-glyph ((t (:foreground ,yellow :bold t))))
   `(fringe ((t (:foreground ,foreground :background ,background))))
   `(header-line ((t (:foreground ,yellow
                                  :background ,background
                                  :box (:line-width -1 :style released-button)))))
   `(highlight ((t (:background ,background))))
   `(success ((t (:foreground ,green :weight bold))))
   `(warning ((t (:foreground ,red :weight bold))))

   ;; compilation
   `(compilation-column-face ((t (:foreground ,yellow))))
   `(compilation-enter-directory-face ((t (:foreground ,green))))
   `(compilation-error-face ((t (:foreground ,red :weight bold :underline t))))
   `(compilation-face ((t (:foreground ,foreground))))
   `(compilation-info-face ((t (:foreground ,blue))))
   `(compilation-info ((t (:foreground ,green :underline t))))
   `(compilation-leave-directory-face ((t (:foreground ,green))))
   `(compilation-line-face ((t (:foreground ,yellow))))
   `(compilation-line-number ((t (:foreground ,yellow))))
   `(compilation-message-face ((t (:foreground ,blue))))
   `(compilation-warning-face ((t (:foreground ,red :weight bold :underline t))))
   `(compilation-mode-line-exit ((t (:foreground ,green :weight bold))))
   `(compilation-mode-line-fail ((t (:foreground ,red :weight bold))))
   `(compilation-mode-line-run ((t (:foreground ,yellow :weight bold))))

   ;; grep
   `(grep-context-face ((t (:foreground ,foreground))))
   `(grep-error-face ((t (:foreground ,red :weight bold :underline t))))
   `(grep-hit-face ((t (:foreground ,blue))))
   `(grep-match-face ((t (:foreground ,red :weight bold))))
   `(match ((t (:background ,background :foreground ,red :weight bold))))

   ;; isearch
   `(isearch ((t (:foreground ,yellow :weight bold :background ,background))))
   `(isearch-fail ((t (:foreground ,foreground :background ,red))))
   `(lazy-highlight ((t (:foreground ,yellow :weight bold :background ,background))))

   `(menu ((t (:foreground ,foreground :background ,background))))
   `(minibuffer-prompt ((t (:foreground ,yellow))))
   `(mode-line-inactive
     ((t (:foreground ,light-gray
                      :background ,mode-line-darker-bg-inactive
                      :box (:line-width 10 :color ,mode-line-darker-bg-inactive)))))
   `(mode-line
     ((t (:foreground ,light-gray
                      :background ,mode-line-darker-bg
                      :box (:line-width 10 :color ,mode-line-darker-bg)))))
   `(mode-line-buffer-id ((t (:foreground ,light-gray :weight bold))))
   `(region ((t (:background ,blue))
             (t :inverse-video t)))
   `(secondary-selection ((t (:background ,background))))
   `(trailing-whitespace ((t (:background ,red))))
   `(vertical-border ((t (:foreground ,vertical-border-darker :background ,vertical-border-darker))))

   ;; font lock
   `(font-lock-builtin-face ((t (:foreground ,foreground :weight bold))))
   `(font-lock-comment-face ((t (:foreground ,light-gray))))
   `(font-lock-comment-delimiter-face ((t (:foreground ,light-gray))))
   `(font-lock-constant-face ((t (:foreground ,green))))
   `(font-lock-doc-face ((t (:foreground ,green))))
   `(font-lock-function-name-face ((t (:foreground ,cyan))))
   `(font-lock-keyword-face ((t (:foreground ,light-blue :weight bold))))
   `(font-lock-negation-char-face ((t (:foreground ,yellow :weight bold))))
   `(font-lock-preprocessor-face ((t (:foreground ,blue))))
   `(font-lock-regexp-grouping-construct ((t (:foreground ,yellow :weight bold))))
   `(font-lock-regexp-grouping-backslash ((t (:foreground ,green :weight bold))))
   `(font-lock-string-face ((t (:foreground ,red))))
   `(font-lock-type-face ((t (:foreground ,blue))))
   `(font-lock-variable-name-face ((t (:foreground ,gray))))
   `(font-lock-warning-face ((t (:foreground ,yellow :weight bold))))
   `(c-annotation-face ((t (:inherit font-lock-constant-face))))

   ;; which-function-mode
   `(which-func ((t (:foreground ,blue))))

   ;; Third-party

   ;; ace-jump
   `(ace-jump-face-background
     ((t (:foreground ,foreground :background ,background :inverse-video nil))))
   `(ace-jump-face-foreground
     ((t (:foreground ,green :background ,background :inverse-video nil))))

   ;; auctex
   `(font-latex-bold-face ((t (:inherit bold))))
   `(font-latex-warning-face ((t (:foreground nil :inherit font-lock-warning-face))))
   `(font-latex-sectioning-5-face ((t (:foreground ,red :weight bold))))
   `(font-latex-sedate-face ((t (:foreground ,yellow))))
   `(font-latex-italic-face ((t (:foreground ,cyan :slant italic))))
   `(font-latex-string-face ((t (:inherit ,font-lock-string-face))))
   `(font-latex-math-face ((t (:foreground ,red))))

   ;; auto-complete
   `(ac-candidate-face ((t (:background ,foreground :foreground ,background))))
   `(ac-selection-face ((t (:background ,blue :foreground ,foreground))))
   `(popup-tip-face ((t (:background ,yellow :foreground ,background))))
   `(popup-scroll-bar-foreground-face ((t (:background ,blue))))
   `(popup-scroll-bar-background-face ((t (:background ,background))))
   `(popup-isearch-match ((t (:background ,background :foreground ,foreground))))

   ;; company-mode
   `(company-tooltip ((t (:foreground ,foreground :background ,background))))
   `(company-tooltip-selection ((t (:foreground ,foreground :background ,background))))
   `(company-tooltip-mouse ((t (:background ,background))))
   `(company-tooltip-common ((t (:foreground ,green))))
   `(company-tooltip-common-selection ((t (:foreground ,green))))
   `(company-scrollbar-fg ((t (:background ,background))))
   `(company-scrollbar-bg ((t (:background ,background))))
   `(company-preview ((t (:background ,green))))
   `(company-preview-common ((t (:foreground ,green :background ,background))))

   ;; clojure-test-mode
   `(clojure-test-failure-face ((t (:foreground ,red :weight bold :underline t))))
   `(clojure-test-error-face ((t (:foreground ,red :weight bold :underline t))))
   `(clojure-test-success-face ((t (:foreground ,green :weight bold :underline t))))

   ;; cperl-mode
   `(cperl-array-face ((t (:foreground ,yellow))))
   `(cperl-hash-face ((t (:foreground ,cyan))))
   `(cperl-nonoverridable-face ((t (:foreground ,light-magenta))))

   ;; diff
   `(diff-added ((t (:foreground ,green :background nil))
                 (t (:foreground ,green :background nil))))
   `(diff-changed ((t (:foreground ,yellow))))
   `(diff-removed ((t (:foreground ,red :background nil))
                   (t (:foreground ,red :background nil))))
   `(diff-refine-added ((t (:inherit diff-added :weight bold))))
   `(diff-refine-change ((t (:inherit diff-changed :weight bold))))
   `(diff-refine-removed ((t (:inherit diff-removed :weight bold))))
   `(diff-header ((t (:background ,background))
                  (t (:background ,foreground :foreground ,background))))
   `(diff-file-header
     ((t (:background ,background :foreground ,foreground :bold t))
      (t (:background ,foreground :foreground ,background :bold t))))

   ;; diff-hl
   `(diff-hl-change ((t (:foreground ,blue :background ,background))))
   `(diff-hl-delete ((t (:foreground ,red :background ,background))))
   `(diff-hl-insert ((t (:foreground ,green :background ,background))))
   `(diff-hl-unknown ((t (:foreground ,yellow :background ,background))))

   ;; dired+
   `(diredp-display-msg ((t (:foreground ,blue))))
   `(diredp-compressed-file-suffix ((t (:foreground ,red))))
   `(diredp-date-time ((t (:foreground ,magenta))))
   `(diredp-deletion ((t (:foreground ,yellow))))
   `(diredp-deletion-file-name ((t (:foreground ,red))))
   `(diredp-dir-heading ((t (:foreground ,blue :background ,background))))
   `(diredp-dir-priv ((t (:foreground ,cyan))))
   `(diredp-exec-priv ((t (:foreground ,red))))
   `(diredp-executable-tag ((t (:foreground ,green))))
   `(diredp-file-name ((t (:foreground ,blue))))
   `(diredp-file-suffix ((t (:foreground ,green))))
   `(diredp-flag-mark ((t (:foreground ,yellow))))
   `(diredp-flag-mark-line ((t (:foreground ,red))))
   `(diredp-ignored-file-name ((t (:foreground ,red))))
   `(diredp-link-priv ((t (:foreground ,yellow))))
   `(diredp-mode-line-flagged ((t (:foreground ,yellow))))
   `(diredp-mode-line-marked ((t (:foreground ,red))))
   `(diredp-no-priv ((t (:foreground ,foreground))))
   `(diredp-number ((t (:foreground ,green))))
   `(diredp-other-priv ((t (:foreground ,yellow))))
   `(diredp-rare-priv ((t (:foreground ,red))))
   `(diredp-read-priv ((t (:foreground ,green))))
   `(diredp-symlink ((t (:foreground ,yellow))))
   `(diredp-write-priv ((t (:foreground ,magenta))))

   ;; ediff
   `(ediff-current-diff-A ((t (:foreground ,foreground :background ,red))))
   `(ediff-current-diff-Ancestor ((t (:foreground ,foreground :background ,red))))
   `(ediff-current-diff-B ((t (:foreground ,foreground :background ,green))))
   `(ediff-current-diff-C ((t (:foreground ,foreground :background ,blue))))
   `(ediff-even-diff-A ((t (:background ,background))))
   `(ediff-even-diff-Ancestor ((t (:background ,background))))
   `(ediff-even-diff-B ((t (:background ,background))))
   `(ediff-even-diff-C ((t (:background ,background))))
   `(ediff-fine-diff-A ((t (:foreground ,foreground :background ,red :weight bold))))
   `(ediff-fine-diff-Ancestor ((t (:foreground ,foreground :background ,red weight bold))))
   `(ediff-fine-diff-B ((t (:foreground ,foreground :background ,green :weight bold))))
   `(ediff-fine-diff-C ((t (:foreground ,foreground :background ,blue :weight bold))))
   `(ediff-odd-diff-A ((t (:background ,background))))
   `(ediff-odd-diff-Ancestor ((t (:background ,background))))
   `(ediff-odd-diff-B ((t (:background ,background))))
   `(ediff-odd-diff-C ((t (:background ,background))))

   ;; erc
   `(erc-action-face ((t (:inherit erc-default-face))))
   `(erc-bold-face ((t (:weight bold))))
   `(erc-current-nick-face ((t (:foreground ,blue :weight bold))))
   `(erc-dangerous-host-face ((t (:inherit font-lock-warning-face))))
   `(erc-default-face ((t (:foreground ,foreground))))
   `(erc-direct-msg-face ((t (:inherit erc-default))))
   `(erc-error-face ((t (:inherit font-lock-warning-face))))
   `(erc-fool-face ((t (:inherit erc-default))))
   `(erc-highlight-face ((t (:inherit hover-highlight))))
   `(erc-input-face ((t (:foreground ,yellow))))
   `(erc-keyword-face ((t (:foreground ,blue :weight bold))))
   `(erc-nick-default-face ((t (:foreground ,yellow :weight bold))))
   `(erc-my-nick-face ((t (:foreground ,red :weight bold))))
   `(erc-nick-msg-face ((t (:inherit erc-default))))
   `(erc-notice-face ((t (:foreground ,green))))
   `(erc-pal-face ((t (:foreground ,red :weight bold))))
   `(erc-prompt-face ((t (:foreground ,red :background ,background :weight bold))))
   `(erc-timestamp-face ((t (:foreground ,green))))
   `(erc-underline-face ((t (:underline t))))

   ;; ert
   `(ert-test-result-expected ((t (:foreground ,green :background ,background))))
   `(ert-test-result-unexpected ((t (:foreground ,red :background ,background))))

   ;; eshell
   `(eshell-prompt ((t (:foreground ,yellow :weight bold))))
   `(eshell-ls-archive ((t (:foreground ,red :weight bold))))
   `(eshell-ls-backup ((t (:inherit font-lock-comment-face))))
   `(eshell-ls-clutter ((t (:inherit font-lock-comment-face))))
   `(eshell-ls-directory ((t (:foreground ,blue :weight bold))))
   `(eshell-ls-executable ((t (:foreground ,red :weight bold))))
   `(eshell-ls-unreadable ((t (:foreground ,foreground))))
   `(eshell-ls-missing ((t (:inherit font-lock-warning-face))))
   `(eshell-ls-product ((t (:inherit font-lock-doc-face))))
   `(eshell-ls-special ((t (:foreground ,yellow :weight bold))))
   `(eshell-ls-symlink ((t (:foreground ,cyan :weight bold))))

   ;; flycheck
   `(flycheck-error
     ((((supports :underline (:style wave)))
       (:underline (:style wave :color ,red) :inherit unspecified))
      (t (:foreground ,red :weight bold :underline t))))
   `(flycheck-warning
     ((((supports :underline (:style wave)))
       (:underline (:style wave :color ,yellow) :inherit unspecified))
      (t (:foreground ,yellow :weight bold :underline t))))
   `(flycheck-info
     ((((supports :underline (:style wave)))
       (:underline (:style wave :color ,cyan) :inherit unspecified))
      (t (:foreground ,cyan :weight bold :underline t))))
   `(flycheck-fringe-error ((t (:foreground ,red :weight bold))))
   `(flycheck-fringe-warning ((t (:foreground ,yellow :weight bold))))
   `(flycheck-fringe-info ((t (:foreground ,cyan :weight bold))))

   ;; git-rebase-mode
   `(git-rebase-hash ((t (:foreground, red))))

   ;; helm
   `(helm-header
     ((t (:foreground ,green
                      :background ,background
                      :underline nil
                      :box nil))))
   `(helm-source-header
     ((t (:foreground ,yellow
                      :background ,background
                      :underline nil
                      :weight bold
                      :box (:line-width -1 :style released-button)))))
   `(helm-selection ((t (:background ,green :underline nil))))
   `(helm-selection-line ((t (:background ,background))))
   `(helm-visible-mark ((t (:foreground ,background :background ,yellow))))
   `(helm-candidate-number ((t (:foreground ,green :background ,background))))
   `(helm-separator ((t (:foreground ,red :background ,background))))
   `(helm-time-zone-current ((t (:foreground ,green :background ,background))))
   `(helm-time-zone-home ((t (:foreground ,red :background ,background))))
   `(helm-bookmark-addressbook ((t (:foreground ,red :background ,background))))
   `(helm-bookmark-directory ((t (:foreground nil :background nil :inherit helm-ff-directory))))
   `(helm-bookmark-file ((t (:foreground nil :background nil :inherit helm-ff-file))))
   `(helm-bookmark-gnus ((t (:foreground ,magenta :background ,background))))
   `(helm-bookmark-info ((t (:foreground ,green :background ,background))))
   `(helm-bookmark-man ((t (:foreground ,yellow :background ,background))))
   `(helm-bookmark-w3m ((t (:foreground ,magenta :background ,background))))
   `(helm-buffer-not-saved ((t (:foreground ,red :background ,background))))
   `(helm-buffer-process ((t (:foreground ,cyan :background ,background))))
   `(helm-buffer-saved-out ((t (:foreground ,foreground :background ,background))))
   `(helm-buffer-size ((t (:foreground ,foreground :background ,background))))
   `(helm-ff-directory ((t (:foreground ,cyan :background ,background :weight bold))))
   `(helm-ff-file ((t (:foreground ,foreground :background ,background :weight normal))))
   `(helm-ff-executable ((t (:foreground ,green :background ,background :weight normal))))
   `(helm-ff-invalid-symlink ((t (:foreground ,red :background ,background :weight bold))))
   `(helm-ff-symlink ((t (:foreground ,yellow :background ,background :weight bold))))
   `(helm-ff-prefix ((t (:foreground ,background :background ,yellow :weight normal))))
   `(helm-grep-cmd-line ((t (:foreground ,cyan :background ,background))))
   `(helm-grep-file ((t (:foreground ,foreground :background ,background))))
   `(helm-grep-finish ((t (:foreground ,green :background ,background))))
   `(helm-grep-lineno ((t (:foreground ,foreground :background ,background))))
   `(helm-grep-match ((t (:foreground nil :background nil :inherit helm-match))))
   `(helm-grep-running ((t (:foreground ,red :background ,background))))
   `(helm-moccur-buffer ((t (:foreground ,cyan :background ,background))))
   `(helm-mu-contacts-address-face ((t (:foreground ,foreground :background ,background))))
   `(helm-mu-contacts-name-face ((t (:foreground ,foreground :background ,background))))

   ;; hl-line-mode
   `(hl-line-face ((t (:background ,background))
                   (t :weight bold)))
   `(hl-line ((t (:background ,background)) ; old emacsen
              (t :weight bold)))

   ;; ido-mode
   `(ido-first-match ((t (:foreground ,yellow :weight bold))))
   `(ido-only-match ((t (:foreground ,red :weight bold))))
   `(ido-subdir ((t (:foreground ,yellow))))
   `(ido-indicator ((t (:foreground ,yellow :background ,red))))

   ;; js2-mode
   `(js2-warning ((t (:underline ,red))))
   `(js2-error ((t (:foreground ,red :weight bold))))
   `(js2-jsdoc-tag ((t (:foreground ,green))))
   `(js2-jsdoc-type ((t (:foreground ,green))))
   `(js2-jsdoc-value ((t (:foreground ,green))))
   `(js2-function-param ((t (:foreground, green))))
   `(js2-external-variable ((t (:foreground ,red))))

   ;; linum-mode
   `(linum ((t (:foreground ,light-gray :background ,background))))

   ;; magit
   `(magit-item-highlight ((t (:background ,background))))
   `(magit-section-title ((t (:foreground ,yellow :weight bold))))
   `(magit-process-ok ((t (:foreground ,green :weight bold))))
   `(magit-process-ng ((t (:foreground ,red :weight bold))))
   `(magit-branch ((t (:foreground ,blue :weight bold))))
   `(magit-log-author ((t (:foreground ,red))))
   `(magit-log-sha1 ((t (:foreground, red))))

   ;; org-mode
   `(org-agenda-date-today
     ((t (:foreground ,foreground :slant italic :weight bold))) t)
   `(org-agenda-structure
     ((t (:inherit font-lock-comment-face))))
   `(org-archived ((t (:foreground ,foreground :weight bold))))
   `(org-checkbox ((t (:background ,background :foreground ,foreground
                                   :box (:line-width 1 :style released-button)))))
   `(org-date ((t (:foreground ,blue :underline t))))
   `(org-deadline-announce ((t (:foreground ,red))))
   `(org-done ((t (:bold t :weight bold :foreground ,green))))
   `(org-formula ((t (:foreground ,yellow))))
   `(org-headline-done ((t (:foreground ,green))))
   `(org-hide ((t (:foreground ,background))))
   `(org-level-1 ((t (:foreground ,red))))
   `(org-level-2 ((t (:foreground ,green))))
   `(org-level-3 ((t (:foreground ,blue))))
   `(org-level-4 ((t (:foreground ,yellow))))
   `(org-level-5 ((t (:foreground ,cyan))))
   `(org-level-6 ((t (:foreground ,green))))
   `(org-level-7 ((t (:foreground ,red))))
   `(org-level-8 ((t (:foreground ,blue))))
   `(org-link ((t (:foreground ,yellow :underline t))))
   `(org-scheduled ((t (:foreground ,green))))
   `(org-scheduled-previously ((t (:foreground ,red))))
   `(org-scheduled-today ((t (:foreground ,blue))))
   `(org-sexp-date ((t (:foreground ,blue :underline t))))
   `(org-special-keyword ((t (:inherit font-lock-comment-face))))
   `(org-table ((t (:foreground ,green))))
   `(org-tag ((t (:bold t :weight bold))))
   `(org-time-grid ((t (:foreground ,red))))
   `(org-todo ((t (:bold t :foreground ,red :weight bold))))
   `(org-upcoming-deadline ((t (:inherit font-lock-keyword-face))))
   `(org-warning ((t (:bold t :foreground ,red :weight bold :underline nil))))
   `(org-column ((t (:background ,background))))
   `(org-column-title ((t (:background ,background :underline t :weight bold))))
   `(org-mode-line-clock ((t (:foreground ,foreground :background ,background))))
   `(org-mode-line-clock-overrun ((t (:foreground ,background :background ,red))))
   `(org-ellipsis ((t (:foreground ,yellow :underline t))))
   `(org-footnote ((t (:foreground ,cyan :underline t))))

   ;; outline
   `(outline-1 ((t (:foreground ,red))))
   `(outline-2 ((t (:foreground ,green))))
   `(outline-3 ((t (:foreground ,blue))))
   `(outline-4 ((t (:foreground ,yellow))))
   `(outline-5 ((t (:foreground ,cyan))))
   `(outline-6 ((t (:foreground ,green))))
   `(outline-7 ((t (:foreground ,red))))
   `(outline-8 ((t (:foreground ,blue))))

   ;; powerline
   `(powerline-active1 ((t (:background ,background :inherit mode-line))))
   `(powerline-active2 ((t (:background ,background :inherit mode-line))))
   `(powerline-inactive1 ((t (:background ,background :inherit mode-line-inactive))))
   `(powerline-inactive2 ((t (:background ,background :inherit mode-line-inactive))))

   ;; rainbow-delimiters
   `(rainbow-delimiters-depth-1-face ((t (:foreground ,foreground))))
   `(rainbow-delimiters-depth-2-face ((t (:foreground ,green))))
   `(rainbow-delimiters-depth-3-face ((t (:foreground ,yellow))))
   `(rainbow-delimiters-depth-4-face ((t (:foreground ,cyan))))
   `(rainbow-delimiters-depth-5-face ((t (:foreground ,green))))
   `(rainbow-delimiters-depth-6-face ((t (:foreground ,blue))))
   `(rainbow-delimiters-depth-7-face ((t (:foreground ,yellow))))
   `(rainbow-delimiters-depth-8-face ((t (:foreground ,green))))
   `(rainbow-delimiters-depth-9-face ((t (:foreground ,blue))))
   `(rainbow-delimiters-depth-10-face ((t (:foreground ,red))))
   `(rainbow-delimiters-depth-11-face ((t (:foreground ,green))))
   `(rainbow-delimiters-depth-12-face ((t (:foreground ,blue))))

   ;; sh-mode
   `(sh-heredoc     ((t (:foreground ,yellow :bold t))))
   `(sh-quoted-exec ((t (:foreground ,red))))

   ;; smartparens
   `(sp-show-pair-mismatch-face ((t (:foreground ,red :background ,background :weight bold))))
   `(sp-show-pair-match-face ((t (:background ,background :weight bold))))

   ;; terminal
   `(term-color-black ((t (:foreground ,black))))
   `(term-color-red ((t (:foreground ,red))))
   `(term-color-green ((t (:foreground ,green))))
   `(term-color-yellow ((t (:foreground ,yellow))))
   `(term-color-blue ((t (:foreground ,blue))))
   `(term-color-magenta ((t (:foreground ,magenta))))
   `(term-color-cyan ((t (:foreground ,cyan))))
   `(term-color-white ((t (:foreground ,white))))

   ;; circe
   `(lui-irc-colors-bg-0-face ((t (:background ,white))))
   `(lui-irc-colors-bg-1-face ((t (:background ,black))))
   `(lui-irc-colors-bg-2-face ((t (:background ,blue))))
   `(lui-irc-colors-bg-3-face ((t (:background ,green))))
   `(lui-irc-colors-bg-4-face ((t (:background ,red))))
   `(lui-irc-colors-bg-5-face ((t (:background ,red))))
   `(lui-irc-colors-bg-6-face ((t (:background ,magenta))))
   `(lui-irc-colors-bg-7-face ((t (:background ,yellow))))
   `(lui-irc-colors-bg-8-face ((t (:background ,yellow))))
   `(lui-irc-colors-bg-9-face ((t (:background ,light-green))))
   `(lui-irc-colors-bg-10-face ((t (:background ,cyan))))
   `(lui-irc-colors-bg-11-face ((t (:background ,light-cyan))))
   `(lui-irc-colors-bg-12-face ((t (:background ,light-blue))))
   `(lui-irc-colors-bg-13-face ((t (:background ,light-magenta))))
   `(lui-irc-colors-bg-14-face ((t (:background ,light-gray))))
   `(lui-irc-colors-bg-15-face ((t (:background ,gray))))

   `(lui-irc-colors-fg-0-face ((t (:foreground ,white))))
   `(lui-irc-colors-fg-1-face ((t (:foreground ,black))))
   `(lui-irc-colors-fg-2-face ((t (:foreground ,blue))))
   `(lui-irc-colors-fg-3-face ((t (:foreground ,green))))
   `(lui-irc-colors-fg-4-face ((t (:foreground ,red))))
   `(lui-irc-colors-fg-5-face ((t (:foreground ,red))))
   `(lui-irc-colors-fg-6-face ((t (:foreground ,magenta))))
   `(lui-irc-colors-fg-7-face ((t (:foreground ,yellow))))
   `(lui-irc-colors-fg-8-face ((t (:foreground ,yellow))))
   `(lui-irc-colors-fg-9-face ((t (:foreground ,light-green))))
   `(lui-irc-colors-fg-10-face ((t (:foreground ,cyan))))
   `(lui-irc-colors-fg-11-face ((t (:foreground ,light-cyan))))
   `(lui-irc-colors-fg-12-face ((t (:foreground ,light-blue))))
   `(lui-irc-colors-fg-13-face ((t (:foreground ,light-magenta))))
   `(lui-irc-colors-fg-14-face ((t (:foreground ,light-gray))))
   `(lui-irc-colors-fg-15-face ((t (:foreground ,gray))))

   `(lui-time-stamp-face ((t (:foreground ,light-green :weight bold))))
   `(lui-button-face ((t (:foreground ,gray :underline t))))
   `(lui-highlight-face ((t (:foreground ,white))))
   `(circe-fool-face ((t (:foreground ,light-gray))))
   `(circe-highlight-nick-face ((t (:foreground ,yellow :weight bold))))
   `(circe-prompt-face ((t (:foreground ,cyan :weight bold))))
   `(circe-server-face ((t (:foreground ,blue))))
   `(parinfer-pretty-parens:dim-paren-face
     ((t (:foreground ,light-gray))))

   `(git-gutter-fr:added ((t (:foreground ,green))))
   `(git-gutter-fr:deleted ((t (:foreground ,red))))
   `(git-gutter-fr:modified ((t (:foreground ,yellow))))
   `(git-gutter-fr:unchanged ((t (:foreground ,yellow))))

   `(neo-root-dir-face ((t (:foreground ,green))))
   `(neo-file-link-face ((t (:foreground ,foreground))))
   `(neo-dir-link-face ((t (:foreground ,blue))))
   `(neo-expand-btn-face ((t (:foreground ,blue))))
   `(neo-header-face ((t (:foreground ,foreground))))))

;;;###autoload
(when load-file-name
  (add-to-list 'custom-theme-load-path
               (file-name-as-directory
                (file-name-directory load-file-name))))

(provide-theme 'xresources)

;;; xresources-theme.el ends here
