Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754777Ab3DPGdm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 02:33:42 -0400
Received: from e28smtp06.in.ibm.com ([122.248.162.6]:41336 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754632Ab3DPGdW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 02:33:22 -0400
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
To: mtosatti@redhat.com
Cc: gleb@redhat.com, avi.kivity@gmail.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Subject: [PATCH v3 04/15] KVM: MMU: abstract memslot rmap related operations
Date: Tue, 16 Apr 2013 14:32:42 +0800
Message-Id: <1366093973-2617-5-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1366093973-2617-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
References: <1366093973-2617-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13041606-9574-0000-0000-0000077A89AB
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce slot_rmap_* functions to abstract memslot rmap related
operations which makes the later patch more clearer

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
---
 arch/x86/kvm/mmu.c       |  108 +++++++++++++++++++++++++++++++++-------------
 arch/x86/kvm/mmu_audit.c |   10 +++--
 2 files changed, 84 insertions(+), 34 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index dcc059c..514f5b1 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -1033,14 +1033,14 @@ static unsigned long *__gfn_to_rmap(gfn_t gfn, int level,
 }
 
 /*
- * Take gfn and return the reverse mapping to it.
+ * Take gfn and return the memslot and reverse mapping to it.
  */
-static unsigned long *gfn_to_rmap(struct kvm *kvm, gfn_t gfn, int level)
+static unsigned long *gfn_to_rmap(struct kvm *kvm,
+				  struct kvm_memory_slot **slot,
+				  gfn_t gfn, int level)
 {
-	struct kvm_memory_slot *slot;
-
-	slot = gfn_to_memslot(kvm, gfn);
-	return __gfn_to_rmap(gfn, level, slot);
+	*slot = gfn_to_memslot(kvm, gfn);
+	return __gfn_to_rmap(gfn, level, *slot);
 }
 
 static bool rmap_can_add(struct kvm_vcpu *vcpu)
@@ -1051,27 +1051,42 @@ static bool rmap_can_add(struct kvm_vcpu *vcpu)
 	return mmu_memory_cache_free_objects(cache);
 }
 
+static int slot_rmap_add(struct kvm_memory_slot *slot,
+			 struct kvm_vcpu *vcpu, unsigned long *rmapp,
+			 u64 *spte)
+{
+	return pte_list_add(vcpu, spte, rmapp);
+}
+
+static void slot_rmap_remove(struct kvm_memory_slot *slot,
+			     unsigned long *rmapp, u64 *spte)
+{
+	pte_list_remove(spte, rmapp);
+}
+
 static int rmap_add(struct kvm_vcpu *vcpu, u64 *spte, gfn_t gfn)
 {
+	struct kvm_memory_slot *slot;
 	struct kvm_mmu_page *sp;
 	unsigned long *rmapp;
 
 	sp = page_header(__pa(spte));
 	kvm_mmu_page_set_gfn(sp, spte - sp->spt, gfn);
-	rmapp = gfn_to_rmap(vcpu->kvm, gfn, sp->role.level);
-	return pte_list_add(vcpu, spte, rmapp);
+	rmapp = gfn_to_rmap(vcpu->kvm,  &slot, gfn, sp->role.level);
+	return slot_rmap_add(slot, vcpu, rmapp, spte);
 }
 
 static void rmap_remove(struct kvm *kvm, u64 *spte)
 {
+	struct kvm_memory_slot *slot;
 	struct kvm_mmu_page *sp;
 	gfn_t gfn;
 	unsigned long *rmapp;
 
 	sp = page_header(__pa(spte));
 	gfn = kvm_mmu_page_get_gfn(sp, spte - sp->spt);
-	rmapp = gfn_to_rmap(kvm, gfn, sp->role.level);
-	pte_list_remove(spte, rmapp);
+	rmapp = gfn_to_rmap(kvm, &slot, gfn, sp->role.level);
+	slot_rmap_remove(slot, rmapp, spte);
 }
 
 /*
@@ -1219,6 +1234,13 @@ static bool __rmap_write_protect(struct kvm *kvm, unsigned long *rmapp,
 	return flush;
 }
 
+static bool slot_rmap_write_protect(struct kvm_memory_slot *slot,
+				    struct kvm *kvm, unsigned long *rmapp,
+				    bool pt_protect)
+{
+	return __rmap_write_protect(kvm, rmapp, pt_protect);
+}
+
 /**
  * kvm_mmu_write_protect_pt_masked - write protect selected PT level pages
  * @kvm: kvm instance
@@ -1238,7 +1260,7 @@ void kvm_mmu_write_protect_pt_masked(struct kvm *kvm,
 	while (mask) {
 		rmapp = __gfn_to_rmap(slot->base_gfn + gfn_offset + __ffs(mask),
 				      PT_PAGE_TABLE_LEVEL, slot);
-		__rmap_write_protect(kvm, rmapp, false);
+		slot_rmap_write_protect(slot, kvm, rmapp, false);
 
 		/* clear the first set bit */
 		mask &= mask - 1;
