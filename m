Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760604Ab3BICpt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 21:45:49 -0500
Received: from mail-da0-f47.google.com ([209.85.210.47]:40840 "EHLO
	mail-da0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757769Ab3BICpp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 21:45:45 -0500
From: Michel Lespinasse <walken@google.com>
To: linux-kernel@vger.kernel.org, anton@samba.org, hpa@zytor.com,
        mingo@kernel.org, arjan@linux.intel.com, a.p.zijlstra@chello.nl,
        torvalds@linux-foundation.org, alex.shi@intel.com,
        yuanhan.liu@linux.intel.com, dhowells@redhat.com,
        akpm@linux-foundation.org, tglx@linutronix.de
Subject: [PATCH 1/4] rwsem: make the waiter type an enumeration rather than a bitmask
Date: Fri,  8 Feb 2013 18:45:34 -0800
Message-Id: <1360377937-16297-2-git-send-email-walken@google.com>
X-Mailer: git-send-email 1.8.1
In-Reply-To: <1360377937-16297-1-git-send-email-walken@google.com>
References: <1360377937-16297-1-git-send-email-walken@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We are not planning to add some new waiter flags, so we can convert the
waiter type into an enumeration.

Background: David Howells suggested I do this back when I tried adding
a new waiter type for unfair readers. However, I believe the cleanup
applies regardless of that use case.

Signed-off-by: Michel Lespinasse <walken@google.com>

---
 lib/rwsem.c | 19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

diff --git a/lib/rwsem.c b/lib/rwsem.c
index 8337e1b9bb8d..4a6ff093a433 100644
--- a/lib/rwsem.c
+++ b/lib/rwsem.c
@@ -28,12 +28,15 @@ void __init_rwsem(struct rw_semaphore *sem, const char *name,
 
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
@@ -63,7 +66,7 @@ __rwsem_do_wake(struct rw_semaphore *sem, int wake_type)
 	signed long oldcount, woken, loop, adjustment;
 
 	waiter = list_entry(sem->wait_list.next, struct rwsem_waiter, list);
-	if (!(waiter->flags & RWSEM_WAITING_FOR_WRITE))
+	if (waiter->type != RWSEM_WAITING_FOR_WRITE)
 		goto readers_only;
 
 	if (wake_type == RWSEM_WAKE_READ_OWNED)
@@ -132,10 +135,10 @@ __rwsem_do_wake(struct rw_semaphore *sem, int wake_type)
 		waiter = list_entry(waiter->list.next,
 					struct rwsem_waiter, list);
 
-	} while (waiter->flags & RWSEM_WAITING_FOR_READ);
+	} while (waiter->type != RWSEM_WAITING_FOR_WRITE);
 
 	adjustment = woken * RWSEM_ACTIVE_READ_BIAS;
-	if (waiter->flags & RWSEM_WAITING_FOR_READ)
+	if (waiter->type != RWSEM_WAITING_FOR_WRITE)
 		/* hit end of list above */
 		adjustment -= RWSEM_WAITING_BIAS;
 
@@ -171,7 +174,7 @@ __rwsem_do_wake(struct rw_semaphore *sem, int wake_type)
  */
 static struct rw_semaphore __sched *
 rwsem_down_failed_common(struct rw_semaphore *sem,
-			 unsigned int flags, signed long adjustment)
+			 enum rwsem_waiter_type type, signed long adjustment)
 {
 	struct rwsem_waiter waiter;
 	struct task_struct *tsk = current;
@@ -182,7 +185,7 @@ rwsem_down_failed_common(struct rw_semaphore *sem,
 	/* set up my own style of waitqueue */
 	raw_spin_lock_irq(&sem->wait_lock);
 	waiter.task = tsk;
-	waiter.flags = flags;
+	waiter.type = type;
 	get_task_struct(tsk);
 
 	if (list_empty(&sem->wait_list))
-- 
1.8.1
