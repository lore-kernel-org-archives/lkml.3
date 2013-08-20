Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751865Ab3HTDIn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 23:08:43 -0400
Received: from intranet.asianux.com ([58.214.24.6]:17607 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751350Ab3HTDIm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 23:08:42 -0400
X-Spam-Score: -101.1
Message-ID: <5212DD71.7070208@asianux.com>
Date: Tue, 20 Aug 2013 11:07:29 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>, dvhart@linux.intel.com,
        ccross@android.com, Mel Gorman <mgorman@suse.de>
CC: Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] kernel/futex.c: notice the return value after rt_mutex_finish_proxy_lock()
 fails
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

rt_mutex_finish_proxy_lock() can return failure code (e.g. -EINTR,
-ETIMEDOUT).

Original implementation has already noticed about it, but not check it
before next work.

Also let coments within 80 columns to pass "./scripts/checkpatch.pl".


Signed-off-by: Chen Gang <gang.chen@asianux.com>
---
 kernel/futex.c |   30 ++++++++++++++++--------------
 1 files changed, 16 insertions(+), 14 deletions(-)

diff --git a/kernel/futex.c b/kernel/futex.c
index c3a1a55..1a94e7d 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -2373,21 +2373,23 @@ static int futex_wait_requeue_pi(u32 __user *uaddr, unsigned int flags,
 		ret = rt_mutex_finish_proxy_lock(pi_mutex, to, &rt_waiter, 1);
 		debug_rt_mutex_free_waiter(&rt_waiter);
 
-		spin_lock(q.lock_ptr);
-		/*
-		 * Fixup the pi_state owner and possibly acquire the lock if we
-		 * haven't already.
-		 */
-		res = fixup_owner(uaddr2, &q, !ret);
-		/*
-		 * If fixup_owner() returned an error, proprogate that.  If it
-		 * acquired the lock, clear -ETIMEDOUT or -EINTR.
-		 */
-		if (res)
-			ret = (res < 0) ? res : 0;
+		if (!ret) {
+			spin_lock(q.lock_ptr);
+			/*
+			 * Fixup the pi_state owner and possibly acquire the
+			 * lock if we haven't already.
+			 */
+			res = fixup_owner(uaddr2, &q, !ret);
+			/*
+			 * If fixup_owner() returned an error, proprogate that.
+			 * If it acquired the lock, clear -ETIMEDOUT or -EINTR.
+			 */
+			if (res)
+				ret = (res < 0) ? res : 0;
 
-		/* Unqueue and drop the lock. */
-		unqueue_me_pi(&q);
+			/* Unqueue and drop the lock. */
+			unqueue_me_pi(&q);
+		}
 	}
 
 	/*
-- 
1.7.7.6
