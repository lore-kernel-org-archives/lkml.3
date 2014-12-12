Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030878AbaLLRIx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 12:08:53 -0500
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:61566 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030303AbaLLRIv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 12:08:51 -0500
X-IronPort-AV: E=Sophos;i="5.07,565,1413270000"; 
   d="scan'208";a="52774072"
Message-ID: <548B2120.4080207@broadcom.com>
Date: Fri, 12 Dec 2014 09:08:48 -0800
From: Ray Jui <rjui@broadcom.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Bjorn Helgaas <bhelgaas@google.com>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        "Ian Campbell" <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>,
        Christian Daudt <bcm@fixthebug.org>, Matt Porter <mporter@linaro.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Lucas Stach <l.stach@pengutronix.de>,
        Scott Branden <sbranden@broadcom.com>, <linux-pci@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <bcm-kernel-feedback-list@broadcom.com>, <devicetree@vger.kernel.org>
Subject: Re: [PATCH v2 2/4] PCI: iproc: Add Broadcom iProc PCIe driver
References: <1418351817-14898-3-git-send-email-rjui@broadcom.com> <2190666.DfrpWiLTCc@wuerfel>
In-Reply-To: <2190666.DfrpWiLTCc@wuerfel>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 12/12/2014 4:29 AM, Arnd Bergmann wrote:
> On Thursday 11 December 2014 18:36:55 Ray Jui wrote:
>> Add initial version of the Broadcom iProc PCIe driver. This driver
>> has been tested on NSP and Cygnus and is expected to work on all iProc
>> family of SoCs that deploys the same PCIe host controller
>>
>> The driver also supports MSI
>
> Overall, I'm not convinced it's worth continuing this driver. While it
> supports more features, Hauke's version seemed much cleaner, and I'd
> rather see his driver merged and have you add the additional features.
>
> Why did you drop him from Cc again?
>
In fact, Hauke is on the "to" list of all v2 patchset that I sent out. I 
added him to the "to" list because he mentioned during v1 patchset 
review that he'll help to test this on North Star.

Doesn't Hauke's driver depends on BCMA? In that case, how does it work 
on the SoCs that do not have the IP block to support BCMA?

>> +
>> +#define MII_MGMT_CTRL_OFFSET         0x000
>> +#define MII_MGMT_CTRL_MDCDIV_SHIFT   0
>> +#define MII_MGMT_CTRL_PRE_SHIFT      7
>> +#define MII_MGMT_CTRL_BUSY_SHIFT     8
>> +#define MII_MGMT_CTRL_EXT_SHIFT      9
>> +#define MII_MGMT_CTRL_BTP_SHIFT      10
>
> As mentioned, better move all the MII handling to a separate driver.
>
Agreed.

>> +struct iproc_pcie;
>> +
>> +/**
>> + * iProc MSI
>> + * @pcie: pointer to the iProc PCIe data structure
>> + * @irq_in_use: bitmap of MSI IRQs that are in use
>> + * @domain: MSI IRQ domain
>> + * @chip: MSI controller
>> + * @eq_page: memory page to store the iProc MSI event queue
>> + * @msi_page: memory page for MSI posted writes
>> + */
>> +struct iproc_msi {
>> +	struct iproc_pcie *pcie;
>> +	DECLARE_BITMAP(irq_in_use, MAX_IRQS);
>> +	struct irq_domain *domain;
>> +	struct msi_controller chip;
>> +	unsigned long eq_page;
>> +	unsigned long msi_page;
>> +};
>
> Same for MSI. I would assume that you will eventually have
> chips with this PCI core and a GICv2m or GICv3, so it would
> be better to reference the MSI controller through an msi-parent
> reference that can be replaced with a reference to the GIC.
>
I'll need to look into this in more details.

>> +
>> +	u32 phy_addr;
>
> struct phy *phy;
>
>> +	int irqs[MAX_IRQS];
>
> Please name these irqs individually according to what they do.
> The MSI IRQ should of course be moved to the MSI driver.
>
Will investigate more on MSI.

>> +	struct iproc_msi msi;
>> +};
>> +
>> +static inline int mdio_wait_idle(struct iproc_pcie *pcie)
>> +{
>> +	int timeout = MDIO_TIMEOUT_USEC;
>> +
>> +	while (readl(pcie->mii + MII_MGMT_CTRL_OFFSET) &
>> +			(1 << MII_MGMT_CTRL_BUSY_SHIFT)) {
>> +		udelay(1);
>> +		if (timeout-- <= 0)
>> +			return -EBUSY;
>> +	}
>> +	return 0;
>> +}
>
> Better use ktime_get()/ktime_add_ns()/ktime_before() loop here
> to do an accurate timeout.
>
Sure. Will do that in the PHY driver.

