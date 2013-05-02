Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757266Ab3EBJG1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 05:06:27 -0400
Received: from mail-ea0-f169.google.com ([209.85.215.169]:41591 "EHLO
	mail-ea0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751529Ab3EBJGZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 05:06:25 -0400
Date: Thu, 2 May 2013 11:06:20 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [GIT PULL] scheduler fixes
Message-ID: <20130502090620.GA28742@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest sched-urgent-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git sched-urgent-for-linus

   HEAD: f3002134158092178be81339ec5a22ff80e6c308 Revert "math64: New div64_u64_rem helper"

This fixes the cputime scaling overflow problems for good without having 
bad 32-bit overhead, and gets rid of the div64_u64_rem() helper as well.

	Ingo

------------------>
Stanislaw Gruszka (4):
      sched: Avoid cputime scaling overflow
      sched: Do not account bogus utime
      sched: Avoid prev->stime underflow
      Revert "math64: New div64_u64_rem helper"


 include/linux/math64.h | 19 +-----------
 kernel/sched/cputime.c | 80 ++++++++++++++++++++++++++++++++------------------
 lib/div64.c            | 19 ++++--------
 3 files changed, 58 insertions(+), 60 deletions(-)

diff --git a/include/linux/math64.h b/include/linux/math64.h
index 931a619..b8ba855 100644
--- a/include/linux/math64.h
+++ b/include/linux/math64.h
@@ -30,15 +30,6 @@ static inline s64 div_s64_rem(s64 dividend, s32 divisor, s32 *remainder)
 }
 
 /**
- * div64_u64_rem - unsigned 64bit divide with 64bit divisor
- */
-static inline u64 div64_u64_rem(u64 dividend, u64 divisor, u64 *remainder)
-{
-	*remainder = dividend % divisor;
-	return dividend / divisor;
-}
-
-/**
  * div64_u64 - unsigned 64bit divide with 64bit divisor
  */
 static inline u64 div64_u64(u64 dividend, u64 divisor)
@@ -70,16 +61,8 @@ static inline u64 div_u64_rem(u64 dividend, u32 divisor, u32 *remainder)
 extern s64 div_s64_rem(s64 dividend, s32 divisor, s32 *remainder);
 #endif
 
-#ifndef div64_u64_rem
-extern u64 div64_u64_rem(u64 dividend, u64 divisor, u64 *remainder);
-#endif
-
 #ifndef div64_u64
-static inline u64 div64_u64(u64 dividend, u64 divisor)
-{
-	u64 remainder;
-	return div64_u64_rem(dividend, divisor, &remainder);
-}
+extern u64 div64_u64(u64 dividend, u64 divisor);
 #endif
 
 #ifndef div64_s64
