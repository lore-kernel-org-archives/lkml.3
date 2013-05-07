Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759501Ab3EGNqM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 09:46:12 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:43667 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933396Ab3EGNqI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 09:46:08 -0400
From: Michel Lespinasse <walken@google.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        David Howells <dhowells@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, Rik van Riel <riel@redhat.com>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        Peter Hurley <peter@hurleysoftware.com>
Cc: Alex Shi <alex.shi@intel.com>, Yuanhan Liu <yuanhan.liu@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 01/14] rwsem: make the waiter type an enumeration rather than a bitmask
Date: Tue,  7 May 2013 06:45:49 -0700
Message-Id: <1367934362-10433-2-git-send-email-walken@google.com>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <1367934362-10433-1-git-send-email-walken@google.com>
References: <1367934362-10433-1-git-send-email-walken@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We are not planning to add some new waiter flags, so we can convert the
waiter type into an enumeration.

Background: David Howells suggested I do this back when I tried adding
a new waiter type for unfair readers. However, I believe the cleanup
applies regardless of that use case.

Signed-off-by: Michel Lespinasse <walken@google.com>
Reviewed-by: Rik van Riel <riel@redhat.com>
Reviewed-by: Peter Hurley <peter@hurleysoftware.com>
Acked-by: Davidlohr Bueso <davidlohr.bueso@hp.com>
---
 lib/rwsem-spinlock.c | 19 +++++++++++--------
 lib/rwsem.c          | 23 +++++++++++++----------
 2 files changed, 24 insertions(+), 18 deletions(-)

diff --git a/lib/rwsem-spinlock.c b/lib/rwsem-spinlock.c
index 7542afbb22b3..5f117f37ac0a 100644
--- a/lib/rwsem-spinlock.c
+++ b/lib/rwsem-spinlock.c
@@ -9,12 +9,15 @@
 #include <linux/sched.h>
 #include <linux/export.h>
 
+enum rwsem_waiter_type {
+	RWSEM_WAITING_FOR_WRITE,
+	RWSEM_WAITING_FOR_READ
+};
+
 struct rwsem_waiter {
 	struct list_head list;
 	struct task_struct *task;
-	unsigned int flags;
-#define RWSEM_WAITING_FOR_READ	0x00000001
-#define RWSEM_WAITING_FOR_WRITE	0x00000002
+	enum rwsem_waiter_type type;
 };
 
 int rwsem_is_locked(struct rw_semaphore *sem)
@@ -68,7 +71,7 @@ __rwsem_do_wake(struct rw_semaphore *sem, int wakewrite)
 	waiter = list_entry(sem->wait_list.next, struct rwsem_waiter, list);
 
 	if (!wakewrite) {
-		if (waiter->flags & RWSEM_WAITING_FOR_WRITE)
+		if (waiter->type == RWSEM_WAITING_FOR_WRITE)
 			goto out;
 		goto dont_wake_writers;
 	}
@@ -78,7 +81,7 @@ __rwsem_do_wake(struct rw_semaphore *sem, int wakewrite)
 	 * to -1 here to indicate we get the lock. Instead, we wake it up
 	 * to let it go get it again.
 	 */
