Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754826AbaDKKEZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 06:04:25 -0400
Received: from mail-oa0-f52.google.com ([209.85.219.52]:33735 "EHLO
	mail-oa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750848AbaDKKEX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 06:04:23 -0400
MIME-Version: 1.0
In-Reply-To: <20140410143857.GA27654@localhost.localdomain>
References: <CAKohpo=uT0oC+bZVJQPsoGLb-a4y4huYKtd1ayb4_+iH4906nw@mail.gmail.com>
	<CAKohpom5Ft_XrNTExE9Ukyv1e4car+wicDiPp_Bdhy=PW9Sq8g@mail.gmail.com>
	<20140410143857.GA27654@localhost.localdomain>
Date: Fri, 11 Apr 2014 15:34:23 +0530
Message-ID: <CAKohpomMhpGsYGafr5uZ0QgO0MEndqDA4G=4syhus4sZW3d8cg@mail.gmail.com>
Subject: Re: [Query]: tick-sched: why don't we stop tick when we are running
 idle task?
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10 April 2014 20:09, Frederic Weisbecker <fweisbec@gmail.com> wrote:
> diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
> index 9f8af69..1e2d6b7 100644
> --- a/kernel/time/tick-sched.c
> +++ b/kernel/time/tick-sched.c
> @@ -202,13 +202,16 @@ static void tick_nohz_restart_sched_tick(struct tick_sched *ts, ktime_t now);
>  void __tick_nohz_full_check(void)
>  {
>         struct tick_sched *ts = &__get_cpu_var(tick_cpu_sched);
> +       unsigned long flags;
>
> +       local_irq_save(flags);

As we need to disable interrupts to read this variable, would it be
better to just remove this completely and use is_idle_task(current)
instead?

>         if (tick_nohz_full_cpu(smp_processor_id())) {
> -               if (ts->tick_stopped && !is_idle_task(current)) {
> +               if (ts->tick_stopped && !ts->inidle)) {
>                         if (!can_stop_full_tick())
>                                 tick_nohz_restart_sched_tick(ts, ktime_get());
>                 }
>         }
> +       local_irq_restore(flags);
>  }

> If you like it I'll push it to Ingo.

Yes please. And thanks for the explanations. It was pretty useful.

I am looking to offload 1 second tick to timekeeping CPUs and so
going through these frameworks. I don't have a working solution yet
(even partially :)). Would send a RFC to you as soon as I get anything
working.

--
viresh
