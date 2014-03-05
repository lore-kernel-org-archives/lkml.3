Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757984AbaCEPAJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 10:00:09 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:41535 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757772AbaCEOhQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 09:37:16 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Will Deacon <will.deacon@arm.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.5 03/62] ARM: 7953/1: mm: ensure TLB invalidation is complete before enabling MMU
Date: Wed,  5 Mar 2014 14:36:07 +0000
Message-Id: <1394030226-26652-4-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1394030226-26652-1-git-send-email-luis.henriques@canonical.com>
References: <1394030226-26652-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.32 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Will Deacon <will.deacon@arm.com>

commit bae0ca2bc550d1ec6a118fb8f2696f18c4da3d8e upstream.

During __v{6,7}_setup, we invalidate the TLBs since we are about to
enable the MMU on return to head.S. Unfortunately, without a subsequent
dsb instruction, the invalidation is not guaranteed to have completed by
the time we write to the sctlr, potentially exposing us to junk/stale
translations cached in the TLB.

This patch reworks the init functions so that the dsb used to ensure
completion of cache/predictor maintenance is also used to ensure
completion of the TLB invalidation.

Reported-by: Albin Tonnerre <Albin.Tonnerre@arm.com>
Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/arm/mm/proc-v6.S | 3 ++-
 arch/arm/mm/proc-v7.S | 2 +-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mm/proc-v6.S b/arch/arm/mm/proc-v6.S
index 897486c..4d2e447 100644
--- a/arch/arm/mm/proc-v6.S
+++ b/arch/arm/mm/proc-v6.S
@@ -202,7 +202,6 @@ __v6_setup:
 	mcr	p15, 0, r0, c7, c14, 0		@ clean+invalidate D cache
 	mcr	p15, 0, r0, c7, c5, 0		@ invalidate I cache
 	mcr	p15, 0, r0, c7, c15, 0		@ clean+invalidate cache
-	mcr	p15, 0, r0, c7, c10, 4		@ drain write buffer
 #ifdef CONFIG_MMU
 	mcr	p15, 0, r0, c8, c7, 0		@ invalidate I + D TLBs
 	mcr	p15, 0, r0, c2, c0, 2		@ TTB control register
@@ -212,6 +211,8 @@ __v6_setup:
 	ALT_UP(orr	r8, r8, #TTB_FLAGS_UP)
 	mcr	p15, 0, r8, c2, c0, 1		@ load TTB1
 #endif /* CONFIG_MMU */
+	mcr	p15, 0, r0, c7, c10, 4		@ drain write buffer and
+						@ complete invalidations
 	adr	r5, v6_crval
 	ldmia	r5, {r5, r6}
 #ifdef CONFIG_CPU_ENDIAN_BE8
diff --git a/arch/arm/mm/proc-v7.S b/arch/arm/mm/proc-v7.S
index c2e2b66..fb489cc 100644
--- a/arch/arm/mm/proc-v7.S
+++ b/arch/arm/mm/proc-v7.S
@@ -246,7 +246,6 @@ __v7_setup:
 
 3:	mov	r10, #0
 	mcr	p15, 0, r10, c7, c5, 0		@ I+BTB cache invalidate
-	dsb
 #ifdef CONFIG_MMU
 	mcr	p15, 0, r10, c8, c7, 0		@ invalidate I + D TLBs
 	v7_ttb_setup r10, r4, r8, r5		@ TTBCR, TTBRx setup
@@ -255,6 +254,7 @@ __v7_setup:
 	mcr	p15, 0, r5, c10, c2, 0		@ write PRRR
 	mcr	p15, 0, r6, c10, c2, 1		@ write NMRR
 #endif
+	dsb					@ Complete invalidations
 #ifndef CONFIG_ARM_THUMBEE
 	mrc	p15, 0, r0, c0, c1, 0		@ read ID_PFR0 for ThumbEE
 	and	r0, r0, #(0xf << 12)		@ ThumbEE enabled field
-- 
1.9.0

