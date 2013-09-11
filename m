Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756529Ab3IKFXB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 01:23:01 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:22176 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753314Ab3IKE52 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 00:57:28 -0400
X-Authority-Analysis: v=2.0 cv=V4T/IJbi c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=ztIMjK6J7wcA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=Ff1dCouQ9zIA:10 a=hGzw-44bAAAA:8 a=VwQbUJbxAAAA:8 a=Tty9oNO6AAAA:8 a=wMNdZWldAAAA:8 a=35crcUObn1LEwPT5wXcA:9 a=dowx1zmaLagA:10 a=LI9Vle30uBYA:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130911042909.596921872@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 11 Sep 2013 00:28:51 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Anton Blanchard <anton@samba.org>, <stable@kernel.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [104/251] powerpc/modules: Module CRC relocation fix causes perf issues
References: <20130911042707.738353451@goodmis.org>
Content-Disposition: inline; filename=0104-powerpc-modules-Module-CRC-relocation-fix-causes-per.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.9-rc1 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Anton Blanchard <anton@samba.org>

[ Upstream commit 0e0ed6406e61434d3f38fb58aa8464ec4722b77e ]

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
Acked-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/powerpc/include/asm/module.h |    5 ++---
 arch/powerpc/kernel/vmlinux.lds.S |    3 ---
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
1.7.10.4