@@ -1257,14 +1279,14 @@ static bool rmap_write_protect(struct kvm *kvm, u64 gfn)
 	for (i = PT_PAGE_TABLE_LEVEL;
 	     i < PT_PAGE_TABLE_LEVEL + KVM_NR_PAGE_SIZES; ++i) {
 		rmapp = __gfn_to_rmap(gfn, i, slot);
-		write_protected |= __rmap_write_protect(kvm, rmapp, true);
+		write_protected |= slot_rmap_write_protect(slot, kvm, rmapp,
+							   true);
 	}
 
 	return write_protected;
 }
 
-static int kvm_unmap_rmapp(struct kvm *kvm, unsigned long *rmapp,
-			   struct kvm_memory_slot *slot, unsigned long data)
+static int kvm_unmap_rmapp(struct kvm *kvm, unsigned long *rmapp)
 {
 	u64 *sptep;
 	struct rmap_iterator iter;
@@ -1281,14 +1303,19 @@ static int kvm_unmap_rmapp(struct kvm *kvm, unsigned long *rmapp,
 	return need_tlb_flush;
 }
 
+static int slot_rmap_unmap(struct kvm *kvm, unsigned long *rmapp,
+			   struct kvm_memory_slot *slot, unsigned long data)
+{
+	return kvm_unmap_rmapp(kvm, rmapp);
+}
+
 static int kvm_set_pte_rmapp(struct kvm *kvm, unsigned long *rmapp,
-			     struct kvm_memory_slot *slot, unsigned long data)
+			     pte_t *ptep)
 {
 	u64 *sptep;
 	struct rmap_iterator iter;
 	int need_flush = 0;
 	u64 new_spte;
-	pte_t *ptep = (pte_t *)data;
 	pfn_t new_pfn;
 
 	WARN_ON(pte_huge(*ptep));
@@ -1323,6 +1350,12 @@ static int kvm_set_pte_rmapp(struct kvm *kvm, unsigned long *rmapp,
 	return 0;
 }
 
+static int slot_rmap_set_pte(struct kvm *kvm, unsigned long *rmapp,
+			     struct kvm_memory_slot *slot, unsigned long data)
+{
+	return kvm_set_pte_rmapp(kvm, rmapp, (pte_t *)data);
+}
+
 static int kvm_handle_hva_range(struct kvm *kvm,
 				unsigned long start,
 				unsigned long end,
@@ -1388,21 +1421,20 @@ static int kvm_handle_hva(struct kvm *kvm, unsigned long hva,
 
 int kvm_unmap_hva(struct kvm *kvm, unsigned long hva)
 {
-	return kvm_handle_hva(kvm, hva, 0, kvm_unmap_rmapp);
+	return kvm_handle_hva(kvm, hva, 0, slot_rmap_unmap);
 }
 
 int kvm_unmap_hva_range(struct kvm *kvm, unsigned long start, unsigned long end)
 {
-	return kvm_handle_hva_range(kvm, start, end, 0, kvm_unmap_rmapp);
+	return kvm_handle_hva_range(kvm, start, end, 0, slot_rmap_unmap);
 }
 
 void kvm_set_spte_hva(struct kvm *kvm, unsigned long hva, pte_t pte)
 {
-	kvm_handle_hva(kvm, hva, (unsigned long)&pte, kvm_set_pte_rmapp);
+	kvm_handle_hva(kvm, hva, (unsigned long)&pte, slot_rmap_set_pte);
 }
 
-static int kvm_age_rmapp(struct kvm *kvm, unsigned long *rmapp,
-			 struct kvm_memory_slot *slot, unsigned long data)
+static int kvm_age_rmapp(struct kvm *kvm, unsigned long *rmapp)
 {
 	u64 *sptep;
 	struct rmap_iterator uninitialized_var(iter);
@@ -1417,7 +1449,7 @@ static int kvm_age_rmapp(struct kvm *kvm, unsigned long *rmapp,
 	 * out actively used pages or breaking up actively used hugepages.
 	 */
 	if (!shadow_accessed_mask) {
-		young = kvm_unmap_rmapp(kvm, rmapp, slot, data);
+		young = kvm_unmap_rmapp(kvm, rmapp);
 		goto out;
 	}
 
@@ -1432,13 +1464,20 @@ static int kvm_age_rmapp(struct kvm *kvm, unsigned long *rmapp,
 		}
 	}
 out:
+	return young;
+}
+
+static int slot_rmap_age(struct kvm *kvm, unsigned long *rmapp,
+			 struct kvm_memory_slot *slot, unsigned long data)
+{
+	int young = kvm_age_rmapp(kvm, rmapp);
+
 	/* @data has hva passed to kvm_age_hva(). */
 	trace_kvm_age_page(data, slot, young);
 	return young;
 }
 
-static int kvm_test_age_rmapp(struct kvm *kvm, unsigned long *rmapp,
-			      struct kvm_memory_slot *slot, unsigned long data)
+static int kvm_test_age_rmapp(struct kvm *kvm, unsigned long *rmapp)
 {
 	u64 *sptep;
 	struct rmap_iterator iter;
@@ -1465,29 +1504,37 @@ out:
 	return young;
 }
 
+static int slot_rmap_test_age(struct kvm *kvm, unsigned long *rmapp,
+			      struct kvm_memory_slot *slot,
+			      unsigned long data)
+{
+	return kvm_test_age_rmapp(kvm, rmapp);
+}
+
 #define RMAP_RECYCLE_THRESHOLD 1000
 
 static void rmap_recycle(struct kvm_vcpu *vcpu, u64 *spte, gfn_t gfn)
 {
-	unsigned long *rmapp;
+	struct kvm_memory_slot *slot;
 	struct kvm_mmu_page *sp;
+	unsigned long *rmapp;
 
 	sp = page_header(__pa(spte));
 
-	rmapp = gfn_to_rmap(vcpu->kvm, gfn, sp->role.level);
+	rmapp = gfn_to_rmap(vcpu->kvm, &slot, gfn, sp->role.level);
 
-	kvm_unmap_rmapp(vcpu->kvm, rmapp, NULL, 0);
+	slot_rmap_unmap(vcpu->kvm, rmapp, slot, 0);
 	kvm_flush_remote_tlbs(vcpu->kvm);
 }
 
 int kvm_age_hva(struct kvm *kvm, unsigned long hva)
 {
-	return kvm_handle_hva(kvm, hva, hva, kvm_age_rmapp);
+	return kvm_handle_hva(kvm, hva, hva, slot_rmap_age);
 }
 
 int kvm_test_age_hva(struct kvm *kvm, unsigned long hva)
 {
-	return kvm_handle_hva(kvm, hva, 0, kvm_test_age_rmapp);
+	return kvm_handle_hva(kvm, hva, 0, slot_rmap_test_age);
 }
 
 #ifdef MMU_DEBUG
@@ -4224,7 +4271,8 @@ void kvm_mmu_slot_remove_write_access(struct kvm *kvm, int slot)
 
 		for (index = 0; index <= last_index; ++index, ++rmapp) {
 			if (*rmapp)
-				__rmap_write_protect(kvm, rmapp, false);
+				slot_rmap_write_protect(memslot, kvm, rmapp,
+							false);
 
 			if (need_resched() || spin_needbreak(&kvm->mmu_lock)) {
 				kvm_flush_remote_tlbs(kvm);
diff --git a/arch/x86/kvm/mmu_audit.c b/arch/x86/kvm/mmu_audit.c
index daff69e..ab53647 100644
--- a/arch/x86/kvm/mmu_audit.c
+++ b/arch/x86/kvm/mmu_audit.c
@@ -129,8 +129,9 @@ static void audit_mappings(struct kvm_vcpu *vcpu, u64 *sptep, int level)
 static void inspect_spte_has_rmap(struct kvm *kvm, u64 *sptep)
 {
 	static DEFINE_RATELIMIT_STATE(ratelimit_state, 5 * HZ, 10);
-	unsigned long *rmapp;
+	struct kvm_memory_slot *slot;
 	struct kvm_mmu_page *rev_sp;
+	unsigned long *rmapp;
 	gfn_t gfn;
 
 	rev_sp = page_header(__pa(sptep));
@@ -146,7 +147,7 @@ static void inspect_spte_has_rmap(struct kvm *kvm, u64 *sptep)
 		return;
 	}
 
-	rmapp = gfn_to_rmap(kvm, gfn, rev_sp->role.level);
+	rmapp = gfn_to_rmap(kvm, &slot, gfn, rev_sp->role.level);
 	if (!*rmapp) {
 		if (!__ratelimit(&ratelimit_state))
 			return;
@@ -188,14 +189,15 @@ static void check_mappings_rmap(struct kvm *kvm, struct kvm_mmu_page *sp)
 
 static void audit_write_protection(struct kvm *kvm, struct kvm_mmu_page *sp)
 {
+	struct kvm_memory_slot *slot;
+	struct rmap_iterator iter;
 	unsigned long *rmapp;
 	u64 *sptep;
-	struct rmap_iterator iter;
 
 	if (sp->role.direct || sp->unsync || sp->role.invalid)
 		return;
 
-	rmapp = gfn_to_rmap(kvm, sp->gfn, PT_PAGE_TABLE_LEVEL);
+	rmapp = gfn_to_rmap(kvm, &slot, sp->gfn, PT_PAGE_TABLE_LEVEL);
 
 	for (sptep = rmap_get_first(*rmapp, &iter); sptep;
 	     sptep = rmap_get_next(&iter)) {
-- 
1.7.7.6

