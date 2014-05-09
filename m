Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758111AbaEIVrT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 17:47:19 -0400
Received: from mga11.intel.com ([192.55.52.93]:42088 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757815AbaEIVrQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 17:47:16 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,1020,1389772800"; 
   d="scan'208";a="529362347"
In-Reply-To: <CA+8MBbL6WWQzwMoL29yWR=9T3T-o0Ejb5xc-jwkEmAnaDTBeUw@mail.gmail.com>
From: "Luck, Tony" <tony.luck@intel.com>
Subject: [PATCH] time: Provide full featured jiffies_to_nsecs() function
To: linux-kernel@vger.kernel.org
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, Mauro Chehab <m.chehab@samsung.com>
Date: Fri, 09 May 2014 14:46:56 -0700
Message-Id: <536d4cd0163076d8ca@agluck-desk.sc.intel.com>
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

So we provide a full featured jiffies_to_nsec() function that
takes a "u64" argument and provides a "u64" result.  To avoid
cries of rage from the other user of this: scheduler_tick_max_deferment()
we check whether the argument is small enough that we can do
the calculations in 32-bit operations.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---

Looks like I flubbed on re-sending the updated version of this
after our discussion back in early April.

 include/linux/jiffies.h    |  6 +-----
 kernel/time.c              | 25 +++++++++++++++++++++++++
 kernel/timeconst.bc        | 12 ++++++++++++
 kernel/trace/trace_clock.c |  2 +-
 4 files changed, 39 insertions(+), 6 deletions(-)

diff --git a/include/linux/jiffies.h b/include/linux/jiffies.h
index 1f44466c1e9d..3cf44401055f 100644
--- a/include/linux/jiffies.h
+++ b/include/linux/jiffies.h
@@ -294,11 +294,7 @@ extern unsigned long preset_lpj;
  */
 extern unsigned int jiffies_to_msecs(const unsigned long j);
 extern unsigned int jiffies_to_usecs(const unsigned long j);
-
-static inline u64 jiffies_to_nsecs(const unsigned long j)
-{
-	return (u64)jiffies_to_usecs(j) * NSEC_PER_USEC;
-}
+extern u64 jiffies_to_nsecs(const u64 j);
 
 extern unsigned long msecs_to_jiffies(const unsigned int m);
 extern unsigned long usecs_to_jiffies(const unsigned int u);
diff --git a/kernel/time.c b/kernel/time.c
index 7c7964c33ae7..7e69ceed12c0 100644
--- a/kernel/time.c
+++ b/kernel/time.c
@@ -259,6 +259,7 @@ EXPORT_SYMBOL(jiffies_to_msecs);
 
 unsigned int jiffies_to_usecs(const unsigned long j)
 {
+	WARN_ON_ONCE(j > UINT_MAX * HZ / USEC_PER_SEC);
 #if HZ <= USEC_PER_SEC && !(USEC_PER_SEC % HZ)
 	return (USEC_PER_SEC / HZ) * j;
 #elif HZ > USEC_PER_SEC && !(HZ % USEC_PER_SEC)
@@ -273,6 +274,30 @@ unsigned int jiffies_to_usecs(const unsigned long j)
 }
 EXPORT_SYMBOL(jiffies_to_usecs);
 
+u64 jiffies_to_nsecs(const u64 jl)
+{
+	/* can we do this with 32-bit math? */
+	if (jl < (u64)UINT_MAX * HZ / NSEC_PER_SEC) {
+		unsigned long j = jl;
+#if !(NSEC_PER_SEC % HZ)
+		return (NSEC_PER_SEC / HZ) * j;
+#else
+# if BITS_PER_LONG == 32
+		return (HZ_TO_NSEC_MUL32 * j) >> HZ_TO_NSEC_SHR32;
+# else
+		return (j * HZ_TO_NSEC_NUM) / HZ_TO_NSEC_DEN;
+# endif
+#endif
+	} else {
+#if !(NSEC_PER_SEC % HZ)
+		return (NSEC_PER_SEC / HZ) * jl;
+#else
+		return (jl * HZ_TO_NSEC_NUM) / HZ_TO_NSEC_DEN;
+#endif
+	}
+}
+EXPORT_SYMBOL(jiffies_to_nsecs);
+
 /**
  * timespec_trunc - Truncate timespec to a granularity
  * @t: Timespec
diff --git a/kernel/timeconst.bc b/kernel/timeconst.bc
index 511bdf2cafda..6f6e8b285c2b 100644
--- a/kernel/timeconst.bc
+++ b/kernel/timeconst.bc
@@ -100,6 +100,18 @@ define timeconst(hz) {
 		print "#define USEC_TO_HZ_DEN\t\t", 1000000/cd, "\n"
 		print "\n"
 
+                s=fmuls(32,1000000000,hz)
+                obase=16
+                print "#define HZ_TO_NSEC_MUL32\tU64_C(0x", fmul(s,1000000000,hz), ")\n"
+                obase=10
+                print "#define HZ_TO_NSEC_SHR32\t", s, "\n"
+
+                obase=10
+                cd=gcd(hz,1000000000)
+                print "#define HZ_TO_NSEC_NUM\t\t", 1000000000/cd, "\n"
+                print "#define HZ_TO_NSEC_DEN\t\t", hz/cd, "\n"
+                print "\n"
+
 		print "#endif /* KERNEL_TIMECONST_H */\n"
 	}
 	halt
diff --git a/kernel/trace/trace_clock.c b/kernel/trace/trace_clock.c
index 26dc348332b7..52470fba1d26 100644
--- a/kernel/trace/trace_clock.c
+++ b/kernel/trace/trace_clock.c
@@ -65,7 +65,7 @@ u64 notrace trace_clock_jiffies(void)
 	u64 jiffy = jiffies - INITIAL_JIFFIES;
 
 	/* Return nsecs */
-	return (u64)jiffies_to_usecs(jiffy) * 1000ULL;
+	return jiffies_to_nsecs(jiffy);
 }
 
 /*
-- 
1.8.4.1

