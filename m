Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932730Ab3LDPdQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 10:33:16 -0500
Received: from mail-pb0-f48.google.com ([209.85.160.48]:49233 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932528Ab3LDPdN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 10:33:13 -0500
Message-ID: <529F4B2A.6060508@linaro.org>
Date: Wed, 04 Dec 2013 23:32:58 +0800
From: Hanjun Guo <hanjun.guo@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Marc Zyngier <marc.zyngier@arm.com>
CC: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Mark Rutland <Mark.Rutland@arm.com>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "patches@linaro.org" <patches@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Olof Johansson <olof@lixom.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "linaro-acpi@lists.linaro.org" <linaro-acpi@lists.linaro.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        Jon Masters <jonathan@jonmasters.org>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [RFC part2 PATCH 9/9] ACPI / GIC: Initialize GIC using the information
 in MADT
References: <1386088753-2850-1-git-send-email-hanjun.guo@linaro.org> <1386088753-2850-10-git-send-email-hanjun.guo@linaro.org> <529E1443.9040509@arm.com>
In-Reply-To: <529E1443.9040509@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013年12月04日 01:26, Marc Zyngier wrote:
> Hi Hanjun,
>
> On 03/12/13 16:39, Hanjun Guo wrote:
>> In MADT table, there are GIC cpu interface base address and
>> GIC distributor base address, use them to convert GIC to ACPI.
>>
>> Signed-off-by: Hanjun Guo <hanjun.guo@linaro.org>
>> ---
>>   arch/arm64/kernel/irq.c      |    5 ++++
>>   drivers/acpi/plat/arm-core.c |   66 ++++++++++++++++++++++++++++++++++++------
>>   include/linux/acpi.h         |    6 ++++
>>   3 files changed, 68 insertions(+), 9 deletions(-)
>>
>> diff --git a/arch/arm64/kernel/irq.c b/arch/arm64/kernel/irq.c
>> index 473e5db..a9e68bf 100644
>> --- a/arch/arm64/kernel/irq.c
>> +++ b/arch/arm64/kernel/irq.c
>> @@ -25,6 +25,7 @@
>>   #include <linux/irq.h>
>>   #include <linux/smp.h>
>>   #include <linux/init.h>
>> +#include <linux/acpi.h>
>>   #include <linux/irqchip.h>
>>   #include <linux/seq_file.h>
>>   #include <linux/ratelimit.h>
>> @@ -78,6 +79,10 @@ void __init set_handle_irq(void (*handle_irq)(struct pt_regs *))
>>   void __init init_IRQ(void)
>>   {
>>   	irqchip_init();
>> +
>> +	if (!handle_arch_irq)
>> +		acpi_gic_init();
>> +
> Why is the GIC hardcoded?

Very good question, thanks. I considered GIC only in my patch set.
I have no idea how to handle the GIC hardcoded problem here for
now, but I will figure it out later.

If any suggestion, I will appreciate a lot.

> How are you going to support other interrupt
> controllers?

ACPI 5.0 supports GICv2 only for now, if we want to
support other interrupt controller, we should introduce
some OEM table and parsing it, and it will not covered
by this patch set.

>>   	if (!handle_arch_irq)
>>   		panic("No interrupt controller found.");
>>   }
>> diff --git a/drivers/acpi/plat/arm-core.c b/drivers/acpi/plat/arm-core.c
>> index 17c99e1..509b847 100644
>> --- a/drivers/acpi/plat/arm-core.c
>> +++ b/drivers/acpi/plat/arm-core.c
>> @@ -29,6 +29,7 @@
>>   #include <linux/module.h>
>>   #include <linux/irq.h>
>>   #include <linux/irqdomain.h>
>> +#include <linux/irqchip/arm-gic.h>
>>   #include <linux/slab.h>
>>   #include <linux/bootmem.h>
>>   #include <linux/ioport.h>
>> @@ -211,11 +212,21 @@ acpi_parse_gic(struct acpi_subtable_header *header, const unsigned long end)
>>   	return 0;
>>   }
>>   
>> +#ifdef CONFIG_ARM_GIC
>> +/*
>> + * Hard code here, we can not get memory size from MADT (but FDT does),
>> + * this size is described in ARMv8 foudation model's User Guide
>> + */
>> +#define GIC_DISTRIBUTOR_MEMORY_SIZE (SZ_8K)
>> +#define GIC_CPU_INTERFACE_MEMORY_SIZE (SZ_4K)
> Aside from the incorrect sizes, how do you plan to address the other
> regions that the GICv2 specification describes?

