Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161584Ab3DEFLm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Apr 2013 01:11:42 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:50492 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932563Ab3DEFLk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Apr 2013 01:11:40 -0400
X-IronPort-AV: E=Sophos;i="4.87,412,1363158000"; 
   d="scan'208";a="36071744"
Message-ID: <515E5CFC.4090900@codeaurora.org>
Date: Thu, 04 Apr 2013 22:11:24 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130328 Thunderbird/17.0.5
MIME-Version: 1.0
To: John Stultz <john.stultz@linaro.org>, Thomas Gleixner <tglx@linutronix.de>
CC: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Mark Rutland <mark.rutland@arm.com>,
        Marc Zyngier <Marc.Zyngier@arm.com>
Subject: Re: [PATCH] ARM: arch_timer: Silence debug preempt warnings
References: <1364934672-31554-1-git-send-email-sboyd@codeaurora.org>
In-Reply-To: <1364934672-31554-1-git-send-email-sboyd@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/2/2013 1:31 PM, Stephen Boyd wrote:
> Hot-plugging with CONFIG_DEBUG_PREEMPT=y on a device with arm
> architected timers causes a slew of "using smp_processor_id() in
> preemptible" warnings:
>
>   BUG: using smp_processor_id() in preemptible [00000000] code: sh/111
>   caller is arch_timer_cpu_notify+0x14/0xc8
>
> This happens because sometimes the cpu notifier, arch_timer_cpu_notify(),
> is called in preemptible context but we use this_cpu_ptr()
> to retrieve the clockevent unconditionally. We're only going to
> actually use the pointer in non-preemptible context though,
> so use __this_cpu_ptr() instead to avoid the preemptible checks
> and silence the warning.
>
> Cc: Mark Rutland <mark.rutland@arm.com>
> Cc: Marc Zyngier <Marc.Zyngier@arm.com>
> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
> ---

Anyone else seeing this one?

>  drivers/clocksource/arm_arch_timer.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/clocksource/arm_arch_timer.c b/drivers/clocksource/arm_arch_timer.c
> index d7ad425..5928c29 100644
> --- a/drivers/clocksource/arm_arch_timer.c
> +++ b/drivers/clocksource/arm_arch_timer.c
> @@ -248,7 +248,7 @@ static void __cpuinit arch_timer_stop(struct clock_event_device *clk)
>  static int __cpuinit arch_timer_cpu_notify(struct notifier_block *self,
>  					   unsigned long action, void *hcpu)
>  {
> -	struct clock_event_device *evt = this_cpu_ptr(arch_timer_evt);
> +	struct clock_event_device *evt = __this_cpu_ptr(arch_timer_evt);
>  
>  	switch (action & ~CPU_TASKS_FROZEN) {
>  	case CPU_STARTING:

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

