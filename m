Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754719Ab3JVQNK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 12:13:10 -0400
Received: from mga02.intel.com ([134.134.136.20]:61399 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754665Ab3JVQNE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 12:13:04 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,535,1378882800"; 
   d="scan'208";a="396828247"
From: Andi Kleen <andi@firstfloor.org>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
        rusty@rustcorp.com.au
Subject: [PATCH 07/11] asmlinkage, module: Make ksymtab and kcrctab symbols and __this_module __visible
Date: Tue, 22 Oct 2013 09:12:22 -0700
Message-Id: <1382458346-24811-8-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1382458346-24811-1-git-send-email-andi@firstfloor.org>
References: <1382458346-24811-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Make the ksymtab symbols for EXPORT_SYMBOL visible.
This prevents the LTO compiler from adding a .NUMBER prefix,
which avoids various problems in later export processing.

Cc: rusty@rustcorp.com.au
Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 include/linux/export.h | 4 ++--
 scripts/mod/modpost.c  | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/linux/export.h b/include/linux/export.h
index 412cd50..3f2793d 100644
--- a/include/linux/export.h
+++ b/include/linux/export.h
@@ -43,7 +43,7 @@ extern struct module __this_module;
 /* Mark the CRC weak since genksyms apparently decides not to
  * generate a checksums for some symbols */
 #define __CRC_SYMBOL(sym, sec)					\
-	extern void *__crc_##sym __attribute__((weak));		\
+	extern __visible void *__crc_##sym __attribute__((weak));		\
 	static const unsigned long __kcrctab_##sym		\
 	__used							\
 	__attribute__((section("___kcrctab" sec "+" #sym), unused))	\
@@ -59,7 +59,7 @@ extern struct module __this_module;
 	static const char __kstrtab_##sym[]			\
 	__attribute__((section("__ksymtab_strings"), aligned(1))) \
 	= VMLINUX_SYMBOL_STR(sym);				\
-	static const struct kernel_symbol __ksymtab_##sym	\
+	__visible const struct kernel_symbol __ksymtab_##sym	\
 	__used							\
 	__attribute__((section("___ksymtab" sec "+" #sym), unused))	\
 	= { (unsigned long)&sym, __kstrtab_##sym }
diff --git a/scripts/mod/modpost.c b/scripts/mod/modpost.c
index 8247979..0971bac 100644
--- a/scripts/mod/modpost.c
+++ b/scripts/mod/modpost.c
@@ -1853,7 +1853,7 @@ static void add_header(struct buffer *b, struct module *mod)
 	buf_printf(b, "\n");
 	buf_printf(b, "MODULE_INFO(vermagic, VERMAGIC_STRING);\n");
 	buf_printf(b, "\n");
-	buf_printf(b, "struct module __this_module\n");
+	buf_printf(b, "__visible struct module __this_module\n");
 	buf_printf(b, "__attribute__((section(\".gnu.linkonce.this_module\"))) = {\n");
 	buf_printf(b, "\t.name = KBUILD_MODNAME,\n");
 	if (mod->has_init)
-- 
1.8.3.1

