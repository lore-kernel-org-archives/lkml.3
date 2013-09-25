Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755257Ab3IYWvA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 18:51:00 -0400
Received: from mail-wg0-f46.google.com ([74.125.82.46]:59239 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752857Ab3IYWu6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 18:50:58 -0400
Message-ID: <524368CF.4030803@linaro.org>
Date: Thu, 26 Sep 2013 00:50:55 +0200
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Viresh Kumar <viresh.kumar@linaro.org>, rjw@sisk.pl
CC: linaro-kernel@lists.linaro.org, patches@linaro.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 21/21] cpuidle: change governor from within cpuidle_replace_governor()
References: <cover.1379779777.git.viresh.kumar@linaro.org> <5b758e21eeb97f5f68191819c0820673692b6b75.1379779777.git.viresh.kumar@linaro.org>
In-Reply-To: <5b758e21eeb97f5f68191819c0820673692b6b75.1379779777.git.viresh.kumar@linaro.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/22/2013 03:21 AM, Viresh Kumar wrote:
> When I first read cpuidle_replace_governor()'s name I thought it will replace
> the governor (as per its name) but then found that it just returns the next best
> governor. And cpuidle_unregister_governor() actually replaces it.
> 
> We always replace current governor with the next best and this information is
> already present with cpuidle_replace_governor() and so we don't really need to
> send an additional argument for it.
> 
> Also, it makes sense to actually call cpuidle_switch_governor() from within
> cpuidle_replace_governor() instead.
> 
> Along with this ret_gov is now renamed as new_gov to better suit its purpose.

Actually I am wondering if all this stuff is not over-engineered.

There are 2 governors, each of them suits for a specific kernel config,
periodic tick or tickless system.

menu     => tickless system
periodic => periodic tick system

IMHO, all the code with rating checking and so do not really makes
sense. Wouldn't make sense to remove this code ?

> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
> ---
>  drivers/cpuidle/governor.c | 24 +++++++++++-------------
>  1 file changed, 11 insertions(+), 13 deletions(-)
> 
> diff --git a/drivers/cpuidle/governor.c b/drivers/cpuidle/governor.c
> index ea2f8e7..deb6e50 100644
> --- a/drivers/cpuidle/governor.c
> +++ b/drivers/cpuidle/governor.c
> @@ -98,26 +98,27 @@ int cpuidle_register_governor(struct cpuidle_governor *gov)
>  }
>  
>  /**
> - * cpuidle_replace_governor - find a replacement governor
> - * @exclude_rating: the rating that will be skipped while looking for
> - * new governor.
> + * cpuidle_replace_governor - replace governor with highest rating one
> + *
> + * Finds governor (excluding cpuidle_curr_governor) with highest rating and
> + * replaces cpuidle_curr_governor with it.
>   */
> -static struct cpuidle_governor *cpuidle_replace_governor(int exclude_rating)
> +static inline void cpuidle_replace_governor(void)
>  {
>  	struct cpuidle_governor *gov;
> -	struct cpuidle_governor *ret_gov = NULL;
> +	struct cpuidle_governor *new_gov = NULL;
>  	unsigned int max_rating = 0;
>  
>  	list_for_each_entry(gov, &cpuidle_governors, governor_list) {
> -		if (gov->rating == exclude_rating)
> +		if (gov == cpuidle_curr_governor)
>  			continue;
>  		if (gov->rating > max_rating) {
>  			max_rating = gov->rating;
> -			ret_gov = gov;
> +			new_gov = gov;
>  		}
>  	}
>  
> -	return ret_gov;
> +	cpuidle_switch_governor(new_gov);
>  }
>  
>  /**
> @@ -130,11 +131,8 @@ void cpuidle_unregister_governor(struct cpuidle_governor *gov)
>  		return;
>  
>  	mutex_lock(&cpuidle_lock);
> -	if (gov == cpuidle_curr_governor) {
> -		struct cpuidle_governor *new_gov;
> -		new_gov = cpuidle_replace_governor(gov->rating);
> -		cpuidle_switch_governor(new_gov);
> -	}
> +	if (gov == cpuidle_curr_governor)
> +		cpuidle_replace_governor();
>  	list_del(&gov->governor_list);
>  	mutex_unlock(&cpuidle_lock);
>  }
> 


-- 
 <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

