Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752768AbaAXOhk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jan 2014 09:37:40 -0500
Received: from mail-pd0-f178.google.com ([209.85.192.178]:60985 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752550AbaAXOhi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jan 2014 09:37:38 -0500
Message-ID: <52E27AA8.8040105@linaro.org>
Date: Fri, 24 Jan 2014 22:37:28 +0800
From: Hanjun Guo <hanjun.guo@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
CC: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>,
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
Subject: Re: [PATCH 10/20] ARM64 / ACPI: Enumerate possible/present CPU set
 and map logical cpu id to APIC id
References: <1389961514-13562-1-git-send-email-hanjun.guo@linaro.org> <1389961514-13562-11-git-send-email-hanjun.guo@linaro.org> <20140122155331.GD24288@e102568-lin.cambridge.arm.com>
In-Reply-To: <20140122155331.GD24288@e102568-lin.cambridge.arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Lorenzo,

On 2014年01月22日 23:53, Lorenzo Pieralisi wrote:
> On Fri, Jan 17, 2014 at 12:25:04PM +0000, Hanjun Guo wrote:
>
> [...]
>
>> +/* map logic cpu id to physical GIC id */
>> +extern int arm_cpu_to_apicid[NR_CPUS];
>> +#define cpu_physical_id(cpu) arm_cpu_to_apicid[cpu]
> Sudeep already commented on this, please update it accordingly.

Actually after some careful review of the ACPI code, I can't
update it as MPIDR here.

MPIDR can be the ACPI uid and NOT the GIC id, the mapping
of them are something like this in ACPI driver now:

logic cpu id <---> APIC Id (GIC ID) <---> ACPI uid (MPIDR on ARM)
but not logic cpu id <---> ACPI uid directly, you can refer to
the code of processor_core.c

So here I can only map GIC id to logical cpu id.

>
>> +
>>   #else	/* !CONFIG_ACPI */
>>   #define acpi_disabled 1		/* ACPI sometimes enabled on ARM */
>>   #define acpi_noirq 1		/* ACPI sometimes enabled on ARM */
>> diff --git a/drivers/acpi/plat/arm-core.c b/drivers/acpi/plat/arm-core.c
>> index 8ba3e6f..1d9b789 100644
>> --- a/drivers/acpi/plat/arm-core.c
>> +++ b/drivers/acpi/plat/arm-core.c
>> @@ -31,6 +31,7 @@
>>   #include <linux/smp.h>
>>   
>>   #include <asm/pgtable.h>
>> +#include <asm/cputype.h>
>>   
>>   /*
>>    * We never plan to use RSDT on arm/arm64 as its deprecated in spec but this
>> @@ -52,6 +53,13 @@ EXPORT_SYMBOL(acpi_pci_disabled);
>>    */
>>   static u64 acpi_lapic_addr __initdata;
> Is this variable actually needed ?

Yes, needed for GIC initialization.

>
>>   
>> +/* available_cpus here means enabled cpu in MADT */
>> +static int available_cpus;
> Ditto.
>
>> +
>> +/* Map logic cpu id to physical GIC id (physical CPU id). */
>> +int arm_cpu_to_apicid[NR_CPUS] = { [0 ... NR_CPUS-1] = -1 };
>> +static int boot_cpu_apic_id = -1;
> Do we need all these variables ? I think we should reuse cpu_logical_map
> data structures for that, it looks suspiciously familiar.

MPIDR is the different part. if we use MPIDR as GIC id, i think
we can reuse cpu_logical_map, but Sudeep suggested not
use MPIDR as GIC id.

>
>>   #define BAD_MADT_ENTRY(entry, end) (					\
>>   	(!entry) || (unsigned long)entry + sizeof(*entry) > end ||	\
>>   	((struct acpi_subtable_header *)entry)->length < sizeof(*entry))
>> @@ -132,6 +140,55 @@ static int __init acpi_parse_madt(struct acpi_table_header *table)
>>    * Please refer to chapter5.2.12.14/15 of ACPI 5.0
>>    */
>>   
>> +/**
>> + * acpi_register_gic_cpu_interface - register a gic cpu interface and
>> + * generates a logic cpu number
>> + * @id: gic cpu interface id to register
>> + * @enabled: this cpu is enabled or not
>> + *
>> + * Returns the logic cpu number which maps to the gic cpu interface
>> + */
>> +static int acpi_register_gic_cpu_interface(int id, u8 enabled)
>> +{
>> +	int cpu;
>> +
>> +	if (id >= MAX_GIC_CPU_INTERFACE) {
>> +		pr_info(PREFIX "skipped apicid that is too big\n");
>> +		return -EINVAL;
>> +	}
>> +
>> +	total_cpus++;
>> +	if (!enabled)
>> +		return -EINVAL;
>> +
>> +	if (available_cpus >=  NR_CPUS) {
>> +		pr_warn(PREFIX "NR_CPUS limit of %d reached,"
>> +		" Processor %d/0x%x ignored.\n", NR_CPUS, total_cpus, id);
>> +		return -EINVAL;
>> +	}
> Hmm...what if you are missing the boot CPU ? It is a worthy check.
> Have a look at smp_init_cpus(), it does not bail out on cpu>= NR_CPUS
> because you do want to make sure that the DT contains the boot CPU
> node. Same logic applies.

Thanks, I will review he code you mentioned and find a solution
for ACPI part.

>
>> +
>> +	available_cpus++;
>> +
> Is available_cpus != num_possible_cpus() ? It does not look like hence
> available_cpus can go.

No, possible cpus include available cpus and disabled cpus
this is useful for ACPI based CPU hot-plug features.

>
>> +	/* allocate a logic cpu id for the new comer */
>> +	if (boot_cpu_apic_id == id) {
>> +		/*
>> +		 * boot_cpu_init() already hold bit 0 in cpu_present_mask
>> +		 * for BSP, no need to allocte again.
>> +		 */
>> +		cpu = 0;
>> +	} else {
>> +		cpu = cpumask_next_zero(-1, cpu_present_mask);
>> +	}
>> +
>> +	/* map the logic cpu id to APIC id */
>> +	arm_cpu_to_apicid[cpu] = id;
>> +
>> +	set_cpu_present(cpu, true);
>> +	set_cpu_possible(cpu, true);
> This is getting nasty. Before adding this patch and previous ones we
> need to put in place a method for the kernel to make a definite choice between
> ACPI and DT and stick to that. We can't initialize the logical map twice
> (which will happen if your DT has valid cpu nodes and a chosen node pointing
> to proper ACPI tables) or even having some entries initialized from DT and
> others by ACPI. It is a big fat no-no, please update the series accordingly.

really good catch here :)
so the problem here is that should we use both ACPI and DT in one system?


