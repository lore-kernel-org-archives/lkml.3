Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751957AbaAWP5S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 10:57:18 -0500
Received: from mail-ee0-f52.google.com ([74.125.83.52]:42235 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751710AbaAWP5Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 10:57:16 -0500
Message-ID: <52E13BBC.5020005@linaro.org>
Date: Thu, 23 Jan 2014 16:56:44 +0100
From: Tomasz Nowicki <tomasz.nowicki@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Hanjun Guo <hanjun.guo@linaro.org>
CC: Matthew Garrett <mjg59@srcf.ucam.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Arnd Bergmann <arnd@arndb.de>, Rob Herring <robh@kernel.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Olof Johansson <olof@lixom.net>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Will Deacon <Will.Deacon@arm.com>,
        "linaro-acpi@lists.linaro.org" <linaro-acpi@lists.linaro.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "patches@linaro.org" <patches@linaro.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [Linaro-acpi] [PATCH 04/20] ARM64 / ACPI: Introduce arm_core.c
 and its related head file
References: <1389961514-13562-1-git-send-email-hanjun.guo@linaro.org> <1389961514-13562-5-git-send-email-hanjun.guo@linaro.org> <20140122115453.GC24288@e102568-lin.cambridge.arm.com>
In-Reply-To: <20140122115453.GC24288@e102568-lin.cambridge.arm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Lorenzo,

W dniu 22.01.2014 12:54, Lorenzo Pieralisi pisze:
> On Fri, Jan 17, 2014 at 12:24:58PM +0000, Hanjun Guo wrote:
>
> [...]
>
>> diff --git a/arch/arm64/kernel/setup.c b/arch/arm64/kernel/setup.c
>> index bd9bbd0..2210353 100644
>> --- a/arch/arm64/kernel/setup.c
>> +++ b/arch/arm64/kernel/setup.c
>> @@ -41,6 +41,7 @@
>>   #include <linux/memblock.h>
>>   #include <linux/of_fdt.h>
>>   #include <linux/of_platform.h>
>> +#include <linux/acpi.h>
>>
>>   #include <asm/cputype.h>
>>   #include <asm/elf.h>
>> @@ -225,6 +226,11 @@ void __init setup_arch(char **cmdline_p)
>>
>>   	arm64_memblock_init();
>>
>> +	/* Parse the ACPI tables for possible boot-time configuration */
>> +	acpi_boot_table_init();
>> +	early_acpi_boot_init();
>> +	acpi_boot_init();
>> +
>>   	paging_init();
>
> Can I ask you please why we need to parse ACPI tables before
> paging_init() ?
This is for future usage and because of couple of reasons. Mainly SRAT 
table parsing should be done (before paging_init()) for proper NUMA 
initialization and then paging_init().

Regards,
Tomasz
>
> [...]
>
>> +/*
>> + * __acpi_map_table() will be called before page_init(), so early_ioremap()
>> + * or early_memremap() should be called here.
>
> Again, why is this needed ? What's needed before paging_init() from ACPI ?
>
> [...]
>
>> +/*
>> + * acpi_boot_table_init() and acpi_boot_init()
>> + *  called from setup_arch(), always.
>> + *	1. checksums all tables
>> + *	2. enumerates lapics
>> + *	3. enumerates io-apics
>> + *
>> + * acpi_table_init() is separated to allow reading SRAT without
>> + * other side effects.
>> + */
>> +void __init acpi_boot_table_init(void)
>> +{
>> +	/*
>> +	 * If acpi_disabled, bail out
>> +	 */
>> +	if (acpi_disabled)
>> +		return;
>> +
>> +	/*
>> +	 * Initialize the ACPI boot-time table parser.
>> +	 */
>> +	if (acpi_table_init()) {
>> +		disable_acpi();
>> +		return;
>> +	}
>> +}
>> +
>> +int __init early_acpi_boot_init(void)
>> +{
>> +	/*
>> +	 * If acpi_disabled, bail out
>> +	 */
>> +	if (acpi_disabled)
>> +		return -ENODEV;
>> +
>> +	/*
>> +	 * Process the Multiple APIC Description Table (MADT), if present
>> +	 */
>> +	early_acpi_process_madt();
>> +
>> +	return 0;
>> +}
>> +
>> +int __init acpi_boot_init(void)
>> +{
>> +	/*
>> +	 * If acpi_disabled, bail out
>> +	 */
>> +	if (acpi_disabled)
>> +		return -ENODEV;
>> +
>> +	acpi_table_parse(ACPI_SIG_FADT, acpi_parse_fadt);
>> +
>> +	/*
>> +	 * Process the Multiple APIC Description Table (MADT), if present
>> +	 */
>> +	acpi_process_madt();
>> +
>> +	return 0;
>> +}
>
> Well, apart from having three init calls, one returning void and two
> returning proper values, do not understand why, and do not understand
> why we need three calls in the first place...why should we process MADT
> twice in two separate calls ? What is supposed to change in between that
> prevents you from merging the two together ?
>
> Thanks,
> Lorenzo
>
>
> _______________________________________________
> Linaro-acpi mailing list
> Linaro-acpi@lists.linaro.org
> http://lists.linaro.org/mailman/listinfo/linaro-acpi
>
