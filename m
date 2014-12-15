Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750945AbaLOU6g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 15:58:36 -0500
Received: from mail.kmu-office.ch ([178.209.48.109]:52161 "EHLO
	mail.kmu-office.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750770AbaLOU6f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 15:58:35 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Date: Mon, 15 Dec 2014 21:58:24 +0100
From: Stefan Agner <stefan@agner.ch>
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: tglx@linutronix.de, jason@lakedaemon.net, u.kleine-koenig@pengutronix.de,
        shawn.guo@linaro.org, kernel@pengutronix.de, arnd@arndb.de,
        robh+dt@kernel.org, Pawel Moll <Pawel.Moll@arm.com>,
        Mark Rutland <Mark.Rutland@arm.com>, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, linux@arm.linux.org.uk,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/3] irqchip: vf610-mscm: add support for MSCM
 interrupt router
In-Reply-To: <548EB0FD.3030206@arm.com>
References: <1418594998-2361-1-git-send-email-stefan@agner.ch>
 <1418594998-2361-2-git-send-email-stefan@agner.ch>
 <548EB0FD.3030206@arm.com>
Message-ID: <41a603b345dbee4f2507e80ea0f8bb96@agner.ch>
User-Agent: Roundcube Webmail/1.0.3
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Mon Dec 15 21:57:39 2014
X-DSPAM-Confidence: 0.9899
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 548f4b4312815958119392
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-12-15 10:59, Marc Zyngier wrote:
> Hi Stefan,
> 
> On 14/12/14 22:09, Stefan Agner wrote:
>> This adds support for Vybrid's interrupt router. On VF6xx models,
>> almost all peripherals can be accessed from either of the two
>> CPU's, from the Cortex-A5 or from the Cortex-M4. The interrupt
>> router routes the peripheral interrupts to the configured CPU.
>>
>> The driver makes use of the irqdomain hierarchy support. The
>> parent is either the ARM GIC or the ARM NVIC interrupt controller
>> depending on which CPU the kernel is executed on. Currently only
>> ARM GIC is supported because the NVIC driver lacks hierarchical
>> irqdomain support as of now.
>>
>> Currently, there is no resource control mechnism implemented to
>> avoid concurrent access of the same peripheral. The user needs
>> to make sure to use device trees which assign the peripherals
>> orthogonally. However, this driver warns the user in case the
>> interrupt is already configured for the other CPU. This provides
>> a poor man's resource controller.
>>
>> Signed-off-by: Stefan Agner <stefan@agner.ch>
>> ---
>> Thanks for the feedback on the initial driver, I'm quite happy
>> with the outcome using the hierarchic irqdomain support.
> 
> Great stuff, pleased to see the stacked domain proving to be useful.
> 
>> The driver is tested on Vybrid running on the Cortex-A5 CPU.
>> However, to properly support Cortex-M4, some more work will be
>> needed. Beside the hierarchic irqdomain support for NVIC, the
>> different IRQ cell layout need to be solved: NVIC uses only
>> one cell, whereas GIC uses three. I see two possible solutions:
>> - Support two layouts in this driver. Maybe by using IS_ENABLED,
>>   since it is not possible to compile a kernel for the A5 and
>>   M4.
>> - Define a 3 cell layout as GIC uses it for the MSCM, and pass
>>   a syntetic one cell layout to the parent when calling
>>   irq_domain_alloc_irqs_parent. This driver would then still
>>   need to know what type of interrupt controller the parent is...
>>
>> Ideas/advice welcome...
> 
> You shouldn't use the GIC format for the MSCM, as it doesn't mean
> anything for it. Yes, I know that everybody did that, but that's just
> wrong (MSCM itself shouldn't care about SPIs, except when it is actually
> talking to a GIC). The only reason I didn't clean that up in my ongoing
> series is to avoid having to rewrite all the DTs entirely.
> 
> My hunch is that you should have a MSCM-specific interrupt description
> (I guess two cells should be enough, one for the interrupt number and
> one for the trigger if necessary), and translate this to the format that
> the backing interrupt controller is using (only the map function should
> be affected).

Ok, so foremost you suggest to use always the same interrupt
specification, no matter if I use the dt for the A5 or the M4. Hm, just
some weeks ago I extracted the interrupt properties of all peripherals
and made a base device tree without interrupt properties, just so that I
could create a device tree with the interrupt properties for NVIC and
one for GIC (see vf500.dtsi vs the preliminary vf610m4.dtsi from the
Cortex-M4 support patchset). Back then, I did not put much thought into
MSCM etc., and just adjusted the interrupt properties to the needs of
those two interrupt controllers. When having a common definition, I can
merge those interrupt nodes back into the common device tree, which is
much nicer anyway!

