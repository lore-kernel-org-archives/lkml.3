Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755071AbaFWNNx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 09:13:53 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:37160 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754686AbaFWNFJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 09:05:09 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Thomas Gleixner <tglx@linutronix.de>, Kees Cook <keescook@chromium.org>,
        Will Drewry <wad@chromium.org>, Darren Hart <dvhart@linux.intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 70/93] futex: Always cleanup owner tid in unlock_pi
Date: Mon, 23 Jun 2014 14:02:49 +0100
Message-Id: <1403528592-2163-71-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1403528592-2163-1-git-send-email-luis.henriques@canonical.com>
References: <1403528592-2163-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.12 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Gleixner <tglx@linutronix.de>

commit 13fbca4c6ecd96ec1a1cfa2e4f2ce191fe928a5e upstream.

If the owner died bit is set at futex_unlock_pi, we currently do not
cleanup the user space futex.  So the owner TID of the current owner
(the unlocker) persists.  That's observable inconsistant state,
especially when the ownership of the pi state got transferred.

Clean it up unconditionally.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Kees Cook <keescook@chromium.org>
Cc: Will Drewry <wad@chromium.org>
Cc: Darren Hart <dvhart@linux.intel.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 kernel/futex.c | 40 ++++++++++++++++++----------------------
 1 file changed, 18 insertions(+), 22 deletions(-)

diff --git a/kernel/futex.c b/kernel/futex.c
index d467b4972470..6edcc9aa0dfe 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -904,6 +904,7 @@ static int wake_futex_pi(u32 __user *uaddr, u32 uval, struct futex_q *this)
 	struct task_struct *new_owner;
 	struct futex_pi_state *pi_state = this->pi_state;
 	u32 uninitialized_var(curval), newval;
+	int ret = 0;
 
 	if (!pi_state)
 		return -EINVAL;
@@ -927,23 +928,19 @@ static int wake_futex_pi(u32 __user *uaddr, u32 uval, struct futex_q *this)
 		new_owner = this->task;
 
 	/*
-	 * We pass it to the next owner. (The WAITERS bit is always
-	 * kept enabled while there is PI state around. We must also
-	 * preserve the owner died bit.)
+	 * We pass it to the next owner. The WAITERS bit is always
+	 * kept enabled while there is PI state around. We cleanup the
+	 * owner died bit, because we are the owner.
 	 */
-	if (!(uval & FUTEX_OWNER_DIED)) {
-		int ret = 0;
-
-		newval = FUTEX_WAITERS | task_pid_vnr(new_owner);
+	newval = FUTEX_WAITERS | task_pid_vnr(new_owner);
 
-		if (cmpxchg_futex_value_locked(&curval, uaddr, uval, newval))
-			ret = -EFAULT;
-		else if (curval != uval)
-			ret = -EINVAL;
-		if (ret) {
-			raw_spin_unlock(&pi_state->pi_mutex.wait_lock);
-			return ret;
-		}
+	if (cmpxchg_futex_value_locked(&curval, uaddr, uval, newval))
+		ret = -EFAULT;
+	else if (curval != uval)
+		ret = -EINVAL;
+	if (ret) {
+		raw_spin_unlock(&pi_state->pi_mutex.wait_lock);
+		return ret;
 	}
 
 	raw_spin_lock_irq(&pi_state->owner->pi_lock);
@@ -2188,9 +2185,10 @@ retry:
 	/*
 	 * To avoid races, try to do the TID -> 0 atomic transition
 	 * again. If it succeeds then we can return without waking
-	 * anyone else up:
+	 * anyone else up. We only try this if neither the waiters nor
+	 * the owner died bit are set.
 	 */
-	if (!(uval & FUTEX_OWNER_DIED) &&
+	if (!(uval & ~FUTEX_TID_MASK) &&
 	    cmpxchg_futex_value_locked(&uval, uaddr, vpid, 0))
 		goto pi_faulted;
 	/*
@@ -2222,11 +2220,9 @@ retry:
 	/*
 	 * No waiters - kernel unlocks the futex:
 	 */
-	if (!(uval & FUTEX_OWNER_DIED)) {
-		ret = unlock_futex_pi(uaddr, uval);
-		if (ret == -EFAULT)
-			goto pi_faulted;
-	}
+	ret = unlock_futex_pi(uaddr, uval);
+	if (ret == -EFAULT)
+		goto pi_faulted;
 
 out_unlock:
 	spin_unlock(&hb->lock);
-- 
1.9.1

