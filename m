Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933104Ab3ECH4d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 03:56:33 -0400
Received: from mga02.intel.com ([134.134.136.20]:40020 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932934Ab3ECH4c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 03:56:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,602,1363158000"; 
   d="scan'208";a="307361323"
Message-ID: <51836D74.2030409@intel.com>
Date: Fri, 03 May 2013 15:55:32 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: mingo@redhat.com, tglx@linutronix.de, akpm@linux-foundation.org,
        arjan@linux.intel.com, bp@alien8.de, pjt@google.com,
        namhyung@kernel.org, efault@gmx.de, morten.rasmussen@arm.com,
        vincent.guittot@linaro.org, gregkh@linuxfoundation.org,
        preeti@linux.vnet.ibm.com, viresh.kumar@linaro.org,
        linux-kernel@vger.kernel.org, len.brown@intel.com,
        rafael.j.wysocki@intel.com, jkosina@suse.cz, clark.williams@gmail.com,
        tony.luck@intel.com, keescook@chromium.org, mgorman@suse.de,
        riel@redhat.com
Subject: Re: [PATCH v4 0/6] sched: use runnable load based balance
References: <1367040344-14485-1-git-send-email-alex.shi@intel.com> <20130501121421.GA19602@dyad.programming.kicks-ass.net> <5181B579.9000808@intel.com> <20130502103508.GA13196@dyad.programming.kicks-ass.net>
In-Reply-To: <20130502103508.GA13196@dyad.programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> That should probably look like:
> 
> 	preempt_disable();
> 	raw_spin_unlock_irq();
> 	preempt_enable_no_resched();
> 	schedule();
> 
> Otherwise you might find a performance regression on PREEMPT=y kernels.

Yes, right!
Thanks a lot for reminder. The following patch will fix it.
> 
> OK, so what I was asking after is if you changed the scheduler after PJTs
> patches landed to deal with this bulk wakeup. Also while aim7 might no longer
> trigger the bad pattern what is to say nothing ever will? In particular
> anything using pthread_cond_broadcast() is known to be suspect of bulk wakeups.

Just find a benchmark named as pthread_cond_broadcast. 
http://kristiannielsen.livejournal.com/13577.html. will play with it. :)
> 
> Anyway, I'll go try and make sense of some of the actual patches.. :-)
> 

---

>From 4c9b4b8a9b92bcbe6934637fd33c617e73dbda97 Mon Sep 17 00:00:00 2001
From: Alex Shi <alex.shi@intel.com>
Date: Fri, 3 May 2013 14:51:25 +0800
Subject: [PATCH 8/8] rwsem: small optimizing rwsem_down_failed_common

Peter Zijlstra suggest adding a preempt_enable_no_resched() to prevent
a unnecessary scheduler in raw_spin_unlock.
And we also can pack 2 raw_spin_lock to save one. So has this patch.

Thanks Peter!

Signed-off-by: Alex Shi <alex.shi@intel.com>
---
 lib/rwsem.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/lib/rwsem.c b/lib/rwsem.c
index ad5e0df..9aacf81 100644
--- a/lib/rwsem.c
+++ b/lib/rwsem.c
@@ -212,23 +212,25 @@ rwsem_down_failed_common(struct rw_semaphore *sem,
 		 adjustment == -RWSEM_ACTIVE_WRITE_BIAS)
 		sem = __rwsem_do_wake(sem, RWSEM_WAKE_READ_OWNED);
 
-	raw_spin_unlock_irq(&sem->wait_lock);
-
 	/* wait to be given the lock */
 	for (;;) {
-		if (!waiter.task)
+		if (!waiter.task) {
+			raw_spin_unlock_irq(&sem->wait_lock);
 			break;
+		}
 
-		raw_spin_lock_irq(&sem->wait_lock);
-		/* Try to get the writer sem, may steal from the head writer: */
+		/* Try to get the writer sem, may steal from the head writer */
 		if (flags == RWSEM_WAITING_FOR_WRITE)
 			if (try_get_writer_sem(sem, &waiter)) {
 				raw_spin_unlock_irq(&sem->wait_lock);
 				return sem;
 			}
+		preempt_disable();
 		raw_spin_unlock_irq(&sem->wait_lock);
+		preempt_enable_no_resched();
 		schedule();
 		set_task_state(tsk, TASK_UNINTERRUPTIBLE);
+		raw_spin_lock_irq(&sem->wait_lock);
 	}
 
 	tsk->state = TASK_RUNNING;
-- 
1.7.12

