Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753408Ab3FXSMh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 14:12:37 -0400
Received: from mail-we0-f172.google.com ([74.125.82.172]:50434 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752859Ab3FXSMd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 14:12:33 -0400
From: "Yann E. MORIN" <yann.morin.1998@free.fr>
To: linux-kbuild@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Michal Marek <mmarek@suse.cz>,
        "Yann E. MORIN" <yann.morin.1998@free.fr>
Subject: [PATCH 14/15] kconfig: loop as long as we changed some symbols in randconfig
Date: Mon, 24 Jun 2013 20:11:58 +0200
Message-Id: <3b9a19e08960e5cdad5253998637653e592a3c29.1372097219.git.yann.morin.1998@free.fr>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <cover.1372097219.git.yann.morin.1998@free.fr>
References: <cover.1372097219.git.yann.morin.1998@free.fr>
In-Reply-To: <cover.1372097219.git.yann.morin.1998@free.fr>
References: <cover.1372097219.git.yann.morin.1998@free.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Yann E. MORIN" <yann.morin.1998@free.fr>

Because of choice-in-a-choice constructs, it can happen that not all
symbols are assigned a value during randconfig, leading in rare cases
to this situation:

    ---8<--- choice-in-choice.in
    choice
        bool "A/B/C"
    config A
        bool "A"

    config B
        bool "B"
    if B
    choice
        bool "E/F"
    config E
        bool "E"
    config F
        bool "F"
    endchoice
    endif # B

    config C
        bool "C"
    endchoice
    ---8<---

    $ ./scripts/kconfig/conf --randconfig choice-in-choice.in
    [--SNIP--]
    $ ./scripts/kconfig/conf --silentoldconfig choice-in-choice.in </dev/null
    [--SNIP--]
    A/B/C
      1. A (A)
    > 2. B (B)
      3. C (C)
    choice[1-3]: 2
      E/F
      > 1. E (E) (NEW)
        2. F (F) (NEW)
      choice[1-2]: aborted!

    Console input/output is redirected. Run 'make oldconfig' to update
    configuration.

Fix this by looping in randconfig for as long as some symbol gets assigned
a value.

Note: this was spotted with the USB EHCI Debug Device Gadget (USB_G_DBGP),
which uses this choice-in-a-choice construct, and exhibits this problem.
The example above is just a stripped-down minimalist test-case.

Signed-off-by: "Yann E. MORIN" <yann.morin.1998@free.fr>
---
 scripts/kconfig/conf.c     |  3 ++-
 scripts/kconfig/confdata.c | 18 ++++++++++++++----
 scripts/kconfig/lkc.h      |  2 +-
 3 files changed, 17 insertions(+), 6 deletions(-)

diff --git a/scripts/kconfig/conf.c b/scripts/kconfig/conf.c
index 38616c1..d19944f 100644
--- a/scripts/kconfig/conf.c
+++ b/scripts/kconfig/conf.c
@@ -654,7 +654,8 @@ int main(int ac, char **av)
 		conf_set_all_new_symbols(def_default);
 		break;
 	case randconfig:
-		conf_set_all_new_symbols(def_random);
+		/* Really nothing to do in this loop */
+		while (conf_set_all_new_symbols(def_random)) ;
 		break;
 	case defconfig:
 		conf_set_all_new_symbols(def_default);
diff --git a/scripts/kconfig/confdata.c b/scripts/kconfig/confdata.c
index d36bc1f..c55c227 100644
--- a/scripts/kconfig/confdata.c
+++ b/scripts/kconfig/confdata.c
@@ -1040,7 +1040,7 @@ void conf_set_changed_callback(void (*fn)(void))
 	conf_changed_callback = fn;
 }
 
-static void randomize_choice_values(struct symbol *csym)
+static bool randomize_choice_values(struct symbol *csym)
 {
 	struct property *prop;
 	struct symbol *sym;
@@ -1053,7 +1053,7 @@ static void randomize_choice_values(struct symbol *csym)
 	 * In both cases stop.
 	 */
 	if (csym->curr.tri != yes)
-		return;
+		return false;
 
 	prop = sym_get_choice_prop(csym);
 
@@ -1084,6 +1084,8 @@ static void randomize_choice_values(struct symbol *csym)
 	csym->flags |= SYMBOL_DEF_USER;
 	/* clear VALID to get value calculated */
 	csym->flags &= ~(SYMBOL_VALID);
+
+	return true;
 }
 
 void set_all_choice_values(struct symbol *csym)
@@ -1106,7 +1108,7 @@ void set_all_choice_values(struct symbol *csym)
 	csym->flags &= ~(SYMBOL_VALID | SYMBOL_NEED_SET_CHOICE_VALUES);
 }
 
-void conf_set_all_new_symbols(enum conf_def_mode mode)
+bool conf_set_all_new_symbols(enum conf_def_mode mode)
 {
 	struct symbol *sym, *csym;
 	int i, cnt, pby, pty, ptm;	/* pby: probability of boolean  = y
@@ -1154,6 +1156,7 @@ void conf_set_all_new_symbols(enum conf_def_mode mode)
 			exit( 1 );
 		}
 	}
+	bool has_changed = false;
 
 	for_all_symbols(i, sym) {
 		if (sym_has_value(sym) || (sym->flags & SYMBOL_VALID))
@@ -1161,6 +1164,7 @@ void conf_set_all_new_symbols(enum conf_def_mode mode)
 		switch (sym_get_type(sym)) {
 		case S_BOOLEAN:
 		case S_TRISTATE:
+			has_changed = true;
 			switch (mode) {
 			case def_yes:
 				sym->def[S_DEF_USER].tri = yes;
@@ -1219,6 +1223,12 @@ void conf_set_all_new_symbols(enum conf_def_mode mode)
 
 		sym_calc_value(csym);
 		if (mode == def_random)
-			randomize_choice_values(csym);
+			has_changed = randomize_choice_values(csym);
+		else {
+			set_all_choice_values(csym);
+			has_changed = true;
+		}
 	}
+
+	return has_changed;
 }
diff --git a/scripts/kconfig/lkc.h b/scripts/kconfig/lkc.h
index 0c8d419..09f4edf 100644
--- a/scripts/kconfig/lkc.h
+++ b/scripts/kconfig/lkc.h
@@ -86,7 +86,7 @@ const char *conf_get_autoconfig_name(void);
 char *conf_get_default_confname(void);
 void sym_set_change_count(int count);
 void sym_add_change_count(int count);
-void conf_set_all_new_symbols(enum conf_def_mode mode);
+bool conf_set_all_new_symbols(enum conf_def_mode mode);
 void set_all_choice_values(struct symbol *csym);
 
 struct conf_printer {
-- 
1.8.1.2

