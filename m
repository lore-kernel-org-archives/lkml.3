Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932417AbaJVUlm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 16:41:42 -0400
Received: from mail-qa0-f42.google.com ([209.85.216.42]:39251 "EHLO
	mail-qa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754265AbaJVUll (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 16:41:41 -0400
Date: Wed, 22 Oct 2014 16:41:37 -0400 (EDT)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
To: Daniel Lezcano <daniel.lezcano@linaro.org>
cc: rjw@rjwysocki.net, peterz@infradead.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org
Subject: Re: [PATCH 3/5] cpuidle: idle: menu: Don't reflect when a state
 selection failed
In-Reply-To: <1413822343-1972-3-git-send-email-daniel.lezcano@linaro.org>
Message-ID: <alpine.LFD.2.11.1410221638430.6969@knanqh.ubzr>
References: <1413822343-1972-1-git-send-email-daniel.lezcano@linaro.org> <1413822343-1972-3-git-send-email-daniel.lezcano@linaro.org>
User-Agent: Alpine 2.11 (LFD 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 20 Oct 2014, Daniel Lezcano wrote:

> In the current code, the check to reflect or not the outcoming state is done
> against the idle state which has been choose and its value.

s/choose/chosen/

> Instead of doing a check in each of the reflect functions, just don't call reflect
> if something went wrong in the idle path.
> 
> Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>

Acked-by: Nicolas Pitre <nico@linaro.org>

> ---
>  drivers/cpuidle/governors/ladder.c | 3 +--
>  drivers/cpuidle/governors/menu.c   | 4 +---
>  kernel/sched/idle.c                | 3 ++-
>  3 files changed, 4 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/cpuidle/governors/ladder.c b/drivers/cpuidle/governors/ladder.c
> index fb396d6..c0b36a8 100644
> --- a/drivers/cpuidle/governors/ladder.c
> +++ b/drivers/cpuidle/governors/ladder.c
> @@ -165,8 +165,7 @@ static int ladder_enable_device(struct cpuidle_driver *drv,
>  static void ladder_reflect(struct cpuidle_device *dev, int index)
>  {
>  	struct ladder_device *ldev = &__get_cpu_var(ladder_devices);
> -	if (index > 0)
> -		ldev->last_state_idx = index;
> +	ldev->last_state_idx = index;
>  }
>  
>  static struct cpuidle_governor ladder_governor = {
> diff --git a/drivers/cpuidle/governors/menu.c b/drivers/cpuidle/governors/menu.c
> index a17515f..3907301 100644
> --- a/drivers/cpuidle/governors/menu.c
> +++ b/drivers/cpuidle/governors/menu.c
> @@ -365,9 +365,7 @@ static int menu_select(struct cpuidle_driver *drv, struct cpuidle_device *dev,
>  static void menu_reflect(struct cpuidle_device *dev, int index)
>  {
>  	struct menu_device *data = &__get_cpu_var(menu_devices);
> -	data->last_state_idx = index;
> -	if (index >= 0)
> -		data->needs_update = 1;
> +	data->needs_update = 1;
>  }
>  
>  /**
> diff --git a/kernel/sched/idle.c b/kernel/sched/idle.c
> index f439161..9ac7322 100644
> --- a/kernel/sched/idle.c
> +++ b/kernel/sched/idle.c
> @@ -162,7 +162,8 @@ use_default:
>  	/*
>  	 * Give the governor an opportunity to reflect on the outcome
>  	 */
> -	cpuidle_reflect(dev, entered_state);
> +	if (entered_state >= 0)
> +		cpuidle_reflect(dev, entered_state);
>  
>  exit_idle:
>  	__current_set_polling();
> -- 
> 1.9.1
> 
> 
