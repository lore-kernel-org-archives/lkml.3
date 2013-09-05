Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965338Ab3IEKdU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 06:33:20 -0400
Received: from e28smtp04.in.ibm.com ([122.248.162.4]:41368 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935623Ab3IEK3n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 06:29:43 -0400
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
To: gleb@redhat.com
Cc: avi.kivity@gmail.com, mtosatti@redhat.com, pbonzini@redhat.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Subject: [PATCH v2 07/15] KVM: MMU: redesign the algorithm of pte_list
Date: Thu,  5 Sep 2013 18:29:10 +0800
Message-Id: <1378376958-27252-8-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1378376958-27252-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
References: <1378376958-27252-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13090510-5564-0000-0000-000009927E78
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change the algorithm to:
1) always add new desc to the first desc (pointed by parent_ptes/rmap)
   that is good to implement rcu-nulls-list-like lockless rmap
   walking

2) always move the entry in the first desc to the the position we want
   to remove when delete a spte in the parent_ptes/rmap （backward-move).
   It is good for us to implement lockless rmap walk since in the current
   code, when a spte is deleted from the "desc", another spte in the last
   "desc" will be moved to this position to replace the deleted one. If the
   deleted one has been accessed and we do not access the replaced one, the
   replaced one is missed when we do lockless walk.
   To fix this case, we do not backward move the spte, instead, we forward
   move the entry: when a spte is deleted, we move the entry in the first
   desc to that position

Both of these also can reduce cache miss

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
---
 arch/x86/kvm/mmu.c | 180 ++++++++++++++++++++++++++++++++++++-----------------
 1 file changed, 123 insertions(+), 57 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 8ea54d9..08fb4e2 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -913,6 +913,50 @@ static int mapping_level(struct kvm_vcpu *vcpu, gfn_t large_gfn)
 	return level - 1;
 }
 
+static int __find_first_free(struct pte_list_desc *desc)
+{
+	int i;
+
+	for (i = 0; i < PTE_LIST_EXT; i++)
+		if (!desc->sptes[i])
+			break;
+	return i;
+}
+
+static int find_first_free(struct pte_list_desc *desc)
+{
+	int free = __find_first_free(desc);
+
+	WARN_ON(free >= PTE_LIST_EXT);
+	return free;
+}
+
+static int find_last_used(struct pte_list_desc *desc)
+{
+	int used = __find_first_free(desc) - 1;
+
+	WARN_ON(used < 0 || used >= PTE_LIST_EXT);
+	return used;
+}
+
+/*
+ * TODO: we can encode the desc number into the rmap/parent_ptes
+ * since at least 10 physical/virtual address bits are reserved
+ * on x86. It is worthwhile if it shows that the desc walking is
+ * a performance issue.
+ */
+static int count_spte_number(struct pte_list_desc *desc)
+{
+	int first_free, desc_num;
+
+	first_free = __find_first_free(desc);
+
+	for (desc_num = 0; desc->more; desc = desc->more)
+		desc_num++;
+
+	return first_free + desc_num * PTE_LIST_EXT;
+}
+
 /*
  * Pte mapping structures:
  *
@@ -923,99 +967,121 @@ static int mapping_level(struct kvm_vcpu *vcpu, gfn_t large_gfn)
  *
  * Returns the number of pte entries before the spte was added or zero if
  * the spte was not added.
- *
  */
 static int pte_list_add(struct kvm_vcpu *vcpu, u64 *spte,
 			unsigned long *pte_list)
 {
 	struct pte_list_desc *desc;
-	int i, count = 0;
+	int free_pos;
 
 	if (!*pte_list) {
 		rmap_printk("pte_list_add: %p %llx 0->1\n", spte, *spte);
 		*pte_list = (unsigned long)spte;
-	} else if (!(*pte_list & 1)) {
+		return 0;
+	}
+
+	if (!(*pte_list & 1)) {
 		rmap_printk("pte_list_add: %p %llx 1->many\n", spte, *spte);
 		desc = mmu_alloc_pte_list_desc(vcpu);
 		desc->sptes[0] = (u64 *)*pte_list;
 		desc->sptes[1] = spte;
 		*pte_list = (unsigned long)desc | 1;
-		++count;
-	} else {
-		rmap_printk("pte_list_add: %p %llx many->many\n", spte, *spte);
-		desc = (struct pte_list_desc *)(*pte_list & ~1ul);
-		while (desc->sptes[PTE_LIST_EXT-1] && desc->more) {
-			desc = desc->more;
-			count += PTE_LIST_EXT;
-		}
-		if (desc->sptes[PTE_LIST_EXT-1]) {
-			count += PTE_LIST_EXT;
-			desc->more = mmu_alloc_pte_list_desc(vcpu);
-			desc = desc->more;
-		}
-		for (i = 0; desc->sptes[i]; ++i)
-			++count;
-		desc->sptes[i] = spte;
+		return 1;
 	}
-	return count;
+
+	rmap_printk("pte_list_add: %p %llx many->many\n", spte, *spte);
+	desc = (struct pte_list_desc *)(*pte_list & ~1ul);
+
+	/* No empty entry in the desc. */
+	if (desc->sptes[PTE_LIST_EXT - 1]) {
+		struct pte_list_desc *new_desc;
+		new_desc = mmu_alloc_pte_list_desc(vcpu);
+		new_desc->more = desc;
+		desc = new_desc;
+		*pte_list = (unsigned long)desc | 1;
+	}
+
+	free_pos = find_first_free(desc);
+	desc->sptes[free_pos] = spte;
+	return count_spte_number(desc) - 1;
 }
 
 static void
