Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755751AbaEFNyu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 09:54:50 -0400
Received: from mail-out.m-online.net ([212.18.0.10]:58077 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752001AbaEFNys (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 09:54:48 -0400
X-Auth-Info: EsAiN4dkvNGRYXI9jv1YeC+ixmt8LfVz8A/576FGSgA=
From: Marek Vasut <marex@denx.de>
To: Kishon Vijay Abraham I <kishon@ti.com>
Subject: Re: [PATCH 05/17] pci: host: pcie-dra7xx: add support for pcie-dra7xx controller
Date: Tue, 6 May 2014 15:44:28 +0200
User-Agent: KMail/1.13.7 (Linux/3.13-trunk-amd64; KDE/4.11.5; x86_64; ; )
Cc: devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-omap@vger.kernel.org, linux-pci@vger.kernel.org, rogerq@ti.com,
        balajitk@ti.com, Bjorn Helgaas <bhelgaas@google.com>,
        Mohit Kumar <mohit.kumar@st.com>, Jingoo Han <jg1.han@samsung.com>
References: <1399383244-14556-1-git-send-email-kishon@ti.com> <1399383244-14556-6-git-send-email-kishon@ti.com>
In-Reply-To: <1399383244-14556-6-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201405061544.28738.marex@denx.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, May 06, 2014 at 03:33:51 PM, Kishon Vijay Abraham I wrote:
> Added support for pcie controller in dra7xx. This driver re-uses
> the designware core code that is already present in kernel.

[...]

> +#define to_dra7xx_pcie(x)	container_of((x), struct dra7xx_pcie, pp)
> +
> +static inline u32 dra7xx_pcie_readl(void __iomem *base, u32 offset)

Just pass struct dra7xx_pcie * instead of *base here , it will make the code 
below shorter.

> +{
> +	return readl(base + offset);
> +}
> +
> +static inline void dra7xx_pcie_writel(void __iomem *base, u32 offset, u32
> value) +{

DTTO.

> +	writel(value, base + offset);
> +}
> +
> +static int dra7xx_pcie_link_up(struct pcie_port *pp)
> +{
> +	struct dra7xx_pcie *dra7xx = to_dra7xx_pcie(pp);
> +	u32 reg = dra7xx_pcie_readl(dra7xx->base, PCIECTRL_DRA7XX_CONF_PHY_CS);
> +
> +	if (reg & LINK_UP)
> +		return true;
> +	return false;

return reg & LINK_UP;

> +}
> +
> +static int dra7xx_pcie_establish_link(struct pcie_port *pp)
> +{
> +	u32 reg;
> +	int retries = 1000;
> +	struct dra7xx_pcie *dra7xx = to_dra7xx_pcie(pp);
> +
> +	if (dw_pcie_link_up(pp)) {
> +		dev_err(pp->dev, "link is already up\n");

This will spew, since the .link_up (and thus this function) can be called 
repeatedly. The subsystem will query if the link is up via this function.

> +		return 0;
> +	}
> +
> +	reg = dra7xx_pcie_readl(dra7xx->base, PCIECTRL_DRA7XX_CONF_DEVICE_CMD);
> +	reg |= LTSSM_EN;
> +	dra7xx_pcie_writel(dra7xx->base, PCIECTRL_DRA7XX_CONF_DEVICE_CMD, reg);
> +
> +	while (--retries) {

Use retries--

> +		reg = dra7xx_pcie_readl(dra7xx->base,
> +					PCIECTRL_DRA7XX_CONF_PHY_CS);
> +		if (reg & LINK_UP)
> +			break;
> +		usleep_range(10, 20);
> +	}
> +
> +	if (retries <= 0) {

Then check if retries == 0 and retries can be unsigned int.

> +		dev_err(pp->dev, "link is not up\n");
> +		return -ETIMEDOUT;
> +	}
> +
> +	return 0;
> +}
[...]
> +static int __init dra7xx_pcie_probe(struct platform_device *pdev)
> +{
> +	u32 reg;
> +	int ret;
> +	int irq;
> +	struct phy *phy;
> +	void __iomem *base;
> +	struct resource *res;
> +	struct dra7xx_pcie *dra7xx;
> +	struct device *dev = &pdev->dev;
> +
> +	dra7xx = devm_kzalloc(&pdev->dev, sizeof(*dra7xx), GFP_KERNEL);
> +	if (!dra7xx)
> +		return -ENOMEM;
> +
> +	irq = platform_get_irq(pdev, 0);
> +	if (irq < 0) {
> +		dev_err(dev, "missing IRQ resource\n");
> +		return -EINVAL;
> +	}
> +
> +	ret = devm_request_irq(&pdev->dev, irq, dra7xx_pcie_irq_handler,
> +			       IRQF_SHARED, "dra7xx-pcie-main", dra7xx);
> +	if (ret) {
> +		dev_err(&pdev->dev, "failed to request irq\n");
> +		return ret;
> +	}
> +
> +	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "ti_conf");
> +	base = devm_ioremap_nocache(dev, res->start, resource_size(res));
> +	if (!base)
> +		return -ENOMEM;
> +
> +	phy = devm_phy_get(dev, "pcie-phy");
> +	if (IS_ERR(phy))
> +		return PTR_ERR(phy);
> +
> +	ret = phy_init(phy);
> +	if (ret < 0)
> +		return ret;
> +
> +	ret = phy_power_on(phy);
> +	if (ret < 0)
> +		goto err_power_on;
> +
> +	dra7xx->base = base;
> +	dra7xx->phy = phy;
> +	dra7xx->dev = dev;
> +
> +	pm_runtime_enable(&pdev->dev);
> +	ret = pm_runtime_get_sync(&pdev->dev);
> +	if (IS_ERR_VALUE(ret)) {
> +		dev_err(dev, "pm_runtime_get_sync failed\n");
> +		goto err_runtime_get;
> +	}
> +
> +	reg = dra7xx_pcie_readl(dra7xx->base, PCIECTRL_DRA7XX_CONF_DEVICE_CMD);
> +	reg &= ~LTSSM_EN;
> +	dra7xx_pcie_writel(dra7xx->base, PCIECTRL_DRA7XX_CONF_DEVICE_CMD, reg);

platform_set_drvdata() should be here, before you add the port.

> +	ret = add_pcie_port(dra7xx, pdev);
> +	if (ret < 0)
> +		goto err_add_port;
> +
> +	platform_set_drvdata(pdev, dra7xx);
> +	return 0;
[...]
