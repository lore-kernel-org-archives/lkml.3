Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755923Ab3G3NJ7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 09:09:59 -0400
Received: from e28smtp01.in.ibm.com ([122.248.162.1]:51686 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755389Ab3G3NHv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 09:07:51 -0400
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
To: gleb@redhat.com
Cc: avi.kivity@gmail.com, mtosatti@redhat.com, pbonzini@redhat.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Subject: [PATCH 08/12] KVM: MMU: introduce nulls desc
Date: Tue, 30 Jul 2013 21:02:06 +0800
Message-Id: <1375189330-24066-9-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1375189330-24066-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
References: <1375189330-24066-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13073012-4790-0000-0000-00000988A7DF
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It likes nulls list and we use the pte-list as the nulls which can help us to
detect whether the "desc" is moved to anther rmap then we can re-walk the rmap
if that happened

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
---
 arch/x86/kvm/mmu.c | 35 ++++++++++++++++++++++++++++-------
 1 file changed, 28 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 3013bb1..36caf6a 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -918,6 +918,24 @@ static int mapping_level(struct kvm_vcpu *vcpu, gfn_t large_gfn)
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
@@ -956,7 +974,7 @@ static int count_spte_number(struct pte_list_desc *desc)
 
 	first_free = __find_first_free(desc);
 
-	for (desc_num = 0; desc->more; desc = desc->more)
+	for (desc_num = 0; !desc_is_a_nulls(desc->more); desc = desc->more)
 		desc_num++;
 
 	return first_free + desc_num * PTE_LIST_EXT;
@@ -991,6 +1009,7 @@ static int pte_list_add(struct kvm_vcpu *vcpu, u64 *spte,
 		desc = mmu_alloc_pte_list_desc(vcpu);
 		desc->sptes[0] = (u64 *)*pte_list;
 		desc->sptes[1] = spte;
+		desc_mark_nulls(pte_list, desc);
 		*pte_list = (unsigned long)desc | 1;
 		return 1;
 	}
@@ -1036,7 +1055,7 @@ pte_list_desc_remove_entry(unsigned long *pte_list,
 		/*
 		 * Only one entry existing but still use a desc to store it?
 		 */
-		WARN_ON(!next_desc);
+		WARN_ON(desc_is_a_nulls(next_desc));
 
 		mmu_free_pte_list_desc(first_desc);
 		first_desc = next_desc;
@@ -1050,7 +1069,7 @@ pte_list_desc_remove_entry(unsigned long *pte_list,
 	 * Only one entry in this desc, move the entry to the head
 	 * then the desc can be freed.
 	 */
-	if (!first_desc->sptes[1] && !first_desc->more) {
+	if (!first_desc->sptes[1] && desc_is_a_nulls(first_desc->more)) {
 		*pte_list = (unsigned long)first_desc->sptes[0];
 		mmu_free_pte_list_desc(first_desc);
 	}
@@ -1077,7 +1096,7 @@ static void pte_list_remove(u64 *spte, unsigned long *pte_list)
 
 	rmap_printk("pte_list_remove:  %p many->many\n", spte);
 	desc = (struct pte_list_desc *)(*pte_list & ~1ul);
-	while (desc) {
+	while (!desc_is_a_nulls(desc)) {
 		for (i = 0; i < PTE_LIST_EXT && desc->sptes[i]; ++i)
 			if (desc->sptes[i] == spte) {
 				pte_list_desc_remove_entry(pte_list,
@@ -1103,11 +1122,13 @@ static void pte_list_walk(unsigned long *pte_list, pte_list_walk_fn fn)
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
@@ -1200,7 +1221,7 @@ static u64 *rmap_get_first(unsigned long rmap, struct rmap_iterator *iter)
  */
 static u64 *rmap_get_next(struct rmap_iterator *iter)
 {
-	if (iter->desc) {
+	if (iter->desc && !desc_is_a_nulls(iter->desc)) {
 		if (iter->pos < PTE_LIST_EXT - 1) {
 			u64 *sptep;
 
@@ -1212,7 +1233,7 @@ static u64 *rmap_get_next(struct rmap_iterator *iter)
 
 		iter->desc = iter->desc->more;
 
-		if (iter->desc) {
+		if (!desc_is_a_nulls(iter->desc)) {
 			iter->pos = 0;
 			/* desc->sptes[0] cannot be NULL */
 			return iter->desc->sptes[iter->pos];
-- 
1.8.1.4

