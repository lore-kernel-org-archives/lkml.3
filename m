Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756900AbbAPT2M (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 14:28:12 -0500
Received: from mail-wg0-f49.google.com ([74.125.82.49]:42603 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756829AbbAPT2J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 14:28:09 -0500
Message-ID: <54B96646.8010200@gmail.com>
Date: Fri, 16 Jan 2015 20:28:06 +0100
From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: mtk.manpages@gmail.com, lkml <linux-kernel@vger.kernel.org>,
        Darren Hart <darren@dvhart.com>, Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 2/2] futex: Fix argument handling in futex_lock_pi() calls
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Kerrisk <mtk.manpages@gmail.com>

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

---
Seems obviously safe, but in any case compiled, tested, and booted
on my x86 system.

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
-- 
1.9.3

-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
