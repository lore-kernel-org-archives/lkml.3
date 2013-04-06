Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932873Ab3DFLYF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Apr 2013 07:24:05 -0400
Received: from inca-roads.misterjones.org ([213.251.177.50]:35643 "EHLO
	inca-roads.misterjones.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932821Ab3DFLYB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Apr 2013 07:24:01 -0400
X-Greylist: delayed 2555 seconds by postgrey-1.27 at vger.kernel.org; Sat, 06 Apr 2013 07:24:01 EDT
To: Stephen Boyd <sboyd@codeaurora.org>
Subject: Re: [PATCHv2] ARM: =?UTF-8?Q?arch=5Ftimer=3A=20Silence=20debug=20preempt?=
 =?UTF-8?Q?=20warnings?=
X-PHP-Originating-Script: 0:func.inc
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Sat, 06 Apr 2013 12:41:21 +0200
From: Marc Zyngier <marc.zyngier@arm.com>
Cc: John Stultz <john.stultz@linaro.org>, Thomas Gleixner <tglx@linutronix.de>,
        Mark Rutland <mark.rutland@arm.com>, <linux-arm-msm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Organization: ARM Ltd
In-Reply-To: <1365195449-6755-1-git-send-email-sboyd@codeaurora.org>
References: <1365195449-6755-1-git-send-email-sboyd@codeaurora.org>
Message-ID: <211ac95efd49bd57933aec8c8e746648@localhost>
User-Agent: RoundCube Webmail/0.3.1
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Rcpt-To: sboyd@codeaurora.org, john.stultz@linaro.org, tglx@linutronix.de, mark.rutland@arm.com, linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
X-SA-Exim-Mail-From: marc.zyngier@arm.com
X-SA-Exim-Scanned: No (on inca-roads.misterjones.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri,  5 Apr 2013 13:57:29 -0700, Stephen Boyd <sboyd@codeaurora.org>
wrote:
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
> Cc: Mark Rutland <mark.rutland@arm.com>
> Cc: Marc Zyngier <Marc.Zyngier@arm.com>
> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
> ---
> 
> Changes since v1:
>  * Pushed down this_cpu_ptr and added a comment
> 
>  drivers/clocksource/arm_arch_timer.c | 10 ++++++----
>  1 file changed, 6 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/clocksource/arm_arch_timer.c
> b/drivers/clocksource/arm_arch_timer.c
> index d7ad425..a65a710 100644
> --- a/drivers/clocksource/arm_arch_timer.c
> +++ b/drivers/clocksource/arm_arch_timer.c
> @@ -248,14 +248,16 @@ static void __cpuinit arch_timer_stop(struct
> clock_event_device *clk)
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

Looks good to me.

Acked-by: Marc Zyngier <marc.zyngier@arm.com>

Cheers,

        M.
-- 
Fast, cheap, reliable. Pick two.
