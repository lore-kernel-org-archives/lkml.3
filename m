Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751772AbaCYHoq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 03:44:46 -0400
Received: from moutng.kundenserver.de ([212.227.17.13]:51811 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750903AbaCYHon (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 03:44:43 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Murali Karicheri <m-karicheri2@ti.com>, linux-pci@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Richard Zhu <r65037@freescale.com>, Kukjin Kim <kgene.kim@samsung.com>,
        Mohit Kumar <mohit.kumar@st.com>, Jingoo Han <jg1.han@samsung.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Bjorn Helgaas <bhelgaas@google.com>, Shawn Guo <shawn.guo@linaro.org>
Subject: Re: [RESEND: RFC PATCH 3/3] pcie: keystone: add pcie driver based on designware core driver
Date: Tue, 25 Mar 2014 08:44:36 +0100
Message-ID: <235376049.yyfljDtinu@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1395707726-20437-4-git-send-email-m-karicheri2@ti.com>
References: <1395707726-20437-1-git-send-email-m-karicheri2@ti.com> <1395707726-20437-4-git-send-email-m-karicheri2@ti.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:VZ0XLcMQ/07Wis5XLTs1C6NTdHHuqoUchHt3G1rvw4I
 5fnsg0iHTCg2i4/aTAYpVKCYtT7oDxlqrwOY9DfJj2rwdJDXXY
 V8MXD7nxbzgDrMhmlF7oAdXaAkNpF1lJBJ7bh9eB76pWIUceB4
 w5woU/90s5JStMNQWeA2+Sp7nox8dIlLd3J4aVYit3/jEsJ+cS
 SzYyWzk2qfqhrTENlslBhF8uGMqZiHCpqKKM2ICsCiR3/j6nfg
 KOXNi+kv5RhB9xPJl0F2n6/UKwUIJNViWgOnKLVSw7ngUnp/d9
 7jZrbnATOKV8EcXBwwH18NbxZVw8OoFuEphR1hXE2eQm7QAZ/7
 +Xr2Tqxkv8mKraHDZN0A=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 24 March 2014 20:35:26 Murali Karicheri wrote:
> +
> +int k2_pcie_platform_setup(struct platform_device *pdev)
> +{
> +	struct resource *phy_base_r, *devstat_r;
> +	void __iomem *phy_base, *devstat;
> +	u32 val;
> +	int i;
> +
> +	devstat_r = platform_get_resource_byname(pdev, IORESOURCE_MEM,
> +						 "reg_devcfg");
> +	if (!devstat_r)
> +		return -ENODEV;

It seems you have a distinct register set for the PHY that you are
driving here. Why not make this part generic PHY API driver?

> +static int ks_pcie_establish_link(struct keystone_pcie *ks_pcie)
> +{
> +	struct pcie_port *pp = &ks_pcie->pp;
> +	int count = 0;
> +
> +	dw_pcie_setup_rc(pp);
> +
> +	/* check if the link is up or not */
> +	while (!dw_pcie_link_up(pp)) {
> +		mdelay(100);
> +		count++;
> +		if (count == 10)
> +			return -EINVAL;
> +	}
> +	return 0;
> +}

You are blocking the CPU for up to one second here, which is really
nasty. Please find a way to move the code into a context where you
can sleep and use msleep() instead, or better use an interrupt if the
hardware supports that and use wait_for_completion().

> +
> +static void ks_pcie_msi_irq_handler(unsigned int irq, struct irq_desc *desc)
> +{
> +	struct keystone_pcie *ks_pcie = irq_desc_get_handler_data(desc);
> +	u32 offset = irq - ks_pcie->msi_host_irqs[0], pending, vector;
> +	struct pcie_port *pp = &ks_pcie->pp;
> +	struct irq_chip *chip = irq_desc_get_chip(desc);
> +	int src, virq;

Did I understand this right that the MSI implementation can be used
by any dw-pcie hardware of the same version? If so, it would be good
to move it into an extra file so it can be shared with the next host
driver that uses this version.

> +/**
> + * ks_pcie_set_outbound_trans() - Set PHYADDR <-> BUSADDR
> + * mapping for outbound
> + */
> +static void ks_pcie_set_outbound_trans(struct keystone_pcie *ks_pcie)

> +static void ks_pcie_set_inbound_trans(struct pcie_port *pp)

Why do you need to set this up from the kernel? Please move the
translation window setup into the boot loader if you can.

> +static struct hw_pci keystone_pcie_hw = {
> +	.nr_controllers	= 1,
> +	.setup		= dw_pcie_setup,
> +	.scan		= ks_pcie_scan_bus,
> +	.swizzle        = pci_common_swizzle,
> +	.add_bus	= dw_pcie_add_bus,
> +	.map_irq	= ks_pcie_map_irq,
> +};

This can just be a local variable in the probe function.

> +
> +static int ks_pcie_map_irq(const struct pci_dev *dev, u8 slot, u8 pin)
> +{
> +	struct pcie_port *pp = sys_to_pcie(dev->bus->sysdata);
> +	struct keystone_pcie *ks_pcie = to_keystone_pcie(pp);
> +
> +	dev_info(pp->dev, "ks_pcie_map_irq: pin %d\n", pin);
> +
> +	if (!pin || pin > ks_pcie->num_legacy_host_irqs) {
> +		dev_err(pp->dev, "pci irq pin out of range\n");
> +		return -1;
> +	}
> +
> +	/* pin has values from 1-4 */
> +	return (ks_pcie->virqs[pin - 1] >= 0) ?
> +		ks_pcie->virqs[pin - 1] : -1;
> +}
> +
> +
> +static void ack_irq(struct irq_data *d)
> +{
> +}
> +
> +static void mask_irq(struct irq_data *d)
> +{
> +}
> +
> +static void unmask_irq(struct irq_data *d)
> +{
> +}
> +
> +static struct irq_chip ks_pcie_legacy_irq_chip = {
> +	.name = "PCIe-LEGACY-IRQ",
> +	.irq_ack = ack_irq,
> +	.irq_mask = mask_irq,
> +	.irq_unmask = unmask_irq,
> +};

Can you use the generic irqchip code here?

> +	/*
> +	 * support upto MAX_LEGACY_HOST_IRQS host and legacy IRQs.
> +	 * In dt from index 0 to 3
> +	 */
> +	for (i = 0; i < MAX_LEGACY_HOST_IRQS; i++) {
> +		ks_pcie->legacy_host_irqs[i] = irq_of_parse_and_map(np, i);
> +		if (ks_pcie->legacy_host_irqs[i] < 0)
> +			break;
> +		ks_pcie->num_legacy_host_irqs++;
> +	}
> +
> +	if (ks_pcie->num_legacy_host_irqs) {
> +		ks_pcie->legacy_irqd = irq_domain_add_linear(np,
> +					ks_pcie->num_legacy_host_irqs,
> +					&irq_domain_simple_ops, NULL);
> +
> +		if (!ks_pcie->legacy_irqd) {
> +			dev_err(dev,
> +				"Failed to add irq domain for legacy irqs\n");
> +			return -EINVAL;
> +		}
> +	}
> +
> +	for (i = 0; i < ks_pcie->num_legacy_host_irqs; i++) {
> +		ks_pcie->virqs[i] =
> +			irq_create_mapping(ks_pcie->legacy_irqd, i);
> +		irq_set_chip_and_handler(ks_pcie->virqs[i],
> +			&ks_pcie_legacy_irq_chip, handle_level_irq);
> +		irq_set_chip_data(ks_pcie->virqs[i], ks_pcie);
> +		set_irq_flags(ks_pcie->virqs[i], IRQF_VALID);
> +
> +		if (ks_pcie->legacy_host_irqs[i] >= 0) {
> +			irq_set_handler_data(ks_pcie->legacy_host_irqs[i],
> +				ks_pcie);
> +			irq_set_chained_handler(ks_pcie->legacy_host_irqs[i],
> +				ks_pcie_legacy_irq_handler);
> +		}
> +		set_irq_flags(ks_pcie->legacy_host_irqs[i], IRQF_VALID);
> +	}

I have no idea how this would work with the standard interrupt-map property,
since the legacy interrupt host is now the same device as the pci host.

Maybe it's better to move the legacy irqchip handling entirely out of
the driver and use a separate device node for the registers so it can
come with its own #interrupt-cells, and then refer to this irqchip from
the interrupt-map.

> +	ks_pcie->clk = devm_clk_get(&pdev->dev, "pcie");
> +	if (IS_ERR(ks_pcie->clk)) {
> +		dev_err(&pdev->dev, "Failed to get pcie rc clock\n");
> +		return PTR_ERR(ks_pcie->clk);
> +	}
> +	ret = clk_prepare_enable(ks_pcie->clk);
> +	if (ret)
> +		return ret;

Could you move the clock handling into the generic dw-pcie code?

> +
> +/* Keystone PCIe driver does not allow module unload */
> +static int __init ks_pcie_init(void)
> +{
> +	return platform_driver_probe(&ks_pcie_driver, ks_pcie_probe);
> +}
> +subsys_initcall(ks_pcie_init);

Why subsys_initcall?

We should probably try to fix unloading soon.

> diff --git a/drivers/pci/host/pcie-ks-pdata.h b/drivers/pci/host/pcie-ks-pdata.h
> new file mode 100644
> index 0000000..a7626de
> --- /dev/null
> +++ b/drivers/pci/host/pcie-ks-pdata.h
> @@ -0,0 +1,19 @@
> +/*
> + * Copyright (C) 2013-2014 Texas Instruments., Ltd.
> + *		http://www.ti.com
> + *
> + * Author: Murali Karicheri <m-karicheri2@ti.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +
> +/* platform specific setup for k2 pcie */
> +int k2_pcie_platform_setup(struct platform_device *pdev);
> +
> +/* keystone pcie pdata configurations */
> +struct keystone_pcie_pdata {
> +	int (*setup)(struct platform_device *pdev);
> +};

This should all go away once you have a proper PHY driver.

> diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
> index 3a02717..7c3f777 100644
> --- a/drivers/pci/quirks.c
> +++ b/drivers/pci/quirks.c
> @@ -3461,3 +3461,15 @@ int pci_dev_specific_acs_enabled(struct pci_dev *dev, u16 acs_flags)
>  
>  	return -ENOTTY;
>  }
> +
> +#ifdef CONFIG_PCIE_KEYSTONE
> +/*
> + * The KeyStone PCIe controller has maximum read request size of 256 bytes.
> + * Force this configuration for all EP including bridges.
> + */
> +static void quirk_limit_readrequest(struct pci_dev *dev)
> +{
> +	pcie_set_readrq(dev, 256);
> +}
> +DECLARE_PCI_FIXUP_FINAL(PCI_ANY_ID, PCI_ANY_ID, quirk_limit_readrequest);
> +#endif /* CONFIG_TI_KEYSTONE_PCIE */

You can't do this:

A quirk for a specific hardware must not be enabled by compile-time options.
You have to find a different way to do this.

	Arnd

