Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755375AbaHHAJt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 20:09:49 -0400
Received: from mail-pa0-f73.google.com ([209.85.220.73]:36559 "EHLO
	mail-pa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752827AbaHHAJq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 20:09:46 -0400
From: Andrew Hunter <ahh@google.com>
To: linux-kernel@vger.kernel.org, john.stultz@linaro.org, tglx@linutronix.de,
        unmobile@gmail.com, pjt@google.com, jacobsa@google.com
Cc: Andrew Hunter <ahh@google.com>
Subject: [PATCH] sched: fix timeval conversion to jiffies
Date: Thu,  7 Aug 2014 17:09:18 -0700
Message-Id: <1407456558-18509-1-git-send-email-ahh@google.com>
X-Mailer: git-send-email 2.0.0.526.g5318336
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

timeval_to_jiffies rounding was broken.  It essentially computed
(eliding seconds)

jiffies = usec  * (NSEC_PER_USEC/TICK_NSEC)

by using scaling arithmetic, which took the best approximation of
NSEC_PER_USEC/TICK_NSEC with denominator of 2^USEC_JIFFIE_SC =
x/(2^USEC_JIFFIE_SC), and computed:

jiffies = (usec * x) >> USEC_JIFFIE_SC

and it rounded this calculation up in the intermediate form (since we
can't necessarily exactly represent TICK_NSEC in usec.) But the
scaling arithmetic is a (very slight) *over*approximation of the true
value: rounding the division up by adding 2^USEC_JIFFIE_SC - 1, when
the error in scaling was added in, was sufficient to add one jiffie to
the final result.

In particular, with HZ=1000, we consistently computed that 10000 usec
was 11 jiffies; the same was true for any exact multiple of
TICK_NSEC. This is obviously bad as a general rule, and caused
observable user problems with setitimer() at the very least:

setitimer(ITIMER_PROF, &val, NULL);
setitimer(ITIMER_PROF, NULL, &val);

would actually add a tick to val!

We could possibly still round in the intermediate form, adding
something less than 2^USEC_JIFFIE_SC - 1, but easier still is to
convert usec->nsec, round in nanoseconds, and then convert using
time*spec*_to_jiffies.  This adds one constant multiplication, and is
not observably slower in microbenchmarks on recent x86 hardware.

Tested: the following program:

int main() {
  struct itimerval zero = {{0, 0}, {0, 0}};
  /* Initially set to 10 ms. */
  struct itimerval initial = zero;
  initial.it_interval.tv_usec = 10000;
  setitimer(ITIMER_PROF, &initial, NULL);
  /* Save and restore several times. */
  for (size_t i = 0; i < 10; ++i) {
    struct itimerval prev;
    setitimer(ITIMER_PROF, &zero, &prev);
    /* on old kernels, this goes up by TICK_USEC every iteration */
    printf("previous value: %ld %ld %ld %ld\n",
           prev.it_interval.tv_sec, prev.it_interval.tv_usec,
           prev.it_value.tv_sec, prev.it_value.tv_usec);
    setitimer(ITIMER_PROF, &prev, NULL);
  }
    return 0;
}

Signed-off-by: Andrew Hunter <ahh@google.com>
Reviewed-by: Paul Turner <pjt@google.com>
Reported-by: Aaron Jacobs <jacobsa@google.com>
Change-Id: I7cd0f0764847fd055d39531f54e6ea3dd3ce5453
---
 include/linux/jiffies.h | 12 -----------
 kernel/time.c           | 54 +++++++++++++++++++++++++++----------------------
 2 files changed, 30 insertions(+), 36 deletions(-)

diff --git a/include/linux/jiffies.h b/include/linux/jiffies.h
index 1f44466..c367cbd 100644
--- a/include/linux/jiffies.h
+++ b/include/linux/jiffies.h
@@ -258,23 +258,11 @@ extern unsigned long preset_lpj;
 #define SEC_JIFFIE_SC (32 - SHIFT_HZ)
 #endif
 #define NSEC_JIFFIE_SC (SEC_JIFFIE_SC + 29)
-#define USEC_JIFFIE_SC (SEC_JIFFIE_SC + 19)
 #define SEC_CONVERSION ((unsigned long)((((u64)NSEC_PER_SEC << SEC_JIFFIE_SC) +\
                                 TICK_NSEC -1) / (u64)TICK_NSEC))
 
 #define NSEC_CONVERSION ((unsigned long)((((u64)1 << NSEC_JIFFIE_SC) +\
                                         TICK_NSEC -1) / (u64)TICK_NSEC))
