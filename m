Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758769Ab3G3Jo2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 05:44:28 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:53261 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932378Ab3G3Jd3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 05:33:29 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Anton Blanchard <anton@samba.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 068/106] powerpc/modules: Module CRC relocation fix causes perf issues
Date: Tue, 30 Jul 2013 10:31:27 +0100
Message-Id: <1375176725-5825-69-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1375176725-5825-1-git-send-email-luis.henriques@canonical.com>
References: <1375176725-5825-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.18 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/powerpc/include/asm/module.h | 5 ++---
 arch/powerpc/kernel/vmlinux.lds.S | 3 ---
 2 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/arch/powerpc/include/asm/module.h b/arch/powerpc/include/asm/module.h
index 0192a4e..80de64b 100644
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
diff --git a/arch/powerpc/kernel/vmlinux.lds.S b/arch/powerpc/kernel/vmlinux.lds.S
index 65d1c08..7703569 100644
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
-- 
1.8.3.2

