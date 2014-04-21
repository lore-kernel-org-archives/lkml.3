Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752795AbaDUN0q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 09:26:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57498 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752354AbaDUN0G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 09:26:06 -0400
Date: Mon, 21 Apr 2014 15:26:01 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Avi Kivity <avi.kivity@gmail.com>, Gleb Natapov <gleb@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc: Dominik Dingel <dingel@linux.vnet.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] KVM: async_pf: mm->mm_users can not pin apf->mm
Message-ID: <20140421132601.GA13615@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140421132543.GA13594@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

get_user_pages(mm) is simply wrong if mm->mm_users == 0 and exit_mmap/etc
was already called (or is in progress), mm->mm_count can only pin mm->pgd
and mm_struct itself.

Change kvm_setup_async_pf/async_pf_execute to inc/dec mm->mm_users.

kvm_create_vm/kvm_destroy_vm play with ->mm_count too but this case looks
fine at first glance, it seems that this ->mm is only used to verify that
current->mm == kvm->mm.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 virt/kvm/async_pf.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/virt/kvm/async_pf.c b/virt/kvm/async_pf.c
index 0ced4f3..cda703e 100644
--- a/virt/kvm/async_pf.c
+++ b/virt/kvm/async_pf.c
@@ -99,7 +99,7 @@ static void async_pf_execute(struct work_struct *work)
 	if (waitqueue_active(&vcpu->wq))
 		wake_up_interruptible(&vcpu->wq);
 
-	mmdrop(mm);
+	mmput(mm);
 	kvm_put_kvm(vcpu->kvm);
 }
 
@@ -116,7 +116,7 @@ void kvm_clear_async_pf_completion_queue(struct kvm_vcpu *vcpu)
 		flush_work(&work->work);
 #else
 		if (cancel_work_sync(&work->work)) {
-			mmdrop(work->mm);
+			mmput(work->mm);
 			kvm_put_kvm(vcpu->kvm); /* == work->vcpu->kvm */
 			kmem_cache_free(async_pf_cache, work);
 		}
@@ -181,7 +181,7 @@ int kvm_setup_async_pf(struct kvm_vcpu *vcpu, gva_t gva, unsigned long hva,
 	work->addr = hva;
 	work->arch = *arch;
 	work->mm = current->mm;
-	atomic_inc(&work->mm->mm_count);
+	atomic_inc(&work->mm->mm_users);
 	kvm_get_kvm(work->vcpu->kvm);
 
 	/* this can't really happen otherwise gfn_to_pfn_async
@@ -199,7 +199,7 @@ int kvm_setup_async_pf(struct kvm_vcpu *vcpu, gva_t gva, unsigned long hva,
 	return 1;
 retry_sync:
 	kvm_put_kvm(work->vcpu->kvm);
-	mmdrop(work->mm);
+	mmput(work->mm);
 	kmem_cache_free(async_pf_cache, work);
 	return 0;
 }
-- 
1.5.5.1

