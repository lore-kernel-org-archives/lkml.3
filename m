Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751762AbaJZPXH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Oct 2014 11:23:07 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34863 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751664AbaJZPXF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Oct 2014 11:23:05 -0400
Date: Sun, 26 Oct 2014 08:22:46 -0700
From: tip-bot for Brian Silverman <tipbot@zytor.com>
Message-ID: <tip-30a6b8031fe14031ab27c1fa3483cb9780e7f63c@git.kernel.org>
Cc: bsilver16384@gmail.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, mingo@kernel.org
Reply-To: mingo@kernel.org, tglx@linutronix.de, hpa@zytor.com,
        linux-kernel@vger.kernel.org, bsilver16384@gmail.com
In-Reply-To: <1414282837-23092-1-git-send-email-bsilver16384@gmail.com>
References: <1414282837-23092-1-git-send-email-bsilver16384@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:locking/urgent] futex:
  Fix a race condition between REQUEUE_PI and task death
Git-Commit-ID: 30a6b8031fe14031ab27c1fa3483cb9780e7f63c
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

Commit-ID:  30a6b8031fe14031ab27c1fa3483cb9780e7f63c
Gitweb:     http://git.kernel.org/tip/30a6b8031fe14031ab27c1fa3483cb9780e7f63c
Author:     Brian Silverman <bsilver16384@gmail.com>
AuthorDate: Sat, 25 Oct 2014 20:20:37 -0400
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Sun, 26 Oct 2014 16:16:18 +0100

futex: Fix a race condition between REQUEUE_PI and task death

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
Cc: stable@vger.kernel.org
Link: http://lkml.kernel.org/r/1414282837-23092-1-git-send-email-bsilver16384@gmail.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/futex.c | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/kernel/futex.c b/kernel/futex.c
index bbf071f..63678b5 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -647,8 +647,14 @@ static struct futex_pi_state * alloc_pi_state(void)
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
 
@@ -1527,15 +1533,6 @@ static int futex_requeue(u32 __user *uaddr1, unsigned int flags,
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
@@ -1625,6 +1622,8 @@ retry_private:
 		case 0:
 			break;
 		case -EFAULT:
+			free_pi_state(pi_state);
+			pi_state = NULL;
 			double_unlock_hb(hb1, hb2);
 			hb_waiters_dec(hb2);
 			put_futex_key(&key2);
@@ -1640,6 +1639,8 @@ retry_private:
 			 *   exit to complete.
 			 * - The user space value changed.
 			 */
+			free_pi_state(pi_state);
+			pi_state = NULL;
 			double_unlock_hb(hb1, hb2);
 			hb_waiters_dec(hb2);
 			put_futex_key(&key2);
@@ -1716,6 +1717,7 @@ retry_private:
 	}
 
 out_unlock:
+	free_pi_state(pi_state);
 	double_unlock_hb(hb1, hb2);
 	hb_waiters_dec(hb2);
 
@@ -1733,8 +1735,6 @@ out_put_keys:
 out_put_key1:
 	put_futex_key(&key1);
 out:
-	if (pi_state != NULL)
-		free_pi_state(pi_state);
 	return ret ? ret : task_count;
 }
 
