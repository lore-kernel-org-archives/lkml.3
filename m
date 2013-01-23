Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754925Ab3AWKKw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 05:10:52 -0500
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:42528 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754210Ab3AWKKu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 05:10:50 -0500
Message-ID: <50FFB721.2020509@linux.vnet.ibm.com>
Date: Wed, 23 Jan 2013 18:10:41 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, Avi Kivity <avi.kivity@gmail.com>,
        Gleb Natapov <gleb@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: [PATCH v2 12/12] KVM: MMU: fast drop all spte on the pte_list
References: <50FFB5A1.5090708@linux.vnet.ibm.com>
In-Reply-To: <50FFB5A1.5090708@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13012310-7014-0000-0000-000002815D55
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the pte_list need to be destroyed, no need to delete its spte one
by one, we can directly reset it and free the memory its used

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
---
 arch/x86/kvm/mmu.c |   36 +++++++++++++++++++++++++++---------
 1 files changed, 27 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 2c0a786..0afe8da 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -968,6 +968,25 @@ static void pte_list_remove(u64 *spte, unsigned long *pte_list)
 	}
 }

+static void pte_list_destroy(unsigned long *pte_list)
+{
+	struct pte_list_desc *desc;
+	unsigned long list_value = *pte_list;
+
+	*pte_list = 0;
+
+	if (!(list_value & 1))
+		return;
+
+	desc = (struct pte_list_desc *)(list_value & ~1ul);
+	while (desc) {
+		struct pte_list_desc *next_desc = desc->more;
+
+		mmu_free_pte_list_desc(desc);
+		desc = next_desc;
+	}
+}
+
 /*
  * Used by the following functions to iterate through the sptes linked by a
  * pte_list.  All fields are private and not assumed to be used outside.
@@ -1206,17 +1225,17 @@ static bool rmap_write_protect(struct kvm *kvm, u64 gfn)
 static int kvm_unmap_rmapp(struct kvm *kvm, unsigned long *rmapp,
 			   struct kvm_memory_slot *slot, unsigned long data)
 {
-	u64 *sptep;
 	struct pte_list_iterator iter;
+	u64 *sptep;
 	int need_tlb_flush = 0;

-restart:
 	for_each_spte_in_rmap(*rmapp, iter, sptep) {
-		drop_spte(kvm, sptep);
+		mmu_spte_clear_track_bits(sptep);
 		need_tlb_flush = 1;
-		goto restart;
 	}

+	pte_list_destroy(rmapp);
+
 	return need_tlb_flush;
 }

@@ -2041,11 +2060,10 @@ static void kvm_mmu_unlink_parents(struct kvm *kvm, struct kvm_mmu_page *sp)
 	u64 *sptep;
 	struct pte_list_iterator iter;

-restart:
-	for_each_spte_in_rmap(sp->parent_ptes, iter, sptep) {
-		drop_parent_pte(sp, sptep);
-		goto restart;
-	}
+	for_each_spte_in_rmap(sp->parent_ptes, iter, sptep)
+		mmu_spte_clear_no_track(sptep);
+
+	pte_list_destroy(&sp->parent_ptes);
 }

 static int mmu_zap_unsync_children(struct kvm *kvm,
-- 
1.7.7.6

