Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755687Ab3G3NIN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 09:08:13 -0400
Received: from e28smtp03.in.ibm.com ([122.248.162.3]:44024 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755523Ab3G3NH4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 09:07:56 -0400
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
To: gleb@redhat.com
Cc: avi.kivity@gmail.com, mtosatti@redhat.com, pbonzini@redhat.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Subject: [PATCH 12/12] KVM: MMU: clean up spte_write_protect
Date: Tue, 30 Jul 2013 21:02:10 +0800
Message-Id: <1375189330-24066-13-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1375189330-24066-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
References: <1375189330-24066-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13073013-3864-0000-0000-000009534724
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
index a50eea8..8073c1f 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -1319,8 +1319,7 @@ static void drop_large_spte(struct kvm_vcpu *vcpu, u64 *sptep)
 }
 
 /*
- * Write-protect on the specified @sptep, @pt_protect indicates whether
- * spte write-protection is caused by protecting shadow page table.
+ * Write-protect on the specified @sptep.
  *
  * Note: write protection is difference between drity logging and spte
  * protection:
@@ -1331,25 +1330,23 @@ static void drop_large_spte(struct kvm_vcpu *vcpu, u64 *sptep)
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
@@ -1358,7 +1355,7 @@ static bool __rmap_write_protect(struct kvm *kvm, unsigned long *rmapp,
 	for (sptep = rmap_get_first(*rmapp, &iter); sptep;) {
 		BUG_ON(!(*sptep & PT_PRESENT_MASK));
 
-		flush |= spte_write_protect(kvm, sptep, pt_protect);
+		flush |= spte_write_protect(sptep);
 		sptep = rmap_get_next(&iter);
 	}
 
@@ -1426,7 +1423,7 @@ static bool rmap_write_protect(struct kvm *kvm, u64 gfn)
 	for (i = PT_PAGE_TABLE_LEVEL;
 	     i < PT_PAGE_TABLE_LEVEL + KVM_NR_PAGE_SIZES; ++i) {
 		rmapp = __gfn_to_rmap(gfn, i, slot);
-		write_protected |= __rmap_write_protect(kvm, rmapp, true);
+		write_protected |= __rmap_write_protect(rmapp);
 	}
 
 	return write_protected;
-- 
1.8.1.4

