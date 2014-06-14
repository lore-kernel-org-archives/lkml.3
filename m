Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754012AbaFNUoO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jun 2014 16:44:14 -0400
Received: from 1wt.eu ([62.212.114.60]:42882 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753700AbaFNUoM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jun 2014 16:44:12 -0400
Message-Id: <20140614191250.294887894@1wt.eu>
User-Agent: quilt/0.48-1
Date: Sat, 14 Jun 2014 21:12:54 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Will Drewry <wad@chromium.org>, Kees Cook <keescook@chromium.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Willy Tarreau <w@1wt.eu>
Subject: [ 4/9] futex-prevent-requeue-pi-on-same-futex.patch futex:
In-Reply-To: <57d1129d02f4fc14423dd66474950cb7@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------
 Forbid uaddr == uaddr2 in futex_requeue(...,
 requeue_pi=1)

From: Thomas Gleixner <tglx@linutronix.de>

If uaddr == uaddr2, then we have broken the rule of only requeueing from
a non-pi futex to a pi futex with this call.  If we attempt this, then
dangling pointers may be left for rt_waiter resulting in an exploitable
condition.

This change brings futex_requeue() in line with futex_wait_requeue_pi()
which performs the same check as per commit 6f7b0a2a5c0f ("futex: Forbid
uaddr == uaddr2 in futex_wait_requeue_pi()")

[ tglx: Compare the resulting keys as well, as uaddrs might be
  	different depending on the mapping ]

Fixes CVE-2014-3153.

Reported-by: Pinkie Pie
Signed-off-by: Will Drewry <wad@chromium.org>
Signed-off-by: Kees Cook <keescook@chromium.org>
Cc: stable@vger.kernel.org
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Darren Hart <dvhart@linux.intel.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
(cherry picked from commit e9c243a5a6de0be8e584c604d353412584b592f8)
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 kernel/futex.c | 25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/kernel/futex.c b/kernel/futex.c
index c00b6e4..c894eab 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -1217,6 +1217,13 @@ static int futex_requeue(u32 __user *uaddr1, int fshared, u32 __user *uaddr2,
 
 	if (requeue_pi) {
 		/*
+		 * Requeue PI only works on two distinct uaddrs. This
+		 * check is only valid for private futexes. See below.
+		 */
+		if (uaddr1 == uaddr2)
+			return -EINVAL;
+
+		/*
 		 * requeue_pi requires a pi_state, try to allocate it now
 		 * without any locks in case it fails.
 		 */
@@ -1254,6 +1261,15 @@ retry:
 	if (unlikely(ret != 0))
 		goto out_put_key1;
 
+	/*
+	 * The check above which compares uaddrs is not sufficient for
+	 * shared futexes. We need to compare the keys:
+	 */
+	if (requeue_pi && match_futex(&key1, &key2)) {
+		ret = -EINVAL;
+		goto out_put_keys;
+	}
+
 	hb1 = hash_futex(&key1);
 	hb2 = hash_futex(&key2);
 
@@ -2311,6 +2327,15 @@ static int futex_wait_requeue_pi(u32 __user *uaddr, int fshared,
 	if (ret)
 		goto out_key2;
 
+	/*
+	 * The check above which compares uaddrs is not sufficient for
+	 * shared futexes. We need to compare the keys:
+	 */
+	if (match_futex(&q.key, &key2)) {
+		ret = -EINVAL;
+		goto out_put_keys;
+	}
+
 	/* Queue the futex_q, drop the hb lock, wait for wakeup. */
 	futex_wait_queue_me(hb, &q, to);
 
-- 
1.7.12.2.21.g234cd45.dirty