-#define USEC_CONVERSION  \
-                    ((unsigned long)((((u64)NSEC_PER_USEC << USEC_JIFFIE_SC) +\
-                                        TICK_NSEC -1) / (u64)TICK_NSEC))
-/*
- * USEC_ROUND is used in the timeval to jiffie conversion.  See there
- * for more details.  It is the scaled resolution rounding value.  Note
- * that it is a 64-bit value.  Since, when it is applied, we are already
- * in jiffies (albit scaled), it is nothing but the bits we will shift
- * off.
- */
-#define USEC_ROUND (u64)(((u64)1 << USEC_JIFFIE_SC) - 1)
 /*
  * The maximum jiffie value is (MAX_INT >> 1).  Here we translate that
  * into seconds.  The 64-bit case will overflow if we are not careful,
diff --git a/kernel/time.c b/kernel/time.c
index 7c7964c..3c49ab4 100644
--- a/kernel/time.c
+++ b/kernel/time.c
@@ -496,17 +496,20 @@ EXPORT_SYMBOL(usecs_to_jiffies);
  * that a remainder subtract here would not do the right thing as the
  * resolution values don't fall on second boundries.  I.e. the line:
  * nsec -= nsec % TICK_NSEC; is NOT a correct resolution rounding.
+ * Note that due to the small error in the multiplier here, this
+ * rounding is incorrect for sufficiently large values of tv_nsec, but
+ * well formed timespecs should have tv_nsec < NSEC_PER_SEC, so we're
+ * OK.
  *
  * Rather, we just shift the bits off the right.
  *
  * The >> (NSEC_JIFFIE_SC - SEC_JIFFIE_SC) converts the scaled nsec
  * value to a scaled second value.
  */
-unsigned long
-timespec_to_jiffies(const struct timespec *value)
+static unsigned long
+__timespec_to_jiffies(unsigned long sec, long nsec)
 {
-	unsigned long sec = value->tv_sec;
-	long nsec = value->tv_nsec + TICK_NSEC - 1;
+	nsec = nsec + TICK_NSEC - 1;
 
 	if (sec >= MAX_SEC_IN_JIFFIES){
 		sec = MAX_SEC_IN_JIFFIES;
@@ -517,6 +520,13 @@ timespec_to_jiffies(const struct timespec *value)
 		 (NSEC_JIFFIE_SC - SEC_JIFFIE_SC))) >> SEC_JIFFIE_SC;
 
 }
+
+unsigned long
+timespec_to_jiffies(const struct timespec *value)
+{
+	return __timespec_to_jiffies(value->tv_sec, value->tv_nsec);
+}
+
 EXPORT_SYMBOL(timespec_to_jiffies);
 
 void
@@ -533,31 +543,27 @@ jiffies_to_timespec(const unsigned long jiffies, struct timespec *value)
 }
 EXPORT_SYMBOL(jiffies_to_timespec);
 
-/* Same for "timeval"
+/*
+ * We could use a similar algorithm to timespec_to_jiffies (with a
+ * different multiplier for usec instead of nsec). But this has a
+ * problem with rounding: we can't exactly add TICK_NSEC - 1 to the
+ * usec value, since it's not necessarily integral.
  *
- * Well, almost.  The problem here is that the real system resolution is
- * in nanoseconds and the value being converted is in micro seconds.
- * Also for some machines (those that use HZ = 1024, in-particular),
- * there is a LARGE error in the tick size in microseconds.
-
- * The solution we use is to do the rounding AFTER we convert the
- * microsecond part.  Thus the USEC_ROUND, the bits to be shifted off.
- * Instruction wise, this should cost only an additional add with carry
- * instruction above the way it was done above.
+ * We could instead round in the intermediate scaled representation
+ * (i.e. in units of 1/2^(large scale) jiffies) but that's also
+ * perilous: the scaling introduces a small positive error, which
+ * combined with a division-rounding-upward (i.e. adding 2^(scale) - 1
+ * units to the intermediate before shifting) leads to accidental
+ * overflow and overestimates.
+ *
+ * At the cost of one additional multiplication by a constant, just
+ * use the timespec implementation.
  */
 unsigned long
 timeval_to_jiffies(const struct timeval *value)
 {
-	unsigned long sec = value->tv_sec;
-	long usec = value->tv_usec;
-
-	if (sec >= MAX_SEC_IN_JIFFIES){
-		sec = MAX_SEC_IN_JIFFIES;
-		usec = 0;
-	}
-	return (((u64)sec * SEC_CONVERSION) +
-		(((u64)usec * USEC_CONVERSION + USEC_ROUND) >>
-		 (USEC_JIFFIE_SC - SEC_JIFFIE_SC))) >> SEC_JIFFIE_SC;
+	return __timespec_to_jiffies(value->tv_sec,
+				     value->tv_usec * NSEC_PER_USEC);
 }
 EXPORT_SYMBOL(timeval_to_jiffies);
 
-- 
2.0.0.526.g5318336

