Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753391AbaIDP3c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 11:29:32 -0400
Received: from mail-pd0-f176.google.com ([209.85.192.176]:49772 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751005AbaIDP3a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 11:29:30 -0400
Message-ID: <5408854B.9010703@linaro.org>
Date: Thu, 04 Sep 2014 23:29:15 +0800
From: Hanjun Guo <hanjun.guo@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
CC: Catalin Marinas <Catalin.Marinas@arm.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Mark Rutland <Mark.Rutland@arm.com>, Olof Johansson <olof@lixom.net>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "graeme.gregory@linaro.org" <graeme.gregory@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, Sudeep Holla <Sudeep.Holla@arm.com>,
        Will Deacon <Will.Deacon@arm.com>, Jason Cooper <jason@lakedaemon.net>,
        Marc Zyngier <Marc.Zyngier@arm.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Mark Brown <broonie@kernel.org>, Rob Herring <robh@kernel.org>,
        Robert Richter <rric@kernel.org>, Lv Zheng <lv.zheng@intel.com>,
        Robert Moore <robert.moore@intel.com>,
        Liviu Dudau <Liviu.Dudau@arm.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Charles Garcia-Tobin <Charles.Garcia-Tobin@arm.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linaro-acpi@lists.linaro.org" <linaro-acpi@lists.linaro.org>,
        Tomasz Nowicki <tomasz.nowicki@linaro.org>
Subject: Re: [PATCH v3 09/17] ARM64 / ACPI: Parse MADT for SMP initialization
References: <1409583475-6978-1-git-send-email-hanjun.guo@linaro.org> <1409583475-6978-10-git-send-email-hanjun.guo@linaro.org> <20140903172138.GG1824@e102568-lin.cambridge.arm.com>
In-Reply-To: <20140903172138.GG1824@e102568-lin.cambridge.arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Lorenzo,

On 2014年09月04日 01:21, Lorenzo Pieralisi wrote:
> On Mon, Sep 01, 2014 at 03:57:47PM +0100, Hanjun Guo wrote:
>> MADT contains the information for MPIDR which is essential for
>> SMP initialization, parse the GIC cpu interface structures to
>> get the MPIDR value and map it to cpu_logical_map(), and add
>> enabled cpu with valid MPIDR into cpu_possible_map.
>>
>> ACPI 5.1 only has two explicit methods to boot up SMP, PSCI and
>> Parking protocol, but the Parking protocol is only specified for
>> ARMv7 now, so make PSCI as the only way for the SMP boot protocol
>> before some updates for the ACPI spec or the Parking protocol spec.
[...]
>>  int acpi_noirq;			/* skip ACPI IRQ initialization */
>>  int acpi_disabled;
>>  EXPORT_SYMBOL(acpi_disabled);
>> @@ -31,6 +35,8 @@ EXPORT_SYMBOL(acpi_disabled);
>>  int acpi_pci_disabled;		/* skip ACPI PCI scan and IRQ initialization */
>>  EXPORT_SYMBOL(acpi_pci_disabled);
>>  
>> +static int enabled_cpus;	/* Processors (GICC) with enabled flag in MADT */
> Will this be ever different from (num_possible_cpus() - 1) ?

Yes, num_possible_cpus() will much more than enabled cpus
in MADT, when ACPI based CPU hot plug is introduced, you can refer
to the code in x86.

>
>> +
>>  /*
>>   * __acpi_map_table() will be called before page_init(), so early_ioremap()
>>   * or early_memremap() should be called here to for ACPI table mapping.
>> @@ -51,6 +57,144 @@ void __init __acpi_unmap_table(char *map, unsigned long size)
>>  	early_memunmap(map, size);
>>  }
>>  
>> +/**
>> + * acpi_map_gic_cpu_interface - generates a logical cpu number
>> + * and map to MPIDR represented by GICC structure
>> + * @mpidr: CPU's hardware id to register, MPIDR represented in MADT
>> + * @enabled: this cpu is enabled or not
>> + *
>> + * Returns the logical cpu number which maps to MPIDR
>> + */
>> +static int acpi_map_gic_cpu_interface(u64 mpidr, u8 enabled)
>> +{
>> +	int cpu;
>> +
>> +	if (mpidr == INVALID_HWID) {
>> +		pr_info("Skip invalid cpu hardware ID\n");
>> +		return -EINVAL;
>> +	}
>> +
>> +	total_cpus++;
> What's this used for ?

It is for all the CPU entries in MADT table, it is used to let
people know how many CPUs in MADT (enabled and disabled).

>
>> +	if (!enabled)
>> +		return -EINVAL;
>> +
>> +	if (enabled_cpus >=  NR_CPUS) {
>> +		pr_warn("NR_CPUS limit of %d reached, Processor %d/0x%llx ignored.\n",
>> +			NR_CPUS, total_cpus, mpidr);
>> +		return -EINVAL;
>> +	}
>> +
>> +	/* No need to check duplicate MPIDRs for the first CPU */
>> +	if (enabled_cpus) {
>> +		/*
>> +		 * Duplicate MPIDRs are a recipe for disaster. Scan
>> +		 * all initialized entries and check for
>> +		 * duplicates. If any is found just ignore the CPU.
>> +		 */
>> +		for_each_possible_cpu(cpu) {
>> +			if (cpu_logical_map(cpu) == mpidr) {
>> +				pr_err("Firmware bug, duplicate CPU MPIDR: 0x%llx in MADT\n",
>> +				mpidr);
>> +				return -EINVAL;
>> +			}
>> +		}
>> +	} else {
>> +		/* Fist GICC entry must be BSP as ACPI spec said */
> s/Fist/First/
>
>> +		if  (cpu_logical_map(0) != mpidr) {
>> +			pr_err("First GICC entry is not BSP for MPIDR 0x%llx\n",
>> +			       mpidr);
>> +			return -EINVAL;
>> +		}
> Interesting, this means that if I want to change the boot CPU I have to
> recompile the ACPI tables. Is that really true ?

No, you needn't. there is a logic problem here, we just need to print
some message here and continue, OS will still ok with that.

>
>> +	}
>> +
>> +	/* allocate a logical cpu id for the new comer */
>> +	if (cpu_logical_map(0) == mpidr) {
>> +		/*
>> +		 * boot_cpu_init() already hold bit 0 in cpu_present_mask
>> +		 * for BSP, no need to allocate again.
>> +		 */
>> +		cpu = 0;
>> +	} else {
>> +		cpu = cpumask_next_zero(-1, cpu_possible_mask);
>> +	}
> You may use a ternary operator, more compact and clearer.
>
> BTW you seem to be contradicting yourself. On one hand you keep a
> counter for enabled_cpus, and then use cpu_possible_mask to allocate
> a logical cpu id. Make a decision, either you use a counter or you
> use cpu_possible_mask and its bitweight.

ok.

>
>> +	/*
>> +	 * ACPI 5.1 only has two explicit methods to boot up SMP,
>> +	 * PSCI and Parking protocol, but the Parking protocol is
>> +	 * only specified for ARMv7 now, so make PSCI as the only
>> +	 * way for the SMP boot protocol before some updates for
>> +	 * the ACPI spec or the Parking protocol spec.
>> +	 */
>> +	if (!acpi_psci_present()) {
>> +		pr_warn("CPU %d has no PSCI support, will not boot\n", cpu);
>> +		return -EOPNOTSUPP;
>> +	}
> This check really does not belong here. You do not even start parsing the gic
> cpu interfaces if psci is missing or I am missing something myself. Anyway,
> this check must not be in this function.

I agree with you, i will update the patch.

>
>> +
>> +	/* Get cpu_ops include the boot CPU */
>> +	cpu_ops[cpu] = cpu_get_ops("psci");
>> +	if (!cpu_ops[cpu])
>> +		return -EINVAL;
>> +
>> +	/* CPU 0 was already initialized */
>> +	if (cpu) {
>> +		if (cpu_ops[cpu]->cpu_init(NULL, cpu))
>> +			return -EOPNOTSUPP;
>> +
>> +		/* map the logical cpu id to cpu MPIDR */
>> +		cpu_logical_map(cpu) = mpidr;
>> +
>> +		set_cpu_possible(cpu, true);
>> +	}
>> +
>> +	enabled_cpus++;
> See above to me enabled_cpus and (num_possible_cpus() - 1)  are identical.

I think I need to remove all the CPU hotplug related code and make this function
as simple as possible and introduce them when needed.

>
>> +	return cpu;
>> +}
>> +
>> +static int __init
>> +acpi_parse_gic_cpu_interface(struct acpi_subtable_header *header,
>> +				const unsigned long end)
>> +{
>> +	struct acpi_madt_generic_interrupt *processor;
>> +
>> +	processor = (struct acpi_madt_generic_interrupt *)header;
>> +
>> +	if (BAD_MADT_ENTRY(processor, end))
>> +		return -EINVAL;
>> +
>> +	acpi_table_print_madt_entry(header);
>> +
>> +	acpi_map_gic_cpu_interface(processor->arm_mpidr,
>> +		processor->flags & ACPI_MADT_ENABLED);
> Ehm. You must check the return value here right (and return an error if
> that's an error, otherwise the count value below can be botched ?!).
>
> Or you do not consider a parsing error as an error and want to keep
> parsing remaining GIC CPU IF entries ?

yes, this is my intension. we can skip the error ones and boot
other CPUs which have no errors.

>
>> +
>> +	return 0;
>> +}
>> +
>> +/* Parse GIC cpu interface entries in MADT for SMP init */
>> +void __init acpi_smp_init_cpus(void)
>> +{
>> +	int count;
>> +
>> +	/*
>> +	 * do a partial walk of MADT to determine how many CPUs
>> +	 * we have including disabled CPUs, and get information
>> +	 * we need for SMP init
>> +	 */
>> +	count = acpi_table_parse_madt(ACPI_MADT_TYPE_GENERIC_INTERRUPT,
>> +			acpi_parse_gic_cpu_interface,
>> +			ACPI_MAX_GIC_CPU_INTERFACE_ENTRIES);
>> +
>> +	if (!count) {
>> +		pr_err("No GIC CPU interface entries present\n");
>> +		return;
>> +	} else if (count < 0) {
>> +		pr_err("Error parsing GIC CPU interface entry\n");
>> +		return;
>> +	}
> What would you consider an error ? A single GIC CPU IF entry error ?

could you please explain it in detail? I can't catch up with you, my apologizes.

Thanks
Hanjun
