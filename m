Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932312AbaFIJ03 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 05:26:29 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:59137 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755410AbaFIJ0V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 05:26:21 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Will Drewry <wad@chromium.org>, Kees Cook <keescook@chromium.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 143/146] futex-prevent-requeue-pi-on-same-futex.patch futex: Forbid uaddr == uaddr2 in futex_requeue(..., requeue_pi=1)
Date: Mon,  9 Jun 2014 10:51:18 +0200
Message-Id: <5d1df1c4e508cd3ce714dfc4416c800e7061201e.1402303821.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <ebe219e45dcf94c1a34281167427cff4d742faef.1402303820.git.jslaby@suse.cz>
References: <ebe219e45dcf94c1a34281167427cff4d742faef.1402303820.git.jslaby@suse.cz>
In-Reply-To: <cover.1402303820.git.jslaby@suse.cz>
References: <cover.1402303820.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

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
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 kernel/futex.c | 25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/kernel/futex.c b/kernel/futex.c
index 6c7975b3f291..ab207d65c55f 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -1295,6 +1295,13 @@ static int futex_requeue(u32 __user *uaddr1, unsigned int flags,
 
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
@@ -1332,6 +1339,15 @@ retry:
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
 
@@ -2362,6 +2378,15 @@ static int futex_wait_requeue_pi(u32 __user *uaddr, unsigned int flags,
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
1.9.3

