Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932893AbaJVUiQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 16:38:16 -0400
Received: from mail-qc0-f182.google.com ([209.85.216.182]:50011 "EHLO
	mail-qc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932421AbaJVUiN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 16:38:13 -0400
Date: Wed, 22 Oct 2014 16:38:10 -0400 (EDT)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
To: Daniel Lezcano <daniel.lezcano@linaro.org>
cc: rjw@rjwysocki.net, peterz@infradead.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org
Subject: Re: [PATCH 2/5] sched: idle: Get the next timer event and pass it
 the cpuidle framework
In-Reply-To: <1413822343-1972-2-git-send-email-daniel.lezcano@linaro.org>
Message-ID: <alpine.LFD.2.11.1410221630120.6969@knanqh.ubzr>
References: <1413822343-1972-1-git-send-email-daniel.lezcano@linaro.org> <1413822343-1972-2-git-send-email-daniel.lezcano@linaro.org>
User-Agent: Alpine 2.11 (LFD 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 20 Oct 2014, Daniel Lezcano wrote:

> Following the logic of the previous patch, retrieve from the idle task the
> expected timer sleep duration and pass it to the cpuidle framework.
> 
> Take the opportunity to remove the unused headers in the menu.c file.
> 
> This patch does not change the current behavior.
> 
> Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>

One minor nit below.

> @@ -211,6 +212,12 @@ static void cpu_idle_loop(void)
>  			latency_req = pm_qos_request(PM_QOS_CPU_DMA_LATENCY);
>  
>  			/*
> +			 * The next timer event in us
> +			 */

This 3-line comment is redundant. The code is obvious enough on its own.

> +			next_timer_event = ktime_to_us(
> +				tick_nohz_get_sleep_length());

I'd suggest this form for better readability:

			next_timer_event =
				ktime_to_us(tick_nohz_get_sleep_length());

Other than that...

Acked-by: Nicolas Pitre <nico@linaro.org>

> +
> +			/*
>  			 * In poll mode we reenable interrupts and spin.
>  			 *
>  			 * If the latency req is zero, we don't want to
> @@ -227,7 +234,8 @@ static void cpu_idle_loop(void)
>  			    tick_check_broadcast_expired())
>  				cpu_idle_poll();
>  			else
> -				cpuidle_idle_call(latency_req);
> +				cpuidle_idle_call(latency_req,
> +						  next_timer_event);
>  
>  			arch_cpu_idle_exit();
>  		}
> -- 
> 1.9.1
> 
> 
