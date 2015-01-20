Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932075AbbATNKc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 08:10:32 -0500
Received: from mail-pa0-f42.google.com ([209.85.220.42]:45631 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753940AbbATNK2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 08:10:28 -0500
Message-ID: <54BE53A3.5010706@linaro.org>
Date: Tue, 20 Jan 2015 21:09:55 +0800
From: Hanjun Guo <hanjun.guo@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
CC: Catalin Marinas <Catalin.Marinas@arm.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        Mark Rutland <Mark.Rutland@arm.com>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        Will Deacon <Will.Deacon@arm.com>,
        "graeme.gregory@linaro.org" <graeme.gregory@linaro.org>,
        Sudeep Holla <Sudeep.Holla@arm.com>, "jcm@redhat.com" <jcm@redhat.com>,
        Jason Cooper <jason@lakedaemon.net>,
        Marc Zyngier <Marc.Zyngier@arm.com>,
        Bjorn Helgaas <bhelgaas@google.com>, Mark Brown <broonie@kernel.org>,
        Rob Herring <robh@kernel.org>, Robert Richter <rric@kernel.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Charles Garcia-Tobin <Charles.Garcia-Tobin@arm.com>,
        "phoenix.liyi@huawei.com" <phoenix.liyi@huawei.com>,
        Timur Tabi <timur@codeaurora.org>,
        "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>,
        "wangyijing@huawei.com" <wangyijing@huawei.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linaro-acpi@lists.linaro.org" <linaro-acpi@lists.linaro.org>,
        Tomasz Nowicki <tomasz.nowicki@linaro.org>
Subject: Re: [PATCH v7 10/17] ARM64 / ACPI: Parse MADT for SMP initialization
References: <1421247905-3749-1-git-send-email-hanjun.guo@linaro.org> <1421247905-3749-11-git-send-email-hanjun.guo@linaro.org> <20150116181836.GA15836@red-moon>
In-Reply-To: <20150116181836.GA15836@red-moon>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Lorenzo,

Sorry for the late reply, I was updating this patch according
to your comments and see if it works, inline reply below.

On 2015年01月17日 02:18, Lorenzo Pieralisi wrote:
> Hi Hanjun,
>
> On Wed, Jan 14, 2015 at 03:04:58PM +0000, Hanjun Guo wrote:
>
> [...]
>
>> diff --git a/arch/arm64/include/asm/smp.h b/arch/arm64/include/asm/smp.h
>> index 780f82c..bf22650 100644
>> --- a/arch/arm64/include/asm/smp.h
>> +++ b/arch/arm64/include/asm/smp.h
>> @@ -39,9 +39,10 @@ extern void show_ipi_list(struct seq_file *p, int prec);
>>   extern void handle_IPI(int ipinr, struct pt_regs *regs);
>>
>>   /*
>> - * Setup the set of possible CPUs (via set_cpu_possible)
>> + * Discover the set of possible CPUs and determine their
>> + * SMP operations.
>>    */
>> -extern void smp_init_cpus(void);
>> +extern void of_smp_init_cpus(void);
>>
>>   /*
>>    * Provide a function to raise an IPI cross call on CPUs in callmap.
>> diff --git a/arch/arm64/kernel/acpi.c b/arch/arm64/kernel/acpi.c
>> index 4177758..55d99d9 100644
>> --- a/arch/arm64/kernel/acpi.c
>> +++ b/arch/arm64/kernel/acpi.c
>> @@ -24,6 +24,10 @@
>>   #include <linux/bootmem.h>
>>   #include <linux/smp.h>
>>
>> +#include <asm/smp_plat.h>
>> +#include <asm/cputype.h>
>> +#include <asm/cpu_ops.h>
>
> Alphabetical order please.

OK, already updated.

>
>> +
>>   int acpi_noirq;                        /* skip ACPI IRQ initialization */
>>   int acpi_disabled;
>>   EXPORT_SYMBOL(acpi_disabled);
>> @@ -31,6 +35,8 @@ EXPORT_SYMBOL(acpi_disabled);
>>   int acpi_pci_disabled;         /* skip ACPI PCI scan and IRQ initialization */
>>   EXPORT_SYMBOL(acpi_pci_disabled);
>>
>> +static int enabled_cpus;       /* Processors (GICC) with enabled flag in MADT */
>
> Needed for hotplug ? Remember that each patch must be self-contained.
>
> This patch is clearly not, if I did not know you need to carry this
> stuff over after boot for physical cpu hotplugging it would be hard to
> understand most of this code.
>
> Think about that for anyone looking at your commit-log as a stand alone
> entity in the kernel history.

I will say partly yes :)

Processor (GICC) structures in MADT have a flag to indicate it is
enabled or not, and yes, it can be used as the base support for CPU
hotplug to generate possible cpus with disabled CPU counted (no
implementation in this patch) in, and then we can hot add CPUs
which disabled in MADT table.

But we still got other use cases, such as we just enable cores
we wanted (for example, we can boot 16 cores in a 32 cores system,
with disabled flag for another 16 cores), and update the flag
in firmware without adding/deleting GICC entries, enabled_cpus
will count CPUs with enabled flag and I think this information
it is useful to know.

