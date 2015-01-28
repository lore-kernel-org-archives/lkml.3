Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759346AbbA2Byl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 20:54:41 -0500
Received: from mail-pa0-f41.google.com ([209.85.220.41]:59166 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755479AbbA2ByV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 20:54:21 -0500
Date: Wed, 28 Jan 2015 19:46:11 +0530
From: Tina Ruchandani <ruchandani.tina@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>
Subject: [PATCH v4] trace: Use 64-bit timekeeping
Message-ID: <20150128141611.GA2701@tinar>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The ring_buffer_producer uses 'struct timeval' to measure
its start and end times. 'struct timeval' on 32-bit systems
will have its tv_sec value overflow in year 2038 and beyond.
This patch replaces struct timeval with 'ktime_t' which uses
64-bit representation for nanoseconds.

Suggested-by: Arnd Bergmann <arnd@arndb.de>
Suggested-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Tina Ruchandani <ruchandani.tina@gmail.com>
---
Changes in v4:
	- Fix typo in commit message.
	- Avoid typecast to 'long long' by defining RUN_TIME as '10ULL'
	  instead of '10'.
Changes in v3:
	- Use a more efficient way to compute condition for exiting loop.
	- Fix variable naming - all caps is only for macros.
Changes in v2:
	- Use ktime_t instead of timespec64 for efficiency reasons.
---
 kernel/trace/ring_buffer_benchmark.c | 18 ++++++++----------
 1 file changed, 8 insertions(+), 10 deletions(-)

diff --git a/kernel/trace/ring_buffer_benchmark.c b/kernel/trace/ring_buffer_benchmark.c
index 3f9e328..13d945c 100644
--- a/kernel/trace/ring_buffer_benchmark.c
+++ b/kernel/trace/ring_buffer_benchmark.c
@@ -7,7 +7,7 @@
 #include <linux/completion.h>
 #include <linux/kthread.h>
 #include <linux/module.h>
-#include <linux/time.h>
+#include <linux/ktime.h>
 #include <asm/local.h>
 
 struct rb_page {
@@ -17,7 +17,7 @@ struct rb_page {
 };
 
 /* run time and sleep time in seconds */
-#define RUN_TIME	10
+#define RUN_TIME	10ULL
 #define SLEEP_TIME	10
 
 /* number of events for writer to wake up the reader */
@@ -212,8 +212,7 @@ static void ring_buffer_consumer(void)
 
 static void ring_buffer_producer(void)
 {
-	struct timeval start_tv;
-	struct timeval end_tv;
+	ktime_t start_time, end_time, timeout;
 	unsigned long long time;
 	unsigned long long entries;
 	unsigned long long overruns;
@@ -227,7 +226,8 @@ static void ring_buffer_producer(void)
 	 * make the system stall)
 	 */
 	trace_printk("Starting ring buffer hammer\n");
-	do_gettimeofday(&start_tv);
+	start_time = ktime_get();
+	timeout = ktime_add_ns(start_time, RUN_TIME * NSEC_PER_SEC);
 	do {
 		struct ring_buffer_event *event;
 		int *entry;
@@ -244,7 +244,7 @@ static void ring_buffer_producer(void)
 				ring_buffer_unlock_commit(buffer, event);
 			}
 		}
-		do_gettimeofday(&end_tv);
+		end_time = ktime_get();
 
 		cnt++;
 		if (consumer && !(cnt % wakeup_interval))
@@ -264,7 +264,7 @@ static void ring_buffer_producer(void)
 			cond_resched();
 #endif
 
-	} while (end_tv.tv_sec < (start_tv.tv_sec + RUN_TIME) && !kill_test);
+	} while (ktime_before(end_time, timeout) && !kill_test);
 	trace_printk("End ring buffer hammer\n");
 
 	if (consumer) {
@@ -280,9 +280,7 @@ static void ring_buffer_producer(void)
 		wait_for_completion(&read_done);
 	}
 
-	time = end_tv.tv_sec - start_tv.tv_sec;
-	time *= USEC_PER_SEC;
-	time += (long long)((long)end_tv.tv_usec - (long)start_tv.tv_usec);
+	time = ktime_us_delta(end_time, start_time);
 
 	entries = ring_buffer_entries(buffer);
 	overruns = ring_buffer_overruns(buffer);
-- 
2.2.0.rc0.207.ga3a616c

