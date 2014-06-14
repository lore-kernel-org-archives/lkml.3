Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754163AbaFNUod (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jun 2014 16:44:33 -0400
Received: from 1wt.eu ([62.212.114.60]:42892 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751922AbaFNUob (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jun 2014 16:44:31 -0400
Message-Id: <20140614191250.376143427@1wt.eu>
User-Agent: quilt/0.48-1
Date: Sat, 14 Jun 2014 21:12:56 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>, Kees Cook <keescook@chromium.org>,
        Will Drewry <wad@chromium.org>, Darren Hart <dvhart@linux.intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Willy Tarreau <w@1wt.eu>
Subject: [ 6/9] futex: Always cleanup owner tid in unlock_pi
In-Reply-To: <57d1129d02f4fc14423dd66474950cb7@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Gleixner <tglx@linutronix.de>

If the owner died bit is set at futex_unlock_pi, we currently do not
cleanup the user space futex.  So the owner TID of the current owner
(the unlocker) persists.  That's observable inconsistant state,
especially when the ownership of the pi state got transferred.

Clean it up unconditionally.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Kees Cook <keescook@chromium.org>
Cc: Will Drewry <wad@chromium.org>
Cc: Darren Hart <dvhart@linux.intel.com>
Cc: stable@vger.kernel.org
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
(cherry picked from commit 13fbca4c6ecd96ec1a1cfa2e4f2ce191fe928a5e)
[wt: adjusted context - cmpxchg_futex_value_locked() takes 3 args]
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 kernel/futex.c | 42 +++++++++++++++++++-----------------------
 1 file changed, 19 insertions(+), 23 deletions(-)

diff --git a/kernel/futex.c b/kernel/futex.c
index f77a945..b09ef35 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -827,6 +827,7 @@ static int wake_futex_pi(u32 __user *uaddr, u32 uval, struct futex_q *this)
 	struct task_struct *new_owner;
 	struct futex_pi_state *pi_state = this->pi_state;
 	u32 curval, newval;
+	int ret = 0;
 
 	if (!pi_state)
 		return -EINVAL;
@@ -851,25 +852,21 @@ static int wake_futex_pi(u32 __user *uaddr, u32 uval, struct futex_q *this)
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
 
-		curval = cmpxchg_futex_value_locked(uaddr, uval, newval);
+	curval = cmpxchg_futex_value_locked(uaddr, uval, newval);
 
-		if (curval == -EFAULT)
-			ret = -EFAULT;
-		else if (curval != uval)
-			ret = -EINVAL;
-		if (ret) {
-			spin_unlock(&pi_state->pi_mutex.wait_lock);
-			return ret;
-		}
+	if (curval == -EFAULT)
+		ret = -EFAULT;
+	else if (curval != uval)
+		ret = -EINVAL;
+	if (ret) {
+		spin_unlock(&pi_state->pi_mutex.wait_lock);
+		return ret;
 	}
 
 	spin_lock_irq(&pi_state->owner->pi_lock);
@@ -2133,9 +2130,10 @@ retry:
 	/*
 	 * To avoid races, try to do the TID -> 0 atomic transition
 	 * again. If it succeeds then we can return without waking
-	 * anyone else up:
+	 * anyone else up. We only try this if neither the waiters nor
+	 * the owner died bit are set.
 	 */
-	if (!(uval & FUTEX_OWNER_DIED))
+	if (!(uval & ~FUTEX_TID_MASK))
 		uval = cmpxchg_futex_value_locked(uaddr, task_pid_vnr(current), 0);
 
 
@@ -2170,11 +2168,9 @@ retry:
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
1.7.12.2.21.g234cd45.dirty



