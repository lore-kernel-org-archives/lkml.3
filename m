Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756471AbaIOXeW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 19:34:22 -0400
Received: from mail-pa0-f52.google.com ([209.85.220.52]:47358 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755972AbaIOXeT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 19:34:19 -0400
Message-ID: <54177778.2050103@linaro.org>
Date: Tue, 16 Sep 2014 07:34:16 +0800
From: Hanjun Guo <hanjun.guo@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Olof Johansson <olof@lixom.net>
CC: Catalin Marinas <catalin.marinas@arm.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Mark Rutland <mark.rutland@arm.com>,
        Grant Likely <grant.likely@linaro.org>,
        Will Deacon <will.deacon@arm.com>,
        Graeme Gregory <graeme.gregory@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, Sudeep Holla <Sudeep.Holla@arm.com>,
        Jon Masters <jcm@redhat.com>, Jason Cooper <jason@lakedaemon.net>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Mark Brown <broonie@kernel.org>, Rob Herring <robh@kernel.org>,
        Robert Richter <rric@kernel.org>, Lv Zheng <lv.zheng@intel.com>,
        Robert Moore <robert.moore@intel.com>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Liviu Dudau <Liviu.Dudau@arm.com>,
        Randy Dunlap <rdunlap@infradead.org>, Charles.Garcia-Tobin@arm.com,
        linux-acpi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linaro-acpi@lists.linaro.org,
        Tomasz Nowicki <tomasz.nowicki@linaro.org>
Subject: Re: [PATCH v4 09/18] ARM64 / ACPI: Parse FADT table to get PSCI flags
 for PSCI init
References: <1410530416-30200-1-git-send-email-hanjun.guo@linaro.org> <1410530416-30200-10-git-send-email-hanjun.guo@linaro.org> <20140915063808.GC26649@localhost>
In-Reply-To: <20140915063808.GC26649@localhost>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014年09月15日 14:38, Olof Johansson wrote:
> On Fri, Sep 12, 2014 at 10:00:07PM +0800, Hanjun Guo wrote:
>> diff --git a/arch/arm64/include/asm/psci.h b/arch/arm64/include/asm/psci.h
>> index e5312ea..2454bc5 100644
>> --- a/arch/arm64/include/asm/psci.h
>> +++ b/arch/arm64/include/asm/psci.h
>> @@ -14,6 +14,7 @@
>>  #ifndef __ASM_PSCI_H
>>  #define __ASM_PSCI_H
>>  
>> -int psci_init(void);
>> +int psci_dt_init(void);
>> +int psci_acpi_init(void);
>>  
>>  #endif /* __ASM_PSCI_H */
>> diff --git a/arch/arm64/kernel/acpi.c b/arch/arm64/kernel/acpi.c
>> index 693da7f..9e1ae37 100644
>> --- a/arch/arm64/kernel/acpi.c
>> +++ b/arch/arm64/kernel/acpi.c
>> @@ -13,6 +13,8 @@
>>   *  published by the Free Software Foundation.
>>   */
>>  
>> +#define pr_fmt(fmt) "ACPI: " fmt
>> +
>>  #include <linux/init.h>
>>  #include <linux/acpi.h>
>>  #include <linux/cpumask.h>
>> @@ -49,10 +51,32 @@ void __init __acpi_unmap_table(char *map, unsigned long size)
>>  	early_memunmap(map, size);
>>  }
>>  
>> +static int __init acpi_parse_fadt(struct acpi_table_header *table)
>> +{
>> +	struct acpi_table_fadt *fadt = (struct acpi_table_fadt *)table;
>> +
>> +	/*
>> +	 * Revision in table header is the FADT Major revision,
>> +	 * and there is a minor revision of FADT which was introduced
>> +	 * by ACPI 5.1, we only deal with ACPI 5.1 or higher revision
>> +	 * to get arm boot flags, or we will disable ACPI.
>> +	 */
>> +	if (table->revision > 5 ||
>> +	    (table->revision == 5 && fadt->minor_revision >= 1))
>> +		return 0;
> The commend and code disagree. The code says 5.1 or newer, while the comment say
> _only_ 5.1. One or the other needs to change.

I describe it in the comments "ACPI 5.1 or higher revision", maybe
"newer revision" will be more explicit.

>
> [...]
>
>> diff --git a/arch/arm64/kernel/psci.c b/arch/arm64/kernel/psci.c
>> index 5539547..15ba470 100644
>> --- a/arch/arm64/kernel/psci.c
>> +++ b/arch/arm64/kernel/psci.c
>> @@ -15,6 +15,7 @@
>>  
>>  #define pr_fmt(fmt) "psci: " fmt
>>  
>> +#include <linux/acpi.h>
>>  #include <linux/init.h>
>>  #include <linux/of.h>
>>  #include <linux/smp.h>
>> @@ -23,6 +24,7 @@
>>  #include <linux/delay.h>
>>  #include <uapi/linux/psci.h>
>>  
>> +#include <asm/acpi.h>
>>  #include <asm/compiler.h>
>>  #include <asm/cpu_ops.h>
>>  #include <asm/errno.h>
>> @@ -231,6 +233,33 @@ static void psci_sys_poweroff(void)
>>  	invoke_psci_fn(PSCI_0_2_FN_SYSTEM_OFF, 0, 0, 0);
>>  }
>>  
>> +static void psci_0_2_set_functions(void)
>> +{
>> +	pr_info("Using standard PSCI v0.2 function IDs\n");
>> +	psci_function_id[PSCI_FN_CPU_SUSPEND] = PSCI_0_2_FN64_CPU_SUSPEND;
>> +	psci_ops.cpu_suspend = psci_cpu_suspend;
>> +
>> +	psci_function_id[PSCI_FN_CPU_OFF] = PSCI_0_2_FN_CPU_OFF;
>> +	psci_ops.cpu_off = psci_cpu_off;
>> +
>> +	psci_function_id[PSCI_FN_CPU_ON] = PSCI_0_2_FN64_CPU_ON;
>> +	psci_ops.cpu_on = psci_cpu_on;
>> +
>> +	psci_function_id[PSCI_FN_MIGRATE] = PSCI_0_2_FN64_MIGRATE;
>> +	psci_ops.migrate = psci_migrate;
>> +
>> +	psci_function_id[PSCI_FN_AFFINITY_INFO] = PSCI_0_2_FN64_AFFINITY_INFO;
>> +	psci_ops.affinity_info = psci_affinity_info;
>> +
>> +	psci_function_id[PSCI_FN_MIGRATE_INFO_TYPE] =
>> +		PSCI_0_2_FN_MIGRATE_INFO_TYPE;
>> +	psci_ops.migrate_info_type = psci_migrate_info_type;
>> +
>> +	arm_pm_restart = psci_sys_reset;
>> +
>> +	pm_power_off = psci_sys_poweroff;
>> +}
>> +
>>  /*
>>   * PSCI Function IDs for v0.2+ are well defined so use
>>   * standard values.
>> @@ -264,29 +293,7 @@ static int __init psci_0_2_init(struct device_node *np)
>>  		}
>>  	}
>>  
>> -	pr_info("Using standard PSCI v0.2 function IDs\n");
>> -	psci_function_id[PSCI_FN_CPU_SUSPEND] = PSCI_0_2_FN64_CPU_SUSPEND;
>> -	psci_ops.cpu_suspend = psci_cpu_suspend;
>> -
>> -	psci_function_id[PSCI_FN_CPU_OFF] = PSCI_0_2_FN_CPU_OFF;
>> -	psci_ops.cpu_off = psci_cpu_off;
>> -
>> -	psci_function_id[PSCI_FN_CPU_ON] = PSCI_0_2_FN64_CPU_ON;
>> -	psci_ops.cpu_on = psci_cpu_on;
>> -
>> -	psci_function_id[PSCI_FN_MIGRATE] = PSCI_0_2_FN64_MIGRATE;
>> -	psci_ops.migrate = psci_migrate;
>> -
>> -	psci_function_id[PSCI_FN_AFFINITY_INFO] = PSCI_0_2_FN64_AFFINITY_INFO;
>> -	psci_ops.affinity_info = psci_affinity_info;
>> -
>> -	psci_function_id[PSCI_FN_MIGRATE_INFO_TYPE] =
>> -		PSCI_0_2_FN_MIGRATE_INFO_TYPE;
>> -	psci_ops.migrate_info_type = psci_migrate_info_type;
>> -
>> -	arm_pm_restart = psci_sys_reset;
>> -
>> -	pm_power_off = psci_sys_poweroff;
>> +	psci_0_2_set_functions();
>>  
>>  out_put_node:
>>  	of_node_put(np);
>> @@ -339,7 +346,7 @@ static const struct of_device_id psci_of_match[] __initconst = {
>>  	{},
>>  };
>>  
>> -int __init psci_init(void)
>> +int __init psci_dt_init(void)
>>  {
>>  	struct device_node *np;
>>  	const struct of_device_id *matched_np;
>> @@ -354,6 +361,29 @@ int __init psci_init(void)
>>  	return init_fn(np);
>>  }
>>  
>> +/*
>> + * We use PSCI 0.2+ when ACPI is deployed on ARM64 and it's
>> + * explicitly clarified in SBBR
>> + */
>> +int __init psci_acpi_init(void)
>> +{
>> +	if (!acpi_psci_present()) {
>> +		pr_info("is not implemented in ACPI.\n");
>> +		return -EOPNOTSUPP;
>> +	}
>> +
>> +	pr_info("probing for conduit method from ACPI.\n");
>> +
>> +	if (acpi_psci_use_hvc())
>> +		invoke_psci_fn = __invoke_psci_fn_hvc;
>> +	else
>> +		invoke_psci_fn = __invoke_psci_fn_smc;
>> +
>> +	psci_0_2_set_functions();
>> +
>> +	return 0;
>> +}
>> +
>>  #ifdef CONFIG_SMP
>>  
>>  static int __init cpu_psci_cpu_init(struct device_node *dn, unsigned int cpu)
>> diff --git a/arch/arm64/kernel/setup.c b/arch/arm64/kernel/setup.c
>> index 5796734..7ba20d4 100644
>> --- a/arch/arm64/kernel/setup.c
>> +++ b/arch/arm64/kernel/setup.c
>> @@ -398,10 +398,12 @@ void __init setup_arch(char **cmdline_p)
>>  	efi_idmap_init();
>>  
>>  	cpu_logical_map(0) = read_cpuid_mpidr() & MPIDR_HWID_BITMASK;
>> -	if (acpi_disabled)
>> +	if (acpi_disabled) {
>>  		unflatten_device_tree();
>> -
>> -	psci_init();
>> +		psci_dt_init();
>> +	} else {
>> +		psci_acpi_init();
>> +	}
> This is slightly nitty now, but I think it'd be slightly easier to follow
> boot path if the switch for acpi disabled/enabled was in psci.c. It'd also allow
> psci_dt_init() and psci_acpi_init() to be static.
>
> I.e. keep a psci_init() and just make it call one or the other.

Do you mean something like blow in psci.c?

int __init psci_init(void)
{
if (acpi_disabled)
return psci_dt_init();
else
return psci_acpi_init();
}

Thanks
Hanjun
