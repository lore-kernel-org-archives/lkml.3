Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030445AbaGPTUv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 15:20:51 -0400
Received: from terminus.zytor.com ([198.137.202.10]:44310 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933665AbaGPTUq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 15:20:46 -0400
Date: Wed, 16 Jul 2014 12:19:51 -0700
From: tip-bot for Peter Zijlstra <tipbot@zytor.com>
Message-ID: <tip-4a1c0f262f88e2676fda80a6bf80e7dbccae1dcb@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, sasha.levin@oracle.com, hpa@zytor.com,
        mingo@kernel.org, torvalds@linux-foundation.org, peterz@infradead.org,
        acme@kernel.org, davej@redhat.com, tj@kernel.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, sasha.levin@oracle.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        peterz@infradead.org, davej@redhat.com, acme@kernel.org, tj@kernel.org,
        tglx@linutronix.de
In-Reply-To: <20140623141242.GB19860@laptop.programming.kicks-ass.net>
References: <20140623141242.GB19860@laptop.programming.kicks-ass.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf: Fix lockdep warning on process exit
Git-Commit-ID: 4a1c0f262f88e2676fda80a6bf80e7dbccae1dcb
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  4a1c0f262f88e2676fda80a6bf80e7dbccae1dcb
Gitweb:     http://git.kernel.org/tip/4a1c0f262f88e2676fda80a6bf80e7dbccae1dcb
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Mon, 23 Jun 2014 16:12:42 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 16 Jul 2014 13:18:42 +0200

perf: Fix lockdep warning on process exit

Sasha Levin reported:

> While fuzzing with trinity inside a KVM tools guest running the latest -next
> kernel I've stumbled on the following spew:
>
> ======================================================
> [ INFO: possible circular locking dependency detected ]
> 3.15.0-next-20140613-sasha-00026-g6dd125d-dirty #654 Not tainted
> -------------------------------------------------------
> trinity-c578/9725 is trying to acquire lock:
> (&(&pool->lock)->rlock){-.-...}, at: __queue_work (kernel/workqueue.c:1346)
>
> but task is already holding lock:
> (&ctx->lock){-.....}, at: perf_event_exit_task (kernel/events/core.c:7471 kernel/events/core.c:7533)
>
> which lock already depends on the new lock.

> 1 lock held by trinity-c578/9725:
> #0: (&ctx->lock){-.....}, at: perf_event_exit_task (kernel/events/core.c:7471 kernel/events/core.c:7533)
>
>  Call Trace:
>  dump_stack (lib/dump_stack.c:52)
>  print_circular_bug (kernel/locking/lockdep.c:1216)
>  __lock_acquire (kernel/locking/lockdep.c:1840 kernel/locking/lockdep.c:1945 kernel/locking/lockdep.c:2131 kernel/locking/lockdep.c:3182)
>  lock_acquire (./arch/x86/include/asm/current.h:14 kernel/locking/lockdep.c:3602)
>  _raw_spin_lock (include/linux/spinlock_api_smp.h:143 kernel/locking/spinlock.c:151)
>  __queue_work (kernel/workqueue.c:1346)
>  queue_work_on (kernel/workqueue.c:1424)
>  free_object (lib/debugobjects.c:209)
>  __debug_check_no_obj_freed (lib/debugobjects.c:715)
>  debug_check_no_obj_freed (lib/debugobjects.c:727)
>  kmem_cache_free (mm/slub.c:2683 mm/slub.c:2711)
>  free_task (kernel/fork.c:221)
>  __put_task_struct (kernel/fork.c:250)
>  put_ctx (include/linux/sched.h:1855 kernel/events/core.c:898)
>  perf_event_exit_task (kernel/events/core.c:907 kernel/events/core.c:7478 kernel/events/core.c:7533)
>  do_exit (kernel/exit.c:766)
>  do_group_exit (kernel/exit.c:884)
>  get_signal_to_deliver (kernel/signal.c:2347)
>  do_signal (arch/x86/kernel/signal.c:698)
>  do_notify_resume (arch/x86/kernel/signal.c:751)
>  int_signal (arch/x86/kernel/entry_64.S:600)

Urgh.. so the only way I can make that happen is through:

  perf_event_exit_task_context()
    raw_spin_lock(&child_ctx->lock);
    unclone_ctx(child_ctx)
      put_ctx(ctx->parent_ctx);
    raw_spin_unlock_irqrestore(&child_ctx->lock);

And we can avoid this by doing the change below.

I can't immediately see how this changed recently, but given that you
say it's easy to reproduce, lets fix this.

Reported-by: Sasha Levin <sasha.levin@oracle.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Dave Jones <davej@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: http://lkml.kernel.org/r/20140623141242.GB19860@laptop.programming.kicks-ass.net
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/events/core.c | 18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index c46b02b..6b17ac1 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -7486,7 +7486,7 @@ __perf_event_exit_task(struct perf_event *child_event,
 static void perf_event_exit_task_context(struct task_struct *child, int ctxn)
 {
 	struct perf_event *child_event, *next;
-	struct perf_event_context *child_ctx;
+	struct perf_event_context *child_ctx, *parent_ctx;
 	unsigned long flags;
 
 	if (likely(!child->perf_event_ctxp[ctxn])) {
@@ -7511,6 +7511,15 @@ static void perf_event_exit_task_context(struct task_struct *child, int ctxn)
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
@@ -7521,6 +7530,13 @@ static void perf_event_exit_task_context(struct task_struct *child, int ctxn)
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
