Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755168Ab3IYWJb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 18:09:31 -0400
Received: from mail-we0-f173.google.com ([74.125.82.173]:64235 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752355Ab3IYWJ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 18:09:29 -0400
Message-ID: <52435F16.5080806@linaro.org>
Date: Thu, 26 Sep 2013 00:09:26 +0200
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Viresh Kumar <viresh.kumar@linaro.org>, rjw@sisk.pl
CC: linaro-kernel@lists.linaro.org, patches@linaro.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 15/21] cpuidle: free all state kobjects from cpuidle_free_state_kobj()
References: <cover.1379779777.git.viresh.kumar@linaro.org> <503b7472308007b4c233b33d19f5a54c138212e7.1379779777.git.viresh.kumar@linaro.org>
In-Reply-To: <503b7472308007b4c233b33d19f5a54c138212e7.1379779777.git.viresh.kumar@linaro.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/22/2013 03:21 AM, Viresh Kumar wrote:
> Loop for states is currently present on callers side and so is replicated at
> several places. It would be better to move that inside cpuidle_free_state_kobj()
> instead.
> 
> This patch does it.
> 
> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>

Acked-by: Daniel Lezcano <daniel.lezcano@linaro.org>

> ---
>  drivers/cpuidle/sysfs.c | 23 ++++++++++++-----------
>  1 file changed, 12 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/cpuidle/sysfs.c b/drivers/cpuidle/sysfs.c
> index e918b6d..ade31a9 100644
> --- a/drivers/cpuidle/sysfs.c
> +++ b/drivers/cpuidle/sysfs.c
> @@ -378,12 +378,17 @@ static struct kobj_type ktype_state_cpuidle = {
>  	.release = cpuidle_state_sysfs_release,
>  };
>  
> -static inline void cpuidle_free_state_kobj(struct cpuidle_device *device, int i)
> +static inline void cpuidle_free_state_kobj(struct cpuidle_device *device,
> +		int count)
>  {
> -	kobject_put(&device->kobjs[i]->kobj);
> -	wait_for_completion(&device->kobjs[i]->kobj_unregister);
> -	kfree(device->kobjs[i]);
> -	device->kobjs[i] = NULL;
> +	int i;
> +
> +	for (i = 0; i < count; i++) {
> +		kobject_put(&device->kobjs[i]->kobj);
> +		wait_for_completion(&device->kobjs[i]->kobj_unregister);
> +		kfree(device->kobjs[i]);
> +		device->kobjs[i] = NULL;
> +	}
>  }
>  
>  /**
> @@ -419,8 +424,7 @@ static int cpuidle_add_state_sysfs(struct cpuidle_device *device)
>  	return 0;
>  
>  error_state:
> -	for (i = i - 1; i >= 0; i--)
> -		cpuidle_free_state_kobj(device, i);
> +	cpuidle_free_state_kobj(device, i);
>  	return ret;
>  }
>  
> @@ -430,10 +434,7 @@ error_state:
>   */
>  static void cpuidle_remove_state_sysfs(struct cpuidle_device *device)
>  {
> -	int i;
> -
> -	for (i = 0; i < device->state_count; i++)
> -		cpuidle_free_state_kobj(device, i);
> +	cpuidle_free_state_kobj(device, device->state_count);
>  }
>  
>  #ifdef CONFIG_CPU_IDLE_MULTIPLE_DRIVERS
> 


-- 
 <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

