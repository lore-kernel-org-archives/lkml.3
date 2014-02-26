Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751896AbaBZL6p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 06:58:45 -0500
Received: from mail-ea0-f176.google.com ([209.85.215.176]:57935 "EHLO
	mail-ea0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751476AbaBZL6k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 06:58:40 -0500
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org, mtosatti@redhat.com,
        Liu Jinsong <jinsong.liu@intel.com>, gleb@kernel.org,
        jan.kiszka@siemens.com
Subject: [PATCH v2 1/2] KVM: x86: introduce kvm_supported_xcr0()
Date: Wed, 26 Feb 2014 12:58:25 +0100
Message-Id: <1393415906-15556-2-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1393415906-15556-1-git-send-email-pbonzini@redhat.com>
References: <1393415906-15556-1-git-send-email-pbonzini@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

XSAVE support for KVM is already using host_xcr0 & KVM_SUPPORTED_XCR0 as
a "dynamic" version of KVM_SUPPORTED_XCR0.

However, this is not enough because the MPX bits should not be presented
to the guest unless kvm_x86_ops confirms the support.  So, replace all
instances of host_xcr0 & KVM_SUPPORTED_XCR0 with a new function
kvm_supported_xcr0() that also has this check.

Note that here:

		if (xstate_bv & ~KVM_SUPPORTED_XCR0)
			return -EINVAL;
		if (xstate_bv & ~host_cr0)
			return -EINVAL;

the code is equivalent to

		if ((xstate_bv & ~KVM_SUPPORTED_XCR0) ||
		    (xstate_bv & ~host_cr0)
			return -EINVAL;

i.e. "xstate_bv & (~KVM_SUPPORTED_XCR0 | ~host_cr0)" which is in turn
equal to "xstate_bv & ~(KVM_SUPPORTED_XCR0 & host_cr0)".  So we should
also use the new function there.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/cpuid.c | 27 ++++++++++++++++-----------
 arch/x86/kvm/x86.c   |  4 +---
 arch/x86/kvm/x86.h   |  2 ++
 3 files changed, 19 insertions(+), 14 deletions(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index ddc8a7e165df..18aefb4d0927 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -43,6 +43,16 @@ static u32 xstate_required_size(u64 xstate_bv)
 	return ret;
 }
 
+u64 kvm_supported_xcr0(void)
+{
+	u64 xcr0 = KVM_SUPPORTED_XCR0 & host_xcr0;
+
+	if (!kvm_x86_ops->mpx_supported || !kvm_x86_ops->mpx_supported())
+		xcr0 &= ~(XSTATE_BNDREGS | XSTATE_BNDCSR);
+
+	return xcr0;
+}
+
 void kvm_update_cpuid(struct kvm_vcpu *vcpu)
 {
 	struct kvm_cpuid_entry2 *best;
@@ -73,7 +83,7 @@ void kvm_update_cpuid(struct kvm_vcpu *vcpu)
 	} else {
 		vcpu->arch.guest_supported_xcr0 =
 			(best->eax | ((u64)best->edx << 32)) &
-			host_xcr0 & KVM_SUPPORTED_XCR0;
+			kvm_supported_xcr0();
 		vcpu->arch.guest_xstate_size = best->ebx =
 			xstate_required_size(vcpu->arch.xcr0);
 	}
@@ -210,13 +220,6 @@ static void do_cpuid_1_ent(struct kvm_cpuid_entry2 *entry, u32 function,
 	entry->flags = 0;
 }
 
-static bool supported_xcr0_bit(unsigned bit)
-{
-	u64 mask = ((u64)1 << bit);
-
-	return mask & KVM_SUPPORTED_XCR0 & host_xcr0;
-}
-
 #define F(x) bit(X86_FEATURE_##x)
 
 static int __do_cpuid_ent_emulated(struct kvm_cpuid_entry2 *entry,
@@ -439,16 +442,18 @@ static inline int __do_cpuid_ent(struct kvm_cpuid_entry2 *entry, u32 function,
 	}
 	case 0xd: {
 		int idx, i;
+		u64 supported = kvm_supported_xcr0();
 
-		entry->eax &= host_xcr0 & KVM_SUPPORTED_XCR0;
-		entry->edx &= (host_xcr0 & KVM_SUPPORTED_XCR0) >> 32;
+		entry->eax &= supported;
+		entry->edx &= supported >> 32;
 		entry->flags |= KVM_CPUID_FLAG_SIGNIFCANT_INDEX;
 		for (idx = 1, i = 1; idx < 64; ++idx) {
+			u64 mask = ((u64)1 << idx);
 			if (*nent >= maxnent)
 				goto out;
 
 			do_cpuid_1_ent(&entry[i], function, idx);
-			if (entry[i].eax == 0 || !supported_xcr0_bit(idx))
+			if (entry[i].eax == 0 || !(supported & mask))
 				continue;
 			entry[i].flags |=
 			       KVM_CPUID_FLAG_SIGNIFCANT_INDEX;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 4cca45853dfe..109985016389 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3048,9 +3048,7 @@ static int kvm_vcpu_ioctl_x86_set_xsave(struct kvm_vcpu *vcpu,
 		 * CPUID leaf 0xD, index 0, EDX:EAX.  This is for compatibility
 		 * with old userspace.
 		 */
-		if (xstate_bv & ~KVM_SUPPORTED_XCR0)
-			return -EINVAL;
-		if (xstate_bv & ~host_xcr0)
+		if (xstate_bv & ~kvm_supported_xcr0())
 			return -EINVAL;
 		memcpy(&vcpu->arch.guest_fpu.state->xsave,
 			guest_xsave->region, vcpu->arch.guest_xstate_size);
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index 392ecbff0030..8c97bac9a895 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -126,6 +126,8 @@ int kvm_write_guest_virt_system(struct x86_emulate_ctxt *ctxt,
 				| XSTATE_BNDREGS | XSTATE_BNDCSR)
 extern u64 host_xcr0;
 
+extern u64 kvm_supported_xcr0(void);
+
 extern unsigned int min_timer_period_us;
 
 extern struct static_key kvm_no_apic_vcpu;
-- 
1.8.3.1


