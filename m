Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759267Ab3EBBnH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 May 2013 21:43:07 -0400
Received: from mail-qe0-f73.google.com ([209.85.128.73]:62485 "EHLO
	mail-qe0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759014Ab3EBBnA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 May 2013 21:43:00 -0400
X-Greylist: delayed 463 seconds by postgrey-1.27 at vger.kernel.org; Wed, 01 May 2013 21:43:00 EDT
From: Colin Cross <ccross@android.com>
To: linux-pm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
        arve@android.com, Tejun Heo <tj@kernel.org>,
        Oleg Nesterov <oleg@redhat.com>, Colin Cross <ccross@android.com>,
        Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>
Subject: [PATCH v2 01/10] freezer: shorten freezer sleep time using exponential backoff
Date: Wed,  1 May 2013 18:34:59 -0700
Message-Id: <1367458508-9133-2-git-send-email-ccross@android.com>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <1367458508-9133-1-git-send-email-ccross@android.com>
References: <1367458508-9133-1-git-send-email-ccross@android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All tasks can easily be frozen in under 10 ms, switch to using
an initial 1 ms sleep followed by exponential backoff until
8 ms.  Also convert the printed time to ms instead of centiseconds.

Signed-off-by: Colin Cross <ccross@android.com>
---
 kernel/power/process.c | 23 +++++++++++++----------
 1 file changed, 13 insertions(+), 10 deletions(-)

diff --git a/kernel/power/process.c b/kernel/power/process.c
index 98088e0..eb7e6c1 100644
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
 
@@ -70,20 +71,22 @@ static int try_to_freeze_tasks(bool user_only)
 		 * We need to retry, but first give the freezing tasks some
 		 * time to enter the refrigerator.
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
@@ -96,8 +99,8 @@ static int try_to_freeze_tasks(bool user_only)
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

