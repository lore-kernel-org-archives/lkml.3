Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754720Ab3IYWGp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 18:06:45 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:43732 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751283Ab3IYWGn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 18:06:43 -0400
Message-ID: <52435E6F.4000002@linaro.org>
Date: Thu, 26 Sep 2013 00:06:39 +0200
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Viresh Kumar <viresh.kumar@linaro.org>, rjw@sisk.pl
CC: linaro-kernel@lists.linaro.org, patches@linaro.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Colin Cross <ccross@google.com>
Subject: Re: [PATCH 14/21] cpuidle: coupled: don't compare cpu masks unnecessarily
References: <cover.1379779777.git.viresh.kumar@linaro.org> <564c8b1f073dc396b54866a2220b09b7869289f4.1379779777.git.viresh.kumar@linaro.org>
In-Reply-To: <564c8b1f073dc396b54866a2220b09b7869289f4.1379779777.git.viresh.kumar@linaro.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/22/2013 03:21 AM, Viresh Kumar wrote:
> In cpuidle_coupled_register_device() we do following:
> 	if (WARN_ON(!cpumask_equal(&dev->coupled_cpus, &coupled->coupled_cpus)))
> 		coupled->prevent++;
> 
> This is only required to be done when we are using 'coupled' from an existing
> cpuidle_device and not when we have just done this:
> 
> 	coupled->coupled_cpus = dev->coupled_cpus
> 
> So, move this compare statement to the right place.
> 
> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>

Cc'ed Colin Cross.

> ---
>  drivers/cpuidle/coupled.c | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/cpuidle/coupled.c b/drivers/cpuidle/coupled.c
> index e952936..19a89eb 100644
> --- a/drivers/cpuidle/coupled.c
> +++ b/drivers/cpuidle/coupled.c
> @@ -642,6 +642,10 @@ int cpuidle_coupled_register_device(struct cpuidle_device *dev)
>  		other_dev = per_cpu(cpuidle_devices, cpu);
>  		if (other_dev && other_dev->coupled) {
>  			coupled = other_dev->coupled;
> +
> +			if (WARN_ON(!cpumask_equal(&dev->coupled_cpus,
> +						&coupled->coupled_cpus)))
> +				coupled->prevent++;
>  			goto have_coupled;
>  		}
>  	}
> @@ -655,9 +659,6 @@ int cpuidle_coupled_register_device(struct cpuidle_device *dev)
>  
>  have_coupled:
>  	dev->coupled = coupled;
> -	if (WARN_ON(!cpumask_equal(&dev->coupled_cpus, &coupled->coupled_cpus)))
> -		coupled->prevent++;
> -
>  	cpuidle_coupled_update_online_cpus(coupled);
>  
>  	coupled->refcnt++;
> 


-- 
 <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

