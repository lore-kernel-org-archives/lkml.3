Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754246AbaKYK7U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 05:59:20 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:59035 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752441AbaKYKnP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 05:43:15 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Will Deacon <will.deacon@arm.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 207/254] ARM: 8191/1: decompressor: ensure I-side picks up relocated code
Date: Tue, 25 Nov 2014 10:39:17 +0000
Message-Id: <1416912004-5928-208-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1416912004-5928-1-git-send-email-luis.henriques@canonical.com>
References: <1416912004-5928-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Will Deacon <will.deacon@arm.com>

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/arm/boot/compressed/head.S | 20 ++++++++++++++++----
 1 file changed, 16 insertions(+), 4 deletions(-)

diff --git a/arch/arm/boot/compressed/head.S b/arch/arm/boot/compressed/head.S
index 3a8b32df6b31..d35692b63cfd 100644
--- a/arch/arm/boot/compressed/head.S
+++ b/arch/arm/boot/compressed/head.S
@@ -395,8 +395,7 @@ dtb_check_done:
 		add	sp, sp, r6
 #endif
 
-		tst	r4, #1
-		bleq	cache_clean_flush
+		bl	cache_clean_flush
 
 		adr	r0, BSYM(restart)
 		add	r0, r0, r6
@@ -1045,6 +1044,8 @@ cache_clean_flush:
 		b	call_cache_fn
 
 __armv4_mpu_cache_flush:
+		tst	r4, #1
+		movne	pc, lr
 		mov	r2, #1
 		mov	r3, #0
 		mcr	p15, 0, ip, c7, c6, 0	@ invalidate D cache
@@ -1062,6 +1063,8 @@ __armv4_mpu_cache_flush:
 		mov	pc, lr
 		
 __fa526_cache_flush:
+		tst	r4, #1
+		movne	pc, lr
 		mov	r1, #0
 		mcr	p15, 0, r1, c7, c14, 0	@ clean and invalidate D cache
 		mcr	p15, 0, r1, c7, c5, 0	@ flush I cache
@@ -1070,13 +1073,16 @@ __fa526_cache_flush:
 
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
@@ -1137,6 +1143,8 @@ iflush:
 		mov	pc, lr
 
 __armv5tej_mmu_cache_flush:
+		tst	r4, #1
+		movne	pc, lr
 1:		mrc	p15, 0, r15, c7, c14, 3	@ test,clean,invalidate D cache
 		bne	1b
 		mcr	p15, 0, r0, c7, c5, 0	@ flush I cache
@@ -1144,6 +1152,8 @@ __armv5tej_mmu_cache_flush:
 		mov	pc, lr
 
 __armv4_mmu_cache_flush:
+		tst	r4, #1
+		movne	pc, lr
 		mov	r2, #64*1024		@ default: 32K dcache size (*2)
 		mov	r11, #32		@ default: 32 byte line size
 		mrc	p15, 0, r3, c0, c0, 1	@ read cache type
@@ -1177,6 +1187,8 @@ no_cache_id:
 
 __armv3_mmu_cache_flush:
 __armv3_mpu_cache_flush:
+		tst	r4, #1
+		movne	pc, lr
 		mov	r1, #0
 		mcr	p15, 0, r1, c7, c0, 0	@ invalidate whole cache v3
 		mov	pc, lr
-- 
2.1.0

