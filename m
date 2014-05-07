Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755787AbaEGIps (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 04:45:48 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:36649 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752675AbaEGIpk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 04:45:40 -0400
Message-ID: <5369F287.6000103@ti.com>
Date: Wed, 7 May 2014 14:14:55 +0530
From: Kishon Vijay Abraham I <kishon@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>, <linux-arm-kernel@lists.infradead.org>
CC: <devicetree@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-pci@vger.kernel.org>, Marek Vasut <marex@denx.de>,
        <balajitk@ti.com>, Mohit Kumar <mohit.kumar@st.com>,
        Jingoo Han <jg1.han@samsung.com>, Bjorn Helgaas <bhelgaas@google.com>,
        <rogerq@ti.com>
Subject: Re: [PATCH 05/17] pci: host: pcie-dra7xx: add support for pcie-dra7xx
 controller
References: <1399383244-14556-1-git-send-email-kishon@ti.com> <1399383244-14556-6-git-send-email-kishon@ti.com> <4300084.bc6ByDTk7W@wuerfel>
In-Reply-To: <4300084.bc6ByDTk7W@wuerfel>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tuesday 06 May 2014 07:24 PM, Arnd Bergmann wrote:
> On Tuesday 06 May 2014 19:03:51 Kishon Vijay Abraham I wrote:
>> Added support for pcie controller in dra7xx. This driver re-uses
>> the designware core code that is already present in kernel.
>>
>> Cc: Bjorn Helgaas <bhelgaas@google.com>
>> Cc: Mohit Kumar <mohit.kumar@st.com>
>> Cc: Jingoo Han <jg1.han@samsung.com>
>> Cc: Marek Vasut <marex@denx.de>
>> Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
> 
> Looks pretty good overall, just a few details I noticed:
> 
>> diff --git a/Documentation/devicetree/bindings/pci/ti-pci.txt b/Documentation/devicetree/bindings/pci/ti-pci.txt
>> new file mode 100644
>> index 0000000..6cb6f09
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/pci/ti-pci.txt
>> @@ -0,0 +1,33 @@
>> +TI PCI Controllers
>> +
>> +PCIe Designware Controller
>> +This node should have the properties described in "designware-pcie.txt".
>> + - compatible: Should be "ti,dra7xx-pcie""
> 
> No "xx" in compatible strings please. Just make name this after the first
> chip to use this particular interface.

ok.
> 
>> + - reg : Address and length of the register set for the device.
>> + - reg-names : "ti_conf" for the TI specific registers and rc_dbics for the
>> +   "designware" registers.
> 
> The description uses inconsistent quotation marks. You should also have
> a fixed order in the binding, such as
> 
>  - reg : Two register ranges as listed in the reg-names property
>  - reg-names : The first entry must be "ti-conf" for the TI specific registers
> 	       The second entry must be "rc-dbics" for the designware pcie registers.

ok, looks better.
> 
>> + - phys : the phandle for the PHY device (used by generic PHY framework)
>> + - phy-names : the names of the PHY corresponding to the PHYs present in the
>> +   *phy* phandle.
> 
> It's not just a phandle, it can be any phy specifier including additional
> argument cells.
> 
> The second line should just read
> 
>  - phy-names : must be "pcie-phy"

will fix this.
> 
>> diff --git a/drivers/pci/host/Kconfig b/drivers/pci/host/Kconfig
>> index a6f67ec..7be6393 100644
>> --- a/drivers/pci/host/Kconfig
>> +++ b/drivers/pci/host/Kconfig
>> @@ -1,6 +1,16 @@
>>  menu "PCI host controller drivers"
>>  	depends on PCI
>>  
>> +config PCI_DRA7XX
>> +	bool "TI DRA7xx PCIe controller"
>> +	select PCIE_DW
>> +	depends on OF || HAS_IOMEM || TI_PIPE3
> 
> I think you mean &&, not || here.

ah.. indeed.
> 
>> +static inline u32 x(void __iomem *base, u32 offset)
>> +{
>> +	return readl(base + offset);
>> +}
>> +
>> +static inline void dra7xx_pcie_writel(void __iomem *base, u32 offset, u32 value)
>> +{
>> +	writel(value, base + offset);
>> +}
> 
> These don't actually seem to add any value, you need more characters
> to call the inline function than to open-code it.
> 
>> +static void dra7xx_pcie_enable_interrupts(struct pcie_port *pp)
>> +{
>> +	struct dra7xx_pcie *dra7xx = to_dra7xx_pcie(pp);
>> +
>> +	dra7xx_pcie_writel(dra7xx->base, PCIECTRL_DRA7XX_CONF_IRQSTATUS_MAIN,
>> +			   ~INTERRUPTS);
>> +	dra7xx_pcie_writel(dra7xx->base,
>> +			   PCIECTRL_DRA7XX_CONF_IRQENABLE_SET_MAIN, INTERRUPTS);
>> +	dra7xx_pcie_writel(dra7xx->base, PCIECTRL_DRA7XX_CONF_IRQSTATUS_MSI,
>> +			   ~LEG_EP_INTERRUPTS & ~MSI);
>> +
>> +	if (IS_ENABLED(CONFIG_PCI_MSI))
>> +		dra7xx_pcie_writel(dra7xx->base,
>> +				   PCIECTRL_DRA7XX_CONF_IRQENABLE_SET_MSI, MSI);
>> +	else
>> +		dra7xx_pcie_writel(dra7xx->base,
>> +				   PCIECTRL_DRA7XX_CONF_IRQENABLE_SET_MSI,
>> +				   LEG_EP_INTERRUPTS);
> 
> Doesn't this just enable one or the other? In general I'd assume you need
> both INTx and MSI, at least if MSI is available.

Not sure since the programming sequence in the TRM explicitly states either
legacy interrupts or MSI interrupts should be enabled but not both.
> 
> It probably doesn't hurt to always turn them all on.
> 
>> +static int add_pcie_port(struct dra7xx_pcie *dra7xx,
>> +			  struct platform_device *pdev)
>> +{
>> +	int ret;
>> +	struct pcie_port *pp;
>> +	struct resource *res;
>> +	struct device *dev = &pdev->dev;
>> +
>> +	pp = &dra7xx->pp;
>> +	pp->dev = dev;
>> +	pp->ops = &dra7xx_pcie_host_ops;
>> +
>> +	spin_lock_init(&pp->conf_lock);
>> +
>> +	pp->irq = platform_get_irq(pdev, 1);
>> +	if (pp->irq < 0) {
>> +		dev_err(dev, "missing IRQ resource\n");
>> +		return -EINVAL;
>> +	}
>>
> 
> The binding does not list a mandatory "interrupts" property, so
> this should not be treated as an error.

actually the 'interrupts' property is documented in pci/designware-pcie.txt.
> 
>> +static int __init dra7xx_pcie_probe(struct platform_device *pdev)
>> +{
>> +	irq = platform_get_irq(pdev, 0);
>> +	if (irq < 0) {
>> +		dev_err(dev, "missing IRQ resource\n");
>> +		return -EINVAL;
>> +	}
>> +
>> +	ret = devm_request_irq(&pdev->dev, irq, dra7xx_pcie_irq_handler,
>> +			       IRQF_SHARED, "dra7xx-pcie-main", dra7xx);
>> +	if (ret) {
>> +		dev_err(&pdev->dev, "failed to request irq\n");
>> +		return ret;
>> +	}
> 
> Same here.
> 
>> +
>> +	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "ti_conf");
>> +	base = devm_ioremap_nocache(dev, res->start, resource_size(res));
> 
> Just use devm_ioremap() instead of devm_ioremap_nocache(). The second
> one is just there for historic reasons, and they always do the same
> thing.

Ok.

Thanks
Kishon
