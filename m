Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752183AbaHSKlh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 06:41:37 -0400
Received: from mail-pd0-f174.google.com ([209.85.192.174]:41557 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751492AbaHSKle (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 06:41:34 -0400
Message-ID: <53F3297A.1040309@linaro.org>
Date: Tue, 19 Aug 2014 18:39:54 +0800
From: Hanjun Guo <hanjun.guo@linaro.org>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Sudeep Holla <sudeep.holla@arm.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Mark Rutland <Mark.Rutland@arm.com>
CC: "graeme.gregory@linaro.org" <graeme.gregory@linaro.org>,
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
        "linaro-acpi@lists.linaro.org" <linaro-acpi@lists.linaro.org>
Subject: Re: [PATCH v2 05/18] ARM64 / ACPI: Parse FADT table to get PSCI flags
 for PSCI init
References: <1407166105-17675-1-git-send-email-hanjun.guo@linaro.org> <1407166105-17675-6-git-send-email-hanjun.guo@linaro.org> <53F246D4.7040807@arm.com>
In-Reply-To: <53F246D4.7040807@arm.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-8-19 2:32, Sudeep Holla wrote:
> On 04/08/14 16:28, Hanjun Guo wrote:
>> There are two flags: PSCI_COMPLIANT and PSCI_USE_HVC. When set,
>> the former signals to the OS that the hardware is PSCI compliant.
>> The latter selects the appropriate conduit for PSCI calls by
>> toggling between Hypervisor Calls (HVC) and Secure Monitor Calls
>> (SMC).
>>
>> FADT table contains such information, parse FADT to get the flags
>> for PSCI init. Since ACPI 5.1 doesn't support self defined PSCI
>> function IDs, which means that only PSCI 0.2+ is supported in ACPI.
>>
>> At the same time, only ACPI 5.1 or higher verison supports PSCI,
>> and FADT Major.Minor version was introduced in ACPI 5.1, so we
>> will check the version and only parse FADT table with version >= 5.1.
>>
>> If firmware provides ACPI tables with ACPI version less than 5.1,
>> OS will be messed up with those information and have no way to
>> bring up secondery CPUs, so disable ACPI if we get an FADT table
>> with version less that 5.1.
>>
[...]
>>
>> +static int __init acpi_parse_fadt(struct acpi_table_header *table)
>> +{
>> +    struct acpi_table_fadt *fadt = (struct acpi_table_fadt *)table;
>> +
>> +    /*
>> +     * Revision in table header is the FADT Major version,
>> +     * and there is a minor version of FADT which was introduced
>> +     * by ACPI 5.1, we only deal with ACPI 5.1 or higher version
>> +     * to get arm boot flags, or we will disable ACPI.
>> +     */
>> +    if (table->revision < 5 || fadt->minor_revision < 1) {
> 
>                 &&

Catalin also pointed out this bug :), but && is not enough, for example,
this would not trigger of revision 4.1, although 4.1 is not exist, but
the code will still confusing people, so I updated the code as:

+       if (table->revision > 5 ||
+           (table->revision == 5 && fadt->minor_revision >= 1)) {
+               return 0;
+       } else {
+               pr_info("FADT revision is %d.%d, no PSCI support, should be 5.1
or higher\n",
+                       table->revision, fadt->minor_revision);
+               disable_acpi();
+               return -EINVAL;
+       }

> 
>> +        pr_info("FADT version is %d.%d, no PSCI support, should be 5.1 or
>> higher\n",
>> +            table->revision, fadt->minor_revision);
>> +        disable_acpi();
> 
> Instead of disabling ACPI at multiple places in the boot sequence, can't
> it be done once if acpi_boot_init failed ?
> 
>> +        return -EINVAL;
>> +    }
>> +
>> +    return 0;
>> +}
>> +
>>   /*
>>    * acpi_boot_table_init() called from setup_arch(), always.
>>    *    1. find RSDP and get its address, and then find XSDT
>> @@ -68,6 +90,21 @@ void __init acpi_boot_table_init(void)
>>       }
>>   }
>>
>> +int __init acpi_boot_init(void)
>> +{
>> +    int err = 0;
>> +
>> +    /* If acpi_disabled, bail out */
>> +    if (acpi_disabled)
>> +        return -ENODEV;
>> +
>> +    err = acpi_table_parse(ACPI_SIG_FADT, acpi_parse_fadt);
>> +    if (err)
>> +        pr_err("Can't find FADT\n");
>> +
>> +    return err;
>> +}
>> +
>>   /*
>>    * acpi_suspend_lowlevel() - save kernel state and suspend.
>>    *
>> diff --git a/arch/arm64/kernel/psci.c b/arch/arm64/kernel/psci.c
>> index 9e9798f..2ad2084 100644
>> --- a/arch/arm64/kernel/psci.c
>> +++ b/arch/arm64/kernel/psci.c
>> @@ -15,6 +15,7 @@
>>
>>   #define pr_fmt(fmt) "psci: " fmt
>>
>> +#include <linux/acpi.h>
>>   #include <linux/init.h>
>>   #include <linux/of.h>
>>   #include <linux/smp.h>
>> @@ -231,6 +232,33 @@ static void psci_sys_poweroff(void)
>>       invoke_psci_fn(PSCI_0_2_FN_SYSTEM_OFF, 0, 0, 0);
>>   }
>>
>> +static void psci_0_2_set_functions(void)
>> +{
>> +    pr_info("Using standard PSCI v0.2 function IDs\n");
>> +    psci_function_id[PSCI_FN_CPU_SUSPEND] = PSCI_0_2_FN64_CPU_SUSPEND;
>> +    psci_ops.cpu_suspend = psci_cpu_suspend;
>> +
>> +    psci_function_id[PSCI_FN_CPU_OFF] = PSCI_0_2_FN_CPU_OFF;
>> +    psci_ops.cpu_off = psci_cpu_off;
>> +
>> +    psci_function_id[PSCI_FN_CPU_ON] = PSCI_0_2_FN64_CPU_ON;
>> +    psci_ops.cpu_on = psci_cpu_on;
>> +
>> +    psci_function_id[PSCI_FN_MIGRATE] = PSCI_0_2_FN64_MIGRATE;
>> +    psci_ops.migrate = psci_migrate;
>> +
>> +    psci_function_id[PSCI_FN_AFFINITY_INFO] = PSCI_0_2_FN64_AFFINITY_INFO;
>> +    psci_ops.affinity_info = psci_affinity_info;
>> +
>> +    psci_function_id[PSCI_FN_MIGRATE_INFO_TYPE] =
>> +        PSCI_0_2_FN_MIGRATE_INFO_TYPE;
>> +    psci_ops.migrate_info_type = psci_migrate_info_type;
>> +
>> +    arm_pm_restart = psci_sys_reset;
>> +
>> +    pm_power_off = psci_sys_poweroff;
>> +}
>> +
> 
> Nit: IMO may be you can move these refactoring as separate patch before
> ACPI related changes ?

I'm ok with it, will format another patch and place it in the
beginning of this patch set.

> 
>>   /*
>>    * PSCI Function IDs for v0.2+ are well defined so use
>>    * standard values.
>> @@ -264,29 +292,7 @@ static int psci_0_2_init(struct device_node *np)
>>           }
>>       }
>>
>> -    pr_info("Using standard PSCI v0.2 function IDs\n");
>> -    psci_function_id[PSCI_FN_CPU_SUSPEND] = PSCI_0_2_FN64_CPU_SUSPEND;
>> -    psci_ops.cpu_suspend = psci_cpu_suspend;
>> -
>> -    psci_function_id[PSCI_FN_CPU_OFF] = PSCI_0_2_FN_CPU_OFF;
>> -    psci_ops.cpu_off = psci_cpu_off;
>> -
>> -    psci_function_id[PSCI_FN_CPU_ON] = PSCI_0_2_FN64_CPU_ON;
>> -    psci_ops.cpu_on = psci_cpu_on;
>> -
>> -    psci_function_id[PSCI_FN_MIGRATE] = PSCI_0_2_FN64_MIGRATE;
>> -    psci_ops.migrate = psci_migrate;
>> -
>> -    psci_function_id[PSCI_FN_AFFINITY_INFO] = PSCI_0_2_FN64_AFFINITY_INFO;
>> -    psci_ops.affinity_info = psci_affinity_info;
>> -
>> -    psci_function_id[PSCI_FN_MIGRATE_INFO_TYPE] =
>> -        PSCI_0_2_FN_MIGRATE_INFO_TYPE;
>> -    psci_ops.migrate_info_type = psci_migrate_info_type;
>> -
>> -    arm_pm_restart = psci_sys_reset;
>> -
>> -    pm_power_off = psci_sys_poweroff;
>> +    psci_0_2_set_functions();
>>
>>   out_put_node:
>>       of_node_put(np);
>> @@ -333,6 +339,40 @@ out_put_node:
>>       return err;
>>   }
>>
>> +#ifdef CONFIG_ACPI
>> +static int get_set_conduit_method_acpi(void)
>> +{
>> +    pr_info("probing for conduit method from ACPI.\n");
>> +
>> +    if (acpi_psci_use_hvc())
>> +        invoke_psci_fn = __invoke_psci_fn_hvc;
>> +    else
>> +        invoke_psci_fn = __invoke_psci_fn_smc;
>> +
>> +    return 0;
>> +}
>> +
>> +/* We use PSCI 0.2+ when ACPI is deployed */
>> +static int psci_0_2_init_acpi(void)
> 
> May be this can be renamed psci_acpi_init and called from setup directly
> instead of calling from DT function with acpi_disabled check.

