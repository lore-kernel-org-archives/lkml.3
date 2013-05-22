Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757217Ab3EVT4a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 15:56:30 -0400
Received: from e28smtp05.in.ibm.com ([122.248.162.5]:60344 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757190Ab3EVT41 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 15:56:27 -0400
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
To: gleb@redhat.com
Cc: avi.kivity@gmail.com, mtosatti@redhat.com, pbonzini@redhat.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Subject: [PATCH v7 10/11] KVM: MMU: collapse TLB flushes when zap all pages
Date: Thu, 23 May 2013 03:55:59 +0800
Message-Id: <1369252560-11611-11-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1369252560-11611-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
References: <1369252560-11611-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13052219-8256-0000-0000-0000079BF892
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kvm_zap_obsolete_pages uses lock-break technique to zap pages,
it will flush tlb every time when it does lock-break

We can reload mmu on all vcpus after updating the generation
number so that the obsolete pages are not used on any vcpus,
after that we do not need to flush tlb when obsolete pages
are zapped

Note: kvm_mmu_commit_zap_page is still needed before free
the pages since other vcpus may be doing locklessly shadow
page walking

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
---
 arch/x86/kvm/mmu.c |   32 ++++++++++++++++++++++----------
 1 files changed, 22 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index e676356..5e34056 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -4237,8 +4237,6 @@ static void kvm_zap_obsolete_pages(struct kvm *kvm)
 restart:
 	list_for_each_entry_safe_reverse(sp, node,
 	      &kvm->arch.active_mmu_pages, link) {
-		int ret;
-
 		/*
 		 * No obsolete page exists before new created page since
 		 * active_mmu_pages is the FIFO list.
@@ -4254,21 +4252,24 @@ restart:
 		if (sp->role.invalid)
 			continue;
 
+		/*
+		 * Need not flush tlb since we only zap the sp with invalid
+		 * generation number.
+		 */
 		if (batch >= BATCH_ZAP_PAGES &&
-		      (need_resched() || spin_needbreak(&kvm->mmu_lock))) {
+		      cond_resched_lock(&kvm->mmu_lock)) {
 			batch = 0;
-			kvm_mmu_commit_zap_page(kvm, &invalid_list);
-			cond_resched_lock(&kvm->mmu_lock);
 			goto restart;
 		}
 
-		ret = kvm_mmu_prepare_zap_page(kvm, sp, &invalid_list);
-		batch += ret;
-
-		if (ret)
-			goto restart;
+		batch += kvm_mmu_prepare_zap_obsolete_page(kvm, sp,
+						      &invalid_list);
 	}
 
+	/*
+	 * Should flush tlb before free page tables since lockless-walking
+	 * may use the pages.
+	 */
 	kvm_mmu_commit_zap_page(kvm, &invalid_list);
 }
 
@@ -4287,6 +4288,17 @@ void kvm_mmu_invalidate_zap_all_pages(struct kvm *kvm)
 	trace_kvm_mmu_invalidate_zap_all_pages(kvm);
 	kvm->arch.mmu_valid_gen++;
 
+	/*
+	 * Notify all vcpus to reload its shadow page table
+	 * and flush TLB. Then all vcpus will switch to new
+	 * shadow page table with the new mmu_valid_gen.
+	 *
+	 * Note: we should do this under the protection of
+	 * mmu-lock, otherwise, vcpu would purge shadow page
+	 * but miss tlb flush.
+	 */
+	kvm_reload_remote_mmus(kvm);
+
 	kvm_zap_obsolete_pages(kvm);
 	spin_unlock(&kvm->mmu_lock);
 }
-- 
1.7.7.6