Did these regions have the same base address? I mean the same
as GIC distributor base address and GIC cpu interface base address.

if yes, since the base address is stored in gic_init(), it can be for 
furture
use. if I misunderstood your question, please let me know.

>>   static int __init
>>   acpi_parse_gic_distributor(struct acpi_subtable_header *header,
>>   				const unsigned long end)
>>   {
>>   	struct acpi_madt_generic_distributor *distributor = NULL;
>> +	void __iomem *dist_base = NULL;
>> +	void __iomem *cpu_base = NULL;
>>   
>>   	distributor = (struct acpi_madt_generic_distributor *)header;
>>   
>> @@ -224,8 +235,43 @@ acpi_parse_gic_distributor(struct acpi_subtable_header *header,
>>   
>>   	acpi_table_print_madt_entry(header);
>>   
>> +	/* GIC is initialised after page_init(), no need for early_ioremap */
>> +	dist_base = ioremap(distributor->base_address,
>> +				GIC_CPU_INTERFACE_MEMORY_SIZE);
>> +	if (!dist_base) {
>> +		pr_warn(PREFIX "unable to map gic dist registers\n");
>> +		return -ENOMEM;
>> +	}
>> +
>> +	/*
>> +	 * acpi_lapic_addr is stored in acpi_parse_madt(),
>> +	 * so we can use it here for GIC init
>> +	 */
>> +	if (acpi_lapic_addr) {
>> +		iounmap(dist_base);
>> +		pr_warn(PREFIX "Invalid GIC cpu interface base address\n");
>> +		return -EINVAL;
>> +	}
>> +
>> +	cpu_base = ioremap(acpi_lapic_addr, GIC_CPU_INTERFACE_MEMORY_SIZE);
>> +	if (!cpu_base) {
>> +		iounmap(dist_base);
>> +		pr_warn(PREFIX "unable to map gic cpu registers\n");
>> +		return -ENOMEM;
>> +	}
>> +
>> +	gic_init(distributor->gic_id, -1, dist_base, cpu_base);
>> +
>>   	return 0;
>>   }
>> +#else
>> +static int __init
>> +acpi_parse_gic_distributor(struct acpi_subtable_header *header,
>> +				const unsigned long end)
>> +{
>> +	return -ENODEV;
>> +}
>> +#endif /* CONFIG_ARM_GIC */
>>   
>>   /*
>>    * Parse GIC cpu interface related entries in MADT
>> @@ -234,7 +280,7 @@ acpi_parse_gic_distributor(struct acpi_subtable_header *header,
>>   static int __init acpi_parse_madt_gic_entries(void)
>>   {
>>   	int count;
>> -
>> +
>>   	/*
>>   	 * do a partial walk of MADT to determine how many CPUs
>>   	 * we have including disabled CPUs
>> @@ -468,19 +514,21 @@ static void __init acpi_process_madt(void)
>>   		 * Parse MADT GIC cpu interface entries
>>   		 */
>>   		error = acpi_parse_madt_gic_entries();
>> -		if (!error) {
>> -			/*
>> -			 * Parse MADT GIC distributor entries
>> -			 */
>> -			acpi_parse_madt_gic_distributor_entries();
>> -		}
>> +		if (!error)
>> +			pr_info("Using ACPI for processor (GIC) configuration information\n");
>>   	}
>>   
>> -	pr_info("Using ACPI for processor (GIC) configuration information\n");
>> -
>>   	return;
>>   }
>>   
>> +int __init acpi_gic_init(void)
>> +{
>> +	/*
>> +	 * Parse MADT GIC distributor entries
>> +	 */
>> +	return acpi_parse_madt_gic_distributor_entries();
>> +}
>> +
> Why can't you do the GIC init in the GIC code? We've tried hard to make
> interrupt controllers discoverable and self contained.

thanks for your suggestion, Rob also had the same suggestion,
will try to update it in next version.

> What are you
> going to do when ACPI adds GICv3 to the mix? I don't really think this
> model (shoving everything into the core ACPI code) is sustainable in the
> long run...

Since GICv3 related ACPI proposal is not public and not goes into ACPI
spec, my suggestion is that we implement GICv2 only for now and post
another patches for GICv3 when the new ACPI spec is available.

Thanks
Hanjun
