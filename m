Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752071AbaKUSbd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 13:31:33 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:51586 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751355AbaKUSba (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 13:31:30 -0500
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc: Wanpeng Li <wanpeng.li@linux.intel.com>, Fenghua Yu <fenghua.yu@intel.com>,
        stable@vger.kernel.org, Nadav Amit <namit@cs.technion.ac.il>
Subject: [CFT PATCH 2/2] KVM: x86: support XSAVES usage in the host
Date: Fri, 21 Nov 2014 19:31:18 +0100
Message-Id: <1416594678-13011-3-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1416594678-13011-1-git-send-email-pbonzini@redhat.com>
References: <1416594678-13011-1-git-send-email-pbonzini@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Userspace is expecting non-compacted format for KVM_GET_XSAVE, but
struct xsave_struct might be using the compacted format.  Convert
in order to preserve userspace ABI.

Fixes: f31a9f7c71691569359fa7fb8b0acaa44bce0324
Cc: Fenghua Yu <fenghua.yu@intel.com>
Cc: stable@vger.kernel.org
Cc: Nadav Amit <namit@cs.technion.ac.il>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/x86.c | 48 +++++++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 43 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 5337039427c8..7e8a20e5615a 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3131,15 +3131,53 @@ static int kvm_vcpu_ioctl_x86_set_debugregs(struct kvm_vcpu *vcpu,
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
+	if (xsave->xsave_hdr.xcomp_bv & XSTATE_COMPACTION_ENABLED)
+		valid &= xsave->xsave_hdr.xcomp_bv;
+
+	while (valid) {
+		u64 feature = valid & -valid;
+		int index = fls64(feature) - 1;
+		void *src = get_xsave_addr(xsave, feature);
+
+	        if (src) {
+			u32 size, offset, ecx, edx;
+			cpuid_count(XSTATE_CPUID, index,
+				    &size, &offset, &ecx, &edx);
+	                memcpy(dest + offset, src, size);
+		}
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
-- 
1.8.3.1

