Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965459AbbA1Eio (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 23:38:44 -0500
Received: from mail-pd0-f181.google.com ([209.85.192.181]:61637 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965308AbbA1Eim (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 23:38:42 -0500
Date: Wed, 28 Jan 2015 10:08:37 +0530
From: Tina Ruchandani <ruchandani.tina@gmail.com>
To: Linux PM List <linux-pm@vger.kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>, Pavel Machek <pavel@ucw.cz>,
        Len Brown <len.brown@intel.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, linux-kernel@vger.kernel.org
Subject: [PATCH v2] PM: Use 64-bit timekeeping
Message-ID: <20150128043836.GA4112@tinar>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The freezer try_to_freeze_tasks uses 'struct timeval' for start
and end times, tracking time taken to freeze tasks. 'struct timeval'
on 32-bit systems will have its tv_sec overflow in year 2038 and
beyond. This patches uses 'ktime_t' (which has 64 bit values
for seconds) for start and end time.

Suggested-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Tina Ruchandani <ruchandani.tina@gmail.com>
---
Changes in v2:
	- Use ktime_t to be able to use ktime_ms_delta
	  which is more efficient than timespec64 based methods.
---
 kernel/power/process.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/kernel/power/process.c b/kernel/power/process.c
index 5a6ec86..52414dd 100644
--- a/kernel/power/process.c
+++ b/kernel/power/process.c
@@ -17,6 +17,7 @@
 #include <linux/delay.h>
 #include <linux/workqueue.h>
 #include <linux/kmod.h>
+#include <linux/ktime.h>
 #include <trace/events/power.h>
 
 /* 
@@ -30,13 +31,12 @@ static int try_to_freeze_tasks(bool user_only)
 	unsigned long end_time;
 	unsigned int todo;
 	bool wq_busy = false;
-	struct timeval start, end;
-	u64 elapsed_msecs64;
+	ktime_t start, end;
 	unsigned int elapsed_msecs;
 	bool wakeup = false;
 	int sleep_usecs = USEC_PER_MSEC;
 
-	do_gettimeofday(&start);
+	start = ktime_get();
 
 	end_time = jiffies + msecs_to_jiffies(freeze_timeout_msecs);
 
@@ -78,10 +78,8 @@ static int try_to_freeze_tasks(bool user_only)
 			sleep_usecs *= 2;
 	}
 
-	do_gettimeofday(&end);
-	elapsed_msecs64 = timeval_to_ns(&end) - timeval_to_ns(&start);
-	do_div(elapsed_msecs64, NSEC_PER_MSEC);
-	elapsed_msecs = elapsed_msecs64;
+	end = ktime_get();
+	elapsed_msecs = (unsigned int) ktime_ms_delta(end, start);
 
 	if (todo) {
 		printk("\n");
-- 
2.2.0.rc0.207.ga3a616c

