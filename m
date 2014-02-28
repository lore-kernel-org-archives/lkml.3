Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752040AbaB1MF3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 07:05:29 -0500
Received: from e38.co.us.ibm.com ([32.97.110.159]:38968 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751981AbaB1MF1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 07:05:27 -0500
Message-ID: <53107AA4.30902@linux.vnet.ibm.com>
Date: Fri, 28 Feb 2014 17:31:40 +0530
From: Preeti U Murthy <preeti@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Daniel Lezcano <daniel.lezcano@linaro.org>
CC: mingo@kernel.org, peterz@infradead.org, tglx@linutronix.de,
        rjw@rjwysocki.net, nicolas.pitre@linaro.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH V3 1/5] idle/cpuidle: Split cpuidle_idle_call main function
 into smaller functions
References: <1393315733-32321-1-git-send-email-daniel.lezcano@linaro.org>
In-Reply-To: <1393315733-32321-1-git-send-email-daniel.lezcano@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14022812-1344-0000-0000-000006246D27
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/25/2014 01:38 PM, Daniel Lezcano wrote:
> In order to allow better integration between the cpuidle framework and the
> scheduler, reducing the distance between these two sub-components will
> facilitate this integration by moving part of the cpuidle code in the idle
> task file and, because idle.c is in the sched directory, we have access to
> the scheduler's private structures.
> 
> This patch splits the cpuidle_idle_call main entry function into 3 calls
> to a newly added API:
>  1. select the idle state
>  2. enter the idle state
>  3. reflect the idle state
> 
> The cpuidle_idle_call calls these three functions to implement the main
> idle entry function.
> 
> Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
> Acked-by: Nicolas Pitre <nico@linaro.org>
> ---
> 
> ChangeLog:
> 
> V3:
>     * moved broadcast timer outside of cpuidle_enter() as suggested by
>       Preeti U Murthy.
> 	https://lkml.org/lkml/2014/2/24/601
> V2: 
>     * splitted cpuidle_select error check into 'cpuidle_enabled' function
> 
> ---
>  drivers/cpuidle/cpuidle.c |   97 ++++++++++++++++++++++++++++++++++++----------
>  include/linux/cpuidle.h   |   19 +++++++++
>  2 files changed, 95 insertions(+), 21 deletions(-)
> 
> Index: cpuidle-next/drivers/cpuidle/cpuidle.c
> ===================================================================
> --- cpuidle-next.orig/drivers/cpuidle/cpuidle.c
> +++ cpuidle-next/drivers/cpuidle/cpuidle.c
> @@ -65,6 +65,26 @@ int cpuidle_play_dead(void)
>  }
> 
>  /**
> + * cpuidle_enabled - check if the cpuidle framework is ready
> + * @dev: cpuidle device for this cpu
> + * @drv: cpuidle driver for this cpu
> + *
> + * Return 0 on success, otherwise:
> + * -NODEV : the cpuidle framework is not available
> + * -EBUSY : the cpuidle framework is not initialized
> + */
> +int cpuidle_enabled(struct cpuidle_driver *drv, struct cpuidle_device *dev)
> +{
> +	if (off || !initialized)
> +		return -ENODEV;
> +
> +	if (!drv || !dev || !dev->enabled)
> +		return -EBUSY;
> +
> +	return 0;
> +}
> +
> +/**
>   * cpuidle_enter_state - enter the state and update stats
>   * @dev: cpuidle device for this cpu
>   * @drv: cpuidle driver for this cpu
> @@ -108,6 +128,51 @@ int cpuidle_enter_state(struct cpuidle_d
>  }
> 
>  /**
> + * cpuidle_select - ask the cpuidle framework to choose an idle state
> + *
> + * @drv: the cpuidle driver
> + * @dev: the cpuidle device
> + *
> + * Returns the index of the idle state.
> + */
> +int cpuidle_select(struct cpuidle_driver *drv, struct cpuidle_device *dev)
> +{
> +	return cpuidle_curr_governor->select(drv, dev);
> +}
> +
> +/**
> + * cpuidle_enter - enter into the specified idle state
> + *
> + * @drv:   the cpuidle driver tied with the cpu
> + * @dev:   the cpuidle device
> + * @index: the index in the idle state table
> + *
> + * Returns the index in the idle state, < 0 in case of error.
> + * The error code depends on the backend driver
> + */
> +int cpuidle_enter(struct cpuidle_driver *drv, struct cpuidle_device *dev,
> +		  int index)
> +{
> +	if (cpuidle_state_is_coupled(dev, drv, index))
> +		return cpuidle_enter_state_coupled(dev, drv, index);
> +	return cpuidle_enter_state(dev, drv, index);
> +}
> +
> +/**
<snip>
> 
> -	if (cpuidle_state_is_coupled(dev, drv, next_state))
> -		entered_state = cpuidle_enter_state_coupled(dev, drv,
> -							    next_state);
> -	else
> -		entered_state = cpuidle_enter_state(dev, drv, next_state);
> +	entered_state = cpuidle_enter(drv, dev, next_state);

Wouldn't you need to check for return value on cpuidle_enter()?

Regards
Preeti U Murthy

