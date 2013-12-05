Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756786Ab3LEO2Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 09:28:24 -0500
Received: from mail-pd0-f174.google.com ([209.85.192.174]:40520 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752902Ab3LEO2V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 09:28:21 -0500
Message-ID: <52A08D6E.9070400@linaro.org>
Date: Thu, 05 Dec 2013 22:27:58 +0800
From: Hanjun Guo <hanjun.guo@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Rob Herring <robherring2@gmail.com>
CC: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        Graeme Gregory <graeme.gregory@linaro.org>,
        Al Stone <al.stone@linaro.org>, Linaro Patches <patches@linaro.org>,
        Olof Johansson <olof@lixom.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rob Herring <rob.herring@calxeda.com>, linaro-acpi@lists.linaro.org,
        linux-acpi@vger.kernel.org, Grant Likely <grant.likely@linaro.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [RFC part1 PATCH 5/7] ARM64 / ACPI: Introduce arm_core.c and
 its related head file
References: <1386088611-2801-1-git-send-email-hanjun.guo@linaro.org> <1386088611-2801-6-git-send-email-hanjun.guo@linaro.org> <CAL_Jsq+8O13+hVKVEVGg_Mu4hkRLi6afBhoeduVAWW7g=5B8bQ@mail.gmail.com>
In-Reply-To: <CAL_Jsq+8O13+hVKVEVGg_Mu4hkRLi6afBhoeduVAWW7g=5B8bQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013年12月05日 22:09, Rob Herring wrote:
> On Tue, Dec 3, 2013 at 10:36 AM, Hanjun Guo <hanjun.guo@linaro.org> wrote:
[...]
>> +
>>   #endif /*_ASM_ARM_ACPI_H*/
>> diff --git a/arch/arm64/kernel/setup.c b/arch/arm64/kernel/setup.c
>> index bd9bbd0..8199360 100644
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
>> @@ -225,6 +226,13 @@ void __init setup_arch(char **cmdline_p)
>>
>>          arm64_memblock_init();
>>
>> +       /*
>> +        * Parse the ACPI tables for possible boot-time configuration
>> +        */
>> +       acpi_boot_table_init();
>> +       early_acpi_boot_init();
>> +       acpi_boot_init();
>> +
> How about a single function here. Perhaps called acpi_early_init. That
> would save checking acpi_disabled 3 times.

It is separated for some reasons on intel platforms, one of them
is ACPI based memory hot-plug, SRAT (NUMA related ACPI table)
and its related memory initialization should be finished between
early_acpi_boot_init() and acpi_boot_init().

I keep this code unchanged for future use (memory hotplug)
on ARM, is this make sense to you?

>>          paging_init();
>>          request_standard_resources();
>>
[...]
>> lic License for more details.
>> + *
>> + * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>> + */
>> +
>> +#include <linux/init.h>
>> +#include <linux/acpi.h>
>> +#include <linux/acpi_pmtmr.h>
>> +#include <linux/efi.h>
>> +#include <linux/cpumask.h>
>> +#include <linux/memblock.h>
>> +#include <linux/module.h>
>> +#include <linux/irq.h>
>> +#include <linux/irqdomain.h>
>> +#include <linux/slab.h>
>> +#include <linux/bootmem.h>
>> +#include <linux/ioport.h>
>> +#include <linux/pci.h>
>> +
>> +#include <asm/pgtable.h>
>> +#include <asm/io.h>
> linux/io.h although I can't see where it is even needed.
>
>> +#include <asm/smp.h>
> linux/smp.h ...
>
> Seems like you have a lot of unnecessary headers here. efi.h, slab.h,
> pci.h, etc.

Thanks for the reminding, will update and clean them up.

>> +
>> +/*
>> + * We never plan to use RSDT on arm/arm64 as its deprecated in spec but this
>> + * variable is still required by the ACPI core
>> + */
>> +u32 acpi_rsdt_forced;
>> +
>> +int acpi_noirq;                        /* skip ACPI IRQ initialization */
>> +int acpi_strict;
>> +int acpi_disabled;
>> +EXPORT_SYMBOL(acpi_disabled);
>> +
>> +int acpi_pci_disabled;         /* skip ACPI PCI scan and IRQ initialization */
>> +EXPORT_SYMBOL(acpi_pci_disabled);
>> +
>> +#define PREFIX                 "ACPI: "
>> +
>> +/* FIXME: this function should be moved to topology.c when it is ready */
>> +void arch_fix_phys_package_id(int num, u32 slot)
>> +{
>> +       return;
>> +}
>> +EXPORT_SYMBOL_GPL(arch_fix_phys_package_id);
>> +
>> +/*
>> + * Boot-time Configuration
>> + */
>> +
> It is not really clear what this comment applies to.

Yes, only leading some confusion, will remove it.

>> +enum acpi_irq_model_id acpi_irq_model = ACPI_IRQ_MODEL_PLATFORM;
>> +
>> +static unsigned int gsi_to_irq(unsigned int gsi)
>> +{
>> +       int irq = irq_create_mapping(NULL, gsi);
>> +
>> +       return irq;
>> +}
>> +
>> +/*
>> + * __acpi_map_table() will be called before page_init(), so early_ioremap()
>> + * or early_memremap() should be called here.
>> + *
>> + * FIXME: early_io/memremap()/early_iounmap() are not upstream yet on ARM64,
>> + * just wait for Mark Salter's patchset accepted by mainline
>> + */
>> +char *__init __acpi_map_table(unsigned long phys, unsigned long size)
>> +{
>> +       if (!phys || !size)
>> +               return NULL;
>> +
>> +       /*
>> +        * temporarily use phys_to_virt(),
>> +        * should be early_memremap(phys, size) here
>> +        */
>> +       return phys_to_virt(phys);
>> +}
>> +
>> +void __init __acpi_unmap_table(char *map, unsigned long size)
>> +{
>> +       if (!map || !size)
>> +               return;
>> +
>> +       /* should be early_iounmap(map, size); */
>> +       return;
>> +}
>> +
>> +int acpi_gsi_to_irq(u32 gsi, unsigned int *irq)
>> +{
>> +       *irq = gsi_to_irq(gsi);
>> +
>> +       return 0;
>> +}
>> +EXPORT_SYMBOL_GPL(acpi_gsi_to_irq);
>> +
>> +/*
>> + * success: return IRQ number (>=0)
> '> 0' for interrupts is what normally means success in the kernel. 0
> is for no irq.

Will update :)

>> + * failure: return < 0
>> + */
>> +int acpi_register_gsi(struct device *dev, u32 gsi, int trigger, int polarity)
>> +{
>> +       return -1;
>> +}
>> +EXPORT_SYMBOL_GPL(acpi_register_gsi);
[...]
>> +
>> +static int __init parse_acpi(char *arg)
>> +{
>> +       if (!arg)
>> +               return -EINVAL;
>> +
>> +       /* "acpi=off" disables both ACPI table parsing and interpreter */
>> +       if (strcmp(arg, "off") == 0) {
>> +               disable_acpi();
>> +       }
>> +       /* acpi=strict disables out-of-spec workarounds */
>> +       else if (strcmp(arg, "strict") == 0) {
>> +               acpi_strict = 1;
>> +       }
>> +       return 0;
>> +}
>> +early_param("acpi", parse_acpi);
> These aren't common options across architectures?

Different architectures have different options,
such as x86, it has more options which ARM is not needed.

Thanks
Hanjun
