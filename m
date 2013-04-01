Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759138Ab3DAJ6h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 05:58:37 -0400
Received: from e28smtp02.in.ibm.com ([122.248.162.2]:48097 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758530Ab3DAJ5G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 05:57:06 -0400
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
To: mtosatti@redhat.com
Cc: gleb@redhat.com, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Subject: [PATCH v2 4/6] KVM: MMU: fast invalid all mmio sptes
Date: Mon,  1 Apr 2013 17:56:47 +0800
Message-Id: <1364810209-25954-5-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1364810209-25954-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
References: <1364810209-25954-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13040109-5816-0000-0000-0000075CAC33
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch tries to introduce a very simple and scale way to invalid all
mmio sptes - it need not walk any shadow pages and hold mmu-lock

KVM maintains a global mmio invalid generation-number which is stored in
kvm->memslots.generation and every mmio spte stores the current global
generation-number into his available bits when it is created

When KVM need zap all mmio sptes, it just simply increase the global
generation-number. When guests do mmio access, KVM intercepts a MMIO #PF
then it walks the shadow page table and get the mmio spte. If the
generation-number on the spte does not equal the global generation-number,
it will go to the normal #PF handler to update the mmio spte

Since 19 bits are used to store generation-number on mmio spte, we zap all
mmio sptes when the number is round

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
---
 arch/x86/include/asm/kvm_host.h |    2 +-
 arch/x86/kvm/mmu.c              |   54 +++++++++++++++++++++++++++++++++------
 arch/x86/kvm/mmu.h              |    3 ++
 arch/x86/kvm/paging_tmpl.h      |    7 +++-
 arch/x86/kvm/vmx.c              |    4 +++
 arch/x86/kvm/x86.c              |    3 +-
 6 files changed, 60 insertions(+), 13 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index b5a6462..6c1e642 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -767,7 +767,7 @@ void kvm_mmu_write_protect_pt_masked(struct kvm *kvm,
 				     struct kvm_memory_slot *slot,
 				     gfn_t gfn_offset, unsigned long mask);
 void kvm_mmu_zap_all(struct kvm *kvm);
-void kvm_mmu_zap_mmio_sptes(struct kvm *kvm);
+void kvm_mmu_invalid_mmio_sptes(struct kvm *kvm);
 unsigned int kvm_mmu_calculate_mmu_pages(struct kvm *kvm);
 void kvm_mmu_change_mmu_pages(struct kvm *kvm, unsigned int kvm_nr_mmu_pages);
 
diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 31c5586..1020152 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -205,9 +205,11 @@ EXPORT_SYMBOL_GPL(kvm_mmu_set_mmio_spte_mask);
 #define MMIO_SPTE_GEN_LOW_SHIFT		3
 #define MMIO_SPTE_GEN_HIGH_SHIFT	52
 
+#define MMIO_GEN_SHIFT			19
 #define MMIO_GEN_LOW_SHIFT		9
 #define MMIO_GEN_LOW_MASK		((1 << MMIO_GEN_LOW_SHIFT) - 1)
-#define MMIO_MAX_GEN			((1 << 19) - 1)
+#define MMIO_GEN_MASK			((1 << MMIO_GEN_SHIFT) - 1)
+#define MMIO_MAX_GEN			((1 << MMIO_GEN_SHIFT) - 1)
 
 static u64 generation_mmio_spte_mask(unsigned int gen)
 {
@@ -231,15 +233,21 @@ static unsigned int get_mmio_spte_generation(u64 spte)
 	return gen;
 }
 
+static unsigned int kvm_current_mmio_generation(struct kvm *kvm)
+{
+	return kvm_memslots(kvm)->generation & MMIO_GEN_MASK;
+}
+
 static void mark_mmio_spte(struct kvm *kvm, u64 *sptep, u64 gfn,
 			   unsigned access)
 {
-	u64 mask = generation_mmio_spte_mask(0);
+	unsigned int gen = kvm_current_mmio_generation(kvm);
+	u64 mask = generation_mmio_spte_mask(gen);
 
 	access &= ACC_WRITE_MASK | ACC_USER_MASK;
 	mask |= shadow_mmio_mask | access | gfn << PAGE_SHIFT;
 
-	trace_mark_mmio_spte(sptep, gfn, access, 0);
+	trace_mark_mmio_spte(sptep, gfn, access, gen);
 	mmu_spte_set(sptep, mask);
 }
 
@@ -269,6 +277,12 @@ static bool set_mmio_spte(struct kvm *kvm, u64 *sptep, gfn_t gfn,
 	return false;
 }
 
+static bool check_mmio_spte(struct kvm *kvm, u64 spte)
+{
+	return get_mmio_spte_generation(spte) ==
+		      kvm_current_mmio_generation(kvm);
+}
+
 static inline u64 rsvd_bits(int s, int e)
 {
 	return ((1ULL << (e - s + 1)) - 1) << s;
@@ -3195,6 +3209,9 @@ int handle_mmio_page_fault_common(struct kvm_vcpu *vcpu, u64 addr, bool direct)
 		gfn_t gfn = get_mmio_spte_gfn(spte);
 		unsigned access = get_mmio_spte_access(spte);
 
+		if (unlikely(!check_mmio_spte(vcpu->kvm, spte)))
+			return RET_MMIO_PF_INVALID;
+
 		if (direct)
 			addr = 0;
 
@@ -3236,8 +3253,12 @@ static int nonpaging_page_fault(struct kvm_vcpu *vcpu, gva_t gva,
 
 	pgprintk("%s: gva %lx error %x\n", __func__, gva, error_code);
 
-	if (unlikely(error_code & PFERR_RSVD_MASK))
-		return handle_mmio_page_fault(vcpu, gva, error_code, true);
+	if (unlikely(error_code & PFERR_RSVD_MASK)) {
+		r = handle_mmio_page_fault(vcpu, gva, error_code, true);
+
+		if (likely(r != RET_MMIO_PF_INVALID))
+			return r;
+	}
 
 	r = mmu_topup_memory_caches(vcpu);
 	if (r)
@@ -3313,8 +3334,12 @@ static int tdp_page_fault(struct kvm_vcpu *vcpu, gva_t gpa, u32 error_code,
 	ASSERT(vcpu);
 	ASSERT(VALID_PAGE(vcpu->arch.mmu.root_hpa));
 
-	if (unlikely(error_code & PFERR_RSVD_MASK))
-		return handle_mmio_page_fault(vcpu, gpa, error_code, true);
+	if (unlikely(error_code & PFERR_RSVD_MASK)) {
+		r = handle_mmio_page_fault(vcpu, gpa, error_code, true);
+
+		if (likely(r != RET_MMIO_PF_INVALID))
+			return r;
+	}
 
 	r = mmu_topup_memory_caches(vcpu);
 	if (r)
@@ -4231,7 +4256,7 @@ restart:
 	spin_unlock(&kvm->mmu_lock);
 }
 
-void kvm_mmu_zap_mmio_sptes(struct kvm *kvm)
+static void kvm_mmu_zap_mmio_sptes(struct kvm *kvm)
 {
 	struct kvm_mmu_page *sp, *node;
 	LIST_HEAD(invalid_list);
@@ -4249,6 +4274,19 @@ restart:
 	spin_unlock(&kvm->mmu_lock);
 }
 
+void kvm_mmu_invalid_mmio_sptes(struct kvm *kvm)
+{
+	/*
+	 * The very rare case: if the generation-number is round,
+	 * zap all shadow pages.
+	 *
+	 * The max value is MMIO_MAX_GEN - 1 since it is not called
+	 * when mark memslot invalid.
+	 */
+	if (unlikely(kvm_current_mmio_generation(kvm) >= (MMIO_MAX_GEN - 1)))
+		kvm_mmu_zap_mmio_sptes(kvm);
+}
+
 static int mmu_shrink(struct shrinker *shrink, struct shrink_control *sc)
 {
 	struct kvm *kvm;
diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
index 6b4ba1e..ffd40d1 100644
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -57,11 +57,14 @@ void kvm_mmu_set_mmio_spte_mask(u64 mmio_mask);
  * Return values of handle_mmio_page_fault_common:
  * RET_MMIO_PF_EMU: it is a real mmio page fault, emulate the instruction
  *		    directly.
+ * RET_MMIO_PF_INVALID: invalid spte is detected then let the real page
+ *			fault path update the mmio spte.
  * RET_MMIO_PF_RETRY: let CPU fault again on the address.
  * RET_MMIO_PF_BUG: bug is detected.
  */
 enum {
 	RET_MMIO_PF_EMU = 1,
+	RET_MMIO_PF_INVALID = 2,
 	RET_MMIO_PF_RETRY = 0,
 	RET_MMIO_PF_BUG = -1
 };
diff --git a/arch/x86/kvm/paging_tmpl.h b/arch/x86/kvm/paging_tmpl.h
index bddc5f6..29766ec 100644
--- a/arch/x86/kvm/paging_tmpl.h
+++ b/arch/x86/kvm/paging_tmpl.h
@@ -552,9 +552,12 @@ static int FNAME(page_fault)(struct kvm_vcpu *vcpu, gva_t addr, u32 error_code,
 
 	pgprintk("%s: addr %lx err %x\n", __func__, addr, error_code);
 
-	if (unlikely(error_code & PFERR_RSVD_MASK))
-		return handle_mmio_page_fault(vcpu, addr, error_code,
+	if (unlikely(error_code & PFERR_RSVD_MASK)) {
+		r = handle_mmio_page_fault(vcpu, addr, error_code,
 					      mmu_is_nested(vcpu));
+		if (likely(r != RET_MMIO_PF_INVALID))
+			return r;
+	};
 
 	r = mmu_topup_memory_caches(vcpu);
 	if (r)
diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index d0f2790..9aa9a54 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -5138,6 +5138,10 @@ static int handle_ept_misconfig(struct kvm_vcpu *vcpu)
 	if (likely(ret == RET_MMIO_PF_EMU))
 		return x86_emulate_instruction(vcpu, gpa, 0, NULL, 0) ==
 					      EMULATE_DONE;
+
+	if (unlikely(ret == RET_MMIO_PF_INVALID))
+		return kvm_mmu_page_fault(vcpu, gpa, 0, NULL, 0);
+
 	if (unlikely(ret == RET_MMIO_PF_RETRY))
 		return 1;
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 12ad5b5..4be4733 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -6994,8 +6994,7 @@ void kvm_arch_commit_memory_region(struct kvm *kvm,
 	 * If memory slot is created, or moved, we need to clear all
 	 * mmio sptes.
 	 */
-	if ((change == KVM_MR_CREATE) || (change == KVM_MR_MOVE))
-		kvm_mmu_zap_mmio_sptes(kvm);
+	kvm_mmu_invalid_mmio_sptes(kvm);
 }
 
 void kvm_arch_flush_shadow_all(struct kvm *kvm)
-- 
1.7.7.6

