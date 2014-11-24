Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754360AbaKXQoN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 11:44:13 -0500
Received: from mail-wg0-f51.google.com ([74.125.82.51]:46593 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754185AbaKXQn5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 11:43:57 -0500
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc: wanpeng.li@linux.intel.com, namit@cs.technion.ac.il, hpa@linux.intel.com,
        Fenghua Yu <fenghua.yu@intel.com>
Subject: [CFT PATCH v2 2/2] KVM: x86: support XSAVES usage in the host
Date: Mon, 24 Nov 2014 17:43:34 +0100
Message-Id: <1416847414-22253-3-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1416847414-22253-1-git-send-email-pbonzini@redhat.com>
References: <1416847414-22253-1-git-send-email-pbonzini@redhat.com>
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
Cc: H. Peter Anvin <hpa@linux.intel.com>
Cc: Nadav Amit <namit@cs.technion.ac.il>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/x86.c | 87 +++++++++++++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 80 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 08b5657e57ed..373b0ab9a32e 100644
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
+	u64 xstate_bv = vcpu->arch.guest_supported_xcr0 | XSTATE_FPSSE;
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
-- 
1.8.3.1

