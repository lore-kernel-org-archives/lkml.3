Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760194Ab3GaNkq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 09:40:46 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46901 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759652Ab3GaNZv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 09:25:51 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Anton Blanchard" <anton@samba.org>,
        "Rusty Russell" <rusty@rustcorp.com.au>,
        "Benjamin Herrenschmidt" <benh@kernel.crashing.org>
Date: Wed, 31 Jul 2013 15:23:09 +0200
Message-ID: <lsq.1375276989.950300168@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [74/84] powerpc/modules: Module CRC relocation fix causes perf issues
In-Reply-To: <lsq.1375276989.251749228@decadent.org.uk>
X-SA-Exim-Connect-IP: 151.216.67.181
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.50-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/powerpc/include/asm/module.h | 5 ++---
 arch/powerpc/kernel/vmlinux.lds.S | 3 ---
 2 files changed, 2 insertions(+), 6 deletions(-)

--- a/arch/powerpc/include/asm/module.h
+++ b/arch/powerpc/include/asm/module.h
@@ -87,10 +87,9 @@ struct exception_table_entry;
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

