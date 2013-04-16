Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754701Ab3DPGdY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 02:33:24 -0400
Received: from e28smtp04.in.ibm.com ([122.248.162.4]:57501 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753829Ab3DPGdT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 02:33:19 -0400
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
To: mtosatti@redhat.com
Cc: gleb@redhat.com, avi.kivity@gmail.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Subject: [PATCH v3 05/15] KVM: MMU: allow per-rmap operations
Date: Tue, 16 Apr 2013 14:32:43 +0800
Message-Id: <1366093973-2617-6-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1366093973-2617-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
References: <1366093973-2617-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13041606-5564-0000-0000-00000784CFF5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce rmap_operations to allow rmap having different operations,
then, we are able to handle invalid rmap specially

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
---
 arch/x86/include/asm/kvm_host.h |    1 +
 arch/x86/kvm/mmu.c              |   31 ++++++++++++++++++++++++-------
 arch/x86/kvm/mmu.h              |   16 ++++++++++++++++
 arch/x86/kvm/x86.c              |    1 +
 4 files changed, 42 insertions(+), 7 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 4e1f7cb..5fd6ed1 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -511,6 +511,7 @@ struct kvm_lpage_info {
 };
 
 struct kvm_arch_memory_slot {
+	struct rmap_operations *ops;
 	unsigned long *rmap[KVM_NR_PAGE_SIZES];
 	struct kvm_lpage_info *lpage_info[KVM_NR_PAGE_SIZES - 1];
 };
diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 514f5b1..99ad2a4 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -1055,13 +1055,13 @@ static int slot_rmap_add(struct kvm_memory_slot *slot,
 			 struct kvm_vcpu *vcpu, unsigned long *rmapp,
 			 u64 *spte)
 {
-	return pte_list_add(vcpu, spte, rmapp);
+	return slot->arch.ops->rmap_add(vcpu, spte, rmapp);
 }
 
 static void slot_rmap_remove(struct kvm_memory_slot *slot,
 			     unsigned long *rmapp, u64 *spte)
 {
-	pte_list_remove(spte, rmapp);
+	slot->arch.ops->rmap_remove(spte, rmapp);
 }
 
 static int rmap_add(struct kvm_vcpu *vcpu, u64 *spte, gfn_t gfn)
@@ -1238,7 +1238,7 @@ static bool slot_rmap_write_protect(struct kvm_memory_slot *slot,
 				    struct kvm *kvm, unsigned long *rmapp,
 				    bool pt_protect)
 {
-	return __rmap_write_protect(kvm, rmapp, pt_protect);
+	return slot->arch.ops->rmap_write_protect(kvm, rmapp, pt_protect);
 }
 
 /**
@@ -1306,7 +1306,7 @@ static int kvm_unmap_rmapp(struct kvm *kvm, unsigned long *rmapp)
 static int slot_rmap_unmap(struct kvm *kvm, unsigned long *rmapp,
 			   struct kvm_memory_slot *slot, unsigned long data)
 {
-	return kvm_unmap_rmapp(kvm, rmapp);
+	return slot->arch.ops->rmap_unmap(kvm, rmapp);
 }
 
 static int kvm_set_pte_rmapp(struct kvm *kvm, unsigned long *rmapp,
@@ -1353,7 +1353,7 @@ static int kvm_set_pte_rmapp(struct kvm *kvm, unsigned long *rmapp,
 static int slot_rmap_set_pte(struct kvm *kvm, unsigned long *rmapp,
 			     struct kvm_memory_slot *slot, unsigned long data)
 {
-	return kvm_set_pte_rmapp(kvm, rmapp, (pte_t *)data);
+	return slot->arch.ops->rmap_set_pte(kvm, rmapp, (pte_t *)data);
 }
 
 static int kvm_handle_hva_range(struct kvm *kvm,
@@ -1470,7 +1470,7 @@ out:
 static int slot_rmap_age(struct kvm *kvm, unsigned long *rmapp,
 			 struct kvm_memory_slot *slot, unsigned long data)
 {
-	int young = kvm_age_rmapp(kvm, rmapp);
+	int young = slot->arch.ops->rmap_age(kvm, rmapp);
 
 	/* @data has hva passed to kvm_age_hva(). */
 	trace_kvm_age_page(data, slot, young);
@@ -1508,7 +1508,7 @@ static int slot_rmap_test_age(struct kvm *kvm, unsigned long *rmapp,
 			      struct kvm_memory_slot *slot,
 			      unsigned long data)
 {
-	return kvm_test_age_rmapp(kvm, rmapp);
+	return slot->arch.ops->rmap_test_age(kvm, rmapp);
 }
 
 #define RMAP_RECYCLE_THRESHOLD 1000
@@ -1537,6 +1537,23 @@ int kvm_test_age_hva(struct kvm *kvm, unsigned long hva)
 	return kvm_handle_hva(kvm, hva, 0, slot_rmap_test_age);
 }
 
+static struct rmap_operations normal_rmap_ops = {
+	.rmap_add = pte_list_add,
+	.rmap_remove = pte_list_remove,
+
+	.rmap_write_protect = __rmap_write_protect,
+
+	.rmap_set_pte = kvm_set_pte_rmapp,
+	.rmap_age = kvm_age_rmapp,
+	.rmap_test_age = kvm_test_age_rmapp,
+	.rmap_unmap = kvm_unmap_rmapp
+};
+
+void init_memslot_rmap_ops(struct kvm_memory_slot *slot)
+{
+	slot->arch.ops = &normal_rmap_ops;
+}
+
 #ifdef MMU_DEBUG
 static int is_empty_shadow_page(u64 *spt)
 {
diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
index ffd40d1..bb2b22e 100644
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -114,4 +114,20 @@ static inline bool permission_fault(struct kvm_mmu *mmu, unsigned pte_access,
 	return (mmu->permissions[pfec >> 1] >> pte_access) & 1;
 }
 
+struct rmap_operations {
+	int (*rmap_add)(struct kvm_vcpu *vcpu, u64 *spte,
+			unsigned long *rmap);
+	void (*rmap_remove)(u64 *spte, unsigned long *rmap);
+
+	bool (*rmap_write_protect)(struct kvm *kvm, unsigned long *rmap,
+				   bool pt_protect);
+
+	int (*rmap_set_pte)(struct kvm *kvm, unsigned long *rmap,
+			    pte_t *ptep);
+	int (*rmap_age)(struct kvm *kvm, unsigned long *rmap);
+	int (*rmap_test_age)(struct kvm *kvm, unsigned long *rmap);
+	int (*rmap_unmap)(struct kvm *kvm, unsigned long *rmapp);
+};
+
+void init_memslot_rmap_ops(struct kvm_memory_slot *slot);
 #endif
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 839e666..bec83cd 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -6919,6 +6919,7 @@ static int kvm_arch_create_memslot(struct kvm_memory_slot *slot)
 		}
 	}
 
+	init_memslot_rmap_ops(slot);
 	return 0;
 
 out_free:
-- 
1.7.7.6