Regarding format, since I have to touch all the interrupt properties
anyway, it's not much hassle to use a new format in that process. So my
MSCM format would be, as you suggested, two cells with interrupt number
and the trigger specification (IRQ_TYPE... from
./include/dt-bindings/interrupt-controller/irq.h).

One open thing: How should I determine the backing interrupt controller?
Maybe by just reading the interrupt-cells property of the parent
interrupt controller, and depending on the cell count create that
format?

> 
> That would also make your DT binding a lot less ambiguous.
> 
> Other than that, it looks pretty good to me. Just a few cosmetic remarks
> below:
> 
>>
>>  arch/arm/mach-imx/Kconfig        |   1 +
>>  drivers/irqchip/Kconfig          |  11 +++
>>  drivers/irqchip/Makefile         |   1 +
>>  drivers/irqchip/irq-vf610-mscm.c | 198 +++++++++++++++++++++++++++++++++++++++
>>  4 files changed, 211 insertions(+)
>>  create mode 100644 drivers/irqchip/irq-vf610-mscm.c
>>
>> diff --git a/arch/arm/mach-imx/Kconfig b/arch/arm/mach-imx/Kconfig
>> index e8627e0..3c5859e 100644
>> --- a/arch/arm/mach-imx/Kconfig
>> +++ b/arch/arm/mach-imx/Kconfig
>> @@ -631,6 +631,7 @@ config SOC_IMX6SX
>>
>>  config SOC_VF610
>>  	bool "Vybrid Family VF610 support"
>> +	select VF610_MSCM
>>  	select ARM_GIC
>>  	select PINCTRL_VF610
>>  	select PL310_ERRATA_769419 if CACHE_L2X0
>> diff --git a/drivers/irqchip/Kconfig b/drivers/irqchip/Kconfig
>> index cc79d2a..af5e72a 100644
>> --- a/drivers/irqchip/Kconfig
>> +++ b/drivers/irqchip/Kconfig
>> @@ -136,6 +136,17 @@ config IRQ_CROSSBAR
>>  	  a free irq and configures the IP. Thus the peripheral interrupts are
>>  	  routed to one of the free irqchip interrupt lines.
>>
>> +config VF610_MSCM
>> +	bool
>> +	help
>> +	  Support for MSCM interrupt router available on Vybrid SoC's. The
>> +	  interrupt router is between the CPU's interrupt controller and the
>> +	  peripheral. The router allows to route the peripheral interrupts to
>> +	  one of the two available CPU's on Vybrid VF6xx SoC's (Cortex-A5 or
>> +	  Cortex-M4). The router will be configured transparently on a IRQ
>> +	  request.
>> +	select IRQ_DOMAIN_HIERARCHY
>> +
>>  config KEYSTONE_IRQ
>>  	tristate "Keystone 2 IRQ controller IP"
>>  	depends on ARCH_KEYSTONE
>> diff --git a/drivers/irqchip/Makefile b/drivers/irqchip/Makefile
>> index 9516a32..85651be 100644
>> --- a/drivers/irqchip/Makefile
>> +++ b/drivers/irqchip/Makefile
>> @@ -37,6 +37,7 @@ obj-$(CONFIG_TB10X_IRQC)		+= irq-tb10x.o
>>  obj-$(CONFIG_XTENSA)			+= irq-xtensa-pic.o
>>  obj-$(CONFIG_XTENSA_MX)			+= irq-xtensa-mx.o
>>  obj-$(CONFIG_IRQ_CROSSBAR)		+= irq-crossbar.o
>> +obj-$(CONFIG_VF610_MSCM)		+= irq-vf610-mscm.o
>>  obj-$(CONFIG_BCM7120_L2_IRQ)		+= irq-bcm7120-l2.o
>>  obj-$(CONFIG_BRCMSTB_L2_IRQ)		+= irq-brcmstb-l2.o
>>  obj-$(CONFIG_KEYSTONE_IRQ)		+= irq-keystone.o
>> diff --git a/drivers/irqchip/irq-vf610-mscm.c b/drivers/irqchip/irq-vf610-mscm.c
>> new file mode 100644
>> index 0000000..1597185
>> --- /dev/null
>> +++ b/drivers/irqchip/irq-vf610-mscm.c
>> @@ -0,0 +1,198 @@
>> +/*
>> + * Copyright 2014 Stefan Agner
>> + *
>> + * The code contained herein is licensed under the GNU General Public
>> + * License. You may obtain a copy of the GNU General Public License
>> + * Version 2 or later at the following locations:
>> + *
>> + * http://www.opensource.org/licenses/gpl-license.html
>> + * http://www.gnu.org/copyleft/gpl.html
>> + */
>> +
>> +#include <linux/cpu_pm.h>
>> +#include <linux/io.h>
>> +#include <linux/irq.h>
>> +#include <linux/irqdomain.h>
>> +#include <linux/of.h>
>> +#include <linux/of_address.h>
>> +#include <linux/slab.h>
>> +
>> +#include "irqchip.h"
>> +
>> +#define MSCM_CPxNUM		0x4
>> +#define MSCM_IRSPRC(n)		(0x880 + 2 * (n))
>> +#define MSCM_IRSPRC_CPEN_MASK	0x3
>> +
>> +#define MSCM_IRSPRC_NUM		112
>> +
>> +struct vf610_mscm_chip_data {
>> +	void __iomem *mscm_base;
>> +	u16 cpu_mask;
>> +	u16 mscm_saved_irsprc[MSCM_IRSPRC_NUM];
>> +};
>> +
>> +static struct vf610_mscm_chip_data *chip_data;
>> +
>> +static int vf610_mscm_notifier(struct notifier_block *self, unsigned long cmd,
>> +			       void *v)
>> +{
>> +	int i;
>> +
>> +	switch (cmd) {
>> +	case CPU_CLUSTER_PM_ENTER:
>> +		for (i = 0; i < MSCM_IRSPRC_NUM; i++)
>> +			chip_data->mscm_saved_irsprc[i] = readw_relaxed(
>> +					chip_data->mscm_base + MSCM_IRSPRC(i));
> 
> Please keep the argument to readw_relaxed on the same line as the
> function call. Makes it easier to read.
> 
>> +		break;
>> +	case CPU_CLUSTER_PM_ENTER_FAILED:
>> +	case CPU_CLUSTER_PM_EXIT:
>> +		for (i = 0; i < MSCM_IRSPRC_NUM; i++)
>> +			writew_relaxed(chip_data->mscm_saved_irsprc[i],
>> +				       chip_data->mscm_base + MSCM_IRSPRC(i));
>> +		break;
>> +	}
>> +
>> +	return NOTIFY_OK;
>> +}
>> +
>> +static struct notifier_block mscm_notifier_block = {
>> +	.notifier_call = vf610_mscm_notifier,
>> +};
>> +
>> +static void vf610_mscm_enable(struct irq_data *data)
>> +{
>> +	irq_hw_number_t hwirq = data->hwirq;
>> +	struct vf610_mscm_chip_data *chip_data = data->chip_data;
>> +	u16 irsprc;
>> +
>> +	irsprc = readw_relaxed(chip_data->mscm_base + MSCM_IRSPRC(hwirq));
>> +	irsprc &= MSCM_IRSPRC_CPEN_MASK;
>> +
>> +	WARN_ON(irsprc);
> 
> Does this read have an influence on the interrupt routing?

No it doesn't. The warn here implements the poor man's resource
controller (see commit message above).

> 
>> +
>> +	writew_relaxed(chip_data->cpu_mask,
>> +		       chip_data->mscm_base + MSCM_IRSPRC(hwirq));
>> +
>> +	irq_chip_unmask_parent(data);
>> +}
>> +
>> +static void vf610_mscm_disable(struct irq_data *data)
>> +{
>> +	irq_hw_number_t hwirq = data->hwirq;
>> +	struct vf610_mscm_chip_data *chip_data = data->chip_data;
>> +	u16 irsprc;
>> +
>> +	irsprc = readw_relaxed(chip_data->mscm_base + MSCM_IRSPRC(hwirq));
>> +	irsprc &= MSCM_IRSPRC_CPEN_MASK;
> 
> And this one?

Ok, I had a warning in disable too before, but now this read is really
superfluous.

> 
>> +	writew_relaxed(0x0, chip_data->mscm_base + MSCM_IRSPRC(hwirq));
>> +
>> +	irq_chip_mask_parent(data);
>> +}
>> +
>> +static struct irq_chip vf610_mscm_irq_chip = {
>> +	.name			= "MSCM_IR",
>> +	.irq_mask		= irq_chip_mask_parent,
>> +	.irq_unmask		= irq_chip_unmask_parent,
>> +	.irq_eoi		= irq_chip_eoi_parent,
>> +	.irq_enable		= vf610_mscm_enable,
>> +	.irq_disable		= vf610_mscm_disable,
>> +	.irq_retrigger		= irq_chip_retrigger_hierarchy,
>> +	.irq_set_affinity	= irq_chip_set_affinity_parent,
>> +};
>> +
>> +static int vf610_mscm_domain_xlate(struct irq_domain *d,
>> +				struct device_node *controller,
>> +				const u32 *intspec, unsigned int intsize,
>> +				unsigned long *out_hwirq,
>> +				unsigned int *out_type)
>> +{
>> +	if (intsize != 3)
>> +		return -EINVAL;
>> +
>> +	/* MSCM doesn't handle PPI */
>> +	if (intspec[0])
>> +		return -EINVAL;
>> +
>> +	*out_hwirq = intspec[1];
>> +	*out_type = intspec[2] & IRQ_TYPE_SENSE_MASK;
>> +	return 0;
>> +}
>> +
>> +static int vf610_mscm_domain_alloc(struct irq_domain *domain, unsigned int virq,
>> +				   unsigned int nr_irqs, void *arg)
>> +{
>> +	int i;
>> +	irq_hw_number_t hwirq;
>> +	struct of_phandle_args *irq_data = arg;
>> +	struct of_phandle_args gic_data = *irq_data;
>> +
>> +	if (irq_data->args_count != 3)
>> +		return -EINVAL;
>> +
>> +	/* MSCM doesn't handle PPI */
>> +	if (irq_data->args[0])
>> +		return -EINVAL;
>> +
>> +	hwirq = irq_data->args[1];
>> +	for (i = 0; i < nr_irqs; i++)
>> +		irq_domain_set_hwirq_and_chip(domain, virq + i, hwirq + i,
>> +					      &vf610_mscm_irq_chip,
>> +					      domain->host_data);
>> +
>> +	gic_data.np = domain->parent->of_node;
>> +	return irq_domain_alloc_irqs_parent(domain, virq, nr_irqs, &gic_data);
>> +}
>> +
>> +static const struct irq_domain_ops mscm_irq_domain_ops = {
>> +	.xlate = vf610_mscm_domain_xlate,
>> +	.alloc = vf610_mscm_domain_alloc,
>> +	.free = irq_domain_free_irqs_common,
>> +};
>> +
>> +static int __init vf610_mscm_of_init(struct device_node *node,
>> +			       struct device_node *parent)
>> +{
>> +	struct irq_domain *domain, *domain_parent;
>> +	int ret;
>> +
>> +	domain_parent = irq_find_host(parent);
>> +	if (!domain_parent) {
>> +		pr_err("vf610_mscm: interrupt-parent not found\n");
>> +		return -EINVAL;
>> +	}
>> +
>> +	chip_data = kzalloc(sizeof(*chip_data), GFP_KERNEL);
>> +	if (!chip_data)
>> +		return -ENOMEM;
>> +
>> +	chip_data->mscm_base = of_io_request_and_map(node, 0, "mscm");
>> +
>> +	if (!chip_data->mscm_base) {
>> +		pr_err("vf610_mscm: unable to map mscm register\n");
>> +		ret = -ENOMEM;
>> +		goto out_free;
>> +	}
>> +
>> +	domain = irq_domain_add_hierarchy(domain_parent, 0,
>> +					  MSCM_IRSPRC_NUM, node,
>> +					  &mscm_irq_domain_ops, chip_data);
>> +	if (!domain) {
>> +		ret = -ENOMEM;
>> +		goto out_unmap;
>> +	}
>> +
>> +	chip_data->cpu_mask = 0x1 <<
>> +		readl_relaxed(chip_data->mscm_base + MSCM_CPxNUM);
> 
> That's a bit hard to read. Put it on the same line.
> 
>> +
>> +	cpu_pm_register_notifier(&mscm_notifier_block);
>> +
>> +	return 0;
>> +
>> +out_unmap:
>> +	iounmap(chip_data->mscm_base);
>> +out_free:
>> +	kfree(chip_data);
>> +	return ret;
>> +}
>> +IRQCHIP_DECLARE(vf610_mscm, "fsl,vf610-mscm", vf610_mscm_of_init);
>>
> 
> Otherwise, looks pretty good to me.
> 

The same line adjustment will break the 80 character border... But I
agree, it's ugly the way it is now. Will put them in the same line. 

--
Stefan

