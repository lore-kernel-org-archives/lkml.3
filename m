Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754097Ab3E0RGL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 May 2013 13:06:11 -0400
Received: from smtp1.it.da.ut.ee ([193.40.5.66]:42190 "EHLO smtp1.it.da.ut.ee"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752994Ab3E0RGK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 May 2013 13:06:10 -0400
Date: Mon, 27 May 2013 20:06:07 +0300 (EEST)
From: Meelis Roos <mroos@linux.ee>
To: Thomas Gleixner <tglx@linutronix.de>
cc: Borislav Petkov <bp@alien8.de>,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Len Brown <lenb@kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: 3.10-rc3: WARNING: at kernel/time/tick-broadcast.c:578
In-Reply-To: <alpine.LFD.2.02.1305271841130.4220@ionos>
Message-ID: <alpine.SOC.1.00.1305272005540.2372@math.ut.ee>
References: <alpine.SOC.1.00.1305271406050.2372@math.ut.ee> <20130527123520.GA4806@pd.tnic> <alpine.LFD.2.02.1305271456280.4220@ionos> <alpine.SOC.1.00.1305271849130.2372@math.ut.ee> <alpine.LFD.2.02.1305271841130.4220@ionos>
User-Agent: Alpine 1.00 (SOC 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Found another possibility how we end up with the stale flag.

This cures it, thank you!

> diff --git a/kernel/time/tick-broadcast.c b/kernel/time/tick-broadcast.c
> index 24938d5..0c73942 100644
> --- a/kernel/time/tick-broadcast.c
> +++ b/kernel/time/tick-broadcast.c
> @@ -511,6 +511,12 @@ again:
>  		}
>  	}
>  
> +	/*
> +	 * Remove the current cpu from the pending mask. The event is
> +	 * delivered immediately in tick_do_broadcast() !
> +	 */
> +	cpumask_clear_cpu(smp_processor_id(), tick_broadcast_pending_mask);
> +
>  	/* Take care of enforced broadcast requests */
>  	cpumask_or(tmpmask, tmpmask, tick_broadcast_force_mask);
>  	cpumask_clear(tick_broadcast_force_mask);
> @@ -575,8 +581,8 @@ void tick_broadcast_oneshot_control(unsigned long reason)
>  
>  	raw_spin_lock_irqsave(&tick_broadcast_lock, flags);
>  	if (reason == CLOCK_EVT_NOTIFY_BROADCAST_ENTER) {
> -		WARN_ON_ONCE(cpumask_test_cpu(cpu, tick_broadcast_pending_mask));
>  		if (!cpumask_test_and_set_cpu(cpu, tick_broadcast_oneshot_mask)) {
> +			WARN_ON_ONCE(cpumask_test_cpu(cpu, tick_broadcast_pending_mask));
>  			clockevents_set_mode(dev, CLOCK_EVT_MODE_SHUTDOWN);
>  			/*
>  			 * We only reprogram the broadcast timer if we
> 

-- 
Meelis Roos (mroos@linux.ee)
