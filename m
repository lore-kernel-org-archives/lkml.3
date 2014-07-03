Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932486AbaGCN3d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 09:29:33 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:39216 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751382AbaGCN3c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 09:29:32 -0400
MIME-Version: 1.0
Date: Thu, 3 Jul 2014 18:59:31 +0530
Message-ID: <CAKohpomvG-jEhMow=g5-nOAW7aBGBAfMjwRocOMU3rMfK9VTgA@mail.gmail.com>
Subject: [Query/tick] Are we enqueing 'tick-sched' hrtimers in past ?
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Thomas Gleixner <tglx@linutronix.de>, Steven Rostedt <rostedt@goodmis.org>,
        =?UTF-8?B?RnLDqWTDqXJpYyBXZWlzYmVja2Vy?= <fweisbec@gmail.com>
Cc: Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        Linaro Networking <linaro-networking@linaro.org>,
        Kevin Hilman <khilman@linaro.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thomas et al,

I was analyzing few traces with 'trace-cmd' and realized that timings
weren't matching properly. For example consider this trace:

1            cat-1867  [000] d.h1   149.750891: hrtimer_expire_entry:
hrtimer=ee7b3740 function=tick_sched_timer now=149740008694
2            cat-1867  [000] d.h1   149.750900: softirq_raise: vec=1
[action=TIMER]
3            cat-1867  [000] d.h1   149.750905: softirq_raise: vec=9
[action=RCU]
4            cat-1867  [000] d.h2   149.750910: sched_stat_runtime:
comm=cat pid=1867 runtime=1463250 [ns] vruntime=4777557704 [ns]
5            cat-1867  [000] d.h1   149.750914: softirq_raise: vec=7
[action=SCHED]
6            cat-1867  [000] d.h1   149.750919: hrtimer_expire_exit:
hrtimer=ee7b3740
7            cat-1867  [000] d.h2   149.750922: hrtimer_start:
hrtimer=ee7b3740 function=tick_sched_timer expires=149745000000
softexpires=149745000000

Line 1: now=149.740008694 and trace-time: 149.750891. diff 10ms (consistently)
Line 7: trace-time: 149.750922 and expires: 149.745000000, diff 5ms


So, either there is a mismatch of trace-times and required to be
fixed? (@Steven)

Or we are almost always adding the tick-sched hrtimer in past?


I wasn't sure and tried to go through tick-sched and hrtimer core
code again and this is what I realized.

At certain points we are trying to make sure that 'jiffies' are updated
for current-time with loops like:

Lowres mode:

                while (tick_nohz_reprogram(ts, now)) {
                       now = ktime_get();
                       tick_do_update_jiffies64(now);
                }

tick_nohz_reprogram() does check if expires is in past and returns
-ETIME (right?). And so we are guaranteed to updated jiffies to
current time and reprogram clkevt device in future.

Highres mode:
- First of all this kind of loop is missing from tick-handler:
tick_sched_timer() as we are relying on hrtimer core to restart hrtimer
for us and so we aren't trying to updated jiffies to latest values. And
so we might (maybe always as shown in my traces) enqueue hrtimer
in past.

- At some places we do have a while loop:

static void tick_nohz_restart(struct tick_sched *ts, ktime_t now)
{
        ...

        while (1) {
                /* Forward the time to expire in the future */
                hrtimer_forward(&ts->sched_timer, now, tick_period);

                if (ts->nohz_mode == NOHZ_MODE_HIGHRES) {
                        hrtimer_start_expires(&ts->sched_timer,
                                              HRTIMER_MODE_ABS_PINNED);
                        /* Check, if the timer was already in the past */
                        if (hrtimer_active(&ts->sched_timer))
                                break;
                } else {
                        ...
                }
                ...
       }
}


But I couldn't make out that this while loop will actually run for
hres mode. Unlike tick_nohz_reprogram(), hrtimer_start_expires()
never fails and calls enqueue_hrtimer() which does this:
        timer->state |= HRTIMER_STATE_ENQUEUED;

And so hrtimer_active() is guaranteed to return 'true' ? From the
comment over hrtimer_active() here it looks we are trying to make
sure that we aren't adding hrtimer in past, but code doesn't look
like that.

And so there is a possibility that hrtimers are getting added in past.

I tried to go to the initial commit: 79bf2bb (tick-management:
dyntick / highres functionality) and see if things were different there.

But they weren't.

Sorry for the long mail :)

--
viresh