-pte_list_desc_remove_entry(unsigned long *pte_list, struct pte_list_desc *desc,
-			   int i, struct pte_list_desc *prev_desc)
+pte_list_desc_remove_entry(unsigned long *pte_list,
+			   struct pte_list_desc *desc, int i)
 {
-	int j;
+	struct pte_list_desc *first_desc;
+	int last_used;
 
-	for (j = PTE_LIST_EXT - 1; !desc->sptes[j] && j > i; --j)
-		;
-	desc->sptes[i] = desc->sptes[j];
-	desc->sptes[j] = NULL;
-	if (j != 0)
+	first_desc = (struct pte_list_desc *)(*pte_list & ~1ul);
+	last_used = find_last_used(first_desc);
+
+	/*
+	 * Move the entry from the first desc to this position we want
+	 * to remove.
+	 */
+	desc->sptes[i] = first_desc->sptes[last_used];
+	first_desc->sptes[last_used] = NULL;
+
+	/* No valid entry in this desc, we can free this desc now. */
+	if (!first_desc->sptes[0]) {
+		struct pte_list_desc *next_desc = first_desc->more;
+
+		/*
+		 * Only one entry existing but still use a desc to store it?
+		 */
+		WARN_ON(!next_desc);
+
+		mmu_free_pte_list_desc(first_desc);
+		*pte_list = (unsigned long)next_desc | 1ul;
 		return;
-	if (!prev_desc && !desc->more)
-		*pte_list = (unsigned long)desc->sptes[0];
-	else
-		if (prev_desc)
-			prev_desc->more = desc->more;
-		else
-			*pte_list = (unsigned long)desc->more | 1;
-	mmu_free_pte_list_desc(desc);
+	}
+
+	/*
+	 * Only one entry in this desc, move the entry to the head
+	 * then the desc can be freed.
+	 */
+	if (!first_desc->sptes[1] && !first_desc->more) {
+		*pte_list = (unsigned long)first_desc->sptes[0];
+		mmu_free_pte_list_desc(first_desc);
+	}
 }
 
 static void pte_list_remove(u64 *spte, unsigned long *pte_list)
 {
 	struct pte_list_desc *desc;
-	struct pte_list_desc *prev_desc;
 	int i;
 
 	if (!*pte_list) {
-		printk(KERN_ERR "pte_list_remove: %p 0->BUG\n", spte);
+		pr_err("pte_list_remove: %p 0->BUG\n", spte);
 		BUG();
-	} else if (!(*pte_list & 1)) {
+		return;
+	}
+
+	if (!(*pte_list & 1)) {
 		rmap_printk("pte_list_remove:  %p 1->0\n", spte);
 		if ((u64 *)*pte_list != spte) {
-			printk(KERN_ERR "pte_list_remove:  %p 1->BUG\n", spte);
+			pr_err("pte_list_remove:  %p 1->BUG\n", spte);
 			BUG();
 		}
 		*pte_list = 0;
-	} else {
-		rmap_printk("pte_list_remove:  %p many->many\n", spte);
-		desc = (struct pte_list_desc *)(*pte_list & ~1ul);
-		prev_desc = NULL;
-		while (desc) {
-			for (i = 0; i < PTE_LIST_EXT && desc->sptes[i]; ++i)
-				if (desc->sptes[i] == spte) {
-					pte_list_desc_remove_entry(pte_list,
-							       desc, i,
-							       prev_desc);
-					return;
-				}
-			prev_desc = desc;
-			desc = desc->more;
-		}
-		pr_err("pte_list_remove: %p many->many\n", spte);
-		BUG();
+		return;
 	}
+
+	rmap_printk("pte_list_remove:  %p many->many\n", spte);
+	desc = (struct pte_list_desc *)(*pte_list & ~1ul);
+	while (desc) {
+		for (i = 0; i < PTE_LIST_EXT && desc->sptes[i]; ++i)
+			if (desc->sptes[i] == spte) {
+				pte_list_desc_remove_entry(pte_list,
+							       desc, i);
+				return;
+			}
+		desc = desc->more;
+	}
+
+	pr_err("pte_list_remove: %p many->many\n", spte);
+	BUG();
 }
 
 typedef void (*pte_list_walk_fn) (u64 *spte);
-- 
1.8.1.4

