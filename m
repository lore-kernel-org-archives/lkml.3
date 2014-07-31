Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752412AbaGaSwP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 14:52:15 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:41704 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750952AbaGaSwN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 14:52:13 -0400
Message-ID: <1406832724.8971.29.camel@smoke>
Subject: Re: [PATCH 10/19] ARM64 / ACPI: Get the enable method for SMP
 initialization in ACPI way
From: Geoff Levand <geoff@infradead.org>
To: Hanjun Guo <hanjun.guo@linaro.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Mark Rutland <mark.rutland@arm.com>, Mark Brown <broonie@linaro.org>,
        Liviu Dudau <Liviu.Dudau@arm.com>, Lv Zheng <lv.zheng@intel.com>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Robert Moore <robert.moore@intel.com>, linux-acpi@vger.kernel.org,
        Grant Likely <grant.likely@linaro.org>, Charles.Garcia-Tobin@arm.com,
        Robert Richter <rric@kernel.org>, Jason Cooper <jason@lakedaemon.net>,
        Arnd Bergmann <arnd@arndb.de>, Marc Zyngier <marc.zyngier@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Tomasz Nowicki <tomasz.nowicki@linaro.org>,
        linaro-acpi-private@linaro.org, Bjorn Helgaas <bhelgaas@google.com>,
        linux-arm-kernel@lists.infradead.org,
        Graeme Gregory <graeme.gregory@linaro.org>,
        Randy Dunlap <rdunlap@infradead.org>, linux-kernel@vger.kernel.org,
        Sudeep Holla <Sudeep.Holla@arm.com>
Date: Thu, 31 Jul 2014 11:52:04 -0700
In-Reply-To: <1406206825-15590-11-git-send-email-hanjun.guo@linaro.org>
References: <1406206825-15590-1-git-send-email-hanjun.guo@linaro.org>
	 <1406206825-15590-11-git-send-email-hanjun.guo@linaro.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Hanjun,

On Thu, 2014-07-24 at 21:00 +0800, Hanjun Guo wrote:
> ACPI 5.1 only has two explicit methods to boot up SMP,
> PSCI and Parking protocol, but the Parking protocol is
> only suitable for ARMv7 now, so make PSCI as the only way
> for the SMP boot protocol before some updates for the
> ACPI spec or the Parking protocol spec.
> 
> Signed-off-by: Hanjun Guo <hanjun.guo@linaro.org>
> Signed-off-by: Tomasz Nowicki <tomasz.nowicki@linaro.org>
> ---
>  arch/arm64/include/asm/acpi.h    |   21 +++++++++++++++
>  arch/arm64/include/asm/cpu_ops.h |    9 ++++++-
>  arch/arm64/include/asm/smp.h     |    2 +-
>  arch/arm64/kernel/acpi.c         |    9 +++++++
>  arch/arm64/kernel/cpu_ops.c      |   52 ++++++++++++++++++++++++++++++++++----
>  arch/arm64/kernel/smp.c          |   29 +++++++++++++++++++--
>  6 files changed, 113 insertions(+), 9 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/acpi.h b/arch/arm64/include/asm/acpi.h
> index 5ce85f8..6240327 100644
> --- a/arch/arm64/include/asm/acpi.h
> +++ b/arch/arm64/include/asm/acpi.h
> @@ -14,6 +14,27 @@
>  
>  /* Basic configuration for ACPI */
>  #ifdef	CONFIG_ACPI

^^ This seems to be a tab (\t) character here, which is a strange thing
for me to see...

> +/*
> + * ACPI 5.1 only has two explicit methods to
> + * boot up SMP, PSCI and Parking protocol,
> + * but the Parking protocol is only defined
> + * for ARMv7 now, so make PSCI as the only
> + * way for the SMP boot protocol before some
> + * updates for the ACPI spec or the Parking
> + * protocol spec.
> + *
> + * This enum is intend to make the boot method
> + * scalable when above updates are happended,
> + * which NOT means to support all of them.
> + */

This comment will become out of date soon (I hope), and it is often the
case that these short term comments are not removed, so I think it
better to put this kind of note into the commit message, not the code.

