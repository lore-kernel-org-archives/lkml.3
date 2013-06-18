Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933874Ab3FRWpw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 18:45:52 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:42962 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933482Ab3FRWpl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 18:45:41 -0400
From: "Yann E. MORIN" <yann.morin.1998@free.fr>
To: linux-kbuild@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Michal Marek <mmarek@suse.cz>,
        "Yann E. MORIN" <yann.morin.1998@free.fr>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Sam Ravnborg <sam@ravnborg.org>, Sedat Dilek <sedat.dilek@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>, Stephen Rothwell <sfr@canb.auug.org.au>
Subject: [PATCH 14/14] kconfig: fix randomising choice entries in presence of KCONFIG_ALLCONFIG
Date: Wed, 19 Jun 2013 00:45:10 +0200
Message-Id: <b4e0ac8385fecde0363a2499323f81b4a91e8430.1371595499.git.yann.morin.1998@free.fr>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <cover.1371595499.git.yann.morin.1998@free.fr>
References: <cover.1371595499.git.yann.morin.1998@free.fr>
In-Reply-To: <cover.1371595499.git.yann.morin.1998@free.fr>
References: <cover.1371595499.git.yann.morin.1998@free.fr>
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

Reported-by: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Signed-off-by: "Yann E. MORIN" <yann.morin.1998@free.fr>
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Cc: Michal Marek <mmarek@suse.cz>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Sedat Dilek <sedat.dilek@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>

---
Changes v3 -> v4
  - fix previous issue where some choices would not be set, which would
    cause silentoldconfig to ask for them and was then breaking this
    workflow (as reported by Arnd and Sedat):
        KCONFIG_ALLCONFIG=foo.defconfig make randconfig
        make silentoldconfig </dev/nullo
    which I have tested (3h28min!) with:
        touch defconfig
        for(( i=0; i<10000; i++ )); do
            KCONFIG_ALLCONFIG=$(pwd)/defconfig make randconfig >/dev/null 2>&1
            make silentoldconfig </dev/null >/dev/null 2>&1 || break
        done
    which did not break at all.
  - change done in v3 (below) is already fixed by a previous patch

Changes v2 -> v3
  - ensure only one symbol is set in a choice

Changes v1 -> v2:
  - further postpone setting that a choice has a value until
    one is indeed set
  - do not print symbols that are part of an invisible choice
---
 scripts/kconfig/confdata.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/scripts/kconfig/confdata.c b/scripts/kconfig/confdata.c
index c55c227..3e39208 100644
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
-- 
1.8.1.2

