Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754581Ab3JWNdX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Oct 2013 09:33:23 -0400
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:54695 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751476Ab3JWN37 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Oct 2013 09:29:59 -0400
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
To: gleb@redhat.com
Cc: avi.kivity@gmail.com, mtosatti@redhat.com, pbonzini@redhat.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Subject: [PATCH v3 07/15] KVM: MMU: introduce nulls desc
Date: Wed, 23 Oct 2013 21:29:25 +0800
Message-Id: <1382534973-13197-8-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1382534973-13197-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
References: <1382534973-13197-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13102313-9264-0000-0000-000004C927F5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It likes nulls list and we use the pte-list as the nulls which can help us to
detect whether the "desc" is moved to anther rmap then we can re-walk the rmap
if that happened

kvm->slots_lock is held when we do lockless walking that prevents rmap
is reused (free rmap need to hold that lock) so that we can not see the same
nulls used on different rmaps

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
---
 arch/x86/kvm/mmu.c | 35 +++++++++++++++++++++++++++++------
 1 file changed, 29 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 5cce039..4687329 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -913,6 +913,24 @@ static int mapping_level(struct kvm_vcpu *vcpu, gfn_t large_gfn)
 	return level - 1;
 }
 
+static void desc_mark_nulls(unsigned long *pte_list, struct pte_list_desc *desc)
+{
+	unsigned long marker;
+
+	marker = (unsigned long)pte_list | 1UL;
+	desc->more = (struct pte_list_desc *)marker;
+}
+
+static bool desc_is_a_nulls(struct pte_list_desc *desc)
+{
+	return (unsigned long)desc & 1;
+}
+
+static unsigned long *desc_get_nulls_value(struct pte_list_desc *desc)
+{
+	return (unsigned long *)((unsigned long)desc & ~1);
+}
+
 static int __find_first_free(struct pte_list_desc *desc)
 {
 	int i;
@@ -951,7 +969,7 @@ static int count_spte_number(struct pte_list_desc *desc)
 
 	first_free = __find_first_free(desc);
 
-	for (desc_num = 0; desc->more; desc = desc->more)
+	for (desc_num = 0; !desc_is_a_nulls(desc->more); desc = desc->more)
 		desc_num++;
 
 	return first_free + desc_num * PTE_LIST_EXT;
@@ -985,6 +1003,7 @@ static int pte_list_add(struct kvm_vcpu *vcpu, u64 *spte,
 		desc = mmu_alloc_pte_list_desc(vcpu);
 		desc->sptes[0] = (u64 *)*pte_list;
 		desc->sptes[1] = spte;
+		desc_mark_nulls(pte_list, desc);
 		*pte_list = (unsigned long)desc | 1;
 		return 1;
 	}
@@ -1030,7 +1049,7 @@ pte_list_desc_remove_entry(unsigned long *pte_list,
 		/*
 		 * Only one entry existing but still use a desc to store it?
 		 */
-		WARN_ON(!next_desc);
+		WARN_ON(desc_is_a_nulls(next_desc));
 
 		mmu_free_pte_list_desc(first_desc);
 		*pte_list = (unsigned long)next_desc | 1ul;
@@ -1041,7 +1060,7 @@ pte_list_desc_remove_entry(unsigned long *pte_list,
 	 * Only one entry in this desc, move the entry to the head
 	 * then the desc can be freed.
 	 */
-	if (!first_desc->sptes[1] && !first_desc->more) {
+	if (!first_desc->sptes[1] && desc_is_a_nulls(first_desc->more)) {
 		*pte_list = (unsigned long)first_desc->sptes[0];
 		mmu_free_pte_list_desc(first_desc);
 	}
@@ -1070,7 +1089,7 @@ static void pte_list_remove(u64 *spte, unsigned long *pte_list)
 
 	rmap_printk("pte_list_remove:  %p many->many\n", spte);
 	desc = (struct pte_list_desc *)(*pte_list & ~1ul);
-	while (desc) {
+	while (!desc_is_a_nulls(desc)) {
 		for (i = 0; i < PTE_LIST_EXT && desc->sptes[i]; ++i)
 			if (desc->sptes[i] == spte) {
 				pte_list_desc_remove_entry(pte_list,
@@ -1097,11 +1116,13 @@ static void pte_list_walk(unsigned long *pte_list, pte_list_walk_fn fn)
 		return fn((u64 *)*pte_list);
 
 	desc = (struct pte_list_desc *)(*pte_list & ~1ul);
-	while (desc) {
+	while (!desc_is_a_nulls(desc)) {
 		for (i = 0; i < PTE_LIST_EXT && desc->sptes[i]; ++i)
 			fn(desc->sptes[i]);
 		desc = desc->more;
 	}
+
+	WARN_ON(desc_get_nulls_value(desc) != pte_list);
 }
 
 static unsigned long *__gfn_to_rmap(gfn_t gfn, int level,
@@ -1184,6 +1205,7 @@ static u64 *rmap_get_first(unsigned long rmap, struct rmap_iterator *iter)
 
 	iter->desc = (struct pte_list_desc *)(rmap & ~1ul);
 	iter->pos = 0;
+	WARN_ON(desc_is_a_nulls(iter->desc));
 	return iter->desc->sptes[iter->pos];
 }
 
@@ -1204,7 +1226,8 @@ static u64 *rmap_get_next(struct rmap_iterator *iter)
 				return sptep;
 		}
 
-		iter->desc = iter->desc->more;
+		iter->desc = desc_is_a_nulls(iter->desc->more) ?
+				NULL : iter->desc->more;
 
 		if (iter->desc) {
 			iter->pos = 0;
-- 
1.8.1.4

