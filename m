Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754482AbaESMuP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 08:50:15 -0400
Received: from terminus.zytor.com ([198.137.202.10]:58984 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754457AbaESMuL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 08:50:11 -0400
Date: Mon, 19 May 2014 05:48:54 -0700
From: tip-bot for Peter Zijlstra <tipbot@zytor.com>
Message-ID: <tip-b69cf53640da2b86439596118cfa95233154ee76@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, mingo@redhat.com, eranian@google.com,
        paulus@samba.org, hpa@zytor.com, mingo@kernel.org, efault@gmx.de,
        peterz@infradead.org, alexander.shishkin@linux.intel.com,
        paulmck@linux.vnet.ibm.com, fweisbec@gmail.com, ak@linux.intel.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        eranian@google.com, mingo@redhat.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, efault@gmx.de,
        alexander.shishkin@linux.intel.com, paulmck@linux.vnet.ibm.com,
        fweisbec@gmail.com, ak@linux.intel.com, tglx@linutronix.de
In-Reply-To: <20140507123526.GD13658@twins.programming.kicks-ass.net>
References: <20140507123526.GD13658@twins.programming.kicks-ass.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf: Fix a race between ring_buffer_detach()
  and ring_buffer_attach()
Git-Commit-ID: b69cf53640da2b86439596118cfa95233154ee76
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

Commit-ID:  b69cf53640da2b86439596118cfa95233154ee76
Gitweb:     http://git.kernel.org/tip/b69cf53640da2b86439596118cfa95233154ee76
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Fri, 14 Mar 2014 10:50:33 +0100
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Mon, 19 May 2014 21:44:56 +0900

perf: Fix a race between ring_buffer_detach() and ring_buffer_attach()

Alexander noticed that we use RCU iteration on rb->event_list but do
not use list_{add,del}_rcu() to add,remove entries to that list, nor
do we observe proper grace periods when re-using the entries.

Merge ring_buffer_detach() into ring_buffer_attach() such that
attaching to the NULL buffer is detaching.

Furthermore, ensure that between any 'detach' and 'attach' of the same
event we observe the required grace period, but only when strictly
required. In effect this means that only ioctl(.request =
PERF_EVENT_IOC_SET_OUTPUT) will wait for a grace period, while the
normal initial attach and final detach will not be delayed.

This patch should, I think, do the right thing under all
circumstances, the 'normal' cases all should never see the extra grace
period, but the two cases:

 1) PERF_EVENT_IOC_SET_OUTPUT on an event which already has a
    ring_buffer set, will now observe the required grace period between
    removing itself from the old and attaching itself to the new buffer.

    This case is 'simple' in that both buffers are present in
    perf_event_set_output() one could think an unconditional
    synchronize_rcu() would be sufficient; however...

 2) an event that has a buffer attached, the buffer is destroyed
    (munmap) and then the event is attached to a new/different buffer
    using PERF_EVENT_IOC_SET_OUTPUT.

    This case is more complex because the buffer destruction does:
      ring_buffer_attach(.rb = NULL)
    followed by the ioctl() doing:
      ring_buffer_attach(.rb = foo);

    and we still need to observe the grace period between these two
    calls due to us reusing the event->rb_entry list_head.

In order to make 2 happen we use Paul's latest cond_synchronize_rcu()
call.

Cc: Paul Mackerras <paulus@samba.org>
Cc: Stephane Eranian <eranian@google.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Reported-by: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/20140507123526.GD13658@twins.programming.kicks-ass.net
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 include/linux/perf_event.h |   2 +
 kernel/events/core.c       | 109 ++++++++++++++++++++-------------------------
 2 files changed, 51 insertions(+), 60 deletions(-)

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
index feb1329..440eefc 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -3192,7 +3192,8 @@ static void free_event_rcu(struct rcu_head *head)
 }
 
 static void ring_buffer_put(struct ring_buffer *rb);
-static void ring_buffer_detach(struct perf_event *event, struct ring_buffer *rb);
+static void ring_buffer_attach(struct perf_event *event,
+			       struct ring_buffer *rb);
 
 static void unaccount_event_cpu(struct perf_event *event, int cpu)
 {
@@ -3252,8 +3253,6 @@ static void free_event(struct perf_event *event)
 	unaccount_event(event);
 
 	if (event->rb) {
-		struct ring_buffer *rb;
-
 		/*
 		 * Can happen when we close an event with re-directed output.
 		 *
@@ -3261,12 +3260,7 @@ static void free_event(struct perf_event *event)
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
 
@@ -3850,28 +3844,47 @@ unlock:
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
 
-	spin_lock_irqsave(&rb->event_lock, flags);
-	list_del_init(&event->rb_entry);
-	wake_up_all(&event->waitq);
-	spin_unlock_irqrestore(&rb->event_lock, flags);
+	if (rb) {
+		spin_lock_irqsave(&rb->event_lock, flags);
+		list_add_rcu(&event->rb_entry, &rb->event_list);
+		spin_unlock_irqrestore(&rb->event_lock, flags);
+	}
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
 }
 
 static void ring_buffer_wakeup(struct perf_event *event)
@@ -3940,7 +3953,7 @@ static void perf_mmap_close(struct vm_area_struct *vma)
 {
 	struct perf_event *event = vma->vm_file->private_data;
 
-	struct ring_buffer *rb = event->rb;
+	struct ring_buffer *rb = ring_buffer_get(event);
 	struct user_struct *mmap_user = rb->mmap_user;
 	int mmap_locked = rb->mmap_locked;
 	unsigned long size = perf_data_size(rb);
@@ -3948,18 +3961,14 @@ static void perf_mmap_close(struct vm_area_struct *vma)
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
@@ -3989,11 +3998,9 @@ again:
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
 
@@ -4018,6 +4025,7 @@ again:
 	vma->vm_mm->pinned_vm -= mmap_locked;
 	free_uid(mmap_user);
 
+out_put:
 	ring_buffer_put(rb); /* could be last */
 }
 
@@ -4135,7 +4143,6 @@ again:
 	vma->vm_mm->pinned_vm += extra;
 
 	ring_buffer_attach(event, rb);
-	rcu_assign_pointer(event->rb, rb);
 
 	perf_event_init_userpage(event);
 	perf_event_update_userpage(event);
@@ -6934,7 +6941,7 @@ err_size:
 static int
 perf_event_set_output(struct perf_event *event, struct perf_event *output_event)
 {
-	struct ring_buffer *rb = NULL, *old_rb = NULL;
+	struct ring_buffer *rb = NULL;
 	int ret = -EINVAL;
 
 	if (!output_event)
@@ -6962,8 +6969,6 @@ set:
 	if (atomic_read(&event->mmap_count))
 		goto unlock;
 
-	old_rb = event->rb;
-
 	if (output_event) {
 		/* get the rb we want to redirect to */
 		rb = ring_buffer_get(output_event);
@@ -6971,23 +6976,7 @@ set:
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
