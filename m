Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752010Ab3BUTVT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 14:21:19 -0500
Received: from mail-da0-f44.google.com ([209.85.210.44]:59454 "EHLO
	mail-da0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751266Ab3BUTVR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 14:21:17 -0500
From: Kevin Hilman <khilman@linaro.org>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Mats Liljegren <mats.liljegren@enea.com>, linaro-dev@lists.linaro.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC/PATCH 4/5] cputime: use do_div() for nsec resolution conversion helpers
References: <1361389302-11968-1-git-send-email-khilman@linaro.org>
	<1361389302-11968-5-git-send-email-khilman@linaro.org>
	<20130221175857.GB14256@danjae.linux.parc55>
Date: Thu, 21 Feb 2013 11:21:13 -0800
In-Reply-To: <20130221175857.GB14256@danjae.linux.parc55> (Namhyung Kim's
	message of "Thu, 21 Feb 2013 09:58:57 -0800")
Message-ID: <87621lo4ly.fsf@linaro.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Namhyung Kim <namhyung@kernel.org> writes:

> Hi Kevin,
>
> On Wed, Feb 20, 2013 at 11:41:41AM -0800, Kevin Hilman wrote:
>> For the nsec resolution conversions to be useful on non 64-bit
>> architectures, do_div() needs to be used for the 64-bit divisions.
>> 
>> Signed-off-by: Kevin Hilman <khilman@linaro.org>
>> ---
>>  include/asm-generic/cputime_nsecs.h | 51 +++++++++++++++++++++++++++----------
>>  1 file changed, 37 insertions(+), 14 deletions(-)
>> 
>> diff --git a/include/asm-generic/cputime_nsecs.h b/include/asm-generic/cputime_nsecs.h
>> index b6485ca..daa6075 100644
>> --- a/include/asm-generic/cputime_nsecs.h
>> +++ b/include/asm-generic/cputime_nsecs.h
>> @@ -24,13 +24,17 @@ typedef u64 __nocast cputime64_t;
>>  /*
>>   * Convert cputime <-> jiffies (HZ)
>>   */
>> -#define cputime_to_jiffies(__ct)	\
>> -	((__force u64)(__ct) / (NSEC_PER_SEC / HZ))
>> +static inline u64 cputime_to_jiffies(const cputime_t ct)
>> +{
>> +	cputime_t __ct = ct;
>
> Why it removed the "(__force u64)" conversion part?  Shouldn't it be:
>
> 	u64 __ct = (__force u64) ct;
>
> ?

You're right, that was an oversight.  Updated patch below.

Frederic, if you merge this, please take the one below with the __force
attributes added back.

I've updated my branch to include the fixed version.

Kevin


>From a8a0a8b8b12512a7f862ade459cd88d2b48e2bf3 Mon Sep 17 00:00:00 2001
From: Kevin Hilman <khilman@linaro.org>
Date: Thu, 14 Feb 2013 11:27:36 -0800
Subject: [PATCH 4/5] cputime: use do_div() for nsec resolution conversion
 helpers

For the nsec resolution conversions to be useful on non 64-bit
architectures, do_div() needs to be used for the 64-bit divisions.

Special thanks to Namhyung Kim for pointing out omissions of the
__force attribute in an earlier version.

Cc: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Kevin Hilman <khilman@linaro.org>
---
 include/asm-generic/cputime_nsecs.h | 51 +++++++++++++++++++++++++++----------
 1 file changed, 37 insertions(+), 14 deletions(-)

diff --git a/include/asm-generic/cputime_nsecs.h b/include/asm-generic/cputime_nsecs.h
index b6485ca..d4944c9 100644
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
+	u64 __ct = (__force u64) ct;
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
+	u64 __ct = (__force u64) ct;
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
+	u64 __ct = (__force u64) ct;
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
+	u64 __ct = (__force u64) ct;
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
+	u64 __ct = (__force u64) ct;
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
+	u64 __ct = (__force u64) ct;
+
+	do_div(__ct, (NSEC_PER_SEC / USER_HZ));
+	return __ct;
+}
 #define clock_t_to_cputime(__x)		\
 	(__force cputime_t)((__x) * (NSEC_PER_SEC / USER_HZ))
 
-- 
1.8.1.2

