Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751555AbaDRLNw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 07:13:52 -0400
Received: from mail-ee0-f44.google.com ([74.125.83.44]:57868 "EHLO
	mail-ee0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750857AbaDRLNr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 07:13:47 -0400
Message-ID: <535108E3.2010208@gmail.com>
Date: Fri, 18 Apr 2014 13:13:39 +0200
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
To: Gregory CLEMENT <gregory.clement@free-electrons.com>,
        Mathias Nyman <mathias.nyman@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>
CC: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, Lior Amsalem <alior@marvell.com>,
        Tawfik Bayouk <tawfik@marvell.com>, Nadav Haklai <nadavh@marvell.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org
Subject: Re: [PATCH 2/8] usb: host: xhci-plat: Add support for the Armada
 38x glue code
References: <1397816563-9000-1-git-send-email-gregory.clement@free-electrons.com> <1397816563-9000-3-git-send-email-gregory.clement@free-electrons.com>
In-Reply-To: <1397816563-9000-3-git-send-email-gregory.clement@free-electrons.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/18/2014 12:22 PM, Gregory CLEMENT wrote:
> For the armada 38x SoCs which come with an xhci controller, specific
> initialization must be done during probe, especially in relation with
> the MBus windows initialization. This patch adds this support.
> 
> Signed-off-by: Gregory CLEMENT <gregory.clement@free-electrons.com>
> ---
>  drivers/usb/host/Kconfig      |   7 +++
>  drivers/usb/host/Makefile     |   1 +
>  drivers/usb/host/xhci-mvebu.c | 105 ++++++++++++++++++++++++++++++++++++++++++
>  drivers/usb/host/xhci-mvebu.h |  21 +++++++++
>  drivers/usb/host/xhci-plat.c  |  10 ++++
>  5 files changed, 144 insertions(+)
>  create mode 100644 drivers/usb/host/xhci-mvebu.c
>  create mode 100644 drivers/usb/host/xhci-mvebu.h
> 
> diff --git a/drivers/usb/host/Kconfig b/drivers/usb/host/Kconfig
> index 3d9e54062d62..e70943fac4a1 100644
> --- a/drivers/usb/host/Kconfig
> +++ b/drivers/usb/host/Kconfig
> @@ -29,6 +29,13 @@ if USB_XHCI_HCD
>  config USB_XHCI_PLATFORM
>  	tristate
>  
> +config USB_XHCI_MVEBU
> +	tristate "xHCI support for Marvell Armada 38x"
> +	select USB_XHCI_PLATFORM
> +	---help---
> +	  Say 'Y' to enable the support for the xHCI host controller
> +	  found in Marvell Armada 38x ARM SOCs.
> +
>  endif # USB_XHCI_HCD
>  
>  config USB_EHCI_HCD
> diff --git a/drivers/usb/host/Makefile b/drivers/usb/host/Makefile
> index 7530468c9a4f..7a8db7f7dc01 100644
> --- a/drivers/usb/host/Makefile
> +++ b/drivers/usb/host/Makefile
> @@ -19,6 +19,7 @@ xhci-hcd-$(CONFIG_PCI)	+= xhci-pci.o
>  
>  ifneq ($(CONFIG_USB_XHCI_PLATFORM), )
>  	xhci-hcd-y		+= xhci-plat.o
> +	xhci-hcd-$(CONFIG_USB_XHCI_MVEBU)	+= xhci-mvebu.o
>  endif
>  
>  obj-$(CONFIG_USB_WHCI_HCD)	+= whci/
> diff --git a/drivers/usb/host/xhci-mvebu.c b/drivers/usb/host/xhci-mvebu.c
> new file mode 100644
> index 000000000000..dc9c7648ab65
> --- /dev/null
> +++ b/drivers/usb/host/xhci-mvebu.c
> @@ -0,0 +1,105 @@
> +/*
> + * Copyright (C) 2014 Marvell
> + * Author: Gregory CLEMENT <gregory.clement@free-electrons.com>
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License
> + * version 2 as published by the Free Software Foundation.
> + */
> +
> +#include <linux/clk.h>
> +#include <linux/io.h>
> +#include <linux/mbus.h>
> +#include <linux/of.h>
> +#include <linux/platform_device.h>
> +
> +#include "xhci.h"
> +
> +#define USB3_MAX_WINDOWS	4
> +#define USB3_WIN_CTRL(w)	(0x0 + ((w) * 8))
> +#define USB3_WIN_BASE(w)	(0x4 + ((w) * 8))
> +
> +static void __init mv_usb3_conf_mbus_windows(void __iomem *base,
> +			const struct mbus_dram_target_info *dram)
> +{
> +	int win;
> +
> +	/* Clear all existing windows */
> +	for (win = 0; win < USB3_MAX_WINDOWS; win++) {
> +		writel(0, base + USB3_WIN_CTRL(win));
> +		writel(0, base + USB3_WIN_BASE(win));
> +	}
> +
> +	/* Program each DRAM CS in a seperate window */
> +	for (win = 0; win < dram->num_cs; win++) {
> +		const struct mbus_dram_window *cs = dram->cs + win;
> +
> +		writel(((cs->size - 1) & 0xffff0000) | (cs->mbus_attr << 8) |
> +		       (dram->mbus_dram_target_id << 4) | 1,
> +		       base + USB3_WIN_CTRL(win));
> +
> +		writel((cs->base & 0xffff0000), base + USB3_WIN_BASE(win));
> +	}
> +}
> +
> +int xhci_mvebu_probe(struct platform_device *pdev)
> +{
> +	struct resource	*res;
> +	void __iomem	*base;
> +	const struct mbus_dram_target_info *dram;
> +	int ret;
> +	struct clk *clk;
> +
> +	res = platform_get_resource(pdev, IORESOURCE_MEM, 1);
> +	if (!res)
> +		return -ENODEV;
> +
> +	/*
> +	 * We don't use devm_ioremap() because this mapping should
> +	 * only exists for the duration of this probe function.
> +	 */
> +	base = ioremap(res->start, resource_size(res));
> +	if (!base)
> +		return -ENODEV;
> +
> +	clk = devm_clk_get(&pdev->dev, NULL);
> +	if (IS_ERR(clk)) {
> +		iounmap(base);
> +		return PTR_ERR(clk);
> +	}
> +
> +	ret = clk_prepare_enable(clk);
> +	if (ret < 0) {
> +		iounmap(base);
> +		return ret;
> +	}
> +
> +	dram = mv_mbus_dram_info();
> +	mv_usb3_conf_mbus_windows(base, dram);
> +
> +	/*
> +	 * This memory area was only needed to configure the MBus
> +	 * windows, and is therefore no longer useful.
> +	 */
> +	iounmap(base);
> +
> +	ret = common_xhci_plat_probe(pdev, clk);
> +	if (ret < 0) {
> +		clk_disable_unprepare(clk);
> +		return ret;
> +	}
> +
> +	return ret;
> +}
> +
> +int xhci_mvebu_remove(struct platform_device *pdev)
> +{
> +	struct usb_hcd *hcd = platform_get_drvdata(pdev);
> +	struct xhci_hcd	*xhci = hcd_to_xhci(hcd);
> +	struct clk *clk = xhci->priv;
> +
> +	common_xhci_plat_remove(pdev);
> +	clk_disable_unprepare(clk);
> +
> +	return 0;
> +}
> diff --git a/drivers/usb/host/xhci-mvebu.h b/drivers/usb/host/xhci-mvebu.h
> new file mode 100644
> index 000000000000..897ef298f22f
> --- /dev/null
> +++ b/drivers/usb/host/xhci-mvebu.h
> @@ -0,0 +1,21 @@
> +/*
> + * Copyright (C) 2014 Marvell
> + *
> + * Gregory Clement <gregory.clement@free-electrons.com>
> + *
> + * This file is licensed under the terms of the GNU General Public
> + * License version 2.  This program is licensed "as is" without any
> + * warranty of any kind, whether express or implied.
> + */
> +
> +#ifndef __LINUX_XHCI_MVEBU_H
> +#define __LINUX_XHCI_MVEBU_H
> +
> +#ifdef CONFIG_USB_XHCI_MVEBU
> +int xhci_mvebu_probe(struct platform_device *pdev);
> +int xhci_mvebu_remove(struct platform_device *pdev);
> +#else
> +#define xhci_mvebu_probe NULL
> +#define xhci_mvebu_remove NULL
> +#endif
> +#endif /* __LINUX_XHCI_MVEBU_H */
> diff --git a/drivers/usb/host/xhci-plat.c b/drivers/usb/host/xhci-plat.c
> index 8029cc82edc4..f1261d3848a9 100644
> --- a/drivers/usb/host/xhci-plat.c
> +++ b/drivers/usb/host/xhci-plat.c
> @@ -19,6 +19,7 @@
>  #include <linux/of_device.h>
>  
>  #include "xhci.h"
> +#include "xhci-mvebu.h"
>  
>  static void xhci_plat_quirks(struct device *dev, struct xhci_hcd *xhci)
>  {
> @@ -250,6 +251,11 @@ static const struct dev_pm_ops xhci_plat_pm_ops = {
>  #endif /* CONFIG_PM */
>  
>  #ifdef CONFIG_OF

Gregory,

either you should #ifndef CONFIG_USB_XHCI_MVEBU this and the one below -
or even better:

Can you put driver stub with its of_match_table right into xhci-mvebu?
That way platform specific probe wouldn't pollute the generic driver.

Greg will have a better opinion about it, but I remember some cleanup
in ehci, that basically removed platform specific references from the
generic code.

> +struct xhci_plat_ops xhci_plat_mvebu = {
> +	.probe =  xhci_mvebu_probe,
> +	.remove =  xhci_mvebu_remove,
> +};
> +
>  static const struct of_device_id usb_xhci_of_match[] = {
>  	{
>  		.compatible = "generic-xhci",
> @@ -259,6 +265,10 @@ static const struct of_device_id usb_xhci_of_match[] = {
>  		.compatible = "xhci-platform",
>  		.data = (void *) &xhci_plat_default,
>  	},
> +	{
> +		.compatible = "marvell,xhci-armada-380",

nit: the ususal order we use on mvebu is "marvell,<soc>-<ip>", so this
should be "marvell,armada-380-xhci".

Sebastian

> +		.data = (void *) &xhci_plat_mvebu,
> +	},
>  	{ },
>  };
>  MODULE_DEVICE_TABLE(of, usb_xhci_of_match);
> 

