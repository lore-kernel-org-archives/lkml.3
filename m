Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752115AbbASLKn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 06:10:43 -0500
Received: from terminus.zytor.com ([198.137.202.10]:43077 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751194AbbASLKk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 06:10:40 -0500
Date: Mon, 19 Jan 2015 03:10:28 -0800
From: tip-bot for Michael Kerrisk <tipbot@zytor.com>
Message-ID: <tip-996636ddae5cab8883bd76b996cd4f2ea9a152be@git.kernel.org>
Cc: hpa@zytor.com, darren@dvhart.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, mingo@kernel.org, mtk.manpages@gmail.com
Reply-To: mtk.manpages@gmail.com, mingo@kernel.org,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, darren@dvhart.com,
        hpa@zytor.com
In-Reply-To: <54B96646.8010200@gmail.com>
References: <54B96646.8010200@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:locking/core] futex: Fix argument handling in futex_lock_pi(
 ) calls
Git-Commit-ID: 996636ddae5cab8883bd76b996cd4f2ea9a152be
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

Commit-ID:  996636ddae5cab8883bd76b996cd4f2ea9a152be
Gitweb:     http://git.kernel.org/tip/996636ddae5cab8883bd76b996cd4f2ea9a152be
Author:     Michael Kerrisk <mtk.manpages@gmail.com>
AuthorDate: Fri, 16 Jan 2015 20:28:06 +0100
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Mon, 19 Jan 2015 12:05:32 +0100

futex: Fix argument handling in futex_lock_pi() calls

This patch fixes two separate buglets in calls to futex_lock_pi():

  * Eliminate unused 'detect' argument
  * Change unused 'timeout' argument of FUTEX_TRYLOCK_PI to NULL

The 'detect' argument of futex_lock_pi() seems never to have been
used (when it was included with the initial PI mutex implementation
in Linux 2.6.18, all checks against its value were disabled by
ANDing against 0 (i.e., if (detect... && 0)), and with
commit 778e9a9c3e7193ea9f434f382947155ffb59c755, any mention of
this argument in futex_lock_pi() went way altogether. Its presence
now serves only to confuse readers of the code, by giving the
impression that the futex() FUTEX_LOCK_PI operation actually does
use the 'val' argument. This patch removes the argument.

The futex_lock_pi() call that corresponds to FUTEX_TRYLOCK_PI includes
'timeout' as one of its arguments. This misleads the reader into thinking
that the FUTEX_TRYLOCK_PI operation does employ timeouts for some sensible
purpose; but it does not.  Indeed, it cannot, because the checks at the
start of sys_futex() exclude FUTEX_TRYLOCK_PI from the set of operations
that do copy_from_user() on the timeout argument. So, in the
FUTEX_TRYLOCK_PI futex_lock_pi() call it would be simplest to change
'timeout' to 'NULL'. This patch does that.

Signed-off-by: Michael Kerrisk <mtk.manpages@gmail.com>
Reviewed-by: Darren Hart <darren@dvhart.com>
Link: http://lkml.kernel.org/r/54B96646.8010200@gmail.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

---
 kernel/futex.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/futex.c b/kernel/futex.c
index 63678b5..4eeb63d 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -2258,7 +2258,7 @@ static long futex_wait_restart(struct restart_block *restart)
  * if there are waiters then it will block, it does PI, etc. (Due to
  * races the kernel might see a 0 value of the futex too.)
  */
-static int futex_lock_pi(u32 __user *uaddr, unsigned int flags, int detect,
+static int futex_lock_pi(u32 __user *uaddr, unsigned int flags,
 			 ktime_t *time, int trylock)
 {
 	struct hrtimer_sleeper timeout, *to = NULL;
@@ -2953,11 +2953,11 @@ long do_futex(u32 __user *uaddr, int op, u32 val, ktime_t *timeout,
 	case FUTEX_WAKE_OP:
 		return futex_wake_op(uaddr, flags, uaddr2, val, val2, val3);
 	case FUTEX_LOCK_PI:
-		return futex_lock_pi(uaddr, flags, val, timeout, 0);
+		return futex_lock_pi(uaddr, flags, timeout, 0);
 	case FUTEX_UNLOCK_PI:
 		return futex_unlock_pi(uaddr, flags);
 	case FUTEX_TRYLOCK_PI:
-		return futex_lock_pi(uaddr, flags, 0, timeout, 1);
+		return futex_lock_pi(uaddr, flags, NULL, 1);
 	case FUTEX_WAIT_REQUEUE_PI:
 		val3 = FUTEX_BITSET_MATCH_ANY;
 		return futex_wait_requeue_pi(uaddr, flags, val, timeout, val3,
