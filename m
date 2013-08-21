Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751858Ab3HUMtA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 08:49:00 -0400
Received: from merlin.infradead.org ([205.233.59.134]:56310 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751638Ab3HUMs7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 08:48:59 -0400
Date: Wed, 21 Aug 2013 14:48:49 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Arjan van de Ven <arjan@linux.intel.com>,
        Fernando Luis =?iso-8859-1?Q?V=E1zquez?= Cao 
	<fernando_b1@lab.ntt.co.jp>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 2/4] nohz: Synchronize sleep time stats with seqlock
Message-ID: <20130821124849.GB31370@twins.programming.kicks-ass.net>
References: <20130819111026.GE24092@twins.programming.kicks-ass.net>
 <521313D8.9080500@lab.ntt.co.jp>
 <20130820084405.GC3258@twins.programming.kicks-ass.net>
 <52138BE9.5090005@linux.intel.com>
 <20130820160146.GG3258@twins.programming.kicks-ass.net>
 <20130820163312.GA17957@redhat.com>
 <20130820175429.GI3258@twins.programming.kicks-ass.net>
 <20130820182553.GB22287@redhat.com>
 <20130821083130.GM3258@twins.programming.kicks-ass.net>
 <20130821113551.GA1472@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130821113551.GA1472@redhat.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 21, 2013 at 01:35:51PM +0200, Oleg Nesterov wrote:
> > > Btw. Whatever we do, can't we unify io_schedule/io_schedule_timeout?
> >
> > I suppose we could, a timeout of MAX_SCHEDULE_TIMEOUT will act like a
> > regular schedule, but it gets all the overhead of doing
> > schedule_timeout(). So I don't think its a win.
> 
> Well, the only overhead is "if(to == MAX_SCHEDULE_TIMEOUT)" at the start.
> I don't think it makes sense to copy-and-paste the identical code to
> avoid it. But please ignore, this is really minor and off-topic.

Ah, so the 'problem' is that schedule_timeout() doesn't live in
kernel/sched/core.c and we thus get an extra function call (which are
somewhat expensive on some archs).

That said, I suppose we could do something like the below, that should
allow the compiler to DTRT.

---
 include/linux/sched.h |   35 ++++++++++++++++++++++---
 kernel/sched/core.c   |   22 +++++-----------
 kernel/timer.c        |   67 ++++++++++--------------------------------------
 3 files changed, 52 insertions(+), 72 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 50d04b9..112960c 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -303,10 +303,37 @@ extern char __sched_text_start[], __sched_text_end[];
 extern int in_sched_functions(unsigned long addr);
 
 #define	MAX_SCHEDULE_TIMEOUT	LONG_MAX
-extern signed long schedule_timeout(signed long timeout);
-extern signed long schedule_timeout_interruptible(signed long timeout);
-extern signed long schedule_timeout_killable(signed long timeout);
-extern signed long schedule_timeout_uninterruptible(signed long timeout);
+extern long __schedule_timeout(long timeout);
+
+static inline long schedule_timeout(long timeout)
+{
+	if (timeout == MAX_SCHEDULE_TIMEOUT) {
+		schedule();
+		return timeout;
+	}
+	return __schedule_timeout(timeout);
+}
+
+/*
+ * We can use __set_current_state() here because schedule_timeout() calls
+ * schedule() unconditionally.
+ */
+static inline long schedule_timeout_interruptible(long timeout)
+{
+	__set_current_state(TASK_INTERRUPTIBLE);
+	return schedule_timeout(timeout);
+}
+static inline long schedule_timeout_killable(long timeout)
+{
+	__set_current_state(TASK_KILLABLE);
+	return schedule_timeout(timeout);
+}
+static inline long schedule_timeout_uninterruptible(long timeout)
+{
+	__set_current_state(TASK_UNINTERRUPTIBLE);
+	return schedule_timeout(timeout);
+}
+
 asmlinkage void schedule(void);
 extern void schedule_preempt_disabled(void);
 
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index f737871..ef2cddd 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -3937,21 +3937,6 @@ EXPORT_SYMBOL_GPL(yield_to);
  * This task is about to go to sleep on IO. Increment rq->nr_iowait so
  * that process accounting knows that this is a task in IO wait state.
  */
