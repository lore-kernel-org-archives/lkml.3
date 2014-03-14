Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755418AbaCNSYx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 14:24:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42056 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754478AbaCNSYw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 14:24:52 -0400
Date: Fri, 14 Mar 2014 19:23:31 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Gleb Natapov <gleb@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Davidlohr Bueso <davi@redhat.com>, Davidlohr Bueso <davidlohr@hp.com>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Rik van Riel <riel@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mgorman@suse.de>, Michel Lespinasse <walken@google.com>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: async_pf.c && use_mm() (Was: mm,vmacache: also flush cache for
	VM_CLONE)
Message-ID: <20140314182331.GA11482@redhat.com>
References: <CA+55aFxyGJFEz5NnHtK1wn8oDLy9n-CttttKL_0AM69gN8JzxQ@mail.gmail.com> <20140309170909.GA13335@redhat.com> <CA+55aFxEGj9poWNLAncvrrOTzjDtrwMnOM_d3ACqRkcvY86qHA@mail.gmail.com> <1394481375.3867.1.camel@buesod1.americas.hpqcorp.net> <20140313145941.GA26215@redhat.com> <CA+55aFyNd7L+G3hFauJPxUOengK-_o2G-SFmVooPZ-sE6xBj=g@mail.gmail.com> <20140313163632.GA30737@redhat.com> <20140313182702.GA3429@redhat.com> <CA+55aFwqTbsYCyPf6_i6RmBkPHpEhJjiRfZm6_1_yPa_kUkYiQ@mail.gmail.com> <CA+55aFzBjMQGapsS1Jw3rdrPaOYYPn7NamtjN47_W_r1QKX+8Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFzBjMQGapsS1Jw3rdrPaOYYPn7NamtjN47_W_r1QKX+8Q@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/13, Linus Torvalds wrote:
>
> Ok, no longer on my phone, and no, it clearly does the reference count with a
>
>     atomic_inc(&work->mm->mm_count);
>
> separately. The use_mm/unuse_mm seems entirely specious.

Yes, it really looks as if we can simply remove it.

But once again, with or without use_mm() it seems that the refcounting
is buggy. get_user_pages() is simply wrong if ->mm_users == 0 and
exit_mmap/etc was already called (or in progress).

So I think we need something like below, but I can't test this change
or audit other (potential) users of kvm_async_pf->mm.

Perhaps this is not a bug and somehow it is guaranteed that, say,
kvm_clear_async_pf_completion_queue() must be always called before the
caller of kvm_setup_async_pf() can exit? I don't know, but in this case
we do not need any accounting and this should be documented.

Gleb, what do you think?

Oleg.

--- x/virt/kvm/async_pf.c
+++ x/virt/kvm/async_pf.c
@@ -65,11 +65,9 @@ static void async_pf_execute(struct work_struct *work)
 
 	might_sleep();
 
-	use_mm(mm);
 	down_read(&mm->mmap_sem);
 	get_user_pages(current, mm, addr, 1, 1, 0, NULL, NULL);
 	up_read(&mm->mmap_sem);
-	unuse_mm(mm);
 
 	spin_lock(&vcpu->async_pf.lock);
 	list_add_tail(&apf->link, &vcpu->async_pf.done);
@@ -85,7 +83,7 @@ static void async_pf_execute(struct work_struct *work)
 	if (waitqueue_active(&vcpu->wq))
 		wake_up_interruptible(&vcpu->wq);
 
-	mmdrop(mm);
+	mmput(mm);
 	kvm_put_kvm(vcpu->kvm);
 }
 
@@ -98,7 +96,7 @@ void kvm_clear_async_pf_completion_queue(struct kvm_vcpu *vcpu)
 				   typeof(*work), queue);
 		list_del(&work->queue);
 		if (cancel_work_sync(&work->work)) {
-			mmdrop(work->mm);
+			mmput(work->mm);
 			kvm_put_kvm(vcpu->kvm); /* == work->vcpu->kvm */
 			kmem_cache_free(async_pf_cache, work);
 		}
@@ -162,7 +160,7 @@ int kvm_setup_async_pf(struct kvm_vcpu *vcpu, gva_t gva, gfn_t gfn,
 	work->addr = gfn_to_hva(vcpu->kvm, gfn);
 	work->arch = *arch;
 	work->mm = current->mm;
-	atomic_inc(&work->mm->mm_count);
+	atomic_inc(&work->mm->mm_users);
 	kvm_get_kvm(work->vcpu->kvm);
 
 	/* this can't really happen otherwise gfn_to_pfn_async
@@ -180,7 +178,7 @@ int kvm_setup_async_pf(struct kvm_vcpu *vcpu, gva_t gva, gfn_t gfn,
 	return 1;
 retry_sync:
 	kvm_put_kvm(work->vcpu->kvm);
-	mmdrop(work->mm);
+	mmput(work->mm);
 	kmem_cache_free(async_pf_cache, work);
 	return 0;
 }

