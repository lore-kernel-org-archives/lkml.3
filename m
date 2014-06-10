Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755478AbaFJU2Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 16:28:25 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:35080 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754019AbaFJTtK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 15:49:10 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Oleg Nesterov <oleg@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 113/160] KVM: async_pf: mm->mm_users can not pin apf->mm
Date: Tue, 10 Jun 2014 12:45:53 -0700
Message-Id: <1402429600-20477-114-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1402429600-20477-1-git-send-email-kamal@canonical.com>
References: <1402429600-20477-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.3 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 virt/kvm/async_pf.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/virt/kvm/async_pf.c b/virt/kvm/async_pf.c
index 8631d9c..f2c80d5 100644
--- a/virt/kvm/async_pf.c
+++ b/virt/kvm/async_pf.c
@@ -85,7 +85,7 @@ static void async_pf_execute(struct work_struct *work)
 	if (waitqueue_active(&vcpu->wq))
 		wake_up_interruptible(&vcpu->wq);
 
-	mmdrop(mm);
+	mmput(mm);
 	kvm_put_kvm(vcpu->kvm);
 }
 
@@ -98,7 +98,7 @@ void kvm_clear_async_pf_completion_queue(struct kvm_vcpu *vcpu)
 				   typeof(*work), queue);
 		list_del(&work->queue);
 		if (cancel_work_sync(&work->work)) {
-			mmdrop(work->mm);
+			mmput(work->mm);
 			kvm_put_kvm(vcpu->kvm); /* == work->vcpu->kvm */
 			kmem_cache_free(async_pf_cache, work);
 		}
@@ -162,7 +162,7 @@ int kvm_setup_async_pf(struct kvm_vcpu *vcpu, gva_t gva, gfn_t gfn,
 	work->addr = gfn_to_hva(vcpu->kvm, gfn);
 	work->arch = *arch;
 	work->mm = current->mm;
-	atomic_inc(&work->mm->mm_count);
+	atomic_inc(&work->mm->mm_users);
 	kvm_get_kvm(work->vcpu->kvm);
 
 	/* this can't really happen otherwise gfn_to_pfn_async
@@ -180,7 +180,7 @@ int kvm_setup_async_pf(struct kvm_vcpu *vcpu, gva_t gva, gfn_t gfn,
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

