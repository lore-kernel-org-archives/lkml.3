Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753416Ab3ISS3i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Sep 2013 14:29:38 -0400
Received: from mail-vc0-f169.google.com ([209.85.220.169]:59202 "EHLO
	mail-vc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752225Ab3ISS3g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Sep 2013 14:29:36 -0400
Date: Thu, 19 Sep 2013 11:29:28 -0700
From: Kim Phillips <kim.phillips@linaro.org>
To: stable@vger.kernel.org
Cc: linaro-networking@linaro.org, patches@linaro.org,
        linux-kernel@vger.kernel.org,
        Christoffer Dall <christoffer.dall@linaro.org>,
        Gleb Natapov <gleb@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>,
        Russell King <linux@arm.linux.org.uk>,
        Jonghwan Choi <jhbird.choi@samsung.com>, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH linux-stable-3.10.y] ARM: KVM: Fix 64-bit coprocessor
 handling
Message-Id: <20130919112928.9ce56f1a150c276a8070747e@linaro.org>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.17; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Christoffer Dall <christoffer.dall@linaro.org>

commit 240e99cbd00aa541b572480e3ea7ecb0d480bc79 upstream.

Fixes booting a guest OS on a v3.10 host kernel.

Without this, on an arndale board, qemu bails with:

Initial read of kernel register state failed
kvm_init_vcpu failed: Invalid argument

Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
Signed-off-by: Kim Phillips <kim.phillips@linaro.org>
Cc: Gleb Natapov <gleb@redhat.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Jonghwan Choi <jhbird.choi@samsung.com>
Cc: kvmarm@lists.cs.columbia.edu
Cc: kvm@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
Cc: <stable@vger.kernel.org> # 3.10.x
---
resumbission of:

https://lkml.org/lkml/2013/8/23/50

albeit with perhaps a better rationale than 'looks like it should be in
the 3.10-stable tree'.

 arch/arm/kvm/coproc.c     | 26 +++++++++++++++++++-------
 arch/arm/kvm/coproc.h     |  3 +++
 arch/arm/kvm/coproc_a15.c |  6 +++++-
 3 files changed, 27 insertions(+), 8 deletions(-)

