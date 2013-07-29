Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756786Ab3G2OmU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 10:42:20 -0400
Received: from e23smtp05.au.ibm.com ([202.81.31.147]:58047 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751558Ab3G2OmS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 10:42:18 -0400
Message-ID: <51F67E96.6040008@linux.vnet.ibm.com>
Date: Mon, 29 Jul 2013 20:09:18 +0530
From: Deepthi Dharwar <deepthi@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130219 Thunderbird/17.0.3
MIME-Version: 1.0
To: Daniel Lezcano <daniel.lezcano@linaro.org>
CC: linuxppc-dev@lists.ozlabs.org, linux-pm@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [linux-pm] [PATCH 1/3] cpuidle/powernv: cpuidle backend driver
 for powernv
References: <20130723090111.7291.99479.stgit@deepthi.in.ibm.com> <20130723090137.7291.36657.stgit@deepthi.in.ibm.com> <51F35A2A.1080408@linaro.org>
In-Reply-To: <51F35A2A.1080408@linaro.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13072914-1396-0000-0000-00000354DA6F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Daniel,

On 07/27/2013 10:57 AM, Daniel Lezcano wrote:
> On 07/23/2013 11:01 AM, Deepthi Dharwar wrote:
>> This patch implements a back-end cpuidle driver for
>> powernv calling power7_nap and snooze idle states.
>> This can be extended by adding more idle states
>> in the future to the existing framework.
>>
>> Signed-off-by: Deepthi Dharwar <deepthi@linux.vnet.ibm.com>
>> ---
>>  arch/powerpc/platforms/powernv/Kconfig          |    9 +
>>  arch/powerpc/platforms/powernv/Makefile         |    1 
>>  arch/powerpc/platforms/powernv/processor_idle.c |  239 +++++++++++++++++++++++
>>  3 files changed, 249 insertions(+)
>>  create mode 100644 arch/powerpc/platforms/powernv/processor_idle.c
>>
>> diff --git a/arch/powerpc/platforms/powernv/Kconfig b/arch/powerpc/platforms/powernv/Kconfig
>> index c24684c..ace2d22 100644
>> --- a/arch/powerpc/platforms/powernv/Kconfig
>> +++ b/arch/powerpc/platforms/powernv/Kconfig
>> @@ -20,3 +20,12 @@ config PPC_POWERNV_RTAS
>>  	default y
>>  	select PPC_ICS_RTAS
>>  	select PPC_RTAS
>> +
>> +config POWERNV_IDLE
>> +	bool "CPUIdle driver for powernv platform"
>> +	depends on CPU_IDLE
>> +	depends on PPC_POWERNV
>> +	default y
>> +	help
>> +	Select this option to enable processor idle state management
>> +	through cpuidle subsystem.
>> diff --git a/arch/powerpc/platforms/powernv/Makefile b/arch/powerpc/platforms/powernv/Makefile
>> index 7fe5951..c0e44eb 100644
>> --- a/arch/powerpc/platforms/powernv/Makefile
>> +++ b/arch/powerpc/platforms/powernv/Makefile
>> @@ -4,3 +4,4 @@ obj-y			+= opal-rtc.o opal-nvram.o
>>  obj-$(CONFIG_SMP)	+= smp.o
>>  obj-$(CONFIG_PCI)	+= pci.o pci-p5ioc2.o pci-ioda.o
>>  obj-$(CONFIG_EEH)	+= eeh-ioda.o eeh-powernv.o
>> +obj-$(CONFIG_POWERNV_IDLE)     += processor_idle.o
>> diff --git a/arch/powerpc/platforms/powernv/processor_idle.c b/arch/powerpc/platforms/powernv/processor_idle.c
>> new file mode 100644
>> index 0000000..f43ad91a
>> --- /dev/null
>> +++ b/arch/powerpc/platforms/powernv/processor_idle.c
>> @@ -0,0 +1,239 @@
>> +/*
>> + *  processor_idle - idle state cpuidle driver.
>> + */
>> +
>> +#include <linux/kernel.h>
>> +#include <linux/module.h>
>> +#include <linux/init.h>
>> +#include <linux/moduleparam.h>
>> +#include <linux/cpuidle.h>
>> +#include <linux/cpu.h>
>> +#include <linux/notifier.h>
>> +
>> +#include <asm/machdep.h>
>> +#include <asm/runlatch.h>
>> +
>> +struct cpuidle_driver powernv_idle_driver = {
>> +	.name =		"powernv_idle",
>> +	.owner =	THIS_MODULE,
>> +};
>> +
>> +#define MAX_IDLE_STATE_COUNT	2
>> +
>> +static int max_idle_state = MAX_IDLE_STATE_COUNT - 1;
>> +static struct cpuidle_device __percpu *powernv_cpuidle_devices;
>> +static struct cpuidle_state *cpuidle_state_table;
>> +
>> +static int snooze_loop(struct cpuidle_device *dev,
>> +			struct cpuidle_driver *drv,
>> +			int index)
>> +{
>> +	int cpu = dev->cpu;
>> +
>> +	local_irq_enable();
>> +	set_thread_flag(TIF_POLLING_NRFLAG);
>> +
>> +	while ((!need_resched()) && cpu_online(cpu)) {
>> +		ppc64_runlatch_off();
>> +		HMT_very_low();
>> +	}
> 
> Why are you using the cpu_online test here ?

Snooze state is an idle state where cpu executes an infinite loop by
reducing the priority of the thread and the idle cpu can come out of it
only if need_resched is set or in case the cpu is offlined. In order to
continue executing this loop to remain in this idle state, we need the
check just to be safe.

>> +
>> +	HMT_medium();
>> +	clear_thread_flag(TIF_POLLING_NRFLAG);
>> +	smp_mb();
>> +	return index;
>> +}
>> +
>> +
>> +static int nap_loop(struct cpuidle_device *dev,
>> +				struct cpuidle_driver *drv,
>> +				int index)
>> +{
>> +	ppc64_runlatch_off();
>> +	power7_idle();
>> +	return index;
>> +}
>> +
>> +/*
>> + * States for dedicated partition case.
>> + */
>> +static struct cpuidle_state powernv_states[MAX_IDLE_STATE_COUNT] = {
>> +	{ /* Snooze */
>> +		.name = "snooze",
>> +		.desc = "snooze",
>> +		.flags = CPUIDLE_FLAG_TIME_VALID,
>> +		.exit_latency = 0,
>> +		.target_residency = 0,
>> +		.enter = &snooze_loop },
>> +	 { /* Nap */
>> +		.name = "Nap",
>> +		.desc = "Nap",
>> +		.flags = CPUIDLE_FLAG_TIME_VALID,
>> +		.exit_latency = 10,
>> +		.target_residency = 100,
>> +		.enter = &nap_loop },
>> +};
>> +
>> +static int powernv_cpuidle_add_cpu_notifier(struct notifier_block *n,
>> +			unsigned long action, void *hcpu)
>> +{
>> +	int hotcpu = (unsigned long)hcpu;
>> +	struct cpuidle_device *dev =
>> +			per_cpu_ptr(powernv_cpuidle_devices, hotcpu);
>> +
>> +	if (dev && cpuidle_get_driver()) {
>> +		switch (action) {
>> +		case CPU_ONLINE:
>> +		case CPU_ONLINE_FROZEN:
>> +			cpuidle_pause_and_lock();
>> +			cpuidle_enable_device(dev);
>> +			cpuidle_resume_and_unlock();
>> +			break;
>> +
>> +		case CPU_DEAD:
>> +		case CPU_DEAD_FROZEN:
>> +			cpuidle_pause_and_lock();
>> +			cpuidle_disable_device(dev);
>> +			cpuidle_resume_and_unlock();
>> +			break;
>> +
>> +		default:
>> +			return NOTIFY_DONE;
>> +		}
>> +	}
>> +	return NOTIFY_OK;
>> +}
>> +
>> +static struct notifier_block setup_hotplug_notifier = {
>> +	.notifier_call = powernv_cpuidle_add_cpu_notifier,
>> +};
> 
> This is duplicated code with the pseries cpuidle driver and IMHO it
> should be moved to the cpuidle framework.

Yes, a lot of code here is there in pseries cpuidle driver. I am
re-factoring that aspect so that we can use one back-end driver for both
pseries and powernv. I will post it out soon.

Moving the hotplug handler to cpuidle can be done as a separate feature.
This needs change in all the other archs that use cpuidle and  change in
the framework itself.

> 
>> +/*
>> + * powernv_cpuidle_driver_init()
>> + */
>> +static int powernv_cpuidle_driver_init(void)
>> +{
>> +	int idle_state;
>> +	struct cpuidle_driver *drv = &powernv_idle_driver;
>> +
>> +	drv->state_count = 0;
>> +
>> +	for (idle_state = 0; idle_state < MAX_IDLE_STATE_COUNT; ++idle_state) {
>> +
>> +		if (idle_state > max_idle_state)
>> +			break;
>> +
>> +		/* is the state not enabled? */
>> +		if (cpuidle_state_table[idle_state].enter == NULL)
>> +			continue;
>> +
>> +		drv->states[drv->state_count] =	/* structure copy */
>> +			cpuidle_state_table[idle_state];
>> +
>> +		drv->state_count += 1;
>> +	}
>> +
>> +	return 0;
>> +}
> 
> 
> Instead of doing struct copy, why don't you use the state's 'disable'
> field of the driver and then enable the state in the routine ?

Going forward, having a single driver for powernv and pseries, I would
like to have two separate cpuidle state table for each arch. And both
would have their idle states and corresponding routines. Combining
different arch idle routines into one table and enabling/disabling them
would be quite confusing.

> 
>> +/* powernv_idle_devices_uninit(void)
>> + * unregister cpuidle devices and de-allocate memory
>> + */
>> +static void powernv_idle_devices_uninit(void)
>> +{
>> +	int i;
>> +	struct cpuidle_device *dev;
>> +
>> +	for_each_possible_cpu(i) {
>> +		dev = per_cpu_ptr(powernv_cpuidle_devices, i);
>> +		cpuidle_unregister_device(dev);
>> +	}
>> +
>> +	free_percpu(powernv_cpuidle_devices);
>> +	return;
>> +}
>> +
>> +/* powernv_idle_devices_init()
>> + * allocate, initialize and register cpuidle device
>> + */
>> +static int powernv_idle_devices_init(void)
>> +{
>> +	int i;
>> +	struct cpuidle_driver *drv = &powernv_idle_driver;
>> +	struct cpuidle_device *dev;
>> +
>> +	powernv_cpuidle_devices = alloc_percpu(struct cpuidle_device);
>> +	if (powernv_cpuidle_devices == NULL)
>> +		return -ENOMEM;
>> +
>> +	for_each_possible_cpu(i) {
>> +		dev = per_cpu_ptr(powernv_cpuidle_devices, i);
>> +		dev->state_count = drv->state_count;
>> +		dev->cpu = i;
>> +		if (cpuidle_register_device(dev)) {
>> +			printk(KERN_DEBUG \
>> +				"cpuidle_register_device %d failed!\n", i);
>> +			return -EIO;
>> +		}
>> +	}
>> +	return 0;
> 
> 
> There is now the cpuidle_register(struct cpuidle_driver *, cpumask *);
> 
> You can get rid of the cpuidle_device struct and this init routine.

Thanks for the pointer. I will look into this.


>> +}
>> +
>> +/*
>> + * powernv_idle_probe()
>> + * Choose state table for shared versus dedicated partition
>> + */
>> +static int powernv_idle_probe(void)
>> +{
>> +
>> +	if (cpuidle_disable != IDLE_NO_OVERRIDE)
>> +		return -ENODEV;
>> +
>> +	cpuidle_state_table = powernv_states;
>> +	return 0;
>> +}
>> +
>> +static int __init powernv_processor_idle_init(void)
>> +{
>> +	int retval;
>> +
>> +	retval = powernv_idle_probe();
>> +	if (retval)
>> +		return retval;
>> +
>> +	powernv_cpuidle_driver_init();
>> +	retval = cpuidle_register_driver(&powernv_idle_driver);
>> +	if (retval) {
>> +		printk(KERN_DEBUG "Registration of powernv driver failed.\n");
>> +		return retval;
>> +	}
>> +
>> +	retval = powernv_idle_devices_init();
>> +	if (retval) {
>> +		powernv_idle_devices_uninit();
>> +		cpuidle_unregister_driver(&powernv_idle_driver);
>> +		return retval;
>> +	}
>> +
>> +	register_cpu_notifier(&setup_hotplug_notifier);
>> +	printk(KERN_DEBUG "powernv_idle_driver registered\n");
>> +
>> +	return 0;
>> +}
>> +
>> +static void __exit powernv_processor_idle_exit(void)
>> +{
>> +
>> +	unregister_cpu_notifier(&setup_hotplug_notifier);
>> +	powernv_idle_devices_uninit();
>> +	cpuidle_unregister_driver(&powernv_idle_driver);
>> +
>> +	return;
>> +}
>> +
>> +module_init(powernv_processor_idle_init);
>> +module_exit(powernv_processor_idle_exit);
>> +
>> +MODULE_AUTHOR("Deepthi Dharwar <deepthi@linux.vnet.ibm.com>");
>> +MODULE_DESCRIPTION("Cpuidle driver for POWERNV");
>> +MODULE_LICENSE("GPL");
>>
> 
> 
Thanks a lot for your time and review.

Regards,
Deepthi

