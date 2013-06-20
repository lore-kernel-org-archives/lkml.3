Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755987Ab3FTI6e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 04:58:34 -0400
Received: from mail-ee0-f47.google.com ([74.125.83.47]:50000 "EHLO
	mail-ee0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752359Ab3FTI63 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 04:58:29 -0400
Date: Thu, 20 Jun 2013 10:58:24 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] perf fixes
Message-ID: <20130620085824.GA6346@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest perf-urgent-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git perf-urgent-for-linus

   HEAD: f1a527899ef0a8a241eb3bea619eb2e29d797f44 perf/x86: Fix broken PEBS-LL support on SNB-EP/IVB-EP

Four fixes. The mmap ones are unfortunately larger than desired - fuzzing 
uncovered bugs that needed perf context life time management changes to 
fix properly.

Thanks,

	Ingo

------------------>
Masami Hiramatsu (1):
      kprobes: Fix to free gone and unused optprobes

Peter Zijlstra (2):
      perf: Fix perf mmap bugs
      perf: Fix mmap() accounting hole

Stephane Eranian (1):
      perf/x86: Fix broken PEBS-LL support on SNB-EP/IVB-EP


 arch/x86/kernel/cpu/perf_event_intel.c |   2 +-
 include/linux/perf_event.h             |   3 +-
 kernel/events/core.c                   | 233 +++++++++++++++++++++++----------
 kernel/events/internal.h               |   4 +
 kernel/kprobes.c                       |  30 +++--
 5 files changed, 187 insertions(+), 85 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index f60d41f..a9e2207 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -165,13 +165,13 @@ static struct extra_reg intel_snb_extra_regs[] __read_mostly = {
 	INTEL_EVENT_EXTRA_REG(0xb7, MSR_OFFCORE_RSP_0, 0x3f807f8fffull, RSP_0),
 	INTEL_EVENT_EXTRA_REG(0xbb, MSR_OFFCORE_RSP_1, 0x3f807f8fffull, RSP_1),
 	INTEL_UEVENT_PEBS_LDLAT_EXTRA_REG(0x01cd),
-	INTEL_UEVENT_PEBS_LDLAT_EXTRA_REG(0x01cd),
 	EVENT_EXTRA_END
 };
 
 static struct extra_reg intel_snbep_extra_regs[] __read_mostly = {
 	INTEL_EVENT_EXTRA_REG(0xb7, MSR_OFFCORE_RSP_0, 0x3fffff8fffull, RSP_0),
 	INTEL_EVENT_EXTRA_REG(0xbb, MSR_OFFCORE_RSP_1, 0x3fffff8fffull, RSP_1),
+	INTEL_UEVENT_PEBS_LDLAT_EXTRA_REG(0x01cd),
 	EVENT_EXTRA_END
 };
 
diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index f463a46..c5b6dbf 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -389,8 +389,7 @@ struct perf_event {
 	/* mmap bits */
 	struct mutex			mmap_mutex;
 	atomic_t			mmap_count;
-	int				mmap_locked;
-	struct user_struct		*mmap_user;
+
 	struct ring_buffer		*rb;
 	struct list_head		rb_entry;
 
diff --git a/kernel/events/core.c b/kernel/events/core.c
index 9dc297f..b391907 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -196,9 +196,6 @@ static void cpu_ctx_sched_in(struct perf_cpu_context *cpuctx,
 static void update_context_time(struct perf_event_context *ctx);
 static u64 perf_event_time(struct perf_event *event);
 
-static void ring_buffer_attach(struct perf_event *event,
-			       struct ring_buffer *rb);
-
 void __weak perf_event_print_debug(void)	{ }
 
 extern __weak const char *perf_pmu_name(void)
@@ -2918,6 +2915,7 @@ static void free_event_rcu(struct rcu_head *head)
 }
 
 static void ring_buffer_put(struct ring_buffer *rb);
+static void ring_buffer_detach(struct perf_event *event, struct ring_buffer *rb);
 
 static void free_event(struct perf_event *event)
 {
@@ -2942,15 +2940,30 @@ static void free_event(struct perf_event *event)
 		if (has_branch_stack(event)) {
 			static_key_slow_dec_deferred(&perf_sched_events);
 			/* is system-wide event */
-			if (!(event->attach_state & PERF_ATTACH_TASK))
+			if (!(event->attach_state & PERF_ATTACH_TASK)) {
 				atomic_dec(&per_cpu(perf_branch_stack_events,
 						    event->cpu));
+			}
 		}
 	}
 
 	if (event->rb) {
-		ring_buffer_put(event->rb);
-		event->rb = NULL;
+		struct ring_buffer *rb;
+
+		/*
+		 * Can happen when we close an event with re-directed output.
+		 *
+		 * Since we have a 0 refcount, perf_mmap_close() will skip
+		 * over us; possibly making our ring_buffer_put() the last.
+		 */
+		mutex_lock(&event->mmap_mutex);
+		rb = event->rb;
+		if (rb) {
+			rcu_assign_pointer(event->rb, NULL);
+			ring_buffer_detach(event, rb);
+			ring_buffer_put(rb); /* could be last */
+		}
+		mutex_unlock(&event->mmap_mutex);
 	}
 
 	if (is_cgroup_event(event))
@@ -3188,30 +3201,13 @@ static unsigned int perf_poll(struct file *file, poll_table *wait)
 	unsigned int events = POLL_HUP;
 
 	/*
-	 * Race between perf_event_set_output() and perf_poll(): perf_poll()
-	 * grabs the rb reference but perf_event_set_output() overrides it.
-	 * Here is the timeline for two threads T1, T2:
-	 * t0: T1, rb = rcu_dereference(event->rb)
-	 * t1: T2, old_rb = event->rb
-	 * t2: T2, event->rb = new rb
-	 * t3: T2, ring_buffer_detach(old_rb)
-	 * t4: T1, ring_buffer_attach(rb1)
-	 * t5: T1, poll_wait(event->waitq)
-	 *
-	 * To avoid this problem, we grab mmap_mutex in perf_poll()
-	 * thereby ensuring that the assignment of the new ring buffer
-	 * and the detachment of the old buffer appear atomic to perf_poll()
+	 * Pin the event->rb by taking event->mmap_mutex; otherwise
+	 * perf_event_set_output() can swizzle our rb and make us miss wakeups.
 	 */
 	mutex_lock(&event->mmap_mutex);
-
-	rcu_read_lock();
-	rb = rcu_dereference(event->rb);
-	if (rb) {
-		ring_buffer_attach(event, rb);
+	rb = event->rb;
+	if (rb)
 		events = atomic_xchg(&rb->poll, 0);
-	}
-	rcu_read_unlock();
-
 	mutex_unlock(&event->mmap_mutex);
 
 	poll_wait(file, &event->waitq, wait);
@@ -3521,16 +3517,12 @@ static void ring_buffer_attach(struct perf_event *event,
 		return;
 
 	spin_lock_irqsave(&rb->event_lock, flags);
-	if (!list_empty(&event->rb_entry))
-		goto unlock;
-
-	list_add(&event->rb_entry, &rb->event_list);
-unlock:
+	if (list_empty(&event->rb_entry))
+		list_add(&event->rb_entry, &rb->event_list);
 	spin_unlock_irqrestore(&rb->event_lock, flags);
 }
 
-static void ring_buffer_detach(struct perf_event *event,
-			       struct ring_buffer *rb)
+static void ring_buffer_detach(struct perf_event *event, struct ring_buffer *rb)
 {
 	unsigned long flags;
 
@@ -3549,13 +3541,10 @@ static void ring_buffer_wakeup(struct perf_event *event)
 
 	rcu_read_lock();
 	rb = rcu_dereference(event->rb);
-	if (!rb)
-		goto unlock;
-
-	list_for_each_entry_rcu(event, &rb->event_list, rb_entry)
-		wake_up_all(&event->waitq);
-
-unlock:
+	if (rb) {
+		list_for_each_entry_rcu(event, &rb->event_list, rb_entry)
+			wake_up_all(&event->waitq);
+	}
 	rcu_read_unlock();
 }
 
@@ -3584,18 +3573,10 @@ static struct ring_buffer *ring_buffer_get(struct perf_event *event)
 
 static void ring_buffer_put(struct ring_buffer *rb)
 {
-	struct perf_event *event, *n;
-	unsigned long flags;
-
 	if (!atomic_dec_and_test(&rb->refcount))
 		return;
 
-	spin_lock_irqsave(&rb->event_lock, flags);
-	list_for_each_entry_safe(event, n, &rb->event_list, rb_entry) {
-		list_del_init(&event->rb_entry);
-		wake_up_all(&event->waitq);
-	}
-	spin_unlock_irqrestore(&rb->event_lock, flags);
+	WARN_ON_ONCE(!list_empty(&rb->event_list));
 
 	call_rcu(&rb->rcu_head, rb_free_rcu);
 }
@@ -3605,26 +3586,100 @@ static void perf_mmap_open(struct vm_area_struct *vma)
 	struct perf_event *event = vma->vm_file->private_data;
 
 	atomic_inc(&event->mmap_count);
+	atomic_inc(&event->rb->mmap_count);
 }
 
