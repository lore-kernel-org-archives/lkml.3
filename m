Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753361AbaIPVJv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 17:09:51 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:33117 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751687AbaIPVJu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 17:09:50 -0400
From: Christopher Covington <cov@codeaurora.org>
To: Sonny Rao <sonnyrao@chromium.org>, Will Deacon <will.deacon@arm.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Mark Rutland <Mark.Rutland@arm.com>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Marc Zyngier <marc.zyngier@arm.com>,
        linux-arm-kernel@lists.infradead.org,
        Doug Anderson <dianders@chromium.org>, linux-kernel@vger.kernel.org
Cc: Christopher Covington <cov@codeaurora.org>
Subject: [RFC] arm: Handle starting up in secure mode
Date: Tue, 16 Sep 2014 17:09:16 -0400
Message-Id: <1410901756-20694-1-git-send-email-cov@codeaurora.org>
X-Mailer: git-send-email 1.8.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ARM Linux currently has the most features available to it in hypervisor
(HYP) mode, so switch to it when possible. This can also ensure proper
reset of newer registers such as CNTVOFF.

The permissions on the Non-Secure Access Control Register (NSACR) are
used to probe what the security setting currently is when in supervisor
(SVC) mode.

Signed-off-by: Christopher Covington <cov@codeaurora.org>
---
 arch/arm/kernel/head.S     |  1 +
 arch/arm/kernel/hyp-stub.S | 71 ++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 72 insertions(+)

diff --git a/arch/arm/kernel/head.S b/arch/arm/kernel/head.S
index 664eee8..6fe2387 100644
--- a/arch/arm/kernel/head.S
+++ b/arch/arm/kernel/head.S
@@ -85,6 +85,7 @@ ENTRY(stext)
  THUMB(	.thumb			)	@ switch to Thumb now.
  THUMB(1:			)
 
+	bl	__mon_stub_install
 #ifdef CONFIG_ARM_VIRT_EXT
 	bl	__hyp_stub_install
 #endif
diff --git a/arch/arm/kernel/hyp-stub.S b/arch/arm/kernel/hyp-stub.S
index 2a55373..36d1a9c 100644
--- a/arch/arm/kernel/hyp-stub.S
+++ b/arch/arm/kernel/hyp-stub.S
@@ -20,6 +20,7 @@
 #include <linux/linkage.h>
 #include <asm/assembler.h>
 #include <asm/virt.h>
+#include <asm/opcodes-sec.h>
 
 #ifndef ZIMAGE
 /*
@@ -76,6 +77,64 @@ ENTRY(__boot_cpu_mode)
 #endif /* ZIMAGE */
 
 /*
+ * Detect whether the system is in secure supervisor mode, and if it is,
+ * switch to hypervisor mode by way of secure monitor mode.
+ */
+ENTRY(__mon_stub_install)
+	mrs	r4, cpsr
+	and	r4, r4, #MODE_MASK
+	cmp	r4, #SVC_MODE
+	movne	pc, lr
+
+	/*
+	 * Set things up so that if an NSACR access causes an undefined
+	 * instruction exception, we return. safe_svcmode_maskall called
+	 * just after this will get us back into supervisor mode.
+	 */
+	adr	r4, __mon_stub_vectors
+	mcr	p15, 0, r4, c12, c0, 0	@ set vector base address (VBAR)
+	mov	r4, lr
+
+	/*
+	 * Writing the NSACR will only succeed if we're in a secure mode.
+	 */
+	mrc	p15, 0, r5, c1, c1, 2	@ get non-secure access control (NSACR)
+	mcr	p15, 0, r5, c1, c1, 2	@ set non-secure access control (NSACR)
+
+	/*
+	 * If we get here, we know we're in secure supervisor mode, so make the
+	 * switch to secure monitor mode.
+	 *
+	 * TODO: make sure this doesn't trap to A64 EL3.
+	 */
+	adr	r4, __mon_stub_vectors
+	mcr	p15, 0, r4, c12, c0, 1	@ set monitor vector base (MVBAR)
+	adr	r4, mon_settings
+	__SMC(0)
+
+	/*
+	 * Now, from non-secure supervisor mode, transition to hypervisor mode
+	 * and return via the exception vector.
+	 */
+	mov	r4, lr
+	__HVC(0)
+ENDPROC(__mon_stub_install)
+
+ENTRY(mon_settings)
+	/*
+	 * Prepare for hypervisor mode by setting the HCE and NS bits.
+	 */
+	mrc	p15, 0, r4, c1, c1, 0	@ get secure configuration (SCR)
+	orr	r4, r4, #0x100
+	orr	r4, r4, #1
+	mcr	p15, 0, r4, c1, c1, 0	@ set secure configuration (SCR)
+
+	adr	r4, __mon_stub_vectors
+	mcr	p15, 4, r4, c12, c0, 0	@ set hypervisor vectors (HVBAR)
+	__ERET
+ENDPROC(mon_settings)
+
+/*
  * Hypervisor stub installation functions.
  *
  * These must be called with the MMU and D-cache off.
@@ -209,6 +268,18 @@ ENDPROC(__hyp_set_vectors)
 #endif
 
 .align 5
+__mon_stub_vectors:
+__mon_stub_reset:	W(b)	.
+__mon_stub_und:		mov	pc, r4
+__mon_stub_call:	mov	pc, r4
+__mon_stub_pabort:	W(b)	.
+__mon_stub_dabort:	W(b)	.
+__mon_stub_trap:	mov	pc, r4
+__mon_stub_irq:		W(b)	.
+__mon_stub_fiq:		W(b)	.
+ENDPROC(__hyp_stub_vectors)
+
+.align 5
 __hyp_stub_vectors:
 __hyp_stub_reset:	W(b)	.
 __hyp_stub_und:		W(b)	.
-- 
Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by the Linux Foundation.