-void __sched io_schedule(void)
-{
-	struct rq *rq = raw_rq();
-
-	delayacct_blkio_start();
-	atomic_inc(&rq->nr_iowait);
-	blk_flush_plug(current);
-	current->in_iowait = 1;
-	schedule();
-	current->in_iowait = 0;
-	atomic_dec(&rq->nr_iowait);
-	delayacct_blkio_end();
-}
-EXPORT_SYMBOL(io_schedule);
-
 long __sched io_schedule_timeout(long timeout)
 {
 	struct rq *rq = raw_rq();
@@ -3968,6 +3953,13 @@ long __sched io_schedule_timeout(long timeout)
 	return ret;
 }
 
+void __sched io_schedule(void)
+{
+	io_schedule_timeout(MAX_SCHEDULE_TIMEOUT);
+}
+EXPORT_SYMBOL(io_schedule);
+
+
 /**
  * sys_sched_get_priority_max - return maximum RT priority.
  * @policy: scheduling class.
diff --git a/kernel/timer.c b/kernel/timer.c
index 15bc1b4..8244ce0 100644
--- a/kernel/timer.c
+++ b/kernel/timer.c
@@ -1429,38 +1429,24 @@ static void process_timeout(unsigned long __data)
  *
  * In all cases the return value is guaranteed to be non-negative.
  */
-signed long __sched schedule_timeout(signed long timeout)
+signed long __sched __schedule_timeout(signed long timeout)
 {
 	struct timer_list timer;
 	unsigned long expire;
 
-	switch (timeout)
-	{
-	case MAX_SCHEDULE_TIMEOUT:
-		/*
-		 * These two special cases are useful to be comfortable
-		 * in the caller. Nothing more. We could take
-		 * MAX_SCHEDULE_TIMEOUT from one of the negative value
-		 * but I' d like to return a valid offset (>=0) to allow
-		 * the caller to do everything it want with the retval.
-		 */
-		schedule();
-		goto out;
-	default:
-		/*
-		 * Another bit of PARANOID. Note that the retval will be
-		 * 0 since no piece of kernel is supposed to do a check
-		 * for a negative retval of schedule_timeout() (since it
-		 * should never happens anyway). You just have the printk()
-		 * that will tell you if something is gone wrong and where.
-		 */
-		if (timeout < 0) {
-			printk(KERN_ERR "schedule_timeout: wrong timeout "
+	/*
+	 * Another bit of PARANOID. Note that the retval will be 0 since no
+	 * piece of kernel is supposed to do a check for a negative retval of
+	 * schedule_timeout() (since it should never happens anyway). You just
+	 * have the printk() that will tell you if something is gone wrong and
+	 * where.
+	 */
+	if (timeout < 0) {
+		printk(KERN_ERR "schedule_timeout: wrong timeout "
 				"value %lx\n", timeout);
-			dump_stack();
-			current->state = TASK_RUNNING;
-			goto out;
-		}
+		dump_stack();
+		current->state = TASK_RUNNING;
+		goto out;
 	}
 
 	expire = timeout + jiffies;
@@ -1478,32 +1464,7 @@ signed long __sched schedule_timeout(signed long timeout)
  out:
 	return timeout < 0 ? 0 : timeout;
 }
-EXPORT_SYMBOL(schedule_timeout);
-
-/*
- * We can use __set_current_state() here because schedule_timeout() calls
- * schedule() unconditionally.
- */
-signed long __sched schedule_timeout_interruptible(signed long timeout)
-{
-	__set_current_state(TASK_INTERRUPTIBLE);
-	return schedule_timeout(timeout);
-}
-EXPORT_SYMBOL(schedule_timeout_interruptible);
-
-signed long __sched schedule_timeout_killable(signed long timeout)
-{
-	__set_current_state(TASK_KILLABLE);
-	return schedule_timeout(timeout);
-}
-EXPORT_SYMBOL(schedule_timeout_killable);
-
-signed long __sched schedule_timeout_uninterruptible(signed long timeout)
-{
-	__set_current_state(TASK_UNINTERRUPTIBLE);
-	return schedule_timeout(timeout);
-}
-EXPORT_SYMBOL(schedule_timeout_uninterruptible);
+EXPORT_SYMBOL(__schedule_timeout);
 
 static int __cpuinit init_timers_cpu(int cpu)
 {