diff --git a/kernel/sched/cputime.c b/kernel/sched/cputime.c
index 33508dc..337a367 100644
--- a/kernel/sched/cputime.c
+++ b/kernel/sched/cputime.c
@@ -506,34 +506,47 @@ void account_idle_ticks(unsigned long ticks)
 }
 
 /*
- * Perform (stime * rtime) / total with reduced chances
- * of multiplication overflows by using smaller factors
- * like quotient and remainders of divisions between
- * rtime and total.
+ * Perform (stime * rtime) / total, but avoid multiplication overflow by
+ * loosing precision when the numbers are big.
  */
 static cputime_t scale_stime(u64 stime, u64 rtime, u64 total)
 {
-	u64 rem, res, scaled;
+	u64 scaled;
 
-	if (rtime >= total) {
-		/*
-		 * Scale up to rtime / total then add
-		 * the remainder scaled to stime / total.
-		 */
-		res = div64_u64_rem(rtime, total, &rem);
-		scaled = stime * res;
-		scaled += div64_u64(stime * rem, total);
-	} else {
-		/*
-		 * Same in reverse: scale down to total / rtime
-		 * then substract that result scaled to
-		 * to the remaining part.
-		 */
-		res = div64_u64_rem(total, rtime, &rem);
-		scaled = div64_u64(stime, res);
-		scaled -= div64_u64(scaled * rem, total);
+	for (;;) {
+		/* Make sure "rtime" is the bigger of stime/rtime */
+		if (stime > rtime) {
+			u64 tmp = rtime; rtime = stime; stime = tmp;
+		}
+
+		/* Make sure 'total' fits in 32 bits */
+		if (total >> 32)
+			goto drop_precision;
+
+		/* Does rtime (and thus stime) fit in 32 bits? */
+		if (!(rtime >> 32))
+			break;
+
+		/* Can we just balance rtime/stime rather than dropping bits? */
+		if (stime >> 31)
+			goto drop_precision;
+
+		/* We can grow stime and shrink rtime and try to make them both fit */
+		stime <<= 1;
+		rtime >>= 1;
+		continue;
+
+drop_precision:
+		/* We drop from rtime, it has more bits than stime */
+		rtime >>= 1;
+		total >>= 1;
 	}
 
+	/*
+	 * Make sure gcc understands that this is a 32x32->64 multiply,
+	 * followed by a 64/32->64 divide.
+	 */
+	scaled = div_u64((u64) (u32) stime * (u64) (u32) rtime, (u32)total);
 	return (__force cputime_t) scaled;
 }
 
@@ -545,7 +558,7 @@ static void cputime_adjust(struct task_cputime *curr,
 			   struct cputime *prev,
 			   cputime_t *ut, cputime_t *st)
 {
-	cputime_t rtime, stime, total;
+	cputime_t rtime, stime, utime, total;
 
 	if (vtime_accounting_enabled()) {
 		*ut = curr->utime;
@@ -568,13 +581,21 @@ static void cputime_adjust(struct task_cputime *curr,
 	 */
 	rtime = nsecs_to_cputime(curr->sum_exec_runtime);
 
-	if (!rtime) {
-		stime = 0;
-	} else if (!total) {
-		stime = rtime;
-	} else {
+	/*
+	 * Update userspace visible utime/stime values only if actual execution
+	 * time is bigger than already exported. Note that can happen, that we
+	 * provided bigger values due to scaling inaccuracy on big numbers.
+	 */
+	if (prev->stime + prev->utime >= rtime)
+		goto out;
+
+	if (total) {
 		stime = scale_stime((__force u64)stime,
 				    (__force u64)rtime, (__force u64)total);
+		utime = rtime - stime;
+	} else {
+		stime = rtime;
+		utime = 0;
 	}
 
 	/*
@@ -583,8 +604,9 @@ static void cputime_adjust(struct task_cputime *curr,
 	 * Let's enforce monotonicity.
 	 */
 	prev->stime = max(prev->stime, stime);
-	prev->utime = max(prev->utime, rtime - prev->stime);
+	prev->utime = max(prev->utime, utime);
 
+out:
 	*ut = prev->utime;
 	*st = prev->stime;
 }
diff --git a/lib/div64.c b/lib/div64.c
index 3af5728..a163b6c 100644
--- a/lib/div64.c
+++ b/lib/div64.c
@@ -79,10 +79,9 @@ EXPORT_SYMBOL(div_s64_rem);
 #endif
 
 /**
- * div64_u64_rem - unsigned 64bit divide with 64bit divisor and 64bit remainder
+ * div64_u64 - unsigned 64bit divide with 64bit divisor
  * @dividend:	64bit dividend
  * @divisor:	64bit divisor
- * @remainder:  64bit remainder
  *
  * This implementation is a modified version of the algorithm proposed
  * by the book 'Hacker's Delight'.  The original source and full proof
@@ -90,33 +89,27 @@ EXPORT_SYMBOL(div_s64_rem);
  *
  * 'http://www.hackersdelight.org/HDcode/newCode/divDouble.c.txt'
  */
-#ifndef div64_u64_rem
-u64 div64_u64_rem(u64 dividend, u64 divisor, u64 *remainder)
+#ifndef div64_u64
+u64 div64_u64(u64 dividend, u64 divisor)
 {
 	u32 high = divisor >> 32;
 	u64 quot;
 
 	if (high == 0) {
-		u32 rem32;
-		quot = div_u64_rem(dividend, divisor, &rem32);
-		*remainder = rem32;
+		quot = div_u64(dividend, divisor);
 	} else {
 		int n = 1 + fls(high);
 		quot = div_u64(dividend >> n, divisor >> n);
 
 		if (quot != 0)
 			quot--;
-
-		*remainder = dividend - quot * divisor;
-		if (*remainder >= divisor) {
+		if ((dividend - quot * divisor) >= divisor)
 			quot++;
-			*remainder -= divisor;
-		}
 	}
 
 	return quot;
 }
-EXPORT_SYMBOL(div64_u64_rem);
+EXPORT_SYMBOL(div64_u64);
 #endif
 
 /**
