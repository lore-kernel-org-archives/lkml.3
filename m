Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755403AbaJWTXA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 15:23:00 -0400
Received: from mail-yh0-f54.google.com ([209.85.213.54]:64910 "EHLO
	mail-yh0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751700AbaJWTW6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 15:22:58 -0400
From: Brian Silverman <bsilver16384@gmail.com>
To: tglx@linutronix.de
Cc: austin.linux@gmail.com, linux-kernel@vger.kernel.org,
        Brian Silverman <bsilver16384@gmail.com>
Subject: [PATCH] futex: fix a race condition between REQUEUE_PI and task death
Date: Thu, 23 Oct 2014 15:22:39 -0400
Message-Id: <1414092159-17697-1-git-send-email-bsilver16384@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

pi_state_free and exit_pi_state_list both clean up futex_pi_state's.
exit_pi_state_list takes the hb lock first, and most callers of
pi_state_free do too. requeue_pi didn't, which causes lots of problems.
Move the pi_state_free calls in requeue_pi to before it drops the hb
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
I am not subscribed to the list so please CC me on any responses.

 kernel/futex.c |   32 +++++++++++++++++++++-----------
 1 file changed, 21 insertions(+), 11 deletions(-)

diff --git a/kernel/futex.c b/kernel/futex.c
index 815d7af..dc69775 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -639,6 +639,9 @@ static struct futex_pi_state * alloc_pi_state(void)
 	return pi_state;
 }
 
+/**
+ * Must be called with the hb lock held.
+ */
 static void free_pi_state(struct futex_pi_state *pi_state)
 {
 	if (!atomic_dec_and_test(&pi_state->refcount))
@@ -1519,15 +1522,6 @@ static int futex_requeue(u32 __user *uaddr1, unsigned int flags,
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
@@ -1558,6 +1552,14 @@ retry_private:
 		ret = get_futex_value_locked(&curval, uaddr1);
 
 		if (unlikely(ret)) {
+			if (flags & FLAGS_SHARED && pi_state != NULL) {
+				/*
+				 * We will have to lookup the pi_state again, so
+				 * free this one to keep the accounting correct.
+				 */
+				free_pi_state(pi_state);
+				pi_state = NULL;
+			}
 			double_unlock_hb(hb1, hb2);
 			hb_waiters_dec(hb2);
 
@@ -1617,6 +1619,10 @@ retry_private:
 		case 0:
 			break;
 		case -EFAULT:
+			if (pi_state != NULL) {
+				free_pi_state(pi_state);
+				pi_state = NULL;
+			}
 			double_unlock_hb(hb1, hb2);
 			hb_waiters_dec(hb2);
 			put_futex_key(&key2);
@@ -1632,6 +1638,10 @@ retry_private:
 			 *   exit to complete.
 			 * - The user space value changed.
 			 */
+			if (pi_state != NULL) {
+				free_pi_state(pi_state);
+				pi_state = NULL;
+			}
 			double_unlock_hb(hb1, hb2);
 			hb_waiters_dec(hb2);
 			put_futex_key(&key2);
@@ -1708,6 +1718,8 @@ retry_private:
 	}
 
 out_unlock:
+	if (pi_state != NULL)
+		free_pi_state(pi_state);
 	double_unlock_hb(hb1, hb2);
 	hb_waiters_dec(hb2);
 
@@ -1725,8 +1737,6 @@ out_put_keys:
 out_put_key1:
 	put_futex_key(&key1);
 out:
-	if (pi_state != NULL)
-		free_pi_state(pi_state);
 	return ret ? ret : task_count;
 }
 
-- 
1.7.10.4

