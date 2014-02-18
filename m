Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752784AbaBRTsj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 14:48:39 -0500
Received: from mailout3.w1.samsung.com ([210.118.77.13]:59515 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752199AbaBRTsg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 14:48:36 -0500
X-AuditID: cbfec7f4-b7f796d000005a13-14-5303b911a0b4
Message-id: <5303B910.5090009@samsung.com>
Date: Tue, 18 Feb 2014 23:48:32 +0400
From: Alexey Perevalov <a.perevalov@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623
 Thunderbird/17.0.7
MIME-version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
Cc: John Stultz <john.stultz@linaro.org>, linux-kernel@vger.kernel.org,
        anton@enomsg.org, kyungmin.park@samsung.com, akpm@linux-foundation.org,
        cw00.choi@samsung.com
Subject: Re: [PATCH v2 0/3] Deferrable timers support for timerfd API
References: <1389609835-24377-1-git-send-email-a.perevalov@samsung.com>
 <52DEC6A3.9020600@linaro.org> <52E606D8.6000401@samsung.com>
 <alpine.DEB.2.02.1402041419420.24986@ionos.tec.linutronix.de>
 <52F1DDA8.90605@samsung.com>
 <alpine.DEB.2.02.1402051229260.24986@ionos.tec.linutronix.de>
 <52F2B504.5010403@linaro.org>
 <alpine.DEB.2.02.1402052306580.24986@ionos.tec.linutronix.de>
 <52F3C8A5.708@samsung.com>
 <alpine.DEB.2.02.1402062148440.21991@ionos.tec.linutronix.de>
 <5300D752.5030403@samsung.com>
 <alpine.DEB.2.02.1402161634590.21991@ionos.tec.linutronix.de>
In-reply-to: <alpine.DEB.2.02.1402161634590.21991@ionos.tec.linutronix.de>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrALMWRmVeSWpSXmKPExsVy+t/xq7qCO5mDDS7vVbeYs34Nm8XBrZoW
	1788Z7U481vX4mzTG3aLy7vmsFls3jSV2YHdY0L/J0aPO9f2sHm8O3eO3ePEjN8sHn1bVjF6
	fN4kF8AWxWWTkpqTWZZapG+XwJVx6csiloIlUhXvvzxmbmB8KdLFyMEhIWAisX6lTRcjJ5Ap
	JnHh3nq2LkYuDiGBpYwS9x43M0E4nxklzn55yQJSxSugJdHe/o4JxGYRUJW48+EFK8ggNgED
	iX33bEFMUYEIiaPLNSGqBSV+TL4H1ikioCGx8dItZpCRzAIrGSXmfvvDDpIQFnCVOLF9PSvE
	rsMsEhumPwXr4BTwkvj47CIbiM0sYC2xctI2RghbXmLzmrfMExgFZiFZMgtJ2SwkZQsYmVcx
	iqaWJhcUJ6XnGuoVJ+YWl+al6yXn525ihIT6lx2Mi49ZHWIU4GBU4uH9oMwULMSaWFZcmXuI
	UYKDWUmEV3EVc7AQb0piZVVqUX58UWlOavEhRiYOTqkGxqrK7xNSZNiKDJ/p5sRYSXk1br64
	d3eQ28HnoXmmdoYMka5x6XtqHBSuyKf0nV9Vd3CHoWdtSW3u5niXH24NJcw756Xx8TEvS0h/
	wKqhff/Qnfef2i/4BsWwLV+kP8uaY5p+n7jBW9XTF7538oSenMSdOuvQX6ZXr66uUv2UGDlx
	05cpB6KXKbEUZyQaajEXFScCABY3rfFTAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/16/2014 07:39 PM, Thomas Gleixner wrote:
> On Sun, 16 Feb 2014, Alexey Perevalov wrote:
>> As I understand main idea in hrtimer.c was do not decrement expires_next in
>> case of DEFERRABLE timers type.
>> Such small average delay could be explained: it's due higher resolution, and
>> cpu is not in idle when we in hrtimer_interrupt,
>> with timer_list decrementing process not so often.
>> In this case it's hard to me to explain such small "time delta", it occurs
>> almost every time we have larger delay.
> Well, the point of deferrable timers is that they get executed, when
> the cpu is not idle, i.e. running some other timers as well
>
> I did not test my patch and I have no idea whether it really does what
> it should do, but tracing should tell you rather fast.
>
> So w/o instrumenting the kernel you can't tell why a timer is
> expired. Just looking at random numbers does not help. You need to
> create a proper test scenario which makes sure that the system goes
> into an extended nohz idle and then check whether the timers are
> deferred over that idle time.
>
> Thanks,
>
> 	tglx
>
>


Dear Thomas,

I figured out with deviation, I described before.

It was due expires and especially softexpires is fixed (don't base on 
delay).

For example if we have a timer like this:
hrtimer_expire_entry: hrtimer=ffffffffa056f280 function=timerfd_tmrproc 
[hrtimers_mod] now=191450988244 expires=191400000000 
softexpires=191400000000
It was fired at 191450988244, but softexpire is  191400000000, 50ms 
delay, if I'm not wrong.
Next trigger time is 191700000000, (hrtimer_start: 
hrtimer=ffffffffa056f280 function=timerfd_tmrproc [hrtimers_mod] 
expires=191700000000 softexpires=191700000000)
and if there is no cpu idle at next time, we'll get 250ms interval for 
such timer. But we want 300ms or more for DEFERRABLE timer.

Thomas what do you think about moving format expire/softexpire to 
_!now!_ in run_hrtimer, right before we
invoke callback function? The prolongation of hrtimer usually comes from 
user timer functions by
invoking hrtimer_forward, which moves expires/softexpires forward.


+static void __run_hrtimer(struct hrtimer *timer, ktime_t *now, int 
deferrable)
  {
         struct hrtimer_clock_base *base = timer->base;
         struct hrtimer_cpu_base *cpu_base = base->cpu_base;
@@ -1286,8 +1286,13 @@ static void __run_hrtimer(struct hrtimer *timer, 
ktime_t *now)
          * the timer base.
          */
         raw_spin_unlock(&cpu_base->lock);
-       trace_hrtimer_expire_entry(timer, now);
+       trace_hrtimer_expire_entry(timer, now, 0);
+
+       if (deferrable)
+               hrtimer_set_expires(timer, *now);
         restart = fn(timer);


I got expected results (timer interval is 300ms):
[  247.251609] time delta 315563612
[  247.652398] time delta 400788785
[  248.000169] time delta 347764697
[  248.372070] time delta 371900444
[  248.800175] time delta 428105238
[  249.144178] time delta 344002733
[  249.455920] time delta 311748775
[  249.804166] time delta 348245676
[  250.136165] time delta 331999061
[  250.458606] time delta 322441758
[  250.804184] time delta 345571829

Also I tried move just _softexpire, but timer function in this case 
wasn't called at all.


-- 
Best regards,
Alexey Perevalov
