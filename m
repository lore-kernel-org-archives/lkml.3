Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755373AbaFUUek (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jun 2014 16:34:40 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34843 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755295AbaFUUeh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jun 2014 16:34:37 -0400
Date: Sat, 21 Jun 2014 13:33:31 -0700
From: tip-bot for Thomas Gleixner <tipbot@zytor.com>
Message-ID: <tip-bd1dbcc67cd2c1181e2c01daac51eabf1b964dd8@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, darren@dvhart.com, kees@outflux.net,
        tglx@linutronix.de, davidlohr@hp.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        darren@dvhart.com, peterz@infradead.org, kees@outflux.net,
        tglx@linutronix.de, davidlohr@hp.com
In-Reply-To: <20140611204237.092947239@linutronix.de>
References: <20140611204237.092947239@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:locking/core] futex: Use futex_top_waiter()
  in lookup_pi_state()
Git-Commit-ID: bd1dbcc67cd2c1181e2c01daac51eabf1b964dd8
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

Commit-ID:  bd1dbcc67cd2c1181e2c01daac51eabf1b964dd8
Gitweb:     http://git.kernel.org/tip/bd1dbcc67cd2c1181e2c01daac51eabf1b964dd8
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Wed, 11 Jun 2014 20:45:39 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Sat, 21 Jun 2014 22:26:23 +0200

futex: Use futex_top_waiter() in lookup_pi_state()

No point in open coding the same function again.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Darren Hart <darren@dvhart.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Davidlohr Bueso <davidlohr@hp.com>
Cc: Kees Cook <kees@outflux.net>
Cc: wad@chromium.org
Link: http://lkml.kernel.org/r/20140611204237.092947239@linutronix.de
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/futex.c | 124 ++++++++++++++++++++++++++++-----------------------------
 1 file changed, 61 insertions(+), 63 deletions(-)

diff --git a/kernel/futex.c b/kernel/futex.c
index 346d5c2..fff1ed9 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -796,87 +796,85 @@ static int
 lookup_pi_state(u32 uval, struct futex_hash_bucket *hb,
 		union futex_key *key, struct futex_pi_state **ps)
 {
+	struct futex_q *match = futex_top_waiter(hb, key);
 	struct futex_pi_state *pi_state = NULL;
-	struct futex_q *this, *next;
 	struct task_struct *p;
 	pid_t pid = uval & FUTEX_TID_MASK;
 
-	plist_for_each_entry_safe(this, next, &hb->chain, list) {
-		if (match_futex(&this->key, key)) {
-			/*
-			 * Sanity check the waiter before increasing
-			 * the refcount and attaching to it.
-			 */
-			pi_state = this->pi_state;
-			/*
-			 * Userspace might have messed up non-PI and
-			 * PI futexes [3]
-			 */
-			if (unlikely(!pi_state))
-				return -EINVAL;
+	if (match) {
+		/*
+		 * Sanity check the waiter before increasing the
+		 * refcount and attaching to it.
+		 */
+		pi_state = match->pi_state;
+		/*
+		 * Userspace might have messed up non-PI and PI
+		 * futexes [3]
+		 */
+		if (unlikely(!pi_state))
+			return -EINVAL;
 
-			WARN_ON(!atomic_read(&pi_state->refcount));
+		WARN_ON(!atomic_read(&pi_state->refcount));
 
+		/*
+		 * Handle the owner died case:
+		 */
+		if (uval & FUTEX_OWNER_DIED) {
 			/*
-			 * Handle the owner died case:
+			 * exit_pi_state_list sets owner to NULL and
+			 * wakes the topmost waiter. The task which
+			 * acquires the pi_state->rt_mutex will fixup
+			 * owner.
 			 */
-			if (uval & FUTEX_OWNER_DIED) {
+			if (!pi_state->owner) {
 				/*
-				 * exit_pi_state_list sets owner to NULL and
-				 * wakes the topmost waiter. The task which
-				 * acquires the pi_state->rt_mutex will fixup
-				 * owner.
+				 * No pi state owner, but the user
+				 * space TID is not 0. Inconsistent
+				 * state. [5]
 				 */
-				if (!pi_state->owner) {
-					/*
-					 * No pi state owner, but the user
-					 * space TID is not 0. Inconsistent
-					 * state. [5]
-					 */
-					if (pid)
-						return -EINVAL;
-					/*
-					 * Take a ref on the state and
-					 * return. [4]
-					 */
-					goto out_state;
-				}
-
-				/*
-				 * If TID is 0, then either the dying owner
-				 * has not yet executed exit_pi_state_list()
-				 * or some waiter acquired the rtmutex in the
-				 * pi state, but did not yet fixup the TID in
-				 * user space.
-				 *
-				 * Take a ref on the state and return. [6]
-				 */
-				if (!pid)
-					goto out_state;
-			} else {
+				if (pid)
+					return -EINVAL;
 				/*
-				 * If the owner died bit is not set,
-				 * then the pi_state must have an
-				 * owner. [7]
+				 * Take a ref on the state and
+				 * return. [4]
 				 */
-				if (!pi_state->owner)
-					return -EINVAL;
+				goto out_state;
 			}
 
 			/*
-			 * Bail out if user space manipulated the
-			 * futex value. If pi state exists then the
-			 * owner TID must be the same as the user
-			 * space TID. [9/10]
+			 * If TID is 0, then either the dying owner
+			 * has not yet executed exit_pi_state_list()
+			 * or some waiter acquired the rtmutex in the
+			 * pi state, but did not yet fixup the TID in
+			 * user space.
+			 *
+			 * Take a ref on the state and return. [6]
+			 */
+			if (!pid)
+				goto out_state;
+		} else {
+			/*
+			 * If the owner died bit is not set,
+			 * then the pi_state must have an
+			 * owner. [7]
 			 */
-			if (pid != task_pid_vnr(pi_state->owner))
+			if (!pi_state->owner)
 				return -EINVAL;
-
-		out_state:
-			atomic_inc(&pi_state->refcount);
-			*ps = pi_state;
-			return 0;
 		}
+
+		/*
+		 * Bail out if user space manipulated the
+		 * futex value. If pi state exists then the
+		 * owner TID must be the same as the user
+		 * space TID. [9/10]
+		 */
+		if (pid != task_pid_vnr(pi_state->owner))
+			return -EINVAL;
+
+	out_state:
+		atomic_inc(&pi_state->refcount);
+		*ps = pi_state;
+		return 0;
 	}
 
 	/*
