Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756133AbbAWSAU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 13:00:20 -0500
Received: from mail-yk0-f172.google.com ([209.85.160.172]:63282 "EHLO
	mail-yk0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754530AbbAWSAS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 13:00:18 -0500
MIME-Version: 1.0
In-Reply-To: <CALAqxLVGquBDT-rgLhPi068Y3BYXLUNJu-okPb4sh4+vTfqFBw@mail.gmail.com>
References: <1421928077-4698-1-git-send-email-pang.xunlei@linaro.org>
	<CALAqxLVGquBDT-rgLhPi068Y3BYXLUNJu-okPb4sh4+vTfqFBw@mail.gmail.com>
Date: Sat, 24 Jan 2015 02:00:17 +0800
Message-ID: <CADcy93XFB0q3NayE2cxgHwGC4bLaHehyEe8TE_t4curssF8jMw@mail.gmail.com>
Subject: Re: [PATCH v2 1/3] time: Don't bother to run rtc_resume() for the
 nonstop clocksource
From: Xunlei Pang <pang.xunlei@linaro.org>
To: John Stultz <john.stultz@linaro.org>
Cc: lkml <linux-kernel@vger.kernel.org>,
        "rtc-linux@googlegroups.com" <rtc-linux@googlegroups.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Arnd Bergmann <arnd.bergmann@linaro.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23 January 2015 at 02:30, John Stultz <john.stultz@linaro.org> wrote:
> On Thu, Jan 22, 2015 at 4:01 AM, Xunlei Pang <pang.xunlei@linaro.org> wrote:
>> If a system does not provide a persistent_clock(), the time
>> will be updated on resume by rtc_resume(). With the addition
>> of the non-stop clocksources for suspend timing, those systems
>> set the time on resume in timekeeping_resume(), but may not
>> provide a valid persistent_clock().
>>
>> This results in the rtc_resume() logic thinking no one has set
>> the time and it then will over-write the suspend time again,
>> which is not necessary and only increases clock error.
>>
>> So, fix this for rtc_resume().
>>
>> Signed-off-by: Xunlei Pang <pang.xunlei@linaro.org>
>> ---
>> v1->v2:
>> Modify according to Thomas' feedback.
>>
>>  drivers/rtc/class.c         |  2 +-
>>  include/linux/timekeeping.h |  7 +++++++
>>  kernel/time/timekeeping.c   | 16 +++++-----------
>>  3 files changed, 13 insertions(+), 12 deletions(-)
>>
>> diff --git a/drivers/rtc/class.c b/drivers/rtc/class.c
>> index 472a5ad..6100af5 100644
>> --- a/drivers/rtc/class.c
>> +++ b/drivers/rtc/class.c
>> @@ -102,7 +102,7 @@ static int rtc_resume(struct device *dev)
>>         struct timespec64       sleep_time;
>>         int err;
>>
>> -       if (has_persistent_clock())
>> +       if (timekeeping_sleeptime_injected())
>>                 return 0;
>>
>>         rtc_hctosys_ret = -ENODEV;
>> diff --git a/include/linux/timekeeping.h b/include/linux/timekeeping.h
>> index 9b63d13..2b87c64 100644
>> --- a/include/linux/timekeeping.h
>> +++ b/include/linux/timekeeping.h
>> @@ -238,6 +238,13 @@ extern void getnstime_raw_and_real(struct timespec *ts_raw,
>>   */
>>  extern bool persistent_clock_exist;
>>  extern int persistent_clock_is_local;
>> +extern bool timekeeping_sleeptime_inject;
>> +
>> +/* Used by rtc_resume() */
>> +static inline bool timekeeping_sleeptime_injected(void)
>> +{
>> +       return timekeeping_sleeptime_inject;
>> +}
>>
>
> Again, there's no reason to make this a static inline, nor the
> sleeptime_inject variable global.
> Just make it a function in timekeeping and provide definition so it
> can be used by the rtc resume.


Hi John,

Thanks for your comments, I've refined it, is this one ok?

---
 drivers/rtc/class.c         |  2 +-
 include/linux/timekeeping.h |  1 +
 kernel/time/timekeeping.c   | 32 ++++++++++++++++++++------------
 3 files changed, 22 insertions(+), 13 deletions(-)

diff --git a/drivers/rtc/class.c b/drivers/rtc/class.c
index 472a5ad..6100af5 100644
--- a/drivers/rtc/class.c
+++ b/drivers/rtc/class.c
@@ -102,7 +102,7 @@ static int rtc_resume(struct device *dev)
  struct timespec64 sleep_time;
  int err;

- if (has_persistent_clock())
+ if (timekeeping_sleeptime_injected())
  return 0;

  rtc_hctosys_ret = -ENODEV;
diff --git a/include/linux/timekeeping.h b/include/linux/timekeeping.h
index 9b63d13..17a460d 100644
--- a/include/linux/timekeeping.h
+++ b/include/linux/timekeeping.h
@@ -225,6 +225,7 @@ static inline void timekeeping_clocktai(struct timespec *ts)
 /*
  * RTC specific
  */
+extern bool timekeeping_sleeptime_injected(void);
 extern void timekeeping_inject_sleeptime64(struct timespec64 *delta);

 /*
diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index 6a93185..b02133e 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -1125,12 +1125,26 @@ static void
__timekeeping_inject_sleeptime(struct timekeeper *tk,
  tk_debug_account_sleep_time(delta);
 }

+static bool sleeptime_inject;
+
+#if defined(CONFIG_RTC_CLASS) && \
+ defined(CONFIG_PM_SLEEP) && \
+ defined(CONFIG_RTC_HCTOSYS_DEVICE)
+/**
+ * Used by rtc_resume().
+ */
+bool timekeeping_sleeptime_injected(void)
+{
+ return sleeptime_inject;
+}
+
 /**
  * timekeeping_inject_sleeptime64 - Adds suspend interval to
timeekeeping values
  * @delta: pointer to a timespec64 delta value
  *
  * This hook is for architectures that cannot support read_persistent_clock
- * because their RTC/persistent clock is only accessible when irqs are enabled.
+ * because their RTC/persistent clock is only accessible when irqs are enabled,
+ * and also don't have an effective nonstop clocksource.
  *
  * This function should only be called by rtc_resume(), and allows
  * a suspend offset to be injected into the timekeeping values.
@@ -1140,13 +1154,6 @@ void timekeeping_inject_sleeptime64(struct
timespec64 *delta)
  struct timekeeper *tk = &tk_core.timekeeper;
  unsigned long flags;

- /*
- * Make sure we don't set the clock twice, as timekeeping_resume()
- * already did it
- */
- if (has_persistent_clock())
- return;
-
  raw_spin_lock_irqsave(&timekeeper_lock, flags);
  write_seqcount_begin(&tk_core.seq);

@@ -1162,6 +1169,7 @@ void timekeeping_inject_sleeptime64(struct
timespec64 *delta)
  /* signal hrtimers about time change */
  clock_was_set();
 }
+#endif

 /**
  * timekeeping_resume - Resumes the generic timekeeping subsystem.
@@ -1178,8 +1186,8 @@ static void timekeeping_resume(void)
  struct timespec64 ts_new, ts_delta;
  struct timespec tmp;
  cycle_t cycle_now, cycle_delta;
- bool suspendtime_found = false;

+ sleeptime_inject = false;
  read_persistent_clock(&tmp);
  ts_new = timespec_to_timespec64(tmp);

@@ -1226,13 +1234,13 @@ static void timekeeping_resume(void)
  nsec += ((u64) cycle_delta * mult) >> shift;

  ts_delta = ns_to_timespec64(nsec);
- suspendtime_found = true;
+ sleeptime_inject = true;
  } else if (timespec64_compare(&ts_new, &timekeeping_suspend_time) > 0) {
  ts_delta = timespec64_sub(ts_new, timekeeping_suspend_time);
- suspendtime_found = true;
+ sleeptime_inject = true;
  }

- if (suspendtime_found)
+ if (sleeptime_inject)
  __timekeeping_inject_sleeptime(tk, &ts_delta);

  /* Re-base the last cycle value */
-- 
1.9.1
