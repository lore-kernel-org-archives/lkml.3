Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753293Ab3FXSMX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 14:12:23 -0400
Received: from mail-wg0-f54.google.com ([74.125.82.54]:43084 "EHLO
	mail-wg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753259Ab3FXSMV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 14:12:21 -0400
From: "Yann E. MORIN" <yann.morin.1998@free.fr>
To: linux-kbuild@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Michal Marek <mmarek@suse.cz>,
        Dirk Gouders <dirk@gouders.net>,
        "Yann E. MORIN" <yann.morin.1998@free.fr>
Subject: [PATCH 07/15] mconf/nconf: mark empty menus/menuconfigs different from non-empty ones
Date: Mon, 24 Jun 2013 20:11:51 +0200
Message-Id: <1278ebdbc3167883f32095491990fbdc7cdf8b5e.1372097219.git.yann.morin.1998@free.fr>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <cover.1372097219.git.yann.morin.1998@free.fr>
References: <cover.1372097219.git.yann.morin.1998@free.fr>
In-Reply-To: <cover.1372097219.git.yann.morin.1998@free.fr>
References: <cover.1372097219.git.yann.morin.1998@free.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dirk Gouders <dirk@gouders.net>

Submenus are sometimes empty and it would be nice if there is
something that notifies us that we should not expect any content
_before_ we enter a submenu.

A new function menu_is_empty() was introduced and empty menus and
menuconfigs are now marked by "----" as opposed to non-empty ones that
are marked by "--->".

This scheme was suggested by "Yann E. MORIN" <yann.morin.1998@free.fr>.

Signed-off-by: Dirk Gouders <dirk@gouders.net>
Tested-by: "Yann E. MORIN" <yann.morin.1998@free.fr>
Reviewed-by: "Yann E. MORIN" <yann.morin.1998@free.fr>
Signed-off-by: "Yann E. MORIN" <yann.morin.1998@free.fr>
---
 scripts/kconfig/lkc_proto.h |  1 +
 scripts/kconfig/mconf.c     | 11 ++++++-----
 scripts/kconfig/menu.c      | 16 ++++++++++++++++
 scripts/kconfig/nconf.c     | 16 ++++++++--------
 4 files changed, 31 insertions(+), 13 deletions(-)

diff --git a/scripts/kconfig/lkc_proto.h b/scripts/kconfig/lkc_proto.h
index ef1a738..ecdb965 100644
--- a/scripts/kconfig/lkc_proto.h
+++ b/scripts/kconfig/lkc_proto.h
@@ -14,6 +14,7 @@ P(conf_set_message_callback, void,(void (*fn)(const char *fmt, va_list ap)));
 /* menu.c */
 P(rootmenu,struct menu,);
 
+P(menu_is_empty, bool, (struct menu *menu));
 P(menu_is_visible, bool, (struct menu *menu));
 P(menu_has_prompt, bool, (struct menu *menu));
 P(menu_get_prompt,const char *,(struct menu *menu));
diff --git a/scripts/kconfig/mconf.c b/scripts/kconfig/mconf.c
index cb8cf4a..6ee4aae 100644
--- a/scripts/kconfig/mconf.c
+++ b/scripts/kconfig/mconf.c
@@ -48,7 +48,7 @@ static const char mconf_readme[] = N_(
 "----------\n"
 "o  Use the Up/Down arrow keys (cursor keys) to highlight the item\n"
 "   you wish to change or submenu wish to select and press <Enter>.\n"
-"   Submenus are designated by \"--->\".\n"
+"   Submenus are designated by \"--->\", empty ones by \"----\".\n"
 "\n"
 "   Shortcut: Press the option's highlighted letter (hotkey).\n"
 "             Pressing a hotkey more than once will sequence\n"
@@ -176,7 +176,7 @@ static const char mconf_readme[] = N_(
 "\n"),
 menu_instructions[] = N_(
 	"Arrow keys navigate the menu.  "
-	"<Enter> selects submenus --->.  "
+	"<Enter> selects submenus ---> (or empty submenus ----).  "
 	"Highlighted letters are hotkeys.  "
 	"Pressing <Y> includes, <N> excludes, <M> modularizes features.  "
 	"Press <Esc><Esc> to exit, <?> for Help, </> for Search.  "
@@ -498,8 +498,9 @@ static void build_conf(struct menu *menu)
 						  menu->data ? "-->" : "++>",
 						  indent + 1, ' ', prompt);
 				} else
-					item_make("   %*c%s  --->", indent + 1, ' ', prompt);
-
+					item_make("   %*c%s  %s",
+						  indent + 1, ' ', prompt,
+						  menu_is_empty(menu) ? "----" : "--->");
 				item_set_tag('m');
 				item_set_data(menu);
 				if (single_menu_mode && menu->data)
@@ -630,7 +631,7 @@ static void build_conf(struct menu *menu)
 			  (sym_has_value(sym) || !sym_is_changable(sym)) ?
 			  "" : _(" (NEW)"));
 		if (menu->prompt->type == P_MENU) {
-			item_add_str("  --->");
+			item_add_str("  %s", menu_is_empty(menu) ? "----" : "--->");
 			return;
 		}
 	}
