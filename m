Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753854AbaLCLvs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 06:51:48 -0500
Received: from cantor2.suse.de ([195.135.220.15]:54626 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752382AbaLCL1S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 06:27:18 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Will Deacon <will.deacon@arm.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 038/101] ARM: 8191/1: decompressor: ensure I-side picks up relocated code
Date: Wed,  3 Dec 2014 12:26:00 +0100
Message-Id: <f0a72a0e7c682320fa38e71612008de3e3d796ca.1417605922.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <f9a3dbb8fd1853c16930b2c95eefa34a324eca19.1417605922.git.jslaby@suse.cz>
References: <f9a3dbb8fd1853c16930b2c95eefa34a324eca19.1417605922.git.jslaby@suse.cz>
In-Reply-To: <cover.1417605922.git.jslaby@suse.cz>
References: <cover.1417605922.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Will Deacon <will.deacon@arm.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 238962ac71910d6c20162ea5230685fead1836a4 upstream.

To speed up decompression, the decompressor sets up a flat, cacheable
mapping of memory. However, when there is insufficient space to hold
the page tables for this mapping, we don't bother to enable the caches
and subsequently skip all the cache maintenance hooks.

Skipping the cache maintenance before jumping to the relocated code
allows the processor to predict the branch and populate the I-cache
with stale data before the relocation loop has completed (since a
bootloader may have SCTLR.I set, which permits normal, cacheable
instruction fetches regardless of SCTLR.M).

This patch moves the cache maintenance check into the maintenance
routines themselves, allowing the v6/v7 versions to invalidate the
I-cache regardless of the MMU state.

Reported-by: Marc Carino <marc.ceeeee@gmail.com>
Tested-by: Julien Grall <julien.grall@linaro.org>
Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 arch/arm/boot/compressed/head.S | 20 ++++++++++++++++----
 1 file changed, 16 insertions(+), 4 deletions(-)

diff --git a/arch/arm/boot/compressed/head.S b/arch/arm/boot/compressed/head.S
index 75189f13cf54..de5143e4ad04 100644
--- a/arch/arm/boot/compressed/head.S
+++ b/arch/arm/boot/compressed/head.S
@@ -399,8 +399,7 @@ dtb_check_done:
 		add	sp, sp, r6
 #endif
 
-		tst	r4, #1
-		bleq	cache_clean_flush
+		bl	cache_clean_flush
 
 		adr	r0, BSYM(restart)
 		add	r0, r0, r6
@@ -1053,6 +1052,8 @@ cache_clean_flush:
 		b	call_cache_fn
 
 __armv4_mpu_cache_flush:
+		tst	r4, #1
+		movne	pc, lr
 		mov	r2, #1
 		mov	r3, #0
 		mcr	p15, 0, ip, c7, c6, 0	@ invalidate D cache
@@ -1070,6 +1071,8 @@ __armv4_mpu_cache_flush:
 		mov	pc, lr
 		
 __fa526_cache_flush:
+		tst	r4, #1
+		movne	pc, lr
 		mov	r1, #0
 		mcr	p15, 0, r1, c7, c14, 0	@ clean and invalidate D cache
 		mcr	p15, 0, r1, c7, c5, 0	@ flush I cache
@@ -1078,13 +1081,16 @@ __fa526_cache_flush:
 
 __armv6_mmu_cache_flush:
 		mov	r1, #0
-		mcr	p15, 0, r1, c7, c14, 0	@ clean+invalidate D
+		tst	r4, #1
+		mcreq	p15, 0, r1, c7, c14, 0	@ clean+invalidate D
 		mcr	p15, 0, r1, c7, c5, 0	@ invalidate I+BTB
-		mcr	p15, 0, r1, c7, c15, 0	@ clean+invalidate unified
+		mcreq	p15, 0, r1, c7, c15, 0	@ clean+invalidate unified
 		mcr	p15, 0, r1, c7, c10, 4	@ drain WB
 		mov	pc, lr
 
 __armv7_mmu_cache_flush:
+		tst	r4, #1
+		bne	iflush
 		mrc	p15, 0, r10, c0, c1, 5	@ read ID_MMFR1
 		tst	r10, #0xf << 16		@ hierarchical cache (ARMv7)
 		mov	r10, #0
@@ -1145,6 +1151,8 @@ iflush:
 		mov	pc, lr
 
 __armv5tej_mmu_cache_flush:
+		tst	r4, #1
+		movne	pc, lr
 1:		mrc	p15, 0, r15, c7, c14, 3	@ test,clean,invalidate D cache
 		bne	1b
 		mcr	p15, 0, r0, c7, c5, 0	@ flush I cache
@@ -1152,6 +1160,8 @@ __armv5tej_mmu_cache_flush:
 		mov	pc, lr
 
 __armv4_mmu_cache_flush:
+		tst	r4, #1
+		movne	pc, lr
 		mov	r2, #64*1024		@ default: 32K dcache size (*2)
 		mov	r11, #32		@ default: 32 byte line size
 		mrc	p15, 0, r3, c0, c0, 1	@ read cache type
@@ -1185,6 +1195,8 @@ no_cache_id:
 
 __armv3_mmu_cache_flush:
 __armv3_mpu_cache_flush:
+		tst	r4, #1
+		movne	pc, lr
 		mov	r1, #0
 		mcr	p15, 0, r1, c7, c0, 0	@ invalidate whole cache v3
 		mov	pc, lr
-- 
2.1.3

