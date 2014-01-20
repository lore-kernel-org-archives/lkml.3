Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754075AbaATMag (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 07:30:36 -0500
Received: from mail-pb0-f44.google.com ([209.85.160.44]:37247 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751857AbaATMaa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 07:30:30 -0500
Message-ID: <52DD15FC.5030807@linaro.org>
Date: Mon, 20 Jan 2014 20:26:36 +0800
From: Hanjun Guo <hanjun.guo@linaro.org>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Sudeep Holla <Sudeep.Holla@arm.com>
CC: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>, Olof Johansson <olof@lixom.net>,
        Linus Walleij <linus.walleij@linaro.org>,
        Bjorn Helgaas <bhelgaas@google.com>, Rob Herring <robh@kernel.org>,
        Mark Rutland <Mark.Rutland@arm.com>, Arnd Bergmann <arnd@arndb.de>,
        "patches@linaro.org" <patches@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "linaro-acpi@lists.linaro.org" <linaro-acpi@lists.linaro.org>,
        Charles Garcia-Tobin <Charles.Garcia-Tobin@arm.com>,
        Al Stone <al.stone@linaro.org>,
        "graeme.gregory@linaro.org" <graeme.gregory@linaro.org>
Subject: Re: [PATCH 04/20] ARM64 / ACPI: Introduce arm_core.c and its related
 head file
References: <1389961514-13562-1-git-send-email-hanjun.guo@linaro.org> <1389961514-13562-5-git-send-email-hanjun.guo@linaro.org> <52D960D1.3090700@arm.com>
In-Reply-To: <52D960D1.3090700@arm.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-1-18 0:56, Sudeep Holla wrote:
> On 17/01/14 12:24, Hanjun Guo wrote:
>> Introduce arm_core.c and its related head file, after this patch,
>> we can get ACPI tables from firmware on ARM64 now.
>>
>> Signed-off-by: Al Stone <al.stone@linaro.org>
>> Signed-off-by: Graeme Gregory <graeme.gregory@linaro.org>
>> Signed-off-by: Hanjun Guo <hanjun.guo@linaro.org>
>> ---
>>  arch/arm64/include/asm/acpi.h |   57 +++++++++++
>>  arch/arm64/kernel/setup.c     |    6 ++
>>  drivers/acpi/Makefile         |    2 +
>>  drivers/acpi/plat/Makefile    |    1 +
>>  drivers/acpi/plat/arm-core.c  |  209 +++++++++++++++++++++++++++++++++++++++++
>>  5 files changed, 275 insertions(+)
>>  create mode 100644 drivers/acpi/plat/Makefile
>>  create mode 100644 drivers/acpi/plat/arm-core.c
>>
>> diff --git a/arch/arm64/include/asm/acpi.h b/arch/arm64/include/asm/acpi.h
>> index cf19dc6..908d71b 100644
>> --- a/arch/arm64/include/asm/acpi.h
>> +++ b/arch/arm64/include/asm/acpi.h
>> @@ -19,6 +19,43 @@
>>  #ifndef _ASM_ARM64_ACPI_H
>>  #define _ASM_ARM64_ACPI_H
>>  
>> +#include <asm/cacheflush.h>
>> +
>> +#include <linux/init.h>
>> +
>> +#define COMPILER_DEPENDENT_INT64	s64
>> +#define COMPILER_DEPENDENT_UINT64	u64
>> +
>> +/*
>> + * Calling conventions:
>> + *
>> + * ACPI_SYSTEM_XFACE        - Interfaces to host OS (handlers, threads)
>> + * ACPI_EXTERNAL_XFACE      - External ACPI interfaces
>> + * ACPI_INTERNAL_XFACE      - Internal ACPI interfaces
>> + * ACPI_INTERNAL_VAR_XFACE  - Internal variable-parameter list interfaces
>> + */
>> +#define ACPI_SYSTEM_XFACE
>> +#define ACPI_EXTERNAL_XFACE
>> +#define ACPI_INTERNAL_XFACE
>> +#define ACPI_INTERNAL_VAR_XFACE
>> +
>> +/* Asm macros */
>> +#define ACPI_FLUSH_CPU_CACHE() flush_cache_all()
>> +
>> +/* Basic configuration for ACPI */
>> +#ifdef	CONFIG_ACPI
>> +extern int acpi_disabled;
>> +extern int acpi_noirq;
>> +extern int acpi_pci_disabled;
>> +extern int acpi_strict;
>> +
>> +static inline void disable_acpi(void)
>> +{
>> +	acpi_disabled = 1;
>> +	acpi_pci_disabled = 1;
>> +	acpi_noirq = 1;
>> +}
>> +
>>  static inline bool arch_has_acpi_pdc(void)
>>  {
>>  	return false;	/* always false for now */
>> @@ -29,4 +66,24 @@ static inline void arch_acpi_set_pdc_bits(u32 *buf)
>>  	return;
>>  }
>>  
>> +static inline void acpi_noirq_set(void) { acpi_noirq = 1; }
>> +static inline void acpi_disable_pci(void)
>> +{
>> +	acpi_pci_disabled = 1;
>> +	acpi_noirq_set();
>> +}
>> +
>> +/* FIXME: this function should be moved to topology.h when it's ready */
>> +void arch_fix_phys_package_id(int num, u32 slot);
>> +
>> +/* temperally define -1 to make acpi core compilerable */
>> +#define cpu_physical_id(cpu) -1
>> +
> 
> I assume `cpu` here is logical cpu id in which case you can define it to be same
> as cpu_logical_map ?

Yes. it is about the hardware id of CPU and may refer to MPIDR in ARM/ARM64.

Thanks
Hanjun

