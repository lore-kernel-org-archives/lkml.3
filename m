Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935093Ab3BTTl7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 14:41:59 -0500
Received: from mail-pa0-f52.google.com ([209.85.220.52]:33708 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935027Ab3BTTlz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 14:41:55 -0500
From: Kevin Hilman <khilman@linaro.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mats Liljegren <mats.liljegren@enea.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linaro-dev@lists.linaro.org
Subject: [RFC/PATCH 4/5] cputime: use do_div() for nsec resolution conversion helpers
Date: Wed, 20 Feb 2013 11:41:41 -0800
Message-Id: <1361389302-11968-5-git-send-email-khilman@linaro.org>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1361389302-11968-1-git-send-email-khilman@linaro.org>
References: <1361389302-11968-1-git-send-email-khilman@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For the nsec resolution conversions to be useful on non 64-bit
architectures, do_div() needs to be used for the 64-bit divisions.

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

