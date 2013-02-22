Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756628Ab3BVK0k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2013 05:26:40 -0500
Received: from mail-vb0-f45.google.com ([209.85.212.45]:48230 "EHLO
	mail-vb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754101Ab3BVK0i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2013 05:26:38 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.02.1302211436300.22263@ionos>
References: <CAB4PhKevqf0e4nzYraE9ZTAFbPCFfNpguAnPoVpJh-FFe2TAZA@mail.gmail.com>
	<alpine.LFD.2.02.1302201400400.22263@ionos>
	<CAB4PhKfxPcyQfpM2Ra1OxsyYhS5fnkjtPy=uYgxFHim1rOdoug@mail.gmail.com>
	<alpine.LFD.2.02.1302211015270.22263@ionos>
	<CAB4PhKf+Z-TK4KGDZm1kYOWibg=e2Ehnhjxt_oTbFq9eqouAjA@mail.gmail.com>
	<alpine.LFD.2.02.1302211436300.22263@ionos>
Date: Fri, 22 Feb 2013 18:26:36 +0800
Message-ID: <CAB4PhKdaR8hUSHAu4r2C90F9AC6a52VAqCHj6J1xHzA8RFpj2Q@mail.gmail.com>
Subject: Re: too many timer retries happen when do local timer swtich with
 broadcast timer
From: Jason Liu <liu.h.jason@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas,

2013/2/21 Thomas Gleixner <tglx@linutronix.de>:
> Jason,
>
> On Thu, 21 Feb 2013, Jason Liu wrote:
>> 2013/2/21 Thomas Gleixner <tglx@linutronix.de>:
>> > Now your explanation makes sense.
>> >
>> > I have no fast solution for this, but I think that I have an idea how
>> > to fix it. Stay tuned.
>>
>> Thanks Thomas, wait for your fix. :)
>
> find below a completely untested patch, which should address that issue.
>

I have tested the below patch, but run into the following warnings:

[  713.340593] ------------[ cut here ]------------
[  713.345238] WARNING: at
/linux-2.6-imx/kernel/time/tick-broadcast.c:497
tick_broadcast_oneshot_control+0x210/0x254()
[  713.359240] Modules linked in:
[  713.362332] [<8004b2cc>] (unwind_backtrace+0x0/0xf8) from
[<80079764>] (warn_slowpath_common+0x54/0x64)
[  713.371740] [<80079764>] (warn_slowpath_common+0x54/0x64) from
[<80079790>] (warn_slowpath_null+0x1c/0x24)
[  713.381408] [<80079790>] (warn_slowpath_null+0x1c/0x24) from
[<800a5320>] (tick_broadcast_oneshot_control+0x210/0x254)
[  713.392120] [<800a5320>]
(tick_broadcast_oneshot_control+0x210/0x254) from [<800a48b0>]
(tick_notify+0xd4/0x1f8)
[  713.402317] [<800a48b0>] (tick_notify+0xd4/0x1f8) from [<8009b154>]
(notifier_call_chain+0x4c/0x8c)
[  713.411377] [<8009b154>] (notifier_call_chain+0x4c/0x8c) from
[<8009b24c>] (raw_notifier_call_chain+0x18/0x20)
[  713.421392] [<8009b24c>] (raw_notifier_call_chain+0x18/0x20) from
[<800a3d9c>] (clockevents_notify+0x30/0x198)
[  713.431417] [<800a3d9c>] (clockevents_notify+0x30/0x198) from
[<80052f58>] (arch_idle_multi_core+0x4c/0xc4)
[  713.441175] [<80052f58>] (arch_idle_multi_core+0x4c/0xc4) from
[<80044f68>] (default_idle+0x20/0x28)
[  713.450322] [<80044f68>] (default_idle+0x20/0x28) from [<800455c0>]
(cpu_idle+0xc8/0xfc)
[  713.458425] [<800455c0>] (cpu_idle+0xc8/0xfc) from [<80008984>]
(start_kernel+0x260/0x294)
[  713.466701] [<80008984>] (start_kernel+0x260/0x294) from
[<10008040>] (0x10008040)

So, the code here which bring the warnings:
void tick_broadcast_oneshot_control(unsigned long reason)
{
...
WARN_ON_ONCE(test_bit(cpu, tick_force_broadcast_mask));

}

