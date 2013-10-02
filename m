Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753276Ab3JBOGf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 10:06:35 -0400
Received: from mail-ea0-f169.google.com ([209.85.215.169]:60773 "EHLO
	mail-ea0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753072Ab3JBOGa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 10:06:30 -0400
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org, gleb@redhat.com
Subject: [PATCH 3/3] KVM: x86: only copy XSAVE state for the supported features
Date: Wed,  2 Oct 2013 16:06:16 +0200
Message-Id: <1380722776-12358-4-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1380722776-12358-1-git-send-email-pbonzini@redhat.com>
References: <1380722776-12358-1-git-send-email-pbonzini@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This makes the interface more deterministic for userspace, which can expect
(after configuring only the features it supports) to get exactly the same
state from the kernel, independent of the host CPU and kernel version.

Suggested-by: Gleb Natapov <gleb@redhat.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/include/asm/kvm_host.h |  1 +
 arch/x86/kvm/cpuid.c            | 28 ++++++++++++++++++++++++++--
 arch/x86/kvm/x86.c              | 11 +++++++----
 3 files changed, 34 insertions(+), 6 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 35d10d1..52110d0 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -390,6 +390,7 @@ struct kvm_vcpu_arch {
 	struct fpu guest_fpu;
 	u64 xcr0;
 	u64 guest_supported_xcr0;
+	u32 guest_xstate_size;
 
 	struct kvm_pio_request pio;
 	void *pio_data;
diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 5a5ff94..0a1e3b8 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -23,6 +23,26 @@
 #include "mmu.h"
 #include "trace.h"
 
+static u32 xstate_required_size(u64 xstate_bv)
+{
+	int feature_bit = 0;
+	u32 ret = XSAVE_HDR_SIZE + XSAVE_HDR_OFFSET;
+
+	xstate_bv &= ~XSTATE_FPSSE;
+	while (xstate_bv) {
+		if (xstate_bv & 0x1) {
+		        u32 eax, ebx, ecx, edx;
+		        cpuid_count(0xD, feature_bit, &eax, &ebx, &ecx, &edx);
+			ret = max(ret, eax + ebx);
+		}
+
+		xstate_bv >>= 1;
+		feature_bit++;
+	}
+
+	return ret;
+}
+
 void kvm_update_cpuid(struct kvm_vcpu *vcpu)
 {
 	struct kvm_cpuid_entry2 *best;
@@ -47,12 +67,16 @@ void kvm_update_cpuid(struct kvm_vcpu *vcpu)
 	}
 
 	best = kvm_find_cpuid_entry(vcpu, 0xD, 0);
-	if (!best)
+	if (!best) {
 		vcpu->arch.guest_supported_xcr0 = 0;
-	else
+		vcpu->arch.guest_xstate_size = XSAVE_HDR_SIZE + XSAVE_HDR_OFFSET;
+	} else {
 		vcpu->arch.guest_supported_xcr0 =
 			(best->eax | ((u64)best->edx << 32)) &
 			host_xcr0 & KVM_SUPPORTED_XCR0;
+		vcpu->arch.guest_xstate_size =
+			xstate_required_size(vcpu->arch.guest_supported_xcr0);
+	}
 
 	kvm_pmu_cpuid_update(vcpu);
 }
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 7d5c520..e8e2d09 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2984,11 +2984,13 @@ static int kvm_vcpu_ioctl_x86_set_debugregs(struct kvm_vcpu *vcpu,
 static void kvm_vcpu_ioctl_x86_get_xsave(struct kvm_vcpu *vcpu,
 					 struct kvm_xsave *guest_xsave)
 {
-	if (cpu_has_xsave)
+	if (cpu_has_xsave) {
 		memcpy(guest_xsave->region,
 			&vcpu->arch.guest_fpu.state->xsave,
-			xstate_size);
-	else {
+			vcpu->arch.guest_xstate_size);
+		*(u64 *)&guest_xsave->region[XSAVE_HDR_OFFSET / sizeof(u32)] &=
+			vcpu->arch.guest_supported_xcr0 | XSTATE_FPSSE;
+	} else {
 		memcpy(guest_xsave->region,
 			&vcpu->arch.guest_fpu.state->fxsave,
 			sizeof(struct i387_fxsave_struct));
@@ -3014,7 +3016,7 @@ static int kvm_vcpu_ioctl_x86_set_xsave(struct kvm_vcpu *vcpu,
 		if (xstate_bv & ~host_xcr0)
 			return -EINVAL;
 		memcpy(&vcpu->arch.guest_fpu.state->xsave,
-			guest_xsave->region, xstate_size);
+			guest_xsave->region, vcpu->arch.guest_xstate_size);
 	} else {
 		if (xstate_bv & ~XSTATE_FPSSE)
 			return -EINVAL;
@@ -6951,6 +6953,7 @@ int kvm_arch_vcpu_init(struct kvm_vcpu *vcpu)
 	vcpu->arch.pv_time_enabled = false;
 
 	vcpu->arch.guest_supported_xcr0 = 0;
+	vcpu->arch.guest_xstate_size = XSAVE_HDR_SIZE + XSAVE_HDR_OFFSET;
 
 	kvm_async_pf_hash_reset(vcpu);
 	kvm_pmu_init(vcpu);
-- 
1.8.3.1

