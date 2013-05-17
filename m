Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754126Ab3EQPPI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 11:15:08 -0400
Received: from mga14.intel.com ([143.182.124.37]:56432 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752177Ab3EQPPG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 11:15:06 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,693,1363158000"; 
   d="scan'208";a="335798508"
Message-ID: <1368803693.8285.39.camel@intelbox>
Subject: Re: [PATCH v2 1/8] time: add *_to_jiffies_timeout helpers to
 guarantee a minimum duration
From: Imre Deak <imre.deak@intel.com>
Reply-To: imre.deak@intel.com
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        John Stultz <john.stultz@linaro.org>, Ingo Molnar <mingo@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Eric Dumazet <edumazet@google.com>,
        Prarit Bhargava <prarit@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dong Zhu <bluezhudong@gmail.com>
Date: Fri, 17 May 2013 18:14:53 +0300
In-Reply-To: <201305171535.51652.arnd@arndb.de>
References: <1368542918-8861-1-git-send-email-imre.deak@intel.com>
	 <201305151726.44017.arnd@arndb.de> <1368640576.28478.52.camel@ideak-mobl>
	 <201305171535.51652.arnd@arndb.de>
Organization: Intel
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-05-17 at 15:35 +0200, Arnd Bergmann wrote:
> On Wednesday 15 May 2013, Imre Deak wrote:
> > On Wed, 2013-05-15 at 17:26 +0200, Arnd Bergmann wrote:
> >
> > > > Signed-off-by: Imre Deak <imre.deak@intel.com>
> > > 
> > > This certainly looks like a reasonable change, but I wonder if we could take
> > > it one step further and add milisecond based interfaces for some of those
> > > functions that currently take a jiffies value, something like
> > > 
> > > int timer_set_msecs(struct timer_list *timer, unsigned long msecs)
> > > {
> > > 	unsigned long j = msec_to_jiffies(msecs);
> > > 	return mod_timer(timer, min_t(msecs, MAX_JIFFY_OFFSET));
> > > }
> > 
> > Ok, but I think we'd still need the *_to_jiffies_timeout helpers, so
> > that we don't have to open code the +1 magic anywhere.
> 
> Yes, but we would not change any driver code to use those.

I don't know which would be a better API for drivers. We have quite a
few more functions that accept a jiffies timeout parameter, for example:

wait_event_timeout
wait_event_interruptible_timeout
wait_for_completion_timeout
wait_for_completion_interruptible_timeout
schedule_timeout
...

For all of these we'd have to add an msec and perhaps also an usec
variant. I find it simpler to have a set of helpers that can convert
from any time format to jiffies, which can be used then with any of
these functions.

Also we would still need to expose these helpers to drivers in case they
want to compare against the current jiffies directly.

> We probably would not need all of the helpers and add only the
> ones that are required by other infrastructure.
>
> > > > +#define __define_time_to_jiffies_timeout(tname, ttype)                 \
> > > > +unsigned long tname ## _to_jiffies_timeout(const ttype v)              \
> > > > +{                                                                      \
> > > > +       unsigned long j = tname ## _to_jiffies(v);                      \
> > > > +       return min_t(unsigned long, MAX_JIFFY_OFFSET, j + 1);           \
> > > > +}                                                                      \
> > > > +EXPORT_SYMBOL(tname ## _to_jiffies_timeout);
> > > 
> > > The macro has a few disadvantages:
> > > 
> > > * It's impossible to grep for the function or use tags if you generate
> > >   the identifier using the macro.
> > 
> > They are fully spelled in include/linux/jiffies.h . Would it be ok if I
> > moved the kernel doc there with a reference to kernel/time.c?
> 
> Yes, I guess that's ok. I would prefer to have them open-coded, but
> it's not a big issue.
> 
> > > * msecs_to_jiffies is what puts MAX_JIFFY_OFFSET there in the first
> > >   place, which means you add an extra comparison here that should
> > >   not really be needed.
> > 
> > Yes, but that allows us to keep things simple across all the helpers. I
> > haven't checked but I'd assume compiler inlining/optimization should
> > make this a non-issue anyway.
> 
> msecs_to_jiffies is a global function, so it won't normally get inlined.

Actually you were right about this. Now that I checked msecs_to_jiffies
does get inlined into msecs_to_jiffies_timeout but the comparison won't
get optimized away.

How about the following to solve the two issues you raised? Admittedly
somewhat bigger diff than the previous version :/

diff --git a/include/linux/jiffies.h b/include/linux/jiffies.h
index 8fb8edf..270a012 100644
--- a/include/linux/jiffies.h
+++ b/include/linux/jiffies.h
@@ -272,16 +272,17 @@ extern unsigned long preset_lpj;
  */
 #define USEC_ROUND (u64)(((u64)1 << USEC_JIFFIE_SC) - 1)
 /*
- * The maximum jiffie value is (MAX_INT >> 1).  Here we translate that
+ * The passed jiffy value can be at most (MAX_INT >> 1).  We translate
that
  * into seconds.  The 64-bit case will overflow if we are not careful,
- * so use the messy SH_DIV macro to do it.  Still all constants.
+ * so use the messy SH_DIV macro to do it.  Still all constants if the
+ * parameter is constant.
  */
 #if BITS_PER_LONG < 64
-# define MAX_SEC_IN_JIFFIES \
-	(long)((u64)((u64)MAX_JIFFY_OFFSET * TICK_NSEC) / NSEC_PER_SEC)
+# define JIFFIES_TO_SEC(j) \
+	(long)((u64)((u64)(j) * TICK_NSEC) / NSEC_PER_SEC)
 #else	/* take care of overflow on 64 bits machines */
-# define MAX_SEC_IN_JIFFIES \
-	(SH_DIV((MAX_JIFFY_OFFSET >> SEC_JIFFIE_SC) * TICK_NSEC, NSEC_PER_SEC,
1) - 1)
+# define JIFFIES_TO_SEC(j) \
+	(SH_DIV(((j) >> SEC_JIFFIE_SC) * TICK_NSEC, NSEC_PER_SEC, 1) - 1)
 
 #endif
 
@@ -311,6 +312,11 @@ extern u64 nsec_to_clock_t(u64 x);
 extern u64 nsecs_to_jiffies64(u64 n);
 extern unsigned long nsecs_to_jiffies(u64 n);
 
+extern unsigned long msecs_to_jiffies_timeout(const unsigned int m);
+extern unsigned long usecs_to_jiffies_timeout(const unsigned int u);
+extern unsigned long timespec_to_jiffies_timeout(const struct timespec
*value);
+extern unsigned long timeval_to_jiffies_timeout(const struct timeval
*value);
+
 #define TIMESTAMP_SIZE	30
 
 #endif
diff --git a/kernel/time.c b/kernel/time.c
index d3617db..00f9f7c 100644
--- a/kernel/time.c
+++ b/kernel/time.c
@@ -434,7 +434,8 @@ EXPORT_SYMBOL(ns_to_timeval);
  *
  * We must also be careful about 32-bit overflows.
  */
-unsigned long msecs_to_jiffies(const unsigned int m)
+static unsigned long __msecs_to_jiffies_delta(const unsigned int m,
+					      const int delta)
 {
 	/*
 	 * Negative value, means infinite timeout:
@@ -448,7 +449,7 @@ unsigned long msecs_to_jiffies(const unsigned int m)
 	 * round multiple of HZ, divide with the factor between them,
 	 * but round upwards:
 	 */
-	return (m + (MSEC_PER_SEC / HZ) - 1) / (MSEC_PER_SEC / HZ);
+	return (m + (MSEC_PER_SEC / HZ) - 1) / (MSEC_PER_SEC / HZ) + delta;
 #elif HZ > MSEC_PER_SEC && !(HZ % MSEC_PER_SEC)
 	/*
 	 * HZ is larger than 1000, and HZ is a nice round multiple of
@@ -457,40 +458,78 @@ unsigned long msecs_to_jiffies(const unsigned int
m)
 	 * But first make sure the multiplication result cannot
 	 * overflow:
 	 */
-	if (m > jiffies_to_msecs(MAX_JIFFY_OFFSET))
+	if (m > jiffies_to_msecs(MAX_JIFFY_OFFSET - delta))
 		return MAX_JIFFY_OFFSET;
 
-	return m * (HZ / MSEC_PER_SEC);
+	return m * (HZ / MSEC_PER_SEC) + delta;
 #else
 	/*
 	 * Generic case - multiply, round and divide. But first
 	 * check that if we are doing a net multiplication, that
 	 * we wouldn't overflow:
 	 */
-	if (HZ > MSEC_PER_SEC && m > jiffies_to_msecs(MAX_JIFFY_OFFSET))
+	if (HZ > MSEC_PER_SEC && m > jiffies_to_msecs(MAX_JIFFY_OFFSET -
delta))
 		return MAX_JIFFY_OFFSET;
 
-	return (MSEC_TO_HZ_MUL32 * m + MSEC_TO_HZ_ADJ32)
-		>> MSEC_TO_HZ_SHR32;
+	return ((MSEC_TO_HZ_MUL32 * m + MSEC_TO_HZ_ADJ32)
+		>> MSEC_TO_HZ_SHR32) + delta;
 #endif
 }
+
+unsigned long msecs_to_jiffies(const unsigned int m)
+{
+	return __msecs_to_jiffies_delta(m, 0);
+}
 EXPORT_SYMBOL(msecs_to_jiffies);
 
-unsigned long usecs_to_jiffies(const unsigned int u)
+/**
+ * msecs_to_jiffies_timeout - Convert msecs to jiffies with guaranteed
minimum duration
+ *
+ * Works similarly to msecs_to_jiffies(), but returns a value that
represents
+ * a wait time that is guaranteed to be at least the given msecs
duration. In
+ * contrast the value returned by msecs_to_jiffies() represents a wait
time
+ * that can be up to 1 jiffy less than the specified msecs duration,
depending
+ * on which point in time between two scheduling clock ticks we use the
+ * returned jiffy value.
+ */
+unsigned long msecs_to_jiffies_timeout(const unsigned int m)
+{
+	return __msecs_to_jiffies_delta(m, 1);
+}
+EXPORT_SYMBOL(msecs_to_jiffies_timeout);
+
+static unsigned long __usecs_to_jiffies_delta(const unsigned int u,
+					      const int delta)
 {
-	if (u > jiffies_to_usecs(MAX_JIFFY_OFFSET))
+	if (u > jiffies_to_usecs(MAX_JIFFY_OFFSET - delta))
 		return MAX_JIFFY_OFFSET;
 #if HZ <= USEC_PER_SEC && !(USEC_PER_SEC % HZ)
-	return (u + (USEC_PER_SEC / HZ) - 1) / (USEC_PER_SEC / HZ);
+	return (u + (USEC_PER_SEC / HZ) - 1) / (USEC_PER_SEC / HZ) + delta;
 #elif HZ > USEC_PER_SEC && !(HZ % USEC_PER_SEC)
-	return u * (HZ / USEC_PER_SEC);
+	return u * (HZ / USEC_PER_SEC) + delta;
 #else
-	return (USEC_TO_HZ_MUL32 * u + USEC_TO_HZ_ADJ32)
-		>> USEC_TO_HZ_SHR32;
+	return ((USEC_TO_HZ_MUL32 * u + USEC_TO_HZ_ADJ32)
+		>> USEC_TO_HZ_SHR32) + delta;
 #endif
 }
+
+unsigned long usecs_to_jiffies(const unsigned int u)
+{
+	return __usecs_to_jiffies_delta(u, 0);
+}
 EXPORT_SYMBOL(usecs_to_jiffies);
 
+/**
+ * usecs_to_jiffies_timeout - Convert usecs to jiffies with guaranteed
minimum duration
+ *
+ * Works like msecs_to_jiffies_timeout(), but takes usecs.
+ */
+unsigned long usecs_to_jiffies_timeout(const unsigned int u)
+{
+	return __usecs_to_jiffies_delta(u, 1);
+}
+EXPORT_SYMBOL(usecs_to_jiffies_timeout);
+
 /*
  * The TICK_NSEC - 1 rounds up the value to the next resolution.  Note
  * that a remainder subtract here would not do the right thing as the
@@ -502,23 +541,41 @@ EXPORT_SYMBOL(usecs_to_jiffies);
  * The >> (NSEC_JIFFIE_SC - SEC_JIFFIE_SC) converts the scaled nsec
  * value to a scaled second value.
  */
-unsigned long
-timespec_to_jiffies(const struct timespec *value)
+static unsigned long
+__timespec_to_jiffies_delta(const struct timespec *value, const int
delta)
 {
 	unsigned long sec = value->tv_sec;
 	long nsec = value->tv_nsec + TICK_NSEC - 1;
 
-	if (sec >= MAX_SEC_IN_JIFFIES){
-		sec = MAX_SEC_IN_JIFFIES;
+	if (sec >= JIFFIES_TO_SEC(MAX_JIFFY_OFFSET - delta)) {
+		sec = JIFFIES_TO_SEC(MAX_JIFFY_OFFSET - delta);
 		nsec = 0;
 	}
-	return (((u64)sec * SEC_CONVERSION) +
+	return ((((u64)sec * SEC_CONVERSION) +
 		(((u64)nsec * NSEC_CONVERSION) >>
-		 (NSEC_JIFFIE_SC - SEC_JIFFIE_SC))) >> SEC_JIFFIE_SC;
+		 (NSEC_JIFFIE_SC - SEC_JIFFIE_SC))) >> SEC_JIFFIE_SC) + delta;
+
+}
 
+unsigned long
+timespec_to_jiffies(const struct timespec *value)
+{
+	return __timespec_to_jiffies_delta(value, 0);
 }
 EXPORT_SYMBOL(timespec_to_jiffies);
 
+/**
+ * timespec_to_jiffies_timeout - Convert timespec to jiffies with
guaranteed minimum duration
+ *
+ * Works like msecs_to_jiffies_timeout(), but takes a timespec.
+ */
+unsigned long
+timespec_to_jiffies_timeout(const struct timespec *value)
+{
+	return __timespec_to_jiffies_delta(value, 1);
+}
+EXPORT_SYMBOL(timespec_to_jiffies_timeout);
+
 void
 jiffies_to_timespec(const unsigned long jiffies, struct timespec
*value)
 {
@@ -545,22 +602,40 @@ EXPORT_SYMBOL(jiffies_to_timespec);
  * Instruction wise, this should cost only an additional add with carry
  * instruction above the way it was done above.
  */
-unsigned long
-timeval_to_jiffies(const struct timeval *value)
+static unsigned long
+__timeval_to_jiffies_delta(const struct timeval *value, const int
delta)
 {
 	unsigned long sec = value->tv_sec;
 	long usec = value->tv_usec;
 
-	if (sec >= MAX_SEC_IN_JIFFIES){
-		sec = MAX_SEC_IN_JIFFIES;
+	if (sec >= JIFFIES_TO_SEC(MAX_JIFFY_OFFSET - delta)) {
+		sec = JIFFIES_TO_SEC(MAX_JIFFY_OFFSET - delta);
 		usec = 0;
 	}
-	return (((u64)sec * SEC_CONVERSION) +
+	return ((((u64)sec * SEC_CONVERSION) +
 		(((u64)usec * USEC_CONVERSION + USEC_ROUND) >>
-		 (USEC_JIFFIE_SC - SEC_JIFFIE_SC))) >> SEC_JIFFIE_SC;
+		 (USEC_JIFFIE_SC - SEC_JIFFIE_SC))) >> SEC_JIFFIE_SC) + delta;
+}
+
+unsigned long
+timeval_to_jiffies(const struct timeval *value)
+{
+	return __timeval_to_jiffies_delta(value, 0);
 }
 EXPORT_SYMBOL(timeval_to_jiffies);
 
+/**
+ * timeval_to_jiffies_timeout - Convert timeval to jiffies with
guaranteed minimum duration
+ *
+ * Works like msecs_to_jiffies_timeout(), but takes a timeval.
+ */
+unsigned long
+timeval_to_jiffies_timeout(const struct timeval *value)
+{
+	return __timeval_to_jiffies_delta(value, 1);
+}
+EXPORT_SYMBOL(timeval_to_jiffies_timeout);
+
 void jiffies_to_timeval(const unsigned long jiffies, struct timeval
*value)
 {
 	/*


