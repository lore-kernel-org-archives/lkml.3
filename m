Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752032AbaAXJKK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jan 2014 04:10:10 -0500
Received: from mail-pb0-f52.google.com ([209.85.160.52]:47345 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751178AbaAXJJ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jan 2014 04:09:58 -0500
Message-ID: <52E22DD4.3050807@linaro.org>
Date: Fri, 24 Jan 2014 17:09:40 +0800
From: Hanjun Guo <hanjun.guo@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Tomasz Nowicki <tomasz.nowicki@linaro.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
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
References: <1389961514-13562-1-git-send-email-hanjun.guo@linaro.org> <1389961514-13562-5-git-send-email-hanjun.guo@linaro.org> <20140122115453.GC24288@e102568-lin.cambridge.arm.com> <52E13BBC.5020005@linaro.org>
In-Reply-To: <52E13BBC.5020005@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014年01月23日 23:56, Tomasz Nowicki wrote:
> Hi Lorenzo,
>
> W dniu 22.01.2014 12:54, Lorenzo Pieralisi pisze:
>> On Fri, Jan 17, 2014 at 12:24:58PM +0000, Hanjun Guo wrote:
>>
>> [...]
>>
>>> diff --git a/arch/arm64/kernel/setup.c b/arch/arm64/kernel/setup.c
>>> index bd9bbd0..2210353 100644
>>> --- a/arch/arm64/kernel/setup.c
>>> +++ b/arch/arm64/kernel/setup.c
>>> @@ -41,6 +41,7 @@
>>> #include <linux/memblock.h>
>>> #include <linux/of_fdt.h>
>>> #include <linux/of_platform.h>
>>> +#include <linux/acpi.h>
>>>
>>> #include <asm/cputype.h>
>>> #include <asm/elf.h>
>>> @@ -225,6 +226,11 @@ void __init setup_arch(char **cmdline_p)
>>>
>>> arm64_memblock_init();
>>>
>>> + /* Parse the ACPI tables for possible boot-time configuration */
>>> + acpi_boot_table_init();
>>> + early_acpi_boot_init();
>>> + acpi_boot_init();
>>> +
>>> paging_init();
>>
>> Can I ask you please why we need to parse ACPI tables before
>> paging_init() ?
> This is for future usage and because of couple of reasons. Mainly SRAT 
> table parsing should be done (before paging_init()) for proper NUMA 
> initialization and then paging_init().

Yes, I agree, thanks for Tomasz's clarification.

>>
>> [...]
>>
>>> +/*
>>> + * __acpi_map_table() will be called before page_init(), so 
>>> early_ioremap()
>>> + * or early_memremap() should be called here.
>>
>> Again, why is this needed ? What's needed before paging_init() from 
>> ACPI ?
>>
>> [...]
>>
>>> +/*
>>> + * acpi_boot_table_init() and acpi_boot_init()
>>> + * called from setup_arch(), always.
>>> + * 1. checksums all tables
>>> + * 2. enumerates lapics
>>> + * 3. enumerates io-apics
>>> + *
>>> + * acpi_table_init() is separated to allow reading SRAT without
>>> + * other side effects.
>>> + */
>>> +void __init acpi_boot_table_init(void)
>>> +{
>>> + /*
>>> + * If acpi_disabled, bail out
>>> + */
>>> + if (acpi_disabled)
>>> + return;
>>> +
>>> + /*
>>> + * Initialize the ACPI boot-time table parser.
>>> + */
>>> + if (acpi_table_init()) {
>>> + disable_acpi();
>>> + return;
>>> + }
>>> +}
>>> +
>>> +int __init early_acpi_boot_init(void)
>>> +{
>>> + /*
>>> + * If acpi_disabled, bail out
>>> + */
>>> + if (acpi_disabled)
>>> + return -ENODEV;
>>> +
>>> + /*
>>> + * Process the Multiple APIC Description Table (MADT), if present
>>> + */
>>> + early_acpi_process_madt();
>>> +
>>> + return 0;
>>> +}
>>> +
>>> +int __init acpi_boot_init(void)
>>> +{
>>> + /*
>>> + * If acpi_disabled, bail out
>>> + */
>>> + if (acpi_disabled)
>>> + return -ENODEV;
>>> +
>>> + acpi_table_parse(ACPI_SIG_FADT, acpi_parse_fadt);
>>> +
>>> + /*
>>> + * Process the Multiple APIC Description Table (MADT), if present
>>> + */
>>> + acpi_process_madt();
>>> +
>>> + return 0;
>>> +}
>>
>> Well, apart from having three init calls, one returning void and two
>> returning proper values, do not understand why, and do not understand
>> why we need three calls in the first place...why should we process MADT
>> twice in two separate calls ? What is supposed to change in between that
>> prevents you from merging the two together ?

Thanks for pointing this out. I can merge acpi_boot_table_init() and
early_acpi_boot_init() together, but can not merge early_acpi_boot_init()
and acpi_boot_init() together.

early_acpi_boot_init() and acpi_boot_init() was separated intentionally for
memory hotplug reasons. memory allocated in this stage can not be migrated
and cause memory hot-remove failed, in order to keep memory allocated
at base node (general NUMA node 0 in the system) at boot stage, we should
parse SRAT first before CPU is enumerated, does this make sense to you?

Thanks
Hanjun