+/*
+ * A buffer can be mmap()ed multiple times; either directly through the same
+ * event, or through other events by use of perf_event_set_output().
+ *
+ * In order to undo the VM accounting done by perf_mmap() we need to destroy
+ * the buffer here, where we still have a VM context. This means we need
+ * to detach all events redirecting to us.
+ */
 static void perf_mmap_close(struct vm_area_struct *vma)
 {
 	struct perf_event *event = vma->vm_file->private_data;
 
-	if (atomic_dec_and_mutex_lock(&event->mmap_count, &event->mmap_mutex)) {
-		unsigned long size = perf_data_size(event->rb);
-		struct user_struct *user = event->mmap_user;
-		struct ring_buffer *rb = event->rb;
+	struct ring_buffer *rb = event->rb;
+	struct user_struct *mmap_user = rb->mmap_user;
+	int mmap_locked = rb->mmap_locked;
+	unsigned long size = perf_data_size(rb);
+
+	atomic_dec(&rb->mmap_count);
+
+	if (!atomic_dec_and_mutex_lock(&event->mmap_count, &event->mmap_mutex))
+		return;
 
-		atomic_long_sub((size >> PAGE_SHIFT) + 1, &user->locked_vm);
-		vma->vm_mm->pinned_vm -= event->mmap_locked;
-		rcu_assign_pointer(event->rb, NULL);
-		ring_buffer_detach(event, rb);
+	/* Detach current event from the buffer. */
+	rcu_assign_pointer(event->rb, NULL);
+	ring_buffer_detach(event, rb);
+	mutex_unlock(&event->mmap_mutex);
+
+	/* If there's still other mmap()s of this buffer, we're done. */
+	if (atomic_read(&rb->mmap_count)) {
+		ring_buffer_put(rb); /* can't be last */
+		return;
+	}
+
+	/*
+	 * No other mmap()s, detach from all other events that might redirect
+	 * into the now unreachable buffer. Somewhat complicated by the
+	 * fact that rb::event_lock otherwise nests inside mmap_mutex.
+	 */
+again:
+	rcu_read_lock();
+	list_for_each_entry_rcu(event, &rb->event_list, rb_entry) {
+		if (!atomic_long_inc_not_zero(&event->refcount)) {
+			/*
+			 * This event is en-route to free_event() which will
+			 * detach it and remove it from the list.
+			 */
+			continue;
+		}
+		rcu_read_unlock();
+
+		mutex_lock(&event->mmap_mutex);
+		/*
+		 * Check we didn't race with perf_event_set_output() which can
+		 * swizzle the rb from under us while we were waiting to
+		 * acquire mmap_mutex.
+		 *
+		 * If we find a different rb; ignore this event, a next
+		 * iteration will no longer find it on the list. We have to
+		 * still restart the iteration to make sure we're not now
+		 * iterating the wrong list.
+		 */
+		if (event->rb == rb) {
+			rcu_assign_pointer(event->rb, NULL);
+			ring_buffer_detach(event, rb);
+			ring_buffer_put(rb); /* can't be last, we still have one */
+		}
 		mutex_unlock(&event->mmap_mutex);
+		put_event(event);
 
-		ring_buffer_put(rb);
-		free_uid(user);
+		/*
+		 * Restart the iteration; either we're on the wrong list or
+		 * destroyed its integrity by doing a deletion.
+		 */
+		goto again;
 	}
+	rcu_read_unlock();
+
+	/*
+	 * It could be there's still a few 0-ref events on the list; they'll
+	 * get cleaned up by free_event() -- they'll also still have their
+	 * ref on the rb and will free it whenever they are done with it.
+	 *
+	 * Aside from that, this buffer is 'fully' detached and unmapped,
+	 * undo the VM accounting.
+	 */
+
+	atomic_long_sub((size >> PAGE_SHIFT) + 1, &mmap_user->locked_vm);
+	vma->vm_mm->pinned_vm -= mmap_locked;
+	free_uid(mmap_user);
+
+	ring_buffer_put(rb); /* could be last */
 }
 
 static const struct vm_operations_struct perf_mmap_vmops = {
@@ -3674,12 +3729,24 @@ static int perf_mmap(struct file *file, struct vm_area_struct *vma)
 		return -EINVAL;
 
 	WARN_ON_ONCE(event->ctx->parent_ctx);
+again:
 	mutex_lock(&event->mmap_mutex);
 	if (event->rb) {
-		if (event->rb->nr_pages == nr_pages)
-			atomic_inc(&event->rb->refcount);
-		else
+		if (event->rb->nr_pages != nr_pages) {
 			ret = -EINVAL;
+			goto unlock;
+		}
+
+		if (!atomic_inc_not_zero(&event->rb->mmap_count)) {
+			/*
+			 * Raced against perf_mmap_close() through
+			 * perf_event_set_output(). Try again, hope for better
+			 * luck.
+			 */
+			mutex_unlock(&event->mmap_mutex);
+			goto again;
+		}
+
 		goto unlock;
 	}
 
@@ -3720,12 +3787,16 @@ static int perf_mmap(struct file *file, struct vm_area_struct *vma)
 		ret = -ENOMEM;
 		goto unlock;
 	}
-	rcu_assign_pointer(event->rb, rb);
+
+	atomic_set(&rb->mmap_count, 1);
+	rb->mmap_locked = extra;
+	rb->mmap_user = get_current_user();
 
 	atomic_long_add(user_extra, &user->locked_vm);
-	event->mmap_locked = extra;
-	event->mmap_user = get_current_user();
-	vma->vm_mm->pinned_vm += event->mmap_locked;
+	vma->vm_mm->pinned_vm += extra;
+
+	ring_buffer_attach(event, rb);
+	rcu_assign_pointer(event->rb, rb);
 
 	perf_event_update_userpage(event);
 
@@ -3734,7 +3805,11 @@ unlock:
 		atomic_inc(&event->mmap_count);
 	mutex_unlock(&event->mmap_mutex);
 
-	vma->vm_flags |= VM_DONTEXPAND | VM_DONTDUMP;
+	/*
+	 * Since pinned accounting is per vm we cannot allow fork() to copy our
+	 * vma.
+	 */
+	vma->vm_flags |= VM_DONTCOPY | VM_DONTEXPAND | VM_DONTDUMP;
 	vma->vm_ops = &perf_mmap_vmops;
 
 	return ret;
@@ -6412,6 +6487,8 @@ set:
 	if (atomic_read(&event->mmap_count))
 		goto unlock;
 
+	old_rb = event->rb;
+
 	if (output_event) {
 		/* get the rb we want to redirect to */
 		rb = ring_buffer_get(output_event);
@@ -6419,16 +6496,28 @@ set:
 			goto unlock;
 	}
 
-	old_rb = event->rb;
-	rcu_assign_pointer(event->rb, rb);
 	if (old_rb)
 		ring_buffer_detach(event, old_rb);
+
+	if (rb)
+		ring_buffer_attach(event, rb);
+
+	rcu_assign_pointer(event->rb, rb);
+
+	if (old_rb) {
+		ring_buffer_put(old_rb);
+		/*
+		 * Since we detached before setting the new rb, so that we
+		 * could attach the new rb, we could have missed a wakeup.
+		 * Provide it now.
+		 */
+		wake_up_all(&event->waitq);
+	}
+
 	ret = 0;
 unlock:
 	mutex_unlock(&event->mmap_mutex);
 
-	if (old_rb)
-		ring_buffer_put(old_rb);
 out:
 	return ret;
 }
