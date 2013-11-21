Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754223Ab3KUM4v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 07:56:51 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:51520 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754091Ab3KUM4t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 07:56:49 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2 Resend] cpuidle: free all state kobjects from cpuidle_free_state_kobj()
Date: Thu, 21 Nov 2013 14:09:29 +0100
Message-ID: <1500472.jI9SKO09jR@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.12.0-rc6+; KDE/4.10.5; x86_64; ; )
In-Reply-To: <8094ec60e0ad37d24ffbf146bc61515bd805c4fe.1385004181.git.viresh.kumar@linaro.org>
References: <8094ec60e0ad37d24ffbf146bc61515bd805c4fe.1385004181.git.viresh.kumar@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, November 21, 2013 08:54:12 AM Viresh Kumar wrote:
> Loop for states is currently present on callers side and so is replicated at
> several places. It would be better to move that inside cpuidle_free_state_kobj()
> instead.
> 
> This patch does it.
> 
> Acked-by: Daniel Lezcano <daniel.lezcano@linaro.org>
> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
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

Well, doesn't the ordering actually matter?  Your patch changes the ordering
here.

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
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
