Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754513Ab3JWNcn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Oct 2013 09:32:43 -0400
Received: from e23smtp02.au.ibm.com ([202.81.31.144]:54245 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752063Ab3JWNaG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Oct 2013 09:30:06 -0400
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
To: gleb@redhat.com
Cc: avi.kivity@gmail.com, mtosatti@redhat.com, pbonzini@redhat.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Subject: [PATCH v3 12/15] KVM: MMU: check last spte with unawareness of mapping level
Date: Wed, 23 Oct 2013 21:29:30 +0800
Message-Id: <1382534973-13197-13-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1382534973-13197-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
References: <1382534973-13197-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13102313-5490-0000-0000-0000045F7D90
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The sptes on the middle level should obey these rules:
- they are always writable
- they are not pointing to process's page, so that SPTE_HOST_WRITEABLE has
  no chance to be set

So we can check last spte by using PT_WRITABLE_MASK and SPTE_HOST_WRITEABLE
that can be got from spte, then we can let is_last_spte() do not depend on
the mapping level anymore

This is important to implement lockless write-protection since only spte is
available at that time

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
---
 arch/x86/kvm/mmu.c         | 25 ++++++++++++-------------
 arch/x86/kvm/mmu_audit.c   |  6 +++---
 arch/x86/kvm/paging_tmpl.h |  6 ++----
 3 files changed, 17 insertions(+), 20 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 5b42858..8b96d96 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -337,13 +337,13 @@ static int is_rmap_spte(u64 pte)
 	return is_shadow_present_pte(pte);
 }
 
-static int is_last_spte(u64 pte, int level)
+static int is_last_spte(u64 pte)
 {
-	if (level == PT_PAGE_TABLE_LEVEL)
-		return 1;
-	if (is_large_pte(pte))
-		return 1;
-	return 0;
+	/*
+	 * All the sptes on the middle level are writable but
+	 * SPTE_HOST_WRITEABLE is not set.
+	 */
+	return !(is_writable_pte(pte) && !(pte & SPTE_HOST_WRITEABLE));
 }
 
 static pfn_t spte_to_pfn(u64 pte)
