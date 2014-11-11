Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752538AbaKKLYU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 06:24:20 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:57766 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754340AbaKKLLI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 06:11:08 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Brian Silverman <bsilver16384@gmail.com>, austin.linux@gmail.com,
        darren@dvhart.com, peterz@infradead.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 131/170] futex: Fix a race condition between REQUEUE_PI and task death
Date: Tue, 11 Nov 2014 11:08:10 +0000
Message-Id: <1415704129-12709-132-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1415704129-12709-1-git-send-email-luis.henriques@canonical.com>
References: <1415704129-12709-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Brian Silverman <bsilver16384@gmail.com>

commit 30a6b8031fe14031ab27c1fa3483cb9780e7f63c upstream.

free_pi_state and exit_pi_state_list both clean up futex_pi_state's.
exit_pi_state_list takes the hb lock first, and most callers of
free_pi_state do too. requeue_pi doesn't, which means free_pi_state
can free the pi_state out from under exit_pi_state_list. For example:

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

[ tglx: Removed a pointless free_pi_state() call and the hb->lock held
  	debugging. The latter comes via a seperate patch ]

Signed-off-by: Brian Silverman <bsilver16384@gmail.com>
Cc: austin.linux@gmail.com
Cc: darren@dvhart.com
Cc: peterz@infradead.org
Link: http://lkml.kernel.org/r/1414282837-23092-1-git-send-email-bsilver16384@gmail.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
[ luis: backported to 3.16: adjusted context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 kernel/futex.c | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/kernel/futex.c b/kernel/futex.c
index c5909b46af98..9fba3c706e2b 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -641,8 +641,14 @@ static struct futex_pi_state * alloc_pi_state(void)
 	return pi_state;
 }
 
+/*
+ * Must be called with the hb lock held.
+ */
 static void free_pi_state(struct futex_pi_state *pi_state)
 {
+	if (!pi_state)
+		return;
+
 	if (!atomic_dec_and_test(&pi_state->refcount))
 		return;
 
@@ -1554,15 +1560,6 @@ static int futex_requeue(u32 __user *uaddr1, unsigned int flags,
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
@@ -1652,6 +1649,8 @@ retry_private:
 		case 0:
 			break;
 		case -EFAULT:
+			free_pi_state(pi_state);
+			pi_state = NULL;
 			double_unlock_hb(hb1, hb2);
 			hb_waiters_dec(hb2);
 			put_futex_key(&key2);
@@ -1662,6 +1661,8 @@ retry_private:
 			goto out;
 		case -EAGAIN:
 			/* The owner was exiting, try again. */
+			free_pi_state(pi_state);
+			pi_state = NULL;
 			double_unlock_hb(hb1, hb2);
 			hb_waiters_dec(hb2);
 			put_futex_key(&key2);
@@ -1738,6 +1739,7 @@ retry_private:
 	}
 
 out_unlock:
+	free_pi_state(pi_state);
 	double_unlock_hb(hb1, hb2);
 	hb_waiters_dec(hb2);
 
@@ -1755,8 +1757,6 @@ out_put_keys:
 out_put_key1:
 	put_futex_key(&key1);
 out:
-	if (pi_state != NULL)
-		free_pi_state(pi_state);
 	return ret ? ret : task_count;
 }
 
-- 
2.1.0

