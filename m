Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932204Ab3KWA5R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 19:57:17 -0500
Received: from g4t0014.houston.hp.com ([15.201.24.17]:5451 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932168Ab3KWA44 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 19:56:56 -0500
From: Davidlohr Bueso <davidlohr@hp.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, dvhart@linux.intel.com, peterz@infradead.org,
        tglx@linutronix.de, efault@gmx.de, jeffm@suse.com,
        torvalds@linux-foundation.org, scott.norton@hp.com, tom.vaden@hp.com,
        aswin@hp.com, Waiman.Long@hp.com, jason.low2@hp.com, davidlohr@hp.com
Subject: [PATCH 5/5] sched,futex: Provide delayed wakeup list
Date: Fri, 22 Nov 2013 16:56:37 -0800
Message-Id: <1385168197-8612-6-git-send-email-davidlohr@hp.com>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1385168197-8612-1-git-send-email-davidlohr@hp.com>
References: <1385168197-8612-1-git-send-email-davidlohr@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Zijlstra <peterz@infradead.org>

Original patchset: https://lkml.org/lkml/2011/9/14/118

This is useful for locking primitives that can effect multiple
wakeups per operation and want to avoid lock internal lock contention
by delaying the wakeups until we've released the lock internal locks.

Alternatively it can be used to avoid issuing multiple wakeups, and
thus save a few cycles, in packet processing. Queue all target tasks
and wakeup once you've processed all packets. That way you avoid
waking the target task multiple times if there were multiple packets
for the same task.

This patch adds the needed infrastructure into the scheduler code
and uses the new wake_list to delay the futex wakeups until
after we've released the hash bucket locks. This avoids the newly
woken tasks from immediately getting stuck on the hb->lock.

Cc: Ingo Molnar <mingo@kernel.org>
Cc: Darren Hart <dvhart@linux.intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Jeff Mahoney <jeffm@suse.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Scott Norton <scott.norton@hp.com>
Cc: Tom Vaden <tom.vaden@hp.com>
Cc: Aswin Chandramouleeswaran <aswin@hp.com>
Cc: Waiman Long <Waiman.Long@hp.com>
Tested-by: Jason Low <jason.low2@hp.com>
[forward ported]
Signed-off-by: Davidlohr Bueso <davidlohr@hp.com>
---
Please note that in the original thread there was some debate
about spurious wakeups (https://lkml.org/lkml/2011/9/17/31), so
you can consider this more of an RFC patch if folks believe that
this functionality is incomplete/buggy.

 include/linux/sched.h | 41 +++++++++++++++++++++++++++++++++++++++++
 kernel/futex.c        | 31 +++++++++++++++----------------
 kernel/sched/core.c   | 19 +++++++++++++++++++
 3 files changed, 75 insertions(+), 16 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 7e35d4b..679aabb 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -793,6 +793,20 @@ enum cpu_idle_type {
 
 extern int __weak arch_sd_sibiling_asym_packing(void);
 
+struct wake_list_head {
+	struct wake_list_node *first;
+};
+
+struct wake_list_node {
+	struct wake_list_node *next;
+};
+
+#define WAKE_LIST_TAIL ((struct wake_list_node *) 0x01)
+
+#define WAKE_LIST(name)					\
+	struct wake_list_head name = { WAKE_LIST_TAIL }
+
+
 struct sched_domain_attr {
 	int relax_domain_level;
 };
@@ -1078,6 +1092,8 @@ struct task_struct {
 	unsigned int btrace_seq;
 #endif
 
+	struct wake_list_node wake_list;
+
 	unsigned int policy;
 	int nr_cpus_allowed;
 	cpumask_t cpus_allowed;
@@ -2044,6 +2060,31 @@ extern void wake_up_new_task(struct task_struct *tsk);
 extern void sched_fork(unsigned long clone_flags, struct task_struct *p);
 extern void sched_dead(struct task_struct *p);
 
+static inline void
+wake_list_add(struct wake_list_head *head, struct task_struct *p)
+{
+	struct wake_list_node *n = &p->wake_list;
+
+	/*
+	 * Atomically grab the task, if ->wake_list is !0 already it means
+	 * its already queued (either by us or someone else) and will get the
+	 * wakeup due to that.
+	 *
+	 * This cmpxchg() implies a full barrier, which pairs with the write
+	 * barrier implied by the wakeup in wake_up_list().
+	 */
+	if (cmpxchg(&n->next, NULL, head->first))
+		return;
+
+	/*
+	 * The head is context local, there can be no concurrency.
+	 */
+	get_task_struct(p);
+	head->first = n;
+}
+
+extern void wake_up_list(struct wake_list_head *head, unsigned int state);
+
 extern void proc_caches_init(void);
 extern void flush_signals(struct task_struct *);
 extern void __flush_signals(struct task_struct *);
diff --git a/kernel/futex.c b/kernel/futex.c
index 2f9dd5d..3d60a3d 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -851,20 +851,17 @@ static void __unqueue_futex(struct futex_q *q)
  * The hash bucket lock must be held when this is called.
  * Afterwards, the futex_q must not be accessed.
  */
-static void wake_futex(struct futex_q *q)
+static void wake_futex(struct wake_list_head *wake_list, struct futex_q *q)
 {
 	struct task_struct *p = q->task;
 
 	/*
-	 * We set q->lock_ptr = NULL _before_ we wake up the task. If
-	 * a non-futex wake up happens on another CPU then the task
-	 * might exit and p would dereference a non-existing task
-	 * struct. Prevent this by holding a reference on p across the
-	 * wake up.
+	 * Queue up and delay the futex wakeups until the hb lock
+	 * has been released.
 	 */
-	get_task_struct(p);
-
+	wake_list_add(wake_list, p);
 	__unqueue_futex(q);
+
 	/*
 	 * The waiting task can free the futex_q as soon as
 	 * q->lock_ptr = NULL is written, without taking any locks. A
@@ -873,9 +870,6 @@ static void wake_futex(struct futex_q *q)
 	 */
 	smp_wmb();
 	q->lock_ptr = NULL;
-
-	wake_up_state(p, TASK_NORMAL);
-	put_task_struct(p);
 }
 
 static int wake_futex_pi(u32 __user *uaddr, u32 uval, struct futex_q *this)
@@ -992,6 +986,7 @@ futex_wake(u32 __user *uaddr, unsigned int flags, int nr_wake, u32 bitset)
 	struct futex_q *this, *next;
 	union futex_key key = FUTEX_KEY_INIT;
 	int ret;
+	WAKE_LIST(wake_list);
 
 	if (!bitset)
 		return -EINVAL;
@@ -1018,7 +1013,7 @@ futex_wake(u32 __user *uaddr, unsigned int flags, int nr_wake, u32 bitset)
 			if (!(this->bitset & bitset))
 				continue;
 
-			wake_futex(this);
+			wake_futex(&wake_list, this);
 			if (++ret >= nr_wake)
 				break;
 		}
@@ -1027,6 +1022,7 @@ futex_wake(u32 __user *uaddr, unsigned int flags, int nr_wake, u32 bitset)
 	spin_unlock(&hb->lock);
 out_put_key:
 	put_futex_key(&key);
+	wake_up_list(&wake_list, TASK_NORMAL);
 out:
 	return ret;
 }
@@ -1043,7 +1039,7 @@ futex_wake_op(u32 __user *uaddr1, unsigned int flags, u32 __user *uaddr2,
 	struct futex_hash_bucket *hb1, *hb2;
 	struct futex_q *this, *next;
 	int ret, op_ret;
-
+	WAKE_LIST(wake_list);
 retry:
 	ret = get_futex_key(uaddr1, flags & FLAGS_SHARED, &key1, VERIFY_READ);
 	if (unlikely(ret != 0))
@@ -1094,7 +1090,7 @@ retry_private:
 				ret = -EINVAL;
 				goto out_unlock;
 			}
-			wake_futex(this);
+			wake_futex(&wake_list, this);
 			if (++ret >= nr_wake)
 				break;
 		}
@@ -1108,7 +1104,7 @@ retry_private:
 					ret = -EINVAL;
 					goto out_unlock;
 				}
