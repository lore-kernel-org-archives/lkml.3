Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753533Ab3BPQMe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2013 11:12:34 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:21366 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753484Ab3BPQMd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2013 11:12:33 -0500
X-Authority-Analysis: v=2.0 cv=UN5f7Vjy c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=MPEKn9ueenIA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=zGjexpQmzOwA:10 a=pFGuKcPpq-rcvapjx70A:9 a=PUjeQqilurYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1361031150.23152.133.camel@gandalf.local.home>
Subject: Re: [RFC] sched: The removal of idle_balance()
From: Steven Rostedt <rostedt@goodmis.org>
To: Mike Galbraith <efault@gmx.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, Paul Turner <pjt@google.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Clark Williams <clark@redhat.com>,
        Andrew Theurer <habanero@us.ibm.com>
Date: Sat, 16 Feb 2013 11:12:30 -0500
In-Reply-To: <1360913172.4736.20.camel@marge.simpson.net>
References: <1360908819.23152.97.camel@gandalf.local.home>
	 <1360913172.4736.20.camel@marge.simpson.net>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-02-15 at 08:26 +0100, Mike Galbraith wrote:
> On Fri, 2013-02-15 at 01:13 -0500, Steven Rostedt wrote:
> 
> > Think about it some more, just because we go idle isn't enough reason to
> > pull a runable task over. CPUs go idle all the time, and tasks are woken
> > up all the time. There's no reason that we can't just wait for the sched
> > tick to decide its time to do a bit of balancing. Sure, it would be nice
> > if the idle CPU did the work. But I think that frame of mind was an
> > incorrect notion from back in the early 2000s and does not apply to
> > today's hardware, or perhaps it doesn't apply to the (relatively) new
> > CFS scheduler. If you want aggressive scheduling, make the task rt, and
> > it will do aggressive scheduling.
> 
> (the throttle is supposed to keep idle_balance() from doing severe
> damage, that may want a peek/tweak)
> 
> Hackbench spreads itself with FORK/EXEC balancing, how does say a kbuild
> do with no idle_balance()?
> 

Interesting, I added this patch and it brought down my hackbench to the
same level as removing idle_balance(). Although, on initial tests, it
doesn't seem to help much else (compiles and such), but it doesn't seem
to hurt things either.

As idea of this patch is that we do not want to run the idle_balance if
a task will wake up soon. It adds the heuristic, that if the previous
task is set to TASK_UNINTERRUPTIBLE it will probably wake up in the near
future, because it is blocked on IO or even a mutex. Especially if it is
blocked on a mutex it will likely wake up soon, thus the CPU technically
isn't quite idle. Avoiding the idle balance in this case brings
hackbench back down (50%) on my box.

Ideally, I would have liked to use rq->nr_uninterruptible, but that
counter is only meaningful for the sum of all CPUs, as it may be
incremented on one CPU but then decremented on another CPU. Thus my
algorithm can only use the heuristic of the task immediately going to
sleep.

-- Steve

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 1dff78a..886a9af 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -2928,7 +2928,7 @@ need_resched:
 	pre_schedule(rq, prev);
 
 	if (unlikely(!rq->nr_running))
-		idle_balance(cpu, rq);
+		idle_balance(cpu, rq, prev);
 
 	put_prev_task(rq, prev);
 	next = pick_next_task(rq);
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index ed18c74..a29ea5e 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -5208,7 +5208,7 @@ out:
  * idle_balance is called by schedule() if this_cpu is about to become
  * idle. Attempts to pull tasks from other CPUs.
  */
-void idle_balance(int this_cpu, struct rq *this_rq)
+void idle_balance(int this_cpu, struct rq *this_rq, struct task_struct *prev)
 {
 	struct sched_domain *sd;
 	int pulled_task = 0;
@@ -5216,6 +5216,9 @@ void idle_balance(int this_cpu, struct rq *this_rq)
 
 	this_rq->idle_stamp = this_rq->clock;
 
+	if (!(prev->state & TASK_UNINTERRUPTIBLE))
+		return;
+
 	if (this_rq->avg_idle < sysctl_sched_migration_cost)
 		return;
 
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index fc88644..f259070 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -876,11 +876,11 @@ extern const struct sched_class idle_sched_class;
 #ifdef CONFIG_SMP
 
 extern void trigger_load_balance(struct rq *rq, int cpu);
-extern void idle_balance(int this_cpu, struct rq *this_rq);
+extern void idle_balance(int this_cpu, struct rq *this_rq, struct task_struct *prev);
 
 #else	/* CONFIG_SMP */
 
-static inline void idle_balance(int cpu, struct rq *rq)
+static inline void idle_balance(int cpu, struct rq *rq, struct task_struct *prev)
 {
 }
 


