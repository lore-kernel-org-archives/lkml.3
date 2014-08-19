Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752642AbaHSDwF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 23:52:05 -0400
Received: from mail-pd0-f169.google.com ([209.85.192.169]:44503 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752380AbaHSDwD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 23:52:03 -0400
Message-ID: <53F2C983.8000800@linaro.org>
Date: Tue, 19 Aug 2014 11:50:27 +0800
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
        "linaro-acpi@lists.linaro.org" <linaro-acpi@lists.linaro.org>
Subject: Re: [PATCH v2 05/18] ARM64 / ACPI: Parse FADT table to get PSCI flags
 for PSCI init
References: <1407166105-17675-1-git-send-email-hanjun.guo@linaro.org> <1407166105-17675-6-git-send-email-hanjun.guo@linaro.org> <20140818142721.GR20043@localhost>
In-Reply-To: <20140818142721.GR20043@localhost>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-8-18 22:27, Catalin Marinas wrote:
> On Mon, Aug 04, 2014 at 04:28:12PM +0100, Hanjun Guo wrote:
>> There are two flags: PSCI_COMPLIANT and PSCI_USE_HVC. When set,
>> the former signals to the OS that the hardware is PSCI compliant.
> 
> Actually it signals that the firmware is PSCI compliant. The hardware
> doesn't care much.

Right, I will update it.

> 
>> diff --git a/arch/arm64/include/asm/acpi.h b/arch/arm64/include/asm/acpi.h
>> index 6400312..6e04868 100644
>> --- a/arch/arm64/include/asm/acpi.h
>> +++ b/arch/arm64/include/asm/acpi.h
>> @@ -19,6 +19,18 @@ extern int acpi_disabled;
>>  extern int acpi_noirq;
>>  extern int acpi_pci_disabled;
>>  
>> +/* 1 to indicate PSCI 0.2+ is implemented */
>> +static inline bool acpi_psci_present(void)
>> +{
>> +	return !!(acpi_gbl_FADT.arm_boot_flags & ACPI_FADT_PSCI_COMPLIANT);
>> +}
>> +
>> +/* 1 to indicate HVC must be used instead of SMC as the PSCI conduit */
>> +static inline bool acpi_psci_use_hvc(void)
>> +{
>> +	return !!(acpi_gbl_FADT.arm_boot_flags & ACPI_FADT_PSCI_USE_HVC);
>> +}
> 
> Do we actually need !! here? Shouldn't the compiler figure out
> conversion to bool automatically?

I thought !! will explicitly show that it's a bool value and
improve the readability of the code, but I'm ok to remove !!
here.

> 
>> diff --git a/arch/arm64/kernel/acpi.c b/arch/arm64/kernel/acpi.c
>> index 9cf9127..69a315d 100644
>> --- a/arch/arm64/kernel/acpi.c
>> +++ b/arch/arm64/kernel/acpi.c
>> @@ -11,6 +11,8 @@
>>   *  published by the Free Software Foundation.
>>   */
>>  
>> +#define pr_fmt(fmt) "ACPI: " fmt
>> +
>>  #include <linux/init.h>
>>  #include <linux/acpi.h>
>>  #include <linux/cpumask.h>
>> @@ -47,6 +49,26 @@ void __init __acpi_unmap_table(char *map, unsigned long size)
>>  	early_memunmap(map, size);
>>  }
>>  
>> +static int __init acpi_parse_fadt(struct acpi_table_header *table)
>> +{
>> +	struct acpi_table_fadt *fadt = (struct acpi_table_fadt *)table;
>> +
>> +	/*
>> +	 * Revision in table header is the FADT Major version,
>> +	 * and there is a minor version of FADT which was introduced
>> +	 * by ACPI 5.1, we only deal with ACPI 5.1 or higher version
>> +	 * to get arm boot flags, or we will disable ACPI.
>> +	 */
>> +	if (table->revision < 5 || fadt->minor_revision < 1) {
> 
> If we ever get revision 6.0, this would trigger.

Yes, good catch, actually I already fixed that in my local git repo,

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
>> diff --git a/arch/arm64/kernel/setup.c b/arch/arm64/kernel/setup.c
>> index 85c6326..dfc4e4f3 100644
>> --- a/arch/arm64/kernel/setup.c
>> +++ b/arch/arm64/kernel/setup.c
>> @@ -395,6 +395,8 @@ void __init setup_arch(char **cmdline_p)
>>  	efi_idmap_init();
>>  
>>  	cpu_logical_map(0) = read_cpuid_mpidr() & MPIDR_HWID_BITMASK;
>> +	acpi_boot_init();
>> +
>>  	unflatten_device_tree();
> 
> Unless that's changed in a subsequent patch, do we still need to call
> unflatten_device_tree() if ACPI was successful?

No, we don't. in [PATCH v2 16/18], we will not call unflatten_device_tree()
if ACPI is successful. Since the CONFIG_ACPI is not enabled for ARM64 (will
enable it in the last patch), so acpi_boot_init() is a stub empty function
here.

> 
>>  	psci_init();
> 
> I would also rename this to something like psci_dt_init() and move the
> acpi_disabled check here rather than in the callee.

thanks for the suggestion, I will update my patch :)

Thanks
Hanjun