diff --git a/arch/arm/kvm/coproc.c b/arch/arm/kvm/coproc.c
index 4a51990..db9cf69 100644
--- a/arch/arm/kvm/coproc.c
+++ b/arch/arm/kvm/coproc.c
@@ -146,7 +146,11 @@ static bool pm_fake(struct kvm_vcpu *vcpu,
 #define access_pmintenclr pm_fake
 
 /* Architected CP15 registers.
- * Important: Must be sorted ascending by CRn, CRM, Op1, Op2
+ * CRn denotes the primary register number, but is copied to the CRm in the
+ * user space API for 64-bit register access in line with the terminology used
+ * in the ARM ARM.
+ * Important: Must be sorted ascending by CRn, CRM, Op1, Op2 and with 64-bit
+ *            registers preceding 32-bit ones.
  */
 static const struct coproc_reg cp15_regs[] = {
 	/* CSSELR: swapped by interrupt.S. */
@@ -154,8 +158,8 @@ static const struct coproc_reg cp15_regs[] = {
 			NULL, reset_unknown, c0_CSSELR },
 
 	/* TTBR0/TTBR1: swapped by interrupt.S. */
-	{ CRm( 2), Op1( 0), is64, NULL, reset_unknown64, c2_TTBR0 },
-	{ CRm( 2), Op1( 1), is64, NULL, reset_unknown64, c2_TTBR1 },
+	{ CRm64( 2), Op1( 0), is64, NULL, reset_unknown64, c2_TTBR0 },
+	{ CRm64( 2), Op1( 1), is64, NULL, reset_unknown64, c2_TTBR1 },
 
 	/* TTBCR: swapped by interrupt.S. */
 	{ CRn( 2), CRm( 0), Op1( 0), Op2( 2), is32,
@@ -182,7 +186,7 @@ static const struct coproc_reg cp15_regs[] = {
 			NULL, reset_unknown, c6_IFAR },
 
 	/* PAR swapped by interrupt.S */
-	{ CRn( 7), Op1( 0), is64, NULL, reset_unknown64, c7_PAR },
+	{ CRm64( 7), Op1( 0), is64, NULL, reset_unknown64, c7_PAR },
 
 	/*
 	 * DC{C,I,CI}SW operations:
@@ -399,12 +403,13 @@ static bool index_to_params(u64 id, struct coproc_params *params)
 			      | KVM_REG_ARM_OPC1_MASK))
 			return false;
 		params->is_64bit = true;
-		params->CRm = ((id & KVM_REG_ARM_CRM_MASK)
+		/* CRm to CRn: see cp15_to_index for details */
+		params->CRn = ((id & KVM_REG_ARM_CRM_MASK)
 			       >> KVM_REG_ARM_CRM_SHIFT);
 		params->Op1 = ((id & KVM_REG_ARM_OPC1_MASK)
 			       >> KVM_REG_ARM_OPC1_SHIFT);
 		params->Op2 = 0;
-		params->CRn = 0;
+		params->CRm = 0;
 		return true;
 	default:
 		return false;
@@ -898,7 +903,14 @@ static u64 cp15_to_index(const struct coproc_reg *reg)
 	if (reg->is_64) {
 		val |= KVM_REG_SIZE_U64;
 		val |= (reg->Op1 << KVM_REG_ARM_OPC1_SHIFT);
-		val |= (reg->CRm << KVM_REG_ARM_CRM_SHIFT);
+		/*
+		 * CRn always denotes the primary coproc. reg. nr. for the
+		 * in-kernel representation, but the user space API uses the
+		 * CRm for the encoding, because it is modelled after the
+		 * MRRC/MCRR instructions: see the ARM ARM rev. c page
+		 * B3-1445
+		 */
+		val |= (reg->CRn << KVM_REG_ARM_CRM_SHIFT);
 	} else {
 		val |= KVM_REG_SIZE_U32;
 		val |= (reg->Op1 << KVM_REG_ARM_OPC1_SHIFT);
diff --git a/arch/arm/kvm/coproc.h b/arch/arm/kvm/coproc.h
index b7301d3..0461d5c 100644
--- a/arch/arm/kvm/coproc.h
+++ b/arch/arm/kvm/coproc.h
@@ -135,6 +135,8 @@ static inline int cmp_reg(const struct coproc_reg *i1,
 		return -1;
 	if (i1->CRn != i2->CRn)
 		return i1->CRn - i2->CRn;
+	if (i1->is_64 != i2->is_64)
+		return i2->is_64 - i1->is_64;
 	if (i1->CRm != i2->CRm)
 		return i1->CRm - i2->CRm;
 	if (i1->Op1 != i2->Op1)
@@ -145,6 +147,7 @@ static inline int cmp_reg(const struct coproc_reg *i1,
 
 #define CRn(_x)		.CRn = _x
 #define CRm(_x) 	.CRm = _x
+#define CRm64(_x)       .CRn = _x, .CRm = 0
 #define Op1(_x) 	.Op1 = _x
 #define Op2(_x) 	.Op2 = _x
 #define is64		.is_64 = true
diff --git a/arch/arm/kvm/coproc_a15.c b/arch/arm/kvm/coproc_a15.c
index 685063a..cf93472 100644
--- a/arch/arm/kvm/coproc_a15.c
+++ b/arch/arm/kvm/coproc_a15.c
@@ -114,7 +114,11 @@ static bool access_l2ectlr(struct kvm_vcpu *vcpu,
 
 /*
  * A15-specific CP15 registers.
- * Important: Must be sorted ascending by CRn, CRM, Op1, Op2
+ * CRn denotes the primary register number, but is copied to the CRm in the
+ * user space API for 64-bit register access in line with the terminology used
+ * in the ARM ARM.
+ * Important: Must be sorted ascending by CRn, CRM, Op1, Op2 and with 64-bit
+ *            registers preceding 32-bit ones.
  */
 static const struct coproc_reg a15_regs[] = {
 	/* MPIDR: we use VMPIDR for guest access. */
-- 
1.8.4

