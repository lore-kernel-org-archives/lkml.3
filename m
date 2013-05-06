Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933921Ab3EFXzP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 19:55:15 -0400
Received: from mail-qa0-f74.google.com ([209.85.216.74]:50242 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932368Ab3EFXu3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 19:50:29 -0400
From: Colin Cross <ccross@android.com>
To: linux-kernel@vger.kernel.org
Cc: Pavel Machek <pavel@ucw.cz>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mandeep Singh Baines <msb@chromium.org>,
        Colin Cross <ccross@android.com>, Oleg Nesterov <oleg@redhat.com>,
        linux-nfs@vger.kernel.org, linux-pm@vger.kernel.org,
        netdev@vger.kernel.org, Linus Torvalds <torvalds@linux-foundation.org>,
        Tejun Heo <tj@kernel.org>, Len Brown <len.brown@intel.com>
Subject: [PATCH v3 05/16] freezer: shorten freezer sleep time using exponential backoff
Date: Mon,  6 May 2013 16:50:10 -0700
Message-Id: <1367884221-20462-6-git-send-email-ccross@android.com>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <1367884221-20462-1-git-send-email-ccross@android.com>
References: <1367884221-20462-1-git-send-email-ccross@android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All tasks can easily be frozen in under 10 ms, switch to using
an initial 1 ms sleep followed by exponential backoff until
8 ms.  Also convert the printed time to ms instead of centiseconds.

Acked-by: Pavel Machek <pavel@ucw.cz>
Acked-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Colin Cross <ccross@android.com>
---
 kernel/power/process.c | 26 +++++++++++++++-----------
 1 file changed, 15 insertions(+), 11 deletions(-)

diff --git a/kernel/power/process.c b/kernel/power/process.c
index 98088e0..fc0df84 100644
--- a/kernel/power/process.c
+++ b/kernel/power/process.c
@@ -30,9 +30,10 @@ static int try_to_freeze_tasks(bool user_only)
 	unsigned int todo;
 	bool wq_busy = false;
 	struct timeval start, end;
-	u64 elapsed_csecs64;
-	unsigned int elapsed_csecs;
+	u64 elapsed_msecs64;
+	unsigned int elapsed_msecs;
 	bool wakeup = false;
+	int sleep_usecs = USEC_PER_MSEC;
 
 	do_gettimeofday(&start);
 
@@ -68,22 +69,25 @@ static int try_to_freeze_tasks(bool user_only)
 
 		/*
 		 * We need to retry, but first give the freezing tasks some
-		 * time to enter the refrigerator.
+		 * time to enter the refrigerator.  Start with an initial
+		 * 1 ms sleep followed by exponential backoff until 8 ms.
 		 */
-		msleep(10);
+		usleep_range(sleep_usecs / 2, sleep_usecs);
+		if (sleep_usecs < 8 * USEC_PER_MSEC)
+			sleep_usecs *= 2;
 	}
 
 	do_gettimeofday(&end);
-	elapsed_csecs64 = timeval_to_ns(&end) - timeval_to_ns(&start);
-	do_div(elapsed_csecs64, NSEC_PER_SEC / 100);
-	elapsed_csecs = elapsed_csecs64;
+	elapsed_msecs64 = timeval_to_ns(&end) - timeval_to_ns(&start);
+	do_div(elapsed_msecs64, NSEC_PER_MSEC);
+	elapsed_msecs = elapsed_msecs64;
 
 	if (todo) {
 		printk("\n");
-		printk(KERN_ERR "Freezing of tasks %s after %d.%02d seconds "
+		printk(KERN_ERR "Freezing of tasks %s after %d.%03d seconds "
 		       "(%d tasks refusing to freeze, wq_busy=%d):\n",
 		       wakeup ? "aborted" : "failed",
-		       elapsed_csecs / 100, elapsed_csecs % 100,
+		       elapsed_msecs / 1000, elapsed_msecs % 1000,
 		       todo - wq_busy, wq_busy);
 
 		if (!wakeup) {
@@ -96,8 +100,8 @@ static int try_to_freeze_tasks(bool user_only)
 			read_unlock(&tasklist_lock);
 		}
 	} else {
-		printk("(elapsed %d.%02d seconds) ", elapsed_csecs / 100,
-			elapsed_csecs % 100);
+		printk("(elapsed %d.%03d seconds) ", elapsed_msecs / 1000,
+			elapsed_msecs % 1000);
 	}
 
 	return todo ? -EBUSY : 0;
-- 
1.8.2.1

