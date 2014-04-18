Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752533AbaDRRAM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 13:00:12 -0400
Received: from merlin.infradead.org ([205.233.59.134]:59478 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751159AbaDRRAH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 13:00:07 -0400
Date: Fri, 18 Apr 2014 18:59:58 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Vince Weaver <vincent.weaver@maine.edu>
Cc: Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [perf] more perf_fuzzer memory corruption
Message-ID: <20140418165958.GQ13658@twins.programming.kicks-ass.net>
References: <20140416141514.GS11182@twins.programming.kicks-ass.net>
 <alpine.DEB.2.10.1404161326380.19325@vincent-weaver-1.um.maine.edu>
 <alpine.DEB.2.10.1404161337350.19325@vincent-weaver-1.um.maine.edu>
 <20140417094815.GA9348@gmail.com>
 <20140417114533.GJ11096@twins.programming.kicks-ass.net>
 <20140417142213.GA29338@gmail.com>
 <alpine.DEB.2.10.1404171037590.22226@vincent-weaver-1.um.maine.edu>
 <20140417145418.GM11096@twins.programming.kicks-ass.net>
 <alpine.DEB.2.10.1404181042320.26918@vincent-weaver-1.um.maine.edu>
 <20140418152314.GY11182@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140418152314.GY11182@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 18, 2014 at 05:23:14PM +0200, Peter Zijlstra wrote:
> OK, that's a good clue. That looks like we're freeing events that still
> are on the owner list, which would indicate we're freeing events that
> have a refcount.
> 
> I added a WARN in free_event() to check the refcount, along with a
> number of false positives (through the perf_event_open() fail path) I do
> appear to be getting actual fails here.
> 
> At least I can 'reproduce' this. Earlier attempts, even based on your
> .config only got me very mysterious lockups -- I suspect the corruption
> happens on a slightly different spot or so and completely messes up the
> machine.

The below should have only made the false positives go away, but my
machine has magically stopped going all funny on me. Could you give it a
go?

---
 kernel/events/core.c | 73 +++++++++++++++++++++++++++++++---------------------
 1 file changed, 43 insertions(+), 30 deletions(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index f83a71a3e46d..f9d7b859395e 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -3231,8 +3231,11 @@ static void __free_event(struct perf_event *event)
 
 	call_rcu(&event->rcu_head, free_event_rcu);
 }
-static void free_event(struct perf_event *event)
+
+static void _free_event(struct perf_event *event)
 {
+	WARN_ON(atomic_long_read(&event->refcount));
+
 	irq_work_sync(&event->pending);
 
 	unaccount_event(event);
@@ -3259,45 +3262,28 @@ static void free_event(struct perf_event *event)
 	if (is_cgroup_event(event))
 		perf_detach_cgroup(event);
 
-
 	__free_event(event);
 }
 
-int perf_event_release_kernel(struct perf_event *event)
-{
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
+static void put_event(struct perf_event *event);
 
-	return 0;
+static void free_event(struct perf_event *event)
+{
+	if (unlikely(atomic_long_cmpxchg(&event->refcount, 1, 0) != 1)) {
+		WARN(1, "unexpected event refcount: %ld\n", 
+				atomic_long_read(&event->refcount));
+		put_event(event);
+		return;
+	}
+	_free_event(event);
 }
-EXPORT_SYMBOL_GPL(perf_event_release_kernel);
 
 /*
  * Called when the last reference to the file is gone.
  */
 static void put_event(struct perf_event *event)
 {
+	struct perf_event_context *ctx = event->ctx;
 	struct task_struct *owner;
 
 	if (!atomic_long_dec_and_test(&event->refcount))
@@ -3336,9 +3322,36 @@ static void put_event(struct perf_event *event)
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
 }
 
+int perf_event_release_kernel(struct perf_event *event)
+{
+	put_event(event);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(perf_event_release_kernel);
+
 static int perf_release(struct inode *inode, struct file *file)
 {
 	put_event(file->private_data);
