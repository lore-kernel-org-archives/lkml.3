Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759262AbaD3Sox (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 14:44:53 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:38871 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751498AbaD3Sov (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 14:44:51 -0400
Date: Wed, 30 Apr 2014 20:44:37 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Vince Weaver <vincent.weaver@maine.edu>
Cc: Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [perf] more perf_fuzzer memory corruption
Message-ID: <20140430184437.GH17778@laptop.programming.kicks-ass.net>
References: <20140418165958.GQ13658@twins.programming.kicks-ass.net>
 <20140418171516.GR13658@twins.programming.kicks-ass.net>
 <alpine.DEB.2.10.1404231643420.30955@vincent-weaver-1.um.maine.edu>
 <alpine.DEB.2.10.1404242243220.12717@vincent-weaver-1.umelst.maine.edu>
 <alpine.DEB.2.10.1404281017590.18996@vincent-weaver-1.umelst.maine.edu>
 <alpine.DEB.2.10.1404281447570.18996@vincent-weaver-1.umelst.maine.edu>
 <20140429094632.GP27561@twins.programming.kicks-ass.net>
 <alpine.DEB.2.10.1404291411220.22490@vincent-weaver-1.umelst.maine.edu>
 <20140429190108.GB30445@twins.programming.kicks-ass.net>
 <alpine.DEB.2.10.1404291534520.22490@vincent-weaver-1.umelst.maine.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.10.1404291534520.22490@vincent-weaver-1.umelst.maine.edu>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Vince, could you add the below to whatever tracing muck you already
have?

After staring at your traces all day with Thomas, we have doubts about
the refcount integrity.



---
 kernel/events/core.c | 146 +++++++++++++++++++++++++++++----------------------
 1 file changed, 82 insertions(+), 64 deletions(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index 5129b1201050..dac01e099f13 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -1664,6 +1664,9 @@ event_sched_in(struct perf_event *event,
 	u64 tstamp = perf_event_time(event);
 	int ret = 0;
 
+	WARN_ON(event->ctx != ctx);
+	lockdep_assert_held(&ctx->lock);
+
 	if (event->state <= PERF_EVENT_STATE_OFF)
 		return 0;
 
@@ -2029,14 +2032,9 @@ static int __perf_event_enable(void *info)
 	if (leader != event && leader->state != PERF_EVENT_STATE_ACTIVE)
 		goto unlock;
 
-	if (!group_can_go_on(event, cpuctx, 1)) {
-		err = -EEXIST;
-	} else {
-		if (event == leader)
-			err = group_sched_in(event, cpuctx, ctx);
-		else
-			err = event_sched_in(event, cpuctx, ctx);
-	}
+	err = -EEXIST;
+	if (group_can_go_on(event, cpuctx, 1))
+		err = group_sched_in(event, cpuctx, ctx);
 
 	if (err) {
 		/*
@@ -2293,6 +2291,7 @@ static void perf_event_context_sched_out(struct task_struct *task, int ctxn,
 	if (!cpuctx->task_ctx)
 		return;
 
+#if 0
 	rcu_read_lock();
 	next_ctx = next->perf_event_ctxp[ctxn];
 	if (!next_ctx)
@@ -2335,6 +2334,7 @@ static void perf_event_context_sched_out(struct task_struct *task, int ctxn,
 	}
 unlock:
 	rcu_read_unlock();
+#endif
 
 	if (do_switch) {
 		raw_spin_lock(&ctx->lock);
@@ -3233,10 +3233,18 @@ static void __free_event(struct perf_event *event)
 	if (event->pmu)
 		module_put(event->pmu->module);
 
+	WARN_ON(event->hlist_entry.pprev && event->hlist_entry.pprev != LIST_POISON2);
+
 	call_rcu(&event->rcu_head, free_event_rcu);
 }
-static void free_event(struct perf_event *event)
+
+static void _free_event(struct perf_event *event)
 {
+	long refs = atomic_long_read(&event->refcount);
+
+	WARN(refs, "freeing event with %ld refs left; ptr=0x%p\n", refs, event);
+	trace_printk("freeing with %ld refs; ptr=0x%p\n", refs, event);
+
 	irq_work_sync(&event->pending);
 
 	unaccount_event(event);
@@ -3263,48 +3271,32 @@ static void free_event(struct perf_event *event)
 	if (is_cgroup_event(event))
 		perf_detach_cgroup(event);
 
-
 	__free_event(event);
 }
 
-int perf_event_release_kernel(struct perf_event *event)
+static void free_event(struct perf_event *event)
 {
-	struct perf_event_context *ctx = event->ctx;
-
-	WARN_ON_ONCE(ctx->parent_ctx);
-	/*
-	 * There are two ways this annotation is useful:
-	 *
-	 *  1) there is a lock recursion from perf_event_exit_task
-	 *     see the comment there.
-	 *
-	 *  2) there is a lock-inversion with mmap_sem through
-	 *     perf_event_read_group(), which takes faults while
-	 *     holding ctx->mutex, however this is called after
-	 *     the last filedesc died, so there is no possibility
-	 *     to trigger the AB-BA case.
-	 */
-	mutex_lock_nested(&ctx->mutex, SINGLE_DEPTH_NESTING);
-	raw_spin_lock_irq(&ctx->lock);
-	perf_group_detach(event);
-	raw_spin_unlock_irq(&ctx->lock);
-	perf_remove_from_context(event);
-	mutex_unlock(&ctx->mutex);
-
-	free_event(event);
-
-	return 0;
+	if (unlikely(atomic_long_cmpxchg(&event->refcount, 1, 0) != 1)) {
+		WARN(1, "unexpected event refcount: %ld; ptr=0x%p\n",
+				atomic_long_read(&event->refcount),
+				event);
+		return;
+	}
+	_free_event(event);
 }
-EXPORT_SYMBOL_GPL(perf_event_release_kernel);
 
 /*
  * Called when the last reference to the file is gone.
  */
-static void put_event(struct perf_event *event)
+static void put_event(struct perf_event *event, struct perf_event *other)
 {
+	struct perf_event_context *ctx = event->ctx;
 	struct task_struct *owner;
 
-	if (!atomic_long_dec_and_test(&event->refcount))
+	long refs = atomic_long_sub_return(1, &event->refcount);
+	trace_printk("put ref: %ld; ptr=0x%p other=0x%p\n", refs, event, other);
+
+	if (refs)
 		return;
 
 	rcu_read_lock();
@@ -3316,14 +3308,8 @@ static void put_event(struct perf_event *event)
 	 * owner->perf_event_mutex.
 	 */
 	smp_read_barrier_depends();
-	if (owner) {
-		/*
-		 * Since delayed_put_task_struct() also drops the last
-		 * task reference we can safely take a new reference
-		 * while holding the rcu_read_lock().
-		 */
-		get_task_struct(owner);
-	}
+	if (owner && !atomic_inc_not_zero(&owner->usage))
+		owner = NULL;
 	rcu_read_unlock();
 
 	if (owner) {
@@ -3340,12 +3326,39 @@ static void put_event(struct perf_event *event)
 		put_task_struct(owner);
 	}
 
-	perf_event_release_kernel(event);
+	WARN_ON_ONCE(ctx->parent_ctx);
+	/*
+	 * There are two ways this annotation is useful:
+	 *
+	 *  1) there is a lock recursion from perf_event_exit_task
+	 *     see the comment there.
+	 *
+	 *  2) there is a lock-inversion with mmap_sem through
+	 *     perf_event_read_group(), which takes faults while
+	 *     holding ctx->mutex, however this is called after
+	 *     the last filedesc died, so there is no possibility
+	 *     to trigger the AB-BA case.
+	 */
+	mutex_lock_nested(&ctx->mutex, SINGLE_DEPTH_NESTING);
+	raw_spin_lock_irq(&ctx->lock);
+	perf_group_detach(event);
+	raw_spin_unlock_irq(&ctx->lock);
+	perf_remove_from_context(event);
+	mutex_unlock(&ctx->mutex);
+
+	_free_event(event);
+}
+
+int perf_event_release_kernel(struct perf_event *event)
+{
+	put_event(event, NULL);
+	return 0;
 }
+EXPORT_SYMBOL_GPL(perf_event_release_kernel);
 
 static int perf_release(struct inode *inode, struct file *file)
 {
-	put_event(file->private_data);
+	put_event(file->private_data, NULL);
 	return 0;
 }
 
@@ -3969,6 +3982,11 @@ static void perf_mmap_close(struct vm_area_struct *vma)
 			 */
 			continue;
 		}
+
+		trace_printk("inc ref: %ld; ptr=0x%p\n",
+				atomic_long_read(&event->refcount),
+				event);
+
 		rcu_read_unlock();
 
 		mutex_lock(&event->mmap_mutex);
@@ -3988,7 +4006,7 @@ static void perf_mmap_close(struct vm_area_struct *vma)
 			ring_buffer_put(rb); /* can't be last, we still have one */
 		}
 		mutex_unlock(&event->mmap_mutex);
-		put_event(event);
+		put_event(event, NULL);
 
 		/*
 		 * Restart the iteration; either we're on the wrong list or
@@ -7374,7 +7392,7 @@ static void sync_child_event(struct perf_event *child_event,
 	 * Release the parent event, if this was the last
 	 * reference to it.
 	 */
-	put_event(parent_event);
+	put_event(parent_event, child_event);
 }
 
 static void
@@ -7382,11 +7400,9 @@ __perf_event_exit_task(struct perf_event *child_event,
 			 struct perf_event_context *child_ctx,
 			 struct task_struct *child)
 {
-	if (child_event->parent) {
-		raw_spin_lock_irq(&child_ctx->lock);
-		perf_group_detach(child_event);
-		raw_spin_unlock_irq(&child_ctx->lock);
-	}
+	raw_spin_lock_irq(&child_ctx->lock);
+	perf_group_detach(child_event);
+	raw_spin_unlock_irq(&child_ctx->lock);
 
 	perf_remove_from_context(child_event);
 
@@ -7458,12 +7474,7 @@ static void perf_event_exit_task_context(struct task_struct *child, int ctxn)
 	mutex_lock(&child_ctx->mutex);
 
 again:
-	list_for_each_entry_safe(child_event, tmp, &child_ctx->pinned_groups,
-				 group_entry)
-		__perf_event_exit_task(child_event, child_ctx, child);
-
-	list_for_each_entry_safe(child_event, tmp, &child_ctx->flexible_groups,
-				 group_entry)
+	list_for_each_entry_rcu(child_event, &child_ctx->event_list, event_entry)
 		__perf_event_exit_task(child_event, child_ctx, child);
 
 	/*
@@ -7472,8 +7483,10 @@ static void perf_event_exit_task_context(struct task_struct *child, int ctxn)
 	 * will still point to the list head terminating the iteration.
 	 */
 	if (!list_empty(&child_ctx->pinned_groups) ||
-	    !list_empty(&child_ctx->flexible_groups))
+	    !list_empty(&child_ctx->flexible_groups)) {
+		WARN_ON_ONCE(1);
 		goto again;
+	}
 
 	mutex_unlock(&child_ctx->mutex);
 
@@ -7519,7 +7532,7 @@ static void perf_free_event(struct perf_event *event,
 	list_del_init(&event->child_list);
 	mutex_unlock(&parent->child_mutex);
 
-	put_event(parent);
+	put_event(parent, event);
 
 	perf_group_detach(event);
 	list_del_event(event, ctx);
@@ -7605,6 +7618,11 @@ inherit_event(struct perf_event *parent_event,
 		return NULL;
 	}
 
+	trace_printk("inherit inc ref: %ld; ptr=0x%p other=0x%p\n",
+			atomic_long_read(&parent_event->refcount),
+			parent_event,
+			child_event);
+
 	get_ctx(child_ctx);
 
 	/*
