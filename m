Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756361Ab3AURWC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 12:22:02 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:64596 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754454Ab3AURRA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 12:17:00 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, arm@kernel.org,
        Arnd Bergmann <arnd@arndb.de>,
        Matthew Gretton-Dann <matthew.gretton-dann@arm.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>
Subject: [PATCH 01/15] ARM: compressed/head.S: work around new binutils warning
Date: Mon, 21 Jan 2013 17:15:54 +0000
Message-Id: <1358788568-11137-2-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1358788568-11137-1-git-send-email-arnd@arndb.de>
References: <1358788568-11137-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:0y6Vnz6gRf7XlxPmKSm8gmWlXV2d5yhnCdgOjtyXWKI
 VYG5ohewE05h6gBZY5w9y9Oj7e+5xRnBTRszmNzUARl/g5f61v
 vzCB+Kfphs5eONA6NxQD5uIH2H/8lQLxE7iWL8m7u48cSppxO6
 lMRDi9Pl8TFiXgKFrBh+76i83LVsiAVbZ9RMRRBfGGc8pqpEKc
 XnzLQovds110bOfdWNhvU2rj5jiEWJhvNJhByQkzaK3FnWHjMh
 I+e/Wv2CYdpiEc/ZVa/4DPx45TSimem2hOozNTSuA8Rbg0oLAT
 yV3HL1Y4uMl180wAtrS1QJjPO4ZtbkTZtgbDIb6U9zNJH/BgG5
 m15TwhBrzfRsPbPmIuXW1O97bk87JnO7R9R7n38qE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In August 2012, Matthew Gretton-Dann checked a change
into binutils labelled "Error on obsolete & warn on
deprecated registers", apparently as part of ARMv8
support. Apparently, this was supposed to emit
the message "Warning: This coprocessor register access
is deprecated in ARMv8" when using certain mcr/mrc
instructions and building for ARMv8. Unfortunately,
the message that is actually emitted appears to be
'(null)', which is less helpful in comparison.

Even more unfortunately, this is biting us on
every single kernel build with a new gas, because
arch/arm/boot/compressed/head.S and some other files
in that directory are built with -march=all since
kernel commit 80cec14a8 "[ARM] Add -march=all to
assembly file build in arch/arm/boot/compressed"
back in v2.6.28.

This patch reverts Russell's nice solution and
replaces it with a more complex one that sprinkles
.arch statements inside of the head.S file in
functions that are executed in different architecture
levels, which seems to solve the original problem
just as well, and gets rid of the new one, too.

Without this patch, building anything results in:

arch/arm/boot/compressed/head.S: Assembler messages:
arch/arm/boot/compressed/head.S:565: Warning: (null)
arch/arm/boot/compressed/head.S:676: Warning: (null)
arch/arm/boot/compressed/head.S:698: Warning: (null)
arch/arm/boot/compressed/head.S:722: Warning: (null)
arch/arm/boot/compressed/head.S:726: Warning: (null)
arch/arm/boot/compressed/head.S:957: Warning: (null)
arch/arm/boot/compressed/head.S:996: Warning: (null)
arch/arm/boot/compressed/head.S:997: Warning: (null)
arch/arm/boot/compressed/head.S:1027: Warning: (null)
arch/arm/boot/compressed/head.S:1035: Warning: (null)
arch/arm/boot/compressed/head.S:1046: Warning: (null)
arch/arm/boot/compressed/head.S:1060: Warning: (null)
arch/arm/boot/compressed/head.S:1092: Warning: (null)
arch/arm/boot/compressed/head.S:1094: Warning: (null)
arch/arm/boot/compressed/head.S:1095: Warning: (null)
arch/arm/boot/compressed/head.S:1102: Warning: (null)
arch/arm/boot/compressed/head.S:1134: Warning: (null)

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Matthew Gretton-Dann <matthew.gretton-dann@arm.com>
Cc: Russell King <rmk+kernel@arm.linux.org.uk>
---
 arch/arm/boot/compressed/Makefile |    2 +-
 arch/arm/boot/compressed/head.S   |   12 ++++++++++++
 2 files changed, 13 insertions(+), 1 deletion(-)

diff --git a/arch/arm/boot/compressed/Makefile b/arch/arm/boot/compressed/Makefile
index 5cad8a6..dfe5687 100644
--- a/arch/arm/boot/compressed/Makefile
+++ b/arch/arm/boot/compressed/Makefile
@@ -121,7 +121,7 @@ KBUILD_CFLAGS = $(subst -pg, , $(ORIG_CFLAGS))
 endif
 
 ccflags-y := -fpic -fno-builtin -I$(obj)
