Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752588AbaHDUzC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 16:55:02 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:29246 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751119AbaHDUzA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 16:55:00 -0400
From: Sasha Levin <sasha.levin@oracle.com>
To: gleb@kernel.org, pbonzini@redhat.com
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sasha Levin <sasha.levin@oracle.com>
Subject: [PATCH] KVM: MMU: Use hashtable for MMU page hash
Date: Mon,  4 Aug 2014 16:54:49 -0400
Message-Id: <1407185689-27727-1-git-send-email-sasha.levin@oracle.com>
X-Mailer: git-send-email 1.9.1
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the kernel hashtable interface instead of the hlist interface.
This allows us to eliminate some unneeded code and make the code
simpler.

Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
---
 arch/x86/include/asm/kvm_host.h |    4 ++--
 arch/x86/kvm/mmu.c              |   16 ++++++----------
 2 files changed, 8 insertions(+), 12 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 5724601..2c8e3c5 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -17,6 +17,7 @@
 #include <linux/tracepoint.h>
 #include <linux/cpumask.h>
 #include <linux/irq_work.h>
+#include <linux/hashtable.h>
 
 #include <linux/kvm.h>
 #include <linux/kvm_para.h>
@@ -90,7 +91,6 @@ static inline gfn_t gfn_to_index(gfn_t gfn, gfn_t base_gfn, int level)
 #define KVM_PERMILLE_MMU_PAGES 20
 #define KVM_MIN_ALLOC_MMU_PAGES 64
 #define KVM_MMU_HASH_SHIFT 10
-#define KVM_NUM_MMU_PAGES (1 << KVM_MMU_HASH_SHIFT)
 #define KVM_MIN_FREE_MMU_PAGES 5
 #define KVM_REFILL_PAGES 25
 #define KVM_MAX_CPUID_ENTRIES 80
@@ -556,7 +556,7 @@ struct kvm_arch {
 	unsigned int n_max_mmu_pages;
 	unsigned int indirect_shadow_pages;
 	unsigned long mmu_valid_gen;
-	struct hlist_head mmu_page_hash[KVM_NUM_MMU_PAGES];
+	DECLARE_HASHTABLE(mmu_page_hash, KVM_MMU_HASH_SHIFT);
 	/*
 	 * Hash table of struct kvm_mmu_page.
 	 */
diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 9314678..db1ae90 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -1525,7 +1525,7 @@ static inline void kvm_mod_used_mmu_pages(struct kvm *kvm, int nr)
 static void kvm_mmu_free_page(struct kvm_mmu_page *sp)
 {
 	ASSERT(is_empty_shadow_page(sp->spt));
-	hlist_del(&sp->hash_link);
+	hash_del(&sp->hash_link);
 	list_del(&sp->link);
 	free_page((unsigned long)sp->spt);
 	if (!sp->role.direct)
@@ -1533,11 +1533,6 @@ static void kvm_mmu_free_page(struct kvm_mmu_page *sp)
 	kmem_cache_free(mmu_page_header_cache, sp);
 }
 
-static unsigned kvm_page_table_hashfn(gfn_t gfn)
-{
-	return gfn & ((1 << KVM_MMU_HASH_SHIFT) - 1);
-}
-
 static void mmu_page_add_parent_pte(struct kvm_vcpu *vcpu,
 				    struct kvm_mmu_page *sp, u64 *parent_pte)
 {
@@ -1724,8 +1719,8 @@ static void kvm_mmu_commit_zap_page(struct kvm *kvm,
  * all the obsolete pages.
  */
 #define for_each_gfn_sp(_kvm, _sp, _gfn)				\
-	hlist_for_each_entry(_sp,					\
-	  &(_kvm)->arch.mmu_page_hash[kvm_page_table_hashfn(_gfn)], hash_link) \
+	hash_for_each_possible((_kvm)->arch.mmu_page_hash, (_sp),	\
+				hash_link, (_gfn))			\
 		if ((_sp)->gfn != (_gfn)) {} else
 
 #define for_each_gfn_indirect_valid_sp(_kvm, _sp, _gfn)			\
@@ -1973,8 +1968,7 @@ static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu,
 		return sp;
 	sp->gfn = gfn;
 	sp->role = role;
-	hlist_add_head(&sp->hash_link,
-		&vcpu->kvm->arch.mmu_page_hash[kvm_page_table_hashfn(gfn)]);
+	hash_add(vcpu->kvm->arch.mmu_page_hash, &sp->hash_link, gfn);
 	if (!direct) {
 		if (rmap_write_protect(vcpu->kvm, gfn))
 			kvm_flush_remote_tlbs(vcpu->kvm);
@@ -3885,6 +3879,8 @@ static void init_kvm_nested_mmu(struct kvm_vcpu *vcpu)
 
 static void init_kvm_mmu(struct kvm_vcpu *vcpu)
 {
+	hash_init(kvm->arch.mmu_page_hash);
+
 	if (mmu_is_nested(vcpu))
 		return init_kvm_nested_mmu(vcpu);
 	else if (tdp_enabled)
-- 
1.7.10.4

