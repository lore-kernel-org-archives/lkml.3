Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758290AbaJaLGq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 07:06:46 -0400
Received: from mail-wg0-f43.google.com ([74.125.82.43]:58499 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757152AbaJaLGp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 07:06:45 -0400
Date: Fri, 31 Oct 2014 12:06:40 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "Paul E. McKenney" <paulmck@us.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] locking fixes
Message-ID: <20141031110640.GA25112@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest locking-urgent-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git locking-urgent-for-linus

   # HEAD: 30a6b8031fe14031ab27c1fa3483cb9780e7f63c futex: Fix a race condition between REQUEUE_PI and task death

This tree contains two futex fixes: one fixes a race condition, 
the other clarifies shared/private futex comments.

 Thanks,

	Ingo

------------------>
Brian Silverman (1):
      futex: Fix a race condition between REQUEUE_PI and task death

Davidlohr Bueso (1):
      futex: Mention key referencing differences between shared and private futexes


 kernel/futex.c | 36 +++++++++++++++++++++---------------
 1 file changed, 21 insertions(+), 15 deletions(-)

diff --git a/kernel/futex.c b/kernel/futex.c
index f3a3a071283c..63678b573d61 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -143,9 +143,8 @@
  *
  * Where (A) orders the waiters increment and the futex value read through
  * atomic operations (see hb_waiters_inc) and where (B) orders the write
- * to futex and the waiters read -- this is done by the barriers in
- * get_futex_key_refs(), through either ihold or atomic_inc, depending on the
- * futex type.
+ * to futex and the waiters read -- this is done by the barriers for both
+ * shared and private futexes in get_futex_key_refs().
  *
  * This yields the following case (where X:=waiters, Y:=futex):
  *
@@ -344,13 +343,20 @@ static void get_futex_key_refs(union futex_key *key)
 		futex_get_mm(key); /* implies MB (B) */
 		break;
 	default:
+		/*
+		 * Private futexes do not hold reference on an inode or
+		 * mm, therefore the only purpose of calling get_futex_key_refs
+		 * is because we need the barrier for the lockless waiter check.
+		 */
 		smp_mb(); /* explicit MB (B) */
 	}
 }
 
 /*
  * Drop a reference to the resource addressed by a key.
- * The hash bucket spinlock must not be held.
+ * The hash bucket spinlock must not be held. This is
+ * a no-op for private futexes, see comment in the get
+ * counterpart.
  */
 static void drop_futex_key_refs(union futex_key *key)
 {
@@ -641,8 +647,14 @@ static struct futex_pi_state * alloc_pi_state(void)
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
 
@@ -1521,15 +1533,6 @@ static int futex_requeue(u32 __user *uaddr1, unsigned int flags,
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
@@ -1619,6 +1622,8 @@ static int futex_requeue(u32 __user *uaddr1, unsigned int flags,
 		case 0:
 			break;
 		case -EFAULT:
+			free_pi_state(pi_state);
+			pi_state = NULL;
 			double_unlock_hb(hb1, hb2);
 			hb_waiters_dec(hb2);
 			put_futex_key(&key2);
@@ -1634,6 +1639,8 @@ static int futex_requeue(u32 __user *uaddr1, unsigned int flags,
 			 *   exit to complete.
 			 * - The user space value changed.
 			 */
+			free_pi_state(pi_state);
+			pi_state = NULL;
 			double_unlock_hb(hb1, hb2);
 			hb_waiters_dec(hb2);
 			put_futex_key(&key2);
@@ -1710,6 +1717,7 @@ static int futex_requeue(u32 __user *uaddr1, unsigned int flags,
 	}
 
 out_unlock:
+	free_pi_state(pi_state);
 	double_unlock_hb(hb1, hb2);
 	hb_waiters_dec(hb2);
 
@@ -1727,8 +1735,6 @@ static int futex_requeue(u32 __user *uaddr1, unsigned int flags,
 out_put_key1:
 	put_futex_key(&key1);
 out:
-	if (pi_state != NULL)
-		free_pi_state(pi_state);
 	return ret ? ret : task_count;
 }
 
