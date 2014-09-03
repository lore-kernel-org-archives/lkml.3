Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756171AbaICRVr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 13:21:47 -0400
Received: from service87.mimecast.com ([91.220.42.44]:43988 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752645AbaICRVp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 13:21:45 -0400
Date: Wed, 3 Sep 2014 18:21:38 +0100
From: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
To: Hanjun Guo <hanjun.guo@linaro.org>
Cc: Catalin Marinas <Catalin.Marinas@arm.com>,
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
Message-ID: <20140903172138.GG1824@e102568-lin.cambridge.arm.com>
References: <1409583475-6978-1-git-send-email-hanjun.guo@linaro.org>
 <1409583475-6978-10-git-send-email-hanjun.guo@linaro.org>
MIME-Version: 1.0
In-Reply-To: <1409583475-6978-10-git-send-email-hanjun.guo@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginalArrivalTime: 03 Sep 2014 17:21:39.0771 (UTC) FILETIME=[85EBB8B0:01CFC79B]
X-MC-Unique: 114090318214200201
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 01, 2014 at 03:57:47PM +0100, Hanjun Guo wrote:
> MADT contains the information for MPIDR which is essential for
> SMP initialization, parse the GIC cpu interface structures to
> get the MPIDR value and map it to cpu_logical_map(), and add
> enabled cpu with valid MPIDR into cpu_possible_map.
> 
> ACPI 5.1 only has two explicit methods to boot up SMP, PSCI and
> Parking protocol, but the Parking protocol is only specified for
> ARMv7 now, so make PSCI as the only way for the SMP boot protocol
> before some updates for the ACPI spec or the Parking protocol spec.
> 
> Signed-off-by: Hanjun Guo <hanjun.guo@linaro.org>
> Signed-off-by: Tomasz Nowicki <tomasz.nowicki@linaro.org>
> ---
>  arch/arm64/include/asm/acpi.h    |    4 ++
>  arch/arm64/include/asm/cpu_ops.h |    1 +
>  arch/arm64/include/asm/smp.h     |    5 +-
>  arch/arm64/kernel/acpi.c         |  144 ++++++++++++++++++++++++++++++++++++++
>  arch/arm64/kernel/cpu_ops.c      |    4 +-
>  arch/arm64/kernel/setup.c        |    8 ++-
>  arch/arm64/kernel/smp.c          |    2 +-
>  7 files changed, 161 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/acpi.h b/arch/arm64/include/asm/acpi.h
> index 620057c..e013dbb 100644
> --- a/arch/arm64/include/asm/acpi.h
> +++ b/arch/arm64/include/asm/acpi.h
> @@ -51,6 +51,7 @@ static inline bool acpi_has_cpu_in_madt(void)
>  }
>  
>  static inline void arch_fix_phys_package_id(int num, u32 slot) { }
> +void __init acpi_smp_init_cpus(void);
>  
>  /* Low-level suspend routine.
>   *
> @@ -64,10 +65,13 @@ static inline void arch_fix_phys_package_id(int num, u32 slot) { }
>  extern int (*acpi_suspend_lowlevel)(void);
>  #define acpi_wakeup_address 0
>  
> +#define ACPI_MAX_GIC_CPU_INTERFACE_ENTRIES 65535
> +
>  #else
>  
>  static inline bool acpi_psci_present(void) { return false; }
>  static inline bool acpi_psci_use_hvc(void) { return false; }
> +static inline void acpi_smp_init_cpus(void) { }
>  
>  #endif /* CONFIG_ACPI */
>  
> diff --git a/arch/arm64/include/asm/cpu_ops.h b/arch/arm64/include/asm/cpu_ops.h
> index d7b4b38..d149580 100644
> --- a/arch/arm64/include/asm/cpu_ops.h
> +++ b/arch/arm64/include/asm/cpu_ops.h
> @@ -61,6 +61,7 @@ struct cpu_operations {
>  };
>  
>  extern const struct cpu_operations *cpu_ops[NR_CPUS];
> +const struct cpu_operations *cpu_get_ops(const char *name);
>  extern int __init cpu_read_ops(struct device_node *dn, int cpu);
>  extern void __init cpu_read_bootcpu_ops(void);
>  
> diff --git a/arch/arm64/include/asm/smp.h b/arch/arm64/include/asm/smp.h
> index a498f2c..c877adc 100644
> --- a/arch/arm64/include/asm/smp.h
> +++ b/arch/arm64/include/asm/smp.h
> @@ -39,9 +39,10 @@ extern void show_ipi_list(struct seq_file *p, int prec);
>  extern void handle_IPI(int ipinr, struct pt_regs *regs);
>  
>  /*
> - * Setup the set of possible CPUs (via set_cpu_possible)
> + * Discover the set of possible CPUs and determine their
> + * SMP operations.
>   */
> -extern void smp_init_cpus(void);
> +extern void of_smp_init_cpus(void);
>  
>  /*
>   * Provide a function to raise an IPI cross call on CPUs in callmap.
> diff --git a/arch/arm64/kernel/acpi.c b/arch/arm64/kernel/acpi.c
> index 470570c..fbaaf01 100644
> --- a/arch/arm64/kernel/acpi.c
> +++ b/arch/arm64/kernel/acpi.c
> @@ -24,6 +24,10 @@
>  #include <linux/bootmem.h>
>  #include <linux/smp.h>
>  
> +#include <asm/smp_plat.h>
> +#include <asm/cputype.h>
> +#include <asm/cpu_ops.h>
> +
>  int acpi_noirq;			/* skip ACPI IRQ initialization */
>  int acpi_disabled;
>  EXPORT_SYMBOL(acpi_disabled);
> @@ -31,6 +35,8 @@ EXPORT_SYMBOL(acpi_disabled);
>  int acpi_pci_disabled;		/* skip ACPI PCI scan and IRQ initialization */
>  EXPORT_SYMBOL(acpi_pci_disabled);
>  
> +static int enabled_cpus;	/* Processors (GICC) with enabled flag in MADT */

