Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752923AbaAXO5p (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jan 2014 09:57:45 -0500
Received: from mail-pd0-f174.google.com ([209.85.192.174]:57881 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752682AbaAXO5n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jan 2014 09:57:43 -0500
Message-ID: <52E27F5D.6070302@linaro.org>
Date: Fri, 24 Jan 2014 22:57:33 +0800
From: Hanjun Guo <hanjun.guo@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Catalin Marinas <catalin.marinas@arm.com>
CC: "Rafael J. Wysocki" <rjw@rjwysocki.net>, Will Deacon <Will.Deacon@arm.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>, Olof Johansson <olof@lixom.net>,
        Linus Walleij <linus.walleij@linaro.org>,
        Bjorn Helgaas <bhelgaas@google.com>, Rob Herring <robh@kernel.org>,
        Mark Rutland <Mark.Rutland@arm.com>, Arnd Bergmann <arnd@arndb.de>,
        "patches@linaro.org" <patches@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "linaro-acpi@lists.linaro.org" <linaro-acpi@lists.linaro.org>,
        Charles Garcia-Tobin <Charles.Garcia-Tobin@arm.com>
Subject: Re: [PATCH 11/20] ARM64 / ACPI: Get the enable method for SMP initialization
References: <1389961514-13562-1-git-send-email-hanjun.guo@linaro.org> <1389961514-13562-12-git-send-email-hanjun.guo@linaro.org> <20140123175031.GJ27520@arm.com>
In-Reply-To: <20140123175031.GJ27520@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Catalin,

On 2014年01月24日 01:50, Catalin Marinas wrote:
> On Fri, Jan 17, 2014 at 12:25:05PM +0000, Hanjun Guo wrote:
>> --- a/arch/arm64/kernel/smp.c
>> +++ b/arch/arm64/kernel/smp.c
>> @@ -48,6 +48,7 @@
>>   #include <asm/sections.h>
>>   #include <asm/tlbflush.h>
>>   #include <asm/ptrace.h>
>> +#include <asm/acpi.h>
>>   
>>   /*
>>    * as from 2.5, kernels no longer have an init_tasks structure
>> @@ -280,7 +281,7 @@ static void (*smp_cross_call)(const struct cpumask *, unsigned int);
>>    * cpu logical map array containing MPIDR values related to logical
>>    * cpus. Assumes that cpu_logical_map(0) has already been initialized.
>>    */
>> -void __init smp_init_cpus(void)
>> +static int __init of_smp_init_cpus(void)
>>   {
>>   	struct device_node *dn = NULL;
>>   	unsigned int i, cpu = 1;
>> @@ -364,6 +365,10 @@ next:
>>   		cpu++;
>>   	}
>>   
>> +	/* No device tree or no CPU node in DT */
>> +	if (cpu == 1 && !bootcpu_valid)
>> +		return -ENODEV;
>> +
>>   	/* sanity check */
>>   	if (cpu > NR_CPUS)
>>   		pr_warning("no. of cores (%d) greater than configured maximum of %d - clipping\n",
>> @@ -371,7 +376,7 @@ next:
>>   
>>   	if (!bootcpu_valid) {
>>   		pr_err("DT missing boot CPU MPIDR, not enabling secondaries\n");
>> -		return;
>> +		return -EINVAL;
>>   	}
>>   
>>   	/*
>> @@ -381,6 +386,39 @@ next:
>>   	for (i = 0; i < NR_CPUS; i++)
>>   		if (cpu_logical_map(i) != INVALID_HWID)
>>   			set_cpu_possible(i, true);
>> +
>> +	return 0;
>> +}
>> +
>> +/*
>> + * In ACPI mode, the cpu possible map was enumerated before SMP
>> + * initialization when MADT table was parsed, so we can get the
>> + * possible map here to initialize CPUs.
>> + */
>> +static void __init acpi_smp_init_cpus(void)
>> +{
>> +	int cpu;
>> +	const char *enable_method;
>> +
>> +	for_each_possible_cpu(cpu) {
>> +		enable_method = acpi_get_enable_method(cpu);
>> +		if (!enable_method)
>> +			continue;
>> +
>> +		cpu_ops[cpu] = cpu_get_ops(enable_method);
>> +		if (!cpu_ops[cpu])
>> +			continue;
>> +
>> +		cpu_ops[cpu]->cpu_init(NULL, cpu);
>> +	}
>> +}
>> +
>> +void __init smp_init_cpus(void)
>> +{
>> +	if (!of_smp_init_cpus())
>> +		return;
>> +
>> +	acpi_smp_init_cpus();
>>   }
> With DT we initialise the cpu_ops[0] via cpu_read_bootcpu_ops() called
> from setup_arch(). This is needed because with PSCI we use cpu_ops for
> power management even if it's a UP system. Do you get a some kernel
> warning about device node for the boot cpu not found?

Thanks for pointing this out, actually we didn't find a dts file with
spin-table method for SMP initialization, and this patch is not fully
tested (only spin-table method is supported in ACPI now), we are
working on that and get this patch fully tested.

I will review the code carefully in your comments, and update
the code accordingly.

>
>> --- a/drivers/acpi/plat/arm-core.c
>> +++ b/drivers/acpi/plat/arm-core.c
>> @@ -367,6 +367,32 @@ static void __init acpi_process_madt(void)
>>   }
>>   
>>   /*
>> + * To see PCSI is enabled or not.
>> + *
>> + * PSCI is not available for ACPI 5.0, return FALSE for now.
>> + *
>> + * FIXME: should we introduce early_param("psci", func) for test purpose?
>> + */
>> +static bool acpi_psci_smp_available(int cpu)
>> +{
>> +	return FALSE;
>> +}
>> +
>> +static const char *enable_method[] = {
>> +	"psci",
>> +	"spin-table",
>> +	NULL
>> +};
>> +
>> +const char *acpi_get_enable_method(int cpu)
>> +{
>> +	if (acpi_psci_smp_available(cpu))
>> +		return enable_method[0];
>> +	else
>> +		return enable_method[1];
>> +}
> You could just use literal strings here, actually even ignoring PSCI
> until available.

Ok.

Thanks
Hanjun

