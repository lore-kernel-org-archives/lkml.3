Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753414Ab3DOOO3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 10:14:29 -0400
Received: from mail-qe0-f50.google.com ([209.85.128.50]:54917 "EHLO
	mail-qe0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752650Ab3DOOO0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 10:14:26 -0400
From: Benjamin Poirier <bpoirier@suse.de>
To: Michal Marek <mmarek@suse.cz>
Cc: "Yann E. MORIN" <yann.morin.1998@free.fr>,
        Wang YanQing <udknight@gmail.com>,
        Dirk Gouders <gouders@et.bocholt.fh-gelsenkirchen.de>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] menuconfig: Add "breadcrumbs" navigation aid
Date: Mon, 15 Apr 2013 10:13:51 -0400
Message-Id: <1366035231-24370-2-git-send-email-bpoirier@suse.de>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1366035231-24370-1-git-send-email-bpoirier@suse.de>
References: <1366035231-24370-1-git-send-email-bpoirier@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Displays a trail of the menu entries used to get to the current menu.

Signed-off-by: Benjamin Poirier <bpoirier@suse.de>
---
 scripts/kconfig/list.h            |   27 ++++++++++++++
 scripts/kconfig/lxdialog/dialog.h |    7 ++++
 scripts/kconfig/lxdialog/util.c   |   48 ++++++++++++++++++++++++-
 scripts/kconfig/mconf.c           |   71 ++++++++++++++++++++++++++++++++++++-
 4 files changed, 151 insertions(+), 2 deletions(-)

diff --git a/scripts/kconfig/list.h b/scripts/kconfig/list.h
index b87206c..ea1d581 100644
--- a/scripts/kconfig/list.h
+++ b/scripts/kconfig/list.h
@@ -101,4 +101,31 @@ static inline void list_add_tail(struct list_head *_new, struct list_head *head)
 	__list_add(_new, head->prev, head);
 }
 
+/*
+ * Delete a list entry by making the prev/next entries
+ * point to each other.
+ *
+ * This is only for internal list manipulation where we know
+ * the prev/next entries already!
+ */
+static inline void __list_del(struct list_head *prev, struct list_head *next)
+{
+	next->prev = prev;
+	prev->next = next;
+}
+
+#define LIST_POISON1  ((void *) 0x00100100)
+#define LIST_POISON2  ((void *) 0x00200200)
+/**
+ * list_del - deletes entry from list.
+ * @entry: the element to delete from the list.
+ * Note: list_empty() on entry does not return true after this, the entry is
+ * in an undefined state.
+ */
+static inline void list_del(struct list_head *entry)
+{
+	__list_del(entry->prev, entry->next);
+	entry->next = LIST_POISON1;
+	entry->prev = LIST_POISON2;
+}
 #endif
diff --git a/scripts/kconfig/lxdialog/dialog.h b/scripts/kconfig/lxdialog/dialog.h
index 307022a..10993370 100644
--- a/scripts/kconfig/lxdialog/dialog.h
+++ b/scripts/kconfig/lxdialog/dialog.h
@@ -106,8 +106,14 @@ struct dialog_color {
 	int hl;		/* highlight this item */
 };
 
+struct subtitle_list {
+	struct subtitle_list *next;
+	const char *text;
+};
+
 struct dialog_info {
 	const char *backtitle;
+	struct subtitle_list *subtitles;
 	struct dialog_color screen;
 	struct dialog_color shadow;
 	struct dialog_color dialog;
@@ -196,6 +202,7 @@ int on_key_resize(void);
 
 int init_dialog(const char *backtitle);
 void set_dialog_backtitle(const char *backtitle);
+void set_dialog_subtitles(struct subtitle_list *subtitles);
 void end_dialog(int x, int y);
 void attr_clear(WINDOW * win, int height, int width, chtype attr);
 void dialog_clear(void);
diff --git a/scripts/kconfig/lxdialog/util.c b/scripts/kconfig/lxdialog/util.c
index 109d531..9a41d78 100644
--- a/scripts/kconfig/lxdialog/util.c
+++ b/scripts/kconfig/lxdialog/util.c
@@ -257,13 +257,54 @@ void dialog_clear(void)
 	attr_clear(stdscr, LINES, COLS, dlg.screen.atr);
 	/* Display background title if it exists ... - SLH */
 	if (dlg.backtitle != NULL) {
-		int i;
+		int i, len = 0;
+		struct subtitle_list *pos;
 
 		wattrset(stdscr, dlg.screen.atr);
 		mvwaddstr(stdscr, 0, 1, (char *)dlg.backtitle);
 		wmove(stdscr, 1, 1);
 		for (i = 1; i < COLS - 1; i++)
 			waddch(stdscr, ACS_HLINE);
+
+		for (pos = dlg.subtitles; pos != NULL; pos = pos->next) {
+			/* 3 is for the arrow and spaces */
+			len += strlen(pos->text) + 3;
+		}
+
+		if (len) {
+			int skip = 0;
+
+			wmove(stdscr, 1, 1);
+			if (len > COLS - 2) {
+				const char *ellipsis = "[...] ";
+				waddstr(stdscr, ellipsis);
+				skip = len - (COLS - 2 - strlen(ellipsis));
+			}
+
+			for (pos = dlg.subtitles; pos != NULL; pos =
+			     pos->next) {
+				if (skip == 0)
+					waddch(stdscr, ACS_RARROW);
+				else
+					skip--;
+
+				if (skip == 0)
+					waddch(stdscr, ' ');
+				else
+					skip--;
+
+				if (skip < strlen(pos->text)) {
+					waddstr(stdscr, pos->text + skip);
+					skip = 0;
+				} else
+					skip -= strlen(pos->text);
+
+				if (skip == 0)
+					waddch(stdscr, ' ');
+				else
+					skip--;
+			}
+		}
 	}
 	wnoutrefresh(stdscr);
 }
