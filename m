Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422829AbaGRSn0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 14:43:26 -0400
Received: from mga02.intel.com ([134.134.136.20]:62471 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030567AbaGRSnZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 14:43:25 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,686,1400050800"; 
   d="scan'208";a="575324214"
Message-Id: <99d63c5bfe9b320a3b428d773825a37095bf6a51.1405708254.git.tony.luck@intel.com>
In-Reply-To: <20140718133609.3125e72d@gandalf.local.home>
From: Tony Luck <tony.luck@intel.com>
Subject: [PATCH] tracing: Fix wraparound problems in "uptime" tracer
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>, <fweisbec@gmail.com>,
        <m.chehab@samsung.com>, "Xie XiuQi" <xiexiuqi@huawei.com>
Date: Fri, 18 Jul 2014 11:43:01 -0700
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

Avoid these problems by using jiffies_64 as our basis, and
not converting to nanoseconds (we do convert to clock_t because
user facing API must not be dependent on internal kernel
HZ values).

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 kernel/trace/trace.c       | 2 +-
 kernel/trace/trace_clock.c | 9 +++++----
 2 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 384ede311717..eb7d56480545 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -809,7 +809,7 @@ static struct {
 	{ trace_clock_local,	"local",	1 },
 	{ trace_clock_global,	"global",	1 },
 	{ trace_clock_counter,	"counter",	0 },
-	{ trace_clock_jiffies,	"uptime",	1 },
+	{ trace_clock_jiffies,	"uptime",	0 },
 	{ trace_clock,		"perf",		1 },
 	ARCH_TRACE_CLOCKS
 };
diff --git a/kernel/trace/trace_clock.c b/kernel/trace/trace_clock.c
index 26dc348332b7..57b67b1f24d1 100644
--- a/kernel/trace/trace_clock.c
+++ b/kernel/trace/trace_clock.c
@@ -59,13 +59,14 @@ u64 notrace trace_clock(void)
 
 /*
  * trace_jiffy_clock(): Simply use jiffies as a clock counter.
+ * Note that this use of jiffies_64 is not completely safe on
+ * 32-bit systems. But the window is tiny, and the effect if
+ * we are affected is that we will have an obviously bogus
+ * timestamp on a trace event - i.e. not life threatening.
  */
 u64 notrace trace_clock_jiffies(void)
 {
-	u64 jiffy = jiffies - INITIAL_JIFFIES;
-
-	/* Return nsecs */
-	return (u64)jiffies_to_usecs(jiffy) * 1000ULL;
+	return jiffies_64_to_clock_t(jiffies_64 - INITIAL_JIFFIES);
 }
 
 /*
-- 
1.8.4.1

