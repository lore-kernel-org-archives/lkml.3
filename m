Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755286AbaFUUeb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jun 2014 16:34:31 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34828 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755178AbaFUUe3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jun 2014 16:34:29 -0400
Date: Sat, 21 Jun 2014 13:33:17 -0700
From: tip-bot for Thomas Gleixner <tipbot@zytor.com>
Message-ID: <tip-ccf9e6a80d9e1b9df69c98e6b9745cf49869ee15@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        darren@dvhart.com, peterz@infradead.org, kees@outflux.net,
        tglx@linutronix.de, davidlohr@hp.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, darren@dvhart.com, kees@outflux.net,
        tglx@linutronix.de, davidlohr@hp.com
In-Reply-To: <20140611204237.016987332@linutronix.de>
References: <20140611204237.016987332@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:locking/core] futex: Make unlock_pi more robust
Git-Commit-ID: ccf9e6a80d9e1b9df69c98e6b9745cf49869ee15
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

Commit-ID:  ccf9e6a80d9e1b9df69c98e6b9745cf49869ee15
Gitweb:     http://git.kernel.org/tip/ccf9e6a80d9e1b9df69c98e6b9745cf49869ee15
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Wed, 11 Jun 2014 20:45:38 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Sat, 21 Jun 2014 22:26:23 +0200

futex: Make unlock_pi more robust

The kernel tries to atomically unlock the futex without checking
whether there is kernel state associated to the futex.

So if user space manipulated the user space value, this will leave
kernel internal state around associated to the owner task. 

For robustness sake, lookup first whether there are waiters on the
futex. If there are waiters, wake the top priority waiter with all the
proper sanity checks applied.

If there are no waiters, do the atomic release. We do not have to
preserve the waiters bit in this case, because a potentially incoming
waiter is blocked on the hb->lock and will acquire the futex
atomically. We neither have to preserve the owner died bit. The caller
is the owner and it was supposed to cleanup the mess.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Darren Hart <darren@dvhart.com>
Cc: Davidlohr Bueso <davidlohr@hp.com>
Cc: Kees Cook <kees@outflux.net>
Cc: wad@chromium.org
Link: http://lkml.kernel.org/r/20140611204237.016987332@linutronix.de
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/futex.c | 76 +++++++++++++++++++---------------------------------------
 1 file changed, 25 insertions(+), 51 deletions(-)

diff --git a/kernel/futex.c b/kernel/futex.c
index e5c6c40..346d5c2 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -1186,22 +1186,6 @@ static int wake_futex_pi(u32 __user *uaddr, u32 uval, struct futex_q *this)
 	return 0;
 }
 
-static int unlock_futex_pi(u32 __user *uaddr, u32 uval)
-{
-	u32 uninitialized_var(oldval);
-
-	/*
-	 * There is no waiter, so we unlock the futex. The owner died
-	 * bit has not to be preserved here. We are the owner:
-	 */
-	if (cmpxchg_futex_value_locked(&oldval, uaddr, uval, 0))
-		return -EFAULT;
-	if (oldval != uval)
-		return -EAGAIN;
-
-	return 0;
-}
-
 /*
  * Express the locking dependencies for lockdep:
  */
@@ -2401,10 +2385,10 @@ uaddr_faulted:
  */
 static int futex_unlock_pi(u32 __user *uaddr, unsigned int flags)
 {
-	struct futex_hash_bucket *hb;
-	struct futex_q *this, *next;
+	u32 uninitialized_var(curval), uval, vpid = task_pid_vnr(current);
 	union futex_key key = FUTEX_KEY_INIT;
-	u32 uval, vpid = task_pid_vnr(current);
+	struct futex_hash_bucket *hb;
+	struct futex_q *match;
 	int ret;
 
 retry:
@@ -2417,57 +2401,47 @@ retry:
 		return -EPERM;
 
 	ret = get_futex_key(uaddr, flags & FLAGS_SHARED, &key, VERIFY_WRITE);
-	if (unlikely(ret != 0))
-		goto out;
+	if (ret)
+		return ret;
 
 	hb = hash_futex(&key);
 	spin_lock(&hb->lock);
 
 	/*
-	 * To avoid races, try to do the TID -> 0 atomic transition
-	 * again. If it succeeds then we can return without waking
-	 * anyone else up. We only try this if neither the waiters nor
-	 * the owner died bit are set.
+	 * Check waiters first. We do not trust user space values at
+	 * all and we at least want to know if user space fiddled
+	 * with the futex value instead of blindly unlocking.
 	 */
-	if (!(uval & ~FUTEX_TID_MASK) &&
-	    cmpxchg_futex_value_locked(&uval, uaddr, vpid, 0))
-		goto pi_faulted;
-	/*
-	 * Rare case: we managed to release the lock atomically,
-	 * no need to wake anyone else up:
-	 */
-	if (unlikely(uval == vpid))
-		goto out_unlock;
-
-	/*
-	 * Ok, other tasks may need to be woken up - check waiters
-	 * and do the wakeup if necessary:
-	 */
-	plist_for_each_entry_safe(this, next, &hb->chain, list) {
-		if (!match_futex (&this->key, &key))
-			continue;
-		ret = wake_futex_pi(uaddr, uval, this);
+	match = futex_top_waiter(hb, &key);
+	if (match) {
+		ret = wake_futex_pi(uaddr, uval, match);
 		/*
-		 * The atomic access to the futex value
-		 * generated a pagefault, so retry the
-		 * user-access and the wakeup:
+		 * The atomic access to the futex value generated a
+		 * pagefault, so retry the user-access and the wakeup:
 		 */
 		if (ret == -EFAULT)
 			goto pi_faulted;
 		goto out_unlock;
 	}
+
 	/*
-	 * No waiters - kernel unlocks the futex:
+	 * We have no kernel internal state, i.e. no waiters in the
+	 * kernel. Waiters which are about to queue themselves are stuck
+	 * on hb->lock. So we can safely ignore them. We do neither
+	 * preserve the WAITERS bit not the OWNER_DIED one. We are the
+	 * owner.
 	 */
-	ret = unlock_futex_pi(uaddr, uval);
-	if (ret == -EFAULT)
+	if (cmpxchg_futex_value_locked(&curval, uaddr, uval, 0))
 		goto pi_faulted;
 
+	/*
+	 * If uval has changed, let user space handle it.
+	 */
+	ret = (curval == uval) ? 0 : -EAGAIN;
+
 out_unlock:
 	spin_unlock(&hb->lock);
 	put_futex_key(&key);
-
-out:
 	return ret;
 
 pi_faulted:
