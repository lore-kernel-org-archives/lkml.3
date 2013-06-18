Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933933Ab3FRWsz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 18:48:55 -0400
Received: from mail-wi0-f174.google.com ([209.85.212.174]:55753 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755725Ab3FRWpU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 18:45:20 -0400
From: "Yann E. MORIN" <yann.morin.1998@free.fr>
To: linux-kbuild@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Michal Marek <mmarek@suse.cz>,
        =?UTF-8?q?Arve=20Hj=C3=B8nnev=C3=A5g?= <arve@android.com>,
        "Yann E. MORIN" <yann.morin.1998@free.fr>
Subject: [PATCH 01/14] kconfig: Fix defconfig when one choice menu selects options that another choice menu depends on
Date: Wed, 19 Jun 2013 00:44:57 +0200
Message-Id: <fbe98bb9ed3dae23e320c6b113e35f129538d14a.1371595499.git.yann.morin.1998@free.fr>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <cover.1371595499.git.yann.morin.1998@free.fr>
References: <cover.1371595499.git.yann.morin.1998@free.fr>
In-Reply-To: <cover.1371595499.git.yann.morin.1998@free.fr>
References: <cover.1371595499.git.yann.morin.1998@free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arve Hjønnevåg <arve@android.com>

The defconfig and Kconfig combination below, which is based on 3.10-rc4
Kconfigs, resulted in several options getting set to "m" instead of "y".

defconfig.choice:
---8<---
CONFIG_MODULES=y
CONFIG_USB_ZERO=y
---8<---

Kconfig.choice:
---8<---
menuconfig MODULES
	bool "Enable loadable module support"

config CONFIGFS_FS
	tristate "Userspace-driven configuration filesystem"

config OCFS2_FS
        tristate "OCFS2 file system support"
        depends on CONFIGFS_FS
        select CRC32

config USB_LIBCOMPOSITE
	tristate
	select CONFIGFS_FS

choice
	tristate "USB Gadget Drivers"
	default USB_ETH

config USB_ZERO
	tristate "Gadget Zero (DEVELOPMENT)"
	select USB_LIBCOMPOSITE

config USB_ETH
	tristate "Ethernet Gadget (with CDC Ethernet support)"
	select USB_LIBCOMPOSITE

endchoice

config CRC32
        tristate "CRC32/CRC32c functions"
        default y

choice
        prompt "CRC32 implementation"
        depends on CRC32
        default CRC32_SLICEBY8

config CRC32_SLICEBY8
        bool "Slice by 8 bytes"

endchoice
---8<---

$ scripts/kconfig/conf --defconfig=defconfig.choice Kconfig.choice

would result in:

.config:
---8<---
CONFIG_MODULES=y
CONFIG_CONFIGFS_FS=m
CONFIG_USB_LIBCOMPOSITE=m
CONFIG_USB_ZERO=m
CONFIG_CRC32=y
CONFIG_CRC32_SLICEBY8=y
---8<---

when the expected result would be:

.config:
---8<---
CONFIG_MODULES=y
CONFIG_CONFIGFS_FS=y
CONFIG_USB_LIBCOMPOSITE=y
CONFIG_USB_ZERO=y
CONFIG_CRC32=y
CONFIG_CRC32_SLICEBY8=y
---8<---

Signed-off-by: Arve Hjønnevåg <arve@android.com>
[yann.morin.1998@free.fr: add the resulting .config to commit log,
                          remove unneeded USB_GADGET from the defconfig]
Tested-by: "Yann E. MORIN" <yann.morin.1998@free.fr>
Reviewed-by: "Yann E. MORIN" <yann.morin.1998@free.fr>
Signed-off-by: Yann E. MORIN <yann.morin.1998@free.fr>
---
 scripts/kconfig/confdata.c | 14 ++++++++++----
 scripts/kconfig/expr.h     |  3 +++
 scripts/kconfig/lkc.h      |  1 +
 scripts/kconfig/symbol.c   | 11 +++++++++++
 4 files changed, 25 insertions(+), 4 deletions(-)

diff --git a/scripts/kconfig/confdata.c b/scripts/kconfig/confdata.c
index 43eda40..35e0f16 100644
--- a/scripts/kconfig/confdata.c
+++ b/scripts/kconfig/confdata.c
@@ -1083,7 +1083,7 @@ static void randomize_choice_values(struct symbol *csym)
 	csym->flags &= ~(SYMBOL_VALID);
 }
 
-static void set_all_choice_values(struct symbol *csym)
+void set_all_choice_values(struct symbol *csym)
 {
 	struct property *prop;
 	struct symbol *sym;
@@ -1100,7 +1100,7 @@ static void set_all_choice_values(struct symbol *csym)
 	}
 	csym->flags |= SYMBOL_DEF_USER;
 	/* clear VALID to get value calculated */
-	csym->flags &= ~(SYMBOL_VALID);
+	csym->flags &= ~(SYMBOL_VALID | SYMBOL_NEED_SET_CHOICE_VALUES);
 }
 
 void conf_set_all_new_symbols(enum conf_def_mode mode)
@@ -1202,6 +1202,14 @@ void conf_set_all_new_symbols(enum conf_def_mode mode)
 	 * selected in a choice block and we set it to yes,
 	 * and the rest to no.
 	 */
+	if (mode != def_random) {
+		for_all_symbols(i, csym) {
+			if ((sym_is_choice(csym) && !sym_has_value(csym)) ||
+			    sym_is_choice_value(csym))
+				csym->flags |= SYMBOL_NEED_SET_CHOICE_VALUES;
+		}
+	}
+
 	for_all_symbols(i, csym) {
 		if (sym_has_value(csym) || !sym_is_choice(csym))
 			continue;
@@ -1209,7 +1217,5 @@ void conf_set_all_new_symbols(enum conf_def_mode mode)
 		sym_calc_value(csym);
 		if (mode == def_random)
 			randomize_choice_values(csym);
-		else
-			set_all_choice_values(csym);
 	}
 }
diff --git a/scripts/kconfig/expr.h b/scripts/kconfig/expr.h
index cdd4860..df198a5 100644
--- a/scripts/kconfig/expr.h
+++ b/scripts/kconfig/expr.h
@@ -106,6 +106,9 @@ struct symbol {
 #define SYMBOL_DEF3       0x40000  /* symbol.def[S_DEF_3] is valid */
 #define SYMBOL_DEF4       0x80000  /* symbol.def[S_DEF_4] is valid */
 
+/* choice values need to be set before calculating this symbol value */
+#define SYMBOL_NEED_SET_CHOICE_VALUES  0x100000
+
 #define SYMBOL_MAXLENGTH	256
 #define SYMBOL_HASHSIZE		9973
 
diff --git a/scripts/kconfig/lkc.h b/scripts/kconfig/lkc.h
index f8aee5f..0c8d419 100644
--- a/scripts/kconfig/lkc.h
+++ b/scripts/kconfig/lkc.h
@@ -87,6 +87,7 @@ char *conf_get_default_confname(void);
 void sym_set_change_count(int count);
 void sym_add_change_count(int count);
 void conf_set_all_new_symbols(enum conf_def_mode mode);
+void set_all_choice_values(struct symbol *csym);
 
 struct conf_printer {
 	void (*print_symbol)(FILE *, struct symbol *, const char *, void *);
diff --git a/scripts/kconfig/symbol.c b/scripts/kconfig/symbol.c
index ecc5aa5..ab8f4c8 100644
--- a/scripts/kconfig/symbol.c
+++ b/scripts/kconfig/symbol.c
@@ -300,6 +300,14 @@ void sym_calc_value(struct symbol *sym)
 
 	if (sym->flags & SYMBOL_VALID)
 		return;
+
+	if (sym_is_choice_value(sym) &&
+	    sym->flags & SYMBOL_NEED_SET_CHOICE_VALUES) {
+		sym->flags &= ~SYMBOL_NEED_SET_CHOICE_VALUES;
+		prop = sym_get_choice_prop(sym);
+		sym_calc_value(prop_get_symbol(prop));
+	}
+
 	sym->flags |= SYMBOL_VALID;
 
 	oldval = sym->curr;
@@ -425,6 +433,9 @@ void sym_calc_value(struct symbol *sym)
 
 	if (sym->flags & SYMBOL_AUTO)
 		sym->flags &= ~SYMBOL_WRITE;
+
+	if (sym->flags & SYMBOL_NEED_SET_CHOICE_VALUES)
+		set_all_choice_values(sym);
 }
 
 void sym_clear_all_valid(void)
-- 
1.8.1.2

