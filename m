Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753354Ab3AXQoK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 11:44:10 -0500
Received: from mail-vb0-f47.google.com ([209.85.212.47]:45027 "EHLO
	mail-vb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751902Ab3AXQoI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 11:44:08 -0500
MIME-Version: 1.0
In-Reply-To: <1354537588-25831-2-git-send-email-vincent.guittot@linaro.org>
References: <1354537588-25831-1-git-send-email-vincent.guittot@linaro.org>
	<1354537588-25831-2-git-send-email-vincent.guittot@linaro.org>
Date: Thu, 24 Jan 2013 17:44:05 +0100
Message-ID: <CAFTL4hxPPddCmhcPrdZgWVSy3Z+9_Jr9ruT9L5qhq6yFuuEDNQ@mail.gmail.com>
Subject: Re: [PATCH Resend 1/3] sched: fix nr_busy_cpus with coupled cpuidle
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Vincent Guittot <vincent.guittot@linaro.org>
Cc: linux-kernel@vger.kernel.org, linaro-dev@lists.linaro.org,
        peterz@infradead.org, mingo@kernel.org, ccross@android.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/12/3 Vincent Guittot <vincent.guittot@linaro.org>:
> With the coupled cpuidle driver (but probably also with other drivers),
> a CPU loops in a temporary safe state while waiting for other CPUs of its
> cluster to be ready to enter the coupled C-state. If an IRQ or a softirq
> occurs, the CPU will stay in this internal loop if there is no need
> to resched. The SCHED softirq clears the NOHZ and increases
> nr_busy_cpus. If there is no need to resched, we will not call
> set_cpu_sd_state_idle because of this internal loop in a cpuidle state.
> We have to call set_cpu_sd_state_idle in tick_nohz_irq_exit which is used
> to handle such situation.

I'm a bit confused with this.

set_cpu_sd_state_busy() is only called from nohz_kick_needed(). And it
checks idle_cpu() before doing anything. So if no task is going to be
scheduled, idle_cpu() prevents from calling set_cpu_sd_state_busy().

I'm probably missing something.

Thanks.

>
> Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
> ---
>  kernel/time/tick-sched.c |    2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
> index 955d35b..b8d74ea 100644
> --- a/kernel/time/tick-sched.c
> +++ b/kernel/time/tick-sched.c
> @@ -570,6 +570,8 @@ void tick_nohz_irq_exit(void)
>         if (!ts->inidle)
>                 return;
>
> +       set_cpu_sd_state_idle();
> +
>         /* Cancel the timer because CPU already waken up from the C-states*/
>         menu_hrtimer_cancel();
>         __tick_nohz_idle_enter(ts);
> --
> 1.7.9.5
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
