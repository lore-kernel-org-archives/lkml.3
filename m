Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752976AbaFGB0B (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 21:26:01 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:36195 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752707AbaFGBXk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 21:23:40 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Kees Cook" <keescook@chromium.org>,
        "Linus Torvalds" <torvalds@linux-foundation.org>,
        "Darren Hart" <dvhart@linux.intel.com>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        "Will Drewry" <wad@chromium.org>, Pinkie@decadent.org.uk
Date: Sat, 07 Jun 2014 02:26:29 +0100
Message-ID: <lsq.1402104389.125698523@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 89/92] futex-prevent-requeue-pi-on-same-futex.patch
 futex: Forbid uaddr == uaddr2 in futex_requeue(..., requeue_pi=1)
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

commit e9c243a5a6de0be8e584c604d353412584b592f8 upstream.

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
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Darren Hart <dvhart@linux.intel.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 kernel/futex.c | 25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -1289,6 +1289,13 @@ static int futex_requeue(u32 __user *uad
 
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
@@ -1326,6 +1333,15 @@ retry:
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
 
@@ -2357,6 +2373,15 @@ static int futex_wait_requeue_pi(u32 __u
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
 