-asflags-y := -Wa,-march=all -DZIMAGE
+asflags-y := -DZIMAGE
 
 # Supply kernel BSS size to the decompressor via a linker symbol.
 KBSS_SZ = $(shell $(CROSS_COMPILE)size $(obj)/../../../../vmlinux | \
diff --git a/arch/arm/boot/compressed/head.S b/arch/arm/boot/compressed/head.S
index fe4d9c3..3b0b21a 100644
--- a/arch/arm/boot/compressed/head.S
+++ b/arch/arm/boot/compressed/head.S
@@ -548,6 +548,7 @@ cache_on:	mov	r3, #8			@ cache_on function
  * to cover all 32bit address and cacheable and bufferable.
  */
 __armv4_mpu_cache_on:
+		.arch armv4
 		mov	r0, #0x3f		@ 4G, the whole
 		mcr	p15, 0, r0, c6, c7, 0	@ PR7 Area Setting
 		mcr 	p15, 0, r0, c6, c7, 1
@@ -655,6 +656,7 @@ ENDPROC(__setup_mmu)
 @ Enable unaligned access on v6, to allow better code generation
 @ for the decompressor C code:
 __armv6_mmu_cache_on:
+		.arch armv6
 		mrc	p15, 0, r0, c1, c0, 0	@ read SCTLR
 		bic	r0, r0, #2		@ A (no unaligned access fault)
 		orr	r0, r0, #1 << 22	@ U (v6 unaligned access model)
@@ -663,11 +665,13 @@ __armv6_mmu_cache_on:
 
 __arm926ejs_mmu_cache_on:
 #ifdef CONFIG_CPU_DCACHE_WRITETHROUGH
+		.arch armv5
 		mov	r0, #4			@ put dcache in WT mode
 		mcr	p15, 7, r0, c15, c0, 0
 #endif
 
 __armv4_mmu_cache_on:
+		.arch armv4
 		mov	r12, lr
 #ifdef CONFIG_MMU
 		mov	r6, #CB_BITS | 0x12	@ U
@@ -688,6 +692,7 @@ __armv4_mmu_cache_on:
 		mov	pc, r12
 
 __armv7_mmu_cache_on:
+		.arch armv7-a
 		mov	r12, lr
 #ifdef CONFIG_MMU
 		mrc	p15, 0, r11, c0, c1, 4	@ read ID_MMFR0
@@ -1031,6 +1036,7 @@ cache_clean_flush:
 		mov	r3, #16
 		b	call_cache_fn
 
+		.arch armv4
 __armv4_mpu_cache_flush:
 		mov	r2, #1
 		mov	r3, #0
@@ -1056,6 +1062,7 @@ __fa526_cache_flush:
 		mov	pc, lr
 
 __armv6_mmu_cache_flush:
+		.arch armv6
 		mov	r1, #0
 		mcr	p15, 0, r1, c7, c14, 0	@ clean+invalidate D
 		mcr	p15, 0, r1, c7, c5, 0	@ invalidate I+BTB
@@ -1063,6 +1070,7 @@ __armv6_mmu_cache_flush:
 		mcr	p15, 0, r1, c7, c10, 4	@ drain WB
 		mov	pc, lr
 
+		.arch armv7-a
 __armv7_mmu_cache_flush:
 		mrc	p15, 0, r10, c0, c1, 5	@ read ID_MMFR1
 		tst	r10, #0xf << 16		@ hierarchical cache (ARMv7)
@@ -1123,6 +1131,7 @@ iflush:
 		mcr	p15, 0, r10, c7, c5, 4	@ ISB
 		mov	pc, lr
 
+		.arch armv5
 __armv5tej_mmu_cache_flush:
 1:		mrc	p15, 0, r15, c7, c14, 3	@ test,clean,invalidate D cache
 		bne	1b
@@ -1130,6 +1139,7 @@ __armv5tej_mmu_cache_flush:
 		mcr	p15, 0, r0, c7, c10, 4	@ drain WB
 		mov	pc, lr
 
+		.arch armv4
 __armv4_mmu_cache_flush:
 		mov	r2, #64*1024		@ default: 32K dcache size (*2)
 		mov	r11, #32		@ default: 32 byte line size
@@ -1168,6 +1178,8 @@ __armv3_mpu_cache_flush:
 		mcr	p15, 0, r1, c7, c0, 0	@ invalidate whole cache v3
 		mov	pc, lr
 
+		.arch armv4
+
 /*
  * Various debugging routines for printing hex characters and
  * memory, which again must be relocatable.
-- 
1.7.10.4

