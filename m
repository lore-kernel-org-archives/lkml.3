Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932790AbaEGMeW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 08:34:22 -0400
Received: from mailgw12.technion.ac.il ([132.68.225.12]:33313 "EHLO
	mailgw12.technion.ac.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751487AbaEGMdF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 08:33:05 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AisCAKsmalOERCABjGdsb2JhbABayUUBgRoWDgEBASc8giYBBSdSEFFXBxKIQclKhXEXjlIHhD8EigKkJYFC
X-IPAS-Result: AisCAKsmalOERCABjGdsb2JhbABayUUBgRoWDgEBASc8giYBBSdSEFFXBxKIQclKhXEXjlIHhD8EigKkJYFC
X-IronPort-AV: E=Sophos;i="4.97,1003,1389736800"; 
   d="scan'208";a="105236360"
From: Nadav Amit <namit@cs.technion.ac.il>
To: mtosatti@redhat.com, pbonzini@redhat.com, hpa@zytor.com
Cc: gleb@kernel.org, tglx@linutronix.de, mingo@redhat.com, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Nadav Amit <namit@cs.technion.ac.il>
Subject: [PATCH 3/5] KVM: x86: Mark bit 7 in long-mode PDPTE according to 1GB pages support
Date: Wed,  7 May 2014 15:32:50 +0300
Message-Id: <1399465972-4026-4-git-send-email-namit@cs.technion.ac.il>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1399465972-4026-1-git-send-email-namit@cs.technion.ac.il>
References: <1399465972-4026-1-git-send-email-namit@cs.technion.ac.il>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In long-mode, bit 7 in the PDPTE is not reserved only if 1GB pages are
supported by the CPU. Currently the bit is considered by KVM as always
reserved.

Signed-off-by: Nadav Amit <namit@cs.technion.ac.il>
---
 arch/x86/kvm/cpuid.h | 7 +++++++
 arch/x86/kvm/mmu.c   | 8 ++++++--
 2 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/cpuid.h b/arch/x86/kvm/cpuid.h
index eeecbed..f908731 100644
--- a/arch/x86/kvm/cpuid.h
+++ b/arch/x86/kvm/cpuid.h
@@ -88,4 +88,11 @@ static inline bool guest_cpuid_has_x2apic(struct kvm_vcpu *vcpu)
 	return best && (best->ecx & bit(X86_FEATURE_X2APIC));
 }
 
+static inline bool guest_cpuid_has_gbpages(struct kvm_vcpu *vcpu)
+{
+	struct kvm_cpuid_entry2 *best;
+
+	best = kvm_find_cpuid_entry(vcpu, 0x80000001, 0);
+	return best && (best->edx & bit(X86_FEATURE_GBPAGES));
+}
 #endif
diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 65f2400..9314678 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -22,6 +22,7 @@
 #include "mmu.h"
 #include "x86.h"
 #include "kvm_cache_regs.h"
+#include "cpuid.h"
 
 #include <linux/kvm_host.h>
 #include <linux/types.h>
@@ -3516,11 +3517,14 @@ static void reset_rsvds_bits_mask(struct kvm_vcpu *vcpu,
 {
 	int maxphyaddr = cpuid_maxphyaddr(vcpu);
 	u64 exb_bit_rsvd = 0;
+	u64 gbpages_bit_rsvd = 0;
 
 	context->bad_mt_xwr = 0;
 
 	if (!context->nx)
 		exb_bit_rsvd = rsvd_bits(63, 63);
+	if (!guest_cpuid_has_gbpages(vcpu))
+		gbpages_bit_rsvd = rsvd_bits(7, 7);
 	switch (context->root_level) {
 	case PT32_ROOT_LEVEL:
 		/* no rsvd bits for 2 level 4K page table entries */
@@ -3557,14 +3561,14 @@ static void reset_rsvds_bits_mask(struct kvm_vcpu *vcpu,
 		context->rsvd_bits_mask[0][3] = exb_bit_rsvd |
 			rsvd_bits(maxphyaddr, 51) | rsvd_bits(7, 7);
 		context->rsvd_bits_mask[0][2] = exb_bit_rsvd |
-			rsvd_bits(maxphyaddr, 51) | rsvd_bits(7, 7);
+			gbpages_bit_rsvd | rsvd_bits(maxphyaddr, 51);
 		context->rsvd_bits_mask[0][1] = exb_bit_rsvd |
 			rsvd_bits(maxphyaddr, 51);
 		context->rsvd_bits_mask[0][0] = exb_bit_rsvd |
 			rsvd_bits(maxphyaddr, 51);
 		context->rsvd_bits_mask[1][3] = context->rsvd_bits_mask[0][3];
 		context->rsvd_bits_mask[1][2] = exb_bit_rsvd |
-			rsvd_bits(maxphyaddr, 51) |
+			gbpages_bit_rsvd | rsvd_bits(maxphyaddr, 51) |
 			rsvd_bits(13, 29);
 		context->rsvd_bits_mask[1][1] = exb_bit_rsvd |
 			rsvd_bits(maxphyaddr, 51) |
-- 
1.9.1

