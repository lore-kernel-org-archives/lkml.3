Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935772Ab3IEKb5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 06:31:57 -0400
Received: from e23smtp01.au.ibm.com ([202.81.31.143]:58576 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935688Ab3IEK3q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 06:29:46 -0400
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
To: gleb@redhat.com
Cc: avi.kivity@gmail.com, mtosatti@redhat.com, pbonzini@redhat.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Subject: [PATCH v2 09/15] KVM: MMU: introduce pte-list lockless walker
Date: Thu,  5 Sep 2013 18:29:12 +0800
Message-Id: <1378376958-27252-10-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1378376958-27252-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
References: <1378376958-27252-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13090510-1618-0000-0000-0000049321A6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The basic idea is from nulls list which uses a nulls to indicate
whether the desc is moved to different pte-list

Note, we should do bottom-up walk in the desc since we always move
the bottom entry to the deleted position. A desc only has 3 entries
in the current code so it is not a problem now, but the issue will
be triggered if we expend the size of desc in the further development

Thanks to SLAB_DESTROY_BY_RCU, the desc can be quickly reused

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
---
 arch/x86/kvm/mmu.c | 57 ++++++++++++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 53 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index c5f1b27..3e1432f 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -975,6 +975,10 @@ static int count_spte_number(struct pte_list_desc *desc)
 	return first_free + desc_num * PTE_LIST_EXT;
 }
 
+#define rcu_assign_pte_list(pte_list_p, value)				\
+	rcu_assign_pointer(*(unsigned long __rcu **)(pte_list_p),	\
+			(unsigned long *)(value))
+
 /*
  * Pte mapping structures:
  *
@@ -994,7 +998,7 @@ static int pte_list_add(struct kvm_vcpu *vcpu, u64 *spte,
 
 	if (!*pte_list) {
 		rmap_printk("pte_list_add: %p %llx 0->1\n", spte, *spte);
-		*pte_list = (unsigned long)spte;
+		rcu_assign_pte_list(pte_list, spte);
 		return 0;
 	}
 
@@ -1004,7 +1008,7 @@ static int pte_list_add(struct kvm_vcpu *vcpu, u64 *spte,
 		desc->sptes[0] = (u64 *)*pte_list;
 		desc->sptes[1] = spte;
 		desc_mark_nulls(pte_list, desc);
-		*pte_list = (unsigned long)desc | 1;
+		rcu_assign_pte_list(pte_list, (unsigned long)desc | 1);
 		return 1;
 	}
 
@@ -1017,7 +1021,7 @@ static int pte_list_add(struct kvm_vcpu *vcpu, u64 *spte,
 		new_desc = mmu_alloc_pte_list_desc(vcpu);
 		new_desc->more = desc;
 		desc = new_desc;
-		*pte_list = (unsigned long)desc | 1;
+		rcu_assign_pte_list(pte_list, (unsigned long)desc | 1);
 	}
 
 	free_pos = find_first_free(desc);
@@ -1125,6 +1129,51 @@ static void pte_list_walk(unsigned long *pte_list, pte_list_walk_fn fn)
 	WARN_ON(desc_get_nulls_value(desc) != pte_list);
 }
 
+/* The caller should hold rcu lock. */
+static void pte_list_walk_lockless(unsigned long *pte_list,
+				   pte_list_walk_fn fn)
+{
+	struct pte_list_desc *desc;
+	unsigned long pte_list_value;
+	int i;
+
+restart:
+	/*
+	 * Force the pte_list to be reloaded.
+	 *
+	 * See the comments in hlist_nulls_for_each_entry_rcu().
+	 */
+	barrier();
+	pte_list_value = *rcu_dereference(pte_list);
+	if (!pte_list_value)
+		return;
+
+	if (!(pte_list_value & 1))
+		return fn((u64 *)pte_list_value);
+
+	desc = (struct pte_list_desc *)(pte_list_value & ~1ul);
+	while (!desc_is_a_nulls(desc)) {
+		/*
+		 * We should do top-down walk since we always use the higher
+		 * indices to replace the deleted entry if only one desc is
+		 * used in the rmap when a spte is removed. Otherwise the
+		 * moved entry will be missed.
+		 */
+		for (i = PTE_LIST_EXT - 1; i >= 0; i--)
+			if (desc->sptes[i])
+				fn(desc->sptes[i]);
+
+		desc = rcu_dereference(desc->more);
+
+		/* It is being initialized. */
+		if (unlikely(!desc))
+			goto restart;
+	}
+
+	if (unlikely(desc_get_nulls_value(desc) != pte_list))
+		goto restart;
+}
+
 static unsigned long *__gfn_to_rmap(gfn_t gfn, int level,
 				    struct kvm_memory_slot *slot)
 {
@@ -4651,7 +4700,7 @@ int kvm_mmu_module_init(void)
 {
 	pte_list_desc_cache = kmem_cache_create("pte_list_desc",
 					    sizeof(struct pte_list_desc),
-					    0, 0, NULL);
+					    0, SLAB_DESTROY_BY_RCU, NULL);
 	if (!pte_list_desc_cache)
 		goto nomem;
 
-- 
1.8.1.4