-				wake_futex(this);
+				wake_futex(&wake_list, this);
 				if (++op_ret >= nr_wake2)
 					break;
 			}
@@ -1122,6 +1118,7 @@ out_put_keys:
 	put_futex_key(&key2);
 out_put_key1:
 	put_futex_key(&key1);
+	wake_up_list(&wake_list, TASK_NORMAL);
 out:
 	return ret;
 }
@@ -1276,6 +1273,7 @@ static int futex_requeue(u32 __user *uaddr1, unsigned int flags,
 	struct futex_hash_bucket *hb1, *hb2;
 	struct futex_q *this, *next;
 	u32 curval2;
+	WAKE_LIST(wake_list);
 
 	if (requeue_pi) {
 		/*
@@ -1423,7 +1421,7 @@ retry_private:
 		 * woken by futex_unlock_pi().
 		 */
 		if (++task_count <= nr_wake && !requeue_pi) {
-			wake_futex(this);
+			wake_futex(&wake_list, this);
 			continue;
 		}
 
@@ -1476,6 +1474,7 @@ out_put_keys:
 	put_futex_key(&key2);
 out_put_key1:
 	put_futex_key(&key1);
+	wake_up_list(&wake_list, TASK_NORMAL);
 out:
 	if (pi_state != NULL)
 		free_pi_state(pi_state);
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index c180860..1e1b1ad 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -1695,6 +1695,25 @@ int wake_up_state(struct task_struct *p, unsigned int state)
 	return try_to_wake_up(p, state, 0);
 }
 
+void wake_up_list(struct wake_list_head *head, unsigned int state)
+{
+	struct wake_list_node *n = head->first;
+	struct task_struct *p;
+
+	while (n != WAKE_LIST_TAIL) {
+		p = container_of(n, struct task_struct, wake_list);
+		n = n->next;
+
+		p->wake_list.next = NULL;
+		/*
+		 * wake_up_state() implies a wmb() to pair with the queueing
+		 * in wake_list_add() so as not to miss wakeups.
+		 */
+		wake_up_state(p, state);
+		put_task_struct(p);
+	}
+}
+
 /*
  * Perform scheduler related setup for a newly forked process p.
  * p is forked by current.
-- 
1.8.1.4

