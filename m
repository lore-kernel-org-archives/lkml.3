Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754875Ab3AWKJp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 05:09:45 -0500
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:44802 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754481Ab3AWKJn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 05:09:43 -0500
Message-ID: <50FFB6DE.8060709@linux.vnet.ibm.com>
Date: Wed, 23 Jan 2013 18:09:34 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, Avi Kivity <avi.kivity@gmail.com>,
        Gleb Natapov <gleb@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: [PATCH v2 10/12] KVM: MMU: unify the code of walking pte list
References: <50FFB5A1.5090708@linux.vnet.ibm.com>
In-Reply-To: <50FFB5A1.5090708@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13012310-5140-0000-0000-000002AA57D6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Walking parent spte and walking ramp have same logic, this patch introduces
for_each_spte_in_pte_list to integrate their code

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
---
 arch/x86/kvm/mmu.c       |  199 ++++++++++++++++++++++------------------------
 arch/x86/kvm/mmu_audit.c |    5 +-
 2 files changed, 97 insertions(+), 107 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 55198a1..b7da3fb 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -968,26 +968,75 @@ static void pte_list_remove(u64 *spte, unsigned long *pte_list)
 	}
 }

-typedef void (*pte_list_walk_fn) (u64 *spte);
-static void pte_list_walk(unsigned long *pte_list, pte_list_walk_fn fn)
+/*
+ * Used by the following functions to iterate through the sptes linked by a
+ * pte_list.  All fields are private and not assumed to be used outside.
+ */
+struct pte_list_iterator {
+	/* private fields */
+	struct pte_list_desc *desc;	/* holds the sptep if not NULL */
+	int pos;			/* index of the sptep */
+};
+
+/*
+ * Iteration must be started by this function.  This should also be used after
+ * removing/dropping sptes from the pte_list link because in such cases the
+ * information in the itererator may not be valid.
+ *
+ * Returns sptep if found, NULL otherwise.
+ */
+static u64 *pte_list_get_first(unsigned long pte_list,
+			       struct pte_list_iterator *iter)
 {
-	struct pte_list_desc *desc;
-	int i;
+	if (!pte_list)
+		return NULL;

-	if (!*pte_list)
-		return;
+	if (!(pte_list & 1)) {
+		iter->desc = NULL;
+		return (u64 *)pte_list;
+	}

-	if (!(*pte_list & 1))
-		return fn((u64 *)*pte_list);
+	iter->desc = (struct pte_list_desc *)(pte_list & ~1ul);
+	iter->pos = 0;
+	return iter->desc->sptes[iter->pos];
+}

