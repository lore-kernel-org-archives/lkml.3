Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933714Ab3FRWp2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 18:45:28 -0400
Received: from mail-wi0-f182.google.com ([209.85.212.182]:42073 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933236Ab3FRWpZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 18:45:25 -0400
From: "Yann E. MORIN" <yann.morin.1998@free.fr>
To: linux-kbuild@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Michal Marek <mmarek@suse.cz>,
        Dirk Gouders <dirk@gouders.net>,
        "Yann E. MORIN" <yann.morin.1998@free.fr>
Subject: [PATCH 04/14] kconfig/lxdialog: handle newline characters in print_autowrap()
Date: Wed, 19 Jun 2013 00:45:00 +0200
Message-Id: <1376391621654cc369c5e8b60497f7c184f0ed47.1371595499.git.yann.morin.1998@free.fr>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <cover.1371595499.git.yann.morin.1998@free.fr>
References: <cover.1371595499.git.yann.morin.1998@free.fr>
In-Reply-To: <cover.1371595499.git.yann.morin.1998@free.fr>
References: <cover.1371595499.git.yann.morin.1998@free.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dirk Gouders <dirk@gouders.net>

When exiting menuconfig with unsaved changes, a dialog like
the following is shown:

        Do you wish to save your new configuration ? <ESC><ESC>
        to continue.

The author of the dialog text specified a newline after the '?',
and probably expected it to be processed, so let print_autowrap()
handle newlines propperly.

Also, reword that dialog's second phrase with a real sentence.

Signed-off-by: Dirk Gouders <dirk@gouders.net>
Tested-by: "Yann E. MORIN" <yann.morin.1998@free.fr>
Reviewed-by: "Yann E. MORIN" <yann.morin.1998@free.fr>
[yann.morin.1998@free.fr: very slightly tweak the commit message]
Signed-off-by: Yann E. MORIN <yann.morin.1998@free.fr>
---
 scripts/kconfig/lxdialog/util.c | 31 +++++++++++++++++--------------
 scripts/kconfig/mconf.c         |  4 ++--
 2 files changed, 19 insertions(+), 16 deletions(-)

diff --git a/scripts/kconfig/lxdialog/util.c b/scripts/kconfig/lxdialog/util.c
index 78fe4e9..0fa567e 100644
--- a/scripts/kconfig/lxdialog/util.c
+++ b/scripts/kconfig/lxdialog/util.c
@@ -371,27 +371,19 @@ void print_title(WINDOW *dialog, const char *title, int width)
 /*
  * Print a string of text in a window, automatically wrap around to the
  * next line if the string is too long to fit on one line. Newline
- * characters '\n' are replaced by spaces.  We start on a new line
+ * characters '\n' are propperly processed.  We start on a new line
  * if there is no room for at least 4 nonblanks following a double-space.
  */
 void print_autowrap(WINDOW * win, const char *prompt, int width, int y, int x)
 {
 	int newl, cur_x, cur_y;
-	int i, prompt_len, room, wlen;
-	char tempstr[MAX_LEN + 1], *word, *sp, *sp2;
+	int prompt_len, room, wlen;
+	char tempstr[MAX_LEN + 1], *word, *sp, *sp2, *newline_separator = 0;
 
 	strcpy(tempstr, prompt);
 
 	prompt_len = strlen(tempstr);
 
-	/*
-	 * Remove newlines
-	 */
-	for (i = 0; i < prompt_len; i++) {
-		if (tempstr[i] == '\n')
-			tempstr[i] = ' ';
-	}
-
 	if (prompt_len <= width - x * 2) {	/* If prompt is short */
 		wmove(win, y, (width - prompt_len) / 2);
 		waddstr(win, tempstr);
@@ -401,7 +393,10 @@ void print_autowrap(WINDOW * win, const char *prompt, int width, int y, int x)
 		newl = 1;
 		word = tempstr;
 		while (word && *word) {
-			sp = strchr(word, ' ');
+			sp = strpbrk(word, "\n ");
+			if (sp && *sp == '\n')
+				newline_separator = sp;
+
 			if (sp)
 				*sp++ = 0;
 
@@ -413,7 +408,7 @@ void print_autowrap(WINDOW * win, const char *prompt, int width, int y, int x)
 			if (wlen > room ||
 			    (newl && wlen < 4 && sp
 			     && wlen + 1 + strlen(sp) > room
-			     && (!(sp2 = strchr(sp, ' '))
+			     && (!(sp2 = strpbrk(sp, "\n "))
 				 || wlen + 1 + (sp2 - sp) > room))) {
 				cur_y++;
 				cur_x = x;
@@ -421,7 +416,15 @@ void print_autowrap(WINDOW * win, const char *prompt, int width, int y, int x)
 			wmove(win, cur_y, cur_x);
 			waddstr(win, word);
 			getyx(win, cur_y, cur_x);
-			cur_x++;
+
+			/* Move to the next line if the word separator was a newline */
+			if (newline_separator) {
+				cur_y++;
+				cur_x = x;
+				newline_separator = 0;
+			} else
+				cur_x++;
+
 			if (sp && *sp == ' ') {
 				cur_x++;	/* double space */
 				while (*++sp == ' ') ;
diff --git a/scripts/kconfig/mconf.c b/scripts/kconfig/mconf.c
index 2396c5b..cb8cf4a 100644
--- a/scripts/kconfig/mconf.c
+++ b/scripts/kconfig/mconf.c
@@ -958,8 +958,8 @@ static int handle_exit(void)
 	dialog_clear();
 	if (conf_get_changed())
 		res = dialog_yesno(NULL,
-				   _("Do you wish to save your new configuration ?\n"
-				     "<ESC><ESC> to continue."),
+				   _("Do you wish to save your new configuration?\n"
+				     "(Press <ESC><ESC> to continue kernel configuration.)"),
 				   6, 60);
 	else
 		res = -1;
-- 
1.8.1.2

