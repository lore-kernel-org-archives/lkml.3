Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755306Ab3CTXeg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 19:34:36 -0400
Received: from mail-pb0-f54.google.com ([209.85.160.54]:37764 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754414Ab3CTXee (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 19:34:34 -0400
From: Kevin Hilman <khilman@linaro.org>
To: Frederic Weisbecker <fweisbec@gmail.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        linux-kernel@vger.kernel.org
Cc: Paul McKenney <paulmck@linux.vnet.ibm.com>,
        linux-arm-kernel@lists.infradead.org, linaro-kernel@lists.linaro.org
Subject: [PATCH 1/3] cputime_nsecs: use math64.h for nsec resolution conversion helpers
Date: Wed, 20 Mar 2013 16:34:25 -0700
Message-Id: <1363822467-6275-2-git-send-email-khilman@linaro.org>
X-Mailer: git-send-email 1.8.2
In-Reply-To: <1363822467-6275-1-git-send-email-khilman@linaro.org>
References: <1363822467-6275-1-git-send-email-khilman@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For the nsec resolution conversions to be useable on non 64-bit
architectures, the helpers in <linux/math64.h> need to be used so the
right arch-specific 64-bit math helpers can be used (e.g. do_div())

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Kevin Hilman <khilman@linaro.org>
---
 include/asm-generic/cputime_nsecs.h | 28 +++++++++++++++++++---------
 1 file changed, 19 insertions(+), 9 deletions(-)

diff --git a/include/asm-generic/cputime_nsecs.h b/include/asm-generic/cputime_nsecs.h
index a8ece9a..2c9e62c 100644
--- a/include/asm-generic/cputime_nsecs.h
+++ b/include/asm-generic/cputime_nsecs.h
@@ -16,21 +16,27 @@
 #ifndef _ASM_GENERIC_CPUTIME_NSECS_H
 #define _ASM_GENERIC_CPUTIME_NSECS_H
 
+#include <linux/math64.h>
+
 typedef u64 __nocast cputime_t;
 typedef u64 __nocast cputime64_t;
 
 #define cputime_one_jiffy		jiffies_to_cputime(1)
 
+#define cputime_div(__ct, divisor)  div_u64((__force u64)__ct, divisor)
+#define cputime_div_rem(__ct, divisor, remainder) \
+	div_u64_rem((__force u64)__ct, divisor, remainder);
+
 /*
  * Convert cputime <-> jiffies (HZ)
  */
 #define cputime_to_jiffies(__ct)	\
-	((__force u64)(__ct) / (NSEC_PER_SEC / HZ))
+	cputime_div(__ct, NSEC_PER_SEC / HZ)
 #define cputime_to_scaled(__ct)		(__ct)
 #define jiffies_to_cputime(__jif)	\
 	(__force cputime_t)((__jif) * (NSEC_PER_SEC / HZ))
 #define cputime64_to_jiffies64(__ct)	\
-	((__force u64)(__ct) / (NSEC_PER_SEC / HZ))
+	cputime_div(__ct, NSEC_PER_SEC / HZ)
 #define jiffies64_to_cputime64(__jif)	\
 	(__force cputime64_t)((__jif) * (NSEC_PER_SEC / HZ))
 
@@ -45,7 +51,7 @@ typedef u64 __nocast cputime64_t;
  * Convert cputime <-> microseconds
  */
 #define cputime_to_usecs(__ct)		\
-	((__force u64)(__ct) / NSEC_PER_USEC)
+	cputime_div(__ct, NSEC_PER_USEC)
 #define usecs_to_cputime(__usecs)	\
 	(__force cputime_t)((__usecs) * NSEC_PER_USEC)
 #define usecs_to_cputime64(__usecs)	\
@@ -55,7 +61,7 @@ typedef u64 __nocast cputime64_t;
  * Convert cputime <-> seconds
  */
 #define cputime_to_secs(__ct)		\
-	((__force u64)(__ct) / NSEC_PER_SEC)
+	cputime_div(__ct, NSEC_PER_SEC)
 #define secs_to_cputime(__secs)		\
 	(__force cputime_t)((__secs) * NSEC_PER_SEC)
 
@@ -69,8 +75,10 @@ static inline cputime_t timespec_to_cputime(const struct timespec *val)
 }
 static inline void cputime_to_timespec(const cputime_t ct, struct timespec *val)
 {
-	val->tv_sec  = (__force u64) ct / NSEC_PER_SEC;
-	val->tv_nsec = (__force u64) ct % NSEC_PER_SEC;
+	u32 rem;
+
+	val->tv_sec = cputime_div_rem(ct, NSEC_PER_SEC, &rem);
+	val->tv_nsec = rem;
 }
 
 /*
@@ -83,15 +91,17 @@ static inline cputime_t timeval_to_cputime(const struct timeval *val)
 }
 static inline void cputime_to_timeval(const cputime_t ct, struct timeval *val)
 {
-	val->tv_sec = (__force u64) ct / NSEC_PER_SEC;
-	val->tv_usec = ((__force u64) ct % NSEC_PER_SEC) / NSEC_PER_USEC;
+	u32 rem;
+
+	val->tv_sec = cputime_div_rem(ct, NSEC_PER_SEC, &rem);
+	val->tv_usec = rem / NSEC_PER_USEC;
 }
 
 /*
  * Convert cputime <-> clock (USER_HZ)
  */
 #define cputime_to_clock_t(__ct)	\
-	((__force u64)(__ct) / (NSEC_PER_SEC / USER_HZ))
+	cputime_div(__ct, (NSEC_PER_SEC / USER_HZ))
 #define clock_t_to_cputime(__x)		\
 	(__force cputime_t)((__x) * (NSEC_PER_SEC / USER_HZ))
 
-- 
1.8.2