diff --git a/kernel/events/internal.h b/kernel/events/internal.h
index eb675c4..ca65997 100644
--- a/kernel/events/internal.h
+++ b/kernel/events/internal.h
@@ -31,6 +31,10 @@ struct ring_buffer {
 	spinlock_t			event_lock;
 	struct list_head		event_list;
 
+	atomic_t			mmap_count;
+	unsigned long			mmap_locked;
+	struct user_struct		*mmap_user;
+
 	struct perf_event_mmap_page	*user_page;
 	void				*data_pages[0];
 };
diff --git a/kernel/kprobes.c b/kernel/kprobes.c
index 3fed7f0..bddf3b2 100644
--- a/kernel/kprobes.c
+++ b/kernel/kprobes.c
@@ -467,6 +467,7 @@ static struct kprobe *__kprobes get_optimized_kprobe(unsigned long addr)
 /* Optimization staging list, protected by kprobe_mutex */
 static LIST_HEAD(optimizing_list);
 static LIST_HEAD(unoptimizing_list);
+static LIST_HEAD(freeing_list);
 
 static void kprobe_optimizer(struct work_struct *work);
 static DECLARE_DELAYED_WORK(optimizing_work, kprobe_optimizer);
@@ -504,7 +505,7 @@ static __kprobes void do_optimize_kprobes(void)
  * Unoptimize (replace a jump with a breakpoint and remove the breakpoint
  * if need) kprobes listed on unoptimizing_list.
  */
