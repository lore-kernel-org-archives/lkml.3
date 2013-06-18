Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933842Ab3FRWpk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 18:45:40 -0400
Received: from mail-wi0-f171.google.com ([209.85.212.171]:38584 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933482Ab3FRWp2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 18:45:28 -0400
From: "Yann E. MORIN" <yann.morin.1998@free.fr>
To: linux-kbuild@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Michal Marek <mmarek@suse.cz>,
        Dirk Gouders <dirk@gouders.net>,
        "Yann E. MORIN" <yann.morin.1998@free.fr>
Subject: [PATCH 06/14] nconf: use function calls instead of ncurses' variables LINES and COLS
Date: Wed, 19 Jun 2013 00:45:02 +0200
Message-Id: <e0b42605e685a0833303e1d4dde277c99d9e17b5.1371595499.git.yann.morin.1998@free.fr>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <cover.1371595499.git.yann.morin.1998@free.fr>
References: <cover.1371595499.git.yann.morin.1998@free.fr>
In-Reply-To: <cover.1371595499.git.yann.morin.1998@free.fr>
References: <cover.1371595499.git.yann.morin.1998@free.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dirk Gouders <dirk@gouders.net>

According to the documentation [1], LINES and COLS are initialized by
initscr(); it does not say anything about the behavior when windows are
resized.

Do not rely on the current implementation of ncurses that updates
these variables on resize, but use the propper function calls or macros
to get window dimensions.

The use of the variables in main() was OK, but for the sake of
consistency it was modified to use the macro getmaxyx().

[1] ncurses(3X)

Signed-off-by: Dirk Gouders <dirk@gouders.net>
Reviewed-by: "Yann E. MORIN" <yann.morin.1998@free.fr>
[yann.morin.1998@free.fr: declare 'lines' and 'columns' on a single line]
Signed-off-by: Yann E. MORIN <yann.morin.1998@free.fr>
---
 scripts/kconfig/nconf.c     | 21 ++++++++++++++-------
 scripts/kconfig/nconf.gui.c | 20 +++++++++++---------
 2 files changed, 25 insertions(+), 16 deletions(-)

diff --git a/scripts/kconfig/nconf.c b/scripts/kconfig/nconf.c
index dbf31ed..aac85d3 100644
--- a/scripts/kconfig/nconf.c
+++ b/scripts/kconfig/nconf.c
@@ -365,15 +365,16 @@ static void print_function_line(void)
 	int i;
 	int offset = 1;
 	const int skip = 1;
+	int lines = getmaxy(stdscr);
 
 	for (i = 0; i < function_keys_num; i++) {
 		(void) wattrset(main_window, attributes[FUNCTION_HIGHLIGHT]);
-		mvwprintw(main_window, LINES-3, offset,
+		mvwprintw(main_window, lines-3, offset,
 				"%s",
 				function_keys[i].key_str);
 		(void) wattrset(main_window, attributes[FUNCTION_TEXT]);
 		offset += strlen(function_keys[i].key_str);
-		mvwprintw(main_window, LINES-3,
+		mvwprintw(main_window, lines-3,
 				offset, "%s",
 				function_keys[i].func);
 		offset += strlen(function_keys[i].func) + skip;
@@ -954,7 +955,7 @@ static void show_menu(const char *prompt, const char *instructions,
 
 	clear();
 	(void) wattrset(main_window, attributes[NORMAL]);
-	print_in_middle(stdscr, 1, 0, COLS,
+	print_in_middle(stdscr, 1, 0, getmaxx(stdscr),
 			menu_backtitle,
 			attributes[MAIN_HEADING]);
 
@@ -1455,14 +1456,18 @@ static void conf_save(void)
 
 void setup_windows(void)
 {
+	int lines, columns;
+
+	getmaxyx(stdscr, lines, columns);
+
 	if (main_window != NULL)
 		delwin(main_window);
 
 	/* set up the menu and menu window */
-	main_window = newwin(LINES-2, COLS-2, 2, 1);
+	main_window = newwin(lines-2, columns-2, 2, 1);
 	keypad(main_window, TRUE);
-	mwin_max_lines = LINES-7;
-	mwin_max_cols = COLS-6;
+	mwin_max_lines = lines-7;
+	mwin_max_cols = columns-6;
 
 	/* panels order is from bottom to top */
 	new_panel(main_window);
@@ -1470,6 +1475,7 @@ void setup_windows(void)
 
 int main(int ac, char **av)
 {
+	int lines, columns;
 	char *mode;
 
 	setlocale(LC_ALL, "");
@@ -1495,7 +1501,8 @@ int main(int ac, char **av)
 	keypad(stdscr, TRUE);
 	curs_set(0);
 
-	if (COLS < 75 || LINES < 20) {
+	getmaxyx(stdscr, lines, columns);
+	if (columns < 75 || lines < 20) {
 		endwin();
 		printf("Your terminal should have at "
 			"least 20 lines and 75 columns\n");
diff --git a/scripts/kconfig/nconf.gui.c b/scripts/kconfig/nconf.gui.c
index 9f8c44e..8275f0e5 100644
--- a/scripts/kconfig/nconf.gui.c
+++ b/scripts/kconfig/nconf.gui.c
@@ -276,8 +276,8 @@ int btn_dialog(WINDOW *main_window, const char *msg, int btn_num, ...)
 
 	total_width = max(msg_width, btns_width);
 	/* place dialog in middle of screen */
-	y = (LINES-(msg_lines+4))/2;
-	x = (COLS-(total_width+4))/2;
+	y = (getmaxy(stdscr)-(msg_lines+4))/2;
+	x = (getmaxx(stdscr)-(total_width+4))/2;
 
 
 	/* create the windows */
@@ -387,8 +387,8 @@ int dialog_inputbox(WINDOW *main_window,
 		prompt_width = max(prompt_width, strlen(title));
 
 	/* place dialog in middle of screen */
-	y = (LINES-(prompt_lines+4))/2;
-	x = (COLS-(prompt_width+4))/2;
+	y = (getmaxy(stdscr)-(prompt_lines+4))/2;
+	x = (getmaxx(stdscr)-(prompt_width+4))/2;
 
 	strncpy(result, init, *result_len);
 
@@ -545,7 +545,7 @@ void show_scroll_win(WINDOW *main_window,
 {
 	int res;
 	int total_lines = get_line_no(text);
-	int x, y;
+	int x, y, lines, columns;
 	int start_x = 0, start_y = 0;
 	int text_lines = 0, text_cols = 0;
 	int total_cols = 0;
@@ -556,6 +556,8 @@ void show_scroll_win(WINDOW *main_window,
 	WINDOW *pad;
 	PANEL *panel;
 
+	getmaxyx(stdscr, lines, columns);
+
 	/* find the widest line of msg: */
 	total_lines = get_line_no(text);
 	for (i = 0; i < total_lines; i++) {
@@ -569,14 +571,14 @@ void show_scroll_win(WINDOW *main_window,
 	(void) wattrset(pad, attributes[SCROLLWIN_TEXT]);
 	fill_window(pad, text);
 
-	win_lines = min(total_lines+4, LINES-2);
-	win_cols = min(total_cols+2, COLS-2);
+	win_lines = min(total_lines+4, lines-2);
+	win_cols = min(total_cols+2, columns-2);
 	text_lines = max(win_lines-4, 0);
 	text_cols = max(win_cols-2, 0);
 
 	/* place window in middle of screen */
-	y = (LINES-win_lines)/2;
-	x = (COLS-win_cols)/2;
+	y = (lines-win_lines)/2;
+	x = (columns-win_cols)/2;
 
 	win = newwin(win_lines, win_cols, y, x);
 	keypad(win, TRUE);
-- 
1.8.1.2

