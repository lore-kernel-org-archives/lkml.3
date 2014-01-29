Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752368AbaA2F2E (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jan 2014 00:28:04 -0500
Received: from mail-oa0-f49.google.com ([209.85.219.49]:35966 "EHLO
	mail-oa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751126AbaA2F2A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jan 2014 00:28:00 -0500
MIME-Version: 1.0
In-Reply-To: <CAKohpomMZ0TAN2e6N76_g4ZRzxd5vZ1XfuZfxrP7GMxfTNiLVw@mail.gmail.com>
References: <CALZhoSQZQcM0yKTw1=ZkYz3Z_3X2QxLk0vCw6gKXW55HSrVEdw@mail.gmail.com>
	<alpine.DEB.2.02.1401221459590.4260@ionos.tec.linutronix.de>
	<CALZhoSSSOZKwDok2ZHumeZAs0R88SC6bU2BaL54U3TU6jgoaZA@mail.gmail.com>
	<CAKohpomMZ0TAN2e6N76_g4ZRzxd5vZ1XfuZfxrP7GMxfTNiLVw@mail.gmail.com>
Date: Wed, 29 Jan 2014 10:57:59 +0530
Message-ID: <CAM4v1pPnHuSKX9UAjnqzappThKS0a6_6-PEqpiiCPpjQ_3anQQ@mail.gmail.com>
Subject: Re: Is it ok for deferrable timer wakeup the idle cpu?
From: Preeti Murthy <preeti.lkml@gmail.com>
To: Viresh Kumar <viresh.kumar@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>, fweisbec@gmail.com
Cc: Lei Wen <adrian.wenl@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, Jan 23, 2014 at 11:22 AM, Viresh Kumar <viresh.kumar@linaro.org> wrote:

> Hi Guys,
>
> So the first question is why cpufreq needs it and is it really stupid?
> Yes, it is stupid but that's how its implemented since a long time. It does
> so to get data about the load on CPUs, so that freq can be scaled up/down.
>
> Though there is a solution in discussion currently, which will take
> inputs from scheduler and so these background timers would go away.
> But we need to wait until that time.
>
> Now, why do we need that for every cpu, while that for a single cpu might
> be enough? The answer is cpuidle here: What if the cpu responsible for
> running timer goes to sleep? Who will evaluate the load then? And if we
> make this timer run on one cpu in non-deferrable mode then that cpu
> would be waken up again and again from idle. So, it was decided to have
> a per-cpu deferrable timer. Though to improve efficiency, once it is fired
> on any cpu, timer for all other CPUs are rescheduled, so that they don't
> fire before 5ms (sampling time)..

How about simplifying this design by doing the below?

1. Since anyway cpufreq governors monitor load on the cpu once every
5ms, *tie it with tick_sched_timer*, which also gets deferred when the cpu
enters nohz_idle.

2. To overcome the problem of running this job of monitoring the load
on every cpu, have the *time keeping* cpu do it for you.

The time keeping cpu has the property that if it has to go to idle, it will do
so and let the next cpu that runs the periodic timer become the time keeper.
Hence no cpu is prevented from entering nohz_idle and the cpu that is busy
and first executes periodic timer will take over as the time keeper.

The result would be:

1. One cpu at any point in time will be monitoring cpu load, at every sched tick
as long as its busy. If it goes to sleep, then it gives up this duty
and enters idle.
The next cpu that runs the periodic timer becomes the cpu to monitor the load
and will continue to do so as long as its busy. Hence we do not miss monitoring
the cpu load.

2. This will avoid an additional timer for cpufreq.

3. It avoids sending IPIs each time this timer gets modified since there is just
one CPU doing the monitoring.

4. The downside to this could be that we are stretching the functions of the
 periodic timer into the power management domain which does not seem like
the right thing to do.

Having said the above, the fix that Viresh has proposed along with the nohz_full
condition that Frederick added looks to solve this problem.

But just a thought on if there is scope to improve this part of the
cpufreq code.
What do you all think?

Thanks

Regards
Preeti U Murthy
>
> I think below diff might get this fixed for you, though I am not sure if it
> breaks something else. Probably Thomas/Frederic can answer here.
> If this looks fine I will send it formally again:
>
> diff --git a/kernel/timer.c b/kernel/timer.c
> index accfd24..3a2c7fa 100644
> --- a/kernel/timer.c
> +++ b/kernel/timer.c
> @@ -940,7 +940,8 @@ void add_timer_on(struct timer_list *timer, int cpu)
>          * makes sure that a CPU on the way to stop its tick can not
>          * evaluate the timer wheel.
>          */
> -       wake_up_nohz_cpu(cpu);
> +       if (!tbase_get_deferrable(timer->base))
> +               wake_up_nohz_cpu(cpu);
>         spin_unlock_irqrestore(&base->lock, flags);
>  }
>  EXPORT_SYMBOL_GPL(add_timer_on);
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
