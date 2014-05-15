Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753269AbaEOQXN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 12:23:13 -0400
Received: from mout.kundenserver.de ([212.227.17.24]:55232 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751256AbaEOQXL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 12:23:11 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Murali Karicheri <m-karicheri2@ti.com>, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Mohit Kumar <mohit.kumar@st.com>, Jingoo Han <jg1.han@samsung.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Bjorn Helgaas <bhelgaas@google.com>
Subject: Re: [PATCH v1 5/5] pci: keystone: add pcie driver based on designware core driver
Date: Thu, 15 May 2014 18:23:05 +0200
Message-ID: <6048322.x3M3sdDEWO@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1400169692-9677-6-git-send-email-m-karicheri2@ti.com>
References: <1400169692-9677-1-git-send-email-m-karicheri2@ti.com> <1400169692-9677-6-git-send-email-m-karicheri2@ti.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:P4wQGpmzjcO1z3HC1j8PsVyQfJKwfWpRshJLoWX6xe+
 KoK8i8SskcRxmL/0bJyVyLhwANKh2HsVoZlHgXf2PtJu2OaxlV
 ko68QCyEZYQWC/hYSho4fvnImi3i9itklCLuCoMm5nytTnUkHd
 AOCdCyrasIY9FIsRTZxVEOEieVvyDVXz0cK5zrcFDvpsPotI+n
 KMF7WasyNZeY1FvUU5/Sg60Lp7cGNBLFsLSPAdHApahbzUTlcA
 +o8hs/gDrc7956q9hJqrCDxMJBKni+I+FWR1LeITpKNgqPJJs2
 CUEWNqihpzDqnaGYqDz3jfR2t23H9GPLgyJEXjB6YHnHowRJiX
 uuBgBqivQ6efYul8LjCE=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 15 May 2014 12:01:32 Murali Karicheri wrote:

> +static int
> +keystone_pcie_fault(unsigned long addr, unsigned int fsr,
> +		struct pt_regs *regs)
> +{
> +	unsigned long instr = *(unsigned long *) instruction_pointer(regs);
> +
> +	if ((instr & 0x0e100090) == 0x00100090) {
> +		int reg = (instr >> 12) & 15;
> +
> +		regs->uregs[reg] = -1;
> +		regs->ARM_pc += 4;
> +	}
> +
> +	return 0;
> +}

This needs to check in the PCI host registers what happened and do
some appropriate action. If the fault was not caused by PCIe, it
should not be ignored here but get passed on to the next handler.

> +static int __init ks_pcie_probe(struct platform_device *pdev)
> +{
> +	struct device_node *np = pdev->dev.of_node;
> +	struct device *dev = &pdev->dev;
> +	struct keystone_pcie *ks_pcie;
> +	void __iomem *devstat;
> +	struct pcie_port *pp;
> +	struct resource *res;
> +	struct phy *phy;
> +	int ret = 0;
> +	u32 val;
> +
> +	ks_pcie = devm_kzalloc(&pdev->dev, sizeof(*ks_pcie),
> +				GFP_KERNEL);
> +	if (!ks_pcie) {
> +		dev_err(dev, "no memory for keystone pcie\n");
> +		return -ENOMEM;
> +	}
> +
> +	/* check if serdes phy needs to be enabled */
> +	if (of_get_property(np, "ti,init-phy", NULL) != NULL) {
> +		phy = devm_phy_get(dev, "pcie-phy");
> +			if (IS_ERR(phy))
> +				return PTR_ERR(phy);
> +
> +		ret = phy_init(phy);
> +		if (ret < 0)
> +			return ret;
> +	}

I think you can just call devm_phy_get() unconditionally here and
get rid of the ti,init-phy property. If there is no phy, don't
initialize it.

> +
> +	ret = add_pcie_port(ks_pcie, pdev);
> +	if (ret < 0)
> +		goto fail_clk;
> +
> +	platform_set_drvdata(pdev, ks_pcie);

Set the platform data first, then add the port.

> +	dev_info(dev, "pcie rc probe success\n");

Remove this.

> +#ifdef CONFIG_PCI_KEYSTONE
> +/*
> + * The KeyStone PCIe controller has maximum read request size of 256 bytes.
> + */
> +static void quirk_limit_readrequest(struct pci_dev *dev)
> +{
> +	int readrq = pcie_get_readrq(dev);
> +
> +	if (readrq > 256)
> +		pcie_set_readrq(dev, 256);
> +}
> +DECLARE_PCI_FIXUP_FINAL(PCI_ANY_ID, PCI_ANY_ID, quirk_limit_readrequest);
> +#endif /* CONFIG_PCI_KEYSTONE */

This doesn't work: you can't just limit do this for all devices just based
on PCI_KEYSTONE being enabled, you have to check if you are actually using
this controller.

	Arnd