-	desc = (struct pte_list_desc *)(*pte_list & ~1ul);
-	while (desc) {
-		for (i = 0; i < PTE_LIST_EXT && desc->sptes[i]; ++i)
-			fn(desc->sptes[i]);
-		desc = desc->more;
+/*
+ * Must be used with a valid iterator: e.g. after pte_list_get_next().
+ *
+ * Returns sptep if found, NULL otherwise.
+ */
+static u64 *pte_list_get_next(struct pte_list_iterator *iter)
+{
+	if (iter->desc) {
+		if (iter->pos < PTE_LIST_EXT - 1) {
+			u64 *sptep;
+
+			++iter->pos;
+			sptep = iter->desc->sptes[iter->pos];
+			if (sptep)
+				return sptep;
+		}
+
+		iter->desc = iter->desc->more;
+
+		if (iter->desc) {
+			iter->pos = 0;
+			/* desc->sptes[0] cannot be NULL */
+			return iter->desc->sptes[iter->pos];
+		}
 	}
+
+	return NULL;
 }

+#define for_each_spte_in_pte_list(pte_list, iter, spte)		\
+	   for (spte = pte_list_get_first(pte_list, &(iter));	\
+	      spte != NULL; spte = pte_list_get_next(&(iter)))
+
+#define for_each_spte_in_rmap(rmap, iter, spte)			\
+	   for_each_spte_in_pte_list(rmap, iter, spte)
+
 static unsigned long *__gfn_to_rmap(gfn_t gfn, int level,
 				    struct kvm_memory_slot *slot)
 {
@@ -1039,67 +1088,6 @@ static void rmap_remove(struct kvm *kvm, u64 *spte)
 	pte_list_remove(spte, rmapp);
 }

-/*
- * Used by the following functions to iterate through the sptes linked by a
- * rmap.  All fields are private and not assumed to be used outside.
- */
-struct rmap_iterator {
-	/* private fields */
-	struct pte_list_desc *desc;	/* holds the sptep if not NULL */
-	int pos;			/* index of the sptep */
-};
-
-/*
- * Iteration must be started by this function.  This should also be used after
- * removing/dropping sptes from the rmap link because in such cases the
- * information in the itererator may not be valid.
- *
- * Returns sptep if found, NULL otherwise.
- */
-static u64 *rmap_get_first(unsigned long rmap, struct rmap_iterator *iter)
-{
-	if (!rmap)
-		return NULL;
-
-	if (!(rmap & 1)) {
-		iter->desc = NULL;
-		return (u64 *)rmap;
-	}
-
-	iter->desc = (struct pte_list_desc *)(rmap & ~1ul);
-	iter->pos = 0;
-	return iter->desc->sptes[iter->pos];
-}
-
-/*
- * Must be used with a valid iterator: e.g. after rmap_get_first().
- *
- * Returns sptep if found, NULL otherwise.
- */
-static u64 *rmap_get_next(struct rmap_iterator *iter)
-{
-	if (iter->desc) {
-		if (iter->pos < PTE_LIST_EXT - 1) {
-			u64 *sptep;
-
-			++iter->pos;
-			sptep = iter->desc->sptes[iter->pos];
-			if (sptep)
-				return sptep;
-		}
-
-		iter->desc = iter->desc->more;
-
-		if (iter->desc) {
-			iter->pos = 0;
-			/* desc->sptes[0] cannot be NULL */
-			return iter->desc->sptes[iter->pos];
-		}
-	}
-
-	return NULL;
-}
-
 static void drop_spte(struct kvm *kvm, u64 *sptep)
 {
 	if (mmu_spte_clear_track_bits(sptep))
@@ -1160,14 +1148,13 @@ static bool __rmap_write_protect(struct kvm *kvm, unsigned long *rmapp,
 				 bool pt_protect)
 {
 	u64 *sptep;
-	struct rmap_iterator iter;
+	struct pte_list_iterator iter;
 	bool flush = false;

-	for (sptep = rmap_get_first(*rmapp, &iter); sptep;) {
+	for_each_spte_in_rmap(*rmapp, iter, sptep) {
 		BUG_ON(!(*sptep & PT_PRESENT_MASK));

 		spte_write_protect(kvm, sptep, &flush, pt_protect);
-		sptep = rmap_get_next(&iter);
 	}

 	return flush;
@@ -1221,15 +1208,14 @@ static int kvm_unmap_rmapp(struct kvm *kvm, unsigned long *rmapp,
 			   struct kvm_memory_slot *slot, unsigned long data)
 {
 	u64 *sptep;
-	struct rmap_iterator iter;
+	struct pte_list_iterator iter;
 	int need_tlb_flush = 0;

-	while ((sptep = rmap_get_first(*rmapp, &iter))) {
-		BUG_ON(!(*sptep & PT_PRESENT_MASK));
-		rmap_printk("kvm_rmap_unmap_hva: spte %p %llx\n", sptep, *sptep);
-
+restart:
+	for_each_spte_in_rmap(*rmapp, iter, sptep) {
 		drop_spte(kvm, sptep);
 		need_tlb_flush = 1;
+		goto restart;
 	}

 	return need_tlb_flush;
@@ -1239,7 +1225,7 @@ static int kvm_set_pte_rmapp(struct kvm *kvm, unsigned long *rmapp,
 			     struct kvm_memory_slot *slot, unsigned long data)
 {
 	u64 *sptep;
-	struct rmap_iterator iter;
+	struct pte_list_iterator iter;
 	int need_flush = 0;
 	u64 new_spte;
 	pte_t *ptep = (pte_t *)data;
@@ -1248,7 +1234,8 @@ static int kvm_set_pte_rmapp(struct kvm *kvm, unsigned long *rmapp,
 	WARN_ON(pte_huge(*ptep));
 	new_pfn = pte_pfn(*ptep);

-	for (sptep = rmap_get_first(*rmapp, &iter); sptep;) {
+restart:
+	for_each_spte_in_rmap(*rmapp, iter, sptep) {
 		BUG_ON(!is_shadow_present_pte(*sptep));
 		rmap_printk("kvm_set_pte_rmapp: spte %p %llx\n", sptep, *sptep);

@@ -1256,19 +1243,18 @@ static int kvm_set_pte_rmapp(struct kvm *kvm, unsigned long *rmapp,

 		if (pte_write(*ptep)) {
 			drop_spte(kvm, sptep);
-			sptep = rmap_get_first(*rmapp, &iter);
-		} else {
-			new_spte = *sptep & ~PT64_BASE_ADDR_MASK;
-			new_spte |= (u64)new_pfn << PAGE_SHIFT;
+			goto restart;
+		}

-			new_spte &= ~PT_WRITABLE_MASK;
-			new_spte &= ~SPTE_HOST_WRITEABLE;
-			new_spte &= ~shadow_accessed_mask;
+		new_spte = *sptep & ~PT64_BASE_ADDR_MASK;
+		new_spte |= (u64)new_pfn << PAGE_SHIFT;

-			mmu_spte_clear_track_bits(sptep);
-			mmu_spte_set(sptep, new_spte);
-			sptep = rmap_get_next(&iter);
-		}
+		new_spte &= ~PT_WRITABLE_MASK;
+		new_spte &= ~SPTE_HOST_WRITEABLE;
+		new_spte &= ~shadow_accessed_mask;
+
+		mmu_spte_clear_track_bits(sptep);
+		mmu_spte_set(sptep, new_spte);
 	}

 	if (need_flush)
@@ -1359,7 +1345,7 @@ static int kvm_age_rmapp(struct kvm *kvm, unsigned long *rmapp,
 			 struct kvm_memory_slot *slot, unsigned long data)
 {
 	u64 *sptep;
-	struct rmap_iterator uninitialized_var(iter);
+	struct pte_list_iterator uninitialized_var(iter);
 	int young = 0;

 	/*
@@ -1375,8 +1361,7 @@ static int kvm_age_rmapp(struct kvm *kvm, unsigned long *rmapp,
 		goto out;
 	}

-	for (sptep = rmap_get_first(*rmapp, &iter); sptep;
-	     sptep = rmap_get_next(&iter)) {
+	for_each_spte_in_rmap(*rmapp, iter, sptep) {
 		BUG_ON(!is_shadow_present_pte(*sptep));

 		if (*sptep & shadow_accessed_mask) {
@@ -1395,7 +1380,7 @@ static int kvm_test_age_rmapp(struct kvm *kvm, unsigned long *rmapp,
 			      struct kvm_memory_slot *slot, unsigned long data)
 {
 	u64 *sptep;
-	struct rmap_iterator iter;
+	struct pte_list_iterator iter;
 	int young = 0;

 	/*
@@ -1406,8 +1391,7 @@ static int kvm_test_age_rmapp(struct kvm *kvm, unsigned long *rmapp,
 	if (!shadow_accessed_mask)
 		goto out;

-	for (sptep = rmap_get_first(*rmapp, &iter); sptep;
-	     sptep = rmap_get_next(&iter)) {
+	for_each_spte_in_rmap(*rmapp, iter, sptep) {
 		BUG_ON(!is_shadow_present_pte(*sptep));

 		if (*sptep & shadow_accessed_mask) {
@@ -1539,7 +1523,11 @@ static struct kvm_mmu_page *kvm_mmu_alloc_page(struct kvm_vcpu *vcpu,
 static void mark_unsync(u64 *spte);
 static void kvm_mmu_mark_parents_unsync(struct kvm_mmu_page *sp)
 {
-	pte_list_walk(&sp->parent_ptes, mark_unsync);
+	struct pte_list_iterator iter;
+	u64 *spte;
+
+	for_each_spte_in_pte_list(sp->parent_ptes, iter, spte)
+		mark_unsync(spte);
 }

 static void mark_unsync(u64 *spte)
@@ -2059,10 +2047,13 @@ static void kvm_mmu_page_unlink_children(struct kvm *kvm,
 static void kvm_mmu_unlink_parents(struct kvm *kvm, struct kvm_mmu_page *sp)
 {
 	u64 *sptep;
-	struct rmap_iterator iter;
+	struct pte_list_iterator iter;

-	while ((sptep = rmap_get_first(sp->parent_ptes, &iter)))
+restart:
+	for_each_spte_in_rmap(sp->parent_ptes, iter, sptep) {
 		drop_parent_pte(sp, sptep);
+		goto restart;
+	}
 }

 static int mmu_zap_unsync_children(struct kvm *kvm,
diff --git a/arch/x86/kvm/mmu_audit.c b/arch/x86/kvm/mmu_audit.c
index daff69e..a08d384 100644
--- a/arch/x86/kvm/mmu_audit.c
+++ b/arch/x86/kvm/mmu_audit.c
@@ -190,15 +190,14 @@ static void audit_write_protection(struct kvm *kvm, struct kvm_mmu_page *sp)
 {
 	unsigned long *rmapp;
 	u64 *sptep;
-	struct rmap_iterator iter;
+	struct pte_list_iterator iter;

 	if (sp->role.direct || sp->unsync || sp->role.invalid)
 		return;

 	rmapp = gfn_to_rmap(kvm, sp->gfn, PT_PAGE_TABLE_LEVEL);

-	for (sptep = rmap_get_first(*rmapp, &iter); sptep;
-	     sptep = rmap_get_next(&iter)) {
+	for_each_spte_in_rmap(*rmapp, iter, sptep) {
 		if (is_writable_pte(*sptep))
 			audit_printk(kvm, "shadow page has writable "
 				     "mappings: gfn %llx role %x\n",
-- 
1.7.7.6

