Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758906AbaELPW7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 11:22:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25287 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758554AbaELPW4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 11:22:56 -0400
Date: Mon, 12 May 2014 17:22:08 +0200
From: Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>
To: Waiman Long <Waiman.Long@hp.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>, linux-arch@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        xen-devel@lists.xenproject.org, kvm@vger.kernel.org,
        Paolo Bonzini <paolo.bonzini@gmail.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Rik van Riel <riel@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        David Vrabel <david.vrabel@citrix.com>,
        Oleg Nesterov <oleg@redhat.com>, Gleb Natapov <gleb@redhat.com>,
        Scott J Norton <scott.norton@hp.com>, Chegu Vinod <chegu_vinod@hp.com>
Subject: Re: [PATCH v10 03/19] qspinlock: Add pending bit
Message-ID: <20140512152208.GA12309@potion.brq.redhat.com>
References: <1399474907-22206-1-git-send-email-Waiman.Long@hp.com>
 <1399474907-22206-4-git-send-email-Waiman.Long@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1399474907-22206-4-git-send-email-Waiman.Long@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-05-07 11:01-0400, Waiman Long:
> From: Peter Zijlstra <peterz@infradead.org>
> 
> Because the qspinlock needs to touch a second cacheline; add a pending
> bit and allow a single in-word spinner before we punt to the second
> cacheline.

I think there is an unwanted scenario on virtual machines:
1) VCPU sets the pending bit and start spinning.
2) Pending VCPU gets descheduled.
    - we have PLE and lock holder isn't running [1]
    - the hypervisor randomly preempts us
3) Lock holder unlocks while pending VCPU is waiting in queue.
4) Subsequent lockers will see free lock with set pending bit and will
   loop in trylock's 'for (;;)'
    - the worst-case is lock starving [2]
    - PLE can save us from wasting whole timeslice

Retry threshold is the easiest solution, regardless of its ugliness [4].

Another minor design flaw is that formerly first VCPU gets appended to
the tail when it decides to queue;
is the performance gain worth it?

Thanks.


---
1: Pause Loop Exiting is almost certain to vmexit in that case: we
   default to 4096 TSC cycles on KVM, and pending loop is longer than 4
   (4096/PSPIN_THRESHOLD).
   We would also vmexit if critical section was longer than 4k.

2: In this example, vpus 1 and 2 use the lock while 3 never gets there.
   VCPU:  1      2      3
        lock()                   // we are the holder
              pend()             // we have pending bit
              vmexit             // while in PSPIN_THRESHOLD loop
        unlock()
                     vmentry
                     SPINNING    // for {;;} loop
                     vmexit
              vmentry
              lock()
        pend()
        vmexit
             unlock()
                     vmentry
                     SPINNING
                     vmexit
        vmentry
        --- loop ---

   The window is (should be) too small to happen in bare-metal.

3: Pending VCPU was first in line, but when it decides to queue, it must
   go to the tail.

4:
The idea is to prevent unfairness by queueing after a while of useless
looping.  Magic value should be set a bit above the time it takes an
active pending bit holder to go through the loop.  4 looks enough.
We can use either pv_qspinlock_enabled() or cpu_has_hypervisor.
I presume that we never want this to happen in a VM and that we won't
have pv_qspinlock_enabled() without cpu_has_hypervisor.

diff --git a/kernel/locking/qspinlock.c b/kernel/locking/qspinlock.c
index 37b5c7f..cd45c27 100644
--- a/kernel/locking/qspinlock.c
+++ b/kernel/locking/qspinlock.c
@@ -573,7 +573,7 @@ static __always_inline int get_qlock(struct qspinlock *lock)
 static inline int trylock_pending(struct qspinlock *lock, u32 *pval)
 {
 	u32 old, new, val = *pval;
-	int retry = 1;
+	int retry = 0;
 
 	/*
 	 * trylock || pending
@@ -595,9 +595,9 @@ static inline int trylock_pending(struct qspinlock *lock, u32 *pval)
 			 * a while to see if that either bit will be cleared.
 			 * If that is no change, we return and be queued.
 			 */
-			if (!retry)
+			if (retry)
 				return 0;
-			retry--;
+			retry++;
 			cpu_relax();
 			cpu_relax();
 			*pval = val = atomic_read(&lock->val);
@@ -608,7 +608,11 @@ static inline int trylock_pending(struct qspinlock *lock, u32 *pval)
 			 * Assuming that the pending bit holder is going to
 			 * set the lock bit and clear the pending bit soon,
 			 * it is better to wait than to exit at this point.
+			 * Our assumption does not hold on hypervisors, where
+			 * the pending bit holder doesn't have to be running.
 			 */
+			if (cpu_has_hypervisor && ++retry > MAGIC)
+					return 0;
 			cpu_relax();
 			*pval = val = atomic_read(&lock->val);
 			continue;
