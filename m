Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754899Ab3AWKKU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 05:10:20 -0500
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:60286 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754481Ab3AWKKR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 05:10:17 -0500
Message-ID: <50FFB6FF.5060607@linux.vnet.ibm.com>
Date: Wed, 23 Jan 2013 18:10:07 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, Avi Kivity <avi.kivity@gmail.com>,
        Gleb Natapov <gleb@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: [PATCH v2 11/12] KVM: MMU: fix spte assertion
References: <50FFB5A1.5090708@linux.vnet.ibm.com>
In-Reply-To: <50FFB5A1.5090708@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13012310-0260-0000-0000-00000271660B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

PT_PRESENT_MASK bit is not enough to see the spte has already been mapped
into pte-list for mmio spte also set this bit. Use is_shadow_present_pte
instead to fix it

Also, this patch move many assertions to the common place to clean up the
code

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
---
 arch/x86/kvm/mmu.c |   20 ++++++--------------
 1 files changed, 6 insertions(+), 14 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index b7da3fb..2c0a786 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -1032,7 +1032,9 @@ static u64 *pte_list_get_next(struct pte_list_iterator *iter)

 #define for_each_spte_in_pte_list(pte_list, iter, spte)		\
 	   for (spte = pte_list_get_first(pte_list, &(iter));	\
-	      spte != NULL; spte = pte_list_get_next(&(iter)))
+	      spte != NULL &&					\
+	      ({WARN_ON(!is_shadow_present_pte(*(spte))); 1; });\
+		   spte = pte_list_get_next(&iter))

 #define for_each_spte_in_rmap(rmap, iter, spte)			\
 	   for_each_spte_in_pte_list(rmap, iter, spte)
@@ -1151,11 +1153,8 @@ static bool __rmap_write_protect(struct kvm *kvm, unsigned long *rmapp,
 	struct pte_list_iterator iter;
 	bool flush = false;

-	for_each_spte_in_rmap(*rmapp, iter, sptep) {
-		BUG_ON(!(*sptep & PT_PRESENT_MASK));
-
+	for_each_spte_in_rmap(*rmapp, iter, sptep)
 		spte_write_protect(kvm, sptep, &flush, pt_protect);
-	}

 	return flush;
 }
@@ -1236,7 +1235,6 @@ static int kvm_set_pte_rmapp(struct kvm *kvm, unsigned long *rmapp,

 restart:
 	for_each_spte_in_rmap(*rmapp, iter, sptep) {
-		BUG_ON(!is_shadow_present_pte(*sptep));
 		rmap_printk("kvm_set_pte_rmapp: spte %p %llx\n", sptep, *sptep);

 		need_flush = 1;
@@ -1361,15 +1359,12 @@ static int kvm_age_rmapp(struct kvm *kvm, unsigned long *rmapp,
 		goto out;
 	}

-	for_each_spte_in_rmap(*rmapp, iter, sptep) {
-		BUG_ON(!is_shadow_present_pte(*sptep));
-
+	for_each_spte_in_rmap(*rmapp, iter, sptep)
 		if (*sptep & shadow_accessed_mask) {
 			young = 1;
 			clear_bit((ffs(shadow_accessed_mask) - 1),
 				 (unsigned long *)sptep);
 		}
-	}
 out:
 	/* @data has hva passed to kvm_age_hva(). */
 	trace_kvm_age_page(data, slot, young);
@@ -1391,14 +1386,11 @@ static int kvm_test_age_rmapp(struct kvm *kvm, unsigned long *rmapp,
 	if (!shadow_accessed_mask)
 		goto out;

-	for_each_spte_in_rmap(*rmapp, iter, sptep) {
-		BUG_ON(!is_shadow_present_pte(*sptep));
-
+	for_each_spte_in_rmap(*rmapp, iter, sptep)
 		if (*sptep & shadow_accessed_mask) {
 			young = 1;
 			break;
 		}
-	}
 out:
 	return young;
 }
-- 
1.7.7.6

