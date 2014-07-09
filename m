Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964776AbaGIPZL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 11:25:11 -0400
Received: from mail-ob0-f173.google.com ([209.85.214.173]:48541 "EHLO
	mail-ob0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932591AbaGIPZE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 11:25:04 -0400
MIME-Version: 1.0
In-Reply-To: <53BD1AA3.4000203@arm.com>
References: <cover.1404888801.git.viresh.kumar@linaro.org>
	<13861232628603285a2734e32b309abd73c8741c.1404888801.git.viresh.kumar@linaro.org>
	<53BD1AA3.4000203@arm.com>
Date: Wed, 9 Jul 2014 20:55:02 +0530
Message-ID: <CAKohpokjYVUo1+wSdyuwGRnDGAq6XeS-EPRjv4gg96TWM3+bdg@mail.gmail.com>
Subject: Re: [RFC 2/7] hrtimer: don't check for active hrtimer after adding it
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Chris Redpath <Chris.Redpath@arm.com>
Cc: "tglx@linutronix.de" <tglx@linutronix.de>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "fweisbec@gmail.com" <fweisbec@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "preeti@linux.vnet.ibm.com" <preeti@linux.vnet.ibm.com>,
        Arvind Chauhan <Arvind.Chauhan@arm.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9 July 2014 16:04, Chris Redpath <Chris.Redpath@arm.com> wrote:
> On 09/07/14 07:55, Viresh Kumar wrote:
>> diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
>> index cf40209..a76f962 100644
>> --- a/kernel/hrtimer.c
>> +++ b/kernel/hrtimer.c
>> @@ -1555,8 +1555,6 @@ static int __sched do_nanosleep(struct
>> hrtimer_sleeper *t, enum hrtimer_mode mod
>>         do {
>>                 set_current_state(TASK_INTERRUPTIBLE);
>>                 hrtimer_start_expires(&t->timer, mode);
>> -               if (!hrtimer_active(&t->timer))
>> -                       t->task = NULL;
>>
>>                 if (likely(t->task))
>>                         freezable_schedule();
>> @@ -1837,8 +1835,6 @@ schedule_hrtimeout_range_clock(ktime_t *expires,
>> unsigned long delta,
>>         hrtimer_init_sleeper(&t, current);
>>
>>         hrtimer_start_expires(&t.timer, mode);
>> -       if (!hrtimer_active(&t.timer))
>> -               t.task = NULL;
>>
>>         if (likely(t.task))
>>                 schedule();
>>
>
> Maybe safe to remove this if condition too.


Included following diff to this patch:

diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index a76f962..ae7b5cf 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -1556,8 +1556,7 @@ static int __sched do_nanosleep(struct
hrtimer_sleeper *t, enum hrtimer_mode mod
                set_current_state(TASK_INTERRUPTIBLE);
                hrtimer_start_expires(&t->timer, mode);

-               if (likely(t->task))
-                       freezable_schedule();
+               freezable_schedule();

                hrtimer_cancel(&t->timer);
                mode = HRTIMER_MODE_ABS;
@@ -1836,8 +1835,7 @@ schedule_hrtimeout_range_clock(ktime_t *expires,
unsigned long delta,

        hrtimer_start_expires(&t.timer, mode);

-       if (likely(t.task))
-               schedule();
+       schedule();

        hrtimer_cancel(&t.timer);
        destroy_hrtimer_on_stack(&t.timer);



Latest changes are pushed to my branch in case someone is looking to
test them.