> +enum acpi_smp_boot_protocol {
> +	ACPI_SMP_BOOT_PSCI,
> +	ACPI_SMP_BOOT_PARKING_PROTOCOL,
> +	ACPI_SMP_BOOT_PROTOCOL_MAX
> +};
> +
> +enum acpi_smp_boot_protocol smp_boot_protocol(void);
> +
>  extern int acpi_disabled;
>  extern int acpi_noirq;
>  extern int acpi_pci_disabled;
> diff --git a/arch/arm64/include/asm/cpu_ops.h b/arch/arm64/include/asm/cpu_ops.h
> index d7b4b38..2a7c6fd 100644
> --- a/arch/arm64/include/asm/cpu_ops.h
> +++ b/arch/arm64/include/asm/cpu_ops.h
> @@ -61,7 +61,14 @@ struct cpu_operations {
>  };
>  
>  extern const struct cpu_operations *cpu_ops[NR_CPUS];
> -extern int __init cpu_read_ops(struct device_node *dn, int cpu);
> +extern int __init cpu_of_read_ops(struct device_node *dn, int cpu);
> +
> +#ifdef CONFIG_ACPI
> +extern int __init cpu_acpi_read_ops(int cpu);
> +#else
> +static inline int __init cpu_acpi_read_ops(int cpu) { return -ENODEV; }
> +#endif

This looks messy and not scalable for new enable methods.  It
seems a better way is to retain cpu_read_ops() and its functionality,
which is to return the proper enable method for that cpu in a generic
way.

Is there some reason you can't integrate acpi into the existing
cpu_ops and need to make this completely parallel method?

