Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754325AbaGPVVw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 17:21:52 -0400
Received: from www.linutronix.de ([62.245.132.108]:59617 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752330AbaGPVEB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 17:04:01 -0400
Message-Id: <20140716205052.849635925@linutronix.de>
User-Agent: quilt/0.63-1
Date: Wed, 16 Jul 2014 21:03:59 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: [patch V2 08/64] time: More core infrastructure for timespec64
References: <20140716205018.175419210@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline; filename=jstultz-tk-99c585d.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: John Stultz <john.stultz@linaro.org>

Helper and conversion functions for timespec64.

Signed-off-by: John Stultz <john.stultz@linaro.org>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

---
 include/linux/ktime.h  |   28 ++++++++++++++++++++++
 include/linux/time64.h |   28 ++++++++++++++++++++++
 kernel/time/time.c     |   62 +++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 118 insertions(+)

Index: tip/include/linux/ktime.h
===================================================================
--- tip.orig/include/linux/ktime.h
+++ tip/include/linux/ktime.h
@@ -83,6 +83,12 @@ static inline ktime_t timespec_to_ktime(
 	return ktime_set(ts.tv_sec, ts.tv_nsec);
 }
 
+/* convert a timespec64 to ktime_t format: */
+static inline ktime_t timespec64_to_ktime(struct timespec64 ts)
+{
+	return ktime_set(ts.tv_sec, ts.tv_nsec);
+}
+
 /* convert a timeval to ktime_t format: */
 static inline ktime_t timeval_to_ktime(struct timeval tv)
 {
@@ -92,6 +98,9 @@ static inline ktime_t timeval_to_ktime(s
 /* Map the ktime_t to timespec conversion to ns_to_timespec function */
 #define ktime_to_timespec(kt)		ns_to_timespec((kt).tv64)
 
+/* Map the ktime_t to timespec conversion to ns_to_timespec function */
+#define ktime_to_timespec64(kt)		ns_to_timespec64((kt).tv64)
+
 /* Map the ktime_t to timeval conversion to ns_to_timeval function */
 #define ktime_to_timeval(kt)		ns_to_timeval((kt).tv64)
 
@@ -186,6 +195,25 @@ static inline __must_check bool ktime_to
 		return true;
 	} else {
 		return false;
+	}
+}
+
+/**
+ * ktime_to_timespec64_cond - convert a ktime_t variable to timespec64
+ *			    format only if the variable contains data
+ * @kt:		the ktime_t variable to convert
+ * @ts:		the timespec variable to store the result in
+ *
+ * Return: %true if there was a successful conversion, %false if kt was 0.
+ */
+static inline __must_check bool ktime_to_timespec64_cond(const ktime_t kt,
+						       struct timespec64 *ts)
+{
+	if (kt.tv64) {
+		*ts = ktime_to_timespec64(kt);
+		return true;
+	} else {
+		return false;
 	}
 }
 
Index: tip/include/linux/time64.h
===================================================================
--- tip.orig/include/linux/time64.h
+++ tip/include/linux/time64.h
@@ -33,6 +33,16 @@ struct timespec64 {
 
 #if __BITS_PER_LONG == 64
 
+static inline struct timespec timespec64_to_timespec(const struct timespec64 ts64)
+{
+	return ts64;
+}
+
+static inline struct timespec64 timespec_to_timespec64(const struct timespec ts)
+{
+	return ts;
+}
+
 # define timespec64_equal		timespec_equal
 # define timespec64_compare		timespec_compare
 # define set_normalized_timespec64	set_normalized_timespec
@@ -47,6 +57,24 @@ struct timespec64 {
 
 #else
 
+static inline struct timespec timespec64_to_timespec(const struct timespec64 ts64)
+{
+	struct timespec ret;
+
+	ret.tv_sec = (time_t)ts64.tv_sec;
+	ret.tv_nsec = ts64.tv_nsec;
+	return ret;
+}
+
+static inline struct timespec64 timespec_to_timespec64(const struct timespec ts)
+{
+	struct timespec64 ret;
+
+	ret.tv_sec = ts.tv_sec;
+	ret.tv_nsec = ts.tv_nsec;
+	return ret;
+}
+
 static inline int timespec64_equal(const struct timespec64 *a,
 				   const struct timespec64 *b)
 {
Index: tip/kernel/time/time.c
===================================================================
--- tip.orig/kernel/time/time.c
+++ tip/kernel/time/time.c
@@ -420,6 +420,68 @@ struct timeval ns_to_timeval(const s64 n
 }
 EXPORT_SYMBOL(ns_to_timeval);
 
+#if BITS_PER_LONG == 32
+/**
+ * set_normalized_timespec - set timespec sec and nsec parts and normalize
+ *
+ * @ts:		pointer to timespec variable to be set
+ * @sec:	seconds to set
+ * @nsec:	nanoseconds to set
+ *
+ * Set seconds and nanoseconds field of a timespec variable and
+ * normalize to the timespec storage format
+ *
+ * Note: The tv_nsec part is always in the range of
+ *	0 <= tv_nsec < NSEC_PER_SEC
+ * For negative values only the tv_sec field is negative !
+ */
+void set_normalized_timespec64(struct timespec64 *ts, time64_t sec, s64 nsec)
+{
+	while (nsec >= NSEC_PER_SEC) {
+		/*
+		 * The following asm() prevents the compiler from
+		 * optimising this loop into a modulo operation. See
+		 * also __iter_div_u64_rem() in include/linux/time.h
+		 */
+		asm("" : "+rm"(nsec));
+		nsec -= NSEC_PER_SEC;
+		++sec;
+	}
+	while (nsec < 0) {
+		asm("" : "+rm"(nsec));
+		nsec += NSEC_PER_SEC;
+		--sec;
+	}
+	ts->tv_sec = sec;
+	ts->tv_nsec = nsec;
+}
+EXPORT_SYMBOL(set_normalized_timespec64);
+
+/**
+ * ns_to_timespec64 - Convert nanoseconds to timespec64
+ * @nsec:       the nanoseconds value to be converted
+ *
+ * Returns the timespec64 representation of the nsec parameter.
+ */
+struct timespec64 ns_to_timespec64(const s64 nsec)
+{
+	struct timespec64 ts;
+	s32 rem;
+
+	if (!nsec)
+		return (struct timespec64) {0, 0};
+
+	ts.tv_sec = div_s64_rem(nsec, NSEC_PER_SEC, &rem);
+	if (unlikely(rem < 0)) {
+		ts.tv_sec--;
+		rem += NSEC_PER_SEC;
+	}
+	ts.tv_nsec = rem;
+
+	return ts;
+}
+EXPORT_SYMBOL(ns_to_timespec64);
+#endif
 /*
  * When we convert to jiffies then we interpret incoming values
  * the following way:


