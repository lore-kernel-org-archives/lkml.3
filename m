Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756356Ab3KFVAV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 16:00:21 -0500
Received: from mail-wg0-f42.google.com ([74.125.82.42]:37367 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755984Ab3KFVAU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 16:00:20 -0500
Message-ID: <527AADE0.7050101@linaro.org>
Date: Wed, 06 Nov 2013 22:00:16 +0100
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Deepthi Dharwar <deepthi@linux.vnet.ibm.com>, benh@kernel.crashing.org,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
CC: michael@ellerman.id.au, scottwood@freescale.com,
        srivatsa.bhat@linux.vnet.ibm.com, preeti@linux.vnet.ibm.com,
        linux-pm@lists.linux-foundation.org, svaidy@linux.vnet.ibm.com
Subject: Re: [PATCH V7 2/7] pseries/cpuidle: Use cpuidle_register() for initialisation.
References: <20131029110052.31547.82682.stgit@deepthi.in.ibm.com> <20131029110127.31547.9773.stgit@deepthi.in.ibm.com>
In-Reply-To: <20131029110127.31547.9773.stgit@deepthi.in.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/29/2013 12:01 PM, Deepthi Dharwar wrote:
> This patch replaces the cpuidle driver and devices initialisation
> calls with a single generic cpuidle_register() call
> and also includes minor refactoring of the code around it.
>
> Signed-off-by: Deepthi Dharwar <deepthi@linux.vnet.ibm.com>

Acked-by: Daniel Lezcano <daniel.lezcano@linaro.org>

> ---
>   drivers/cpuidle/cpuidle-ibm-power.c |   80 +++++------------------------------
>   1 file changed, 12 insertions(+), 68 deletions(-)
>
> diff --git a/drivers/cpuidle/cpuidle-ibm-power.c b/drivers/cpuidle/cpuidle-ibm-power.c
> index a166e38..faf8cc1 100644
> --- a/drivers/cpuidle/cpuidle-ibm-power.c
> +++ b/drivers/cpuidle/cpuidle-ibm-power.c
> @@ -1,5 +1,5 @@
>   /*
> - *  processor_idle - idle state cpuidle driver.
> + *  cpuidle-ibm-power - idle state cpuidle driver.
>    *  Adapted from drivers/idle/intel_idle.c and
>    *  drivers/acpi/processor_idle.c
>    *
> @@ -28,7 +28,6 @@ struct cpuidle_driver pseries_idle_driver = {
>   #define MAX_IDLE_STATE_COUNT	2
>
>   static int max_idle_state = MAX_IDLE_STATE_COUNT - 1;
> -static struct cpuidle_device __percpu *pseries_cpuidle_devices;
>   static struct cpuidle_state *cpuidle_state_table;
>
>   static inline void idle_loop_prolog(unsigned long *in_purr)
> @@ -56,13 +55,12 @@ static int snooze_loop(struct cpuidle_device *dev,
>   			int index)
>   {
>   	unsigned long in_purr;
> -	int cpu = dev->cpu;
>
>   	idle_loop_prolog(&in_purr);
>   	local_irq_enable();
>   	set_thread_flag(TIF_POLLING_NRFLAG);
>
> -	while ((!need_resched()) && cpu_online(cpu)) {
> +	while (!need_resched()) {
>   		ppc64_runlatch_off();
>   		HMT_low();
>   		HMT_very_low();
> @@ -191,7 +189,7 @@ static int pseries_cpuidle_add_cpu_notifier(struct notifier_block *n,
>   {
>   	int hotcpu = (unsigned long)hcpu;
>   	struct cpuidle_device *dev =
> -			per_cpu_ptr(pseries_cpuidle_devices, hotcpu);
> +			per_cpu(cpuidle_devices, hotcpu);
>
>   	if (dev && cpuidle_get_driver()) {
>   		switch (action) {
> @@ -248,50 +246,6 @@ static int pseries_cpuidle_driver_init(void)
>   	return 0;
>   }
>
> -/* pseries_idle_devices_uninit(void)
> - * unregister cpuidle devices and de-allocate memory
> - */
> -static void pseries_idle_devices_uninit(void)
> -{
> -	int i;
> -	struct cpuidle_device *dev;
> -
> -	for_each_possible_cpu(i) {
> -		dev = per_cpu_ptr(pseries_cpuidle_devices, i);
> -		cpuidle_unregister_device(dev);
> -	}
> -
> -	free_percpu(pseries_cpuidle_devices);
> -	return;
> -}
> -
> -/* pseries_idle_devices_init()
> - * allocate, initialize and register cpuidle device
> - */
> -static int pseries_idle_devices_init(void)
> -{
> -	int i;
> -	struct cpuidle_driver *drv = &pseries_idle_driver;
> -	struct cpuidle_device *dev;
> -
> -	pseries_cpuidle_devices = alloc_percpu(struct cpuidle_device);
> -	if (pseries_cpuidle_devices == NULL)
> -		return -ENOMEM;
> -
> -	for_each_possible_cpu(i) {
> -		dev = per_cpu_ptr(pseries_cpuidle_devices, i);
> -		dev->state_count = drv->state_count;
> -		dev->cpu = i;
> -		if (cpuidle_register_device(dev)) {
> -			printk(KERN_DEBUG \
> -				"cpuidle_register_device %d failed!\n", i);
> -			return -EIO;
> -		}
> -	}
> -
> -	return 0;
> -}
> -
>   /*
>    * pseries_idle_probe()
>    * Choose state table for shared versus dedicated partition
> @@ -299,9 +253,6 @@ static int pseries_idle_devices_init(void)
>   static int pseries_idle_probe(void)
>   {
>
> -	if (!firmware_has_feature(FW_FEATURE_SPLPAR))
> -		return -ENODEV;
> -
>   	if (cpuidle_disable != IDLE_NO_OVERRIDE)
>   		return -ENODEV;
>
> @@ -310,10 +261,13 @@ static int pseries_idle_probe(void)
>   		return -EPERM;
>   	}
>
> -	if (lppaca_shared_proc(get_lppaca()))
> -		cpuidle_state_table = shared_states;
> -	else
> -		cpuidle_state_table = dedicated_states;
> +	if (firmware_has_feature(FW_FEATURE_SPLPAR)) {
> +		if (lppaca_shared_proc(get_lppaca()))
> +			cpuidle_state_table = shared_states;
> +		else
> +			cpuidle_state_table = dedicated_states;
> +	} else
> +		return -ENODEV;
>
>   	return 0;
>   }
> @@ -327,22 +281,14 @@ static int __init pseries_processor_idle_init(void)
>   		return retval;
>
>   	pseries_cpuidle_driver_init();
> -	retval = cpuidle_register_driver(&pseries_idle_driver);
> +	retval = cpuidle_register(&pseries_idle_driver, NULL);
>   	if (retval) {
>   		printk(KERN_DEBUG "Registration of pseries driver failed.\n");
>   		return retval;
>   	}
>
> -	retval = pseries_idle_devices_init();
> -	if (retval) {
> -		pseries_idle_devices_uninit();
> -		cpuidle_unregister_driver(&pseries_idle_driver);
> -		return retval;
> -	}
> -
>   	register_cpu_notifier(&setup_hotplug_notifier);
>   	printk(KERN_DEBUG "pseries_idle_driver registered\n");
> -
>   	return 0;
>   }
>
> @@ -350,9 +296,7 @@ static void __exit pseries_processor_idle_exit(void)
>   {
>
>   	unregister_cpu_notifier(&setup_hotplug_notifier);
> -	pseries_idle_devices_uninit();
> -	cpuidle_unregister_driver(&pseries_idle_driver);
> -
> +	cpuidle_unregister(&pseries_idle_driver);
>   	return;
>   }
>
>


-- 
  <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

