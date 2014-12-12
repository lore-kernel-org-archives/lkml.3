Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967729AbaLLMaO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 07:30:14 -0500
Received: from mout.kundenserver.de ([212.227.17.24]:57365 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967609AbaLLMaK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 07:30:10 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Ray Jui <rjui@broadcom.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>,
        Christian Daudt <bcm@fixthebug.org>, Matt Porter <mporter@linaro.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Lucas Stach <l.stach@pengutronix.de>,
        Scott Branden <sbranden@broadcom.com>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        bcm-kernel-feedback-list@broadcom.com, devicetree@vger.kernel.org,
        hauke@hauke-m.de
Subject: Re: [PATCH v2 2/4] PCI: iproc: Add Broadcom iProc PCIe driver
Date: Fri, 12 Dec 2014 13:29:20 +0100
Message-ID: <2190666.DfrpWiLTCc@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1418351817-14898-3-git-send-email-rjui@broadcom.com>
References: <1418351817-14898-3-git-send-email-rjui@broadcom.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V03:K0:++maxZiWU/mf3TxYjESTR/toqmcPdm/X0Rrxi9hDnO6SLmF/x01
 Ea2p8IUvxmZ4hyWo1F4ls+d9T2xhy6icSqfaU4QQItD3YnwmuPxrW/6YudRGZPxKQ7X+tGQ
 9mbXLlfEYN+p2BXIbdAstBijhMXsOa+nsvN55l715Rlw36Hz74IzzgVFlyzi8T1PN0zyQck
 RGxxmote2sZZm5bmHRDFA==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 11 December 2014 18:36:55 Ray Jui wrote:
> Add initial version of the Broadcom iProc PCIe driver. This driver
> has been tested on NSP and Cygnus and is expected to work on all iProc
> family of SoCs that deploys the same PCIe host controller
>
> The driver also supports MSI

Overall, I'm not convinced it's worth continuing this driver. While it
supports more features, Hauke's version seemed much cleaner, and I'd
rather see his driver merged and have you add the additional features.

Why did you drop him from Cc again?

> +
> +#define MII_MGMT_CTRL_OFFSET         0x000
> +#define MII_MGMT_CTRL_MDCDIV_SHIFT   0
> +#define MII_MGMT_CTRL_PRE_SHIFT      7
> +#define MII_MGMT_CTRL_BUSY_SHIFT     8
> +#define MII_MGMT_CTRL_EXT_SHIFT      9
> +#define MII_MGMT_CTRL_BTP_SHIFT      10

As mentioned, better move all the MII handling to a separate driver.

> +struct iproc_pcie;
> +
> +/**
> + * iProc MSI
> + * @pcie: pointer to the iProc PCIe data structure
> + * @irq_in_use: bitmap of MSI IRQs that are in use
> + * @domain: MSI IRQ domain
> + * @chip: MSI controller
> + * @eq_page: memory page to store the iProc MSI event queue
> + * @msi_page: memory page for MSI posted writes
> + */
> +struct iproc_msi {
> +	struct iproc_pcie *pcie;
> +	DECLARE_BITMAP(irq_in_use, MAX_IRQS);
> +	struct irq_domain *domain;
> +	struct msi_controller chip;
> +	unsigned long eq_page;
> +	unsigned long msi_page;
> +};

Same for MSI. I would assume that you will eventually have
chips with this PCI core and a GICv2m or GICv3, so it would
be better to reference the MSI controller through an msi-parent
reference that can be replaced with a reference to the GIC.

> +
> +	u32 phy_addr;

struct phy *phy;

> +	int irqs[MAX_IRQS];

Please name these irqs individually according to what they do.
The MSI IRQ should of course be moved to the MSI driver.

> +	struct iproc_msi msi;
> +};
> +
> +static inline int mdio_wait_idle(struct iproc_pcie *pcie)
> +{
> +	int timeout = MDIO_TIMEOUT_USEC;
> +
> +	while (readl(pcie->mii + MII_MGMT_CTRL_OFFSET) &
> +			(1 << MII_MGMT_CTRL_BUSY_SHIFT)) {
> +		udelay(1);
> +		if (timeout-- <= 0)
> +			return -EBUSY;
> +	}
> +	return 0;
> +}

Better use ktime_get()/ktime_add_ns()/ktime_before() loop here
to do an accurate timeout.

> +static void iproc_pcie_reset(struct iproc_pcie *pcie)
> +{
> +	u32 val;
> +
> +	/* send a downstream reset */
> +	val = EP_MODE_SURVIVE_PERST | RC_PCIE_RST_OUTPUT;
> +	writel(val, pcie->reg + CLK_CONTROL_OFFSET);
> +	udelay(250);
> +	val &= ~EP_MODE_SURVIVE_PERST;
> +	writel(val, pcie->reg + CLK_CONTROL_OFFSET);
> +	mdelay(250);
> +}

250ms delay is not acceptable. Please find a way to call this function
from a context in which you can sleep.

> +static int iproc_pcie_check_link(struct iproc_pcie *pcie)
> +{
> +	int ret;
> +	u8 nlw;
> +	u16 pos, tmp16;
> +	u32 val;
> +	struct pci_sys_data sys;
> +	struct pci_bus bus;
> +
> +	val = readl(pcie->reg + PCIE_LINK_STATUS_OFFSET);
> +	dev_dbg(pcie->dev, "link status: 0x%08x\n", val);
> +
> +	val = readl(pcie->reg + STRAP_STATUS_OFFSET);
> +	dev_dbg(pcie->dev, "strap status: 0x%08x\n", val);
> +
> +	memset(&sys, 0, sizeof(sys));
> +	memset(&bus, 0, sizeof(bus));
> +
> +	bus.number = 0;
> +	bus.ops = &iproc_pcie_ops;
> +	bus.sysdata = &sys;
> +	sys.private_data = pcie;
> +
> +	ret = iproc_pci_read_conf(&bus, 0, PCI_HEADER_TYPE, 1, &val);
> +	if (ret != PCIBIOS_SUCCESSFUL || val != PCI_HEADER_TYPE_BRIDGE) {
> +		dev_err(pcie->dev, "in EP mode, val=0x08%x\n", val);
> +		return -EFAULT;
> +	}

Remove the fake pci_bus hack and just read the config space directly.

> +	if (nlw == 0) {
> +		/* try GEN 1 link speed */
> +#define PCI_LINK_STATUS_CTRL_2_OFFSET 0xDC
> +#define PCI_TARGET_LINK_SPEED_MASK    0xF
> +#define PCI_TARGET_LINK_SPEED_GEN2    0x2
> +#define PCI_TARGET_LINK_SPEED_GEN1    0x1
> +		pci_bus_read_config_dword(&bus, 0,
> +				PCI_LINK_STATUS_CTRL_2_OFFSET, &val);
> +		if ((val & PCI_TARGET_LINK_SPEED_MASK) ==
> +				PCI_TARGET_LINK_SPEED_GEN2) {
> +			val &= ~PCI_TARGET_LINK_SPEED_MASK;
> +			val |= PCI_TARGET_LINK_SPEED_GEN1;
> +			pci_bus_write_config_dword(&bus, 0,
> +					PCI_LINK_STATUS_CTRL_2_OFFSET, val);
> +			pci_bus_read_config_dword(&bus, 0,
> +					PCI_LINK_STATUS_CTRL_2_OFFSET, &val);
> +			mdelay(100);

Too much delay.

> +static struct hw_pci hw;

Put this on the stack.

> +
> +	/* Get the PCI memory ranges from DT */
> +	for_each_of_pci_range(&parser, &range) {
> +		of_pci_range_to_resource(&range, np, &res);
> +
> +		switch (res.flags & IORESOURCE_TYPE_BITS) {
> +		case IORESOURCE_IO:
> +			memcpy(&pcie->io, &res, sizeof(res));
> +			pcie->io.name = "I/O";
> +			break;
> +
> +		case IORESOURCE_MEM:
> +			memcpy(&pcie->mem, &res, sizeof(res));
> +			pcie->mem.name = "MEM";
> +			break;
> +		}
> +	}

I think you need to request all the resources here, including the physical
I/O space window.

> +static struct platform_driver iproc_pcie_driver = {
> +	.driver = {
> +		.owner = THIS_MODULE,
> +		.name = "iproc-pcie",
> +		.of_match_table =
> +		   of_match_ptr(iproc_pcie_of_match_table),
> +	},
> +};

Make this a bcma_driver.

> +static int __init iproc_pcie_init(void)
> +{
> +	return platform_driver_probe(&iproc_pcie_driver,
> +			iproc_pcie_probe);
> +}
> +subsys_initcall(iproc_pcie_init);

module_init()? Doesn't seem necessary to have this early.

	Arnd
