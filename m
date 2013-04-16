Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755425Ab3DPGjm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 02:39:42 -0400
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:33710 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754034Ab3DPGjk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 02:39:40 -0400
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
To: mtosatti@redhat.com
Cc: gleb@redhat.com, avi.kivity@gmail.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Subject: [PATCH v3 09/15] KVM: MMU: introduce free_meslot_rmap_desc_nolock
Date: Tue, 16 Apr 2013 14:32:47 +0800
Message-Id: <1366093973-2617-10-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1366093973-2617-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
References: <1366093973-2617-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
x-cbid: 13041606-3568-0000-0000-000003702C34
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It frees pte-list-descs used by memslot rmap after update
memslot is completed

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
---
 arch/x86/kvm/mmu.c |   26 ++++++++++++++++++++++++++
 arch/x86/kvm/mmu.h |    1 +
 2 files changed, 27 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index e6414d2..9ac584f 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -1049,6 +1049,22 @@ static void pte_list_clear_concurrently(u64 *spte, unsigned long *pte_list)
 	return;
 }
 
+static void pte_list_free_desc(unsigned long *pte_list)
+{
+	struct pte_list_desc *desc, *next;
+	unsigned long pte_value = *pte_list;
+
+	if (!(pte_value & 1))
+		return;
+
+	desc = (struct pte_list_desc *)(pte_value & ~1ul);
+	do {
+		next = desc->more;
+		mmu_free_pte_list_desc(desc);
+		desc = next;
+	} while (desc);
+}
+
 typedef void (*pte_list_walk_fn) (u64 *spte);
 static void pte_list_walk(unsigned long *pte_list, pte_list_walk_fn fn)
 {
@@ -1786,6 +1802,16 @@ unmap_memslot_rmap_nolock(struct kvm *kvm, struct kvm_memory_slot *slot)
 	walk_memslot_rmap_nolock(slot, unmap_invalid_rmap_nolock, kvm);
 }
 
+static void free_rmap_desc_nolock(unsigned long *rmapp, void *data)
+{
+	pte_list_free_desc(rmapp);
+}
+
+void free_meslot_rmap_desc_nolock(struct kvm_memory_slot *slot)
+{
+	walk_memslot_rmap_nolock(slot, free_rmap_desc_nolock, NULL);
+}
+
 #ifdef MMU_DEBUG
 static int is_empty_shadow_page(u64 *spt)
 {
diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
index d6aa31a..ab434b7 100644
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -130,4 +130,5 @@ struct rmap_operations {
 };
 
 void init_memslot_rmap_ops(struct kvm_memory_slot *slot);
+void free_meslot_rmap_desc_nolock(struct kvm_memory_slot *slot);
 #endif
-- 
1.7.7.6

