Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932159Ab3DXWar (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Apr 2013 18:30:47 -0400
Received: from mail-wg0-f47.google.com ([74.125.82.47]:56032 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758559Ab3DXWaa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Apr 2013 18:30:30 -0400
From: "Yann E. MORIN" <yann.morin.1998@free.fr>
To: linux-kbuild@vger.kernel.org
Cc: Michal Marek <mmarek@suse.cz>, linux-kernel@vger.kernel.org,
        "Yann E. MORIN" <yann.morin.1998@free.fr>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Sam Ravnborg <sam@ravnborg.org>, Arnaud Lacombe <lacombar@gmail.com>
Subject: [PATCH 6/8] kconfig: fix randomising choice entries in presence of KCONFIG_ALLCONFIG
Date: Thu, 25 Apr 2013 00:29:53 +0200
Message-Id: <422c809f03f043d0950d8362214818e956a9daee.1366841993.git.yann.morin.1998@free.fr>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <cover.1366841993.git.yann.morin.1998@free.fr>
References: <cover.1366841993.git.yann.morin.1998@free.fr>
In-Reply-To: <cover.1366841993.git.yann.morin.1998@free.fr>
References: <cover.1366841993.git.yann.morin.1998@free.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Yann E. MORIN" <yann.morin.1998@free.fr>

Currently, randconfig does randomise choice entries, unless KCONFIG_ALLCONFIG
is specified.

For example, given those two files (Thomas' test-case):

    ---8<--- Config.test.in
    config OPTIONA
        bool "Option A"

    choice
        prompt "This is a choice"

    config CHOICE_OPTIONA
        bool "Choice Option A"

    config CHOICE_OPTIONB
        bool "Choice Option B"

    endchoice

    config OPTIONB
        bool "Option B"
    ---8<--- Config.test.in

    ---8<--- config.defaults
    CONFIG_OPTIONA=y
    ---8<--- config.defaults

And running:
    ./scripts/kconfig/conf --randconfig Config.test.in

does properly randomise the two choice symbols (and the two booleans).

However, running:
    KCONFIG_ALLCONFIG=config.defaults \
    ./scripts/kconfig/conf --randconfig Config.test.in

does *not* reandomise the two choice entries, and only CHOICE_OPTIONA
will ever be selected. (OPTIONA will always be set (expected), and
OPTIONB will be be properly randomised (expected).)

This patch defers setting that a choice has a value until a symbol for
that choice is indeed set, so that choices are properly randomised when
KCONFIG_ALLCONFIG is set, but not if a symbol for that choice is set.

Also, as a side-efect, this patch fixes the following case:

    ---8<---
    choice
    config OPTION_A
        bool "Option A"
    config OPTION_B
        bool "Option B"
    config OPTION_C
        bool "Option C"
    endchoice
    ---8<---

which could previously generate such .config files:

    ---8<---                            ---8<---
    CONFIG_OPTION_A=y                   CONFIG_OPTION_A=y
    CONFIG_OPTION_B=y                   # CONFIG_OPTION_B is not set
    # CONFIG_OPTION_C is not set        CONFIG_OPTION_C=y
    ---8<---                            ---8<---

Ie., the first entry in a choice is always set, plus zero or one of
the other options may be set.

This patch ensures that only one option may be set for a choice.

Reported-by: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Signed-off-by: "Yann E. MORIN" <yann.morin.1998@free.fr>
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Cc: Michal Marek <mmarek@suse.cz>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Arnaud Lacombe <lacombar@gmail.com>

---
Changes v2 -> v3
  - ensure only one symbol is set in a choice

Changes v1 -> v2:
  - further postpone setting that a choice has a value until
    one is indeed set
  - do not print symbols that are part of an invisible choice
---
 scripts/kconfig/confdata.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/scripts/kconfig/confdata.c b/scripts/kconfig/confdata.c
index 2e35d4b..8927480 100644
--- a/scripts/kconfig/confdata.c
+++ b/scripts/kconfig/confdata.c
@@ -288,8 +288,6 @@ load:
 	for_all_symbols(i, sym) {
 		sym->flags |= SYMBOL_CHANGED;
 		sym->flags &= ~(def_flags|SYMBOL_VALID);
-		if (sym_is_choice(sym))
-			sym->flags |= def_flags;
 		switch (sym->type) {
 		case S_INT:
 		case S_HEX:
@@ -379,13 +377,13 @@ setsym:
 			case mod:
 				if (cs->def[def].tri == yes) {
 					conf_warning("%s creates inconsistent choice state", sym->name);
-					cs->flags &= ~def_flags;
 				}
 				break;
 			case yes:
 				if (cs->def[def].tri != no)
 					conf_warning("override: %s changes choice state", sym->name);
 				cs->def[def].val = sym;
+				cs->flags |= def_flags;
 				break;
 			}
 			cs->def[def].tri = EXPR_OR(cs->def[def].tri, sym->def[def].tri);
@@ -791,6 +789,8 @@ int conf_write(const char *name)
 			sym_calc_value(sym);
 			if (!(sym->flags & SYMBOL_WRITE))
 				goto next;
+			if (sym_is_choice_value(sym) && !menu_is_visible(menu->parent))
+				goto next;
 			sym->flags &= ~SYMBOL_WRITE;
 
 			conf_write_symbol(out, sym, &kconfig_printer_cb, NULL);
@@ -1077,6 +1077,7 @@ static void randomize_choice_values(struct symbol *csym)
 		else {
 			sym->def[S_DEF_USER].tri = no;
 		}
+		sym->flags &= ~(SYMBOL_VALID);
 	}
 	csym->flags |= SYMBOL_DEF_USER;
 	/* clear VALID to get value calculated */
-- 
1.7.10.4