-static __kprobes void do_unoptimize_kprobes(struct list_head *free_list)
+static __kprobes void do_unoptimize_kprobes(void)
 {
 	struct optimized_kprobe *op, *tmp;
 
@@ -515,9 +516,9 @@ static __kprobes void do_unoptimize_kprobes(struct list_head *free_list)
 	/* Ditto to do_optimize_kprobes */
 	get_online_cpus();
 	mutex_lock(&text_mutex);
-	arch_unoptimize_kprobes(&unoptimizing_list, free_list);
+	arch_unoptimize_kprobes(&unoptimizing_list, &freeing_list);
 	/* Loop free_list for disarming */
-	list_for_each_entry_safe(op, tmp, free_list, list) {
+	list_for_each_entry_safe(op, tmp, &freeing_list, list) {
 		/* Disarm probes if marked disabled */
 		if (kprobe_disabled(&op->kp))
 			arch_disarm_kprobe(&op->kp);
@@ -536,11 +537,11 @@ static __kprobes void do_unoptimize_kprobes(struct list_head *free_list)
 }
 
 /* Reclaim all kprobes on the free_list */
-static __kprobes void do_free_cleaned_kprobes(struct list_head *free_list)
+static __kprobes void do_free_cleaned_kprobes(void)
 {
 	struct optimized_kprobe *op, *tmp;
 
-	list_for_each_entry_safe(op, tmp, free_list, list) {
+	list_for_each_entry_safe(op, tmp, &freeing_list, list) {
 		BUG_ON(!kprobe_unused(&op->kp));
 		list_del_init(&op->list);
 		free_aggr_kprobe(&op->kp);
@@ -556,8 +557,6 @@ static __kprobes void kick_kprobe_optimizer(void)
 /* Kprobe jump optimizer */
 static __kprobes void kprobe_optimizer(struct work_struct *work)
 {
-	LIST_HEAD(free_list);
-
 	mutex_lock(&kprobe_mutex);
 	/* Lock modules while optimizing kprobes */
 	mutex_lock(&module_mutex);
@@ -566,7 +565,7 @@ static __kprobes void kprobe_optimizer(struct work_struct *work)
 	 * Step 1: Unoptimize kprobes and collect cleaned (unused and disarmed)
 	 * kprobes before waiting for quiesence period.
 	 */
-	do_unoptimize_kprobes(&free_list);
+	do_unoptimize_kprobes();
 
 	/*
 	 * Step 2: Wait for quiesence period to ensure all running interrupts
@@ -581,7 +580,7 @@ static __kprobes void kprobe_optimizer(struct work_struct *work)
 	do_optimize_kprobes();
 
 	/* Step 4: Free cleaned kprobes after quiesence period */
-	do_free_cleaned_kprobes(&free_list);
+	do_free_cleaned_kprobes();
 
 	mutex_unlock(&module_mutex);
 	mutex_unlock(&kprobe_mutex);
@@ -723,8 +722,19 @@ static void __kprobes kill_optimized_kprobe(struct kprobe *p)
 	if (!list_empty(&op->list))
 		/* Dequeue from the (un)optimization queue */
 		list_del_init(&op->list);
-
 	op->kp.flags &= ~KPROBE_FLAG_OPTIMIZED;
+
+	if (kprobe_unused(p)) {
+		/* Enqueue if it is unused */
+		list_add(&op->list, &freeing_list);
+		/*
+		 * Remove unused probes from the hash list. After waiting
+		 * for synchronization, this probe is reclaimed.
+		 * (reclaiming is done by do_free_cleaned_kprobes().)
+		 */
+		hlist_del_rcu(&op->kp.hlist);
+	}
+
 	/* Don't touch the code, because it is already freed. */
 	arch_remove_optimized_kprobe(op);
 }
