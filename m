Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753020AbaH2Kbi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 06:31:38 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:46149 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752861AbaH2Kbe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 06:31:34 -0400
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc: David Matlack <dmatlack@google.com>, stable@vger.kernel.org,
        Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Subject: [PATCH 3/3] kvm: x86: fix stale mmio cache bug
Date: Fri, 29 Aug 2014 12:31:17 +0200
Message-Id: <1409308277-4021-4-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1409308277-4021-1-git-send-email-pbonzini@redhat.com>
References: <1409308277-4021-1-git-send-email-pbonzini@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Matlack <dmatlack@google.com>

The following events can lead to an incorrect KVM_EXIT_MMIO bubbling
up to userspace:

(1) Guest accesses gpa X without a memory slot. The gfn is cached in
struct kvm_vcpu_arch (mmio_gfn). On Intel EPT-enabled hosts, KVM sets
the SPTE write-execute-noread so that future accesses cause
EPT_MISCONFIGs.

(2) Host userspace creates a memory slot via KVM_SET_USER_MEMORY_REGION
covering the page just accessed.

(3) Guest attempts to read or write to gpa X again. On Intel, this
generates an EPT_MISCONFIG. The memory slot generation number that
was incremented in (2) would normally take care of this but we fast
path mmio faults through quickly_check_mmio_pf(), which only checks
the per-vcpu mmio cache. Since we hit the cache, KVM passes a
KVM_EXIT_MMIO up to userspace.

This patch fixes the issue by using the memslot generation number
to validate the mmio cache.

[ xiaoguangrong: adjust the code to make it simpler for stable-tree fix. ]

Cc: stable@vger.kernel.org
Signed-off-by: David Matlack <dmatlack@google.com>
Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/include/asm/kvm_host.h |  1 +
 arch/x86/kvm/mmu.c              |  2 +-
 arch/x86/kvm/x86.h              | 20 +++++++++++++++-----
 3 files changed, 17 insertions(+), 6 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 031e1dcea5a6..a9dc893dcf1b 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -481,6 +481,7 @@ struct kvm_vcpu_arch {
 	u64 mmio_gva;
 	unsigned access;
 	gfn_t mmio_gfn;
+	u64 mmio_gen;
 
 	struct kvm_pmu pmu;
 
diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 96515957ba82..1cd2a5fbde07 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -3162,7 +3162,7 @@ static void mmu_sync_roots(struct kvm_vcpu *vcpu)
 	if (!VALID_PAGE(vcpu->arch.mmu.root_hpa))
 		return;
 
-	vcpu_clear_mmio_info(vcpu, ~0ul);
+	vcpu_clear_mmio_info(vcpu, MMIO_GVA_ANY);
 	kvm_mmu_audit(vcpu, AUDIT_PRE_SYNC);
 	if (vcpu->arch.mmu.root_level == PT64_ROOT_LEVEL) {
 		hpa_t root = vcpu->arch.mmu.root_hpa;
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index 306a1b77581f..985fb2c006fa 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -88,15 +88,23 @@ static inline void vcpu_cache_mmio_info(struct kvm_vcpu *vcpu,
 	vcpu->arch.mmio_gva = gva & PAGE_MASK;
 	vcpu->arch.access = access;
 	vcpu->arch.mmio_gfn = gfn;
+	vcpu->arch.mmio_gen = kvm_memslots(vcpu->kvm)->generation;
+}
+
+static inline bool vcpu_match_mmio_gen(struct kvm_vcpu *vcpu)
+{
+	return vcpu->arch.mmio_gen == kvm_memslots(vcpu->kvm)->generation;
 }
 
 /*
- * Clear the mmio cache info for the given gva,
- * specially, if gva is ~0ul, we clear all mmio cache info.
+ * Clear the mmio cache info for the given gva. If gva is MMIO_GVA_ANY, we
+ * clear all mmio cache info.
  */
+#define MMIO_GVA_ANY (~(gva_t)0)
+
 static inline void vcpu_clear_mmio_info(struct kvm_vcpu *vcpu, gva_t gva)
 {
-	if (gva != (~0ul) && vcpu->arch.mmio_gva != (gva & PAGE_MASK))
+	if (gva != MMIO_GVA_ANY && vcpu->arch.mmio_gva != (gva & PAGE_MASK))
 		return;
 
 	vcpu->arch.mmio_gva = 0;
@@ -104,7 +112,8 @@ static inline void vcpu_clear_mmio_info(struct kvm_vcpu *vcpu, gva_t gva)
 
 static inline bool vcpu_match_mmio_gva(struct kvm_vcpu *vcpu, unsigned long gva)
 {
-	if (vcpu->arch.mmio_gva && vcpu->arch.mmio_gva == (gva & PAGE_MASK))
+	if (vcpu_match_mmio_gen(vcpu) && vcpu->arch.mmio_gva &&
+	      vcpu->arch.mmio_gva == (gva & PAGE_MASK))
 		return true;
 
 	return false;
@@ -112,7 +121,8 @@ static inline bool vcpu_match_mmio_gva(struct kvm_vcpu *vcpu, unsigned long gva)
 
 static inline bool vcpu_match_mmio_gpa(struct kvm_vcpu *vcpu, gpa_t gpa)
 {
-	if (vcpu->arch.mmio_gfn && vcpu->arch.mmio_gfn == gpa >> PAGE_SHIFT)
+	if (vcpu_match_mmio_gen(vcpu) && vcpu->arch.mmio_gfn &&
+	      vcpu->arch.mmio_gfn == gpa >> PAGE_SHIFT)
 		return true;
 
 	return false;
-- 
1.8.3.1

