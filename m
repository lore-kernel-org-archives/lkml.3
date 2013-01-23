Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754781Ab3AWKFi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 05:05:38 -0500
Received: from e23smtp05.au.ibm.com ([202.81.31.147]:40800 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754386Ab3AWKFg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 05:05:36 -0500
Message-ID: <50FFB5E9.2010500@linux.vnet.ibm.com>
Date: Wed, 23 Jan 2013 18:05:29 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, Avi Kivity <avi.kivity@gmail.com>,
        Gleb Natapov <gleb@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: [PATCH v2 03/12] KVM: MMU: simplify mmu_set_spte
References: <50FFB5A1.5090708@linux.vnet.ibm.com>
In-Reply-To: <50FFB5A1.5090708@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13012310-1396-0000-0000-00000274583A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In order to detecting spte remapping, we can simply check whether the
spte has already been pointing to the pfn even if the spte is not the
last spte, for middle spte is pointing to the kernel pfn which can not
be mapped to userspace

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
---
 arch/x86/kvm/mmu.c |   28 +++++++---------------------
 1 files changed, 7 insertions(+), 21 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 8dca8af..a999755 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -2407,33 +2407,20 @@ static void mmu_set_spte(struct kvm_vcpu *vcpu, u64 *sptep,
 			 int write_fault, int *emulate, int level, gfn_t gfn,
 			 pfn_t pfn, bool speculative, bool host_writable)
 {
-	int was_rmapped = 0;
-	int rmap_count;
+	bool was_rmapped = false;

 	pgprintk("%s: spte %llx access %x write_fault %d gfn %llx\n",
 		 __func__, *sptep, pt_access,
 		 write_fault, gfn);

 	if (is_rmap_spte(*sptep)) {
-		/*
-		 * If we overwrite a PTE page pointer with a 2MB PMD, unlink
-		 * the parent of the now unreachable PTE.
-		 */
-		if (level > PT_PAGE_TABLE_LEVEL &&
-		    !is_large_pte(*sptep)) {
-			struct kvm_mmu_page *child;
-			u64 pte = *sptep;
+		if (pfn != spte_to_pfn(*sptep)) {
+			struct kvm_mmu_page *sp = page_header(__pa(sptep));

-			child = page_header(pte & PT64_BASE_ADDR_MASK);
-			drop_parent_pte(child, sptep);
-			kvm_flush_remote_tlbs(vcpu->kvm);
-		} else if (pfn != spte_to_pfn(*sptep)) {
-			pgprintk("hfn old %llx new %llx\n",
-				 spte_to_pfn(*sptep), pfn);
-			drop_spte(vcpu->kvm, sptep);
-			kvm_flush_remote_tlbs(vcpu->kvm);
+			if (mmu_page_zap_pte(vcpu->kvm, sp, sptep))
+				kvm_flush_remote_tlbs(vcpu->kvm);
 		} else
-			was_rmapped = 1;
+			was_rmapped = true;
 	}

 	if (set_spte(vcpu, sptep, pte_access, level, gfn, pfn, speculative,
@@ -2456,8 +2443,7 @@ static void mmu_set_spte(struct kvm_vcpu *vcpu, u64 *sptep,

 	if (is_shadow_present_pte(*sptep)) {
 		if (!was_rmapped) {
-			rmap_count = rmap_add(vcpu, sptep, gfn);
-			if (rmap_count > RMAP_RECYCLE_THRESHOLD)
+			if (rmap_add(vcpu, sptep, gfn) > RMAP_RECYCLE_THRESHOLD)
 				rmap_recycle(vcpu, sptep, gfn);
 		}
 	}
-- 
1.7.7.6

