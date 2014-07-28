Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752074AbaG1WuB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 18:50:01 -0400
Received: from mail-we0-f169.google.com ([74.125.82.169]:54968 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751425AbaG1Wtz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 18:49:55 -0400
Message-ID: <53D6D391.8090907@linaro.org>
Date: Mon, 28 Jul 2014 23:49:53 +0100
From: Graeme Gregory <graeme.gregory@linaro.org>
User-Agent: Mozilla/5.0 (Windows NT 6.3; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Sudeep Holla <sudeep.holla@arm.com>, Hanjun Guo <hanjun.guo@linaro.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Mark Rutland <Mark.Rutland@arm.com>
CC: Arnd Bergmann <arnd@arndb.de>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        Will Deacon <Will.Deacon@arm.com>, Jason Cooper <jason@lakedaemon.net>,
        Marc Zyngier <Marc.Zyngier@arm.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Mark Brown <broonie@linaro.org>, Robert Richter <rric@kernel.org>,
        Lv Zheng <lv.zheng@intel.com>, Robert Moore <robert.moore@intel.com>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Liviu Dudau <Liviu.Dudau@arm.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Charles Garcia-Tobin <Charles.Garcia-Tobin@arm.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Al Stone <al.stone@linaro.org>,
        Tomasz Nowicki <tomasz.nowicki@linaro.org>
Subject: Re: [PATCH 01/19] ARM64 / ACPI: Get RSDP and ACPI boot-time tables
References: <1406206825-15590-1-git-send-email-hanjun.guo@linaro.org> <1406206825-15590-2-git-send-email-hanjun.guo@linaro.org> <53D69678.20002@arm.com>
In-Reply-To: <53D69678.20002@arm.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 28/07/2014 19:29, Sudeep Holla wrote:
>
>
> On 24/07/14 14:00, Hanjun Guo wrote:
>> From: Al Stone <al.stone@linaro.org>
>>
>> As we want to get ACPI tables to parse and then use the information
>> for system initialization, we should get the RSDP (Root System
>> Description Pointer) first, it then locates Extended Root Description
>> Table (XSDT) which contains all the 64-bit physical address that
>> pointer to other boot-time tables.
>>
>> Introduce acpi.c and its related head file in this patch to provide
>> fundamental needs of extern variables and functions for ACPI core,
>> and then get boot-time tables as needed.
>>    - asm/cpu.h need for ACPI core and will be updated in the future to
>>      add definitions for arch_(un)register_cpu which are required for
>>      ACPI based physical CPU hotplug;
>>    - asm/acenv.h for arch specific ACPICA environments and
>>      implementation;
>>    - asm/acpi.h for arch specific variables and functions needed by
>>      ACPI driver core;
>>    - acpi.c for ARM64 related ACPI implementation for ACPI driver
>>      core;
>>
>> acpi_boot_table_init() is introduced to get RSDP and boot-time tables,
>> it will be called in setup_arch() before paging_init(), so we should
>> use eary_memremap() mechanism here to get the RSDP and all the table
>> pointers.
>>
>> Signed-off-by: Al Stone <al.stone@linaro.org>
>> Signed-off-by: Graeme Gregory <graeme.gregory@linaro.org>
>> Signed-off-by: Tomasz Nowicki <tomasz.nowicki@linaro.org>
>> Signed-off-by: Hanjun Guo <hanjun.guo@linaro.org>
>> ---
>>   arch/arm64/include/asm/acenv.h |   18 ++++++++++
>>   arch/arm64/include/asm/acpi.h  |   41 ++++++++++++++++++++++
>>   arch/arm64/include/asm/cpu.h   |   11 ++++++
>>   arch/arm64/kernel/Makefile     |    1 +
>>   arch/arm64/kernel/acpi.c       |   76 
>> ++++++++++++++++++++++++++++++++++++++++
>>   arch/arm64/kernel/setup.c      |    4 +++
>>   6 files changed, 151 insertions(+)
>>   create mode 100644 arch/arm64/include/asm/acenv.h
>>   create mode 100644 arch/arm64/include/asm/acpi.h
>>   create mode 100644 arch/arm64/include/asm/cpu.h
>>   create mode 100644 arch/arm64/kernel/acpi.c
>>
>> diff --git a/arch/arm64/include/asm/acenv.h 
>> b/arch/arm64/include/asm/acenv.h
>> new file mode 100644
>> index 0000000..3899ee6
>> --- /dev/null
>> +++ b/arch/arm64/include/asm/acenv.h
>> @@ -0,0 +1,18 @@
>> +/*
>> + * ARM64 specific ACPICA environments and implementation
>> + *
>> + * Copyright (C) 2014, Linaro Ltd.
>> + *   Author: Hanjun Guo <hanjun.guo@linaro.org>
>> + *   Author: Graeme Gregory <graeme.gregory@linaro.org>
>> + *
>> + * This program is free software; you can redistribute it and/or modify
>> + * it under the terms of the GNU General Public License version 2 as
>> + * published by the Free Software Foundation.
>> + */
>> +
>> +#ifndef _ASM_ACENV_H
>> +#define _ASM_ACENV_H
>> +
>> +#define ACPI_FLUSH_CPU_CACHE() WARN_ONCE(1, "Not currently supported 
>> on ARM64")
>> +
>> +#endif /* _ASM_ACENV_H */
>> diff --git a/arch/arm64/include/asm/acpi.h 
>> b/arch/arm64/include/asm/acpi.h
>> new file mode 100644
>> index 0000000..e8581ea
>> --- /dev/null
>> +++ b/arch/arm64/include/asm/acpi.h
>> @@ -0,0 +1,41 @@
>> +/*
>> + *  Copyright (C) 2013-2014, Linaro Ltd.
>> + *     Author: Al Stone <al.stone@linaro.org>
>> + *     Author: Graeme Gregory <graeme.gregory@linaro.org>
>> + *     Author: Hanjun Guo <hanjun.guo@linaro.org>
>> + *
>> + *  This program is free software; you can redistribute it and/or 
>> modify
>> + *  it under the terms of the GNU General Public License version 2 as
>> + *  published by the Free Software Foundation;
>> + */
>> +
>> +#ifndef _ASM_ACPI_H
>> +#define _ASM_ACPI_H
>> +
>> +/* Basic configuration for ACPI */
>> +#ifdef CONFIG_ACPI
>> +extern int acpi_disabled;
>> +extern int acpi_noirq;
>> +extern int acpi_pci_disabled;
>> +extern int acpi_strict;
>
> Until we need to enable workarounds, we should have acpi_strict
> as macro rather than variable similar to IA64.
>
>> +
>> +static inline void disable_acpi(void)
>> +{
>> +       acpi_disabled = 1;
>> +       acpi_pci_disabled = 1;
>> +       acpi_noirq = 1;
>> +}
>> +
>> +/*
>> + * MADT must provide at least one GICC structure
>> + * for GIC initialization, so CPU will be
>> + * always available in MADT on ARM64
>> + */
>> +static inline bool acpi_has_cpu_in_madt(void)
>> +{
>> +       return 1;
>> +}
>> +
>
> I don't see the user of this function in the series, it's better to
> remove. Moreover the comment is so misleading. We will have CPU UID
> not the CPU itself in MADT.
>
This is actually required for a patch that is now upstreamed. Comment 
should actually say that its checking for the posibility that the CPU 
can be initialised from the MADT. Its used from core in crash kernel 
case where boot CPU is not necessarily CPU0 like spec demands.

Graeme

>> +#endif /* CONFIG_ACPI */
>> +
>> +#endif /*_ASM_ACPI_H*/
>> diff --git a/arch/arm64/include/asm/cpu.h b/arch/arm64/include/asm/cpu.h
>> new file mode 100644
>> index 0000000..cee7d3f
>> --- /dev/null
>> +++ b/arch/arm64/include/asm/cpu.h
>> @@ -0,0 +1,11 @@
>> +/*
>> + *  Copyright (C) 2013-2014 ARM Ltd.
>> + *
>> + * This program is free software; you can redistribute it and/or modify
>> + * it under the terms of the GNU General Public License version 2 as
>> + * published by the Free Software Foundation.
>> + */
>> +#ifndef __ASM_CPU_H
>> +#define __ASM_CPU_H
>> +
>> +#endif
>> diff --git a/arch/arm64/kernel/Makefile b/arch/arm64/kernel/Makefile
>> index cdaedad..b568c26 100644
>> --- a/arch/arm64/kernel/Makefile
>> +++ b/arch/arm64/kernel/Makefile
>> @@ -29,6 +29,7 @@ arm64-obj-$(CONFIG_ARM64_CPU_SUSPEND) += sleep.o 
>> suspend.o
>>   arm64-obj-$(CONFIG_JUMP_LABEL)         += jump_label.o
>>   arm64-obj-$(CONFIG_KGDB)               += kgdb.o
>>   arm64-obj-$(CONFIG_EFI)                        += efi.o efi-stub.o 
>> efi-entry.o
>> +arm64-obj-$(CONFIG_ACPI)               += acpi.o
>>
>>   obj-y                                  += $(arm64-obj-y) vdso/
>>   obj-m                                  += $(arm64-obj-m)
>> diff --git a/arch/arm64/kernel/acpi.c b/arch/arm64/kernel/acpi.c
>> new file mode 100644
>> index 0000000..c62fce6
>> --- /dev/null
>> +++ b/arch/arm64/kernel/acpi.c
>> @@ -0,0 +1,76 @@
>> +/*
>> + *  ARM64 Specific Low-Level ACPI Boot Support
>> + *
>> + *  Copyright (C) 2013-2014, Linaro Ltd.
>> + *     Author: Al Stone <al.stone@linaro.org>
>> + *     Author: Graeme Gregory <graeme.gregory@linaro.org>
>> + *     Author: Hanjun Guo <hanjun.guo@linaro.org>
>> + *
>> + *  This program is free software; you can redistribute it and/or 
>> modify
>> + *  it under the terms of the GNU General Public License version 2 as
>> + *  published by the Free Software Foundation.
>> + */
>> +
>> +#include <linux/init.h>
>> +#include <linux/acpi.h>
>> +#include <linux/cpumask.h>
>> +#include <linux/memblock.h>
>> +#include <linux/irq.h>
>> +#include <linux/irqdomain.h>
>> +#include <linux/bootmem.h>
>> +#include <linux/smp.h>
>> +
>> +/*
>> + * We never plan to use RSDT on arm/arm64 as its deprecated in spec 
>> but this
>> + * variable is still required by the ACPI core
>> + */
>> +u32 acpi_rsdt_forced;
>
> This looks like yet another stray variable not used anywhere including
> core ACPI
>
>> +
>> +int acpi_noirq;                        /* skip ACPI IRQ 
>> initialization */
>> +int acpi_strict;
>> +int acpi_disabled;
>> +EXPORT_SYMBOL(acpi_disabled);
>> +
>> +int acpi_pci_disabled;         /* skip ACPI PCI scan and IRQ 
>> initialization */
>> +EXPORT_SYMBOL(acpi_pci_disabled);
>> +
>> +/*
>> + * __acpi_map_table() will be called before page_init(), so 
>> early_ioremap()
>> + * or early_memremap() should be called here to for ACPI table mapping.
>> + */
>> +char *__init __acpi_map_table(unsigned long phys, unsigned long size)
>> +{
>> +       if (!phys || !size)
>> +               return NULL;
>> +
>> +       return early_memremap(phys, size);
>> +}
>> +
>> +void __init __acpi_unmap_table(char *map, unsigned long size)
>> +{
>> +       if (!map || !size)
>> +               return;
>> +
>> +       early_iounmap(map, size);
>
> Why not early_memunmap for consistency ?
> Also now there's generic implementation of early mappings does it make
> sense to move this also to acpi core ?
>
> Regards,
> Sudeep
>