>> +static void iproc_pcie_reset(struct iproc_pcie *pcie)
>> +{
>> +	u32 val;
>> +
>> +	/* send a downstream reset */
>> +	val = EP_MODE_SURVIVE_PERST | RC_PCIE_RST_OUTPUT;
>> +	writel(val, pcie->reg + CLK_CONTROL_OFFSET);
>> +	udelay(250);
>> +	val &= ~EP_MODE_SURVIVE_PERST;
>> +	writel(val, pcie->reg + CLK_CONTROL_OFFSET);
>> +	mdelay(250);
>> +}
>
> 250ms delay is not acceptable. Please find a way to call this function
> from a context in which you can sleep.
>
This is called from driver probe, where runs in the process context 
where you can sleep. Is my understanding correct? I can change mdelay to 
msleep so the CPU does not waste time spinning.

>> +static int iproc_pcie_check_link(struct iproc_pcie *pcie)
>> +{
>> +	int ret;
>> +	u8 nlw;
>> +	u16 pos, tmp16;
>> +	u32 val;
>> +	struct pci_sys_data sys;
>> +	struct pci_bus bus;
>> +
>> +	val = readl(pcie->reg + PCIE_LINK_STATUS_OFFSET);
>> +	dev_dbg(pcie->dev, "link status: 0x%08x\n", val);
>> +
>> +	val = readl(pcie->reg + STRAP_STATUS_OFFSET);
>> +	dev_dbg(pcie->dev, "strap status: 0x%08x\n", val);
>> +
>> +	memset(&sys, 0, sizeof(sys));
>> +	memset(&bus, 0, sizeof(bus));
>> +
>> +	bus.number = 0;
>> +	bus.ops = &iproc_pcie_ops;
>> +	bus.sysdata = &sys;
>> +	sys.private_data = pcie;
>> +
>> +	ret = iproc_pci_read_conf(&bus, 0, PCI_HEADER_TYPE, 1, &val);
>> +	if (ret != PCIBIOS_SUCCESSFUL || val != PCI_HEADER_TYPE_BRIDGE) {
>> +		dev_err(pcie->dev, "in EP mode, val=0x08%x\n", val);
>> +		return -EFAULT;
>> +	}
>
> Remove the fake pci_bus hack and just read the config space directly.
>
Will look into this in more details.

>> +	if (nlw == 0) {
>> +		/* try GEN 1 link speed */
>> +#define PCI_LINK_STATUS_CTRL_2_OFFSET 0xDC
>> +#define PCI_TARGET_LINK_SPEED_MASK    0xF
>> +#define PCI_TARGET_LINK_SPEED_GEN2    0x2
>> +#define PCI_TARGET_LINK_SPEED_GEN1    0x1
>> +		pci_bus_read_config_dword(&bus, 0,
>> +				PCI_LINK_STATUS_CTRL_2_OFFSET, &val);
>> +		if ((val & PCI_TARGET_LINK_SPEED_MASK) ==
>> +				PCI_TARGET_LINK_SPEED_GEN2) {
>> +			val &= ~PCI_TARGET_LINK_SPEED_MASK;
>> +			val |= PCI_TARGET_LINK_SPEED_GEN1;
>> +			pci_bus_write_config_dword(&bus, 0,
>> +					PCI_LINK_STATUS_CTRL_2_OFFSET, val);
>> +			pci_bus_read_config_dword(&bus, 0,
>> +					PCI_LINK_STATUS_CTRL_2_OFFSET, &val);
>> +			mdelay(100);
>
> Too much delay.
>
Need to confirm with the ASIC engineer. The delay may be what's needed.

>> +static struct hw_pci hw;
>
> Put this on the stack.
>
>> +
>> +	/* Get the PCI memory ranges from DT */
>> +	for_each_of_pci_range(&parser, &range) {
>> +		of_pci_range_to_resource(&range, np, &res);
>> +
>> +		switch (res.flags & IORESOURCE_TYPE_BITS) {
>> +		case IORESOURCE_IO:
>> +			memcpy(&pcie->io, &res, sizeof(res));
>> +			pcie->io.name = "I/O";
>> +			break;
>> +
>> +		case IORESOURCE_MEM:
>> +			memcpy(&pcie->mem, &res, sizeof(res));
>> +			pcie->mem.name = "MEM";
>> +			break;
>> +		}
>> +	}
>
> I think you need to request all the resources here, including the physical
> I/O space window.
>
Okay.

>> +static struct platform_driver iproc_pcie_driver = {
>> +	.driver = {
>> +		.owner = THIS_MODULE,
>> +		.name = "iproc-pcie",
>> +		.of_match_table =
>> +		   of_match_ptr(iproc_pcie_of_match_table),
>> +	},
>> +};
>
> Make this a bcma_driver.
>
Cannot be a bcma driver. Reason explained above and in PATCH v2 1/4 emails.

>> +static int __init iproc_pcie_init(void)
>> +{
>> +	return platform_driver_probe(&iproc_pcie_driver,
>> +			iproc_pcie_probe);
>> +}
>> +subsys_initcall(iproc_pcie_init);
>
> module_init()? Doesn't seem necessary to have this early.
>
> 	Arnd
>
Will look into this. Forgot why we use subsys_initcall here...
