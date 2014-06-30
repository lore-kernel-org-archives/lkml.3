Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756608AbaF3SRX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 14:17:23 -0400
Received: from mga03.intel.com ([143.182.124.21]:65064 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753256AbaF3SRW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 14:17:22 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,576,1400050800"; 
   d="scan'208";a="451721996"
Message-Id: <f2aafdcb7166ea8e825d43d5eb835ccfea7db1b0.1404149831.git.tony.luck@intel.com>
In-Reply-To: <20140630111040.58fe70de@gandalf.local.home>
From: Tony Luck <tony.luck@intel.com>
Subject: [PATCH] tracing: Fix wraparound problems in "uptime" tracer
To: Steven Rostedt <rostedt@goodmis.org>
Cc: <linux-kernel@vger.kernel.org>, <mingo@redhat.com>, <tony.luck@intel.com>,
        <fweisbec@gmail.com>,
        "<m.chehab@samsung.com> Xie XiuQi" <xiexiuqi@huawei.com>
Date: Mon, 30 Jun 2014 11:17:18 -0700
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There seem to be no non-racy solutions ... I've been wondering
about giving up on a generic jiffies_to_nsec() function because
people might use it in cases where the races might be likley to
bite them.  For my need, I think that "perfect is the enemy of good":

1) The race window is only a few microseconds wide
2) It only exists on 32-bit kernels - which are dying out on server
   systems because they can't handle the amounts of memory on modern
   machines.
3) It opens every 49 days (on a HZ=1000 system)
4) I'm logging error events that happen at a "per-month" frequency (or lower)
5) If the race does happen - the visible result is that we have a
   bad time logged against an error event.

so what about this: ...

From: Tony Luck <tony.luck@intel.com>

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

We can't provide a full features jiffies_to_nsec() function in
any safe way (32-bit systems need locking to read the full 64-bit
jiffies value).  Just do the best we can here and recognise that
32-bit systems may seem some timestamp anomolies if jiffies64
was in the middle of rolling over a 2^32 boundary.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 kernel/timeconst.bc        |  6 ++++++
 kernel/trace/trace_clock.c | 10 ++++++++--
 2 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/kernel/timeconst.bc b/kernel/timeconst.bc
index 511bdf2cafda..a5fef7a7fb27 100644
--- a/kernel/timeconst.bc
+++ b/kernel/timeconst.bc
@@ -100,6 +100,12 @@ define timeconst(hz) {
 		print "#define USEC_TO_HZ_DEN\t\t", 1000000/cd, "\n"
 		print "\n"
 
+		obase=10
+		cd=gcd(hz,1000000000)
+		print "#define HZ_TO_NSEC_NUM\t\t", 1000000000/cd, "\n"
+		print "#define HZ_TO_NSEC_DEN\t\t", hz/cd, "\n"
+		print "\n"
+
 		print "#endif /* KERNEL_TIMECONST_H */\n"
 	}
 	halt
diff --git a/kernel/trace/trace_clock.c b/kernel/trace/trace_clock.c
index 26dc348332b7..dc5b11b9f8a4 100644
--- a/kernel/trace/trace_clock.c
+++ b/kernel/trace/trace_clock.c
@@ -59,13 +59,19 @@ u64 notrace trace_clock(void)
 
 /*
  * trace_jiffy_clock(): Simply use jiffies as a clock counter.
+ * This usage of jiffies_64 isn't safe on 32-bit, but we may be
+ * called from NMI context, and we have no safe way to get a timestamp.
  */
 u64 notrace trace_clock_jiffies(void)
 {
-	u64 jiffy = jiffies - INITIAL_JIFFIES;
+	u64 jiffy = jiffies_64 - INITIAL_JIFFIES;
 
 	/* Return nsecs */
-	return (u64)jiffies_to_usecs(jiffy) * 1000ULL;
+#if !(NSEC_PER_SEC % HZ)
+	return (NSEC_PER_SEC / HZ) * jiffy;
+#else
+	return (jiffy * HZ_TO_NSEC_NUM) / HZ_TO_NSEC_DEN;
+#endif
 }
 
 /*
-- 
1.8.4.1

