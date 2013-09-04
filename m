Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762427Ab3IDK7a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 06:59:30 -0400
Received: from mail-wi0-f181.google.com ([209.85.212.181]:57951 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762398Ab3IDK71 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 06:59:27 -0400
From: "Yann E. MORIN" <yann.morin.1998@free.fr>
To: linux-kbuild@vger.kernel.org
Cc: Michal Marek <mmarek@suse.cz>, linux-kernel@vger.kernel.org,
        Sam Ravnborg <sam@ravnborg.org>,
        "Yann E. MORIN" <yann.morin.1998@free.fr>
Subject: [PATCH 1/3] kconfig: do not special-case 'MODULES' symbol
Date: Wed,  4 Sep 2013 12:59:15 +0200
Message-Id: <b1a4fe311c048e595ecaefc0286d61baa6ff2d7f.1378292314.git.yann.morin.1998@free.fr>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <cover.1378292314.git.yann.morin.1998@free.fr>
References: <cover.1378292314.git.yann.morin.1998@free.fr>
In-Reply-To: <cover.1378292314.git.yann.morin.1998@free.fr>
References: <cover.1378292314.git.yann.morin.1998@free.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Yann E. MORIN" <yann.morin.1998@free.fr>

Currently, the 'MODULES' symbol is hard-coded to be the default symbol
that enables/disables tristates, if no other symbol was declared with
'option modules'.

While this used to be needed for the Linux kernel, we now have an
explicit 'option modules' attached to the 'MODULES' symbol (since
cset 11097a036), so we no longer need to special-case it in the
kconfig code.

Furthermore, kconfig is extensively used out of the Linux kernel, and
other projects may have another meaning for a symbol named 'MODULES'.

This patch changes the way we enable/disable tristates: if a symbol was
found with 'option modules' attached to it, then that symbol controls
enabling tristates. Otherwise, tristates are disabled, even if a symbol
named 'MODULES' exists.

Signed-off-by: "Yann E. MORIN" <yann.morin.1998@free.fr>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Michal Marek <mmarek@suse.cz>
---
 scripts/kconfig/menu.c  |  5 +----
 scripts/kconfig/zconf.y | 11 ++---------
 2 files changed, 3 insertions(+), 13 deletions(-)

diff --git a/scripts/kconfig/menu.c b/scripts/kconfig/menu.c
index 7e233a6..3a9c674 100644
--- a/scripts/kconfig/menu.c
+++ b/scripts/kconfig/menu.c
@@ -197,12 +197,9 @@ void menu_add_symbol(enum prop_type type, struct symbol *sym, struct expr *dep)
 
 void menu_add_option(int token, char *arg)
 {
-	struct property *prop;
-
 	switch (token) {
 	case T_OPT_MODULES:
-		prop = prop_alloc(P_DEFAULT, modules_sym);
-		prop->expr = expr_alloc_symbol(current_entry->sym);
+		modules_sym = current_entry->sym;
 		break;
 	case T_OPT_DEFCONFIG_LIST:
 		if (!sym_defconfig_list)
diff --git a/scripts/kconfig/zconf.y b/scripts/kconfig/zconf.y
index 864da07..0653886 100644
--- a/scripts/kconfig/zconf.y
+++ b/scripts/kconfig/zconf.y
@@ -493,9 +493,6 @@ void conf_parse(const char *name)
 
 	sym_init();
 	_menu_init();
-	modules_sym = sym_lookup(NULL, 0);
-	modules_sym->type = S_BOOLEAN;
-	modules_sym->flags |= SYMBOL_AUTO;
 	rootmenu.prompt = menu_add_prompt(P_MENU, "Linux Kernel Configuration", NULL);
 
 	if (getenv("ZCONF_DEBUG"))
@@ -503,12 +500,8 @@ void conf_parse(const char *name)
 	zconfparse();
 	if (zconfnerrs)
 		exit(1);
-	if (!modules_sym->prop) {
-		struct property *prop;
-
-		prop = prop_alloc(P_DEFAULT, modules_sym);
-		prop->expr = expr_alloc_symbol(sym_lookup("MODULES", 0));
-	}
+	if (!modules_sym)
+		modules_sym = sym_find( "n" );
 
 	rootmenu.prompt->text = _(rootmenu.prompt->text);
 	rootmenu.prompt->text = sym_expand_string_value(rootmenu.prompt->text);
-- 
1.8.1.2

