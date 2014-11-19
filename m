Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933778AbaKSVJ5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 16:09:57 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:56595 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933598AbaKSVEf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 16:04:35 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Marc Carino <marc.ceeeee@gmail.com>,
        Julien Grall <julien.grall@linaro.org>,
        Will Deacon <will.deacon@arm.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>
Subject: [PATCH 3.14 042/122] ARM: 8191/1: decompressor: ensure I-side picks up relocated code
Date: Wed, 19 Nov 2014 12:51:32 -0800
Message-Id: <20141119205210.162179575@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141119205208.812884198@linuxfoundation.org>
References: <20141119205208.812884198@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/boot/compressed/head.S |   20 ++++++++++++++++----
 1 file changed, 16 insertions(+), 4 deletions(-)

--- a/arch/arm/boot/compressed/head.S
+++ b/arch/arm/boot/compressed/head.S
@@ -400,8 +400,7 @@ dtb_check_done:
 		add	sp, sp, r6
 #endif
 
-		tst	r4, #1
-		bleq	cache_clean_flush
+		bl	cache_clean_flush
 
 		adr	r0, BSYM(restart)
 		add	r0, r0, r6
@@ -1050,6 +1049,8 @@ cache_clean_flush:
 		b	call_cache_fn
 
 __armv4_mpu_cache_flush:
+		tst	r4, #1
+		movne	pc, lr
 		mov	r2, #1
 		mov	r3, #0
 		mcr	p15, 0, ip, c7, c6, 0	@ invalidate D cache
@@ -1067,6 +1068,8 @@ __armv4_mpu_cache_flush:
 		mov	pc, lr
 		
 __fa526_cache_flush:
+		tst	r4, #1
+		movne	pc, lr
 		mov	r1, #0
 		mcr	p15, 0, r1, c7, c14, 0	@ clean and invalidate D cache
 		mcr	p15, 0, r1, c7, c5, 0	@ flush I cache
@@ -1075,13 +1078,16 @@ __fa526_cache_flush:
 
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
@@ -1142,6 +1148,8 @@ iflush:
 		mov	pc, lr
 
 __armv5tej_mmu_cache_flush:
+		tst	r4, #1
+		movne	pc, lr
 1:		mrc	p15, 0, r15, c7, c14, 3	@ test,clean,invalidate D cache
 		bne	1b
 		mcr	p15, 0, r0, c7, c5, 0	@ flush I cache
@@ -1149,6 +1157,8 @@ __armv5tej_mmu_cache_flush:
 		mov	pc, lr
 
 __armv4_mmu_cache_flush:
+		tst	r4, #1
+		movne	pc, lr
 		mov	r2, #64*1024		@ default: 32K dcache size (*2)
 		mov	r11, #32		@ default: 32 byte line size
 		mrc	p15, 0, r3, c0, c0, 1	@ read cache type
@@ -1182,6 +1192,8 @@ no_cache_id:
 
 __armv3_mmu_cache_flush:
 __armv3_mpu_cache_flush:
+		tst	r4, #1
+		movne	pc, lr
 		mov	r1, #0
 		mcr	p15, 0, r1, c7, c0, 0	@ invalidate whole cache v3
 		mov	pc, lr