diff --git a/scripts/kconfig/menu.c b/scripts/kconfig/menu.c
index b5c7d90..6d11c8f 100644
--- a/scripts/kconfig/menu.c
+++ b/scripts/kconfig/menu.c
@@ -430,6 +430,22 @@ bool menu_has_prompt(struct menu *menu)
 	return true;
 }
 
+/*
+ * Determine if a menu is empty.
+ * A menu is considered empty if it contains no or only
+ * invisible entries.
+ */
+bool menu_is_empty(struct menu *menu)
+{
+	struct menu *child;
+
+	for (child = menu->list; child; child = child->next) {
+		if (menu_is_visible(child))
+			return(false);
+	}
+	return(true);
+}
+
 bool menu_is_visible(struct menu *menu)
 {
 	struct menu *child;
diff --git a/scripts/kconfig/nconf.c b/scripts/kconfig/nconf.c
index aac85d3..0183153 100644
--- a/scripts/kconfig/nconf.c
+++ b/scripts/kconfig/nconf.c
@@ -45,8 +45,8 @@ static const char nconf_global_help[] = N_(
 "<n> to remove it.  You may press the <Space> key to cycle through the\n"
 "available options.\n"
 "\n"
-"A trailing \"--->\" designates a submenu.\n"
-"\n"
+"A trailing \"--->\" designates a submenu, a trailing \"----\" an\n"
+"empty submenu.\n"
 "\n"
 "Menu navigation keys\n"
 "----------------------------------------------------------------------\n"
@@ -131,7 +131,7 @@ static const char nconf_global_help[] = N_(
 "\n"),
 menu_no_f_instructions[] = N_(
 "Legend:  [*] built-in  [ ] excluded  <M> module  < > module capable.\n"
-"Submenus are designated by a trailing \"--->\".\n"
+"Submenus are designated by a trailing \"--->\", empty ones by \"----\".\n"
 "\n"
 "Use the following keys to navigate the menus:\n"
 "Move up or down with <Up> and <Down>.\n"
@@ -148,7 +148,7 @@ menu_no_f_instructions[] = N_(
 "For help related to the current menu entry press <?> or <h>.\n"),
 menu_instructions[] = N_(
 "Legend:  [*] built-in  [ ] excluded  <M> module  < > module capable.\n"
-"Submenus are designated by a trailing \"--->\".\n"
+"Submenus are designated by a trailing \"--->\", empty ones by \"----\".\n"
 "\n"
 "Use the following keys to navigate the menus:\n"
 "Move up or down with <Up> or <Down>.\n"
@@ -760,9 +760,9 @@ static void build_conf(struct menu *menu)
 						indent + 1, ' ', prompt);
 				} else
 					item_make(menu, 'm',
-						"   %*c%s  --->",
-						indent + 1,
-						' ', prompt);
+						  "   %*c%s  %s",
+						  indent + 1, ' ', prompt,
+						  menu_is_empty(menu) ? "----" : "--->");
 
 				if (single_menu_mode && menu->data)
 					goto conf_childs;
@@ -904,7 +904,7 @@ static void build_conf(struct menu *menu)
 				(sym_has_value(sym) || !sym_is_changable(sym)) ?
 				"" : _(" (NEW)"));
 		if (menu->prompt && menu->prompt->type == P_MENU) {
-			item_add_str("  --->");
+			item_add_str("  %s", menu_is_empty(menu) ? "----" : "--->");
 			return;
 		}
 	}
-- 
1.8.1.2

