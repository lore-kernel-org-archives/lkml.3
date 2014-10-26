Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751892AbaJZAVD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Oct 2014 20:21:03 -0400
Received: from mail-qc0-f177.google.com ([209.85.216.177]:35068 "EHLO
	mail-qc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751432AbaJZAVB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Oct 2014 20:21:01 -0400
From: Brian Silverman <bsilver16384@gmail.com>
To: tglx@linutronix.de
Cc: austin.linux@gmail.com, linux-kernel@vger.kernel.org, darren@dvhart.com,
        peterz@infradead.org, Brian Silverman <bsilver16384@gmail.com>
Subject: [PATCH v2] futex: fix a race condition between REQUEUE_PI and task death
Date: Sat, 25 Oct 2014 20:20:37 -0400
Message-Id: <1414282837-23092-1-git-send-email-bsilver16384@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1414092159-17697-1-git-send-email-bsilver16384@gmail.com>
References: <1414092159-17697-1-git-send-email-bsilver16384@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

free_pi_state and exit_pi_state_list both clean up futex_pi_state's.
exit_pi_state_list takes the hb lock first, and most callers of
free_pi_state do too. requeue_pi didn't, which means free_pi_state can
free the pi_state out from under exit_pi_state_list. For example:
task A                            |  task B
exit_pi_state_list                |
  pi_state =                      |
      curr->pi_state_list->next   |
                                  |  futex_requeue(requeue_pi=1)
                                  |    // pi_state is the same as
                                  |    // the one in task A
                                  |    free_pi_state(pi_state)
                                  |      list_del_init(&pi_state->list)
                                  |      kfree(pi_state)
  list_del_init(&pi_state->list)  |

Move the free_pi_state calls in requeue_pi to before it drops the hb
locks which it's already holding.

I have test code that forks a bunch of processes, which all fork more
processes that do futex(FUTEX_WAIT_REQUEUE_PI), then do
futex(FUTEX_CMP_REQUEUE_PI) before killing the waiting processes. That
test consistently breaks QEMU VMs without this patch.

Although they both make it faster to crash, CONFIG_PREEMPT_RT and lots
of CPUs are not necessary to reproduce this problem. The symptoms range
from random reboots to corrupting the test program to corrupting whole
filesystems to strange BIOS errors. Crashdumps (when they get created at
all) are usually a mess, to the point of crashing tools used to examine
them.

Signed-off-by: Brian Silverman <bsilver16384@gmail.com>
---
 kernel/futex.c |   44 +++++++++++++++++++++++++++-----------------
 1 file changed, 27 insertions(+), 17 deletions(-)

diff --git a/kernel/futex.c b/kernel/futex.c
index 815d7af..c2c35a5 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -64,6 +64,7 @@
 #include <linux/hugetlb.h>
 #include <linux/freezer.h>
 #include <linux/bootmem.h>
+#include <linux/lockdep.h>
 
 #include <asm/futex.h>
 
@@ -639,8 +640,16 @@ static struct futex_pi_state * alloc_pi_state(void)
 	return pi_state;
 }
 
-static void free_pi_state(struct futex_pi_state *pi_state)
+/**
+ * Must be called with the hb lock held.
+ */
+static void free_pi_state(struct futex_pi_state *pi_state,
+					struct futex_hash_bucket *hb)
 {
+	if (!pi_state) return;
+
+	lockdep_assert_held(&hb->lock);
+
 	if (!atomic_dec_and_test(&pi_state->refcount))
 		return;
 
@@ -1519,15 +1528,6 @@ static int futex_requeue(u32 __user *uaddr1, unsigned int flags,
 	}
 
 retry:
-	if (pi_state != NULL) {
-		/*
-		 * We will have to lookup the pi_state again, so free this one
-		 * to keep the accounting correct.
-		 */
-		free_pi_state(pi_state);
-		pi_state = NULL;
-	}
-
 	ret = get_futex_key(uaddr1, flags & FLAGS_SHARED, &key1, VERIFY_READ);
 	if (unlikely(ret != 0))
 		goto out;
@@ -1558,6 +1558,12 @@ retry_private:
 		ret = get_futex_value_locked(&curval, uaddr1);
 
 		if (unlikely(ret)) {
+			/*
+			 * We will have to lookup the pi_state again, so
+			 * free this one to keep the accounting correct.
+			 */
+			free_pi_state(pi_state, hb2);
+			pi_state = NULL;
 			double_unlock_hb(hb1, hb2);
 			hb_waiters_dec(hb2);
 
@@ -1617,6 +1623,8 @@ retry_private:
 		case 0:
 			break;
 		case -EFAULT:
+			free_pi_state(pi_state, hb2);
+			pi_state = NULL;
 			double_unlock_hb(hb1, hb2);
 			hb_waiters_dec(hb2);
 			put_futex_key(&key2);
@@ -1632,6 +1640,8 @@ retry_private:
 			 *   exit to complete.
 			 * - The user space value changed.
 			 */
+			free_pi_state(pi_state, hb2);
+			pi_state = NULL;
 			double_unlock_hb(hb1, hb2);
 			hb_waiters_dec(hb2);
 			put_futex_key(&key2);
@@ -1699,7 +1709,7 @@ retry_private:
 			} else if (ret) {
 				/* -EDEADLK */
 				this->pi_state = NULL;
-				free_pi_state(pi_state);
+				free_pi_state(pi_state, hb2);
 				goto out_unlock;
 			}
 		}
@@ -1708,6 +1718,7 @@ retry_private:
 	}
 
 out_unlock:
+	free_pi_state(pi_state, hb2);
 	double_unlock_hb(hb1, hb2);
 	hb_waiters_dec(hb2);
 
@@ -1725,8 +1736,6 @@ out_put_keys:
 out_put_key1:
 	put_futex_key(&key1);
 out:
-	if (pi_state != NULL)
-		free_pi_state(pi_state);
 	return ret ? ret : task_count;
 }
 
@@ -1850,14 +1859,15 @@ retry:
  * PI futexes can not be requeued and must remove themself from the
  * hash bucket. The hash bucket lock (i.e. lock_ptr) is held on entry
  * and dropped here.
+ * Must be called with the hb lock held.
  */
-static void unqueue_me_pi(struct futex_q *q)
+static void unqueue_me_pi(struct futex_q *q, struct futex_hash_bucket *hb)
 	__releases(q->lock_ptr)
 {
 	__unqueue_futex(q);
 
 	BUG_ON(!q->pi_state);
-	free_pi_state(q->pi_state);
+	free_pi_state(q->pi_state, hb);
 	q->pi_state = NULL;
 
 	spin_unlock(q->lock_ptr);
@@ -2340,7 +2350,7 @@ retry_private:
 		rt_mutex_unlock(&q.pi_state->pi_mutex);
 
 	/* Unqueue and drop the lock */
-	unqueue_me_pi(&q);
+	unqueue_me_pi(&q, hb);
 
 	goto out_put_key;
 
@@ -2651,7 +2661,7 @@ static int futex_wait_requeue_pi(u32 __user *uaddr, unsigned int flags,
 			ret = (res < 0) ? res : 0;
 
 		/* Unqueue and drop the lock. */
-		unqueue_me_pi(&q);
+		unqueue_me_pi(&q, hb);
 	}
 
 	/*
-- 
1.7.10.4

