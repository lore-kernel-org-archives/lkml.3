Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933070Ab3CLRGw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 13:06:52 -0400
Received: from mho-04-ewr.mailhop.org ([204.13.248.74]:24341 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932153Ab3CLRGr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 13:06:47 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18LfSbrz6lgQkuS3GCC4cvL
Date: Tue, 12 Mar 2013 10:06:41 -0700
From: Tony Lindgren <tony@atomide.com>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-arm-msm@vger.kernel.org,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 03/10] ARM: smp_twd: Divorce smp_twd from local timer
 API
Message-ID: <20130312170640.GC22059@atomide.com>
References: <20130308194802.GG11806@atomide.com>
 <513A40EF.8050403@codeaurora.org>
 <20130308200811.GJ11806@atomide.com>
 <513A4774.3040605@codeaurora.org>
 <20130308202947.GK11806@atomide.com>
 <513A8B22.5030008@codeaurora.org>
 <20130311172847.GP26093@atomide.com>
 <513E5804.3050104@codeaurora.org>
 <20130311225004.GR26093@atomide.com>
 <513E82EE.2040407@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <513E82EE.2040407@codeaurora.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Stephen Boyd <sboyd@codeaurora.org> [130311 18:25]:
> On 03/11/13 15:50, Tony Lindgren wrote:
> > * Stephen Boyd <sboyd@codeaurora.org> [130311 15:22]:
> >> Ok. qemu works for me before applying my patches. I've added this into
> >> the series before this patch to fix the boot issue.
> > OK thanks:
> >
> >
> 
> Actually, it's worse. From reading the code it looks like quite a few
> other machines register a clockevent and get jiffies going so they can
> calibrate the twd. I also see that Rob Herring's pull request to move
> smp_twd to CLKSRC_OF_DECLARE is going to conflict with any changes I
> make in the board files. I think we need to make the twd use the
> late_time_init callback if there is no clock rate and ignore the other
> patch I sent out a few hours ago. Basically, squash this into this 3/10
> patch.

Looks reasonable to me to keep things working.

Regards,

Tony
 
> ----8<-----
> 
> diff --git a/arch/arm/kernel/smp_twd.c b/arch/arm/kernel/smp_twd.c
> index a1185d3..c58918f 100644
> --- a/arch/arm/kernel/smp_twd.c
> +++ b/arch/arm/kernel/smp_twd.c
> @@ -90,8 +90,10 @@ static int twd_timer_ack(void)
>  	return 0;
>  }
>  
> -static void twd_timer_stop(struct clock_event_device *clk)
> +static void twd_timer_stop(void)
>  {
> +	struct clock_event_device *clk = __this_cpu_ptr(twd_evt);
> +
>  	twd_set_mode(CLOCK_EVT_MODE_UNUSED, clk);
>  	disable_percpu_irq(clk->irq);
>  }
> @@ -265,8 +267,9 @@ static void twd_get_clock(struct device_node *np)
>  /*
>   * Setup the local clock events for a CPU.
>   */
> -static int __cpuinit twd_timer_setup(struct clock_event_device *clk)
> +static void __cpuinit twd_timer_setup(void)
>  {
> +	struct clock_event_device *clk = __this_cpu_ptr(twd_evt);
>  	int cpu = smp_processor_id();
>  
>  	/*
> @@ -275,9 +278,9 @@ static int __cpuinit twd_timer_setup(struct clock_event_device *clk)
>  	 */
>  	if (per_cpu(percpu_setup_called, cpu)) {
>  		__raw_writel(0, twd_base + TWD_TIMER_CONTROL);
> -		clockevents_register_device(__this_cpu_ptr(twd_evt));
> +		clockevents_register_device(clk);
>  		enable_percpu_irq(clk->irq, 0);
> -		return 0;
> +		return;
>  	}
>  	per_cpu(percpu_setup_called, cpu) = true;
>  
> @@ -302,20 +305,18 @@ static int __cpuinit twd_timer_setup(struct clock_event_device *clk)
>  					0xf, 0xffffffff);
>  	enable_percpu_irq(clk->irq, 0);
>  
> -	return 0;
> +	return;
>  }
>  
>  static int __cpuinit twd_timer_cpu_notify(struct notifier_block *self,
>  					   unsigned long action, void *hcpu)
>  {
> -	struct clock_event_device *evt = this_cpu_ptr(twd_evt);
> -
>  	switch (action & ~CPU_TASKS_FROZEN) {
>  	case CPU_STARTING:
> -		twd_timer_setup(evt);
> +		twd_timer_setup();
>  		break;
>  	case CPU_DYING:
> -		twd_timer_stop(evt);
> +		twd_timer_stop();
>  		break;
>  	}
>  
> @@ -348,8 +349,15 @@ static int __init twd_local_timer_common_register(struct device_node *np)
>  
>  	twd_get_clock(np);
>  
> -	/* Immediately configure the timer on the boot CPU */
> -	twd_timer_setup(this_cpu_ptr(twd_evt));
> +	/*
> +	 * Immediately configure the timer on the boot CPU, unless we need
> +	 * jiffies to be incrementing to calibrate the rate in which case
> +	 * setup the timer in late_time_init.
> +	 */
> +	if (twd_timer_rate)
> +		twd_timer_setup();
> +	else
> +		late_time_init = twd_timer_setup;
>  
>  	return 0;
>  
> 
> -- 
> Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
> hosted by The Linux Foundation
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
