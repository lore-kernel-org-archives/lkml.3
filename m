Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752388AbaEVIEd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 04:04:33 -0400
Received: from mail-ee0-f51.google.com ([74.125.83.51]:53103 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751187AbaEVIE2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 04:04:28 -0400
Date: Thu, 22 May 2014 10:04:20 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Jiri Olsa <jolsa@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] perf fixes
Message-ID: <20140522080420.GA20131@gmail.com>
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

   # HEAD: b69cf53640da2b86439596118cfa95233154ee76 perf: Fix a race between ring_buffer_detach() and ring_buffer_attach()

The biggest changes are fixes for races that kept triggering Trinity 
crashes, plus liblockdep build fixes and smaller misc fixes.

... liblockdep bits in perf/urgent are a pull mistake - they should 
have been in locking/urgent - but by the time I noticed other commits 
were added and testing was done :-/ Sorry about that.

 Thanks,

	Ingo

------------------>
Jiri Olsa (1):
      perf: Prevent false warning in perf_swevent_add

Peter Zijlstra (4):
      perf: Fix race in removing an event
      perf: Fix perf_event_init_context()
      perf: Limit perf_event_attr::sample_period to 63 bits
      perf: Fix a race between ring_buffer_detach() and ring_buffer_attach()

S. Lockwood-Childs (1):
      tools/liblockdep: Build liblockdep from tools/Makefile

Sasha Levin (1):
      tools/liblockdep: Remove all build files when doing make clean

Yan, Zheng (1):
      perf/x86/intel: Fix Silvermont's event constraints


 arch/x86/kernel/cpu/perf_event_intel.c |   1 -
 include/linux/perf_event.h             |   2 +
 kernel/events/core.c                   | 174 +++++++++++++++++----------------
 tools/Makefile                         |   6 ++
 tools/lib/lockdep/Makefile             |   5 +-
 5 files changed, 102 insertions(+), 86 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index aa333d9..adb02aa 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -169,7 +169,6 @@ static struct event_constraint intel_slm_event_constraints[] __read_mostly =
 {
 	FIXED_EVENT_CONSTRAINT(0x00c0, 0), /* INST_RETIRED.ANY */
 	FIXED_EVENT_CONSTRAINT(0x003c, 1), /* CPU_CLK_UNHALTED.CORE */
-	FIXED_EVENT_CONSTRAINT(0x013c, 2), /* CPU_CLK_UNHALTED.REF */
 	FIXED_EVENT_CONSTRAINT(0x0300, 2), /* pseudo CPU_CLK_UNHALTED.REF */
 	EVENT_CONSTRAINT_END
 };
diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 3356abc..3ef6ea1 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -402,6 +402,8 @@ struct perf_event {
 
 	struct ring_buffer		*rb;
 	struct list_head		rb_entry;
+	unsigned long			rcu_batches;
+	int				rcu_pending;
 
 	/* poll related */
 	wait_queue_head_t		waitq;
diff --git a/kernel/events/core.c b/kernel/events/core.c
index f83a71a..440eefc 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -1443,6 +1443,11 @@ group_sched_out(struct perf_event *group_event,
 		cpuctx->exclusive = 0;
 }
 
+struct remove_event {
+	struct perf_event *event;
+	bool detach_group;
+};
+
 /*
  * Cross CPU call to remove a performance event
  *
@@ -1451,12 +1456,15 @@ group_sched_out(struct perf_event *group_event,
  */
 static int __perf_remove_from_context(void *info)
 {
-	struct perf_event *event = info;
+	struct remove_event *re = info;
+	struct perf_event *event = re->event;
 	struct perf_event_context *ctx = event->ctx;
 	struct perf_cpu_context *cpuctx = __get_cpu_context(ctx);
 
 	raw_spin_lock(&ctx->lock);
 	event_sched_out(event, cpuctx, ctx);
+	if (re->detach_group)
+		perf_group_detach(event);
 	list_del_event(event, ctx);
 	if (!ctx->nr_events && cpuctx->task_ctx == ctx) {
 		ctx->is_active = 0;
@@ -1481,10 +1489,14 @@ static int __perf_remove_from_context(void *info)
  * When called from perf_event_exit_task, it's OK because the
  * context has been detached from its task.
  */
-static void perf_remove_from_context(struct perf_event *event)
+static void perf_remove_from_context(struct perf_event *event, bool detach_group)
 {
 	struct perf_event_context *ctx = event->ctx;
 	struct task_struct *task = ctx->task;
+	struct remove_event re = {
+		.event = event,
+		.detach_group = detach_group,
+	};
 
 	lockdep_assert_held(&ctx->mutex);
 
@@ -1493,12 +1505,12 @@ static void perf_remove_from_context(struct perf_event *event)
 		 * Per cpu events are removed via an smp call and
 		 * the removal is always successful.
 		 */
-		cpu_function_call(event->cpu, __perf_remove_from_context, event);
+		cpu_function_call(event->cpu, __perf_remove_from_context, &re);
 		return;
 	}
 
 retry:
-	if (!task_function_call(task, __perf_remove_from_context, event))
+	if (!task_function_call(task, __perf_remove_from_context, &re))
 		return;
 
 	raw_spin_lock_irq(&ctx->lock);
@@ -1515,6 +1527,8 @@ retry:
 	 * Since the task isn't running, its safe to remove the event, us
 	 * holding the ctx->lock ensures the task won't get scheduled in.
 	 */
+	if (detach_group)
+		perf_group_detach(event);
 	list_del_event(event, ctx);
 	raw_spin_unlock_irq(&ctx->lock);
 }
@@ -3178,7 +3192,8 @@ static void free_event_rcu(struct rcu_head *head)
 }
 
 static void ring_buffer_put(struct ring_buffer *rb);
-static void ring_buffer_detach(struct perf_event *event, struct ring_buffer *rb);
+static void ring_buffer_attach(struct perf_event *event,
+			       struct ring_buffer *rb);
 
 static void unaccount_event_cpu(struct perf_event *event, int cpu)
 {
@@ -3238,8 +3253,6 @@ static void free_event(struct perf_event *event)
 	unaccount_event(event);
 
 	if (event->rb) {
-		struct ring_buffer *rb;
-
 		/*
 		 * Can happen when we close an event with re-directed output.
 		 *
@@ -3247,12 +3260,7 @@ static void free_event(struct perf_event *event)
 		 * over us; possibly making our ring_buffer_put() the last.
 		 */
 		mutex_lock(&event->mmap_mutex);
-		rb = event->rb;
-		if (rb) {
-			rcu_assign_pointer(event->rb, NULL);
-			ring_buffer_detach(event, rb);
-			ring_buffer_put(rb); /* could be last */
-		}
+		ring_buffer_attach(event, NULL);
 		mutex_unlock(&event->mmap_mutex);
 	}
 
@@ -3281,10 +3289,7 @@ int perf_event_release_kernel(struct perf_event *event)
 	 *     to trigger the AB-BA case.
 	 */
 	mutex_lock_nested(&ctx->mutex, SINGLE_DEPTH_NESTING);
-	raw_spin_lock_irq(&ctx->lock);
-	perf_group_detach(event);
-	raw_spin_unlock_irq(&ctx->lock);
-	perf_remove_from_context(event);
+	perf_remove_from_context(event, true);
 	mutex_unlock(&ctx->mutex);
 
 	free_event(event);
@@ -3839,28 +3844,47 @@ unlock:
 static void ring_buffer_attach(struct perf_event *event,
 			       struct ring_buffer *rb)
 {
+	struct ring_buffer *old_rb = NULL;
 	unsigned long flags;
 
-	if (!list_empty(&event->rb_entry))
-		return;
+	if (event->rb) {
+		/*
+		 * Should be impossible, we set this when removing
+		 * event->rb_entry and wait/clear when adding event->rb_entry.
+		 */
+		WARN_ON_ONCE(event->rcu_pending);
 
-	spin_lock_irqsave(&rb->event_lock, flags);
-	if (list_empty(&event->rb_entry))
-		list_add(&event->rb_entry, &rb->event_list);
-	spin_unlock_irqrestore(&rb->event_lock, flags);
-}
+		old_rb = event->rb;
+		event->rcu_batches = get_state_synchronize_rcu();
+		event->rcu_pending = 1;
 
-static void ring_buffer_detach(struct perf_event *event, struct ring_buffer *rb)
-{
-	unsigned long flags;
+		spin_lock_irqsave(&old_rb->event_lock, flags);
+		list_del_rcu(&event->rb_entry);
+		spin_unlock_irqrestore(&old_rb->event_lock, flags);
+	}
 
-	if (list_empty(&event->rb_entry))
-		return;
+	if (event->rcu_pending && rb) {
+		cond_synchronize_rcu(event->rcu_batches);
+		event->rcu_pending = 0;
+	}
+
+	if (rb) {
+		spin_lock_irqsave(&rb->event_lock, flags);
+		list_add_rcu(&event->rb_entry, &rb->event_list);
+		spin_unlock_irqrestore(&rb->event_lock, flags);
+	}
+
+	rcu_assign_pointer(event->rb, rb);
 
-	spin_lock_irqsave(&rb->event_lock, flags);
-	list_del_init(&event->rb_entry);
-	wake_up_all(&event->waitq);
-	spin_unlock_irqrestore(&rb->event_lock, flags);
+	if (old_rb) {
+		ring_buffer_put(old_rb);
+		/*
+		 * Since we detached before setting the new rb, so that we
+		 * could attach the new rb, we could have missed a wakeup.
+		 * Provide it now.
+		 */
+		wake_up_all(&event->waitq);
+	}
 }
 
 static void ring_buffer_wakeup(struct perf_event *event)
@@ -3929,7 +3953,7 @@ static void perf_mmap_close(struct vm_area_struct *vma)
 {
 	struct perf_event *event = vma->vm_file->private_data;
 
-	struct ring_buffer *rb = event->rb;
+	struct ring_buffer *rb = ring_buffer_get(event);
 	struct user_struct *mmap_user = rb->mmap_user;
 	int mmap_locked = rb->mmap_locked;
 	unsigned long size = perf_data_size(rb);
@@ -3937,18 +3961,14 @@ static void perf_mmap_close(struct vm_area_struct *vma)
 	atomic_dec(&rb->mmap_count);
 
 	if (!atomic_dec_and_mutex_lock(&event->mmap_count, &event->mmap_mutex))
-		return;
+		goto out_put;
 
-	/* Detach current event from the buffer. */
-	rcu_assign_pointer(event->rb, NULL);
-	ring_buffer_detach(event, rb);
+	ring_buffer_attach(event, NULL);
 	mutex_unlock(&event->mmap_mutex);
 
 	/* If there's still other mmap()s of this buffer, we're done. */
-	if (atomic_read(&rb->mmap_count)) {
-		ring_buffer_put(rb); /* can't be last */
-		return;
-	}
+	if (atomic_read(&rb->mmap_count))
+		goto out_put;
 
 	/*
 	 * No other mmap()s, detach from all other events that might redirect
@@ -3978,11 +3998,9 @@ again:
 		 * still restart the iteration to make sure we're not now
 		 * iterating the wrong list.
 		 */
-		if (event->rb == rb) {
-			rcu_assign_pointer(event->rb, NULL);
-			ring_buffer_detach(event, rb);
-			ring_buffer_put(rb); /* can't be last, we still have one */
-		}
+		if (event->rb == rb)
+			ring_buffer_attach(event, NULL);
+
 		mutex_unlock(&event->mmap_mutex);
 		put_event(event);
 
@@ -4007,6 +4025,7 @@ again:
 	vma->vm_mm->pinned_vm -= mmap_locked;
 	free_uid(mmap_user);
 
+out_put:
 	ring_buffer_put(rb); /* could be last */
 }
 
@@ -4124,7 +4143,6 @@ again:
 	vma->vm_mm->pinned_vm += extra;
 
 	ring_buffer_attach(event, rb);
-	rcu_assign_pointer(event->rb, rb);
 
 	perf_event_init_userpage(event);
 	perf_event_update_userpage(event);
@@ -5408,6 +5426,9 @@ struct swevent_htable {
 
 	/* Recursion avoidance in each contexts */
 	int				recursion[PERF_NR_CONTEXTS];
+
+	/* Keeps track of cpu being initialized/exited */
+	bool				online;
 };
 
 static DEFINE_PER_CPU(struct swevent_htable, swevent_htable);
@@ -5654,8 +5675,14 @@ static int perf_swevent_add(struct perf_event *event, int flags)
 	hwc->state = !(flags & PERF_EF_START);
 
 	head = find_swevent_head(swhash, event);
-	if (WARN_ON_ONCE(!head))
+	if (!head) {
+		/*
+		 * We can race with cpu hotplug code. Do not
+		 * WARN if the cpu just got unplugged.
+		 */
+		WARN_ON_ONCE(swhash->online);
 		return -EINVAL;
+	}
 
 	hlist_add_head_rcu(&event->hlist_entry, head);
 
@@ -6914,7 +6941,7 @@ err_size:
 static int
 perf_event_set_output(struct perf_event *event, struct perf_event *output_event)
 {
-	struct ring_buffer *rb = NULL, *old_rb = NULL;
+	struct ring_buffer *rb = NULL;
 	int ret = -EINVAL;
 
 	if (!output_event)
@@ -6942,8 +6969,6 @@ set:
 	if (atomic_read(&event->mmap_count))
 		goto unlock;
 
-	old_rb = event->rb;
-
 	if (output_event) {
 		/* get the rb we want to redirect to */
 		rb = ring_buffer_get(output_event);
@@ -6951,23 +6976,7 @@ set:
 			goto unlock;
 	}
 
-	if (old_rb)
-		ring_buffer_detach(event, old_rb);
-
-	if (rb)
-		ring_buffer_attach(event, rb);
-
-	rcu_assign_pointer(event->rb, rb);
-
-	if (old_rb) {
-		ring_buffer_put(old_rb);
-		/*
-		 * Since we detached before setting the new rb, so that we
-		 * could attach the new rb, we could have missed a wakeup.
-		 * Provide it now.
-		 */
-		wake_up_all(&event->waitq);
-	}
+	ring_buffer_attach(event, rb);
 
 	ret = 0;
 unlock:
@@ -7018,6 +7027,9 @@ SYSCALL_DEFINE5(perf_event_open,
 	if (attr.freq) {
 		if (attr.sample_freq > sysctl_perf_event_sample_rate)
 			return -EINVAL;
+	} else {
+		if (attr.sample_period & (1ULL << 63))
+			return -EINVAL;
 	}
 
 	/*
@@ -7165,7 +7177,7 @@ SYSCALL_DEFINE5(perf_event_open,
 		struct perf_event_context *gctx = group_leader->ctx;
 
 		mutex_lock(&gctx->mutex);
-		perf_remove_from_context(group_leader);
+		perf_remove_from_context(group_leader, false);
 
 		/*
 		 * Removing from the context ends up with disabled
@@ -7175,7 +7187,7 @@ SYSCALL_DEFINE5(perf_event_open,
 		perf_event__state_init(group_leader);
 		list_for_each_entry(sibling, &group_leader->sibling_list,
 				    group_entry) {
-			perf_remove_from_context(sibling);
+			perf_remove_from_context(sibling, false);
 			perf_event__state_init(sibling);
 			put_ctx(gctx);
 		}
@@ -7305,7 +7317,7 @@ void perf_pmu_migrate_context(struct pmu *pmu, int src_cpu, int dst_cpu)
 	mutex_lock(&src_ctx->mutex);
 	list_for_each_entry_safe(event, tmp, &src_ctx->event_list,
 				 event_entry) {
-		perf_remove_from_context(event);
+		perf_remove_from_context(event, false);
 		unaccount_event_cpu(event, src_cpu);
 		put_ctx(src_ctx);
 		list_add(&event->migrate_entry, &events);
@@ -7367,13 +7379,7 @@ __perf_event_exit_task(struct perf_event *child_event,
 			 struct perf_event_context *child_ctx,
 			 struct task_struct *child)
 {
-	if (child_event->parent) {
-		raw_spin_lock_irq(&child_ctx->lock);
-		perf_group_detach(child_event);
-		raw_spin_unlock_irq(&child_ctx->lock);
-	}
-
-	perf_remove_from_context(child_event);
+	perf_remove_from_context(child_event, !!child_event->parent);
 
 	/*
 	 * It can happen that the parent exits first, and has events
@@ -7724,6 +7730,8 @@ int perf_event_init_context(struct task_struct *child, int ctxn)
 	 * swapped under us.
 	 */
 	parent_ctx = perf_pin_task_context(parent, ctxn);
+	if (!parent_ctx)
+		return 0;
 
 	/*
 	 * No need to check if parent_ctx != NULL here; since we saw
@@ -7835,6 +7843,7 @@ static void perf_event_init_cpu(int cpu)
 	struct swevent_htable *swhash = &per_cpu(swevent_htable, cpu);
 
 	mutex_lock(&swhash->hlist_mutex);
+	swhash->online = true;
 	if (swhash->hlist_refcount > 0) {
 		struct swevent_hlist *hlist;
 
@@ -7857,14 +7866,14 @@ static void perf_pmu_rotate_stop(struct pmu *pmu)
 
 static void __perf_event_exit_context(void *__info)
 {
+	struct remove_event re = { .detach_group = false };
 	struct perf_event_context *ctx = __info;
-	struct perf_event *event;
 
 	perf_pmu_rotate_stop(ctx->pmu);
 
 	rcu_read_lock();
-	list_for_each_entry_rcu(event, &ctx->event_list, event_entry)
-		__perf_remove_from_context(event);
+	list_for_each_entry_rcu(re.event, &ctx->event_list, event_entry)
+		__perf_remove_from_context(&re);
 	rcu_read_unlock();
 }
 
@@ -7892,6 +7901,7 @@ static void perf_event_exit_cpu(int cpu)
 	perf_event_exit_cpu_context(cpu);
 
 	mutex_lock(&swhash->hlist_mutex);
+	swhash->online = false;
 	swevent_hlist_release(swhash);
 	mutex_unlock(&swhash->hlist_mutex);
 }
diff --git a/tools/Makefile b/tools/Makefile
index bcae806..9a617ad 100644
--- a/tools/Makefile
+++ b/tools/Makefile
@@ -44,6 +44,9 @@ cpupower: FORCE
 cgroup firewire hv guest usb virtio vm net: FORCE
 	$(call descend,$@)
 
+liblockdep: FORCE
+	$(call descend,lib/lockdep)
+
 libapikfs: FORCE
 	$(call descend,lib/api)
 
@@ -91,6 +94,9 @@ cpupower_clean:
 cgroup_clean hv_clean firewire_clean lguest_clean usb_clean virtio_clean vm_clean net_clean:
 	$(call descend,$(@:_clean=),clean)
 
+liblockdep_clean:
+	$(call descend,lib/lockdep,clean)
+
 libapikfs_clean:
 	$(call descend,lib/api,clean)
 
diff --git a/tools/lib/lockdep/Makefile b/tools/lib/lockdep/Makefile
index cb09d3f..bba2f52 100644
--- a/tools/lib/lockdep/Makefile
+++ b/tools/lib/lockdep/Makefile
@@ -1,8 +1,7 @@
 # file format version
 FILE_VERSION = 1
 
-MAKEFLAGS += --no-print-directory
-LIBLOCKDEP_VERSION=$(shell make -sC ../../.. kernelversion)
+LIBLOCKDEP_VERSION=$(shell make --no-print-directory -sC ../../.. kernelversion)
 
 # Makefiles suck: This macro sets a default value of $(2) for the
 # variable named by $(1), unless the variable has been set by
@@ -231,7 +230,7 @@ install_lib: all_cmd
 install: install_lib
 
 clean:
-	$(RM) *.o *~ $(TARGETS) *.a *.so $(VERSION_FILES) .*.d
+	$(RM) *.o *~ $(TARGETS) *.a *liblockdep*.so* $(VERSION_FILES) .*.d
 	$(RM) tags TAGS
 
 endif # skip-makefile
