Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757322Ab3DZWSh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 18:18:37 -0400
Received: from mail-we0-f169.google.com ([74.125.82.169]:50084 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756257Ab3DZWSf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 18:18:35 -0400
From: "Yann E. MORIN" <yann.morin.1998@free.fr>
To: linux-kbuild@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Sedat Dilek <sedat.dilek@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>, Michal Marek <mmarek@suse.cz>,
        "Yann E. MORIN" <yann.morin.1998@free.fr>,
        Sam Ravnborg <sam@ravnborg.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Greg KH <greg@kroah.com>
Subject: [PATCH 1/1] Revert "kconfig: fix randomising choice entries in presence of KCONFIG_ALLCONFIG"
Date: Sat, 27 Apr 2013 00:18:00 +0200
Message-Id: <23a5dfdad22a574d19d7cc19b391f9ce0d3c2f21.1367014328.git.yann.morin.1998@free.fr>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <cover.1367014328.git.yann.morin.1998@free.fr>
References: <cover.1367014328.git.yann.morin.1998@free.fr>
In-Reply-To: <cover.1367014328.git.yann.morin.1998@free.fr>
References: <cover.1367014328.git.yann.morin.1998@free.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Yann E. MORIN" <yann.morin.1998@free.fr>

This reverts commit 422c809f03f043d0950d8362214818e956a9daee.
It causes more harm than it solves issues.

Reported-by: Sedat Dilek <sedat.dilek@gmail.com>
Reported-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: "Yann E. MORIN" <yann.morin.1998@free.fr>
Tested-by: Sedat Dilek <sedat.dilek@gmail.com>
Cc: Sedat Dilek <sedat.dilek@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Michal Marek <mmarek@suse.cz>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Cc: Greg KH <greg@kroah.com>
---
 scripts/kconfig/confdata.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/scripts/kconfig/confdata.c b/scripts/kconfig/confdata.c
index fc45fc1..43eda40 100644
--- a/scripts/kconfig/confdata.c
+++ b/scripts/kconfig/confdata.c
@@ -288,6 +288,8 @@ load:
 	for_all_symbols(i, sym) {
 		sym->flags |= SYMBOL_CHANGED;
 		sym->flags &= ~(def_flags|SYMBOL_VALID);
+		if (sym_is_choice(sym))
+			sym->flags |= def_flags;
 		switch (sym->type) {
 		case S_INT:
 		case S_HEX:
@@ -377,13 +379,13 @@ setsym:
 			case mod:
 				if (cs->def[def].tri == yes) {
 					conf_warning("%s creates inconsistent choice state", sym->name);
+					cs->flags &= ~def_flags;
 				}
 				break;
 			case yes:
 				if (cs->def[def].tri != no)
 					conf_warning("override: %s changes choice state", sym->name);
 				cs->def[def].val = sym;
-				cs->flags |= def_flags;
 				break;
 			}
 			cs->def[def].tri = EXPR_OR(cs->def[def].tri, sym->def[def].tri);
@@ -789,8 +791,6 @@ int conf_write(const char *name)
 			sym_calc_value(sym);
 			if (!(sym->flags & SYMBOL_WRITE))
 				goto next;
-			if (sym_is_choice_value(sym) && !menu_is_visible(menu->parent))
-				goto next;
 			sym->flags &= ~SYMBOL_WRITE;
 
 			conf_write_symbol(out, sym, &kconfig_printer_cb, NULL);
@@ -1077,7 +1077,6 @@ static void randomize_choice_values(struct symbol *csym)
 		else {
 			sym->def[S_DEF_USER].tri = no;
 		}
-		sym->flags &= ~(SYMBOL_VALID);
 	}
 	csym->flags |= SYMBOL_DEF_USER;
 	/* clear VALID to get value calculated */
-- 
1.8.1.2

