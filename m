Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755130AbaFXUbE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 16:31:04 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:47675 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755071AbaFXUa7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 16:30:59 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Will Drewry <wad@chromium.org>, Kees Cook <keescook@chromium.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 60/65] futex-prevent-requeue-pi-on-same-futex.patch futex: Forbid uaddr == uaddr2 in futex_requeue(..., requeue_pi=1)
Date: Tue, 24 Jun 2014 13:30:20 -0700
Message-Id: <1403641825-12825-61-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1403641825-12825-1-git-send-email-kamal@canonical.com>
References: <1403641825-12825-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.25 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 kernel/futex.c | 25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/kernel/futex.c b/kernel/futex.c
index ef88446..c845054 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -1289,6 +1289,13 @@ static int futex_requeue(u32 __user *uaddr1, unsigned int flags,
 
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
 
@@ -2357,6 +2373,15 @@ static int futex_wait_requeue_pi(u32 __user *uaddr, unsigned int flags,
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
1.9.1

