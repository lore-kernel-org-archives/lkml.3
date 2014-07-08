Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753442AbaGHHee (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 03:34:34 -0400
Received: from mail-vc0-f177.google.com ([209.85.220.177]:55512 "EHLO
	mail-vc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752175AbaGHHec (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 03:34:32 -0400
MIME-Version: 1.0
In-Reply-To: <20140708064204.GD3977@localhost.localdomain>
References: <1404767171-6902-1-git-send-email-john.stultz@linaro.org>
	<20140708064204.GD3977@localhost.localdomain>
Date: Tue, 8 Jul 2014 09:34:32 +0200
Message-ID: <CALAqxLUixKYE1z8GcZzkfrSNqZwtJNBqyYuxo78t+UtswmC68Q@mail.gmail.com>
Subject: Re: [PATCH] alarmtimer: Fix bug where relative alarm timers were
 treated as absolute
From: John Stultz <john.stultz@linaro.org>
To: Richard Cochran <richardcochran@gmail.com>
Cc: lkml <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>, Prarit Bhargava <prarit@redhat.com>,
        Sharvil Nanavati <sharvil@google.com>, stable <stable@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 8, 2014 at 8:42 AM, Richard Cochran
<richardcochran@gmail.com> wrote:
> On Mon, Jul 07, 2014 at 02:06:11PM -0700, John Stultz wrote:
>> @@ -597,8 +602,16 @@ static int alarm_timer_set(struct k_itimer *timr, int flags,
>>
>>       /* start the timer */
>>       timr->it.alarm.interval = timespec_to_ktime(new_setting->it_interval);
>> -     alarm_start(&timr->it.alarm.alarmtimer,
>> -                     timespec_to_ktime(new_setting->it_value));
>> +     exp = timespec_to_ktime(new_setting->it_value);
>> +     /* Convert (if necessary) to absolute time */
>> +     if (flags != TIMER_ABSTIME) {
>> +             ktime_t now;
>> +
>> +             now = alarm_bases[timr->it.alarm.alarmtimer.type].gettime();
>> +             exp = ktime_add(now, exp);
>> +     }
>> +
>> +     alarm_start(&timr->it.alarm.alarmtimer, exp);
>
> Nothing protects 'exp' from becoming invalid before queuing the alarm,
> if the time base is reset on another cpu. Or would that be harmless
> here?

Hrmn.. So that's a separate question, but a good one to validate as well.

common_timer_set() has a similar behavior where the return value of
hrtimer_start_expires() isn't passed up. This is because the userspace
behavior is that if the time has already passed, the timer should fire
immediately.

If you look in __hrtimer_start_range_ns(), you'll see the chunk of
logic at the bottom which (if I'm reading it right) raises the softirq
(to fire the timer) if our timer is the earliest and
enqueue_reprogram fails (due to the clockevent logic returning ETIME
due to the time being in the past).

So its definitely subtle but looks like its ok. But I'll add a
validation test to be sure I'm not missing anything there as well.

thanks
-john
