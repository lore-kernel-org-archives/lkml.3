Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932246Ab3FGXLu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 19:11:50 -0400
Received: from mail-ie0-f178.google.com ([209.85.223.178]:48669 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756156Ab3FGXDt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 19:03:49 -0400
From: David Daney <ddaney.cavm@gmail.com>
To: linux-mips@linux-mips.org, ralf@linux-mips.org, kvm@vger.kernel.org,
        Sanjay Lal <sanjayl@kymasys.com>
Cc: linux-kernel@vger.kernel.org, David Daney <david.daney@cavium.com>
Subject: [PATCH 10/31] mips/kvm: Implement ioctls to get and set FPU registers.
Date: Fri,  7 Jun 2013 16:03:14 -0700
Message-Id: <1370646215-6543-11-git-send-email-ddaney.cavm@gmail.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1370646215-6543-1-git-send-email-ddaney.cavm@gmail.com>
References: <1370646215-6543-1-git-send-email-ddaney.cavm@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Daney <david.daney@cavium.com>

The current implementation does nothing with them, but future MIPSVZ
work need them.  Also add the asm-offsets accessors for the fields.

Signed-off-by: David Daney <david.daney@cavium.com>
---
 arch/mips/include/asm/kvm_host.h |  8 ++++++++
 arch/mips/kernel/asm-offsets.c   |  8 ++++++++
 arch/mips/kvm/kvm_mips.c         | 26 ++++++++++++++++++++++++--
 3 files changed, 40 insertions(+), 2 deletions(-)

diff --git a/arch/mips/include/asm/kvm_host.h b/arch/mips/include/asm/kvm_host.h
index 16013c7..505b804 100644
--- a/arch/mips/include/asm/kvm_host.h
+++ b/arch/mips/include/asm/kvm_host.h
@@ -102,6 +102,14 @@ struct kvm_vcpu_arch {
 	unsigned long lo;
 	unsigned long epc;
 
+	/* FPU state */
+	u64 fpr[32];
+	u32 fir;
+	u32 fccr;
+	u32 fexr;
+	u32 fenr;
+	u32 fcsr;
+
 	void *impl;
 };
 
diff --git a/arch/mips/kernel/asm-offsets.c b/arch/mips/kernel/asm-offsets.c
index 5a9222e..03bf363 100644
--- a/arch/mips/kernel/asm-offsets.c
+++ b/arch/mips/kernel/asm-offsets.c
@@ -377,6 +377,14 @@ void output_kvm_defines(void)
 	OFFSET(KVM_VCPU_ARCH_HI, kvm_vcpu, arch.hi);
 	OFFSET(KVM_VCPU_ARCH_EPC, kvm_vcpu, arch.epc);
 	OFFSET(KVM_VCPU_ARCH_IMPL, kvm_vcpu, arch.impl);
+	BLANK();
+	OFFSET(KVM_VCPU_ARCH_FPR,	kvm_vcpu, arch.fpr);
+	OFFSET(KVM_VCPU_ARCH_FIR,	kvm_vcpu, arch.fir);
+	OFFSET(KVM_VCPU_ARCH_FCCR,	kvm_vcpu, arch.fccr);
+	OFFSET(KVM_VCPU_ARCH_FEXR,	kvm_vcpu, arch.fexr);
+	OFFSET(KVM_VCPU_ARCH_FENR,	kvm_vcpu, arch.fenr);
+	OFFSET(KVM_VCPU_ARCH_FCSR,	kvm_vcpu, arch.fcsr);
+	BLANK();
 
 	OFFSET(KVM_MIPS_VCPU_TE_HOST_EBASE, kvm_mips_vcpu_te, host_ebase);
 	OFFSET(KVM_MIPS_VCPU_TE_GUEST_EBASE, kvm_mips_vcpu_te, guest_ebase);
diff --git a/arch/mips/kvm/kvm_mips.c b/arch/mips/kvm/kvm_mips.c
index 041caad..18c8dc8 100644
--- a/arch/mips/kvm/kvm_mips.c
+++ b/arch/mips/kvm/kvm_mips.c
@@ -465,12 +465,34 @@ int kvm_arch_vcpu_postcreate(struct kvm_vcpu *vcpu)
 
 int kvm_arch_vcpu_ioctl_get_fpu(struct kvm_vcpu *vcpu, struct kvm_fpu *fpu)
 {
-	return -ENOIOCTLCMD;
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(vcpu->arch.fpr); i++)
+		fpu->fpr[i] = vcpu->arch.fpr[i];
+
+	fpu->fir = vcpu->arch.fir;
+	fpu->fccr = vcpu->arch.fccr;
+	fpu->fexr = vcpu->arch.fexr;
+	fpu->fenr = vcpu->arch.fenr;
+	fpu->fcsr = vcpu->arch.fcsr;
+
+	return 0;
 }
 
 int kvm_arch_vcpu_ioctl_set_fpu(struct kvm_vcpu *vcpu, struct kvm_fpu *fpu)
 {
-	return -ENOIOCTLCMD;
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(vcpu->arch.fpr); i++)
+		vcpu->arch.fpr[i] = fpu->fpr[i];
+
+	vcpu->arch.fir = fpu->fir;
+	vcpu->arch.fccr = fpu->fccr;
+	vcpu->arch.fexr = fpu->fexr;
+	vcpu->arch.fenr = fpu->fenr;
+	vcpu->arch.fcsr = fpu->fcsr;
+
+	return 0;
 }
 
 int kvm_arch_vcpu_fault(struct kvm_vcpu *vcpu, struct vm_fault *vmf)
-- 
1.7.11.7