>
>> +
>>   /*
>>    * __acpi_map_table() will be called before page_init(), so early_ioremap()
>>    * or early_memremap() should be called here to for ACPI table mapping.
>> @@ -51,6 +57,134 @@ void __init __acpi_unmap_table(char *map, unsigned long size)
>>          early_memunmap(map, size);
>>   }
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
>
> It would be __init, except that you might need it after boot for
> hotplug, correct ?

Yes, good catch :)

I agree with you here totally that I shouldn't add hot-plug
code in this patch, I will update it.

>
>> +{
>> +       int cpu;
>> +
>> +       if (mpidr == INVALID_HWID) {
>> +               pr_info("Skip MADT cpu entry with invalid MPIDR\n");
>> +               return -EINVAL;
>> +       }
>> +
>> +       total_cpus++;
>> +       if (!enabled)
>> +               return -EINVAL;
>> +
>> +       if (enabled_cpus >=  NR_CPUS) {
>> +               pr_warn("NR_CPUS limit of %d reached, Processor %d/0x%llx ignored.\n",
>> +                       NR_CPUS, total_cpus, mpidr);
>> +               return -EINVAL;
>> +       }
>> +
>> +       /* No need to check duplicate MPIDRs for the first CPU */
>> +       if (enabled_cpus) {
>> +               /*
>> +                * Duplicate MPIDRs are a recipe for disaster. Scan
>> +                * all initialized entries and check for
>> +                * duplicates. If any is found just ignore the CPU.
>> +                */
>> +               for_each_possible_cpu(cpu) {
>> +                       if (cpu_logical_map(cpu) == mpidr) {
>> +                               pr_err("Firmware bug, duplicate CPU MPIDR: 0x%llx in MADT\n",
>> +                                      mpidr);
>> +                               return -EINVAL;
>> +                       }
>> +               }
>> +
>> +               /* allocate a logical cpu id for the new comer */
>> +               cpu = cpumask_next_zero(-1, cpu_possible_mask);
>> +       } else {
>> +               /*
>> +                * First GICC entry must be BSP as ACPI spec said
>> +                * in section 5.2.12.15
>> +                */
>> +               if  (cpu_logical_map(0) != mpidr) {
>> +                       pr_err("First GICC entry with MPIDR 0x%llx is not BSP\n",
>> +                              mpidr);
>> +                       return -EINVAL;
>> +               }
>> +
>> +               /*
>> +                * boot_cpu_init() already hold bit 0 in cpu_present_mask
>
> You mean cpu_possible_mask ? That's what you allocate from above.

Another hot-plug piece leaved, will update it.

>
>> +                * for BSP, no need to allocate again.
>> +                */
>> +               cpu = 0;
>> +       }
>> +
>> +       /* CPU 0 was already initialized */
>> +       if (cpu) {
>> +               cpu_ops[cpu] = cpu_get_ops(acpi_psci_present() ? "psci" : NULL);
>> +               if (!cpu_ops[cpu])
>> +                       return -EINVAL;
>> +
>> +               if (cpu_ops[cpu]->cpu_init(NULL, cpu))
>> +                       return -EOPNOTSUPP;
>> +
>> +               /* map the logical cpu id to cpu MPIDR */
>> +               cpu_logical_map(cpu) = mpidr;
>> +
>> +               set_cpu_possible(cpu, true);
>> +       } else {
>> +               /* get cpu0's ops, no need to return if ops is null */
>> +               cpu_ops[0] = cpu_get_ops(acpi_psci_present() ? "psci" : NULL);
>> +       }
>
> I do not see much point in calling cpu_get_ops with NULL, and adding
> the check in it to return NULL when the parameter is NULL.
>
> What would you expect from cpu_get_ops when called with NULL other than
> a NULL pointer ?

I'm lost here since it is best way for the implementation I think, any
suggestions?

