Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752575AbaF1Knz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2014 06:43:55 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:50653 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752450AbaF1Knr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2014 06:43:47 -0400
From: Xie XiuQi <xiexiuqi@huawei.com>
To: <linux-kernel@vger.kernel.org>
CC: <rostedt@goodmis.org>, <mingo@redhat.com>, <tony.luck@intel.com>,
        <fweisbec@gmail.com>, <m.chehab@samsung.com>
Subject: [PATCH 1/2] tracing: fix uptime overflow problem
Date: Sat, 28 Jun 2014 19:10:00 +0800
Message-ID: <1403953801-19068-2-git-send-email-xiexiuqi@huawei.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1403953801-19068-1-git-send-email-xiexiuqi@huawei.com>
References: <1403953801-19068-1-git-send-email-xiexiuqi@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.100.166]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The "uptime" tracer added in:
    commit 8aacf017b065a805d27467843490c976835eb4a5
    tracing: Add "uptime" trace clock that uses jiffies
has wraparound problems when the system has been up more
than 1 hour 11 minutes and 34 seconds. It converts jiffies
to nanoseconds using:
        (u64)jiffies_to_usecs(jiffy) * 1000ULL
but since jiffies_to_usecs() only returns a 32-bit value, it
truncates at 2^32 microseconds.  An additional problem on 32-bit
systems is that the argument is "unsigned long", so fixing the
return value only helps until 2^32 jiffies (49.7 days on a HZ=1000
system).

Tony provide full featured jiffies_to_nsecs() function, but
can't resolve another problem that jiffies_lock is not safe
in NMI context.

Now we use the lockless function __current_kernel_time() and
getboottime() to calculate the uptime.

The former discussion is here:
http://lkml.org/lkml/2014/4/8/525

Additional, I changed trace_clock_jiffies to trace_clock_uptime,
in order to better describe its function.

Reported-by: Tony Luck <tony.luck@intel.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: stable@vger.kernel.org	# 3.10+
Signed-off-by: Xie XiuQi <xiexiuqi@huawei.com>
---
 include/linux/trace_clock.h |  2 +-
 kernel/trace/trace.c        |  2 +-
 kernel/trace/trace_clock.c  | 15 +++++++++++----
 3 files changed, 13 insertions(+), 6 deletions(-)

diff --git a/include/linux/trace_clock.h b/include/linux/trace_clock.h
index 1d7ca27..2961ac7 100644
--- a/include/linux/trace_clock.h
+++ b/include/linux/trace_clock.h
@@ -16,7 +16,7 @@
 
 extern u64 notrace trace_clock_local(void);
 extern u64 notrace trace_clock(void);
-extern u64 notrace trace_clock_jiffies(void);
+extern u64 notrace trace_clock_uptime(void);
 extern u64 notrace trace_clock_global(void);
 extern u64 notrace trace_clock_counter(void);
 
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 384ede3..867e849 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -809,7 +809,7 @@ static struct {
 	{ trace_clock_local,	"local",	1 },
 	{ trace_clock_global,	"global",	1 },
 	{ trace_clock_counter,	"counter",	0 },
-	{ trace_clock_jiffies,	"uptime",	1 },
+	{ trace_clock_uptime,	"uptime",	1 },
 	{ trace_clock,		"perf",		1 },
 	ARCH_TRACE_CLOCKS
 };
diff --git a/kernel/trace/trace_clock.c b/kernel/trace/trace_clock.c
index 26dc348..59e4d4d 100644
--- a/kernel/trace/trace_clock.c
+++ b/kernel/trace/trace_clock.c
@@ -19,6 +19,7 @@
 #include <linux/percpu.h>
 #include <linux/sched.h>
 #include <linux/ktime.h>
+#include <linux/time.h>
 #include <linux/trace_clock.h>
 
 /*
@@ -58,14 +59,20 @@ u64 notrace trace_clock(void)
 }
 
 /*
- * trace_jiffy_clock(): Simply use jiffies as a clock counter.
+ * trace_clock_uptime(): Use lockless version __current_kernel_time,
+ * so it's safe in NMI context.
  */
-u64 notrace trace_clock_jiffies(void)
+u64 notrace trace_clock_uptime(void)
 {
-	u64 jiffy = jiffies - INITIAL_JIFFIES;
+	struct timespec uptime, now, boottime;
+
+	/* Does not take xtime_lock, so it's safe in NMI context. */
+	now = __current_kernel_time();
+	getboottime(&boottime);
+	uptime = timespec_sub(now, boottime);
 
 	/* Return nsecs */
-	return (u64)jiffies_to_usecs(jiffy) * 1000ULL;
+	return timespec_to_ns(&uptime);
 }
 
 /*
-- 
2.0.0

