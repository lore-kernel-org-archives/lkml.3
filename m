Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758252AbaEKUAF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2014 16:00:05 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:47963 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757351AbaEKTUy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2014 15:20:54 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Oleg Nesterov <oleg@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 3.14 09/83] KVM: async_pf: mm->mm_users can not pin apf->mm
Date: Sun, 11 May 2014 21:19:10 +0200
Message-Id: <20140511191908.320176620@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140511191907.024339448@linuxfoundation.org>
References: <20140511191907.024339448@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 virt/kvm/async_pf.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/virt/kvm/async_pf.c
+++ b/virt/kvm/async_pf.c
@@ -85,7 +85,7 @@ static void async_pf_execute(struct work
 	if (waitqueue_active(&vcpu->wq))
 		wake_up_interruptible(&vcpu->wq);
 
-	mmdrop(mm);
+	mmput(mm);
 	kvm_put_kvm(vcpu->kvm);
 }
 
@@ -98,7 +98,7 @@ void kvm_clear_async_pf_completion_queue
 				   typeof(*work), queue);
 		list_del(&work->queue);
 		if (cancel_work_sync(&work->work)) {
-			mmdrop(work->mm);
+			mmput(work->mm);
 			kvm_put_kvm(vcpu->kvm); /* == work->vcpu->kvm */
 			kmem_cache_free(async_pf_cache, work);
 		}
@@ -162,7 +162,7 @@ int kvm_setup_async_pf(struct kvm_vcpu *
 	work->addr = gfn_to_hva(vcpu->kvm, gfn);
 	work->arch = *arch;
 	work->mm = current->mm;
-	atomic_inc(&work->mm->mm_count);
+	atomic_inc(&work->mm->mm_users);
 	kvm_get_kvm(work->vcpu->kvm);
 
 	/* this can't really happen otherwise gfn_to_pfn_async
@@ -180,7 +180,7 @@ int kvm_setup_async_pf(struct kvm_vcpu *
 	return 1;
 retry_sync:
 	kvm_put_kvm(work->vcpu->kvm);
-	mmdrop(work->mm);
+	mmput(work->mm);
 	kmem_cache_free(async_pf_cache, work);
 	return 0;
 }