>
> You could move:
>
> cpu_ops[cpu] = cpu_get_ops(acpi_psci_present() ? "psci" : NULL);
>
> out of the if and remove the else, do not know if it makes code clearer,
> shorter for certain.
>
>> +
>> +       enabled_cpus++;
>> +       return cpu;
>> +}
>> +
>> +static int __init
>> +acpi_parse_gic_cpu_interface(struct acpi_subtable_header *header,
>> +                               const unsigned long end)
>> +{
>> +       struct acpi_madt_generic_interrupt *processor;
>> +
>> +       processor = (struct acpi_madt_generic_interrupt *)header;
>> +
>> +       if (BAD_MADT_ENTRY(processor, end))
>> +               return -EINVAL;
>> +
>> +       acpi_table_print_madt_entry(header);
>> +
>> +       acpi_map_gic_cpu_interface(processor->arm_mpidr & MPIDR_HWID_BITMASK,
>> +               processor->flags & ACPI_MADT_ENABLED);
>> +
>> +       return 0;
>> +}
>> +
>> +/* Parse GIC cpu interface entries in MADT for SMP init */
>> +void __init acpi_smp_init_cpus(void)
>> +{
>> +       int count;
>> +
>> +       /*
>> +        * do a partial walk of MADT to determine how many CPUs
>> +        * we have including disabled CPUs, and get information
>> +        * we need for SMP init
>> +        */
>> +       count = acpi_table_parse_madt(ACPI_MADT_TYPE_GENERIC_INTERRUPT,
>> +                       acpi_parse_gic_cpu_interface, 0);
>> +
>> +       if (!count) {
>> +               pr_err("No GIC CPU interface entries present\n");
>> +               return;
>> +       } else if (count < 0) {
>> +               pr_err("Error parsing GIC CPU interface entry\n");
>> +               return;
>> +       }
>> +
>> +       /* Make boot-up look pretty */
>> +       pr_info("%d CPUs enabled, %d CPUs total\n", enabled_cpus, total_cpus);
>> +}
>> +
>>   static int __init acpi_parse_fadt(struct acpi_table_header *table)
>>   {
>>          struct acpi_table_fadt *fadt = (struct acpi_table_fadt *)table;
>> @@ -62,8 +196,20 @@ static int __init acpi_parse_fadt(struct acpi_table_header *table)
>>           * to get arm boot flags, or we will disable ACPI.
>>           */
>>          if (table->revision > 5 ||
>> -           (table->revision == 5 && fadt->minor_revision >= 1))
>> -               return 0;
>> +           (table->revision == 5 && fadt->minor_revision >= 1)) {
>> +               /*
>> +                * ACPI 5.1 only has two explicit methods to boot up SMP,
>> +                * PSCI and Parking protocol, but the Parking protocol is
>> +                * only specified for ARMv7 now, so make PSCI as the only
>> +                * way for the SMP boot protocol before some updates for
>> +                * the ACPI spec or the Parking protocol spec.
>> +                */
>> +               if (acpi_psci_present())
>> +                       return 0;
>> +
>> +               pr_warn("No PSCI support, will not bring up secondary CPUs\n");
>> +               return -EOPNOTSUPP;
>> +       }
>>
>>          pr_warn("Unsupported FADT revision %d.%d, should be 5.1+, will disable ACPI\n",
>>                  table->revision, fadt->minor_revision);
>> diff --git a/arch/arm64/kernel/cpu_ops.c b/arch/arm64/kernel/cpu_ops.c
>> index cce9524..1ea7b9f 100644
>> --- a/arch/arm64/kernel/cpu_ops.c
>> +++ b/arch/arm64/kernel/cpu_ops.c
>> @@ -27,7 +27,7 @@ extern const struct cpu_operations cpu_psci_ops;
>>
>>   const struct cpu_operations *cpu_ops[NR_CPUS];
>>
>> -static const struct cpu_operations *supported_cpu_ops[] __initconst = {
>> +static const struct cpu_operations *supported_cpu_ops[] = {
>
> This __initconst removal should be explained either with code needing
> it or through a comment. You can't make changes with future patches
> in mind, since they may never get merged and you leave code in this
> patch incomplete.
>
> As far as I know if physical CPU hotplug can't/won't be done on ARM64 your
> patch would make changes that are not needed, and miss some changes
> that are (eg removing enabled_cpus or make it __initdata).

I agree with you :)

>
> You can't write a patch with assumptions on subsequent patches.
>
>>   #ifdef CONFIG_SMP
>>          &smp_spin_table_ops,
>>   #endif
>> @@ -35,10 +35,13 @@ static const struct cpu_operations *supported_cpu_ops[] __initconst = {
>>          NULL,
>>   };
>>
>> -static const struct cpu_operations * __init cpu_get_ops(const char *name)
>> +const struct cpu_operations *cpu_get_ops(const char *name)
>
> Ditto.
>
>>   {
>>          const struct cpu_operations **ops = supported_cpu_ops;
>>
>> +       if (!name)
>> +               return NULL;
>> +
>
> See above.
>
>>          while (*ops) {
>>                  if (!strcmp(name, (*ops)->name))
>>                          return *ops;
>> diff --git a/arch/arm64/kernel/setup.c b/arch/arm64/kernel/setup.c
>> index ef5b1e1..54e39e3 100644
>> --- a/arch/arm64/kernel/setup.c
>> +++ b/arch/arm64/kernel/setup.c
>> @@ -414,13 +414,16 @@ void __init setup_arch(char **cmdline_p)
>>          if (acpi_disabled) {
>>                  unflatten_device_tree();
>>                  psci_dt_init();
>> +               cpu_read_bootcpu_ops();
>> +#ifdef CONFIG_SMP
>> +               of_smp_init_cpus();
>> +#endif
>>          } else {
>>                  psci_acpi_init();
>> +               acpi_smp_init_cpus();
>
> With DT you call cpu_read_bootcpu_ops() and then of_smp_init_cpus()
> with acpi you have one function that does both, it is not really
> neat.

The mechanism for ACPI table entry scanning is that for every matched
structure (such as GICC) found, the parse function will be called, so
if we separate them it will duplicate the scanning of ACPI tables.

Thanks
Hanjun
