Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754282Ab3G3NDc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 09:03:32 -0400
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:51180 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752978Ab3G3NDa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 09:03:30 -0400
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
To: gleb@redhat.com
Cc: avi.kivity@gmail.com, mtosatti@redhat.com, pbonzini@redhat.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Subject: [PATCH 05/12] KVM: MMU: add spte into rmap before logging dirty page
Date: Tue, 30 Jul 2013 21:02:03 +0800
Message-Id: <1375189330-24066-6-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1375189330-24066-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
References: <1375189330-24066-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13073012-9264-0000-0000-0000043AF5B2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kvm_vm_ioctl_get_dirty_log() write-protects the spte based on the dirty
bitmap, we should ensure the writable spte can be found in rmap before the
dirty bitmap is visible. Otherwise, we cleared the dirty bitmap and failed
to write-protect the page

It need the memory barrier to prevent out-of-order that will be added in the
later patch

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
---
 arch/x86/kvm/mmu.c | 25 ++++++++++---------------
 1 file changed, 10 insertions(+), 15 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 0fe56ad..58283bf 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -2425,6 +2425,7 @@ static int set_spte(struct kvm_vcpu *vcpu, u64 *sptep,
 {
 	u64 spte;
 	int ret = 0;
+	bool remap = is_rmap_spte(*sptep);
 
 	if (set_mmio_spte(vcpu->kvm, sptep, gfn, pfn, pte_access))
 		return 0;
@@ -2490,6 +2491,14 @@ set_pte:
 	if (mmu_spte_update(sptep, spte))
 		kvm_flush_remote_tlbs(vcpu->kvm);
 
+	if (!remap) {
+		if (rmap_add(vcpu, sptep, gfn) > RMAP_RECYCLE_THRESHOLD)
+			rmap_recycle(vcpu, sptep, gfn);
+
+		if (level > PT_PAGE_TABLE_LEVEL)
+			++vcpu->kvm->stat.lpages;
+	}
+
 	if (pte_access & ACC_WRITE_MASK)
 		mark_page_dirty(vcpu->kvm, gfn);
 done:
@@ -2501,9 +2510,6 @@ static void mmu_set_spte(struct kvm_vcpu *vcpu, u64 *sptep,
 			 int level, gfn_t gfn, pfn_t pfn, bool speculative,
 			 bool host_writable)
 {
-	int was_rmapped = 0;
-	int rmap_count;
-
 	pgprintk("%s: spte %llx write_fault %d gfn %llx\n", __func__,
 		 *sptep, write_fault, gfn);
 
@@ -2525,8 +2531,7 @@ static void mmu_set_spte(struct kvm_vcpu *vcpu, u64 *sptep,
 				 spte_to_pfn(*sptep), pfn);
 			drop_spte(vcpu->kvm, sptep);
 			kvm_flush_remote_tlbs(vcpu->kvm);
-		} else
-			was_rmapped = 1;
+		}
 	}
 
 	if (set_spte(vcpu, sptep, pte_access, level, gfn, pfn, speculative,
@@ -2544,16 +2549,6 @@ static void mmu_set_spte(struct kvm_vcpu *vcpu, u64 *sptep,
 		 is_large_pte(*sptep)? "2MB" : "4kB",
 		 *sptep & PT_PRESENT_MASK ?"RW":"R", gfn,
 		 *sptep, sptep);
-	if (!was_rmapped && is_large_pte(*sptep))
-		++vcpu->kvm->stat.lpages;
-
-	if (is_shadow_present_pte(*sptep)) {
-		if (!was_rmapped) {
-			rmap_count = rmap_add(vcpu, sptep, gfn);
-			if (rmap_count > RMAP_RECYCLE_THRESHOLD)
-				rmap_recycle(vcpu, sptep, gfn);
-		}
-	}
 
 	kvm_release_pfn_clean(pfn);
 }
-- 
1.8.1.4