-	if (waiter->flags & RWSEM_WAITING_FOR_WRITE) {
+	if (waiter->type == RWSEM_WAITING_FOR_WRITE) {
 		wake_up_process(waiter->task);
 		goto out;
 	}
@@ -86,7 +89,7 @@ __rwsem_do_wake(struct rw_semaphore *sem, int wakewrite)
 	/* grant an infinite number of read locks to the front of the queue */
  dont_wake_writers:
 	woken = 0;
-	while (waiter->flags & RWSEM_WAITING_FOR_READ) {
+	while (waiter->type == RWSEM_WAITING_FOR_READ) {
 		struct list_head *next = waiter->list.next;
 
 		list_del(&waiter->list);
@@ -144,7 +147,7 @@ void __sched __down_read(struct rw_semaphore *sem)
 
 	/* set up my own style of waitqueue */
 	waiter.task = tsk;
-	waiter.flags = RWSEM_WAITING_FOR_READ;
+	waiter.type = RWSEM_WAITING_FOR_READ;
 	get_task_struct(tsk);
 
 	list_add_tail(&waiter.list, &sem->wait_list);
@@ -201,7 +204,7 @@ void __sched __down_write_nested(struct rw_semaphore *sem, int subclass)
 	/* set up my own style of waitqueue */
 	tsk = current;
 	waiter.task = tsk;
-	waiter.flags = RWSEM_WAITING_FOR_WRITE;
+	waiter.type = RWSEM_WAITING_FOR_WRITE;
 	list_add_tail(&waiter.list, &sem->wait_list);
 
 	/* wait for someone to release the lock */
diff --git a/lib/rwsem.c b/lib/rwsem.c
index ad5e0df16ab4..672eb33218ac 100644
--- a/lib/rwsem.c
+++ b/lib/rwsem.c
@@ -30,12 +30,15 @@ void __init_rwsem(struct rw_semaphore *sem, const char *name,
 
 EXPORT_SYMBOL(__init_rwsem);
 
+enum rwsem_waiter_type {
+	RWSEM_WAITING_FOR_WRITE,
+	RWSEM_WAITING_FOR_READ
+};
+
 struct rwsem_waiter {
 	struct list_head list;
 	struct task_struct *task;
-	unsigned int flags;
-#define RWSEM_WAITING_FOR_READ	0x00000001
-#define RWSEM_WAITING_FOR_WRITE	0x00000002
+	enum rwsem_waiter_type type;
 };
 
 /* Wake types for __rwsem_do_wake().  Note that RWSEM_WAKE_NO_ACTIVE and
@@ -65,7 +68,7 @@ __rwsem_do_wake(struct rw_semaphore *sem, int wake_type)
 	signed long woken, loop, adjustment;
 
 	waiter = list_entry(sem->wait_list.next, struct rwsem_waiter, list);
-	if (!(waiter->flags & RWSEM_WAITING_FOR_WRITE))
+	if (waiter->type != RWSEM_WAITING_FOR_WRITE)
 		goto readers_only;
 
 	if (wake_type == RWSEM_WAKE_READ_OWNED)
@@ -112,10 +115,10 @@ __rwsem_do_wake(struct rw_semaphore *sem, int wake_type)
 		waiter = list_entry(waiter->list.next,
 					struct rwsem_waiter, list);
 
-	} while (waiter->flags & RWSEM_WAITING_FOR_READ);
+	} while (waiter->type != RWSEM_WAITING_FOR_WRITE);
 
 	adjustment = woken * RWSEM_ACTIVE_READ_BIAS;
-	if (waiter->flags & RWSEM_WAITING_FOR_READ)
+	if (waiter->type != RWSEM_WAITING_FOR_WRITE)
 		/* hit end of list above */
 		adjustment -= RWSEM_WAITING_BIAS;
 
@@ -148,7 +151,7 @@ static int try_get_writer_sem(struct rw_semaphore *sem,
 
 	/* only steal when first waiter is writing */
 	fwaiter = list_entry(sem->wait_list.next, struct rwsem_waiter, list);
-	if (!(fwaiter->flags & RWSEM_WAITING_FOR_WRITE))
+	if (fwaiter->type != RWSEM_WAITING_FOR_WRITE)
 		return 0;
 
 	adjustment = RWSEM_ACTIVE_WRITE_BIAS;
@@ -179,7 +182,7 @@ try_again_write:
  */
 static struct rw_semaphore __sched *
 rwsem_down_failed_common(struct rw_semaphore *sem,
-			 unsigned int flags, signed long adjustment)
+			 enum rwsem_waiter_type type, signed long adjustment)
 {
 	struct rwsem_waiter waiter;
 	struct task_struct *tsk = current;
@@ -190,7 +193,7 @@ rwsem_down_failed_common(struct rw_semaphore *sem,
 	/* set up my own style of waitqueue */
 	raw_spin_lock_irq(&sem->wait_lock);
 	waiter.task = tsk;
-	waiter.flags = flags;
+	waiter.type = type;
 	get_task_struct(tsk);
 
 	if (list_empty(&sem->wait_list))
@@ -221,7 +224,7 @@ rwsem_down_failed_common(struct rw_semaphore *sem,
 
 		raw_spin_lock_irq(&sem->wait_lock);
 		/* Try to get the writer sem, may steal from the head writer: */
-		if (flags == RWSEM_WAITING_FOR_WRITE)
+		if (type == RWSEM_WAITING_FOR_WRITE)
 			if (try_get_writer_sem(sem, &waiter)) {
 				raw_spin_unlock_irq(&sem->wait_lock);
 				return sem;
-- 
1.8.2.1

