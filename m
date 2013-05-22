Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757154Ab3EVT4U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 15:56:20 -0400
Received: from e28smtp09.in.ibm.com ([122.248.162.9]:40011 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757105Ab3EVT4R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 15:56:17 -0400
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
To: gleb@redhat.com
Cc: avi.kivity@gmail.com, mtosatti@redhat.com, pbonzini@redhat.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Subject: [PATCH v7 04/11] KVM: MMU: zap pages in batch
Date: Thu, 23 May 2013 03:55:53 +0800
Message-Id: <1369252560-11611-5-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1369252560-11611-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
References: <1369252560-11611-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13052219-2674-0000-0000-0000091330B5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Zap at lease 10 pages before releasing mmu-lock to reduce the overload
caused by requiring lock

After the patch, kvm_zap_obsolete_pages can forward progress anyway,
so update the comments

[ It improves kernel building 0.6% ~ 1% ]

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
---
 arch/x86/kvm/mmu.c |   35 +++++++++++------------------------
 1 files changed, 11 insertions(+), 24 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index f302540..688e755 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -4203,14 +4203,18 @@ restart:
 	spin_unlock(&kvm->mmu_lock);
 }
 
+#define BATCH_ZAP_PAGES	10
 static void kvm_zap_obsolete_pages(struct kvm *kvm)
 {
 	struct kvm_mmu_page *sp, *node;
 	LIST_HEAD(invalid_list);
+	int batch = 0;
 
 restart:
 	list_for_each_entry_safe_reverse(sp, node,
 	      &kvm->arch.active_mmu_pages, link) {
+		int ret;
+
 		/*
 		 * No obsolete page exists before new created page since
 		 * active_mmu_pages is the FIFO list.
@@ -4219,28 +4223,6 @@ restart:
 			break;
 
 		/*
-		 * Do not repeatedly zap a root page to avoid unnecessary
-		 * KVM_REQ_MMU_RELOAD, otherwise we may not be able to
-		 * progress:
-		 *    vcpu 0                        vcpu 1
-		 *                         call vcpu_enter_guest():
-		 *                            1): handle KVM_REQ_MMU_RELOAD
-		 *                                and require mmu-lock to
-		 *                                load mmu
-		 * repeat:
-		 *    1): zap root page and
-		 *        send KVM_REQ_MMU_RELOAD
-		 *
-		 *    2): if (cond_resched_lock(mmu-lock))
-		 *
-		 *                            2): hold mmu-lock and load mmu
-		 *
-		 *                            3): see KVM_REQ_MMU_RELOAD bit
-		 *                                on vcpu->requests is set
-		 *                                then return 1 to call
-		 *                                vcpu_enter_guest() again.
-		 *            goto repeat;
-		 *
 		 * Since we are reversely walking the list and the invalid
 		 * list will be moved to the head, skip the invalid page
 		 * can help us to avoid the infinity list walking.
@@ -4248,13 +4230,18 @@ restart:
 		if (sp->role.invalid)
 			continue;
 
-		if (need_resched() || spin_needbreak(&kvm->mmu_lock)) {
+		if (batch >= BATCH_ZAP_PAGES &&
+		      (need_resched() || spin_needbreak(&kvm->mmu_lock))) {
+			batch = 0;
 			kvm_mmu_commit_zap_page(kvm, &invalid_list);
 			cond_resched_lock(&kvm->mmu_lock);
 			goto restart;
 		}
 
-		if (kvm_mmu_prepare_zap_page(kvm, sp, &invalid_list))
+		ret = kvm_mmu_prepare_zap_page(kvm, sp, &invalid_list);
+		batch += ret;
+
+		if (ret)
 			goto restart;
 	}
 
-- 
1.7.7.6