>
>> +
>> +	return cpu;
>> +}
>> +
>>   static int __init
>>   acpi_parse_gic(struct acpi_subtable_header *header, const unsigned long end)
>>   {
>> @@ -144,6 +201,16 @@ acpi_parse_gic(struct acpi_subtable_header *header, const unsigned long end)
>>   
>>   	acpi_table_print_madt_entry(header);
>>   
>> +	/*
>> +	 * We need to register disabled CPU as well to permit
>> +	 * counting disabled CPUs. This allows us to size
>> +	 * cpus_possible_map more accurately, to permit
>> +	 * to not preallocating memory for all NR_CPUS
>> +	 * when we use CPU hotplug.
>> +	 */
>> +	acpi_register_gic_cpu_interface(processor->gic_id,
>> +			processor->flags & ACPI_MADT_ENABLED);
>> +
>>   	return 0;
>>   }
>>   
>> @@ -186,6 +253,19 @@ static int __init acpi_parse_madt_gic_entries(void)
>>   		return count;
>>   	}
>>   
>> +#ifdef CONFIG_SMP
>> +	if (available_cpus == 0) {
>> +		pr_info(PREFIX "Found 0 CPUs; assuming 1\n");
>> +		arm_cpu_to_apicid[available_cpus] =
>> +			read_cpuid_mpidr() & MPIDR_HWID_BITMASK;
>> +		available_cpus = 1;	/* We've got at least one of these */
>> +	}
> I'd rather check the MADT for at least the boot cpu to present, if it is
> not ACPI tables are horribly buggy and the kernel should barf on that.
>
>> +#endif
>> +
>> +	/* Make boot-up look pretty */
>> +	pr_info("%d CPUs available, %d CPUs total\n", available_cpus,
>> +		total_cpus);
> Ok, now, how can we use the "disabled" CPUs == (total_cpus - available_cpus) ?

For cpus can be hot-added later when system is running.

>
> Are we keeping track of them in the kernel at all ? It does not look
> like, so I wonder whether we need this bit of info. I do not see why it
> is pretty to know that there are disabled, aka unusable CPUs.
>
>>   	return 0;
>>   }
>>   
>> @@ -321,6 +401,9 @@ int __init early_acpi_boot_init(void)
>>   	if (acpi_disabled)
>>   		return -ENODEV;
>>   
>> +	/* Get the boot CPU's GIC cpu interface id before MADT parsing */
>> +	boot_cpu_apic_id = read_cpuid_mpidr() & MPIDR_HWID_BITMASK;
> See Sudeep's comment.

I will rework this part to get the GIC cpu interface id, not the MPIDR here.

Thanks
Hanjun
