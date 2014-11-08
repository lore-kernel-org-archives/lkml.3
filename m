Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753605AbaKHKjZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Nov 2014 05:39:25 -0500
Received: from e36.co.us.ibm.com ([32.97.110.154]:40911 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753476AbaKHKjX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Nov 2014 05:39:23 -0500
Message-ID: <545DF2D3.6030108@linux.vnet.ibm.com>
Date: Sat, 08 Nov 2014 16:09:15 +0530
From: Preeti U Murthy <preeti@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Daniel Lezcano <daniel.lezcano@linaro.org>, rjw@rjwysocki.net
CC: nicolas.pitre@linaro.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, peterz@infradead.org,
        linaro-kernel@lists.linaro.org, patches@linaro.org, lenb@kernel.org
Subject: Re: [PATCH V3 1/6] sched: idle: Add a weak arch_cpu_idle_poll function
References: <1415370687-18688-1-git-send-email-daniel.lezcano@linaro.org> <1415370687-18688-2-git-send-email-daniel.lezcano@linaro.org>
In-Reply-To: <1415370687-18688-2-git-send-email-daniel.lezcano@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14110810-0021-0000-0000-000005FE153C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/07/2014 08:01 PM, Daniel Lezcano wrote:
> The poll function is called when a timer expired or if we force to poll when
> the cpu_idle_force_poll option is set.
> 
> The poll function does:
> 
>        local_irq_enable();
>        while (!tif_need_resched())
>                cpu_relax();
> 
> This default poll function suits for the x86 arch because its rep; nop;
> hardware power optimization. But on other archs, this optimization does not
> exists and we are not saving power. The arch specific bits may want to
> optimize this loop by adding their own optimization.
> 
> Give an opportunity to the different platform to specify their own polling
> loop by adding a weak cpu_idle_poll_loop function.
> 
> Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
> ---
>  kernel/sched/idle.c | 29 +++++++++++++++++------------
>  1 file changed, 17 insertions(+), 12 deletions(-)
> 
> diff --git a/kernel/sched/idle.c b/kernel/sched/idle.c
> index c47fce7..ea65bbae 100644
> --- a/kernel/sched/idle.c
> +++ b/kernel/sched/idle.c
> @@ -42,18 +42,6 @@ static int __init cpu_idle_nopoll_setup(char *__unused)
>  __setup("hlt", cpu_idle_nopoll_setup);
>  #endif
> 
> -static inline int cpu_idle_poll(void)
> -{
> -	rcu_idle_enter();
> -	trace_cpu_idle_rcuidle(0, smp_processor_id());
> -	local_irq_enable();
> -	while (!tif_need_resched())
> -		cpu_relax();
> -	trace_cpu_idle_rcuidle(PWR_EVENT_EXIT, smp_processor_id());
> -	rcu_idle_exit();
> -	return 1;
> -}
> -
>  /* Weak implementations for optional arch specific functions */
>  void __weak arch_cpu_idle_prepare(void) { }
>  void __weak arch_cpu_idle_enter(void) { }
> @@ -65,6 +53,23 @@ void __weak arch_cpu_idle(void)
>  	local_irq_enable();
>  }
> 
> +void __weak arch_cpu_idle_poll(void)
> +{
> +	local_irq_enable();
> +	while (!tif_need_resched())
> +		cpu_relax();
> +}
> +
> +static inline int cpu_idle_poll(void)
> +{
> +	rcu_idle_enter();
> +	trace_cpu_idle_rcuidle(0, smp_processor_id());
> +	arch_cpu_idle_poll();
> +	trace_cpu_idle_rcuidle(PWR_EVENT_EXIT, smp_processor_id());
> +	rcu_idle_exit();
> +	return 1;
> +}
> +
>  /**
>   * cpuidle_idle_call - the main idle function
>   *
> 

Thanks Daniel!

Reviewed-by: Preeti U. Murthy <preeti@linux.vnet.ibm.com>