Also suggested by Catalin, will do it :)

> 
>> +{
>> +    if (!acpi_psci_present()) {
>> +        pr_info("is not implemented in ACPI.\n");
>> +        return -EOPNOTSUPP;
>> +    }
>> +
>> +    get_set_conduit_method_acpi();
>> +
>> +    psci_0_2_set_functions();
>> +
>> +    return 0;
>> +}
>> +#else
>> +static inline int psci_0_2_init_acpi(void)
>> +{
>> +    return -ENODEV;
>> +}
>> +#endif
>> +
>>   static const struct of_device_id psci_of_match[] __initconst = {
>>       { .compatible = "arm,psci",    .data = psci_0_1_init},
>>       { .compatible = "arm,psci-0.2",    .data = psci_0_2_init},
>> @@ -345,6 +385,9 @@ int __init psci_init(void)
>>       const struct of_device_id *matched_np;
>>       psci_initcall_t init_fn;
>>
>> +    if (!acpi_disabled)
>> +        return psci_0_2_init_acpi();
>> +
> 
> As mentioned above you need not modify this.
> 
>>       np = of_find_matching_node_and_match(NULL, psci_of_match, &matched_np);
>>
>>       if (!np)
>> diff --git a/arch/arm64/kernel/setup.c b/arch/arm64/kernel/setup.c
>> index 85c6326..dfc4e4f3 100644
>> --- a/arch/arm64/kernel/setup.c
>> +++ b/arch/arm64/kernel/setup.c
>> @@ -395,6 +395,8 @@ void __init setup_arch(char **cmdline_p)
>>       efi_idmap_init();
>>
>>       cpu_logical_map(0) = read_cpuid_mpidr() & MPIDR_HWID_BITMASK;
>> +    acpi_boot_init();
>> +
> 
> Check for the return error here and disable ACPI once rather than at
> multiple places all over.

ok.

Thanks
Hanjun

