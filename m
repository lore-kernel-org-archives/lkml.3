Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761601Ab3BNTte (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 14:49:34 -0500
Received: from mail-pa0-f42.google.com ([209.85.220.42]:38358 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758666Ab3BNTtc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 14:49:32 -0500
From: Kevin Hilman <khilman@linaro.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Li Zhong <zhong@linux.vnet.ibm.com>,
        Namhyung Kim <namhyung.kim@lge.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>, Tony Luck <tony.luck@intel.com>,
        Fenghua Yu <fenghua.yu@intel.com>,
        Nicolas Pitre <nicolas.pitre@linaro.org>
Subject: Re: [PATCH 2/8] cputime: Librarize per nsecs resolution cputime definitions
References: <1359399845-10568-1-git-send-email-fweisbec@gmail.com>
	<1359399845-10568-3-git-send-email-fweisbec@gmail.com>
Date: Thu, 14 Feb 2013 11:49:28 -0800
In-Reply-To: <1359399845-10568-3-git-send-email-fweisbec@gmail.com> (Frederic
	Weisbecker's message of "Mon, 28 Jan 2013 20:03:59 +0100")
Message-ID: <87ehgid6bb.fsf@linaro.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frederic Weisbecker <fweisbec@gmail.com> writes:

> The full dynticks cputime accounting that we'll soon introduce
> will rely on sched_clock(). And its clock can have a per
> nanosecond granularity.
>
> To prepare for this, we need to have a cputime_t implementation
> that has this precision.
>
> ia64 virtual cputime accounting already uses that granularity
> so all we need is to librarize its implementation in the asm
> generic headers.

...except that for it to be truly generic (i.e. usable on 32-bit arches),
it should be using do_div() for 64-bit divides.

I understand this series is targetted at 64-bit platforms currently, but
I'm looking (again) at getting adaptive NOHZ working on ARM, and this
was the first obvious obstacle to even compiling.

I see this is already merged into tip/sched/core, so below is a patch on
top of that to convert to using do_div().  If you're OK with the
approach, I'll post it formally to LKML.

Thanks,

Kevin


>From b1572b5ae67d4221277484e59d571b639775af70 Mon Sep 17 00:00:00 2001
From: Kevin Hilman <khilman@linaro.org>
Date: Thu, 14 Feb 2013 11:27:36 -0800
Subject: [PATCH] cputime: use do_div() for nsec resolution conversion helpers

For the nsec resolution conversions to be useful on non 64-bit
architectures, do_div() needs to be used for the 64-bit divisions.

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Kevin Hilman <khilman@linaro.org>
---
 include/asm-generic/cputime_nsecs.h | 51 +++++++++++++++++++++++++++----------
 1 file changed, 37 insertions(+), 14 deletions(-)

diff --git a/include/asm-generic/cputime_nsecs.h b/include/asm-generic/cputime_nsecs.h
index b6485ca..daa6075 100644
--- a/include/asm-generic/cputime_nsecs.h
+++ b/include/asm-generic/cputime_nsecs.h
@@ -24,13 +24,17 @@ typedef u64 __nocast cputime64_t;
 /*
  * Convert cputime <-> jiffies (HZ)
  */
-#define cputime_to_jiffies(__ct)	\
-	((__force u64)(__ct) / (NSEC_PER_SEC / HZ))
+static inline u64 cputime_to_jiffies(const cputime_t ct)
+{
+	cputime_t __ct = ct;
+
+	do_div(__ct, NSEC_PER_SEC / HZ);
+	return __ct;
+}
 #define cputime_to_scaled(__ct)		(__ct)
 #define jiffies_to_cputime(__jif)	\
 	(__force cputime_t)((__jif) * (NSEC_PER_SEC / HZ))
-#define cputime64_to_jiffies64(__ct)	\
-	((__force u64)(__ct) / (NSEC_PER_SEC / HZ))
+#define cputime64_to_jiffies64(__ct) cputime_to_jiffies(__ct)
 #define jiffies64_to_cputime64(__jif)	\
 	(__force cputime64_t)((__jif) * (NSEC_PER_SEC / HZ))
 
@@ -44,8 +48,13 @@ typedef u64 __nocast cputime64_t;
 /*
  * Convert cputime <-> microseconds
  */
-#define cputime_to_usecs(__ct)		\
-	((__force u64)(__ct) / NSEC_PER_USEC)
+static inline u64 cputime_to_usecs(const cputime_t ct)
+{
+	cputime_t __ct = ct;
+
+	do_div(__ct, NSEC_PER_USEC);
+	return __ct;
+}
 #define usecs_to_cputime(__usecs)	\
 	(__force cputime_t)((__usecs) * NSEC_PER_USEC)
 #define usecs_to_cputime64(__usecs)	\
@@ -54,8 +63,13 @@ typedef u64 __nocast cputime64_t;
 /*
  * Convert cputime <-> seconds
  */
-#define cputime_to_secs(__ct)		\
-	((__force u64)(__ct) / NSEC_PER_SEC)
+static inline u64 cputime_to_secs(const cputime_t ct)
+{
+	cputime_t __ct = ct;
+
+	do_div(__ct, NSEC_PER_SEC);
+	return __ct;
+}
 #define secs_to_cputime(__secs)		\
 	(__force cputime_t)((__secs) * NSEC_PER_SEC)
 
@@ -69,8 +83,10 @@ static inline cputime_t timespec_to_cputime(const struct timespec *val)
 }
 static inline void cputime_to_timespec(const cputime_t ct, struct timespec *val)
 {
-	val->tv_sec  = (__force u64) ct / NSEC_PER_SEC;
-	val->tv_nsec = (__force u64) ct % NSEC_PER_SEC;
+	cputime_t __ct = ct;
+
+	val->tv_nsec = do_div(__ct, NSEC_PER_SEC);
+	val->tv_sec = __ct;
 }
 
 /*
@@ -83,15 +99,22 @@ static inline cputime_t timeval_to_cputime(struct timeval *val)
 }
 static inline void cputime_to_timeval(const cputime_t ct, struct timeval *val)
 {
-	val->tv_sec = (__force u64) ct / NSEC_PER_SEC;
-	val->tv_usec = ((__force u64) ct % NSEC_PER_SEC) / NSEC_PER_USEC;
+	cputime_t __ct = ct;
+
+	val->tv_usec = do_div(__ct, NSEC_PER_SEC) / NSEC_PER_USEC;
+	val->tv_sec = __ct;
 }
 
 /*
  * Convert cputime <-> clock (USER_HZ)
  */
-#define cputime_to_clock_t(__ct)	\
-	((__force u64)(__ct) / (NSEC_PER_SEC / USER_HZ))
+static inline u64 cputime_to_clock_t(const cputime_t ct)
+{
+	cputime_t __ct = ct;
+
+	do_div(__ct, (NSEC_PER_SEC / USER_HZ));
+	return __ct;
+}
 #define clock_t_to_cputime(__x)		\
 	(__force cputime_t)((__x) * (NSEC_PER_SEC / USER_HZ))
 
-- 
1.8.1.2



