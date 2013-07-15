Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751241Ab3GOEEm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 00:04:42 -0400
Received: from ozlabs.org ([203.10.76.45]:58155 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750777Ab3GOEEl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 00:04:41 -0400
Date: Mon, 15 Jul 2013 14:04:50 +1000
From: Anton Blanchard <anton@samba.org>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Neil Horman <nhorman@tuxdriver.com>
Cc: linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: [PATCH] module: ppc64 module CRC relocation fix causes perf issues
Message-ID: <20130715140450.573aab15@kryten>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.17; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Module CRCs are implemented as absolute symbols that get resolved by
a linker script. We build an intermediate .o that contains an
unresolved symbol for each CRC. genksysms parses this .o, calculates
the CRCs and writes a linker script that "resolves" the symbols to
the calculated CRC.

Unfortunately the ppc64 relocatable kernel sees these CRCs as symbols
that need relocating and relocates them at boot. Commit d4703aef
(module: handle ppc64 relocating kcrctabs when CONFIG_RELOCATABLE=y)
added a hook to reverse the bogus relocations. Part of this patch
created a symbol at 0x0:

# head -2 /proc/kallsyms 
0000000000000000 T reloc_start
c000000000000000 T .__start

This reloc_start symbol is causing lots of confusion to perf. It
thinks reloc_start is a massive function that stretches from 0x0 to
0xc000000000000000 and we get various cryptic errors out of perf,
including:

problem incrementing symbol count, skipping event

This patch removes the  reloc_start linker script label and instead
defines it as PHYSICAL_START. We also need to wrap it with
CONFIG_PPC64 because the ppc32 kernel can set a non zero
PHYSICAL_START at compile time and we wouldn't want to subtract
it from the CRCs in that case.

Signed-off-by: Anton Blanchard <anton@samba.org>
Cc: <stable@kernel.org>
---

This bug was originally reported on Fedora 19 (3.9.x), so I've marked
it for stable.

Index: b/arch/powerpc/include/asm/module.h
===================================================================
--- a/arch/powerpc/include/asm/module.h
+++ b/arch/powerpc/include/asm/module.h
@@ -82,10 +82,9 @@ struct exception_table_entry;
 void sort_ex_table(struct exception_table_entry *start,
 		   struct exception_table_entry *finish);
 
-#ifdef CONFIG_MODVERSIONS
+#if defined(CONFIG_MODVERSIONS) && defined(CONFIG_PPC64)
 #define ARCH_RELOCATES_KCRCTAB
-
-extern const unsigned long reloc_start[];
+#define reloc_start PHYSICAL_START
 #endif
 #endif /* __KERNEL__ */
 #endif	/* _ASM_POWERPC_MODULE_H */
Index: b/arch/powerpc/kernel/vmlinux.lds.S
===================================================================
--- a/arch/powerpc/kernel/vmlinux.lds.S
+++ b/arch/powerpc/kernel/vmlinux.lds.S
@@ -38,9 +38,6 @@ jiffies = jiffies_64 + 4;
 #endif
 SECTIONS
 {
-	. = 0;
-	reloc_start = .;
-
 	. = KERNELBASE;
 
 /*
