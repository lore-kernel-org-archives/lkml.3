Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754282AbaIBPOD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 11:14:03 -0400
Received: from mail-wg0-f41.google.com ([74.125.82.41]:43550 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751821AbaIBPOA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 11:14:00 -0400
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc: jroedel@suse.de, agraf@suse.de, valentine.sinitsyn@gmail.com,
        jan.kiszka@siemens.com, gleb@cloudius-systems.com,
        avi@cloudius-systems.com
Subject: [PATCH 1/4] KVM: x86: reserve bit 8 of non-leaf PDPEs and PML4Es in 64-bit mode on AMD
Date: Tue,  2 Sep 2014 17:13:47 +0200
Message-Id: <1409670830-14544-2-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1409670830-14544-1-git-send-email-pbonzini@redhat.com>
References: <1409670830-14544-1-git-send-email-pbonzini@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bit 8 would be the "global" bit, which does not quite make sense for non-leaf
page table entries.  Intel ignores it; AMD ignores it in PDEs, but reserves it
in PDPEs and PML4Es.  The SVM test is relying on this behavior, so enforce it.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/cpuid.h |  8 ++++++++
 arch/x86/kvm/mmu.c   | 13 +++++++++++--
 2 files changed, 19 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/cpuid.h b/arch/x86/kvm/cpuid.h
index a5380590ab0e..43b33e301e68 100644
--- a/arch/x86/kvm/cpuid.h
+++ b/arch/x86/kvm/cpuid.h
@@ -88,6 +88,14 @@ static inline bool guest_cpuid_has_x2apic(struct kvm_vcpu *vcpu)
 	return best && (best->ecx & bit(X86_FEATURE_X2APIC));
 }
 
+static inline bool guest_cpuid_is_amd(struct kvm_vcpu *vcpu)
+{
+	struct kvm_cpuid_entry2 *best;
+
+	best = kvm_find_cpuid_entry(vcpu, 0, 0);
+	return best && best->ebx == X86EMUL_CPUID_VENDOR_AuthenticAMD_ebx;
+}
+
 static inline bool guest_cpuid_has_gbpages(struct kvm_vcpu *vcpu)
 {
 	struct kvm_cpuid_entry2 *best;
diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 6b6df0c5be3d..5b93a597e0c8 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -3512,6 +3512,7 @@ static void reset_rsvds_bits_mask(struct kvm_vcpu *vcpu,
 	int maxphyaddr = cpuid_maxphyaddr(vcpu);
 	u64 exb_bit_rsvd = 0;
 	u64 gbpages_bit_rsvd = 0;
+	u64 nonleaf_bit8_rsvd = 0;
 
 	context->bad_mt_xwr = 0;
 
@@ -3519,6 +3520,14 @@ static void reset_rsvds_bits_mask(struct kvm_vcpu *vcpu,
 		exb_bit_rsvd = rsvd_bits(63, 63);
 	if (!guest_cpuid_has_gbpages(vcpu))
 		gbpages_bit_rsvd = rsvd_bits(7, 7);
+
+	/*
+	 * Non-leaf PML4Es and PDPEs reserve bit 8 (which would be the G bit for
+	 * leaf entries) on AMD CPUs only.
+	 */
+	if (guest_cpuid_is_amd(vcpu))
+		nonleaf_bit8_rsvd = rsvd_bits(8, 8);
+
 	switch (context->root_level) {
 	case PT32_ROOT_LEVEL:
 		/* no rsvd bits for 2 level 4K page table entries */
@@ -3553,9 +3562,9 @@ static void reset_rsvds_bits_mask(struct kvm_vcpu *vcpu,
 		break;
 	case PT64_ROOT_LEVEL:
 		context->rsvd_bits_mask[0][3] = exb_bit_rsvd |
-			rsvd_bits(maxphyaddr, 51) | rsvd_bits(7, 7);
+			nonleaf_bit8_rsvd | rsvd_bits(7, 7) | rsvd_bits(maxphyaddr, 51);
 		context->rsvd_bits_mask[0][2] = exb_bit_rsvd |
-			gbpages_bit_rsvd | rsvd_bits(maxphyaddr, 51);
+			nonleaf_bit8_rsvd | gbpages_bit_rsvd | rsvd_bits(maxphyaddr, 51);
 		context->rsvd_bits_mask[0][1] = exb_bit_rsvd |
 			rsvd_bits(maxphyaddr, 51);
 		context->rsvd_bits_mask[0][0] = exb_bit_rsvd |
-- 
1.8.3.1