>
> Thanks,
>
>         tglx
>
> Index: linux-2.6/kernel/time/tick-broadcast.c
> ===================================================================
> --- linux-2.6.orig/kernel/time/tick-broadcast.c
> +++ linux-2.6/kernel/time/tick-broadcast.c
> @@ -397,6 +397,8 @@ int tick_resume_broadcast(void)
>
>  /* FIXME: use cpumask_var_t. */
>  static DECLARE_BITMAP(tick_broadcast_oneshot_mask, NR_CPUS);
> +static DECLARE_BITMAP(tick_broadcast_pending, NR_CPUS);
> +static DECLARE_BITMAP(tick_force_broadcast_mask, NR_CPUS);
>
>  /*
>   * Exposed for debugging: see timer_list.c
> @@ -453,12 +455,24 @@ again:
>         /* Find all expired events */
>         for_each_cpu(cpu, tick_get_broadcast_oneshot_mask()) {
>                 td = &per_cpu(tick_cpu_device, cpu);
> -               if (td->evtdev->next_event.tv64 <= now.tv64)
> +               if (td->evtdev->next_event.tv64 <= now.tv64) {
>                         cpumask_set_cpu(cpu, to_cpumask(tmpmask));
> -               else if (td->evtdev->next_event.tv64 < next_event.tv64)
> +                       /*
> +                        * Mark the remote cpu in the pending mask, so
> +                        * it can avoid reprogramming the cpu local
> +                        * timer in tick_broadcast_oneshot_control().
> +                        */
> +                       set_bit(cpu, tick_broadcast_pending);
> +               } else if (td->evtdev->next_event.tv64 < next_event.tv64)
>                         next_event.tv64 = td->evtdev->next_event.tv64;
>         }
>
> +       /* Take care of enforced broadcast requests */
> +       for_each_cpu(cpu, to_cpumask(tick_force_broadcast_mask)) {
> +               set_bit(cpu, tmpmask);
> +               clear_bit(cpu, tick_force_broadcast_mask);
> +       }
> +
>         /*
>          * Wakeup the cpus which have an expired event.
>          */
> @@ -494,6 +508,7 @@ void tick_broadcast_oneshot_control(unsi
>         struct clock_event_device *bc, *dev;
>         struct tick_device *td;
>         unsigned long flags;
> +       ktime_t now;
>         int cpu;
>
>         /*
> @@ -518,6 +533,8 @@ void tick_broadcast_oneshot_control(unsi
>
>         raw_spin_lock_irqsave(&tick_broadcast_lock, flags);
>         if (reason == CLOCK_EVT_NOTIFY_BROADCAST_ENTER) {
> +               WARN_ON_ONCE(test_bit(cpu, tick_broadcast_pending));
> +               WARN_ON_ONCE(test_bit(cpu, tick_force_broadcast_mask));
>                 if (!cpumask_test_cpu(cpu, tick_get_broadcast_oneshot_mask())) {
>                         cpumask_set_cpu(cpu, tick_get_broadcast_oneshot_mask());
>                         clockevents_set_mode(dev, CLOCK_EVT_MODE_SHUTDOWN);
> @@ -529,10 +546,63 @@ void tick_broadcast_oneshot_control(unsi
>                         cpumask_clear_cpu(cpu,
>                                           tick_get_broadcast_oneshot_mask());
>                         clockevents_set_mode(dev, CLOCK_EVT_MODE_ONESHOT);
> -                       if (dev->next_event.tv64 != KTIME_MAX)
> -                               tick_program_event(dev->next_event, 1);
> +                       if (dev->next_event.tv64 == KTIME_MAX)
> +                               goto out;
> +                       /*
> +                        * The cpu handling the broadcast timer marked
> +                        * this cpu in the broadcast pending mask and
> +                        * fired the broadcast IPI. So we are going to
> +                        * handle the expired event anyway via the
> +                        * broadcast IPI handler. No need to reprogram
> +                        * the timer with an already expired event.
> +                        */
> +                       if (test_and_clear_bit(cpu, tick_broadcast_pending))
> +                               goto out;
> +                       /*
> +                        * If the pending bit is not set, then we are
> +                        * either the CPU handling the broadcast
> +                        * interrupt or we got woken by something else.
> +                        *
> +                        * We are not longer in the broadcast mask, so
> +                        * if the cpu local expiry time is already
> +                        * reached, we would reprogram the cpu local
> +                        * timer with an already expired event.
> +                        *
> +                        * This can lead to a ping-pong when we return
> +                        * to idle and therefor rearm the broadcast
> +                        * timer before the cpu local timer was able
> +                        * to fire. This happens because the forced
> +                        * reprogramming makes sure that the event
> +                        * will happen in the future and depending on
> +                        * the min_delta setting this might be far
> +                        * enough out that the ping-pong starts.
> +                        *
> +                        * If the cpu local next_event has expired
> +                        * then we know that the broadcast timer
> +                        * next_event has expired as well and
> +                        * broadcast is about to be handled. So we
> +                        * avoid reprogramming and enforce that the
> +                        * broadcast handler, which did not run yet,
> +                        * will invoke the cpu local handler.
> +                        *
> +                        * We cannot call the handler directly from
> +                        * here, because we might be in a NOHZ phase
> +                        * and we did not go through the irq_enter()
> +                        * nohz fixups.
> +                        */
> +                       now = ktime_get();
> +                       if (dev->next_event.tv64 <= now.tv64) {
> +                               set_bit(cpu, tick_force_broadcast_mask);
> +                               goto out;
> +                       }
> +                       /*
> +                        * We got woken by something else. Reprogram
> +                        * the cpu local timer device.
> +                        */
> +                       tick_program_event(dev->next_event, 1);
>                 }
>         }
> +out:
>         raw_spin_unlock_irqrestore(&tick_broadcast_lock, flags);
>  }
>
