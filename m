Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751969AbaHLFCw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 01:02:52 -0400
Received: from e28smtp04.in.ibm.com ([122.248.162.4]:51240 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751550AbaHLFCh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 01:02:37 -0400
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
To: gleb@redhat.com
Cc: avi.kivity@gmail.com, mtosatti@redhat.com, pbonzini@redhat.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        David Matlack <dmatlack@google.com>, stable@vger.kernel.org,
        Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Subject: [PATCH 2/2] kvm: x86: fix stale mmio cache bug
Date: Tue, 12 Aug 2014 13:02:01 +0800
Message-Id: <1407819721-27833-2-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1407819721-27833-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
References: <1407819721-27833-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14081205-5564-0000-0000-000000B43BA7
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
---
 arch/x86/include/asm/kvm_host.h |  1 +
 arch/x86/kvm/mmu.c              |  4 ++--
 arch/x86/kvm/mmu.h              |  2 ++
 arch/x86/kvm/x86.h              | 19 +++++++++++++++----
 4 files changed, 20 insertions(+), 6 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 5724601..58fa3ab 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -481,6 +481,7 @@ struct kvm_vcpu_arch {
 	u64 mmio_gva;
 	unsigned access;
 	gfn_t mmio_gfn;
+	unsigned int mmio_gen;
 
 	struct kvm_pmu pmu;
 
diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 9314678..e00fbfe 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -234,7 +234,7 @@ static unsigned int get_mmio_spte_generation(u64 spte)
 	return gen;
 }
 
-static unsigned int kvm_current_mmio_generation(struct kvm *kvm)
+unsigned int kvm_current_mmio_generation(struct kvm *kvm)
 {
 	/*
 	 * Init kvm generation close to MMIO_MAX_GEN to easily test the
@@ -3163,7 +3163,7 @@ static void mmu_sync_roots(struct kvm_vcpu *vcpu)
 	if (!VALID_PAGE(vcpu->arch.mmu.root_hpa))
 		return;
 
-	vcpu_clear_mmio_info(vcpu, ~0ul);
+	vcpu_clear_mmio_info(vcpu, MMIO_GVA_ANY);
 	kvm_mmu_audit(vcpu, AUDIT_PRE_SYNC);
 	if (vcpu->arch.mmu.root_level == PT64_ROOT_LEVEL) {
 		hpa_t root = vcpu->arch.mmu.root_hpa;
diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
index b982112..e2d902a 100644
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -76,6 +76,8 @@ enum {
 };
 
 int handle_mmio_page_fault_common(struct kvm_vcpu *vcpu, u64 addr, bool direct);
+unsigned int kvm_current_mmio_generation(struct kvm *kvm);
+
 void kvm_init_shadow_mmu(struct kvm_vcpu *vcpu, struct kvm_mmu *context);
 void kvm_init_shadow_ept_mmu(struct kvm_vcpu *vcpu, struct kvm_mmu *context,
 		bool execonly);
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index 306a1b7..ffd03b7 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -3,6 +3,7 @@
 
 #include <linux/kvm_host.h>
 #include "kvm_cache_regs.h"
+#include "mmu.h"
 
 static inline void kvm_clear_exception_queue(struct kvm_vcpu *vcpu)
 {
@@ -88,15 +89,23 @@ static inline void vcpu_cache_mmio_info(struct kvm_vcpu *vcpu,
 	vcpu->arch.mmio_gva = gva & PAGE_MASK;
 	vcpu->arch.access = access;
 	vcpu->arch.mmio_gfn = gfn;
+	vcpu->arch.mmio_gen = kvm_current_mmio_generation(vcpu->kvm);
+}
+
+static inline bool vcpu_match_mmio_gen(struct kvm_vcpu *vcpu)
+{
+	return vcpu->arch.mmio_gen == kvm_current_mmio_generation(vcpu->kvm);
 }
 
 /*
  * Clear the mmio cache info for the given gva,
- * specially, if gva is ~0ul, we clear all mmio cache info.
+ * specially, if gva is ~MMIO_GVA_ANY, we clear all mmio cache info.
  */
+#define MMIO_GVA_ANY	~((gva_t)0)
+
 static inline void vcpu_clear_mmio_info(struct kvm_vcpu *vcpu, gva_t gva)
 {
-	if (gva != (~0ul) && vcpu->arch.mmio_gva != (gva & PAGE_MASK))
+	if (gva != MMIO_GVA_ANY && vcpu->arch.mmio_gva != (gva & PAGE_MASK))
 		return;
 
 	vcpu->arch.mmio_gva = 0;
@@ -104,7 +113,8 @@ static inline void vcpu_clear_mmio_info(struct kvm_vcpu *vcpu, gva_t gva)
 
 static inline bool vcpu_match_mmio_gva(struct kvm_vcpu *vcpu, unsigned long gva)
 {
-	if (vcpu->arch.mmio_gva && vcpu->arch.mmio_gva == (gva & PAGE_MASK))
+	if (vcpu_match_mmio_gen(vcpu) && vcpu->arch.mmio_gva &&
+	      vcpu->arch.mmio_gva == (gva & PAGE_MASK))
 		return true;
 
 	return false;
@@ -112,7 +122,8 @@ static inline bool vcpu_match_mmio_gva(struct kvm_vcpu *vcpu, unsigned long gva)
 
 static inline bool vcpu_match_mmio_gpa(struct kvm_vcpu *vcpu, gpa_t gpa)
 {
-	if (vcpu->arch.mmio_gfn && vcpu->arch.mmio_gfn == gpa >> PAGE_SHIFT)
+	if (vcpu_match_mmio_gen(vcpu) && vcpu->arch.mmio_gfn &&
+	      vcpu->arch.mmio_gfn == gpa >> PAGE_SHIFT)
 		return true;
 
 	return false;
-- 
1.8.3.1

