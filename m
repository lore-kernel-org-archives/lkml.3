Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751962AbaKJMlY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 07:41:24 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:59308 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750904AbaKJMlX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 07:41:23 -0500
Date: Mon, 10 Nov 2014 13:41:11 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: rjw@rjwysocki.net, preeti@linux.vnet.ibm.com, nicolas.pitre@linaro.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linaro-kernel@lists.linaro.org, patches@linaro.org, lenb@kernel.org
Subject: Re: [PATCH V3 2/6] sched: idle: cpuidle: Check the latency req
 before idle
Message-ID: <20141110124111.GN3337@twins.programming.kicks-ass.net>
References: <1415370687-18688-1-git-send-email-daniel.lezcano@linaro.org>
 <1415370687-18688-3-git-send-email-daniel.lezcano@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1415370687-18688-3-git-send-email-daniel.lezcano@linaro.org>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 07, 2014 at 03:31:23PM +0100, Daniel Lezcano wrote:
> @@ -216,19 +219,26 @@ static void cpu_idle_loop(void)
>  			local_irq_disable();
>  			arch_cpu_idle_enter();
>  
> +			latency_req = pm_qos_request(PM_QOS_CPU_DMA_LATENCY);
> +
>  			/*
>  			 * In poll mode we reenable interrupts and spin.
>  			 *
> +			 * If the latency req is zero, we don't want to
> +			 * enter any idle state and we jump to the poll
> +			 * function directly
> +			 *
>  			 * Also if we detected in the wakeup from idle
>  			 * path that the tick broadcast device expired
>  			 * for us, we don't want to go deep idle as we
>  			 * know that the IPI is going to arrive right
>  			 * away
>  			 */
> -			if (cpu_idle_force_poll || tick_check_broadcast_expired())
> +			if (!latency_req || cpu_idle_force_poll ||
> +			    tick_check_broadcast_expired())
>  				cpu_idle_poll();

Is this why you wanted that weak poll function?

Should we not instead allow an arch to deal with !latency_req and only
fall back to this polling if there is no actual way for it to implement
this better?
