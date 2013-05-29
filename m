Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935360Ab3E2W0G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 18:26:06 -0400
Received: from mail-wg0-f52.google.com ([74.125.82.52]:54560 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935300Ab3E2WZK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 18:25:10 -0400
From: "Yann E. MORIN" <yann.morin.1998@free.fr>
To: Michal Marek <mmarek@suse.cz>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dirk Gouders <dirk@gouders.net>,
        "Yann E. MORIN" <yann.morin.1998@free.fr>
Subject: [PATCH 3/3] kconfig/menu.c: fix multiple references to expressions in menu_add_prop()
Date: Thu, 30 May 2013 00:24:55 +0200
Message-Id: <e983b7b17ad1a978e954e6aaa62cf12bfc747883.1369866004.git.yann.morin.1998@free.fr>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <cover.1369866004.git.yann.morin.1998@free.fr>
References: <cover.1369866004.git.yann.morin.1998@free.fr>
In-Reply-To: <cover.1369866004.git.yann.morin.1998@free.fr>
References: <cover.1369866004.git.yann.morin.1998@free.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dirk Gouders <dirk@gouders.net>

menu_add_prop() applies upper menus' visibilities to actual prompts
by AND-ing the prompts visibilities with the upper menus ones.

This creates a further reference to the menu's visibilities and when
the expression reduction functions do their work, they may remove or
modify expressions that have multiple references, thus causing
unpredictable side-effects.

The following example Kconfig constructs a case where this causes
problems: a menu and a prompt which's visibilities depend on the same
symbol.  When invoking mconf with this Kconfig and pressing "Z" we
see a problem caused by a free'd expression still referenced by the
menu's visibility:

------------------------------------------------------------------------
mainmenu "Kconfig Testing Configuration"

config VISIBLE
	def_bool n

config Placeholder
	bool "Place holder"

menu "Invisible"
	visible if VISIBLE

config TEST_VAR
	bool "Test option" if VISIBLE

endmenu
------------------------------------------------------------------------

This patch fixes this problem by creating copies of the menu's
visibility expressions before AND-ing them with the prompt's one.

Signed-off-by: Dirk Gouders <dirk@gouders.net>
[yann.morin.1998@free.fr: move variable into its block-scope,
                          keep lines <80 chars, typo]
Tested-by: "Yann E. MORIN" <yann.morin.1998@free.fr>
Reviewed-by: "Yann E. MORIN" <yann.morin.1998@free.fr>
Signed-off-by: "Yann E. MORIN" <yann.morin.1998@free.fr>
---
 scripts/kconfig/menu.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/scripts/kconfig/menu.c b/scripts/kconfig/menu.c
index b5c7d90..fd3f018 100644
--- a/scripts/kconfig/menu.c
+++ b/scripts/kconfig/menu.c
@@ -146,11 +146,24 @@ struct property *menu_add_prop(enum prop_type type, char *prompt, struct expr *e
 			struct menu *menu = current_entry;
 
 			while ((menu = menu->parent) != NULL) {
+				struct expr *dup_expr;
+
 				if (!menu->visibility)
 					continue;
+				/*
+				 * Do not add a reference to the
+				 * menu's visibility expression but
+				 * use a copy of it.  Otherwise the
+				 * expression reduction functions
+				 * will modify expressions that have
+				 * multiple references which can
+				 * cause unwanted side effects.
+				 */
+				dup_expr = expr_copy(menu->visibility);
+
 				prop->visible.expr
 					= expr_alloc_and(prop->visible.expr,
-							 menu->visibility);
+							 dup_expr);
 			}
 		}
 
-- 
1.8.1.2