Will this be ever different from (num_possible_cpus() - 1) ?

> +
>  /*
>   * __acpi_map_table() will be called before page_init(), so early_ioremap()
>   * or early_memremap() should be called here to for ACPI table mapping.
> @@ -51,6 +57,144 @@ void __init __acpi_unmap_table(char *map, unsigned long size)
>  	early_memunmap(map, size);
>  }
>  
> +/**
> + * acpi_map_gic_cpu_interface - generates a logical cpu number
> + * and map to MPIDR represented by GICC structure
> + * @mpidr: CPU's hardware id to register, MPIDR represented in MADT
> + * @enabled: this cpu is enabled or not
> + *
> + * Returns the logical cpu number which maps to MPIDR
> + */
> +static int acpi_map_gic_cpu_interface(u64 mpidr, u8 enabled)
> +{
> +	int cpu;
> +
> +	if (mpidr == INVALID_HWID) {
> +		pr_info("Skip invalid cpu hardware ID\n");
> +		return -EINVAL;
> +	}
> +
> +	total_cpus++;

What's this used for ?

> +	if (!enabled)
> +		return -EINVAL;
> +
> +	if (enabled_cpus >=  NR_CPUS) {
> +		pr_warn("NR_CPUS limit of %d reached, Processor %d/0x%llx ignored.\n",
> +			NR_CPUS, total_cpus, mpidr);
> +		return -EINVAL;
> +	}
> +
> +	/* No need to check duplicate MPIDRs for the first CPU */
> +	if (enabled_cpus) {
> +		/*
> +		 * Duplicate MPIDRs are a recipe for disaster. Scan
> +		 * all initialized entries and check for
> +		 * duplicates. If any is found just ignore the CPU.
> +		 */
> +		for_each_possible_cpu(cpu) {
> +			if (cpu_logical_map(cpu) == mpidr) {
> +				pr_err("Firmware bug, duplicate CPU MPIDR: 0x%llx in MADT\n",
> +				mpidr);
> +				return -EINVAL;
> +			}
> +		}
> +	} else {
> +		/* Fist GICC entry must be BSP as ACPI spec said */

s/Fist/First/

> +		if  (cpu_logical_map(0) != mpidr) {
> +			pr_err("First GICC entry is not BSP for MPIDR 0x%llx\n",
> +			       mpidr);
> +			return -EINVAL;
> +		}

Interesting, this means that if I want to change the boot CPU I have to
recompile the ACPI tables. Is that really true ?

> +	}
> +
> +	/* allocate a logical cpu id for the new comer */
> +	if (cpu_logical_map(0) == mpidr) {
> +		/*
> +		 * boot_cpu_init() already hold bit 0 in cpu_present_mask
> +		 * for BSP, no need to allocate again.
> +		 */
> +		cpu = 0;
> +	} else {
> +		cpu = cpumask_next_zero(-1, cpu_possible_mask);
> +	}

You may use a ternary operator, more compact and clearer.

BTW you seem to be contradicting yourself. On one hand you keep a
counter for enabled_cpus, and then use cpu_possible_mask to allocate
a logical cpu id. Make a decision, either you use a counter or you
use cpu_possible_mask and its bitweight.

> +	/*
> +	 * ACPI 5.1 only has two explicit methods to boot up SMP,
> +	 * PSCI and Parking protocol, but the Parking protocol is
> +	 * only specified for ARMv7 now, so make PSCI as the only
> +	 * way for the SMP boot protocol before some updates for
> +	 * the ACPI spec or the Parking protocol spec.
> +	 */
> +	if (!acpi_psci_present()) {
> +		pr_warn("CPU %d has no PSCI support, will not boot\n", cpu);
> +		return -EOPNOTSUPP;
> +	}

This check really does not belong here. You do not even start parsing the gic
cpu interfaces if psci is missing or I am missing something myself. Anyway,
this check must not be in this function.

> +
> +	/* Get cpu_ops include the boot CPU */
> +	cpu_ops[cpu] = cpu_get_ops("psci");
> +	if (!cpu_ops[cpu])
> +		return -EINVAL;
> +
> +	/* CPU 0 was already initialized */
> +	if (cpu) {
> +		if (cpu_ops[cpu]->cpu_init(NULL, cpu))
> +			return -EOPNOTSUPP;
> +
> +		/* map the logical cpu id to cpu MPIDR */
> +		cpu_logical_map(cpu) = mpidr;
> +
> +		set_cpu_possible(cpu, true);
> +	}
> +
> +	enabled_cpus++;

See above to me enabled_cpus and (num_possible_cpus() - 1)  are identical.

> +	return cpu;
> +}
> +
> +static int __init
> +acpi_parse_gic_cpu_interface(struct acpi_subtable_header *header,
> +				const unsigned long end)
> +{
> +	struct acpi_madt_generic_interrupt *processor;
> +
> +	processor = (struct acpi_madt_generic_interrupt *)header;
> +
> +	if (BAD_MADT_ENTRY(processor, end))
> +		return -EINVAL;
> +
> +	acpi_table_print_madt_entry(header);
> +
> +	acpi_map_gic_cpu_interface(processor->arm_mpidr,
> +		processor->flags & ACPI_MADT_ENABLED);

Ehm. You must check the return value here right (and return an error if
that's an error, otherwise the count value below can be botched ?!).

Or you do not consider a parsing error as an error and want to keep
parsing remaining GIC CPU IF entries ?

> +
> +	return 0;
> +}
> +
> +/* Parse GIC cpu interface entries in MADT for SMP init */
> +void __init acpi_smp_init_cpus(void)
> +{
> +	int count;
> +
> +	/*
> +	 * do a partial walk of MADT to determine how many CPUs
> +	 * we have including disabled CPUs, and get information
> +	 * we need for SMP init
> +	 */
> +	count = acpi_table_parse_madt(ACPI_MADT_TYPE_GENERIC_INTERRUPT,
> +			acpi_parse_gic_cpu_interface,
> +			ACPI_MAX_GIC_CPU_INTERFACE_ENTRIES);
> +
> +	if (!count) {
> +		pr_err("No GIC CPU interface entries present\n");
> +		return;
> +	} else if (count < 0) {
> +		pr_err("Error parsing GIC CPU interface entry\n");
> +		return;
> +	}

What would you consider an error ? A single GIC CPU IF entry error ?

Thanks,
Lorenzo

> +	/* Make boot-up look pretty */
> +	pr_info("%d CPUs enabled, %d CPUs total\n", enabled_cpus, total_cpus);
> +}
> +
>  static int __init acpi_parse_fadt(struct acpi_table_header *table)
>  {
>  	struct acpi_table_fadt *fadt = (struct acpi_table_fadt *)table;
> diff --git a/arch/arm64/kernel/cpu_ops.c b/arch/arm64/kernel/cpu_ops.c
> index cce9524..1a04deb 100644
> --- a/arch/arm64/kernel/cpu_ops.c
> +++ b/arch/arm64/kernel/cpu_ops.c
> @@ -27,7 +27,7 @@ extern const struct cpu_operations cpu_psci_ops;
>  
>  const struct cpu_operations *cpu_ops[NR_CPUS];
>  
> -static const struct cpu_operations *supported_cpu_ops[] __initconst = {
> +static const struct cpu_operations *supported_cpu_ops[] = {
>  #ifdef CONFIG_SMP
>  	&smp_spin_table_ops,
>  #endif
> @@ -35,7 +35,7 @@ static const struct cpu_operations *supported_cpu_ops[] __initconst = {
>  	NULL,
>  };
>  
> -static const struct cpu_operations * __init cpu_get_ops(const char *name)
> +const struct cpu_operations *cpu_get_ops(const char *name)
>  {
>  	const struct cpu_operations **ops = supported_cpu_ops;
>  
> diff --git a/arch/arm64/kernel/setup.c b/arch/arm64/kernel/setup.c
> index ac9ec55..a45ceb3 100644
> --- a/arch/arm64/kernel/setup.c
> +++ b/arch/arm64/kernel/setup.c
> @@ -60,6 +60,7 @@
>  #include <asm/memblock.h>
>  #include <asm/psci.h>
>  #include <asm/efi.h>
> +#include <asm/acpi.h>
>  
>  unsigned int processor_id;
>  EXPORT_SYMBOL(processor_id);
> @@ -398,13 +399,16 @@ void __init setup_arch(char **cmdline_p)
>  	if (acpi_disabled) {
>  		unflatten_device_tree();
>  		psci_dt_init();
> +		cpu_read_bootcpu_ops();
> +#ifdef CONFIG_SMP
> +		of_smp_init_cpus();
> +#endif
>  	} else {
>  		psci_acpi_init();
> +		acpi_smp_init_cpus();
>  	}
>  
> -	cpu_read_bootcpu_ops();
>  #ifdef CONFIG_SMP
> -	smp_init_cpus();
>  	smp_build_mpidr_hash();
>  #endif
>  
> diff --git a/arch/arm64/kernel/smp.c b/arch/arm64/kernel/smp.c
> index 4743397..4e390ac 100644
> --- a/arch/arm64/kernel/smp.c
> +++ b/arch/arm64/kernel/smp.c
> @@ -321,7 +321,7 @@ void __init smp_prepare_boot_cpu(void)
>   * cpu logical map array containing MPIDR values related to logical
>   * cpus. Assumes that cpu_logical_map(0) has already been initialized.
>   */
> -void __init smp_init_cpus(void)
> +void __init of_smp_init_cpus(void)
>  {
>  	struct device_node *dn = NULL;
>  	unsigned int i, cpu = 1;
> -- 
> 1.7.9.5
> 
> 