>  extern void __init cpu_read_bootcpu_ops(void);
>  
>  #endif /* ifndef __ASM_CPU_OPS_H */
> diff --git a/arch/arm64/include/asm/smp.h b/arch/arm64/include/asm/smp.h
> index a498f2c..a5cea56 100644
> --- a/arch/arm64/include/asm/smp.h
> +++ b/arch/arm64/include/asm/smp.h
> @@ -39,7 +39,7 @@ extern void show_ipi_list(struct seq_file *p, int prec);
>  extern void handle_IPI(int ipinr, struct pt_regs *regs);
>  
>  /*
> - * Setup the set of possible CPUs (via set_cpu_possible)
> + * Platform specific SMP operations
>   */
>  extern void smp_init_cpus(void);
>  
> diff --git a/arch/arm64/kernel/acpi.c b/arch/arm64/kernel/acpi.c
> index ff0f6a0..2af6662 100644
> --- a/arch/arm64/kernel/acpi.c
> +++ b/arch/arm64/kernel/acpi.c
> @@ -184,6 +184,15 @@ static int __init acpi_parse_madt_gic_cpu_interface_entries(void)
>  	return 0;
>  }
>  
> +/* Protocol to bring up secondary CPUs */
> +enum acpi_smp_boot_protocol smp_boot_protocol(void)
> +{
> +	if (acpi_psci_present)
> +		return ACPI_SMP_BOOT_PSCI;
> +	else
> +		return ACPI_SMP_BOOT_PARKING_PROTOCOL;
> +}
> +
>  static int __init acpi_parse_fadt(struct acpi_table_header *table)
>  {
>  	struct acpi_table_fadt *fadt = (struct acpi_table_fadt *)table;
> diff --git a/arch/arm64/kernel/cpu_ops.c b/arch/arm64/kernel/cpu_ops.c
> index d62d12f..4d9b3cf 100644
> --- a/arch/arm64/kernel/cpu_ops.c
> +++ b/arch/arm64/kernel/cpu_ops.c
> @@ -16,11 +16,13 @@
>   * along with this program.  If not, see <http://www.gnu.org/licenses/>.
>   */
>  
> -#include <asm/cpu_ops.h>
> -#include <asm/smp_plat.h>
>  #include <linux/errno.h>
>  #include <linux/of.h>
>  #include <linux/string.h>
> +#include <linux/acpi.h>
> +
> +#include <asm/cpu_ops.h>
> +#include <asm/smp_plat.h>
>  
>  extern const struct cpu_operations smp_spin_table_ops;
>  extern const struct cpu_operations cpu_psci_ops;
> @@ -52,7 +54,7 @@ static const struct cpu_operations * __init cpu_get_ops(const char *name)
>  /*
>   * Read a cpu's enable method from the device tree and record it in cpu_ops.
>   */
> -int __init cpu_read_ops(struct device_node *dn, int cpu)
> +int __init cpu_of_read_ops(struct device_node *dn, int cpu)
>  {
>  	const char *enable_method = of_get_property(dn, "enable-method", NULL);
>  	if (!enable_method) {
> @@ -76,12 +78,52 @@ int __init cpu_read_ops(struct device_node *dn, int cpu)
>  	return 0;
>  }
>  
> +#ifdef CONFIG_ACPI
> +/*
> + * Read a cpu's enable method in the ACPI way and record it in cpu_ops.
> + */
> +int __init cpu_acpi_read_ops(int cpu)
> +{
> +	/*
> +	 * For ACPI 5.1, only two kind of methods are provided,
> +	 * Parking protocol and PSCI, but Parking protocol is
> +	 * used on ARMv7 only, so make PSCI as the only method
> +	 * for SMP initialization before the ACPI spec or Parking
> +	 * protocol spec is updated.
> +	 */

Again, this comment will get old fast (I hope).

> +	switch (smp_boot_protocol()) {
> +	case ACPI_SMP_BOOT_PSCI:
> +		cpu_ops[cpu] = cpu_get_ops("psci");
> +		break;
> +	case ACPI_SMP_BOOT_PARKING_PROTOCOL:
> +	default:
> +		cpu_ops[cpu] = NULL;
> +		break;
> +	}
> +
> +	if (!cpu_ops[cpu]) {
> +		pr_warn("CPU %d: unsupported enable-method, only PSCI is supported\n",
> +			cpu);
> +		return -EOPNOTSUPP;
> +	}
> +
> +	return 0;
> +}
> +#endif
> +
>  void __init cpu_read_bootcpu_ops(void)
>  {
> -	struct device_node *dn = of_get_cpu_node(0, NULL);
> +	struct device_node *dn;
> +
> +	if (!acpi_disabled) {
> +		cpu_acpi_read_ops(0);
> +		return;
> +	}
> +
> +	dn = of_get_cpu_node(0, NULL);
>  	if (!dn) {
>  		pr_err("Failed to find device node for boot cpu\n");
>  		return;
>  	}
> -	cpu_read_ops(dn, 0);
> +	cpu_of_read_ops(dn, 0);
>  }
> diff --git a/arch/arm64/kernel/smp.c b/arch/arm64/kernel/smp.c
> index 8f1d37c..cb71662 100644
> --- a/arch/arm64/kernel/smp.c
> +++ b/arch/arm64/kernel/smp.c
> @@ -315,7 +315,7 @@ static void (*smp_cross_call)(const struct cpumask *, unsigned int);
>   * cpu logical map array containing MPIDR values related to logical
>   * cpus. Assumes that cpu_logical_map(0) has already been initialized.
>   */
> -void __init smp_init_cpus(void)
> +static void __init of_smp_init_cpus(void)
>  {
>  	struct device_node *dn = NULL;
>  	unsigned int i, cpu = 1;
> @@ -387,7 +387,7 @@ void __init smp_init_cpus(void)
>  		if (cpu >= NR_CPUS)
>  			goto next;
>  
> -		if (cpu_read_ops(dn, cpu) != 0)
> +		if (cpu_of_read_ops(dn, cpu) != 0)
>  			goto next;
>  
>  		if (cpu_ops[cpu]->cpu_init(dn, cpu))
> @@ -418,6 +418,31 @@ next:
>  			set_cpu_possible(i, true);
>  }
>  
> +/*
> + * In ACPI mode, the cpu possible map was enumerated before SMP
> + * initialization when MADT table was parsed, so we can get the
> + * possible map here to initialize CPUs.
> + */
> +static void __init acpi_smp_init_cpus(void)
> +{
> +	int cpu;
> +
> +	for_each_possible_cpu(cpu) {
> +		if (cpu_acpi_read_ops(cpu) != 0)
> +			continue;
> +
> +		cpu_ops[cpu]->cpu_init(NULL, cpu);
> +	}
> +}
> +
> +void __init smp_init_cpus(void)
> +{
> +	if (acpi_disabled)
> +		of_smp_init_cpus();
> +	else
> +		acpi_smp_init_cpus();
> +}

This is the same as cpu_ops, is acpi so special we need a completely
parallel method of initializing secondary cpus?

-Geoff

