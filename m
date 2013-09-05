Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965232Ab3IEK35 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 06:29:57 -0400
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:58600 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965216Ab3IEK3w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 06:29:52 -0400
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
To: gleb@redhat.com
Cc: avi.kivity@gmail.com, mtosatti@redhat.com, pbonzini@redhat.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Subject: [PATCH v2 15/15] KVM: MMU: use rcu functions to access the pointer
Date: Thu,  5 Sep 2013 18:29:18 +0800
Message-Id: <1378376958-27252-16-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1378376958-27252-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
References: <1378376958-27252-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13090510-0260-0000-0000-000003936B34
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use rcu_assign_pointer() to update all the pointer in desc
and use rcu_dereference() to lockless read the pointer

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
---
 arch/x86/kvm/mmu.c | 46 ++++++++++++++++++++++++++++------------------
 1 file changed, 28 insertions(+), 18 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index f3f17a0..808c2d9 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -927,12 +927,23 @@ static void pte_list_desc_ctor(void *p)
 	desc->more = NULL;
 }
 
+#define rcu_assign_pte_list(pte_list_p, value)				\
+	rcu_assign_pointer(*(unsigned long __rcu **)(pte_list_p),	\
+			  (unsigned long *)(value))
+
+#define rcu_assign_desc_more(morep, value)				\
+	rcu_assign_pointer(*(unsigned long __rcu **)&morep,		\
+			  (unsigned long *)value)
+
+#define rcu_assign_spte(sptep, value)					\
+	rcu_assign_pointer(*(u64 __rcu **)&sptep, (u64 *)value)
+
 static void desc_mark_nulls(unsigned long *pte_list, struct pte_list_desc *desc)
 {
 	unsigned long marker;
 
 	marker = (unsigned long)pte_list | 1UL;
-	desc->more = (struct pte_list_desc *)marker;
+	rcu_assign_desc_more(desc->more, (struct pte_list_desc *)marker);
 }
 
 static bool desc_is_a_nulls(struct pte_list_desc *desc)
@@ -989,10 +1000,6 @@ static int count_spte_number(struct pte_list_desc *desc)
 	return first_free + desc_num * PTE_LIST_EXT;
 }
 
-#define rcu_assign_pte_list(pte_list_p, value)				\
-	rcu_assign_pointer(*(unsigned long __rcu **)(pte_list_p),	\
-			(unsigned long *)(value))
-
 /*
  * Pte mapping structures:
  *
@@ -1019,8 +1026,8 @@ static int pte_list_add(struct kvm_vcpu *vcpu, u64 *spte,
 	if (!(*pte_list & 1)) {
 		rmap_printk("pte_list_add: %p %llx 1->many\n", spte, *spte);
 		desc = mmu_alloc_pte_list_desc(vcpu);
-		desc->sptes[0] = (u64 *)*pte_list;
-		desc->sptes[1] = spte;
+		rcu_assign_spte(desc->sptes[0], *pte_list);
+		rcu_assign_spte(desc->sptes[1], spte);
 		desc_mark_nulls(pte_list, desc);
 		rcu_assign_pte_list(pte_list, (unsigned long)desc | 1);
 		return 1;
@@ -1033,13 +1040,13 @@ static int pte_list_add(struct kvm_vcpu *vcpu, u64 *spte,
 	if (desc->sptes[PTE_LIST_EXT - 1]) {
 		struct pte_list_desc *new_desc;
 		new_desc = mmu_alloc_pte_list_desc(vcpu);
-		new_desc->more = desc;
+		rcu_assign_desc_more(new_desc->more, desc);
 		desc = new_desc;
 		rcu_assign_pte_list(pte_list, (unsigned long)desc | 1);
 	}
 
 	free_pos = find_first_free(desc);
-	desc->sptes[free_pos] = spte;
+	rcu_assign_spte(desc->sptes[free_pos], spte);
 	return count_spte_number(desc) - 1;
 }
 
@@ -1057,8 +1064,8 @@ pte_list_desc_remove_entry(unsigned long *pte_list,
 	 * Move the entry from the first desc to this position we want
 	 * to remove.
 	 */
-	desc->sptes[i] = first_desc->sptes[last_used];
-	first_desc->sptes[last_used] = NULL;
+	rcu_assign_spte(desc->sptes[i], first_desc->sptes[last_used]);
+	rcu_assign_spte(first_desc->sptes[last_used], NULL);
 
 	/* No valid entry in this desc, we can free this desc now. */
 	if (!first_desc->sptes[0]) {
@@ -1070,7 +1077,7 @@ pte_list_desc_remove_entry(unsigned long *pte_list,
 		WARN_ON(desc_is_a_nulls(next_desc));
 
 		mmu_free_pte_list_desc(first_desc);
-		*pte_list = (unsigned long)next_desc | 1ul;
+		rcu_assign_pte_list(pte_list, (unsigned long)next_desc | 1ul);
 		return;
 	}
 
@@ -1079,8 +1086,8 @@ pte_list_desc_remove_entry(unsigned long *pte_list,
 	 * then the desc can be freed.
 	 */
 	if (!first_desc->sptes[1] && desc_is_a_nulls(first_desc->more)) {
-		*pte_list = (unsigned long)first_desc->sptes[0];
-		first_desc->sptes[0] = NULL;
+		rcu_assign_pte_list(pte_list, first_desc->sptes[0]);
+		rcu_assign_spte(first_desc->sptes[0], NULL);
 		mmu_free_pte_list_desc(first_desc);
 	}
 }
@@ -1102,7 +1109,7 @@ static void pte_list_remove(u64 *spte, unsigned long *pte_list)
 			pr_err("pte_list_remove:  %p 1->BUG\n", spte);
 			BUG();
 		}
-		*pte_list = 0;
+		rcu_assign_pte_list(pte_list, 0);
 		return;
 	}
 
@@ -1174,9 +1181,12 @@ restart:
 		 * used in the rmap when a spte is removed. Otherwise the
 		 * moved entry will be missed.
 		 */
-		for (i = PTE_LIST_EXT - 1; i >= 0; i--)
-			if (desc->sptes[i])
-				fn(desc->sptes[i]);
+		for (i = PTE_LIST_EXT - 1; i >= 0; i--) {
+			u64 *sptep = rcu_dereference(desc->sptes[i]);
+
+			if (sptep)
+				fn(sptep);
+		}
 
 		desc = rcu_dereference(desc->more);
 
-- 
1.8.1.4

