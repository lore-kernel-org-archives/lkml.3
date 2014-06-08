Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753538AbaFHLk4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jun 2014 07:40:56 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:50155 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752819AbaFHLkz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jun 2014 07:40:55 -0400
Date: Sun, 8 Jun 2014 13:40:52 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        kernel list <linux-kernel@vger.kernel.org>
Subject: per-thread wait_queue_t
Message-ID: <20140608114052.GA8774@amd.pavel.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

When you proposed to put wait queues into task_struct, you were
probably looking for less coding and more analysis?

Anyway, there's starter patch below... It compiles, but is otherwise
completely untested.

Signed-off-by: Pavel Machek <pavel@ucw.cz>
								Pavel

diff --git a/fs/eventpoll.c b/fs/eventpoll.c
index af90312..6dde102 100644
--- a/fs/eventpoll.c
+++ b/fs/eventpoll.c
@@ -1591,7 +1591,7 @@ static int ep_poll(struct eventpoll *ep, struct epoll_event __user *events,
 	int res = 0, eavail, timed_out = 0;
 	unsigned long flags;
 	long slack = 0;
-	wait_queue_t wait;
+	wait_queue_t *wait;
 	ktime_t expires, *to = NULL;
 
 	if (timeout > 0) {
@@ -1614,13 +1614,14 @@ fetch_events:
 	spin_lock_irqsave(&ep->lock, flags);
 
 	if (!ep_events_available(ep)) {
+		wait = alloc_waitqueue(GFP_KERNEL);
 		/*
 		 * We don't have any available event to return to the caller.
 		 * We need to sleep here, and we will be wake up by
 		 * ep_poll_callback() when events will become available.
 		 */
-		init_waitqueue_entry(&wait, current);
-		__add_wait_queue_exclusive(&ep->wq, &wait);
+		init_waitqueue_entry(wait, current);
+		__add_wait_queue_exclusive(&ep->wq, wait);
 
 		for (;;) {
 			/*
@@ -1642,7 +1643,8 @@ fetch_events:
 
 			spin_lock_irqsave(&ep->lock, flags);
 		}
-		__remove_wait_queue(&ep->wq, &wait);
+		__remove_wait_queue(&ep->wq, wait);
+		free_waitqueue(wait);
 
 		set_current_state(TASK_RUNNING);
 	}
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 25f54c7..0b2be71 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -26,6 +26,7 @@ struct sched_param {
 #include <linux/nodemask.h>
 #include <linux/mm_types.h>
 #include <linux/preempt_mask.h>
+#include <linux/slab.h>
 
 #include <asm/page.h>
 #include <asm/ptrace.h>
@@ -1607,6 +1608,8 @@ struct task_struct {
 	unsigned int	sequential_io;
 	unsigned int	sequential_io_avg;
 #endif
+
+	wait_queue_t wait_queues[NUM_TASK_WAIT_QUEUES];
 };
 
 /* Future-safe accessor for struct task_struct's cpus_allowed. */
@@ -2991,4 +2994,26 @@ static inline unsigned long rlimit_max(unsigned int limit)
 	return task_rlimit_max(current, limit);
 }
 
+static inline wait_queue_t *alloc_waitqueue(int gfp)
+{
+	int i;
+	for (i=0; i<NUM_TASK_WAIT_QUEUES; i++) {
+		if (current->wait_queues[i].flags & WQ_FLAG_FREE) {
+			current->wait_queues[i].flags &= ~WQ_FLAG_FREE;
+			return &current->wait_queues[i];
+		}
+	}
+	return kmalloc(sizeof(wait_queue_t), gfp);
+}
+
+static inline void free_waitqueue(wait_queue_t *q)
+{
+	if (q->flags & WQ_FLAG_HARDCODED) {
+		q->flags |= WQ_FLAG_FREE;
+		return;
+	}
+	kfree(q);
+}
+
+
 #endif
diff --git a/include/linux/wait.h b/include/linux/wait.h
index bd68819..6c0dd83 100644
--- a/include/linux/wait.h
+++ b/include/linux/wait.h
@@ -16,11 +16,15 @@ int default_wake_function(wait_queue_t *wait, unsigned mode, int flags, void *ke
 struct __wait_queue {
 	unsigned int		flags;
 #define WQ_FLAG_EXCLUSIVE	0x01
+#define WQ_FLAG_FREE		0x02
+#define WQ_FLAG_HARDCODED	0x04
 	void			*private;
 	wait_queue_func_t	func;
 	struct list_head	task_list;
 };
 
+#define NUM_TASK_WAIT_QUEUES 2
+
 struct wait_bit_key {
 	void			*flags;
 	int			bit_nr;
@@ -83,6 +87,7 @@ extern void __init_waitqueue_head(wait_queue_head_t *q, const char *name, struct
 # define DECLARE_WAIT_QUEUE_HEAD_ONSTACK(name) DECLARE_WAIT_QUEUE_HEAD(name)
 #endif
 
+
 static inline void init_waitqueue_entry(wait_queue_t *q, struct task_struct *p)
 {
 	q->flags	= 0;
diff --git a/kernel/fork.c b/kernel/fork.c
index 54a8d26..c339e18 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1315,6 +1315,13 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 	p->sequential_io	= 0;
 	p->sequential_io_avg	= 0;
 #endif
+	{
+		int i;
+		for (i=0; i<NUM_TASK_WAIT_QUEUES; i++) {
+			init_waitqueue_entry(&p->wait_queues[i], p);
+			p->wait_queues[i].flags = WQ_FLAG_FREE | WQ_FLAG_HARDCODED;
+		}
+	}
 
 	/* Perform scheduler related setup. Assign this task to a CPU. */
 	retval = sched_fork(clone_flags, p);


-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
