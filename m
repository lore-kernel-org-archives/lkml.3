Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755569Ab3FKQsA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 12:48:00 -0400
Received: from mail-bk0-f54.google.com ([209.85.214.54]:39013 "EHLO
	mail-bk0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752182Ab3FKQmy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 12:42:54 -0400
From: Robert Richter <rric@kernel.org>
To: Borislav Petkov <bp@alien8.de>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Jiri Olsa <jolsa@redhat.com>, linux-kernel@vger.kernel.org,
        Borislav Petkov <bp@suse.de>, Robert Richter <rric@kernel.org>
Subject: [PATCH v2 01/14] perf, ring_buffer: Use same prefix
Date: Tue, 11 Jun 2013 18:42:27 +0200
Message-Id: <1370968960-22527-2-git-send-email-rric@kernel.org>
X-Mailer: git-send-email 1.8.1.1
In-Reply-To: <1370968960-22527-1-git-send-email-rric@kernel.org>
References: <1370968960-22527-1-git-send-email-rric@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <bp@suse.de>

Rename ring_buffer-handling functions consistently with the "rb_"
prefix.

Signed-off-by: Borislav Petkov <bp@suse.de>
Signed-off-by: Robert Richter <rric@kernel.org>
---
 kernel/events/core.c        | 37 +++++++++++++++++--------------------
 kernel/events/ring_buffer.c |  7 +++----
 2 files changed, 20 insertions(+), 24 deletions(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index a0780b3..b790ab6 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -198,8 +198,7 @@ static void cpu_ctx_sched_in(struct perf_cpu_context *cpuctx,
 static void update_context_time(struct perf_event_context *ctx);
 static u64 perf_event_time(struct perf_event *event);
 
-static void ring_buffer_attach(struct perf_event *event,
-			       struct ring_buffer *rb);
+static void rb_attach(struct perf_event *event, struct ring_buffer *rb);
 
 void __weak perf_event_print_debug(void)	{ }
 
@@ -3022,7 +3021,7 @@ static void free_event_rcu(struct rcu_head *head)
 	kfree(event);
 }
 
-static void ring_buffer_put(struct ring_buffer *rb);
+static void rb_put(struct ring_buffer *rb);
 
 static void free_event(struct perf_event *event)
 {
@@ -3054,7 +3053,7 @@ static void free_event(struct perf_event *event)
 	}
 
 	if (event->rb) {
-		ring_buffer_put(event->rb);
+		rb_put(event->rb);
 		event->rb = NULL;
 	}
 
@@ -3299,8 +3298,8 @@ static unsigned int perf_poll(struct file *file, poll_table *wait)
 	 * t0: T1, rb = rcu_dereference(event->rb)
 	 * t1: T2, old_rb = event->rb
 	 * t2: T2, event->rb = new rb
-	 * t3: T2, ring_buffer_detach(old_rb)
-	 * t4: T1, ring_buffer_attach(rb1)
+	 * t3: T2, rb_detach(old_rb)
+	 * t4: T1, rb_attach(rb1)
 	 * t5: T1, poll_wait(event->waitq)
 	 *
 	 * To avoid this problem, we grab mmap_mutex in perf_poll()
@@ -3312,7 +3311,7 @@ static unsigned int perf_poll(struct file *file, poll_table *wait)
 	rcu_read_lock();
 	rb = rcu_dereference(event->rb);
 	if (rb) {
-		ring_buffer_attach(event, rb);
+		rb_attach(event, rb);
 		events = atomic_xchg(&rb->poll, 0);
 	}
 	rcu_read_unlock();
@@ -3617,8 +3616,7 @@ unlock:
 	return ret;
 }
 
-static void ring_buffer_attach(struct perf_event *event,
-			       struct ring_buffer *rb)
+static void rb_attach(struct perf_event *event, struct ring_buffer *rb)
 {
 	unsigned long flags;
 
@@ -3634,8 +3632,7 @@ unlock:
 	spin_unlock_irqrestore(&rb->event_lock, flags);
 }
 
-static void ring_buffer_detach(struct perf_event *event,
-			       struct ring_buffer *rb)
+static void rb_detach(struct perf_event *event, struct ring_buffer *rb)
 {
 	unsigned long flags;
 
@@ -3648,7 +3645,7 @@ static void ring_buffer_detach(struct perf_event *event,
 	spin_unlock_irqrestore(&rb->event_lock, flags);
 }
 
-static void ring_buffer_wakeup(struct perf_event *event)
+static void rb_wakeup(struct perf_event *event)
 {
 	struct ring_buffer *rb;
 
@@ -3672,7 +3669,7 @@ static void rb_free_rcu(struct rcu_head *rcu_head)
 	rb_free(rb);
 }
 
-static struct ring_buffer *ring_buffer_get(struct perf_event *event)
+static struct ring_buffer *rb_get(struct perf_event *event)
 {
 	struct ring_buffer *rb;
 
@@ -3687,7 +3684,7 @@ static struct ring_buffer *ring_buffer_get(struct perf_event *event)
 	return rb;
 }
 
-static void ring_buffer_put(struct ring_buffer *rb)
+static void rb_put(struct ring_buffer *rb)
 {
 	struct perf_event *event, *n;
 	unsigned long flags;
@@ -3724,10 +3721,10 @@ static void perf_mmap_close(struct vm_area_struct *vma)
 		atomic_long_sub((size >> PAGE_SHIFT) + 1, &user->locked_vm);
 		vma->vm_mm->pinned_vm -= event->mmap_locked;
 		rcu_assign_pointer(event->rb, NULL);
-		ring_buffer_detach(event, rb);
+		rb_detach(event, rb);
 		mutex_unlock(&event->mmap_mutex);
 
-		ring_buffer_put(rb);
+		rb_put(rb);
 		free_uid(user);
 	}
 }
@@ -3881,7 +3878,7 @@ static const struct file_operations perf_fops = {
 
 void perf_event_wakeup(struct perf_event *event)
 {
-	ring_buffer_wakeup(event);
+	rb_wakeup(event);
 
 	if (event->pending_kill) {
 		kill_fasync(&event->fasync, SIGIO, event->pending_kill);
@@ -6567,7 +6564,7 @@ set:
 
 	if (output_event) {
 		/* get the rb we want to redirect to */
-		rb = ring_buffer_get(output_event);
+		rb = rb_get(output_event);
 		if (!rb)
 			goto unlock;
 	}
@@ -6575,13 +6572,13 @@ set:
 	old_rb = event->rb;
 	rcu_assign_pointer(event->rb, rb);
 	if (old_rb)
-		ring_buffer_detach(event, old_rb);
+		rb_detach(event, old_rb);
 	ret = 0;
 unlock:
 	mutex_unlock(&event->mmap_mutex);
 
 	if (old_rb)
-		ring_buffer_put(old_rb);
+		rb_put(old_rb);
 out:
 	return ret;
 }
diff --git a/kernel/events/ring_buffer.c b/kernel/events/ring_buffer.c
index cd55144..b514c56 100644
--- a/kernel/events/ring_buffer.c
+++ b/kernel/events/ring_buffer.c
@@ -212,8 +212,7 @@ void perf_output_end(struct perf_output_handle *handle)
 	rcu_read_unlock();
 }
 
-static void
-ring_buffer_init(struct ring_buffer *rb, long watermark, int flags)
+static void rb_init(struct ring_buffer *rb, long watermark, int flags)
 {
 	long max_size = perf_data_size(rb);
 
@@ -290,7 +289,7 @@ struct ring_buffer *rb_alloc(int nr_pages, long watermark, int cpu, int flags)
 
 	rb->nr_pages = nr_pages;
 
-	ring_buffer_init(rb, watermark, flags);
+	rb_init(rb, watermark, flags);
 
 	return rb;
 
@@ -395,7 +394,7 @@ struct ring_buffer *rb_alloc(int nr_pages, long watermark, int cpu, int flags)
 	rb->page_order = ilog2(nr_pages);
 	rb->nr_pages = !!nr_pages;
 
-	ring_buffer_init(rb, watermark, flags);
+	rb_init(rb, watermark, flags);
 
 	return rb;
 
-- 
1.8.1.1

