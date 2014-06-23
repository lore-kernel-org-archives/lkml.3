Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754938AbaFWNLU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 09:11:20 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:37189 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754813AbaFWNFN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 09:05:13 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Oleg Nesterov <oleg@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 78/93] KVM: async_pf: mm->mm_users can not pin apf->mm
Date: Mon, 23 Jun 2014 14:02:57 +0100
Message-Id: <1403528592-2163-79-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1403528592-2163-1-git-send-email-luis.henriques@canonical.com>
References: <1403528592-2163-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.12 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oleg Nesterov <oleg@redhat.com>

commit 41c22f626254b9dc0376928cae009e73d1b6a49a upstream.

get_user_pages(mm) is simply wrong if mm->mm_users == 0 and exit_mmap/etc
was already called (or is in progress), mm->mm_count can only pin mm->pgd
and mm_struct itself.

Change kvm_setup_async_pf/async_pf_execute to inc/dec mm->mm_users.

kvm_create_vm/kvm_destroy_vm play with ->mm_count too but this case looks
fine at first glance, it seems that this ->mm is only used to verify that
current->mm == kvm->mm.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 virt/kvm/async_pf.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/virt/kvm/async_pf.c b/virt/kvm/async_pf.c
index b197950ac4d5..595226d5ccb5 100644
--- a/virt/kvm/async_pf.c
+++ b/virt/kvm/async_pf.c
@@ -87,7 +87,7 @@ static void async_pf_execute(struct work_struct *work)
 	if (waitqueue_active(&vcpu->wq))
 		wake_up_interruptible(&vcpu->wq);
 
-	mmdrop(mm);
+	mmput(mm);
 	kvm_put_kvm(vcpu->kvm);
 }
 
@@ -100,7 +100,7 @@ void kvm_clear_async_pf_completion_queue(struct kvm_vcpu *vcpu)
 				   typeof(*work), queue);
 		list_del(&work->queue);
 		if (cancel_work_sync(&work->work)) {
-			mmdrop(work->mm);
+			mmput(work->mm);
 			kvm_put_kvm(vcpu->kvm); /* == work->vcpu->kvm */
 			kmem_cache_free(async_pf_cache, work);
 		}
@@ -169,7 +169,7 @@ int kvm_setup_async_pf(struct kvm_vcpu *vcpu, gva_t gva, gfn_t gfn,
 	work->addr = gfn_to_hva(vcpu->kvm, gfn);
 	work->arch = *arch;
 	work->mm = current->mm;
-	atomic_inc(&work->mm->mm_count);
+	atomic_inc(&work->mm->mm_users);
 	kvm_get_kvm(work->vcpu->kvm);
 
 	/* this can't really happen otherwise gfn_to_pfn_async
@@ -187,7 +187,7 @@ int kvm_setup_async_pf(struct kvm_vcpu *vcpu, gva_t gva, gfn_t gfn,
 	return 1;
 retry_sync:
 	kvm_put_kvm(work->vcpu->kvm);
-	mmdrop(work->mm);
+	mmput(work->mm);
 	kmem_cache_free(async_pf_cache, work);
 	return 0;
 }
-- 
1.9.1

