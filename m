Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753377AbaBGR5v (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 12:57:51 -0500
Received: from www.linutronix.de ([62.245.132.108]:47736 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751912AbaBGR5t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 12:57:49 -0500
Date: Fri, 7 Feb 2014 18:57:51 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Preeti U Murthy <preeti@linux.vnet.ibm.com>
cc: fengguang.wu@intel.com, mingo@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] time/cpuidle:Fixup fallout from hrtimer broadcast mode
 inclusion
In-Reply-To: <20140207172924.8248.55002.stgit@preeti>
Message-ID: <alpine.DEB.2.02.1402071856420.21991@ionos.tec.linutronix.de>
References: <20140207172924.8248.55002.stgit@preeti>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 7 Feb 2014, Preeti U Murthy wrote:

> The broadcast timer registration has to be done only when
> GENERIC_CLOCKEVENTS_BROADCAST and TICK_ONESHOT config options are enabled.

Then we should compile that file only when those options are
enabled. Where is the point to compile that code w/o the registration
function?

> Also fix max_delta_ticks value for the pseudo clock device.
> 
> Reported-by: Fengguang Wu <fengguang.wu@intel.com>
> Signed-off-by: Preeti U Murthy <preeti@linux.vnet.ibm.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Ingo Molnar <mingo@kernel.org>
> ---
> 
>  kernel/time/tick-broadcast-hrtimer.c |    4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/kernel/time/tick-broadcast-hrtimer.c b/kernel/time/tick-broadcast-hrtimer.c
> index 5591aaa..bc383ac 100644
> --- a/kernel/time/tick-broadcast-hrtimer.c
> +++ b/kernel/time/tick-broadcast-hrtimer.c
> @@ -81,7 +81,7 @@ static struct clock_event_device ce_broadcast_hrtimer = {
>  	.min_delta_ns		= 1,
>  	.max_delta_ns		= KTIME_MAX,
>  	.min_delta_ticks	= 1,
> -	.max_delta_ticks	= KTIME_MAX,
> +	.max_delta_ticks	= ULONG_MAX,
>  	.mult			= 1,
>  	.shift			= 0,
>  	.cpumask		= cpu_all_mask,
> @@ -102,9 +102,11 @@ static enum hrtimer_restart bc_handler(struct hrtimer *t)
>  	return HRTIMER_RESTART;
>  }
>  
> +#if defined(CONFIG_GENERIC_CLOCKEVENTS_BROADCAST) && defined(CONFIG_TICK_ONESHOT)
>  void tick_setup_hrtimer_broadcast(void)
>  {
>  	hrtimer_init(&bctimer, CLOCK_MONOTONIC, HRTIMER_MODE_ABS);
>  	bctimer.function = bc_handler;
>  	clockevents_register_device(&ce_broadcast_hrtimer);
>  }
> +#endif
> 
> 
