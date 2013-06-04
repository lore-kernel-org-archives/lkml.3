Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754859Ab3FDNlm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 09:41:42 -0400
Received: from h1446028.stratoserver.net ([85.214.92.142]:38916 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752154Ab3FDNlk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 09:41:40 -0400
Message-ID: <51ADEE76.7090504@ahsoftware.de>
Date: Tue, 04 Jun 2013 15:41:10 +0200
From: Alexander Holler <holler@ahsoftware.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130421 Thunderbird/17.0.5
MIME-Version: 1.0
To: John Stultz <john.stultz@linaro.org>
CC: linux-kernel@vger.kernel.org, rtc-linux@googlegroups.com,
        Andrew Morton <akpm@linux-foundation.org>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Jonathan Cameron <jic23@cam.ac.uk>, Jiri Kosina <jkosina@suse.cz>
Subject: Re: [PATCH 3/4] rtc: rtc-hid-sensor-time: add option hctosys to set
 time at boot
References: <51765FB9.2050009@ahsoftware.de> <1367752887-2927-1-git-send-email-holler@ahsoftware.de> <1367752887-2927-4-git-send-email-holler@ahsoftware.de> <519BEF13.2040500@linaro.org> <519C0004.9000706@ahsoftware.de> <51A50774.6060400@linaro.org> <51A58726.9090206@ahsoftware.de>
In-Reply-To: <51A58726.9090206@ahsoftware.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 29.05.2013 06:42, schrieb Alexander Holler:
> Am 28.05.2013 21:37, schrieb John Stultz:
>> On 05/21/2013 04:15 PM, Alexander Holler wrote:

>>> Implementation could be as easy as a bool "time_set_at_least_once" in
>>> the timer subsystem itself (e.g. in do_settimeofday() and whatever
>>> similiar is available).
>>
>> If it were to be done this way, it would be good to have the RTC layer
>> check when RTC devices are registered and call the internal hctosys
>> functionality then (rather then just at late_init). Do you want to try
>> to rework the patch in this way?
> 
> That sounds like what Andrew Morton wanted to trick me to do. ;)

Just in case that was misunderstood. Of course, I would rework the patch
if we reach a consensus about how I can do that. I would also volunteer
and would remove hctosys and replace it by a better approach (imho)
which sets the system time when a rtc registers. That doesn't look like
much work.

I've just did a small test and I think the mentioned flag could be
implemented by the patch below (pasted => wrong format).

I don't think stuff like atomic_*, a spinlock, mutex or similiar is
necessary to make sure that the system time will only be set by one rtc,
because I think it is extremly unlikely that more than one rtc will
register at the same time to make such necessary. That means I think
it's ok to just use "if (!systime_was_set) do_settimeofday()" in the rtc
subsystem afterwards.

I would also implement a kernel parameter like systime_from which could
not be set (== use the first clock which offers a valid time) or could
be set to "persistent" or the name of a RTC module in which case either
the persistent clock or the named RTC would be used to set the time, if
and only if the system time wasn't be set by something else (most likely
userspace).

Regards,

Alexander Holler


diff --git a/include/linux/time.h b/include/linux/time.h
index afcdc4b..9c488f3 100644
--- a/include/linux/time.h
+++ b/include/linux/time.h
@@ -129,6 +129,12 @@ extern int update_persistent_clock(struct timespec
now);
 void timekeeping_init(void);
 extern int timekeeping_suspended;

+/*
+ * Will be true if the system time was set at least once by
+ * a persistent clock, RTC or userspace.
+ */
+extern bool systime_was_set;
+
 unsigned long get_seconds(void);
 struct timespec current_kernel_time(void);
 struct timespec __current_kernel_time(void); /* does not take xtime_lock */
diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index 9a0bc98..442e03c 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -32,6 +32,9 @@ int __read_mostly timekeeping_suspended;
 /* Flag for if there is a persistent clock on this platform */
 bool __read_mostly persistent_clock_exist = false;

+/* Flag for if the system time was set at least once */
+bool __read_mostly systime_was_set = false;
+
 static inline void tk_normalize_xtime(struct timekeeper *tk)
 {
        while (tk->xtime_nsec >= ((u64)NSEC_PER_SEC << tk->shift)) {
@@ -448,6 +451,10 @@ int do_settimeofday(const struct timespec *tv)
        if (!timespec_valid_strict(tv))
                return -EINVAL;

+       systime_was_set = true;
+
        write_seqlock_irqsave(&tk->lock, flags);

        timekeeping_forward_now(tk);
@@ -682,8 +689,11 @@ void __init timekeeping_init(void)
                        "         Check your CMOS/BIOS settings.\n");
                now.tv_sec = 0;
                now.tv_nsec = 0;
-       } else if (now.tv_sec || now.tv_nsec)
+       } else if (now.tv_sec || now.tv_nsec) {
                persistent_clock_exist = true;
+               systime_was_set = true;
+       }

        read_boot_clock(&boot);
        if (!timespec_valid_strict(&boot)) {
