Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754668AbaCaAAl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2014 20:00:41 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:37332 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754517AbaC3XnP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2014 19:43:15 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Will Deacon" <will.deacon@arm.com>,
        "Russell King" <rmk+kernel@arm.linux.org.uk>,
        "Albin Tonnerre" <Albin.Tonnerre@arm.com>
Date: Mon, 31 Mar 2014 00:23:35 +0100
Message-ID: <lsq.1396221815.228256947@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 098/200] ARM: 7953/1: mm: ensure TLB invalidation is
 complete before enabling MMU
In-Reply-To: <lsq.1396221814.369444335@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.56-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/arm/mm/proc-v6.S | 3 ++-
 arch/arm/mm/proc-v7.S | 2 +-
 2 files changed, 3 insertions(+), 2 deletions(-)

--- a/arch/arm/mm/proc-v6.S
+++ b/arch/arm/mm/proc-v6.S
@@ -199,7 +199,6 @@ __v6_setup:
 	mcr	p15, 0, r0, c7, c14, 0		@ clean+invalidate D cache
 	mcr	p15, 0, r0, c7, c5, 0		@ invalidate I cache
 	mcr	p15, 0, r0, c7, c15, 0		@ clean+invalidate cache
-	mcr	p15, 0, r0, c7, c10, 4		@ drain write buffer
 #ifdef CONFIG_MMU
 	mcr	p15, 0, r0, c8, c7, 0		@ invalidate I + D TLBs
 	mcr	p15, 0, r0, c2, c0, 2		@ TTB control register
@@ -209,6 +208,8 @@ __v6_setup:
 	ALT_UP(orr	r8, r8, #TTB_FLAGS_UP)
 	mcr	p15, 0, r8, c2, c0, 1		@ load TTB1
 #endif /* CONFIG_MMU */
+	mcr	p15, 0, r0, c7, c10, 4		@ drain write buffer and
+						@ complete invalidations
 	adr	r5, v6_crval
 	ldmia	r5, {r5, r6}
 #ifdef CONFIG_CPU_ENDIAN_BE8
--- a/arch/arm/mm/proc-v7.S
+++ b/arch/arm/mm/proc-v7.S
@@ -368,7 +368,6 @@ __v7_setup:
 
 3:	mov	r10, #0
 	mcr	p15, 0, r10, c7, c5, 0		@ I+BTB cache invalidate
-	dsb
 #ifdef CONFIG_MMU
 	mcr	p15, 0, r10, c8, c7, 0		@ invalidate I + D TLBs
 	mcr	p15, 0, r10, c2, c0, 2		@ TTB control register
@@ -382,6 +381,7 @@ __v7_setup:
 	mcr	p15, 0, r5, c10, c2, 0		@ write PRRR
 	mcr	p15, 0, r6, c10, c2, 1		@ write NMRR
 #endif
+	dsb					@ Complete invalidations
 #ifndef CONFIG_ARM_THUMBEE
 	mrc	p15, 0, r0, c0, c1, 0		@ read ID_PFR0 for ThumbEE
 	and	r0, r0, #(0xf << 12)		@ ThumbEE enabled field

