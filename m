Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755289AbaD1LOh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 07:14:37 -0400
Received: from mail-wi0-f173.google.com ([209.85.212.173]:35158 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754453AbaD1LOf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 07:14:35 -0400
Message-ID: <535E3818.2040905@linaro.org>
Date: Mon, 28 Apr 2014 13:14:32 +0200
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Linux PM list <linux-pm@vger.kernel.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 2/2] cpuidle / menu: Return error code if there are no
 suitable states
References: <2471963.urOyfY8mOG@vostro.rjw.lan> <6832089.A5AOPipfbA@vostro.rjw.lan>
In-Reply-To: <6832089.A5AOPipfbA@vostro.rjw.lan>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/27/2014 02:55 PM, Rafael J. Wysocki wrote:
> From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
>
> If there is a PM QoS latency limit and all of the sufficiently shallow
> C-states are disabled, the cpuidle menu governor returns 0 which on
> some systems is CPUIDLE_DRIVER_STATE_START and shouldn't be returned
> if that C-state has been disabled.
>
> Fix the issue by modifying the menu governor to return an error code
> in such situations.
>
> Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> ---
>   drivers/cpuidle/governors/menu.c |    2 +-
>   include/linux/cpuidle.h          |    2 ++
>   2 files changed, 3 insertions(+), 1 deletion(-)
>
> Index: linux-pm/drivers/cpuidle/governors/menu.c
> ===================================================================
> --- linux-pm.orig/drivers/cpuidle/governors/menu.c
> +++ linux-pm/drivers/cpuidle/governors/menu.c
> @@ -296,7 +296,7 @@ static int menu_select(struct cpuidle_dr
>   		data->needs_update = 0;
>   	}
>
> -	data->last_state_idx = 0;
> +	data->last_state_idx = CPUIDLE_DRIVER_STATE_POLL;
>
>   	/* Special case when user has set very strict latency requirement */
>   	if (unlikely(latency_req == 0))
> Index: linux-pm/include/linux/cpuidle.h
> ===================================================================
> --- linux-pm.orig/include/linux/cpuidle.h
> +++ linux-pm/include/linux/cpuidle.h
> @@ -217,8 +217,10 @@ static inline int cpuidle_register_gover
>
>   #ifdef CONFIG_ARCH_HAS_CPU_RELAX
>   #define CPUIDLE_DRIVER_STATE_START	1
> +#define CPUIDLE_DRIVER_STATE_POLL	0
>   #else
>   #define CPUIDLE_DRIVER_STATE_START	0
> +#define CPUIDLE_DRIVER_STATE_POLL	(-ENXIO)
>   #endif
>
>   #endif /* _LINUX_CPUIDLE_H */

Hi Rafael,

CPUIDLE_DRIVER_STATE_START is only for x86. It introduces some confusion 
in the code. As only two drivers are concerned by it, wouldn't make 
sense to add the poll state to those driver directly instead of having 
the code hacked around ? (eg. insert the poll state in the common 
cpuidle code).


-- 
  <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

