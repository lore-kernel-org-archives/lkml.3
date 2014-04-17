Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755316AbaDQJFt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 05:05:49 -0400
Received: from e28smtp09.in.ibm.com ([122.248.162.9]:48095 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754659AbaDQJFp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 05:05:45 -0400
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
To: gleb@kernel.org
Cc: avi.kivity@gmail.com, mtosatti@redhat.com, pbonzini@redhat.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Subject: [PATCH v5 1/5] Revert "KVM: Simplify kvm->tlbs_dirty handling"
Date: Thu, 17 Apr 2014 17:06:12 +0800
Message-Id: <1397725576-6617-2-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1397725576-6617-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
References: <1397725576-6617-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14041709-2674-0000-0000-00000DD4E471
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This reverts commit 5befdc385ddb2d5ae8995ad89004529a3acf58fc.

Since we will allow flush tlb out of mmu-lock in the later
patch

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
---
 arch/x86/kvm/paging_tmpl.h | 7 +++----
 include/linux/kvm_host.h   | 4 +---
 virt/kvm/kvm_main.c        | 5 ++++-
 3 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/paging_tmpl.h b/arch/x86/kvm/paging_tmpl.h
index 123efd3..4107765 100644
--- a/arch/x86/kvm/paging_tmpl.h
+++ b/arch/x86/kvm/paging_tmpl.h
@@ -913,8 +913,7 @@ static gpa_t FNAME(gva_to_gpa_nested)(struct kvm_vcpu *vcpu, gva_t vaddr,
  *   and kvm_mmu_notifier_invalidate_range_start detect the mapping page isn't
  *   used by guest then tlbs are not flushed, so guest is allowed to access the
  *   freed pages.
- *   We set tlbs_dirty to let the notifier know this change and delay the flush
- *   until such a case actually happens.
+ *   And we increase kvm->tlbs_dirty to delay tlbs flush in this case.
  */
 static int FNAME(sync_page)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp)
 {
@@ -943,7 +942,7 @@ static int FNAME(sync_page)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp)
 			return -EINVAL;
 
 		if (FNAME(prefetch_invalid_gpte)(vcpu, sp, &sp->spt[i], gpte)) {
-			vcpu->kvm->tlbs_dirty = true;
+			vcpu->kvm->tlbs_dirty++;
 			continue;
 		}
 
@@ -958,7 +957,7 @@ static int FNAME(sync_page)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp)
 
 		if (gfn != sp->gfns[i]) {
 			drop_spte(vcpu->kvm, &sp->spt[i]);
-			vcpu->kvm->tlbs_dirty = true;
+			vcpu->kvm->tlbs_dirty++;
 			continue;
 		}
 
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 7d21cf9..33cccd5 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -410,9 +410,7 @@ struct kvm {
 	unsigned long mmu_notifier_seq;
 	long mmu_notifier_count;
 #endif
-	/* Protected by mmu_lock */
-	bool tlbs_dirty;
-
+	long tlbs_dirty;
 	struct list_head devices;
 };
 
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 56baae8..628275a 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -186,9 +186,12 @@ static bool make_all_cpus_request(struct kvm *kvm, unsigned int req)
 
 void kvm_flush_remote_tlbs(struct kvm *kvm)
 {
+	long dirty_count = kvm->tlbs_dirty;
+
+	smp_mb();
 	if (make_all_cpus_request(kvm, KVM_REQ_TLB_FLUSH))
 		++kvm->stat.remote_tlb_flush;
-	kvm->tlbs_dirty = false;
+	cmpxchg(&kvm->tlbs_dirty, dirty_count, 0);
 }
 EXPORT_SYMBOL_GPL(kvm_flush_remote_tlbs);
 
-- 
1.8.1.4

