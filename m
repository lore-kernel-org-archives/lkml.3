Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753238Ab3HBKfW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 06:35:22 -0400
Received: from e28smtp02.in.ibm.com ([122.248.162.2]:35723 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752370Ab3HBKfT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 06:35:19 -0400
Message-ID: <51FB8AD0.6080606@linux.vnet.ibm.com>
Date: Fri, 02 Aug 2013 16:02:48 +0530
From: Preeti U Murthy <preeti@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Daniel Lezcano <daniel.lezcano@linaro.org>
CC: Deepthi Dharwar <deepthi@linux.vnet.ibm.com>,
        linux-pm@lists.linux-foundation.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Subject: Re: [linux-pm] [PATCH 1/3] cpuidle/powernv: cpuidle backend driver
 for powernv
References: <20130723090111.7291.99479.stgit@deepthi.in.ibm.com> <20130723090137.7291.36657.stgit@deepthi.in.ibm.com> <51F35A2A.1080408@linaro.org>
In-Reply-To: <51F35A2A.1080408@linaro.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13080210-5816-0000-0000-0000093B9C43
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
> 
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
> 

Will this not require a cleanup of the hotplug cpuidle notifiers from
other architectures into the cpuidle framework as well?

Regards
Preeti U Murthy

