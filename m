Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753869AbaFGBtF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 21:49:05 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:35922 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752456AbaFGBXg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 21:23:36 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Kees Cook" <keescook@chromium.org>,
        "Linus Torvalds" <torvalds@linux-foundation.org>,
        "Will Drewry" <wad@chromium.org>,
        "Darren Hart" <dvhart@linux.intel.com>,
        "Thomas Gleixner" <tglx@linutronix.de>
Date: Sat, 07 Jun 2014 02:26:29 +0100
Message-ID: <lsq.1402104389.355592398@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 91/92] futex: Always cleanup owner tid in unlock_pi
In-Reply-To: <lsq.1402104388.385007124@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.60-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 kernel/futex.c | 40 ++++++++++++++++++----------------------
 1 file changed, 18 insertions(+), 22 deletions(-)

--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -899,6 +899,7 @@ static int wake_futex_pi(u32 __user *uad
 	struct task_struct *new_owner;
 	struct futex_pi_state *pi_state = this->pi_state;
 	u32 uninitialized_var(curval), newval;
+	int ret = 0;
 
 	if (!pi_state)
 		return -EINVAL;
@@ -922,23 +923,19 @@ static int wake_futex_pi(u32 __user *uad
 		new_owner = this->task;
 
 	/*
-	 * We pass it to the next owner. (The WAITERS bit is always
-	 * kept enabled while there is PI state around. We must also
-	 * preserve the owner died bit.)
-	 */
-	if (!(uval & FUTEX_OWNER_DIED)) {
-		int ret = 0;
-
-		newval = FUTEX_WAITERS | task_pid_vnr(new_owner);
-
-		if (cmpxchg_futex_value_locked(&curval, uaddr, uval, newval))
-			ret = -EFAULT;
-		else if (curval != uval)
-			ret = -EINVAL;
-		if (ret) {
-			raw_spin_unlock(&pi_state->pi_mutex.wait_lock);
-			return ret;
-		}
+	 * We pass it to the next owner. The WAITERS bit is always
+	 * kept enabled while there is PI state around. We cleanup the
+	 * owner died bit, because we are the owner.
+	 */
+	newval = FUTEX_WAITERS | task_pid_vnr(new_owner);
+
+	if (cmpxchg_futex_value_locked(&curval, uaddr, uval, newval))
+		ret = -EFAULT;
+	else if (curval != uval)
+		ret = -EINVAL;
+	if (ret) {
+		raw_spin_unlock(&pi_state->pi_mutex.wait_lock);
+		return ret;
 	}
 
 	raw_spin_lock_irq(&pi_state->owner->pi_lock);
@@ -2183,9 +2180,10 @@ retry:
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
@@ -2217,11 +2215,9 @@ retry:
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

