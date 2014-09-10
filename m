Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751913AbaIJHb7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 03:31:59 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:37101 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751038AbaIJHb4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 03:31:56 -0400
Message-ID: <540FFE0B.7070400@huawei.com>
Date: Wed, 10 Sep 2014 15:30:19 +0800
From: Hanjun Guo <guohanjun@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: Catalin Marinas <catalin.marinas@arm.com>,
        "hanjun.guo@linaro.org" <hanjun.guo@linaro.org>
CC: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
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
        "Lorenzo Pieralisi" <Lorenzo.Pieralisi@arm.com>,
        Liviu Dudau <Liviu.Dudau@arm.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Charles Garcia-Tobin <Charles.Garcia-Tobin@arm.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linaro-acpi@lists.linaro.org" <linaro-acpi@lists.linaro.org>,
        Al Stone <al.stone@linaro.org>,
        "Tomasz Nowicki" <tomasz.nowicki@linaro.org>
Subject: Re: [PATCH v3 02/17] ARM64 / ACPI: Get RSDP and ACPI boot-time tables
References: <1409583475-6978-1-git-send-email-hanjun.guo@linaro.org> <1409583475-6978-3-git-send-email-hanjun.guo@linaro.org> <20140909162648.GE2910@arm.com>
In-Reply-To: <20140909162648.GE2910@arm.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.17.188]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/9/10 0:26, Catalin Marinas wrote:
> On Mon, Sep 01, 2014 at 03:57:40PM +0100, Hanjun Guo wrote:
>> diff --git a/arch/arm64/include/asm/acenv.h b/arch/arm64/include/asm/acenv.h
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
>> +#define ACPI_FLUSH_CPU_CACHE() WARN_ONCE(1, "Not currently supported on ARM64")
> 
> Does this mean that it will be supported at some point? Looking at the
> places where this function is called, I don't really see how this would
> ever work on ARM. Which means that we add such macro just to be able to
> compile code that would never be used on arm64. I would rather see the
> relevant ACPI files only compiled on x86/IA-64 rather than arm64.
> 
>> diff --git a/arch/arm64/kernel/acpi.c b/arch/arm64/kernel/acpi.c
>> new file mode 100644
>> index 0000000..9252f72
>> --- /dev/null
>> +++ b/arch/arm64/kernel/acpi.c
> 
> [...]
> 
>> +/*
>> + * acpi_boot_table_init() called from setup_arch(), always.
>> + *	1. find RSDP and get its address, and then find XSDT
>> + *	2. extract all tables and checksums them all
>> + *
>> + * We can parse ACPI boot-time tables such as MADT after
>> + * this function is called.
>> + */
>> +void __init acpi_boot_table_init(void)
>> +{
>> +	/* If acpi_disabled, bail out */
>> +	if (acpi_disabled)
>> +		return;
> 
> So at this point, there wouldn't be anything yet to set acpi_disabled to
> 1, unless !CONFIG_ACPI.
> 
>> +
>> +	/* Initialize the ACPI boot-time table parser. */
>> +	if (acpi_table_init())
>> +		disable_acpi();
> 
> Do you need anything more to add to this function later? Otherwise, just
> call it in setup_arch() directly (maybe dependent on
> IS_ENABLED(CONFIG_ACPI) or just create an equivalent dummy
> acpi_table_init() when not configured).

We add FADT parse function to this function later.

> 
>> diff --git a/arch/arm64/kernel/setup.c b/arch/arm64/kernel/setup.c
>> index c96172a..fb7cc0e 100644
>> --- a/arch/arm64/kernel/setup.c
>> +++ b/arch/arm64/kernel/setup.c
>> @@ -43,6 +43,7 @@
>>  #include <linux/of_fdt.h>
>>  #include <linux/of_platform.h>
>>  #include <linux/efi.h>
>> +#include <linux/acpi.h>
>>  
>>  #include <asm/fixmap.h>
>>  #include <asm/cpu.h>
>> @@ -385,6 +386,9 @@ void __init setup_arch(char **cmdline_p)
>>  	efi_init();
>>  	arm64_memblock_init();
>>  
>> +	/* Parse the ACPI tables for possible boot-time configuration */
>> +	acpi_boot_table_init();
> 
> Is there any dummy acpi_boot_table_init() when !CONFIG_ACPI? I couldn't
> see one in this patch, so I don't see how this would compile when ACPI
> is disabled.

There is a stub function in linux/acpi.h when ACPI is disabled.

Thanks
Hanjun


