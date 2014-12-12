Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965586AbaLLG2N (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 01:28:13 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:52005 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759351AbaLLGQ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 01:16:59 -0500
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, austin.linux@gmail.com, darren@dvhart.com,
        "Thomas Gleixner" <tglx@linutronix.de>, peterz@infradead.org,
        "Brian Silverman" <bsilver16384@gmail.com>
Date: Fri, 12 Dec 2014 06:14:25 +0000
Message-ID: <lsq.1418364865.917167390@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 084/164] futex: Fix a race condition between
 REQUEUE_PI and task death
In-Reply-To: <lsq.1418364865.554543691@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:c97:8151:cc89:c28d
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.65-rc1 review patch.  If anyone has any objections, please let me know.

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
[bwh: Backported to 3.2: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 kernel/futex.c | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -484,8 +484,14 @@ static struct futex_pi_state * alloc_pi_
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
 
@@ -1399,15 +1405,6 @@ static int futex_requeue(u32 __user *uad
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
@@ -1495,6 +1492,8 @@ retry_private:
 		case 0:
 			break;
 		case -EFAULT:
+			free_pi_state(pi_state);
+			pi_state = NULL;
 			double_unlock_hb(hb1, hb2);
 			put_futex_key(&key2);
 			put_futex_key(&key1);
@@ -1504,6 +1503,8 @@ retry_private:
 			goto out;
 		case -EAGAIN:
 			/* The owner was exiting, try again. */
+			free_pi_state(pi_state);
+			pi_state = NULL;
 			double_unlock_hb(hb1, hb2);
 			put_futex_key(&key2);
 			put_futex_key(&key1);
@@ -1580,6 +1581,7 @@ retry_private:
 	}
 
 out_unlock:
+	free_pi_state(pi_state);
 	double_unlock_hb(hb1, hb2);
 
 	/*
@@ -1596,8 +1598,6 @@ out_put_keys:
 out_put_key1:
 	put_futex_key(&key1);
 out:
-	if (pi_state != NULL)
-		free_pi_state(pi_state);
 	return ret ? ret : task_count;
 }
 

