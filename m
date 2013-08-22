Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754138Ab3HVVIR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 17:08:17 -0400
Received: from mail-oa0-f50.google.com ([209.85.219.50]:36147 "EHLO
	mail-oa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754370Ab3HVVIM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 17:08:12 -0400
MIME-Version: 1.0
In-Reply-To: <1376975864-31487-1-git-send-email-zhangwm@marvell.com>
References: <1376975864-31487-1-git-send-email-zhangwm@marvell.com>
Date: Thu, 22 Aug 2013 14:08:09 -0700
Message-ID: <CAMbhsRT8S8CU589Ku1L9zWFKqR0quszQHwo3a2jeFZxN7Tc-UQ@mail.gmail.com>
Subject: Re: [PATCH] cpuidle: coupled: fix dead loop corner case
From: Colin Cross <ccross@google.com>
To: Neil Zhang <zhangwm@marvell.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 19, 2013 at 10:17 PM, Neil Zhang <zhangwm@marvell.com> wrote:
> There is a corener case when no peripheral irqs route to secondary
> cores.
> Let's take dual core system for example, the sequence is as following:
>
>                 Core 0                          Core1
> 1.                                 set waiting bit and enter waiting loop
> 2. set waiting bit and poke core1
> 3.                                 clear poke in irq and enter safe state
> 4. set ready bit and enter ready loop
>
> Since there is no peripheral irq route to core 1, so it will stay in
> safe state forever, and core 0 will dead loop in the following code.
>         while (!cpuidle_coupled_cpus_ready(coupled)) {
>                 /* Check if any other cpus bailed out of idle. */
>                 if (!cpuidle_coupled_cpus_waiting(coupled))
>         }
>
> The solution is don't let secondary core enter safe state when it has
> already handled the poke interrupt.
>
> Signed-off-by: Neil Zhang <zhangwm@marvell.com>
> Reviewed-by: Fangsuo Wu <fswu@marvell.com>
> ---
>  drivers/cpuidle/coupled.c |    7 +++++++
>  1 files changed, 7 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/cpuidle/coupled.c b/drivers/cpuidle/coupled.c
> index 2a297f8..a37c718 100644
> --- a/drivers/cpuidle/coupled.c
> +++ b/drivers/cpuidle/coupled.c
> @@ -119,6 +119,7 @@ struct cpuidle_coupled {
>  #define CPUIDLE_COUPLED_NOT_IDLE       (-1)
>
>  static DEFINE_MUTEX(cpuidle_coupled_lock);
> +static DEFINE_PER_CPU(bool, poke_sync);
>  static DEFINE_PER_CPU(struct call_single_data, cpuidle_coupled_poke_cb);
>
>  /*
> @@ -295,6 +296,7 @@ static void cpuidle_coupled_poked(void *info)
>  {
>         int cpu = (unsigned long)info;
>         cpumask_clear_cpu(cpu, &cpuidle_coupled_poked_mask);
> +       __this_cpu_write(poke_sync, true);
>  }
>
>  /**
> @@ -473,6 +475,7 @@ retry:
>          * allowed for a single cpu.
>          */
>         while (!cpuidle_coupled_cpus_waiting(coupled)) {
> +               __this_cpu_write(poke_sync, false);
>                 if (cpuidle_coupled_clear_pokes(dev->cpu)) {
>                         cpuidle_coupled_set_not_waiting(dev->cpu, coupled);
>                         goto out;
> @@ -483,6 +486,10 @@ retry:
>                         goto out;
>                 }
>
> +               if (cpuidle_coupled_cpus_waiting(coupled)
> +                       && __this_cpu_read(poke_sync))
> +                       break;
> +
>                 entered_state = cpuidle_enter_state(dev, drv,
>                         dev->safe_state_index);
>         }
> --
> 1.7.4.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

I have a similar patch that avoids adding another check for
cpuidle_coupled_cpus_waiting, and uses the return value from
cpuidle_coupled_clear_pokes instead of adding a percpu bool.  I will
post it shortly.

Do you have a test case that can reproduce this easily?
