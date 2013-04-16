Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755539Ab3DPGkD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 02:40:03 -0400
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:49379 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754069Ab3DPGjl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 02:39:41 -0400
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
To: mtosatti@redhat.com
Cc: gleb@redhat.com, avi.kivity@gmail.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Subject: [PATCH v3 06/15] KVM: MMU: allow concurrently clearing spte on remove-only pte-list
Date: Tue, 16 Apr 2013 14:32:44 +0800
Message-Id: <1366093973-2617-7-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1366093973-2617-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
References: <1366093973-2617-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13041606-0260-0000-0000-000002D0AD31
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch introduce PTE_LIST_SPTE_SKIP which is the placeholder and
it will be set on pte-list after removing a spte so that other sptes
on this pte_list are not moved and the pte-list-descs on the pte-list
are not freed.

If vcpu can not add spte to the pte-list (e.g. the rmap on invalid
memslot) and spte can not be freed during pte-list walk, we can
concurrently clear sptes on the pte-list, the worst case is, we double
zap a spte that is safe.

This patch only ensures that concurrently zapping pte-list is safe,
we will keep spte available during concurrently clearing in the later
patches

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
---
 arch/x86/kvm/mmu.c |   62 +++++++++++++++++++++++++++++++++++++++++++++++----
 1 files changed, 57 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 99ad2a4..850eab5 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -900,6 +900,18 @@ static int mapping_level(struct kvm_vcpu *vcpu, gfn_t large_gfn)
 }
 
 /*
+ * It is the placeholder and it will be set on pte-list after removing
+ * a spte so that other sptes on this pte_list are not moved and the
+ * pte-list-descs on the pte-list are not freed.
+ *
+ * If vcpu can not add spte to the pte-list (e.g. the rmap on invalid
+ * memslot) and spte can not be freed during pte-list walk, we can
+ * cocurrently clear sptes on the pte-list, the worst case is, we double
+ * zap a spte that is safe.
+ */
+#define PTE_LIST_SPTE_SKIP	(u64 *)((~0x0ul) & (~1))
+
+/*
  * Pte mapping structures:
  *
  * If pte_list bit zero is zero, then pte_list point to the spte.
@@ -1003,6 +1015,40 @@ static void pte_list_remove(u64 *spte, unsigned long *pte_list)
 	}
 }
 
+static void pte_list_clear_concurrently(u64 *spte, unsigned long *pte_list)
+{
+	struct pte_list_desc *desc;
+	unsigned long pte_value = *pte_list;
+	int i;
+
+	/* Empty pte list stores nothing. */
+	WARN_ON(!pte_value);
+
+	if (!(pte_value & 1)) {
+		if ((u64 *)pte_value == spte) {
+			*pte_list = (unsigned long)PTE_LIST_SPTE_SKIP;
+			return;
+		}
+
+		/* someone has already cleared it. */
+		WARN_ON(pte_value != (unsigned long)PTE_LIST_SPTE_SKIP);
+		return;
+	}
+
+	desc = (struct pte_list_desc *)(pte_value & ~1ul);
+	while (desc) {
+		for (i = 0; i < PTE_LIST_EXT && desc->sptes[i]; ++i)
+			if (desc->sptes[i] == spte) {
+				desc->sptes[i] = PTE_LIST_SPTE_SKIP;
+				return;
+			}
+
+		desc = desc->more;
+	}
+
+	return;
+}
+
 typedef void (*pte_list_walk_fn) (u64 *spte);
 static void pte_list_walk(unsigned long *pte_list, pte_list_walk_fn fn)
 {
@@ -1214,6 +1260,12 @@ spte_write_protect(struct kvm *kvm, u64 *sptep, bool *flush, bool pt_protect)
 	return false;
 }
 
+/* PTE_LIST_SPTE_SKIP is only used on invalid rmap. */
+static void check_valid_sptep(u64 *sptep)
+{
+	WARN_ON(sptep == PTE_LIST_SPTE_SKIP || !is_rmap_spte(*sptep));
+}
+
 static bool __rmap_write_protect(struct kvm *kvm, unsigned long *rmapp,
 				 bool pt_protect)
 {
@@ -1222,7 +1274,7 @@ static bool __rmap_write_protect(struct kvm *kvm, unsigned long *rmapp,
 	bool flush = false;
 
 	for (sptep = rmap_get_first(*rmapp, &iter); sptep;) {
-		BUG_ON(!(*sptep & PT_PRESENT_MASK));
+		check_valid_sptep(sptep);
 		if (spte_write_protect(kvm, sptep, &flush, pt_protect)) {
 			sptep = rmap_get_first(*rmapp, &iter);
 			continue;
@@ -1293,7 +1345,7 @@ static int kvm_unmap_rmapp(struct kvm *kvm, unsigned long *rmapp)
 	int need_tlb_flush = 0;
 
 	while ((sptep = rmap_get_first(*rmapp, &iter))) {
-		BUG_ON(!(*sptep & PT_PRESENT_MASK));
+		check_valid_sptep(sptep);
 		rmap_printk("kvm_rmap_unmap_hva: spte %p %llx\n", sptep, *sptep);
 
 		drop_spte(kvm, sptep);
@@ -1322,7 +1374,7 @@ static int kvm_set_pte_rmapp(struct kvm *kvm, unsigned long *rmapp,
 	new_pfn = pte_pfn(*ptep);
 
 	for (sptep = rmap_get_first(*rmapp, &iter); sptep;) {
-		BUG_ON(!is_shadow_present_pte(*sptep));
+		check_valid_sptep(sptep);
 		rmap_printk("kvm_set_pte_rmapp: spte %p %llx\n", sptep, *sptep);
 
 		need_flush = 1;
@@ -1455,7 +1507,7 @@ static int kvm_age_rmapp(struct kvm *kvm, unsigned long *rmapp)
 
 	for (sptep = rmap_get_first(*rmapp, &iter); sptep;
 	     sptep = rmap_get_next(&iter)) {
-		BUG_ON(!is_shadow_present_pte(*sptep));
+		check_valid_sptep(sptep);
 
 		if (*sptep & shadow_accessed_mask) {
 			young = 1;
@@ -1493,7 +1545,7 @@ static int kvm_test_age_rmapp(struct kvm *kvm, unsigned long *rmapp)
 
 	for (sptep = rmap_get_first(*rmapp, &iter); sptep;
 	     sptep = rmap_get_next(&iter)) {
-		BUG_ON(!is_shadow_present_pte(*sptep));
+		check_valid_sptep(sptep);
 
 		if (*sptep & shadow_accessed_mask) {
 			young = 1;
-- 
1.7.7.6

