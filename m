Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932176Ab3KFVFj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 16:05:39 -0500
Received: from mail-wi0-f172.google.com ([209.85.212.172]:45609 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932081Ab3KFVFg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 16:05:36 -0500
Message-ID: <527AAF1D.5080605@linaro.org>
Date: Wed, 06 Nov 2013 22:05:33 +0100
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Deepthi Dharwar <deepthi@linux.vnet.ibm.com>, benh@kernel.crashing.org,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
CC: michael@ellerman.id.au, scottwood@freescale.com,
        srivatsa.bhat@linux.vnet.ibm.com, preeti@linux.vnet.ibm.com,
        linux-pm@lists.linux-foundation.org, svaidy@linux.vnet.ibm.com
Subject: Re: [PATCH V7 5/7] POWER/cpuidle: Generic POWER CPUIDLE driver supporting
 PSERIES.
References: <20131029110052.31547.82682.stgit@deepthi.in.ibm.com> <20131029110148.31547.8944.stgit@deepthi.in.ibm.com>
In-Reply-To: <20131029110148.31547.8944.stgit@deepthi.in.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/29/2013 12:01 PM, Deepthi Dharwar wrote:
> This patch includes cleanup and refactoring of the
> existing code to make the driver POWER generic.
> * Re-naming the functions from pseries to generic power.
> * Re-naming the backend driver from pseries_idle to
>    ibm-power-idle.
>
> Signed-off-by: Deepthi Dharwar <deepthi@linux.vnet.ibm.com>

Acked-by: Daniel Lezcano <daniel.lezcano@linaro.org>

... but I am wondering if 'power' name is not confusing with power 
management and if 'powerpc' would suit better.

> ---
>   drivers/cpuidle/cpuidle-ibm-power.c |   32 ++++++++++++++++----------------
>   1 file changed, 16 insertions(+), 16 deletions(-)
>
> diff --git a/drivers/cpuidle/cpuidle-ibm-power.c b/drivers/cpuidle/cpuidle-ibm-power.c
> index e81c207..5b92242 100644
> --- a/drivers/cpuidle/cpuidle-ibm-power.c
> +++ b/drivers/cpuidle/cpuidle-ibm-power.c
> @@ -20,8 +20,8 @@
>   #include <asm/runlatch.h>
>   #include <asm/plpar_wrappers.h>
>
> -struct cpuidle_driver pseries_idle_driver = {
> -	.name             = "pseries_idle",
> +struct cpuidle_driver power_idle_driver = {
> +	.name             = "ibm_power_idle",
>   	.owner            = THIS_MODULE,
>   };
>
> @@ -182,7 +182,7 @@ void update_smt_snooze_delay(int cpu, int residency)
>   			drv->states[1].target_residency = residency;
>   }
>
> -static int pseries_cpuidle_add_cpu_notifier(struct notifier_block *n,
> +static int power_cpuidle_add_cpu_notifier(struct notifier_block *n,
>   			unsigned long action, void *hcpu)
>   {
>   	int hotcpu = (unsigned long)hcpu;
> @@ -213,16 +213,16 @@ static int pseries_cpuidle_add_cpu_notifier(struct notifier_block *n,
>   }
>
>   static struct notifier_block setup_hotplug_notifier = {
> -	.notifier_call = pseries_cpuidle_add_cpu_notifier,
> +	.notifier_call = power_cpuidle_add_cpu_notifier,
>   };
>
>   /*
> - * pseries_cpuidle_driver_init()
> + * power_cpuidle_driver_init()
>    */
> -static int pseries_cpuidle_driver_init(void)
> +static int power_cpuidle_driver_init(void)
>   {
>   	int idle_state;
> -	struct cpuidle_driver *drv = &pseries_idle_driver;
> +	struct cpuidle_driver *drv = &power_idle_driver;
>
>   	drv->state_count = 0;
>   	for (idle_state = 0; idle_state < max_idle_state; ++idle_state) {
> @@ -241,10 +241,10 @@ static int pseries_cpuidle_driver_init(void)
>   }
>
>   /*
> - * pseries_idle_probe()
> + * power_idle_probe()
>    * Choose state table for shared versus dedicated partition
>    */
> -static int pseries_idle_probe(void)
> +static int power_idle_probe(void)
>   {
>
>   	if (cpuidle_disable != IDLE_NO_OVERRIDE)
> @@ -264,24 +264,24 @@ static int pseries_idle_probe(void)
>   	return 0;
>   }
>
> -static int __init pseries_processor_idle_init(void)
> +static int __init power_processor_idle_init(void)
>   {
>   	int retval;
>
> -	retval = pseries_idle_probe();
> +	retval = power_idle_probe();
>   	if (retval)
>   		return retval;
>
> -	pseries_cpuidle_driver_init();
> -	retval = cpuidle_register(&pseries_idle_driver, NULL);
> +	power_cpuidle_driver_init();
> +	retval = cpuidle_register(&power_idle_driver, NULL);
>   	if (retval) {
> -		printk(KERN_DEBUG "Registration of pseries driver failed.\n");
> +		printk(KERN_DEBUG "Registration of ibm_power_idle driver failed.\n");
>   		return retval;
>   	}
>
>   	register_cpu_notifier(&setup_hotplug_notifier);
> -	printk(KERN_DEBUG "pseries_idle_driver registered\n");
> +	printk(KERN_DEBUG "ibm_power_idle registered\n");
>   	return 0;
>   }
>
> -device_initcall(pseries_processor_idle_init);
> +device_initcall(power_processor_idle_init);
>


-- 
  <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