@@ -302,6 +343,11 @@ void set_dialog_backtitle(const char *backtitle)
 	dlg.backtitle = backtitle;
 }
 
+void set_dialog_subtitles(struct subtitle_list *subtitles)
+{
+	dlg.subtitles = subtitles;
+}
+
 /*
  * End using dialog functions.
  */
diff --git a/scripts/kconfig/mconf.c b/scripts/kconfig/mconf.c
index c5418d6..387dc8d 100644
--- a/scripts/kconfig/mconf.c
+++ b/scripts/kconfig/mconf.c
@@ -311,6 +311,50 @@ static void set_config_filename(const char *config_filename)
 		filename[sizeof(filename)-1] = '\0';
 }
 
+struct subtitle_part {
+	struct list_head entries;
+	const char *text;
+};
+static LIST_HEAD(trail);
+
+static struct subtitle_list *subtitles;
+static void set_subtitle(void)
+{
+	struct subtitle_part *sp;
+	struct subtitle_list *pos, *tmp;
+
+	for (pos = subtitles; pos != NULL; pos = tmp) {
+		tmp = pos->next;
+		free(pos);
+	}
+
+	subtitles = NULL;
+	list_for_each_entry(sp, &trail, entries) {
+		if (sp->text) {
+			if (pos) {
+				pos->next = xcalloc(sizeof(*pos), 1);
+				pos = pos->next;
+			} else {
+				subtitles = pos = xcalloc(sizeof(*pos), 1);
+			}
+			pos->text = sp->text;
+		}
+	}
+
+	set_dialog_subtitles(subtitles);
+}
+
+static void reset_subtitle(void)
+{
+	struct subtitle_list *pos, *tmp;
+
+	for (pos = subtitles; pos != NULL; pos = tmp) {
+		tmp = pos->next;
+		free(pos);
+	}
+	subtitles = NULL;
+	set_dialog_subtitles(subtitles);
+}
 
 struct search_data {
 	struct list_head *head;
@@ -353,6 +397,8 @@ static void search_conf(void)
 	char *dialog_input;
 	int dres, vscroll = 0, hscroll = 0;
 	bool again;
+	struct gstr sttext;
+	struct subtitle_part stpart;
 
 	title = str_new();
 	str_printf( &title, _("Enter %s (sub)string to search for "
@@ -379,6 +425,11 @@ again:
 	if (strncasecmp(dialog_input_result, CONFIG_, strlen(CONFIG_)) == 0)
 		dialog_input += strlen(CONFIG_);
 
+	sttext = str_new();
+	str_printf(&sttext, "Search (%s)", dialog_input_result);
+	stpart.text = str_get(&sttext);
+	list_add_tail(&stpart.entries, &trail);
+
 	sym_arr = sym_re_search(dialog_input);
 	do {
 		LIST_HEAD(head);
@@ -392,6 +443,7 @@ again:
 		struct jump_key *pos, *tmp;
 
 		res = get_relations_str(sym_arr, &head);
+		set_subtitle();
 		dres = show_textbox_ext(_("Search Results"), (char *)
 					str_get(&res), 0, 0, keys, &vscroll,
 					&hscroll, &update_text, (void *)
@@ -408,6 +460,8 @@ again:
 	} while (again);
 	free(sym_arr);
 	str_free(&title);
+	list_del(trail.prev);
+	str_free(&sttext);
 }
 
 static void build_conf(struct menu *menu)
@@ -592,16 +646,24 @@ static void conf(struct menu *menu, struct menu *active_menu)
 {
 	struct menu *submenu;
 	const char *prompt = menu_get_prompt(menu);
+	struct subtitle_part stpart;
 	struct symbol *sym;
 	int res;
 	int s_scroll = 0;
 
+	if (menu != &rootmenu)
+		stpart.text = menu_get_prompt(menu);
+	else
+		stpart.text = NULL;
+	list_add_tail(&stpart.entries, &trail);
+
 	while (1) {
 		item_reset();
 		current_menu = menu;
 		build_conf(menu);
 		if (!child_count)
 			break;
+		set_subtitle();
 		dialog_clear();
 		res = dialog_menu(prompt ? _(prompt) : _("Main Menu"),
 				  _(menu_instructions),
@@ -643,13 +705,17 @@ static void conf(struct menu *menu, struct menu *active_menu)
 		case 2:
 			if (sym)
 				show_help(submenu);
-			else
+			else {
+				reset_subtitle();
 				show_helptext(_("README"), _(mconf_readme));
+			}
 			break;
 		case 3:
+			reset_subtitle();
 			conf_save();
 			break;
 		case 4:
+			reset_subtitle();
 			conf_load();
 			break;
 		case 5:
@@ -682,6 +748,8 @@ static void conf(struct menu *menu, struct menu *active_menu)
 			break;
 		}
 	}
+
+	list_del(trail.prev);
 }
 
 static int show_textbox_ext(const char *title, char *text, int r, int c, int
@@ -884,6 +952,7 @@ static int handle_exit(void)
 	int res;
 
 	save_and_exit = 1;
+	reset_subtitle();
 	dialog_clear();
 	if (conf_get_changed())
 		res = dialog_yesno(NULL,
-- 
1.7.10.4

