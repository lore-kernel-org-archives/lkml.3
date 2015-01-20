Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755249AbbATNHm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 08:07:42 -0500
Received: from mx1.redhat.com ([209.132.183.28]:45178 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754756AbbATNHk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 08:07:40 -0500
Message-ID: <54BE529E.7070608@redhat.com>
Date: Tue, 20 Jan 2015 08:05:34 -0500
From: Jon Masters <jcm@redhat.com>
Organization: Red Hat, Inc.
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Tomasz Nowicki <tomasz.nowicki@linaro.org>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Hanjun Guo <hanjun.guo@linaro.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        Mark Rutland <Mark.Rutland@arm.com>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        Will Deacon <Will.Deacon@arm.com>
CC: Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        "graeme.gregory@linaro.org" <graeme.gregory@linaro.org>,
        Sudeep Holla <Sudeep.Holla@arm.com>,
        Jason Cooper <jason@lakedaemon.net>,
        Bjorn Helgaas <bhelgaas@google.com>, Mark Brown <broonie@kernel.org>,
        Rob Herring <robh@kernel.org>, Robert Richter <rric@kernel.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Charles Garcia-Tobin <Charles.Garcia-Tobin@arm.com>,
        "phoenix.liyi@huawei.com" <phoenix.liyi@huawei.com>,
        Timur Tabi <timur@codeaurora.org>,
        "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>,
        "wangyijing@huawei.com" <wangyijing@huawei.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linaro-acpi@lists.linaro.org" <linaro-acpi@lists.linaro.org>
Subject: Re: [PATCH v7 13/17] ARM64 / ACPI: Add GICv2 specific ACPI boot support
References: <1421247905-3749-1-git-send-email-hanjun.guo@linaro.org> <1421247905-3749-14-git-send-email-hanjun.guo@linaro.org> <54B8F2E3.80306@arm.com> <54BE308E.8060407@linaro.org>
In-Reply-To: <54BE308E.8060407@linaro.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/20/2015 05:40 AM, Tomasz Nowicki wrote:
> Hi Marc,
> 
> On 16.01.2015 12:15, Marc Zyngier wrote:
>> On 14/01/15 15:05, Hanjun Guo wrote:
>>> From: Tomasz Nowicki <tomasz.nowicki@linaro.org>
>>>
>>> ACPI kernel uses MADT table for proper GIC initialization. It needs to
>>> parse GIC related subtables, collect CPU interface and distributor
>>> addresses and call driver initialization function (which is hardware
>>> abstraction agnostic). In a similar way, FDT initialize GICv1/2.
>>>
>>> NOTE: This commit allow to initialize GICv1/2 basic functionality.
>>> GICv2 vitalization extension, GICv3/4 and ITS are considered as next
>>> steps.
>>
>> And so is GICv2m, apparently (see below).
>>
>>>
>>> Tested-by: Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>
>>> Tested-by: Yijing Wang <wangyijing@huawei.com>
>>> Signed-off-by: Tomasz Nowicki <tomasz.nowicki@linaro.org>
>>> Signed-off-by: Hanjun Guo <hanjun.guo@linaro.org>
>>> ---
>>>   arch/arm64/kernel/acpi.c             |  26 +++++++++
>>>   drivers/irqchip/irq-gic.c            | 108 +++++++++++++++++++++++++++++++++++
>>>   drivers/irqchip/irqchip.c            |   3 +
>>>   include/linux/irqchip/arm-gic-acpi.h |  31 ++++++++++
>>>   4 files changed, 168 insertions(+)
>>>   create mode 100644 include/linux/irqchip/arm-gic-acpi.h
>>>
>>> diff --git a/arch/arm64/kernel/acpi.c b/arch/arm64/kernel/acpi.c
>>> index c3e24c4..ea3c9fc 100644
>>> --- a/arch/arm64/kernel/acpi.c
>>> +++ b/arch/arm64/kernel/acpi.c
>>> @@ -23,6 +23,7 @@
>>>   #include <linux/irqdomain.h>
>>>   #include <linux/bootmem.h>
>>>   #include <linux/smp.h>
>>> +#include <linux/irqchip/arm-gic-acpi.h>
>>>
>>>   #include <asm/cputype.h>
>>>   #include <asm/cpu_ops.h>
>>> @@ -315,6 +316,31 @@ void __init acpi_boot_table_init(void)
>>>   		pr_err("Can't find FADT or error happened during parsing FADT\n");
>>>   }
>>>
>>> +void __init acpi_gic_init(void)
>>> +{
>>> +	struct acpi_table_header *table;
>>> +	acpi_status status;
>>> +	acpi_size tbl_size;
>>> +	int err;
>>> +
>>> +	if (acpi_disabled)
>>> +		return;
>>> +
>>> +	status = acpi_get_table_with_size(ACPI_SIG_MADT, 0, &table, &tbl_size);
>>> +	if (ACPI_FAILURE(status)) {
>>> +		const char *msg = acpi_format_exception(status);
>>> +
>>> +		pr_err("Failed to get MADT table, %s\n", msg);
>>> +		return;
>>> +	}
>>> +
>>> +	err = gic_v2_acpi_init(table);
>>> +	if (err)
>>> +		pr_err("Failed to initialize GIC IRQ controller");
>>> +
>>> +	early_acpi_os_unmap_memory((char *)table, tbl_size);
>>> +}
>>> +
>>>   static int __init parse_acpi(char *arg)
>>>   {
>>>   	if (!arg)
>>> diff --git a/drivers/irqchip/irq-gic.c b/drivers/irqchip/irq-gic.c
>>> index d617ee5..89a8120 100644
>>> --- a/drivers/irqchip/irq-gic.c
>>> +++ b/drivers/irqchip/irq-gic.c
>>> @@ -33,12 +33,14 @@
>>>   #include <linux/of.h>
>>>   #include <linux/of_address.h>
>>>   #include <linux/of_irq.h>
>>> +#include <linux/acpi.h>
>>>   #include <linux/irqdomain.h>
>>>   #include <linux/interrupt.h>
>>>   #include <linux/percpu.h>
>>>   #include <linux/slab.h>
>>>   #include <linux/irqchip/chained_irq.h>
>>>   #include <linux/irqchip/arm-gic.h>
>>> +#include <linux/irqchip/arm-gic-acpi.h>
>>>
>>>   #include <asm/cputype.h>
>>>   #include <asm/irq.h>
>>> @@ -1083,3 +1085,109 @@ IRQCHIP_DECLARE(msm_8660_qgic, "qcom,msm-8660-qgic", gic_of_init);
>>>   IRQCHIP_DECLARE(msm_qgic2, "qcom,msm-qgic2", gic_of_init);
>>>
>>>   #endif
>>> +
>>> +#ifdef CONFIG_ACPI
>>> +static phys_addr_t dist_phy_base, cpu_phy_base;
>>> +static int cpu_base_assigned;
>>> +
>>> +static int __init
>>> +gic_acpi_parse_madt_cpu(struct acpi_subtable_header *header,
>>> +			const unsigned long end)
>>> +{
>>> +	struct acpi_madt_generic_interrupt *processor;
>>> +	phys_addr_t gic_cpu_base;
>>> +
>>> +	processor = (struct acpi_madt_generic_interrupt *)header;
>>> +
>>> +	if (BAD_MADT_ENTRY(processor, end))
>>> +		return -EINVAL;
>>> +
>>> +	/*
>>> +	 * There is no support for non-banked GICv1/2 register in ACPI spec.
>>> +	 * All CPU interface addresses have to be the same.
>>> +	 */
>>> +	gic_cpu_base = processor->base_address;
>>> +	if (cpu_base_assigned && gic_cpu_base != cpu_phy_base)
>>> +		return -EFAULT;
>>
>> EFAULT? That feels weird. This error code should be returned if an
>> access would generate (or has actually generated) a fault, but this is
>> not the case here. Same for the other cases below.
> Right, will fix that and other cases too.
> 
>>
>>> +
>>> +	cpu_phy_base = gic_cpu_base;
>>> +	cpu_base_assigned = 1;
>>> +	return 0;
>>> +}
>>> +
>>> +static int __init
>>> +gic_acpi_parse_madt_distributor(struct acpi_subtable_header *header,
>>> +				const unsigned long end)
>>> +{
>>> +	struct acpi_madt_generic_distributor *dist;
>>> +
>>> +	dist = (struct acpi_madt_generic_distributor *)header;
>>> +
>>> +	if (BAD_MADT_ENTRY(dist, end))
>>> +		return -EINVAL;
>>> +
>>> +	dist_phy_base = dist->base_address;
>>> +	return 0;
>>> +}
>>> +
>>> +int __init
>>> +gic_v2_acpi_init(struct acpi_table_header *table)
>>> +{
>>> +	void __iomem *cpu_base, *dist_base;
>>> +	int count;
>>> +
>>> +	/* Collect CPU base addresses */
>>> +	count = acpi_parse_entries(ACPI_SIG_MADT,
>>> +				   sizeof(struct acpi_table_madt),
>>> +				   gic_acpi_parse_madt_cpu, table,
>>> +				   ACPI_MADT_TYPE_GENERIC_INTERRUPT, 0);
>>> +	if (count < 0) {
>>> +		pr_err("Error during GICC entries parsing\n");
>>> +		return -EFAULT;
>>> +	} else if (!count) {
>>> +		pr_err("No valid GICC entries exist\n");
>>> +		return -EINVAL;
>>> +	}
>>> +
>>> +	/*
>>> +	 * Find distributor base address. We expect one distributor entry since
>>> +	 * ACPI 5.1 spec neither support multi-GIC instances nor GIC cascade.
>>> +	 */
>>> +	count = acpi_parse_entries(ACPI_SIG_MADT,
>>> +				   sizeof(struct acpi_table_madt),
>>> +				   gic_acpi_parse_madt_distributor, table,
>>> +				   ACPI_MADT_TYPE_GENERIC_DISTRIBUTOR, 0);
>>> +	if (count <= 0) {
>>> +		pr_err("Error during GICD entries parsing\n");
>>> +		return -EFAULT;
>>> +	} else if (!count) {
>>> +		pr_err("No valid GICD entries exist\n");
>>> +		return -EINVAL;
>>> +	} else if (count > 1) {
>>> +		pr_err("More than one GICD entry detected\n");
>>> +		return -EINVAL;
>>> +	}
>>> +
>>> +	cpu_base = ioremap(cpu_phy_base, ACPI_GIC_CPU_IF_MEM_SIZE);
>>> +	if (!cpu_base) {
>>> +		pr_err("Unable to map GICC registers\n");
>>> +		return -ENOMEM;
>>> +	}
>>> +
>>> +	dist_base = ioremap(dist_phy_base, ACPI_GICV2_DIST_MEM_SIZE);
>>> +	if (!dist_base) {
>>> +		pr_err("Unable to map GICD registers\n");
>>> +		iounmap(cpu_base);
>>> +		return -ENOMEM;
>>> +	}
>>> +
>>> +	/*
>>> +	 * Initialize zero GIC instance (no multi-GIC support). Also, set GIC
>>> +	 * as default IRQ domain to allow for GSI registration and GSI to IRQ
>>> +	 * number translation (see acpi_register_gsi() and acpi_gsi_to_irq()).
>>> +	 */
>>> +	gic_init_bases(0, -1, dist_base, cpu_base, 0, NULL);
>>
>> I assume you never tried to port the GICv2m driver to ACPI, right?

Just a data point - it's working with an additional patch that we carry
internally to initialize GICv2m with the appropriate MADT substructures
(and it works well). Once I get a moment I'll ask why it's not posted.

Jon.


