Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755449Ab3HWKdk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 06:33:40 -0400
Received: from e28smtp08.in.ibm.com ([122.248.162.8]:51953 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755203Ab3HWKdi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 06:33:38 -0400
Message-ID: <52173A56.9040200@linux.vnet.ibm.com>
Date: Fri, 23 Aug 2013 16:02:54 +0530
From: Deepthi Dharwar <deepthi@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Wang Dongsheng-B40534 <B40534@freescale.com>
CC: "benh@kernel.crashing.org" <benh@kernel.crashing.org>,
        "daniel.lezcano@linaro.org" <daniel.lezcano@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Wood Scott-B07421 <B07421@freescale.com>,
        "linux-pm@lists.linux-foundation.org" 
	<linux-pm@lists.linux-foundation.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "michael@ellerman.id.au" <michael@ellerman.id.au>,
        "preeti@linux.vnet.ibm.com" <preeti@linux.vnet.ibm.com>,
        "svaidy@linux.vnet.ibm.com" <svaidy@linux.vnet.ibm.com>
Subject: Re: [PATCH V5 3/5] POWER/cpuidle: Generic IBM-POWER backend cpuidle
 driver.
References: <20130822095323.27416.79369.stgit@deepthi.in.ibm.com> <20130822095357.27416.48110.stgit@deepthi.in.ibm.com> <ABB05CD9C9F68C46A5CEDC7F154392590102822A@039-SN2MPN1-021.039d.mgd.msft.net>
In-Reply-To: <ABB05CD9C9F68C46A5CEDC7F154392590102822A@039-SN2MPN1-021.039d.mgd.msft.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13082310-2000-0000-0000-00000D6E2A99
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/23/2013 08:46 AM, Wang Dongsheng-B40534 wrote:
> 
>> diff --git a/drivers/cpuidle/Kconfig b/drivers/cpuidle/Kconfig
>> index 0e2cd5c..e805dcd 100644
>> --- a/drivers/cpuidle/Kconfig
>> +++ b/drivers/cpuidle/Kconfig
> 
> Maybe drivers/cpuidle/Kconfig.powerpc is better? Like arm.
> 

Yes will do that, going ahead other powerpc archs can use this Kconfig.

>> +obj-$(CONFIG_CPU_IDLE_IBM_POWER) += cpuidle-ibm-power.o
>> diff --git a/drivers/cpuidle/cpuidle-ibm-power.c
>> b/drivers/cpuidle/cpuidle-ibm-power.c
>> new file mode 100644
>> index 0000000..4ee5a94
>> --- /dev/null
>> +++ b/drivers/cpuidle/cpuidle-ibm-power.c
>> @@ -0,0 +1,304 @@
>> +/*
>> + *  cpuidle-ibm-power - idle state cpuidle driver.
>> + *  Adapted from drivers/idle/intel_idle.c and
>> + *  drivers/acpi/processor_idle.c
>> + *
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
>> +#include <asm/paca.h>
>> +#include <asm/reg.h>
>> +#include <asm/machdep.h>
>> +#include <asm/firmware.h>
>> +#include <asm/runlatch.h>
>> +#include <asm/plpar_wrappers.h>
>> +
>> +struct cpuidle_driver power_idle_driver = {
>> +	.name             = "IBM-POWER-Idle",
>> +	.owner            = THIS_MODULE,
>> +};
>> +
>> +#define MAX_IDLE_STATE_COUNT	2
>> +
>> +static int max_idle_state = MAX_IDLE_STATE_COUNT - 1;
> 
> Again, do not use the macro.
> 

Yes, shall use ARRAY_SIZE instead and get away with this macro.
That should work


>> +static struct cpuidle_state *cpuidle_state_table;
>> +
>> +static inline void idle_loop_prolog(unsigned long *in_purr)
>> +{
>> +	*in_purr = mfspr(SPRN_PURR);
>> +	/*
>> +	 * Indicate to the HV that we are idle. Now would be
>> +	 * a good time to find other work to dispatch.
>> +	 */
>> +	get_lppaca()->idle = 1;
>> +}
>> +
>> +static inline void idle_loop_epilog(unsigned long in_purr)
>> +{
>> +	get_lppaca()->wait_state_cycles += mfspr(SPRN_PURR) - in_purr;
>> +	get_lppaca()->idle = 0;
>> +}
>> +
>> +static int snooze_loop(struct cpuidle_device *dev,
>> +			struct cpuidle_driver *drv,
>> +			int index)
>> +{
>> +	unsigned long in_purr;
>> +
>> +	idle_loop_prolog(&in_purr);
>> +	local_irq_enable();
> 
> snooze_loop has already registered in cpuidle framework to handle snooze state.
> where disable the irq? Why do "enable" here?
> 

On POWER, snooze state is an infinte busy looping state. The CPUs keep
looping around lowering their priority until they are interrupted. For
this we need to enable irqs in the snooze loop. There is no way a CPU
can come out this state if the interrupts are not enabled.


>> +/*
>> + * States for dedicated partition case.
>> + */
>> +static struct cpuidle_state dedicated_states[MAX_IDLE_STATE_COUNT] = {
>> +	{ /* Snooze */
>> +		.name = "snooze",
>> +		.desc = "snooze",
>> +		.flags = CPUIDLE_FLAG_TIME_VALID,
>> +		.exit_latency = 0,
>> +		.target_residency = 0,
>> +		.enter = &snooze_loop },
>> +	{ /* CEDE */
>> +		.name = "CEDE",
>> +		.desc = "CEDE",
>> +		.flags = CPUIDLE_FLAG_TIME_VALID,
>> +		.exit_latency = 10,
>> +		.target_residency = 100,
>> +		.enter = &dedicated_cede_loop },
>> +};
>> +
>> +/*
>> + * States for shared partition case.
>> + */
>> +static struct cpuidle_state shared_states[MAX_IDLE_STATE_COUNT] = {
>> +	{ /* Shared Cede */
>> +		.name = "Shared Cede",
>> +		.desc = "Shared Cede",
>> +		.flags = CPUIDLE_FLAG_TIME_VALID,
>> +		.exit_latency = 0,
>> +		.target_residency = 0,
>> +		.enter = &shared_cede_loop },
>> +};
>> +
>> +static void __exit power_processor_idle_exit(void)
>> +{
>> +
>> +	unregister_cpu_notifier(&setup_hotplug_notifier);
> 
> Remove a blank line.
> 
>> +	cpuidle_unregister(&power_idle_driver);
>> +	return;
>> +}
>> +
>> +module_init(power_processor_idle_init);
>> +module_exit(power_processor_idle_exit);
>> +
> 
> Did you have tested the module? If not tested, please don't use the module.
> 
We do want to make it a module. But for now that cannot be done due to
some other dependencies. This feature needs to be built in.

Thanks for the review.


>> +MODULE_AUTHOR("Deepthi Dharwar <deepthi@linux.vnet.ibm.com>");
>> +MODULE_DESCRIPTION("Cpuidle driver for IBM POWER platforms");
>> +MODULE_LICENSE("GPL");
>>
> 
Regards,
Deepthi

