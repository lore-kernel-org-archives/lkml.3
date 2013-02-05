Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756657Ab3BEIzI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 03:55:08 -0500
Received: from e28smtp02.in.ibm.com ([122.248.162.2]:51197 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756609Ab3BEIzF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 03:55:05 -0500
Message-ID: <5110C8E3.1080009@linux.vnet.ibm.com>
Date: Tue, 05 Feb 2013 16:54:59 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, Gleb Natapov <gleb@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: [PATCH v3 4/5] KVM: MMU: fix spte assertion
References: <5110C853.4080705@linux.vnet.ibm.com>
In-Reply-To: <5110C853.4080705@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13020508-5816-0000-0000-0000068D9A4C
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
index 2291ea3..58f813a 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -1009,7 +1009,9 @@ static u64 *pte_list_get_next(struct pte_list_iterator *iter)

 #define for_each_spte_in_pte_list(pte_list, iter, spte)		\
 	   for (spte = pte_list_get_first(pte_list, &(iter));	\
-	      spte != NULL; spte = pte_list_get_next(&(iter)))
+	      spte != NULL &&					\
+	      ({WARN_ON(!is_shadow_present_pte(*(spte))); 1; });\
+		   spte = pte_list_get_next(&iter))

 #define for_each_spte_in_rmap(rmap, iter, spte)			\
 	   for_each_spte_in_pte_list(rmap, iter, spte)
@@ -1128,11 +1130,8 @@ static bool __rmap_write_protect(struct kvm *kvm, unsigned long *rmapp,
 	struct pte_list_iterator iter;
 	bool flush = false;

-	for_each_spte_in_rmap(*rmapp, iter, sptep) {
-		BUG_ON(!(*sptep & PT_PRESENT_MASK));
-
+	for_each_spte_in_rmap(*rmapp, iter, sptep)
 		flush |= spte_write_protect(kvm, sptep, pt_protect);
-	}

 	return flush;
 }
@@ -1215,7 +1214,6 @@ static int kvm_set_pte_rmapp(struct kvm *kvm, unsigned long *rmapp,
 		need_flush = kvm_unmap_rmapp(kvm, rmapp, slot, data);
 	else
 		for_each_spte_in_rmap(*rmapp, iter, sptep) {
-			BUG_ON(!is_shadow_present_pte(*sptep));
 			rmap_printk("kvm_set_pte_rmapp: spte %p %llx\n",
 				    sptep, *sptep);

@@ -1336,15 +1334,12 @@ static int kvm_age_rmapp(struct kvm *kvm, unsigned long *rmapp,
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
@@ -1366,14 +1361,11 @@ static int kvm_test_age_rmapp(struct kvm *kvm, unsigned long *rmapp,
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

