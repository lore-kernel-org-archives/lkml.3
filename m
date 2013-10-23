Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754236Ab3JWNbN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Oct 2013 09:31:13 -0400
Received: from e28smtp08.in.ibm.com ([122.248.162.8]:41643 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754022Ab3JWNaI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Oct 2013 09:30:08 -0400
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
To: gleb@redhat.com
Cc: avi.kivity@gmail.com, mtosatti@redhat.com, pbonzini@redhat.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Subject: [PATCH v3 14/15] KVM: MMU: clean up spte_write_protect
Date: Wed, 23 Oct 2013 21:29:32 +0800
Message-Id: <1382534973-13197-15-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1382534973-13197-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
References: <1382534973-13197-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13102313-2000-0000-0000-00000E40C7BF
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now, the only user of spte_write_protect is rmap_write_protect which
always calls spte_write_protect with pt_protect = true, so drop
it and the unused parameter @kvm

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
---
 arch/x86/kvm/mmu.c | 19 ++++++++-----------
 1 file changed, 8 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index d82bbec..3e4b941 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -1340,8 +1340,7 @@ static void drop_large_spte(struct kvm_vcpu *vcpu, u64 *sptep)
 }
 
 /*
- * Write-protect on the specified @sptep, @pt_protect indicates whether
- * spte write-protection is caused by protecting shadow page table.
+ * Write-protect on the specified @sptep.
  *
  * Note: write protection is difference between drity logging and spte
  * protection:
@@ -1352,25 +1351,23 @@ static void drop_large_spte(struct kvm_vcpu *vcpu, u64 *sptep)
  *
  * Return true if tlb need be flushed.
  */
-static bool spte_write_protect(struct kvm *kvm, u64 *sptep, bool pt_protect)
+static bool spte_write_protect(u64 *sptep)
 {
 	u64 spte = *sptep;
 
 	if (!is_writable_pte(spte) &&
-	      !(pt_protect && spte_is_locklessly_modifiable(spte)))
+	      !spte_is_locklessly_modifiable(spte))
 		return false;
 
 	rmap_printk("rmap_write_protect: spte %p %llx\n", sptep, *sptep);
 
-	if (pt_protect)
-		spte &= ~SPTE_MMU_WRITEABLE;
-	spte = spte & ~PT_WRITABLE_MASK;
+	spte &= ~SPTE_MMU_WRITEABLE;
+	spte &= ~PT_WRITABLE_MASK;
 
 	return mmu_spte_update(sptep, spte);
 }
 
-static bool __rmap_write_protect(struct kvm *kvm, unsigned long *rmapp,
-				 bool pt_protect)
+static bool __rmap_write_protect(unsigned long *rmapp)
 {
 	u64 *sptep;
 	struct rmap_iterator iter;
@@ -1379,7 +1376,7 @@ static bool __rmap_write_protect(struct kvm *kvm, unsigned long *rmapp,
 	for (sptep = rmap_get_first(*rmapp, &iter); sptep;) {
 		BUG_ON(!(*sptep & PT_PRESENT_MASK));
 
-		flush |= spte_write_protect(kvm, sptep, pt_protect);
+		flush |= spte_write_protect(sptep);
 		sptep = rmap_get_next(&iter);
 	}
 
@@ -1454,7 +1451,7 @@ static bool rmap_write_protect(struct kvm *kvm, u64 gfn)
 	for (i = PT_PAGE_TABLE_LEVEL;
 	     i < PT_PAGE_TABLE_LEVEL + KVM_NR_PAGE_SIZES; ++i) {
 		rmapp = __gfn_to_rmap(gfn, i, slot);
-		write_protected |= __rmap_write_protect(kvm, rmapp, true);
+		write_protected |= __rmap_write_protect(rmapp);
 	}
 
 	return write_protected;
-- 
1.8.1.4

