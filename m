Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754852Ab3AWKIF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 05:08:05 -0500
Received: from e23smtp03.au.ibm.com ([202.81.31.145]:48493 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754502Ab3AWKIC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 05:08:02 -0500
Message-ID: <50FFB678.5050309@linux.vnet.ibm.com>
Date: Wed, 23 Jan 2013 18:07:52 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, Avi Kivity <avi.kivity@gmail.com>,
        Gleb Natapov <gleb@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: [PATCH v2 07/12] KVM: MMU: remove pt_access in mmu_set_spte
References: <50FFB5A1.5090708@linux.vnet.ibm.com>
In-Reply-To: <50FFB5A1.5090708@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13012310-6102-0000-0000-000002E7D1FC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is only used in debug code, so drop it

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
---
 arch/x86/kvm/mmu.c         |   15 ++++++---------
 arch/x86/kvm/paging_tmpl.h |    9 ++++-----
 2 files changed, 10 insertions(+), 14 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index a8a9c0e..c0bb7cf 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -2436,15 +2436,14 @@ static int set_spte(struct kvm_vcpu *vcpu, u64 *sptep,
 }

 static void mmu_set_spte(struct kvm_vcpu *vcpu, u64 *sptep,
-			 unsigned pt_access, unsigned pte_access,
-			 int write_fault, int *emulate, int level, gfn_t gfn,
-			 pfn_t pfn, bool speculative, bool host_writable)
+			 unsigned pte_access, int write_fault, int *emulate,
+			 int level, gfn_t gfn, pfn_t pfn, bool speculative,
+			 bool host_writable)
 {
 	bool was_rmapped = false;

 	pgprintk("%s: spte %llx access %x write_fault %d gfn %llx\n",
-		 __func__, *sptep, pt_access,
-		 write_fault, gfn);
+		 __func__, *sptep, write_fault, gfn);

 	if (is_rmap_spte(*sptep)) {
 		if (pfn != spte_to_pfn(*sptep)) {
@@ -2547,7 +2546,7 @@ static int direct_pte_prefetch_many(struct kvm_vcpu *vcpu,
 		return -1;

 	for (i = 0; i < ret; i++, gfn++, start++)
-		mmu_set_spte(vcpu, start, ACC_ALL, access, 0, NULL,
+		mmu_set_spte(vcpu, start, access, 0, NULL,
 			     sp->role.level, gfn, page_to_pfn(pages[i]),
 			     true, true);

@@ -2608,9 +2607,7 @@ static int __direct_map(struct kvm_vcpu *vcpu, gpa_t v, int write,

 	for_each_shadow_entry(vcpu, (u64)gfn << PAGE_SHIFT, iterator) {
 		if (iterator.level == level) {
-			unsigned pte_access = ACC_ALL;
-
-			mmu_set_spte(vcpu, iterator.sptep, ACC_ALL, pte_access,
+			mmu_set_spte(vcpu, iterator.sptep, ACC_ALL,
 				     write, &emulate, level, gfn, pfn,
 				     prefault, map_writable);
 			direct_pte_prefetch(vcpu, iterator.sptep);
diff --git a/arch/x86/kvm/paging_tmpl.h b/arch/x86/kvm/paging_tmpl.h
index ca69dcc..b9a0df6 100644
--- a/arch/x86/kvm/paging_tmpl.h
+++ b/arch/x86/kvm/paging_tmpl.h
@@ -326,8 +326,8 @@ FNAME(prefetch_gpte)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
 	 * we call mmu_set_spte() with host_writable = true because
 	 * pte_prefetch_gfn_to_pfn always gets a writable pfn.
 	 */
-	mmu_set_spte(vcpu, spte, sp->role.access, pte_access, 0,
-		     NULL, PT_PAGE_TABLE_LEVEL, gfn, pfn, true, true);
+	mmu_set_spte(vcpu, spte, pte_access, 0, NULL, PT_PAGE_TABLE_LEVEL,
+		     gfn, pfn, true, true);

 	return true;
 }
@@ -473,9 +473,8 @@ static int FNAME(fetch)(struct kvm_vcpu *vcpu, gva_t addr,
 	}

 	clear_sp_write_flooding_count(it.sptep);
-	mmu_set_spte(vcpu, it.sptep, access, gw->pte_access,
-		     write_fault, &emulate, it.level,
-		     gw->gfn, pfn, prefault, map_writable);
+	mmu_set_spte(vcpu, it.sptep, gw->pte_access, write_fault, &emulate,
+		     it.level, gw->gfn, pfn, prefault, map_writable);
 	FNAME(pte_prefetch)(vcpu, gw, it.sptep);

 	return emulate;
-- 
1.7.7.6

