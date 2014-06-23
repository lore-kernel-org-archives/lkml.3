Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754900AbaFWOMv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 10:12:51 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:41714 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751211AbaFWOMs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 10:12:48 -0400
Date: Mon, 23 Jun 2014 16:12:42 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: Ingo Molnar <mingo@kernel.org>, acme@ghostprotocols.net, paulus@samba.org,
        Tejun Heo <tj@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Dave Jones <davej@redhat.com>
Subject: Re: perf/workqueue: lockdep warning on process exit
Message-ID: <20140623141242.GB19860@laptop.programming.kicks-ass.net>
References: <539EFE3A.7020700@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <539EFE3A.7020700@oracle.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 16, 2014 at 10:24:58AM -0400, Sasha Levin wrote:
> Hi all,
> 
> While fuzzing with trinity inside a KVM tools guest running the latest -next
> kernel I've stumbled on the following spew:
> 
> [  430.429005] ======================================================
> [  430.429005] [ INFO: possible circular locking dependency detected ]
> [  430.429005] 3.15.0-next-20140613-sasha-00026-g6dd125d-dirty #654 Not tainted
> [  430.429005] -------------------------------------------------------
> [  430.429005] trinity-c578/9725 is trying to acquire lock:
> [  430.429005] (&(&pool->lock)->rlock){-.-...}, at: __queue_work (kernel/workqueue.c:1346)
> [  430.429005]
> [  430.429005] but task is already holding lock:
> [  430.429005] (&ctx->lock){-.....}, at: perf_event_exit_task (kernel/events/core.c:7471 kernel/events/core.c:7533)
> [  430.439509]
> [  430.439509] which lock already depends on the new lock.


> [  430.450111] 1 lock held by trinity-c578/9725:
> [  430.450111] #0: (&ctx->lock){-.....}, at: perf_event_exit_task (kernel/events/core.c:7471 kernel/events/core.c:7533)
> [  430.450111]
> [  430.450111] stack backtrace:
> [  430.450111] CPU: 6 PID: 9725 Comm: trinity-c578 Not tainted 3.15.0-next-20140613-sasha-00026-g6dd125d-dirty #654
> [  430.450111]  ffffffffadb45840 ffff880101787848 ffffffffaa511b1c 0000000000000003
> [  430.450111]  ffffffffadb8a4c0 ffff880101787898 ffffffffaa5044e2 0000000000000001
> [  430.450111]  ffff880101787928 ffff880101787898 ffff8800aed98cf8 ffff8800aed98000
> [  430.450111] Call Trace:
> [  430.450111] dump_stack (lib/dump_stack.c:52)
> [  430.450111] print_circular_bug (kernel/locking/lockdep.c:1216)
> [  430.450111] __lock_acquire (kernel/locking/lockdep.c:1840 kernel/locking/lockdep.c:1945 kernel/locking/lockdep.c:2131 kernel/locking/lockdep.c:3182)
> [  430.450111] lock_acquire (./arch/x86/include/asm/current.h:14 kernel/locking/lockdep.c:3602)
> [  430.450111] _raw_spin_lock (include/linux/spinlock_api_smp.h:143 kernel/locking/spinlock.c:151)
> [  430.450111] __queue_work (kernel/workqueue.c:1346)
> [  430.450111] queue_work_on (kernel/workqueue.c:1424)
> [  430.450111] free_object (lib/debugobjects.c:209)
> [  430.450111] __debug_check_no_obj_freed (lib/debugobjects.c:715)
> [  430.450111] debug_check_no_obj_freed (lib/debugobjects.c:727)
> [  430.450111] kmem_cache_free (mm/slub.c:2683 mm/slub.c:2711)
> [  430.450111] free_task (kernel/fork.c:221)
> [  430.450111] __put_task_struct (kernel/fork.c:250)
> [  430.450111] put_ctx (include/linux/sched.h:1855 kernel/events/core.c:898)
> [  430.450111] perf_event_exit_task (kernel/events/core.c:907 kernel/events/core.c:7478 kernel/events/core.c:7533)
> [  430.450111] do_exit (kernel/exit.c:766)
> [  430.450111] do_group_exit (kernel/exit.c:884)
> [  430.450111] get_signal_to_deliver (kernel/signal.c:2347)
> [  430.450111] do_signal (arch/x86/kernel/signal.c:698)
> [  430.450111] do_notify_resume (arch/x86/kernel/signal.c:751)
> [  430.450111] int_signal (arch/x86/kernel/entry_64.S:600)


Urgh.. so the only way I can make that happen is through:

  perf_event_exit_task_context()
    raw_spin_lock(&child_ctx->lock);
    unclone_ctx(child_ctx)
      put_ctx(ctx->parent_ctx);
    raw_spin_unlock_irqrestore(&child_ctx->lock);

And we can avoid this by doing something like..

I can't immediately see how this changed recently, but given that you
say its easy to reproduce, can you give this a spin?

---
 kernel/events/core.c | 18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index a33d9a2bcbd7..5e90fa579055 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -7474,7 +7474,7 @@ __perf_event_exit_task(struct perf_event *child_event,
 static void perf_event_exit_task_context(struct task_struct *child, int ctxn)
 {
 	struct perf_event *child_event, *next;
-	struct perf_event_context *child_ctx;
+	struct perf_event_context *child_ctx, *parent_ctx;
 	unsigned long flags;
 
 	if (likely(!child->perf_event_ctxp[ctxn])) {
@@ -7499,6 +7499,15 @@ static void perf_event_exit_task_context(struct task_struct *child, int ctxn)
 	raw_spin_lock(&child_ctx->lock);
 	task_ctx_sched_out(child_ctx);
 	child->perf_event_ctxp[ctxn] = NULL;
+
+	/*
+	 * In order to avoid freeing: child_ctx->parent_ctx->task
+	 * under perf_event_context::lock, grab another reference.
+	 */
+	parent_ctx = child_ctx->parent_ctx;
+	if (parent_ctx)
+		get_ctx(parent_ctx);
+
 	/*
 	 * If this context is a clone; unclone it so it can't get
 	 * swapped to another process while we're removing all
@@ -7509,6 +7518,13 @@ static void perf_event_exit_task_context(struct task_struct *child, int ctxn)
 	raw_spin_unlock_irqrestore(&child_ctx->lock, flags);
 
 	/*
+	 * Now that we no longer hold perf_event_context::lock, drop
+	 * our extra child_ctx->parent_ctx reference.
+	 */
+	if (parent_ctx)
+		put_ctx(parent_ctx);
+
+	/*
 	 * Report the task dead after unscheduling the events so that we
 	 * won't get any samples after PERF_RECORD_EXIT. We can however still
 	 * get a few PERF_RECORD_READ events.
