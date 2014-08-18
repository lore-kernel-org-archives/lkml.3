Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752193AbaHRSc3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 14:32:29 -0400
Received: from service87.mimecast.com ([91.220.42.44]:58235 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751990AbaHRScZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 14:32:25 -0400
Message-ID: <53F2471D.2010203@arm.com>
Date: Mon, 18 Aug 2014 19:34:05 +0100
From: Sudeep Holla <sudeep.holla@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Hanjun Guo <hanjun.guo@linaro.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Mark Rutland <Mark.Rutland@arm.com>
CC: Sudeep Holla <sudeep.holla@arm.com>,
        "graeme.gregory@linaro.org" <graeme.gregory@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        Will Deacon <Will.Deacon@arm.com>, Jason Cooper <jason@lakedaemon.net>,
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
Subject: Re: [PATCH v2 08/18] ARM64 / ACPI: Get the enable method for SMP
 initialization in ACPI way
References: <1407166105-17675-1-git-send-email-hanjun.guo@linaro.org> <1407166105-17675-9-git-send-email-hanjun.guo@linaro.org>
In-Reply-To: <1407166105-17675-9-git-send-email-hanjun.guo@linaro.org>
X-OriginalArrivalTime: 18 Aug 2014 18:32:21.0878 (UTC) FILETIME=[BFCDE160:01CFBB12]
X-MC-Unique: 114081819322300701
Content-Type: text/plain; charset=WINDOWS-1252; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 04/08/14 16:28, Hanjun Guo wrote:
> ACPI 5.1 only has two explicit methods to boot up SMP,
> PSCI and Parking protocol, but the Parking protocol is
> only suitable for ARMv7 now, so make PSCI as the only way
> for the SMP boot protocol before some updates for the
> ACPI spec or the Parking protocol spec.
>
> Signed-off-by: Hanjun Guo <hanjun.guo@linaro.org>
> Signed-off-by: Tomasz Nowicki <tomasz.nowicki@linaro.org>
> ---
>   arch/arm64/include/asm/acpi.h |   21 ++++++++++++++
>   arch/arm64/include/asm/smp.h  |    3 +-
>   arch/arm64/kernel/acpi.c      |    9 ++++++
>   arch/arm64/kernel/cpu_ops.c   |   62 ++++++++++++++++++++++++++++++++++++-----
>   arch/arm64/kernel/smp.c       |   27 +++++++++++++++++-
>   5 files changed, 113 insertions(+), 9 deletions(-)
>
> diff --git a/arch/arm64/include/asm/acpi.h b/arch/arm64/include/asm/acpi.h
> index e877967..022f4ad 100644
> --- a/arch/arm64/include/asm/acpi.h
> +++ b/arch/arm64/include/asm/acpi.h
> @@ -14,6 +14,27 @@
>
>   /* Basic configuration for ACPI */
>   #ifdef	CONFIG_ACPI
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
> +enum acpi_smp_boot_protocol {
> +	ACPI_SMP_BOOT_PSCI,
> +	ACPI_SMP_BOOT_PARKING_PROTOCOL,
> +	ACPI_SMP_BOOT_PROTOCOL_MAX
> +};
> +
> +enum acpi_smp_boot_protocol smp_boot_protocol(void);
> +
>   #define acpi_strict 1	/* No out-of-spec workarounds on ARM64 */
>   extern int acpi_disabled;
>   extern int acpi_noirq;
> diff --git a/arch/arm64/include/asm/smp.h b/arch/arm64/include/asm/smp.h
> index a498f2c..282932c2 100644
> --- a/arch/arm64/include/asm/smp.h
> +++ b/arch/arm64/include/asm/smp.h
> @@ -39,7 +39,8 @@ extern void show_ipi_list(struct seq_file *p, int prec);
>   extern void handle_IPI(int ipinr, struct pt_regs *regs);
>
>   /*
> - * Setup the set of possible CPUs (via set_cpu_possible)
> + * Discover the set of possible CPUs and determine their
> + * SMP operations.
>    */
>   extern void smp_init_cpus(void);
>
> diff --git a/arch/arm64/kernel/acpi.c b/arch/arm64/kernel/acpi.c
> index 9e07d99..8a54b4e 100644
> --- a/arch/arm64/kernel/acpi.c
> +++ b/arch/arm64/kernel/acpi.c
> @@ -170,6 +170,15 @@ static int __init acpi_parse_madt_gic_cpu_interface_entries(void)
>   	return 0;
>   }
>
> +/* Protocol to bring up secondary CPUs */
> +enum acpi_smp_boot_protocol smp_boot_protocol(void)
> +{
> +	if (acpi_psci_present())
> +		return ACPI_SMP_BOOT_PSCI;
> +	else
> +		return ACPI_SMP_BOOT_PARKING_PROTOCOL;
> +}
> +

Which do you need this here ? Can't you use acpi_psci_present directly
in acpi_get_cpu_boot_method ?

