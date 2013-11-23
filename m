Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754878Ab3KWMBY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Nov 2013 07:01:24 -0500
Received: from merlin.infradead.org ([205.233.59.134]:37908 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751988Ab3KWMBW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Nov 2013 07:01:22 -0500
Date: Sat, 23 Nov 2013 13:01:06 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Davidlohr Bueso <davidlohr@hp.com>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, dvhart@linux.intel.com,
        tglx@linutronix.de, efault@gmx.de, jeffm@suse.com,
        torvalds@linux-foundation.org, scott.norton@hp.com, tom.vaden@hp.com,
        aswin@hp.com, Waiman.Long@hp.com, jason.low2@hp.com
Subject: Re: [PATCH 5/5] sched,futex: Provide delayed wakeup list
Message-ID: <20131123120106.GE5364@laptop.programming.kicks-ass.net>
References: <1385168197-8612-1-git-send-email-davidlohr@hp.com>
 <1385168197-8612-6-git-send-email-davidlohr@hp.com>
 <20131123114815.GC16796@laptop.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131123114815.GC16796@laptop.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I used to have a patch to schedule() that would always immediately fall
> through and only actually block on the second call; it illustrated the
> problem really well, in fact so well the kernels fails to boot most
> times.

I found the below on my filesystem -- making it apply shouldn't be hard.
Making it work is the same effort as that patch you sent, we need to
guarantee all schedule() callers can deal with not actually sleeping --
aka. spurious wakeups.

I don't think anybody ever got that thing to run reliable enough to see
if the idea proposed in the patch made any difference to actual
workloads though.

---
Subject: 
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
Date: Thu Dec 09 17:51:09 CET 2010


Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/n/tip-v17vshx6uasjguuwd67fe7tg@git.kernel.org
---
 include/linux/sched.h |    5 +++--
 kernel/sched/core.c   |   18 ++++++++++++++++++
 2 files changed, 21 insertions(+), 2 deletions(-)

--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -153,9 +153,10 @@ print_cfs_rq(struct seq_file *m, int cpu
 #define TASK_DEAD		64
 #define TASK_WAKEKILL		128
 #define TASK_WAKING		256
-#define TASK_STATE_MAX		512
+#define TASK_YIELD		512
+#define TASK_STATE_MAX		1024
 
-#define TASK_STATE_TO_CHAR_STR "RSDTtZXxKW"
+#define TASK_STATE_TO_CHAR_STR "RSDTtZXxKWY"
 
 extern char ___assert_task_state[1 - 2*!!(
 		sizeof(TASK_STATE_TO_CHAR_STR)-1 != ilog2(TASK_STATE_MAX)+1)];
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -931,6 +931,7 @@ void set_task_cpu(struct task_struct *p,
 	 * ttwu() will sort out the placement.
 	 */
 	WARN_ON_ONCE(p->state != TASK_RUNNING && p->state != TASK_WAKING &&
+			!(p->state & TASK_YIELD) &&
 			!(task_thread_info(p)->preempt_count & PREEMPT_ACTIVE));
 
 #ifdef CONFIG_LOCKDEP
@@ -2864,6 +2865,22 @@ static void __sched __schedule(void)
 		if (unlikely(signal_pending_state(prev->state, prev))) {
 			prev->state = TASK_RUNNING;
 		} else {
+			/*
+			 * Provide an auto-yield feature on schedule().
+			 *
+			 * The thought is to avoid a sleep+wakeup cycle
+			 * if simply yielding the cpu will suffice to
+			 * satisfy the required condition.
+			 *
+			 * Assumes the calling schedule() site can deal
+			 * with spurious wakeups.
+			 */
+			if (prev->state & TASK_YIELD) {
+				prev->state &= ~TASK_YIELD;
+			       	if (rq->nr_running > 1)
+					goto no_deactivate;
+			}
+
 			deactivate_task(rq, prev, DEQUEUE_SLEEP);
 			prev->on_rq = 0;
 
@@ -2880,6 +2897,7 @@ static void __sched __schedule(void)
 					try_to_wake_up_local(to_wakeup);
 			}
 		}
+no_deactivate:
 		switch_count = &prev->nvcsw;
 	}
 
