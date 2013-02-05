Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756286Ab3BEIyE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 03:54:04 -0500
Received: from e28smtp02.in.ibm.com ([122.248.162.2]:50688 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754644Ab3BEIyB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 03:54:01 -0500
Message-ID: <5110C8A0.5050405@linux.vnet.ibm.com>
Date: Tue, 05 Feb 2013 16:53:52 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, Gleb Natapov <gleb@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: [PATCH v3 2/5] KVM: MMU: clarify the logic in kvm_set_pte_rmapp
References: <5110C853.4080705@linux.vnet.ibm.com>
In-Reply-To: <5110C853.4080705@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13020508-5816-0000-0000-0000068D9952
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In kvm_set_pte_rmapp, if the new mapping is writable, we need to remove
all spte pointing to that page otherwisewe we only need to adjust the sptes
to let them point to the new page. This patch clarifys the logic and makes
the later patch more clean

[ Impact: no logic changed ]

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
---
 arch/x86/kvm/mmu.c |   17 ++++++++---------
 1 files changed, 8 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 68d4d5f..a0dc0d7 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -1225,16 +1225,16 @@ static int kvm_set_pte_rmapp(struct kvm *kvm, unsigned long *rmapp,
 	WARN_ON(pte_huge(*ptep));
 	new_pfn = pte_pfn(*ptep);

-	for (sptep = rmap_get_first(*rmapp, &iter); sptep;) {
-		BUG_ON(!is_shadow_present_pte(*sptep));
-		rmap_printk("kvm_set_pte_rmapp: spte %p %llx\n", sptep, *sptep);
+	if (pte_write(*ptep))
+		need_flush = kvm_unmap_rmapp(kvm, rmapp, slot, data);
+	else
+		for (sptep = rmap_get_first(*rmapp, &iter); sptep;) {
+			BUG_ON(!is_shadow_present_pte(*sptep));
+			rmap_printk("kvm_set_pte_rmapp: spte %p %llx\n",
+				    sptep, *sptep);

-		need_flush = 1;
+			need_flush = 1;

-		if (pte_write(*ptep)) {
-			drop_spte(kvm, sptep);
-			sptep = rmap_get_first(*rmapp, &iter);
-		} else {
 			new_spte = *sptep & ~PT64_BASE_ADDR_MASK;
 			new_spte |= (u64)new_pfn << PAGE_SHIFT;

@@ -1246,7 +1246,6 @@ static int kvm_set_pte_rmapp(struct kvm *kvm, unsigned long *rmapp,
 			mmu_spte_set(sptep, new_spte);
 			sptep = rmap_get_next(&iter);
 		}
-	}

 	if (need_flush)
 		kvm_flush_remote_tlbs(kvm);
-- 
1.7.7.6

