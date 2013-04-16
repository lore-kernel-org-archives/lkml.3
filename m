Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755645Ab3DPGkK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 02:40:10 -0400
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:33806 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755553Ab3DPGkH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 02:40:07 -0400
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
To: mtosatti@redhat.com
Cc: gleb@redhat.com, avi.kivity@gmail.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Subject: [PATCH v3 07/15] KVM: MMU: introduce invalid rmap handlers
Date: Tue, 16 Apr 2013 14:32:45 +0800
Message-Id: <1366093973-2617-8-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1366093973-2617-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
References: <1366093973-2617-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13041606-3568-0000-0000-000003702C8E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Invalid rmaps is the rmap of the invalid memslot which is being
deleted, especially, we can treat all rmaps are invalid when
kvm is being destroyed since all memslot will be deleted soon.
MMU should remove all sptes on these rmaps before the invalid
memslot fully deleted

The reason why we separately handle invalid rmap is we want to
unmap invalid-rmap out of mmu-lock to achieve scale performance
on intensive memory and vcpu used guest

This patch make all the operations on invalid rmap are clearing
spte and reset rmap's entry. In the later patch, we will introduce
the path out of mmu-lock to unmap invalid rmap

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
---
 arch/x86/kvm/mmu.c |   80 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 80 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 850eab5..2a7a5d0 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -1606,6 +1606,86 @@ void init_memslot_rmap_ops(struct kvm_memory_slot *slot)
 	slot->arch.ops = &normal_rmap_ops;
 }
 
+static int invalid_rmap_add(struct kvm_vcpu *vcpu, u64 *spte,
+			    unsigned long *pte_list)
+{
+	WARN_ON(1);
+	return 0;
+}
+
+static void invalid_rmap_remove(u64 *spte, unsigned long *rmapp)
+{
+	pte_list_clear_concurrently(spte, rmapp);
+}
+
+static bool invalid_rmap_write_protect(struct kvm *kvm, unsigned long *rmapp,
+				       bool pt_protect)
+{
+	WARN_ON(1);
+	return false;
+}
+
+static int __kvm_unmap_invalid_rmapp(unsigned long *rmapp)
+{
+	u64 *sptep;
+	struct rmap_iterator iter;
+
+	for (sptep = rmap_get_first(*rmapp, &iter); sptep;
+	      sptep = rmap_get_next(&iter)) {
+		if (sptep == PTE_LIST_SPTE_SKIP)
+			continue;
+
+		/* Do not call .rmap_remove(). */
+		if (mmu_spte_clear_track_bits(sptep))
+			pte_list_clear_concurrently(sptep, rmapp);
+	}
+
+	return 0;
+}
+
+static int kvm_unmap_invalid_rmapp(struct kvm *kvm, unsigned long *rmapp)
+{
+	return __kvm_unmap_invalid_rmapp(rmapp);
+}
+
+static int invalid_rmap_set_pte(struct kvm *kvm, unsigned long *rmapp,
+				pte_t *ptep)
+{
+	return kvm_unmap_invalid_rmapp(kvm, rmapp);
+}
+
+/*
+ * Invalid rmaps is the rmap of the invalid memslot which is being
+ * deleted, especially, we can treat all rmaps are invalid when
+ * kvm is being destroyed since all memslot will be deleted soon.
+ * MMU should remove all sptes on these rmaps before the invalid
+ * memslot fully deleted.
+ *
+ * VCPUs can not do address translation on invalid memslots, that
+ * means no sptes can be added to their rmaps and no shadow page
+ * can be created in their memory regions, so rmap_add and
+ * rmap_write_protect on invalid memslot should never happen.
+ * Any sptes on invalid rmaps are stale and can not be reused,
+ * we drop all sptes on any other operations. So, all handlers
+ * on invalid rmap do the same thing - remove and zap sptes on
+ * the rmap.
+ *
+ * KVM use pte_list_clear_concurrently to clear spte on invalid
+ * rmap which resets rmap's entry but keeps rmap's memory. The
+ * rmap is fully destroyed when free the invalid memslot.
+ */
+static struct rmap_operations invalid_rmap_ops = {
+	.rmap_add = invalid_rmap_add,
+	.rmap_remove = invalid_rmap_remove,
+
+	.rmap_write_protect = invalid_rmap_write_protect,
+
+	.rmap_set_pte = invalid_rmap_set_pte,
+	.rmap_age = kvm_unmap_invalid_rmapp,
+	.rmap_test_age = kvm_unmap_invalid_rmapp,
+	.rmap_unmap = kvm_unmap_invalid_rmapp
+};
+
 #ifdef MMU_DEBUG
 static int is_empty_shadow_page(u64 *spt)
 {
-- 
1.7.7.6

