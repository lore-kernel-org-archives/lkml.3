Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755621Ab3G3NH5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 09:07:57 -0400
Received: from e28smtp05.in.ibm.com ([122.248.162.5]:33990 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755441Ab3G3NHz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 09:07:55 -0400
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
To: gleb@redhat.com
Cc: avi.kivity@gmail.com, mtosatti@redhat.com, pbonzini@redhat.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Subject: [PATCH 09/12] KVM: MMU: introduce pte-list lockless walker
Date: Tue, 30 Jul 2013 21:02:07 +0800
Message-Id: <1375189330-24066-10-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1375189330-24066-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
References: <1375189330-24066-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13073013-8256-0000-0000-000008937A5E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The basic idea is from nulls list which uses a nulls to indicate
whether the desc is moved to different pte-list

Thanks to SLAB_DESTROY_BY_RCU, the desc can be quickly reused

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
---
 arch/x86/kvm/mmu.c | 51 ++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 50 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 36caf6a..f8fc0cc 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -1010,6 +1010,14 @@ static int pte_list_add(struct kvm_vcpu *vcpu, u64 *spte,
 		desc->sptes[0] = (u64 *)*pte_list;
 		desc->sptes[1] = spte;
 		desc_mark_nulls(pte_list, desc);
+
+		/*
+		 * Esure the old spte has been updated into desc, so
+		 * that the another side can not get the desc from pte_list
+		 * but miss the old spte.
+		 */
+		smp_wmb();
+
 		*pte_list = (unsigned long)desc | 1;
 		return 1;
 	}
@@ -1131,6 +1139,47 @@ static void pte_list_walk(unsigned long *pte_list, pte_list_walk_fn fn)
 	WARN_ON(desc_get_nulls_value(desc) != pte_list);
 }
 
+/* The caller should hold rcu lock. */
+typedef void (*pte_list_walk_lockless_fn) (u64 *spte, int level);
+static void pte_list_walk_lockless(unsigned long *pte_list,
+				   pte_list_walk_lockless_fn fn, int level)
+{
+	struct pte_list_desc *desc;
+	unsigned long pte_list_value;
+	int i;
+
+restart:
+	pte_list_value = ACCESS_ONCE(*pte_list);
+	if (!pte_list_value)
+		return;
+
+	if (!(pte_list_value & 1))
+		return fn((u64 *)pte_list_value, level);
+
+	/*
+	 * fetch pte_list before read sptes in the desc, see the comments
+	 * in pte_list_add().
+	 *
+	 * There is the data dependence since the desc is got from pte_list.
+	 */
+	smp_read_barrier_depends();
+
+	desc = (struct pte_list_desc *)(pte_list_value & ~1ul);
+	while (!desc_is_a_nulls(desc)) {
+		for (i = 0; i < PTE_LIST_EXT && desc->sptes[i]; ++i)
+			fn(desc->sptes[i], level);
+
+		desc = ACCESS_ONCE(desc->more);
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
@@ -4557,7 +4606,7 @@ int kvm_mmu_module_init(void)
 {
 	pte_list_desc_cache = kmem_cache_create("pte_list_desc",
 					    sizeof(struct pte_list_desc),
-					    0, 0, NULL);
+					    0, SLAB_DESTROY_BY_RCU, NULL);
 	if (!pte_list_desc_cache)
 		goto nomem;
 
-- 
1.8.1.4

