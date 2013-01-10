Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754623Ab3AJXez (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 18:34:55 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:44238 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754503Ab3AJXeu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 18:34:50 -0500
Date: Thu, 10 Jan 2013 23:34:42 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Mark Langsdorf <mark.langsdorf@calxeda.com>
Cc: linux-kernel@vger.kernel.org, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Rob Herring <rob.herring@calxeda.com>
Subject: Re: [PATCH 1/4 v10] arm: use devicetree to get smp_twd clock
Message-ID: <20130110233442.GA30875@n2100.arm.linux.org.uk>
References: <1351631056-25938-1-git-send-email-mark.langsdorf@calxeda.com> <1357317346-1120-1-git-send-email-mark.langsdorf@calxeda.com> <1357317346-1120-2-git-send-email-mark.langsdorf@calxeda.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1357317346-1120-2-git-send-email-mark.langsdorf@calxeda.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark,

Rafael just asked me to look at this patch, though I guess these comments
should be directed to Rob who was the original patch author.

On Fri, Jan 04, 2013 at 10:35:43AM -0600, Mark Langsdorf wrote:
> diff --git a/arch/arm/kernel/smp_twd.c b/arch/arm/kernel/smp_twd.c
> index 49f335d..dad2d81 100644
> --- a/arch/arm/kernel/smp_twd.c
> +++ b/arch/arm/kernel/smp_twd.c
> @@ -239,12 +239,15 @@ static irqreturn_t twd_handler(int irq, void *dev_id)
>  	return IRQ_NONE;
>  }
>  
> -static struct clk *twd_get_clock(void)
> +static struct clk *twd_get_clock(struct device_node *np)
>  {
>  	struct clk *clk;
>  	int err;
>  
> -	clk = clk_get_sys("smp_twd", NULL);
> +	if (np)
> +		clk = of_clk_get(np, 0);
> +	else
> +		clk = clk_get_sys("smp_twd", NULL);
>  	if (IS_ERR(clk)) {
>  		pr_err("smp_twd: clock not found: %d\n", (int)PTR_ERR(clk));
>  		return clk;
> @@ -257,6 +260,7 @@ static struct clk *twd_get_clock(void)
>  		return ERR_PTR(err);
>  	}
>  
> +	twd_timer_rate = clk_get_rate(clk);

Hmm, so this overrides the later clk_get_rate() in twd_timer_setup(), making
the later one redundant.  However...

>  	return clk;
>  }
>  
> @@ -285,7 +289,7 @@ static int __cpuinit twd_timer_setup(struct clock_event_device *clk)
>  	 * during the runtime of the system.
>  	 */
>  	if (!common_setup_called) {
> -		twd_clk = twd_get_clock();
> +		twd_clk = twd_get_clock(NULL);
>  
>  		/*
>  		 * We use IS_ERR_OR_NULL() here, because if the clock stubs
> @@ -373,6 +377,8 @@ int __init twd_local_timer_register(struct twd_local_timer *tlt)
>  	if (!twd_base)
>  		return -ENOMEM;
>  
> +	twd_clk = twd_get_clock(NULL);
> +
>  	return twd_local_timer_common_register();

Ok, so this sets up twd_clk, and also twd_timer_rate, but
twd_local_timer_common_register() just ends up registering the set of
function pointers with the local timer code.  Some point later, the
->setup function is called, and that will happen with common_setup_called
false.  The result will be another call to twd_get_clock().

>  }
>  
> @@ -405,6 +411,8 @@ void __init twd_local_timer_of_register(void)
>  		goto out;
>  	}
>  
> +	twd_clk = twd_get_clock(np);
> +
>  	err = twd_local_timer_common_register();

And a similar thing happens here.  Except... the twd_clk gets overwritten
by the call to twd_get_clock(NULL) from twd_timer_setup().

I wonder if it would be much better to move twd_get_clock() out of
twd_timer_setup() entirely, moving it into twd_local_timer_common_register().
twd_local_timer_common_register() would have to take the dev node.
Also, leave the setting of twd_timer_rate in twd_timer_setup().

An alternative strategy would be to move the initialization of the
timer rate also into twd_local_timer_common_register(), detect the
NULL or error clock, and run the calibration from there (I don't think
we can move the calibration).  If that's chosen, then "common_setup_called"
should probably be renamed to "twd_calibration_done".

What do you think?
