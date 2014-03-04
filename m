Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758381AbaCDViM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 16:38:12 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:40787 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755596AbaCDUCu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 15:02:50 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Albin Tonnerre <Albin.Tonnerre@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>
Subject: [PATCH 3.13 017/172] ARM: 7953/1: mm: ensure TLB invalidation is complete before enabling MMU
Date: Tue,  4 Mar 2014 12:01:41 -0800
Message-Id: <20140304200300.277491034@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140304200259.626667112@linuxfoundation.org>
References: <20140304200259.626667112@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/mm/proc-v6.S |    3 ++-
 arch/arm/mm/proc-v7.S |    2 +-
 2 files changed, 3 insertions(+), 2 deletions(-)

--- a/arch/arm/mm/proc-v6.S
+++ b/arch/arm/mm/proc-v6.S
@@ -208,7 +208,6 @@ __v6_setup:
 	mcr	p15, 0, r0, c7, c14, 0		@ clean+invalidate D cache
 	mcr	p15, 0, r0, c7, c5, 0		@ invalidate I cache
 	mcr	p15, 0, r0, c7, c15, 0		@ clean+invalidate cache
-	mcr	p15, 0, r0, c7, c10, 4		@ drain write buffer
 #ifdef CONFIG_MMU
 	mcr	p15, 0, r0, c8, c7, 0		@ invalidate I + D TLBs
 	mcr	p15, 0, r0, c2, c0, 2		@ TTB control register
@@ -218,6 +217,8 @@ __v6_setup:
 	ALT_UP(orr	r8, r8, #TTB_FLAGS_UP)
 	mcr	p15, 0, r8, c2, c0, 1		@ load TTB1
 #endif /* CONFIG_MMU */
+	mcr	p15, 0, r0, c7, c10, 4		@ drain write buffer and
+						@ complete invalidations
 	adr	r5, v6_crval
 	ldmia	r5, {r5, r6}
  ARM_BE8(orr	r6, r6, #1 << 25)		@ big-endian page tables
--- a/arch/arm/mm/proc-v7.S
+++ b/arch/arm/mm/proc-v7.S
@@ -351,7 +351,6 @@ __v7_setup:
 
 4:	mov	r10, #0
 	mcr	p15, 0, r10, c7, c5, 0		@ I+BTB cache invalidate
-	dsb
 #ifdef CONFIG_MMU
 	mcr	p15, 0, r10, c8, c7, 0		@ invalidate I + D TLBs
 	v7_ttb_setup r10, r4, r8, r5		@ TTBCR, TTBRx setup
@@ -360,6 +359,7 @@ __v7_setup:
 	mcr	p15, 0, r5, c10, c2, 0		@ write PRRR
 	mcr	p15, 0, r6, c10, c2, 1		@ write NMRR
 #endif
+	dsb					@ Complete invalidations
 #ifndef CONFIG_ARM_THUMBEE
 	mrc	p15, 0, r0, c0, c1, 0		@ read ID_PFR0 for ThumbEE
 	and	r0, r0, #(0xf << 12)		@ ThumbEE enabled field


