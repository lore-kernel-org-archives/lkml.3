Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755217AbaEGIWg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 04:22:36 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:49092 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751129AbaEGIWd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 04:22:33 -0400
Message-ID: <5369ED25.70101@ti.com>
Date: Wed, 7 May 2014 13:51:57 +0530
From: Kishon Vijay Abraham I <kishon@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Marek Vasut <marex@denx.de>
CC: <devicetree@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-omap@vger.kernel.org>, <linux-pci@vger.kernel.org>,
        <rogerq@ti.com>, <balajitk@ti.com>,
        Bjorn Helgaas <bhelgaas@google.com>, Mohit Kumar <mohit.kumar@st.com>,
        Jingoo Han <jg1.han@samsung.com>
Subject: Re: [PATCH 05/17] pci: host: pcie-dra7xx: add support for pcie-dra7xx
 controller
References: <1399383244-14556-1-git-send-email-kishon@ti.com> <1399383244-14556-6-git-send-email-kishon@ti.com> <201405061544.28738.marex@denx.de>
In-Reply-To: <201405061544.28738.marex@denx.de>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tuesday 06 May 2014 07:14 PM, Marek Vasut wrote:
> On Tuesday, May 06, 2014 at 03:33:51 PM, Kishon Vijay Abraham I wrote:
>> Added support for pcie controller in dra7xx. This driver re-uses
>> the designware core code that is already present in kernel.
> 
> [...]
> 
>> +#define to_dra7xx_pcie(x)	container_of((x), struct dra7xx_pcie, pp)
>> +
>> +static inline u32 dra7xx_pcie_readl(void __iomem *base, u32 offset)
> 
> Just pass struct dra7xx_pcie * instead of *base here , it will make the code 
> below shorter.
> 
>> +{
>> +	return readl(base + offset);
>> +}
>> +
>> +static inline void dra7xx_pcie_writel(void __iomem *base, u32 offset, u32
>> value) +{
> 
> DTTO.
> 
>> +	writel(value, base + offset);
>> +}
>> +
>> +static int dra7xx_pcie_link_up(struct pcie_port *pp)
>> +{
>> +	struct dra7xx_pcie *dra7xx = to_dra7xx_pcie(pp);
>> +	u32 reg = dra7xx_pcie_readl(dra7xx->base, PCIECTRL_DRA7XX_CONF_PHY_CS);
>> +
>> +	if (reg & LINK_UP)
>> +		return true;
>> +	return false;
> 
> return reg & LINK_UP;
> 
>> +}
>> +
>> +static int dra7xx_pcie_establish_link(struct pcie_port *pp)
>> +{
>> +	u32 reg;
>> +	int retries = 1000;
>> +	struct dra7xx_pcie *dra7xx = to_dra7xx_pcie(pp);
>> +
>> +	if (dw_pcie_link_up(pp)) {
>> +		dev_err(pp->dev, "link is already up\n");
> 
> This will spew, since the .link_up (and thus this function) can be called 
> repeatedly. The subsystem will query if the link is up via this function.

*dra7xx_pcie_establish_link* is not the callback for link_up function, so it's
actually called only once.
> 
>> +		return 0;
>> +	}
>> +
>> +	reg = dra7xx_pcie_readl(dra7xx->base, PCIECTRL_DRA7XX_CONF_DEVICE_CMD);
>> +	reg |= LTSSM_EN;
>> +	dra7xx_pcie_writel(dra7xx->base, PCIECTRL_DRA7XX_CONF_DEVICE_CMD, reg);
>> +
>> +	while (--retries) {
> 
> Use retries--
> 
>> +		reg = dra7xx_pcie_readl(dra7xx->base,
>> +					PCIECTRL_DRA7XX_CONF_PHY_CS);
>> +		if (reg & LINK_UP)
>> +			break;
>> +		usleep_range(10, 20);
>> +	}
>> +
>> +	if (retries <= 0) {
> 
> Then check if retries == 0 and retries can be unsigned int.
> 
>> +		dev_err(pp->dev, "link is not up\n");
>> +		return -ETIMEDOUT;
>> +	}
>> +
>> +	return 0;
>> +}
> [...]
>> +static int __init dra7xx_pcie_probe(struct platform_device *pdev)
>> +{
>> +	u32 reg;
>> +	int ret;
>> +	int irq;
>> +	struct phy *phy;
>> +	void __iomem *base;
>> +	struct resource *res;
>> +	struct dra7xx_pcie *dra7xx;
>> +	struct device *dev = &pdev->dev;
>> +
>> +	dra7xx = devm_kzalloc(&pdev->dev, sizeof(*dra7xx), GFP_KERNEL);
>> +	if (!dra7xx)
>> +		return -ENOMEM;
>> +
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
>> +
>> +	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "ti_conf");
>> +	base = devm_ioremap_nocache(dev, res->start, resource_size(res));
>> +	if (!base)
>> +		return -ENOMEM;
>> +
>> +	phy = devm_phy_get(dev, "pcie-phy");
>> +	if (IS_ERR(phy))
>> +		return PTR_ERR(phy);
>> +
>> +	ret = phy_init(phy);
>> +	if (ret < 0)
>> +		return ret;
>> +
>> +	ret = phy_power_on(phy);
>> +	if (ret < 0)
>> +		goto err_power_on;
>> +
>> +	dra7xx->base = base;
>> +	dra7xx->phy = phy;
>> +	dra7xx->dev = dev;
>> +
>> +	pm_runtime_enable(&pdev->dev);
>> +	ret = pm_runtime_get_sync(&pdev->dev);
>> +	if (IS_ERR_VALUE(ret)) {
>> +		dev_err(dev, "pm_runtime_get_sync failed\n");
>> +		goto err_runtime_get;
>> +	}
>> +
>> +	reg = dra7xx_pcie_readl(dra7xx->base, PCIECTRL_DRA7XX_CONF_DEVICE_CMD);
>> +	reg &= ~LTSSM_EN;
>> +	dra7xx_pcie_writel(dra7xx->base, PCIECTRL_DRA7XX_CONF_DEVICE_CMD, reg);
> 
> platform_set_drvdata() should be here, before you add the port.
> 
>> +	ret = add_pcie_port(dra7xx, pdev);
>> +	if (ret < 0)
>> +		goto err_add_port;
>> +
>> +	platform_set_drvdata(pdev, dra7xx);

Al-right. Will fix this and all your other comments.

Thanks
Kishon
