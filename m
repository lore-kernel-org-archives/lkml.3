Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752865AbaF3Ubo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 16:31:44 -0400
Received: from mga01.intel.com ([192.55.52.88]:59652 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750924AbaF3Ubn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 16:31:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,577,1400050800"; 
   d="scan'208";a="555450270"
Message-Id: <b29c17f74d39d1b9240385e7479f63f44c988b8b.1404160039.git.tony.luck@intel.com>
In-Reply-To: <20140630144017.2abc48ba@gandalf.local.home>
From: Tony Luck <tony.luck@intel.com>
Subject: [PATCH-v2] tracing: Fix wraparound problems in "uptime" tracer
To: Steven Rostedt <rostedt@goodmis.org>
Cc: <linux-kernel@vger.kernel.org>, <mingo@redhat.com>, <tony.luck@intel.com>,
        <fweisbec@gmail.com>,
        "<m.chehab@samsung.com> Xie XiuQi" <xiexiuqi@huawei.com>
Date: Mon, 30 Jun 2014 13:31:37 -0700
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

We can't provide a full features jiffies_to_nsec() function in
any safe way (32-bit systems need locking to read the full 64-bit
jiffies value).  Just do the best we can here and recognise that
32-bit systems may seem some timestamp anomolies if jiffies64
was in the middle of rolling over a 2^32 boundary.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---

v1->v2: Use "do_div()" for 64-bit division

 kernel/timeconst.bc        |  6 ++++++
 kernel/trace/trace_clock.c | 12 ++++++++++--
 2 files changed, 16 insertions(+), 2 deletions(-)

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
index 26dc348332b7..3fcf8f4807d5 100644
--- a/kernel/trace/trace_clock.c
+++ b/kernel/trace/trace_clock.c
@@ -59,13 +59,21 @@ u64 notrace trace_clock(void)
 
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
+	jiffy *= HZ_TO_NSEC_NUM;
+	do_div(jiffy, HZ_TO_NSEC_DEN);
+	return jiffy;
+#endif
 }
 
 /*
-- 
1.8.4.1

