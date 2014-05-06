Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757318AbaEFN5j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 09:57:39 -0400
Received: from vps0.lunn.ch ([178.209.37.122]:38515 "EHLO vps0.lunn.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752858AbaEFN5g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 09:57:36 -0400
Date: Tue, 6 May 2014 15:54:27 +0200
From: Andrew Lunn <andrew@lunn.ch>
To: Gregory CLEMENT <gregory.clement@free-electrons.com>
Cc: Mathias Nyman <mathias.nyman@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Felipe Balbi <balbi@ti.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jason Cooper <jason@lakedaemon.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, Lior Amsalem <alior@marvell.com>,
        Tawfik Bayouk <tawfik@marvell.com>, Nadav Haklai <nadavh@marvell.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org
Subject: Re: [PATCH v3 17/20] phy: Add support for USB cluster on the Armada
 375 SoC
Message-ID: <20140506135427.GG6503@lunn.ch>
References: <1399335255-589-1-git-send-email-gregory.clement@free-electrons.com>
 <1399335255-589-18-git-send-email-gregory.clement@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1399335255-589-18-git-send-email-gregory.clement@free-electrons.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 06, 2014 at 02:14:12AM +0200, Gregory CLEMENT wrote:
> The Armada 375 SoC comes with an USB2 host and device controller and
> an USB3 controller. The USB cluster control register allows to manage
> common features of both USB controllers. It uses the generic PHY
> framework
> 
> Signed-off-by: Gregory CLEMENT <gregory.clement@free-electrons.com>
> ---
>  drivers/phy/Kconfig              |   5 ++
>  drivers/phy/Makefile             |   1 +
>  drivers/phy/phy-armada375-usb2.c | 154 +++++++++++++++++++++++++++++++++++++++
>  3 files changed, 160 insertions(+)
>  create mode 100644 drivers/phy/phy-armada375-usb2.c
> 
> diff --git a/drivers/phy/Kconfig b/drivers/phy/Kconfig
> index 3bb05f17b9b4..cdf3e2c24e3a 100644
> --- a/drivers/phy/Kconfig
> +++ b/drivers/phy/Kconfig
> @@ -15,6 +15,11 @@ config GENERIC_PHY
>  	  phy users can obtain reference to the PHY. All the users of this
>  	  framework should select this config.
>  
> +config ARMADA375_USBCLUSTER_PHY
> +	def_bool y
> +	depends on OF
> +	select GENERIC_PHY
> +
>  config PHY_EXYNOS_MIPI_VIDEO
>  	tristate "S5P/EXYNOS SoC series MIPI CSI-2/DSI PHY driver"
>  	depends on HAS_IOMEM
> diff --git a/drivers/phy/Makefile b/drivers/phy/Makefile
> index 2faf78edc864..47d5a86807b6 100644
> --- a/drivers/phy/Makefile
> +++ b/drivers/phy/Makefile
> @@ -3,6 +3,7 @@
>  #
>  
>  obj-$(CONFIG_GENERIC_PHY)		+= phy-core.o
> +obj-$(CONFIG_ARMADA375_USBCLUSTER_PHY)	+= phy-armada375-usb2.o
>  obj-$(CONFIG_BCM_KONA_USB2_PHY)		+= phy-bcm-kona-usb2.o
>  obj-$(CONFIG_PHY_EXYNOS_DP_VIDEO)	+= phy-exynos-dp-video.o
>  obj-$(CONFIG_PHY_EXYNOS_MIPI_VIDEO)	+= phy-exynos-mipi-video.o
> diff --git a/drivers/phy/phy-armada375-usb2.c b/drivers/phy/phy-armada375-usb2.c
> new file mode 100644
> index 000000000000..8bbac45e72c8
> --- /dev/null
> +++ b/drivers/phy/phy-armada375-usb2.c
> @@ -0,0 +1,154 @@
> +/*
> + * USB cluster support for Armada 375 platform.
> + *
> + * Copyright (C) 2014 Marvell
> + *
> + * Gregory CLEMENT <gregory.clement@free-electrons.com>
> + *
> + * This file is licensed under the terms of the GNU General Public
> + * License version 2 or later. This program is licensed "as is"
> + * without any warranty of any kind, whether express or implied.
> + *
> + * Armada 375 comes with an USB2 host and device controller and an
> + * USB3 controller. The USB cluster control register allows to manage
> + * common features of both USB controller.
> + */
> +
> +#include <linux/init.h>
> +#include <linux/io.h>
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/of_address.h>
> +#include <linux/phy/phy.h>
> +#include <linux/platform_device.h>
> +#include <linux/slab.h>
> +
> +#define USB2_PHY_CONFIG_ENABLE BIT(0) /* active low */
> +
> +/* the USB cluster allow to choose between two PHYs*/
> +#define NB_PHY 2
> +
> +enum {
> +	PHY_USB2 = 0,
> +	PHY_USB3 = 1,
> +};
> +
> +struct armada375_cluster_phy {
> +	struct phy *phy;
> +	void __iomem *reg;
> +	bool enable;
> +	bool use_usb3;

Hi Gregory

nit: How about using the enum you just defined?

> +};
> +
> +struct armada375_cluster_phy usb_cluster_phy[NB_PHY];
> +
> +static int armada375_usb_phy_init(struct phy *phy)
> +{
> +	struct armada375_cluster_phy *cluster_phy = phy_get_drvdata(phy);
> +	u32 reg;
> +
> +	if (cluster_phy->enable) {
> +		reg = readl(cluster_phy->reg);
> +		if (cluster_phy->use_usb3)
> +			reg |= USB2_PHY_CONFIG_ENABLE;
> +		else
> +			reg &= ~USB2_PHY_CONFIG_ENABLE;
> +		writel(reg, cluster_phy->reg);
> +
> +		return 0;
> +	} else {
> +		return -ENODEV;
> +	}
> +}
> +
> +static struct phy_ops armada375_usb_phy_ops = {
> +	.init = armada375_usb_phy_init,
> +	.owner		= THIS_MODULE,
> +};
> +
> +static struct phy *armada375_usb_phy_xlate(struct device *dev,
> +					struct of_phandle_args *args)
> +{
> +	if (WARN_ON(args->args[0] >= NB_PHY))
> +		return ERR_PTR(-ENODEV);
> +
> +	return usb_cluster_phy[args->args[0]].phy;
> +}
> +
> +static int armada375_usb_phy_probe(struct platform_device *pdev)
> +{
> +	struct device *dev = &pdev->dev;
> +	struct phy *phy;
> +	struct device_node *np = dev->of_node;
> +	struct phy_provider *phy_provider;
> +	void __iomem *usb_cluster_base;
> +	struct device_node *xhci_node;
> +	int i;
> +
> +	usb_cluster_base = of_iomap(np, 0);

devm_ API?

Check the return value for an error?

> +	BUG_ON(!usb_cluster_base);
> +
> +	for (i = 0; i < NB_PHY; i++) {
> +		phy = devm_phy_create(dev, &armada375_usb_phy_ops, NULL);
> +		if (IS_ERR(phy))
> +			dev_err(dev, "failed to create PHY n%d\n", i);
> +
> +		usb_cluster_phy[i].phy = phy;
> +		usb_cluster_phy[i].reg = usb_cluster_base;
> +		usb_cluster_phy[i].enable = false;
> +		phy_set_drvdata(phy, &usb_cluster_phy[i]);
> +	}
> +
> +	usb_cluster_phy[PHY_USB2].use_usb3 = false;
> +	usb_cluster_phy[PHY_USB3].use_usb3 = true;
> +
> +	/*
> +	 * We can't use the first usb2 unit and usb3 at the same time
> +	 * to manage a USB2 device, so let's disable usb2 if usb3 is
> +	 * slelected. In this case USB2 device will be managed by the

selected


> +	 * xhci controller.
> +	 */
> +
> +	xhci_node = of_find_compatible_node(NULL, NULL,
> +					"marvell,armada-375-xhci");
> +
> +	if (xhci_node && of_device_is_available(xhci_node)) {
> +		usb_cluster_phy[PHY_USB3].enable = true;
> +	} else {
> +		struct device_node *ehci_node;
> +		ehci_node = of_find_compatible_node(NULL, NULL,
> +					"marvell,orion-ehci");
> +		if (ehci_node && of_device_is_available(ehci_node))
> +			usb_cluster_phy[PHY_USB2].enable = true;
> +		of_node_put(ehci_node);
> +	}
> +
> +	of_node_put(xhci_node);
> +
> +	phy_provider = devm_of_phy_provider_register(&pdev->dev,
> +						     armada375_usb_phy_xlate);
> +	if (IS_ERR(phy_provider))
> +		return PTR_ERR(phy_provider);
> +
> +	return 0;
> +}
> +
> +static const struct of_device_id of_usb_cluster_table[] = {
> +	{ .compatible = "marvell,armada-375-usb-cluster", },
> +	{ /* end of list */ },
> +};
> +MODULE_DEVICE_TABLE(of, of_usb_cluster_table);
> +
> +static struct platform_driver armada375_usb_phy_driver = {
> +	.probe	= armada375_usb_phy_probe,
> +	.driver = {
> +		.of_match_table	= of_usb_cluster_table,
> +		.name  = "armada-375-usb-cluster",
> +		.owner = THIS_MODULE,
> +	}
> +};
> +module_platform_driver(armada375_usb_phy_driver);
> +
> +MODULE_DESCRIPTION("Armada 375 USB cluster driver");
> +MODULE_AUTHOR("Gregory CLEMENT <gregory.clement@free-electrons.com>");
> +MODULE_LICENSE("GPL");
> -- 
> 1.8.1.2
> 
