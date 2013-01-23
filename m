Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754745Ab3AWKGN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 05:06:13 -0500
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:55573 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754488Ab3AWKGK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 05:06:10 -0500
Message-ID: <50FFB609.9000205@linux.vnet.ibm.com>
Date: Wed, 23 Jan 2013 18:06:01 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, Avi Kivity <avi.kivity@gmail.com>,
        Gleb Natapov <gleb@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: [PATCH v2 04/12] KVM: MMU: simplify set_spte
References: <50FFB5A1.5090708@linux.vnet.ibm.com>
In-Reply-To: <50FFB5A1.5090708@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13012309-9264-0000-0000-0000030CCA2C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For the logic, the function can be divided into two parts: one is adjusting
pte_access, the rest one is setting spte according the pte_access. It makes
the code more readable

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
---
 arch/x86/kvm/mmu.c |   51 ++++++++++++++++++++++++++-------------------------
 1 files changed, 26 insertions(+), 25 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index a999755..af8bcb2 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -2336,32 +2336,13 @@ static int set_spte(struct kvm_vcpu *vcpu, u64 *sptep,
 		return 0;

 	spte = PT_PRESENT_MASK;
-	if (!speculative)
-		spte |= shadow_accessed_mask;
-
-	if (pte_access & ACC_EXEC_MASK)
-		spte |= shadow_x_mask;
-	else
-		spte |= shadow_nx_mask;
-
-	if (pte_access & ACC_USER_MASK)
-		spte |= shadow_user_mask;
-
-	if (level > PT_PAGE_TABLE_LEVEL)
-		spte |= PT_PAGE_SIZE_MASK;
-	if (tdp_enabled)
-		spte |= kvm_x86_ops->get_mt_mask(vcpu, gfn,
-			kvm_is_mmio_pfn(pfn));

 	if (host_writable)
 		spte |= SPTE_HOST_WRITEABLE;
 	else
 		pte_access &= ~ACC_WRITE_MASK;

-	spte |= (u64)pfn << PAGE_SHIFT;
-
 	if (pte_access & ACC_WRITE_MASK) {
-
 		/*
 		 * Other vcpu creates new sp in the window between
 		 * mapping_level() and acquiring mmu-lock. We can
@@ -2369,11 +2350,9 @@ static int set_spte(struct kvm_vcpu *vcpu, u64 *sptep,
 		 * be fixed if guest refault.
 		 */
 		if (level > PT_PAGE_TABLE_LEVEL &&
-		    has_wrprotected_page(vcpu->kvm, gfn, level))
+		      has_wrprotected_page(vcpu->kvm, gfn, level))
 			goto done;

-		spte |= PT_WRITABLE_MASK | SPTE_MMU_WRITEABLE;
-
 		/*
 		 * Optimization: for pte sync, if spte was writable the hash
 		 * lookup is unnecessary (and expensive). Write protection
@@ -2381,21 +2360,43 @@ static int set_spte(struct kvm_vcpu *vcpu, u64 *sptep,
 		 * Same reasoning can be applied to dirty page accounting.
 		 */
 		if (!can_unsync && is_writable_pte(*sptep))
-			goto set_pte;
+			goto out_access_adjust;

 		if (mmu_need_write_protect(vcpu, gfn, can_unsync)) {
 			pgprintk("%s: found shadow page for %llx, marking ro\n",
 				 __func__, gfn);
 			ret = 1;
 			pte_access &= ~ACC_WRITE_MASK;
-			spte &= ~(PT_WRITABLE_MASK | SPTE_MMU_WRITEABLE);
 		}
 	}

+out_access_adjust:
+	if (!speculative)
+		spte |= shadow_accessed_mask;
+
+	if (pte_access & ACC_EXEC_MASK)
+		spte |= shadow_x_mask;
+	else
+		spte |= shadow_nx_mask;
+
+	if (pte_access & ACC_USER_MASK)
+		spte |= shadow_user_mask;
+
 	if (pte_access & ACC_WRITE_MASK)
+		spte |= PT_WRITABLE_MASK | SPTE_MMU_WRITEABLE;
+
+	if (level > PT_PAGE_TABLE_LEVEL)
+		spte |= PT_PAGE_SIZE_MASK;
+
+	if (tdp_enabled)
+		spte |= kvm_x86_ops->get_mt_mask(vcpu, gfn,
+			kvm_is_mmio_pfn(pfn));
+
+	spte |= (u64)pfn << PAGE_SHIFT;
+
+	if (is_writable_pte(spte))
 		mark_page_dirty(vcpu->kvm, gfn);

-set_pte:
 	if (mmu_spte_update(sptep, spte))
 		kvm_flush_remote_tlbs(vcpu->kvm);
 done:
-- 
1.7.7.6

