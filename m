Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030308Ab3HBKKt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 06:10:49 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:37339 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030228Ab3HBKKg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 06:10:36 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Anton Blanchard <anton@samba.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [ 53/99] powerpc/modules: Module CRC relocation fix causes perf issues
Date: Fri,  2 Aug 2013 18:08:06 +0800
Message-Id: <20130802100233.443484946@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.4.841.g1a3f60e
In-Reply-To: <20130802100225.478715166@linuxfoundation.org>
References: <20130802100225.478715166@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Anton Blanchard <anton@samba.org>

commit 0e0ed6406e61434d3f38fb58aa8464ec4722b77e upstream.

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
Acked-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/include/asm/module.h |    5 ++---
 arch/powerpc/kernel/vmlinux.lds.S |    3 ---
 2 files changed, 2 insertions(+), 6 deletions(-)

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


