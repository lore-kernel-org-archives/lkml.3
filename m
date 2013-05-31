Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752867Ab3EaAiW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 20:38:22 -0400
Received: from e28smtp07.in.ibm.com ([122.248.162.7]:46769 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752056Ab3EaAgz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 20:36:55 -0400
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
To: gleb@redhat.com
Cc: avi.kivity@gmail.com, mtosatti@redhat.com, pbonzini@redhat.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Subject: [PATCH v8 09/11] KVM: MMU: collapse TLB flushes when zap all pages
Date: Fri, 31 May 2013 08:36:28 +0800
Message-Id: <1369960590-14138-10-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1369960590-14138-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
References: <1369960590-14138-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13053100-8878-0000-0000-000007540857
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kvm_zap_obsolete_pages uses lock-break technique to zap pages,
it will flush tlb every time when it does lock-break

We can reload mmu on all vcpus after updating the generation
number so that the obsolete pages are not used on any vcpus,
after that we do not need to flush tlb when obsolete pages
are zapped

It will do kvm_mmu_prepare_zap_page many times and use one
kvm_mmu_commit_zap_page to collapse tlb flush, the side-effects
is that causes obsolete pages unlinked from active_list but leave
on hash-list, so we add the comment around the hash list walker

Note: kvm_mmu_commit_zap_page is still needed before free
the pages since other vcpus may be doing locklessly shadow
page walking

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
---
 arch/x86/kvm/mmu.c |   33 ++++++++++++++++++++++++++++++---
 1 files changed, 30 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index fe9d6f1..674c044 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -1654,6 +1654,16 @@ static int kvm_mmu_prepare_zap_page(struct kvm *kvm, struct kvm_mmu_page *sp,
 static void kvm_mmu_commit_zap_page(struct kvm *kvm,
 				    struct list_head *invalid_list);
 
+/*
+ * NOTE: we should pay more attention on the zapped-obsolete page
+ * (is_obsolete_sp(sp) && sp->role.invalid) when you do hash list walk
+ * since it has been deleted from active_mmu_pages but still can be found
+ * at hast list.
+ *
+ * for_each_gfn_indirect_valid_sp has skipped that kind of page and
+ * kvm_mmu_get_page(), the only user of for_each_gfn_sp(), has skipped
+ * all the obsolete pages.
+ */
 #define for_each_gfn_sp(_kvm, _sp, _gfn)				\
 	hlist_for_each_entry(_sp,					\
 	  &(_kvm)->arch.mmu_page_hash[kvm_page_table_hashfn(_gfn)], hash_link) \
@@ -4224,11 +4234,13 @@ restart:
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
 
@@ -4239,6 +4251,10 @@ restart:
 			goto restart;
 	}
 
+	/*
+	 * Should flush tlb before free page tables since lockless-walking
+	 * may use the pages.
+	 */
 	kvm_mmu_commit_zap_page(kvm, &invalid_list);
 }
 
@@ -4257,6 +4273,17 @@ void kvm_mmu_invalidate_zap_all_pages(struct kvm *kvm)
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

