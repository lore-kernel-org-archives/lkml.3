Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754469AbaI3VjS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 17:39:18 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:32949 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754405AbaI3VjL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 17:39:11 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Pranavkumar Sawargaonkar <pranavkumar@linaro.org>,
        Anup Patel <anup.patel@linaro.org>,
        Christoffer Dall <christoffer.dall@linaro.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 086/103] ARM/ARM64: KVM: Nuke Hyp-mode tlbs before enabling MMU
Date: Tue, 30 Sep 2014 14:31:31 -0700
Message-Id: <1412112708-27356-87-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1412112708-27356-1-git-send-email-kamal@canonical.com>
References: <1412112708-27356-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.8 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pranavkumar Sawargaonkar <pranavkumar@linaro.org>

commit f6edbbf36da3a27b298b66c7955fc84e1dcca305 upstream.

X-Gene u-boot runs in EL2 mode with MMU enabled hence we might
have stale EL2 tlb enteris when we enable EL2 MMU on each host CPU.

This can happen on any ARM/ARM64 board running bootloader in
Hyp-mode (or EL2-mode) with MMU enabled.

This patch ensures that we flush all Hyp-mode (or EL2-mode) TLBs
on each host CPU before enabling Hyp-mode (or EL2-mode) MMU.

Tested-by: Mark Rutland <mark.rutland@arm.com>
Reviewed-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Pranavkumar Sawargaonkar <pranavkumar@linaro.org>
Signed-off-by: Anup Patel <anup.patel@linaro.org>
Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 arch/arm/kvm/init.S       | 4 ++++
 arch/arm64/kvm/hyp-init.S | 4 ++++
 2 files changed, 8 insertions(+)

diff --git a/arch/arm/kvm/init.S b/arch/arm/kvm/init.S
index 1b9844d..ee4f744 100644
--- a/arch/arm/kvm/init.S
+++ b/arch/arm/kvm/init.S
@@ -98,6 +98,10 @@ __do_hyp_init:
 	mrc	p15, 0, r0, c10, c2, 1
 	mcr	p15, 4, r0, c10, c2, 1
 
+	@ Invalidate the stale TLBs from Bootloader
+	mcr	p15, 4, r0, c8, c7, 0	@ TLBIALLH
+	dsb	ish
+
 	@ Set the HSCTLR to:
 	@  - ARM/THUMB exceptions: Kernel config (Thumb-2 kernel)
 	@  - Endianness: Kernel config
diff --git a/arch/arm64/kvm/hyp-init.S b/arch/arm64/kvm/hyp-init.S
index 2b0244d..12e26f3 100644
--- a/arch/arm64/kvm/hyp-init.S
+++ b/arch/arm64/kvm/hyp-init.S
@@ -74,6 +74,10 @@ __do_hyp_init:
 	msr	mair_el2, x4
 	isb
 
+	/* Invalidate the stale TLBs from Bootloader */
+	tlbi	alle2
+	dsb	sy
+
 	mrs	x4, sctlr_el2
 	and	x4, x4, #SCTLR_EL2_EE	// preserve endianness of EL2
 	ldr	x5, =SCTLR_EL2_FLAGS
-- 
1.9.1

