Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756030AbaDHB2r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2014 21:28:47 -0400
Received: from mga09.intel.com ([134.134.136.24]:44977 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753162AbaDHB2q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2014 21:28:46 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,814,1389772800"; 
   d="scan'208";a="516530164"
From: Tony Luck <tony.luck@intel.com>
Date: Mon, 7 Apr 2014 15:25:28 -0700
Subject: [RFC PATCH] time: Fix truncation in jiffies_to_usecs()
To: linux-kernel@vger.kernel.org
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, Mauro Chehab <m.chehab@samsung.com>
Message-Id: <0214020@agluck-desk.sc.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

jiffies_to_usecs() returns an "int" so it can only handle times up to
2^32 microseconds (1 hour 11 minutes 34 seconds) before truncation
occurs.  This is a problem for the "uptime" trace clock added in

    commit 8aacf017b065a805d27467843490c976835eb4a5

    tracing: Add "uptime" trace clock that uses jiffies

since it converts jiffies since boot into microseconds (and then
on to nanoseconds).

Change return type from "int" to "u64" to avoid trucncation.

Also have the trace clock code use jiffies_to_nsecs() directly.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---

This is a RFC because:
a) Not sure it is fair to all the existing users of jiffies_to_usecs()
   to start handing them a u64 when their usage needs are met by "int"
   (mostly they only pass in small arguments, like 10).
b) If this is OK - it needs to touch a few more files where people do
	printk("yada yada yada %d blah blah blah\n", jiffies_to_nsecs(something));
   to change that format to %lld
c) If not this ... then what? Separate routine to convert large numbers
   of jiffies to usec/nsecs?  Should we make the existing one barf when
   handed a number that overflows?

 include/linux/jiffies.h    | 4 ++--
 kernel/time.c              | 2 +-
 kernel/trace/trace_clock.c | 2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/include/linux/jiffies.h b/include/linux/jiffies.h
index 1f44466c1e9d..4b2621af705a 100644
--- a/include/linux/jiffies.h
+++ b/include/linux/jiffies.h
@@ -293,11 +293,11 @@ extern unsigned long preset_lpj;
  * Convert various time units to each other:
  */
 extern unsigned int jiffies_to_msecs(const unsigned long j);
-extern unsigned int jiffies_to_usecs(const unsigned long j);
+extern u64 jiffies_to_usecs(const unsigned long j);
 
 static inline u64 jiffies_to_nsecs(const unsigned long j)
 {
-	return (u64)jiffies_to_usecs(j) * NSEC_PER_USEC;
+	return jiffies_to_usecs(j) * NSEC_PER_USEC;
 }
 
 extern unsigned long msecs_to_jiffies(const unsigned int m);
diff --git a/kernel/time.c b/kernel/time.c
index 7c7964c33ae7..e0dfc77f60ae 100644
--- a/kernel/time.c
+++ b/kernel/time.c
@@ -257,7 +257,7 @@ unsigned int jiffies_to_msecs(const unsigned long j)
 }
 EXPORT_SYMBOL(jiffies_to_msecs);
 
-unsigned int jiffies_to_usecs(const unsigned long j)
+u64 jiffies_to_usecs(const unsigned long j)
 {
 #if HZ <= USEC_PER_SEC && !(USEC_PER_SEC % HZ)
 	return (USEC_PER_SEC / HZ) * j;
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

