Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753464AbaFGBcr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 21:32:47 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:36101 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752653AbaFGBXj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 21:23:39 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Oleg Nesterov" <oleg@redhat.com>,
        "Paolo Bonzini" <pbonzini@redhat.com>
Date: Sat, 07 Jun 2014 02:26:29 +0100
Message-ID: <lsq.1402104389.565998987@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 36/92] KVM: async_pf: mm->mm_users can not pin apf->mm
In-Reply-To: <lsq.1402104388.385007124@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.60-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 virt/kvm/async_pf.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/virt/kvm/async_pf.c
+++ b/virt/kvm/async_pf.c
@@ -87,7 +87,7 @@ static void async_pf_execute(struct work
 	if (waitqueue_active(&vcpu->wq))
 		wake_up_interruptible(&vcpu->wq);
 
-	mmdrop(mm);
+	mmput(mm);
 	kvm_put_kvm(vcpu->kvm);
 }
 
@@ -100,7 +100,7 @@ void kvm_clear_async_pf_completion_queue
 				   typeof(*work), queue);
 		list_del(&work->queue);
 		if (cancel_work_sync(&work->work)) {
-			mmdrop(work->mm);
+			mmput(work->mm);
 			kvm_put_kvm(vcpu->kvm); /* == work->vcpu->kvm */
 			kmem_cache_free(async_pf_cache, work);
 		}
@@ -169,7 +169,7 @@ int kvm_setup_async_pf(struct kvm_vcpu *
 	work->addr = gfn_to_hva(vcpu->kvm, gfn);
 	work->arch = *arch;
 	work->mm = current->mm;
-	atomic_inc(&work->mm->mm_count);
+	atomic_inc(&work->mm->mm_users);
 	kvm_get_kvm(work->vcpu->kvm);
 
 	/* this can't really happen otherwise gfn_to_pfn_async
@@ -187,7 +187,7 @@ int kvm_setup_async_pf(struct kvm_vcpu *
 	return 1;
 retry_sync:
 	kvm_put_kvm(work->vcpu->kvm);
-	mmdrop(work->mm);
+	mmput(work->mm);
 	kmem_cache_free(async_pf_cache, work);
 	return 0;
 }