>   static int __init acpi_parse_fadt(struct acpi_table_header *table)
>   {
>   	struct acpi_table_fadt *fadt = (struct acpi_table_fadt *)table;
> diff --git a/arch/arm64/kernel/cpu_ops.c b/arch/arm64/kernel/cpu_ops.c
> index d62d12f..05bc314 100644
> --- a/arch/arm64/kernel/cpu_ops.c
> +++ b/arch/arm64/kernel/cpu_ops.c
> @@ -16,11 +16,13 @@
>    * along with this program.  If not, see <http://www.gnu.org/licenses/>.
>    */
>
> -#include <asm/cpu_ops.h>
> -#include <asm/smp_plat.h>
>   #include <linux/errno.h>
>   #include <linux/of.h>
>   #include <linux/string.h>
> +#include <linux/acpi.h>
> +
> +#include <asm/cpu_ops.h>
> +#include <asm/smp_plat.h>
>
>   extern const struct cpu_operations smp_spin_table_ops;
>   extern const struct cpu_operations cpu_psci_ops;
> @@ -49,12 +51,44 @@ static const struct cpu_operations * __init cpu_get_ops(const char *name)
>   	return NULL;
>   }
>
> +#ifdef CONFIG_ACPI
> +/*
> + * Get a cpu's boot method in the ACPI way.
> + */
> +static char * __init acpi_get_cpu_boot_method(void)
> +{
> +	/*
> +	 * For ACPI 5.1, only two kind of methods are provided,
> +	 * Parking protocol and PSCI, but Parking protocol is
> +	 * specified for ARMv7 only, so make PSCI as the only method
> +	 * for SMP initialization before the ACPI spec or Parking
> +	 * protocol spec is updated.
> +	 */
> +	switch (smp_boot_protocol()) {
> +	case ACPI_SMP_BOOT_PSCI:
> +		return "psci";
> +	case ACPI_SMP_BOOT_PARKING_PROTOCOL:
> +	default:
> +		return NULL;
> +	}

Use acpi_psci_present as mentioned above.

> +}
> +#else
> +static inline char * __init acpi_get_cpu_boot_method(void) { return NULL; }
> +#endif
> +
>   /*
> - * Read a cpu's enable method from the device tree and record it in cpu_ops.
> + * Read a cpu's enable method and record it in cpu_ops.
>    */
>   int __init cpu_read_ops(struct device_node *dn, int cpu)
>   {
> -	const char *enable_method = of_get_property(dn, "enable-method", NULL);
> +	const char *enable_method;
> +
> +	if (!acpi_disabled) {
> +		enable_method = acpi_get_cpu_boot_method();
> +		goto get_ops;
> +	}
> +
> +	enable_method = of_get_property(dn, "enable-method", NULL);
>   	if (!enable_method) {
>   		/*
>   		 * The boot CPU may not have an enable method (e.g. when
> @@ -66,10 +100,17 @@ int __init cpu_read_ops(struct device_node *dn, int cpu)
>   		return -ENOENT;
>   	}
>
> +get_ops:
>   	cpu_ops[cpu] = cpu_get_ops(enable_method);
>   	if (!cpu_ops[cpu]) {
> -		pr_warn("%s: unsupported enable-method property: %s\n",
> -			dn->full_name, enable_method);
> +		if (acpi_disabled) {
> +			pr_warn("%s: unsupported enable-method property: %s\n",
> +				dn->full_name, enable_method);
> +		} else {
> +			pr_warn("CPU %d: boot protocol unsupported or unknown\n",
> +				cpu);
> +		}
> +
>   		return -EOPNOTSUPP;
>   	}
>
> @@ -78,7 +119,14 @@ int __init cpu_read_ops(struct device_node *dn, int cpu)
>
>   void __init cpu_read_bootcpu_ops(void)
>   {
> -	struct device_node *dn = of_get_cpu_node(0, NULL);
> +	struct device_node *dn;
> +
> +	if (!acpi_disabled) {
> +		cpu_read_ops(NULL, 0);
> +		return;
> +	}
> +

Again not good to mix ACPI in DT functions forcing you to pass
device_node ptr as NULL, better to separate this. Once you gather all
this !acpi_disabled case, you can create appropriate abstractions to be
used in setup.c

E.g. here you check !acpi_disabled and pass NULL for DT node to
cpu_read_ops and hence again you check for !acpi_disabled in
cpu_read_ops. So you need first identify all these checks and put in one
place to understand well how you can refactor existing code to avoid
these multiple checks.


> +	dn = of_get_cpu_node(0, NULL);
>   	if (!dn) {
>   		pr_err("Failed to find device node for boot cpu\n");
>   		return;
> diff --git a/arch/arm64/kernel/smp.c b/arch/arm64/kernel/smp.c
> index 8f1d37c..e21bbc9 100644
> --- a/arch/arm64/kernel/smp.c
> +++ b/arch/arm64/kernel/smp.c
> @@ -315,7 +315,7 @@ static void (*smp_cross_call)(const struct cpumask *, unsigned int);
>    * cpu logical map array containing MPIDR values related to logical
>    * cpus. Assumes that cpu_logical_map(0) has already been initialized.
>    */
> -void __init smp_init_cpus(void)
> +static void __init of_smp_init_cpus(void)
>   {
>   	struct device_node *dn = NULL;
>   	unsigned int i, cpu = 1;
> @@ -418,6 +418,31 @@ next:
>   			set_cpu_possible(i, true);
>   }
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
> +		if (cpu_read_ops(NULL, cpu) != 0)
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
> +
>   void __init smp_prepare_cpus(unsigned int max_cpus)
>   {
>   	int err;
>

