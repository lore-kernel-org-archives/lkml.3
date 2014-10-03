Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761444AbaJDAtm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 20:49:42 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:44709 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754935AbaJCVch (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 17:32:37 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Mark Rutland <mark.rutland@arm.com>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Pranavkumar Sawargaonkar <pranavkumar@linaro.org>,
        Anup Patel <anup.patel@linaro.org>,
        Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PATCH 3.16 043/357] ARM/ARM64: KVM: Nuke Hyp-mode tlbs before enabling MMU
Date: Fri,  3 Oct 2014 14:27:09 -0700
Message-Id: <20141003212934.754645501@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141003212933.458851516@linuxfoundation.org>
References: <20141003212933.458851516@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/kvm/init.S       |    4 ++++
 arch/arm64/kvm/hyp-init.S |    4 ++++
 2 files changed, 8 insertions(+)

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
--- a/arch/arm64/kvm/hyp-init.S
+++ b/arch/arm64/kvm/hyp-init.S
@@ -80,6 +80,10 @@ __do_hyp_init:
 	msr	mair_el2, x4
 	isb
 
+	/* Invalidate the stale TLBs from Bootloader */
+	tlbi	alle2
+	dsb	sy
+
 	mrs	x4, sctlr_el2
 	and	x4, x4, #SCTLR_EL2_EE	// preserve endianness of EL2
 	ldr	x5, =SCTLR_EL2_FLAGS


