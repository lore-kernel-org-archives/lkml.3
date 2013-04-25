Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759344Ab3DYSba (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 14:31:30 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:23302 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759333Ab3DYSb2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 14:31:28 -0400
X-IronPort-AV: E=Sophos;i="4.87,552,1363158000"; 
   d="scan'208";a="41426320"
Message-ID: <5179767F.5030405@codeaurora.org>
Date: Thu, 25 Apr 2013 11:31:27 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:17.0) Gecko/20130328 Thunderbird/17.0.5
MIME-Version: 1.0
To: arm@kernel.org
CC: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Mark Rutland <mark.rutland@arm.com>
Subject: Re: [PATCH/RESEND] ARM: arch_timer: Silence debug preempt warnings
References: <1366241178-16626-1-git-send-email-sboyd@codeaurora.org>
In-Reply-To: <1366241178-16626-1-git-send-email-sboyd@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/17/13 16:26, Stephen Boyd wrote:
> Hot-plugging with CONFIG_DEBUG_PREEMPT=y on a device with arm
> architected timers causes a slew of "using smp_processor_id() in
> preemptible" warnings:
>
>   BUG: using smp_processor_id() in preemptible [00000000] code: sh/111
>   caller is arch_timer_cpu_notify+0x14/0xc8
>
> This happens because sometimes the cpu notifier,
> arch_timer_cpu_notify(), is called in preemptible context and
> other times in non-preemptible context but we use this_cpu_ptr()
> to retrieve the clockevent in all cases. We're only going to
> actually use the pointer in non-preemptible context though, so
> push the this_cpu_ptr() access down into the cases to force the
> checks to occur only in non-preemptible contexts.
>
> Cc: John Stultz <john.stultz@linaro.org>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Mark Rutland <mark.rutland@arm.com>
> Acked-by: Marc Zyngier <Marc.Zyngier@arm.com>
> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
> ---
>
> Resending to arm-soc maintainers instead of timekeeping maintainers. Who
> maintains this driver?

Ping.

>
>  drivers/clocksource/arm_arch_timer.c | 10 ++++++----
>  1 file changed, 6 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/clocksource/arm_arch_timer.c b/drivers/clocksource/arm_arch_timer.c
> index d7ad425..a65a710 100644
> --- a/drivers/clocksource/arm_arch_timer.c
> +++ b/drivers/clocksource/arm_arch_timer.c
> @@ -248,14 +248,16 @@ static void __cpuinit arch_timer_stop(struct clock_event_device *clk)
>  static int __cpuinit arch_timer_cpu_notify(struct notifier_block *self,
>  					   unsigned long action, void *hcpu)
>  {
> -	struct clock_event_device *evt = this_cpu_ptr(arch_timer_evt);
> -
> +	/*
> +	 * Grab cpu pointer in each case to avoid spurious
> +	 * preemptible warnings
> +	 */
>  	switch (action & ~CPU_TASKS_FROZEN) {
>  	case CPU_STARTING:
> -		arch_timer_setup(evt);
> +		arch_timer_setup(this_cpu_ptr(arch_timer_evt));
>  		break;
>  	case CPU_DYING:
> -		arch_timer_stop(evt);
> +		arch_timer_stop(this_cpu_ptr(arch_timer_evt));
>  		break;
>  	}
>  


-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

