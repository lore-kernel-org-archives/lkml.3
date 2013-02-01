Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757019Ab3BANIJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 08:08:09 -0500
Received: from mail.kernel.org ([198.145.19.201]:44355 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754044Ab3BANIF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 08:08:05 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Dave Martin <dave.martin@linaro.org>,
        Harry Liebel <harry.liebel@arm.com>,
        Marc Zyngier <marc.zyngier@arm.com>, Will Deacon <will.deacon@arm.com>
Subject: [ 15/89] ARM: virt: simplify __hyp_stub_install epilog
Date: Fri,  1 Feb 2013 14:07:30 +0100
Message-Id: <20130201130208.552428547@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.2.434.g9a6c84e.dirty
In-Reply-To: <20130201130207.444989281@linuxfoundation.org>
References: <20130201130207.444989281@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marc Zyngier <marc.zyngier@arm.com>

commit d01723479e6a6c70c83295f7847477a016d5e14a upstream.

__hyp_stub_install duplicates quite a bit of safe_svcmode_maskall
by forcing the CPU back to SVC. This is unnecessary, as
safe_svcmode_maskall is called just after.

Furthermore, the way we build SPSR_hyp is buggy as we fail to mask
the interrupts, leading to interesting behaviours on TC2 + UEFI.

The fix is to simply remove this code and rely on safe_svcmode_maskall
to do the right thing.

Reviewed-by: Dave Martin <dave.martin@linaro.org>
Reported-by: Harry Liebel <harry.liebel@arm.com>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/kernel/hyp-stub.S |   12 +++---------
 1 file changed, 3 insertions(+), 9 deletions(-)

--- a/arch/arm/kernel/hyp-stub.S
+++ b/arch/arm/kernel/hyp-stub.S
@@ -120,7 +120,8 @@ ENTRY(__hyp_stub_install_secondary)
  * Eventually, CPU-specific code might be needed -- assume not for now
  *
  * This code relies on the "eret" instruction to synchronize the
- * various coprocessor accesses.
+ * various coprocessor accesses. This is done when we switch to SVC
+ * (see safe_svcmode_maskall).
  */
 	@ Now install the hypervisor stub:
 	adr	r7, __hyp_stub_vectors
@@ -155,14 +156,7 @@ THUMB(	orr	r7, #(1 << 30)	)	@ HSCTLR.TE
 1:
 #endif
 
-	bic	r7, r4, #MODE_MASK
-	orr	r7, r7, #SVC_MODE
-THUMB(	orr	r7, r7, #PSR_T_BIT	)
-	msr	spsr_cxsf, r7		@ This is SPSR_hyp.
-
-	__MSR_ELR_HYP(14)		@ msr elr_hyp, lr
-	__ERET				@ return, switching to SVC mode
-					@ The boot CPU mode is left in r4.
+	bx	lr			@ The boot CPU mode is left in r4.
 ENDPROC(__hyp_stub_install_secondary)
 
 __hyp_stub_do_trap:


