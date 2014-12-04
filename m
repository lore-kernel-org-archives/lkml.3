Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932537AbaLDP5i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 10:57:38 -0500
Received: from mail-wi0-f179.google.com ([209.85.212.179]:35455 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932450AbaLDP53 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 10:57:29 -0500
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc: rkrcmar@redhat.com, Wanpeng Li <wanpeng.li@linux.intel.com>,
        Fenghua Yu <fenghua.yu@intel.com>, stable@vger.kernel.org,
        "H. Peter Anvin" <hpa@linux.intel.com>
Subject: [PATCH 2/9] KVM: x86: support XSAVES usage in the host
Date: Thu,  4 Dec 2014 16:57:07 +0100
Message-Id: <1417708634-24333-3-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1417708634-24333-1-git-send-email-pbonzini@redhat.com>
References: <1417708634-24333-1-git-send-email-pbonzini@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Userspace is expecting non-compacted format for KVM_GET_XSAVE, but
struct xsave_struct might be using the compacted format.  Convert
in order to preserve userspace ABI.

Likewise, userspace is passing non-compacted format for KVM_SET_XSAVE
but the kernel will pass it to XRSTORS, and we need to convert back.

Fixes: f31a9f7c71691569359fa7fb8b0acaa44bce0324
Cc: Fenghua Yu <fenghua.yu@intel.com>
Cc: stable@vger.kernel.org
Cc: H. Peter Anvin <hpa@linux.intel.com>
Reported-by: Nadav Amit <namit@cs.technion.ac.il>
Tested-by: Nadav Amit <namit@cs.technion.ac.il>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/x86.c | 90 +++++++++++++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 83 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 08b5657e57ed..c259814200bd 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3132,15 +3132,89 @@ static int kvm_vcpu_ioctl_x86_set_debugregs(struct kvm_vcpu *vcpu,
 	return 0;
 }
 
+#define XSTATE_COMPACTION_ENABLED (1ULL << 63)
+
+static void fill_xsave(u8 *dest, struct kvm_vcpu *vcpu)
+{
+	struct xsave_struct *xsave = &vcpu->arch.guest_fpu.state->xsave;
+	u64 xstate_bv = xsave->xsave_hdr.xstate_bv;
+	u64 valid;
+
+	/*
+	 * Copy legacy XSAVE area, to avoid complications with CPUID
+	 * leaves 0 and 1 in the loop below.
+	 */
+	memcpy(dest, xsave, XSAVE_HDR_OFFSET);
+
+	/* Set XSTATE_BV */
+	*(u64 *)(dest + XSAVE_HDR_OFFSET) = xstate_bv;
+
+	/*
+	 * Copy each region from the possibly compacted offset to the
+	 * non-compacted offset.
+	 */
+	valid = xstate_bv & ~XSTATE_FPSSE;
+	while (valid) {
+		u64 feature = valid & -valid;
+		int index = fls64(feature) - 1;
+		void *src = get_xsave_addr(xsave, feature);
+
+		if (src) {
+			u32 size, offset, ecx, edx;
+			cpuid_count(XSTATE_CPUID, index,
+				    &size, &offset, &ecx, &edx);
+			memcpy(dest + offset, src, size);
+		}
+
+		valid -= feature;
+	}
+}
+
+static void load_xsave(struct kvm_vcpu *vcpu, u8 *src)
+{
+	struct xsave_struct *xsave = &vcpu->arch.guest_fpu.state->xsave;
+	u64 xstate_bv = *(u64 *)(src + XSAVE_HDR_OFFSET);
+	u64 valid;
+
+	/*
+	 * Copy legacy XSAVE area, to avoid complications with CPUID
+	 * leaves 0 and 1 in the loop below.
+	 */
+	memcpy(xsave, src, XSAVE_HDR_OFFSET);
+
+	/* Set XSTATE_BV and possibly XCOMP_BV.  */
+	xsave->xsave_hdr.xstate_bv = xstate_bv;
+	if (cpu_has_xsaves)
+		xsave->xsave_hdr.xcomp_bv = host_xcr0 | XSTATE_COMPACTION_ENABLED;
+
+	/*
+	 * Copy each region from the non-compacted offset to the
+	 * possibly compacted offset.
+	 */
+	valid = xstate_bv & ~XSTATE_FPSSE;
+	while (valid) {
+		u64 feature = valid & -valid;
+		int index = fls64(feature) - 1;
+		void *dest = get_xsave_addr(xsave, feature);
+
+		if (dest) {
+			u32 size, offset, ecx, edx;
+			cpuid_count(XSTATE_CPUID, index,
+				    &size, &offset, &ecx, &edx);
+			memcpy(dest, src + offset, size);
+		} else
+			WARN_ON_ONCE(1);
+
+		valid -= feature;
+	}
+}
+
 static void kvm_vcpu_ioctl_x86_get_xsave(struct kvm_vcpu *vcpu,
 					 struct kvm_xsave *guest_xsave)
 {
 	if (cpu_has_xsave) {
-		memcpy(guest_xsave->region,
-			&vcpu->arch.guest_fpu.state->xsave,
-			vcpu->arch.guest_xstate_size);
-		*(u64 *)&guest_xsave->region[XSAVE_HDR_OFFSET / sizeof(u32)] &=
-			vcpu->arch.guest_supported_xcr0 | XSTATE_FPSSE;
+		memset(guest_xsave, 0, sizeof(struct kvm_xsave));
+		fill_xsave((u8 *) guest_xsave->region, vcpu);
 	} else {
 		memcpy(guest_xsave->region,
 			&vcpu->arch.guest_fpu.state->fxsave,
@@ -3164,8 +3238,7 @@ static int kvm_vcpu_ioctl_x86_set_xsave(struct kvm_vcpu *vcpu,
 		 */
 		if (xstate_bv & ~kvm_supported_xcr0())
 			return -EINVAL;
-		memcpy(&vcpu->arch.guest_fpu.state->xsave,
-			guest_xsave->region, vcpu->arch.guest_xstate_size);
+		load_xsave(vcpu, (u8 *)guest_xsave->region);
 	} else {
 		if (xstate_bv & ~XSTATE_FPSSE)
 			return -EINVAL;
@@ -6882,6 +6955,9 @@ int fx_init(struct kvm_vcpu *vcpu)
 		return err;
 
 	fpu_finit(&vcpu->arch.guest_fpu);
+	if (cpu_has_xsaves)
+		vcpu->arch.guest_fpu.state->xsave.xsave_hdr.xcomp_bv =
+			host_xcr0 | XSTATE_COMPACTION_ENABLED;
 
 	/*
 	 * Ensure guest xcr0 is valid for loading
-- 
1.8.3.1


