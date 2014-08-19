Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753041AbaHSHi0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 03:38:26 -0400
Received: from mail-pa0-f49.google.com ([209.85.220.49]:47848 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752693AbaHSHiY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 03:38:24 -0400
Message-ID: <53F2FE8E.60307@linaro.org>
Date: Tue, 19 Aug 2014 15:36:46 +0800
From: Hanjun Guo <hanjun.guo@linaro.org>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Catalin Marinas <catalin.marinas@arm.com>
CC: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Mark Rutland <Mark.Rutland@arm.com>,
        "graeme.gregory@linaro.org" <graeme.gregory@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        Sudeep Holla <Sudeep.Holla@arm.com>, Will Deacon <Will.Deacon@arm.com>,
        Jason Cooper <jason@lakedaemon.net>,
        Marc Zyngier <Marc.Zyngier@arm.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Mark Brown <broonie@kernel.org>, Rob Herring <robh@kernel.org>,
        Robert Richter <rric@kernel.org>, Lv Zheng <lv.zheng@intel.com>,
        Robert Moore <robert.moore@intel.com>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Liviu Dudau <Liviu.Dudau@arm.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Charles Garcia-Tobin <Charles.Garcia-Tobin@arm.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linaro-acpi@lists.linaro.org" <linaro-acpi@lists.linaro.org>,
        Tomasz Nowicki <tomasz.nowicki@linaro.org>
Subject: Re: [PATCH v2 06/18] ARM64 / ACPI: Parse MADT to map logical cpu
 to MPIDR and get cpu_possible/present_map
References: <1407166105-17675-1-git-send-email-hanjun.guo@linaro.org> <1407166105-17675-7-git-send-email-hanjun.guo@linaro.org> <20140818142728.GS20043@localhost>
In-Reply-To: <20140818142728.GS20043@localhost>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-8-18 22:27, Catalin Marinas wrote:
> On Mon, Aug 04, 2014 at 04:28:13PM +0100, Hanjun Guo wrote:
>> diff --git a/arch/arm64/include/asm/acpi.h b/arch/arm64/include/asm/acpi.h
>> index 6e04868..e877967 100644
>> --- a/arch/arm64/include/asm/acpi.h
>> +++ b/arch/arm64/include/asm/acpi.h
>> @@ -64,6 +64,8 @@ static inline void arch_fix_phys_package_id(int num, u32 slot) { }
>>  extern int (*acpi_suspend_lowlevel)(void);
>>  #define acpi_wakeup_address 0
>>  
>> +#define MAX_GIC_CPU_INTERFACE 65535
> 
> Does this need to be more than NR_CPUS?

Sometimes yes, CPU structure entries in MADT just like CPU nodes in
device tree, the number of them may more than NR_CPUS.

> 
>> +/**
>> + * acpi_register_gic_cpu_interface - register a gic cpu interface and
>> + * generates a logical cpu number
>> + * @mpidr: CPU's hardware id to register, MPIDR represented in MADT
>> + * @enabled: this cpu is enabled or not
>> + *
>> + * Returns the logical cpu number which maps to the gic cpu interface
>> + */
>> +static int acpi_register_gic_cpu_interface(u64 mpidr, u8 enabled)
>> +{
>> +	int cpu;
>> +
>> +	if (mpidr == INVALID_HWID) {
>> +		pr_info("Skip invalid cpu hardware ID\n");
>> +		return -EINVAL;
>> +	}
>> +
>> +	total_cpus++;
>> +	if (!enabled)
>> +		return -EINVAL;
>> +
>> +	if (enabled_cpus >=  NR_CPUS) {
>> +		pr_warn("NR_CPUS limit of %d reached, Processor %d/0x%llx ignored.\n",
>> +			NR_CPUS, total_cpus, mpidr);
>> +		return -EINVAL;
>> +	}
>> +
>> +	/* If it is the first CPU, no need to check duplicate MPIDRs */
>> +	if (!enabled_cpus)
>> +		goto skip_mpidr_check;
>> +
>> +	/*
>> +	 * Duplicate MPIDRs are a recipe for disaster. Scan
>> +	 * all initialized entries and check for
>> +	 * duplicates. If any is found just ignore the CPU.
>> +	 */
>> +	for_each_present_cpu(cpu) {
>> +		if (cpu_logical_map(cpu) == mpidr) {
>> +			pr_err("Firmware bug, duplicate CPU MPIDR: 0x%llx in MADT\n",
>> +			       mpidr);
>> +			return -EINVAL;
>> +		}
>> +	}
>> +
>> +skip_mpidr_check:
>> +	enabled_cpus++;
>> +
>> +	/* allocate a logical cpu id for the new comer */
>> +	if (cpu_logical_map(0) == mpidr) {
>> +		/*
>> +		 * boot_cpu_init() already hold bit 0 in cpu_present_mask
>> +		 * for BSP, no need to allocate again.
>> +		 */
>> +		cpu = 0;
>> +	} else {
>> +		cpu = cpumask_next_zero(-1, cpu_present_mask);
>> +	}
>> +
>> +	/* map the logical cpu id to cpu MPIDR */
>> +	cpu_logical_map(cpu) = mpidr;
>> +
>> +	set_cpu_possible(cpu, true);
>> +	set_cpu_present(cpu, true);
>> +
>> +	return cpu;
>> +}
> 
> Why not only set the cpu possible here (with the additional mpidr
> validity checks changed to for_each_possible_cpu)...
> 
>> diff --git a/arch/arm64/kernel/smp.c b/arch/arm64/kernel/smp.c
>> index 40f38f4..8f1d37c 100644
>> --- a/arch/arm64/kernel/smp.c
>> +++ b/arch/arm64/kernel/smp.c
>> @@ -36,6 +36,7 @@
>>  #include <linux/completion.h>
>>  #include <linux/of.h>
>>  #include <linux/irq_work.h>
>> +#include <linux/acpi.h>
>>  
>>  #include <asm/atomic.h>
>>  #include <asm/cacheflush.h>
>> @@ -458,7 +459,14 @@ void __init smp_prepare_cpus(unsigned int max_cpus)
>>  		if (err)
>>  			continue;
>>  
>> -		set_cpu_present(cpu, true);
>> +		/*
>> +		 * In ACPI mode, cpu_present_map was initialised when
>> +		 * MADT table was parsed which before this function
>> +		 * is called.
>> +		 */
>> +		if (acpi_disabled)
>> +			set_cpu_present(cpu, true);
>> +
>>  		max_cpus--;
> 
> ... and don't touch this at all.

the original intent was to support CPU hotplug, I will update the patch
as you suggested and introduce the change when CPU hotplug patch is upstreamed,
then it will make the patch less confusing.

Thanks
Hanjun

