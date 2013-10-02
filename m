Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753377Ab3JBOHB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 10:07:01 -0400
Received: from mail-ea0-f180.google.com ([209.85.215.180]:62965 "EHLO
	mail-ea0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752425Ab3JBOG2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 10:06:28 -0400
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org, gleb@redhat.com
Subject: [PATCH 2/3] KVM: x86: prevent setting unsupported XSAVE states
Date: Wed,  2 Oct 2013 16:06:15 +0200
Message-Id: <1380722776-12358-3-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1380722776-12358-1-git-send-email-pbonzini@redhat.com>
References: <1380722776-12358-1-git-send-email-pbonzini@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A guest can still attempt to save and restore XSAVE states even if they
have been masked in CPUID leaf 0Dh.  This usually is not visible to
the guest, but is still wrong: "Any attempt to set a reserved bit (as
determined by the contents of EAX and EDX after executing CPUID with
EAX=0DH, ECX= 0H) in XCR0 for a given processor will result in a #GP
exception".

The patch also performs the same checks as __kvm_set_xcr in KVM_SET_XSAVE.
This catches migration from newer to older kernel/processor before the
guest starts running.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/include/asm/kvm_host.h |  1 +
 arch/x86/kvm/cpuid.c            |  8 ++++++++
 arch/x86/kvm/x86.c              | 18 +++++++++++++++---
 3 files changed, 24 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index c76ff74..35d10d1 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -389,6 +389,7 @@ struct kvm_vcpu_arch {
 
 	struct fpu guest_fpu;
 	u64 xcr0;
+	u64 guest_supported_xcr0;
 
 	struct kvm_pio_request pio;
 	void *pio_data;
diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index a03a9fa..5a5ff94 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -46,6 +46,14 @@ void kvm_update_cpuid(struct kvm_vcpu *vcpu)
 			apic->lapic_timer.timer_mode_mask = 1 << 17;
 	}
 
+	best = kvm_find_cpuid_entry(vcpu, 0xD, 0);
+	if (!best)
+		vcpu->arch.guest_supported_xcr0 = 0;
+	else
+		vcpu->arch.guest_supported_xcr0 =
+			(best->eax | ((u64)best->edx << 32)) &
+			host_xcr0 & KVM_SUPPORTED_XCR0;
+
 	kvm_pmu_cpuid_update(vcpu);
 }
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 187f824..7d5c520 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -586,7 +586,7 @@ int __kvm_set_xcr(struct kvm_vcpu *vcpu, u32 index, u64 xcr)
 		return 1;
 	if ((xcr0 & XSTATE_YMM) && !(xcr0 & XSTATE_SSE))
 		return 1;
-	if (xcr0 & ~host_xcr0)
+	if (xcr0 & ~vcpu->arch.guest_supported_xcr0)
 		return 1;
 	kvm_put_guest_xcr0(vcpu);
 	vcpu->arch.xcr0 = xcr0;
@@ -3003,10 +3003,19 @@ static int kvm_vcpu_ioctl_x86_set_xsave(struct kvm_vcpu *vcpu,
 	u64 xstate_bv =
 		*(u64 *)&guest_xsave->region[XSAVE_HDR_OFFSET / sizeof(u32)];
 
-	if (cpu_has_xsave)
+	if (cpu_has_xsave) {
+		/*
+		 * Here we allow setting states that are not present in
+		 * CPUID leaf 0xD, index 0, EDX:EAX.  This is for compatibility
+		 * with old userspace.
+		 */
+		if (xstate_bv & ~KVM_SUPPORTED_XCR0)
+			return -EINVAL;
+		if (xstate_bv & ~host_xcr0)
+			return -EINVAL;
 		memcpy(&vcpu->arch.guest_fpu.state->xsave,
 			guest_xsave->region, xstate_size);
-	else {
+	} else {
 		if (xstate_bv & ~XSTATE_FPSSE)
 			return -EINVAL;
 		memcpy(&vcpu->arch.guest_fpu.state->fxsave,
@@ -6940,6 +6949,9 @@ int kvm_arch_vcpu_init(struct kvm_vcpu *vcpu)
 
 	vcpu->arch.ia32_tsc_adjust_msr = 0x0;
 	vcpu->arch.pv_time_enabled = false;
+
+	vcpu->arch.guest_supported_xcr0 = 0;
+
 	kvm_async_pf_hash_reset(vcpu);
 	kvm_pmu_init(vcpu);
 
-- 
1.8.3.1


