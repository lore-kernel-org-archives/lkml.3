Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752335AbaIMU4K (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Sep 2014 16:56:10 -0400
Received: from www.linutronix.de ([62.245.132.108]:54505 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752134AbaIMU4I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Sep 2014 16:56:08 -0400
Date: Sat, 13 Sep 2014 22:56:06 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: [GIT pull] timer fixes for 3.17
Message-ID: <alpine.DEB.2.10.1409132248310.23397@nanos>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

please pull the latest timers-urgent-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git timers-urgent-for-linus

The timer department is not too proud about the following fixes:

- Deal with a long standing rounding bug in the timeval to jiffies
  conversion. It's a real issue and this fix fell through the cracks
  for quite some time.

- Another round of alarmtimer fixes. Finally this code gets used more
  widely and the subtle issues hidden for quite some time are noticed
  and fixed. Nothing really exciting, just the itty bitty details
  which bite the serious users here and there.

Thanks,

	tglx

------------------>
Andrew Hunter (1):
      jiffies: Fix timeval conversion to jiffies

Richard Larocque (3):
      alarmtimer: Return relative times in timer_gettime
      alarmtimer: Do not signal SIGEV_NONE timers
      alarmtimer: Lock k_itimer during timer callback


 include/linux/jiffies.h  | 12 -----------
 kernel/time/alarmtimer.c | 34 +++++++++++++++++++----------
 kernel/time/time.c       | 56 +++++++++++++++++++++++++++---------------------
 3 files changed, 54 insertions(+), 48 deletions(-)

diff --git a/include/linux/jiffies.h b/include/linux/jiffies.h
index 1f44466c1e9d..c367cbdf73ab 100644
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
diff --git a/kernel/time/alarmtimer.c b/kernel/time/alarmtimer.c
index 4aec4a457431..a7077d3ae52f 100644
--- a/kernel/time/alarmtimer.c
+++ b/kernel/time/alarmtimer.c
@@ -464,18 +464,26 @@ static enum alarmtimer_type clock2alarm(clockid_t clockid)
 static enum alarmtimer_restart alarm_handle_timer(struct alarm *alarm,
 							ktime_t now)
 {
+	unsigned long flags;
 	struct k_itimer *ptr = container_of(alarm, struct k_itimer,
 						it.alarm.alarmtimer);
-	if (posix_timer_event(ptr, 0) != 0)
-		ptr->it_overrun++;
+	enum alarmtimer_restart result = ALARMTIMER_NORESTART;
+
+	spin_lock_irqsave(&ptr->it_lock, flags);
+	if ((ptr->it_sigev_notify & ~SIGEV_THREAD_ID) != SIGEV_NONE) {
+		if (posix_timer_event(ptr, 0) != 0)
+			ptr->it_overrun++;
+	}
 
 	/* Re-add periodic timers */
 	if (ptr->it.alarm.interval.tv64) {
 		ptr->it_overrun += alarm_forward(alarm, now,
 						ptr->it.alarm.interval);
-		return ALARMTIMER_RESTART;
+		result = ALARMTIMER_RESTART;
 	}
-	return ALARMTIMER_NORESTART;
+	spin_unlock_irqrestore(&ptr->it_lock, flags);
+
+	return result;
 }
 
 /**
@@ -541,18 +549,22 @@ static int alarm_timer_create(struct k_itimer *new_timer)
  * @new_timer: k_itimer pointer
  * @cur_setting: itimerspec data to fill
  *
- * Copies the itimerspec data out from the k_itimer
+ * Copies out the current itimerspec data
  */
 static void alarm_timer_get(struct k_itimer *timr,
 				struct itimerspec *cur_setting)
 {
-	memset(cur_setting, 0, sizeof(struct itimerspec));
+	ktime_t relative_expiry_time =
+		alarm_expires_remaining(&(timr->it.alarm.alarmtimer));
+
+	if (ktime_to_ns(relative_expiry_time) > 0) {
+		cur_setting->it_value = ktime_to_timespec(relative_expiry_time);
+	} else {
+		cur_setting->it_value.tv_sec = 0;
+		cur_setting->it_value.tv_nsec = 0;
+	}
 
-	cur_setting->it_interval =
-			ktime_to_timespec(timr->it.alarm.interval);
-	cur_setting->it_value =
-		ktime_to_timespec(timr->it.alarm.alarmtimer.node.expires);
-	return;
+	cur_setting->it_interval = ktime_to_timespec(timr->it.alarm.interval);
 }
 
 /**
diff --git a/kernel/time/time.c b/kernel/time/time.c
index f0294ba14634..a9ae20fb0b11 100644
--- a/kernel/time/time.c
+++ b/kernel/time/time.c
@@ -559,17 +559,20 @@ EXPORT_SYMBOL(usecs_to_jiffies);
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
@@ -580,6 +583,13 @@ timespec_to_jiffies(const struct timespec *value)
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
@@ -596,31 +606,27 @@ jiffies_to_timespec(const unsigned long jiffies, struct timespec *value)
 }
 EXPORT_SYMBOL(jiffies_to_timespec);
 
-/* Same for "timeval"
- *
- * Well, almost.  The problem here is that the real system resolution is
- * in nanoseconds and the value being converted is in micro seconds.
- * Also for some machines (those that use HZ = 1024, in-particular),
- * there is a LARGE error in the tick size in microseconds.
-
- * The solution we use is to do the rounding AFTER we convert the
- * microsecond part.  Thus the USEC_ROUND, the bits to be shifted off.
- * Instruction wise, this should cost only an additional add with carry
- * instruction above the way it was done above.
+/*
+ * We could use a similar algorithm to timespec_to_jiffies (with a
+ * different multiplier for usec instead of nsec). But this has a
+ * problem with rounding: we can't exactly add TICK_NSEC - 1 to the
+ * usec value, since it's not necessarily integral.
+ *
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
 