@@ -2203,7 +2203,7 @@ static bool shadow_walk_okay(struct kvm_shadow_walk_iterator *iterator)
 static void __shadow_walk_next(struct kvm_shadow_walk_iterator *iterator,
 			       u64 spte)
 {
-	if (is_last_spte(spte, iterator->level)) {
+	if (is_last_spte(spte)) {
 		iterator->level = 0;
 		return;
 	}
@@ -2255,15 +2255,14 @@ static void validate_direct_spte(struct kvm_vcpu *vcpu, u64 *sptep,
 	}
 }
 
-static bool mmu_page_zap_pte(struct kvm *kvm, struct kvm_mmu_page *sp,
-			     u64 *spte)
+static bool mmu_page_zap_pte(struct kvm *kvm, u64 *spte)
 {
 	u64 pte;
 	struct kvm_mmu_page *child;
 
 	pte = *spte;
 	if (is_shadow_present_pte(pte)) {
-		if (is_last_spte(pte, sp->role.level)) {
+		if (is_last_spte(pte)) {
 			drop_spte(kvm, spte);
 			if (is_large_pte(pte))
 				--kvm->stat.lpages;
@@ -2286,7 +2285,7 @@ static void kvm_mmu_page_unlink_children(struct kvm *kvm,
 	unsigned i;
 
 	for (i = 0; i < PT64_ENT_PER_PAGE; ++i)
-		mmu_page_zap_pte(kvm, sp, sp->spt + i);
+		mmu_page_zap_pte(kvm, sp->spt + i);
 }
 
 static void kvm_mmu_put_page(struct kvm_mmu_page *sp, u64 *parent_pte)
@@ -3068,7 +3067,7 @@ static bool fast_page_fault(struct kvm_vcpu *vcpu, gva_t gva, int level,
 	}
 
 	sp = page_header(__pa(iterator.sptep));
-	if (!is_last_spte(spte, sp->role.level))
+	if (!is_last_spte(spte))
 		goto exit;
 
 	/*
@@ -4316,7 +4315,7 @@ void kvm_mmu_pte_write(struct kvm_vcpu *vcpu, gpa_t gpa,
 		local_flush = true;
 		while (npte--) {
 			entry = *spte;
-			mmu_page_zap_pte(vcpu->kvm, sp, spte);
+			mmu_page_zap_pte(vcpu->kvm, spte);
 			if (gentry &&
 			      !((sp->role.word ^ vcpu->arch.mmu.base_role.word)
 			      & mask.word) && rmap_can_add(vcpu))
diff --git a/arch/x86/kvm/mmu_audit.c b/arch/x86/kvm/mmu_audit.c
index daff69e..d54e2ad 100644
--- a/arch/x86/kvm/mmu_audit.c
+++ b/arch/x86/kvm/mmu_audit.c
@@ -45,7 +45,7 @@ static void __mmu_spte_walk(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
 		fn(vcpu, ent + i, level);
 
 		if (is_shadow_present_pte(ent[i]) &&
-		      !is_last_spte(ent[i], level)) {
+		      !is_last_spte(ent[i])) {
 			struct kvm_mmu_page *child;
 
 			child = page_header(ent[i] & PT64_BASE_ADDR_MASK);
@@ -110,7 +110,7 @@ static void audit_mappings(struct kvm_vcpu *vcpu, u64 *sptep, int level)
 		}
 	}
 
-	if (!is_shadow_present_pte(*sptep) || !is_last_spte(*sptep, level))
+	if (!is_shadow_present_pte(*sptep) || !is_last_spte(*sptep))
 		return;
 
 	gfn = kvm_mmu_page_get_gfn(sp, sptep - sp->spt);
@@ -158,7 +158,7 @@ static void inspect_spte_has_rmap(struct kvm *kvm, u64 *sptep)
 
 static void audit_sptes_have_rmaps(struct kvm_vcpu *vcpu, u64 *sptep, int level)
 {
-	if (is_shadow_present_pte(*sptep) && is_last_spte(*sptep, level))
+	if (is_shadow_present_pte(*sptep) && is_last_spte(*sptep))
 		inspect_spte_has_rmap(vcpu->kvm, sptep);
 }
 
diff --git a/arch/x86/kvm/paging_tmpl.h b/arch/x86/kvm/paging_tmpl.h
index ad75d77..33f0216 100644
--- a/arch/x86/kvm/paging_tmpl.h
+++ b/arch/x86/kvm/paging_tmpl.h
@@ -809,7 +809,6 @@ static void FNAME(invlpg)(struct kvm_vcpu *vcpu, gva_t gva)
 {
 	struct kvm_shadow_walk_iterator iterator;
 	struct kvm_mmu_page *sp;
-	int level;
 	u64 *sptep;
 
 	vcpu_clear_mmio_info(vcpu, gva);
@@ -822,11 +821,10 @@ static void FNAME(invlpg)(struct kvm_vcpu *vcpu, gva_t gva)
 
 	spin_lock(&vcpu->kvm->mmu_lock);
 	for_each_shadow_entry(vcpu, gva, iterator) {
-		level = iterator.level;
 		sptep = iterator.sptep;
 
 		sp = page_header(__pa(sptep));
-		if (is_last_spte(*sptep, level)) {
+		if (is_last_spte(*sptep)) {
 			pt_element_t gpte;
 			gpa_t pte_gpa;
 
@@ -836,7 +834,7 @@ static void FNAME(invlpg)(struct kvm_vcpu *vcpu, gva_t gva)
 			pte_gpa = FNAME(get_level1_sp_gpa)(sp);
 			pte_gpa += (sptep - sp->spt) * sizeof(pt_element_t);
 
-			if (mmu_page_zap_pte(vcpu->kvm, sp, sptep))
+			if (mmu_page_zap_pte(vcpu->kvm, sptep))
 				kvm_flush_remote_tlbs(vcpu->kvm);
 
 			if (!rmap_can_add(vcpu))
-- 
1.8.1.4

