Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756466Ab3IPO1P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 10:27:15 -0400
Received: from mail-ea0-f174.google.com ([209.85.215.174]:39272 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755068Ab3IPO0m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 10:26:42 -0400
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: gleb@redhat.com
Subject: [PATCH v2 3/3] KVM: x86: only copy XSAVE state for the supported features
Date: Mon, 16 Sep 2013 16:26:31 +0200
Message-Id: <1379341591-6538-4-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1379341591-6538-1-git-send-email-pbonzini@redhat.com>
References: <1379341591-6538-1-git-send-email-pbonzini@redhat.com>
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
 arch/x86/kvm/cpuid.c            | 28 +++++++++++++++++++++++++++-
 arch/x86/kvm/x86.c              |  9 ++++++---
 3 files changed, 34 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 1553542..a21dcee 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -390,6 +390,7 @@ struct kvm_vcpu_arch {
 	struct fpu guest_fpu;
 	u64 xcr0;
 	u64 supported_xcr0;
+	u32 xstate_size;
 
 	struct kvm_pio_request pio;
 	void *pio_data;
diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index fa754a8..00f5923e 100644
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
@@ -46,12 +66,18 @@ void kvm_update_cpuid(struct kvm_vcpu *vcpu)
 			apic->lapic_timer.timer_mode_mask = 1 << 17;
 	}
 
+	/*
+	 * Adjust which states will be returned by KVM_GET_XSAVE.
+	 * x87 and SSE state is always returned, the others are only
+	 * returned if they are exposed to the guest.
+	 */
 	best = kvm_find_cpuid_entry(vcpu, 0xD, 0);
 	if (!best)
 		return;
 	vcpu->arch.supported_xcr0 =
-		(best->eax | ((u64)best->edx << 32)) &
+		(best->eax | ((u64)best->edx << 32) | XSTATE_FPSSE) &
 		host_xcr0 & KVM_SUPPORTED_XCR0;
+	vcpu->arch.xstate_size = xstate_required_size(vcpu->arch.supported_xcr0);
 
 	kvm_pmu_cpuid_update(vcpu);
 }
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index cc8c403..7c36099 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2984,11 +2984,13 @@ static int kvm_vcpu_ioctl_x86_set_debugregs(struct kvm_vcpu *vcpu,
 static void kvm_vcpu_ioctl_x86_get_xsave(struct kvm_vcpu *vcpu,
 					 struct kvm_xsave *guest_xsave)
 {
-	if (cpu_has_xsave)
+	if (cpu_has_xsave) {
+		*(u64 *)&guest_xsave->region[XSAVE_HDR_OFFSET / sizeof(u32)] &=
+			vcpu->arch.supported_xcr0;
 		memcpy(guest_xsave->region,
 			&vcpu->arch.guest_fpu.state->xsave,
-			xstate_size);
-	else {
+			vcpu->arch.xstate_size);
+	} else {
 		memcpy(guest_xsave->region,
 			&vcpu->arch.guest_fpu.state->fxsave,
 			sizeof(struct i387_fxsave_struct));
@@ -6950,6 +6952,7 @@ int kvm_arch_vcpu_init(struct kvm_vcpu *vcpu)
 	vcpu->arch.pv_time_enabled = false;
 
 	vcpu->arch.supported_xcr0 = XSTATE_FPSSE;
+	vcpu->arch.xstate_size = XSAVE_HDR_SIZE + XSAVE_HDR_OFFSET;
 
 	kvm_async_pf_hash_reset(vcpu);
 	kvm_pmu_init(vcpu);
-- 
1.8.3.1

