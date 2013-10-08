Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755975Ab3JHPpP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 11:45:15 -0400
Received: from ns.mm-sol.com ([212.124.72.66]:38628 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754775Ab3JHPpB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 11:45:01 -0400
Message-ID: <1381247021.24031.84.camel@iivanov-dev.int.mm-sol.com>
Subject: Re: [PATCH v6 3/3] usb: dwc3: Add Qualcomm DWC3 glue layer driver
From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
To: Stanimir Varbanov <svarbanov@mm-sol.com>
Cc: balbi@ti.com, rob.herring@calxeda.com, pawel.moll@arm.com,
        mark.rutland@arm.com, swarren@wwwdotorg.org, ian.campbell@citrix.com,
        rob@landley.net, gregkh@linuxfoundation.org, grant.likely@linaro.org,
        idos@codeaurora.org, mgautam@codeaurora.org,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-arm-msm@vger.kernel.org
Date: Tue, 08 Oct 2013 18:43:41 +0300
In-Reply-To: <52527EA1.8060600@mm-sol.com>
References: <1381131897-13910-1-git-send-email-iivanov@mm-sol.com>
	 <1381131897-13910-4-git-send-email-iivanov@mm-sol.com>
	 <52527EA1.8060600@mm-sol.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Stan, 

On Mon, 2013-10-07 at 12:28 +0300, Stanimir Varbanov wrote: 
> Hi Ivan,
> 
> Minor comments below.
> 
> On 10/07/2013 10:44 AM, Ivan T. Ivanov wrote:
> > From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
> > 
> > DWC3 glue layer is hardware layer around Synopsys DesignWare
> > USB3 core. Its purpose is to supply Synopsys IP with required
> > clocks, voltages and interface it with the rest of the SoC.
> > 
> > Signed-off-by: Ivan T. Ivanov <iivanov@mm-sol.com>
> > ---
> >  drivers/usb/dwc3/Kconfig    |    8 +++
> >  drivers/usb/dwc3/Makefile   |    1 +
> >  drivers/usb/dwc3/dwc3-msm.c |  168 +++++++++++++++++++++++++++++++++++++++++++
> >  3 files changed, 177 insertions(+)
> >  create mode 100644 drivers/usb/dwc3/dwc3-msm.c
> > 
> > diff --git a/drivers/usb/dwc3/Kconfig b/drivers/usb/dwc3/Kconfig
> > index 70fc430..4c7b5a4 100644
> > --- a/drivers/usb/dwc3/Kconfig
> > +++ b/drivers/usb/dwc3/Kconfig
> > @@ -59,6 +59,14 @@ config USB_DWC3_EXYNOS
> >  	  Recent Exynos5 SoCs ship with one DesignWare Core USB3 IP inside,
> >  	  say 'Y' or 'M' if you have one such device.
> >  
> > +config USB_DWC3_MSM
> > +       tristate "Qualcomm MSM/APQ Platforms"
> > +       default USB_DWC3
> > +       select USB_MSM_DWC3_PHYS
> > +       help
> > +         Recent Qualcomm SoCs ship with one DesignWare Core USB3 IP inside,
> > +         say 'Y' or 'M' if you have one such device.
> > +
> >  config USB_DWC3_PCI
> >  	tristate "PCIe-based Platforms"
> >  	depends on PCI
> > diff --git a/drivers/usb/dwc3/Makefile b/drivers/usb/dwc3/Makefile
> > index dd17601..a90de66 100644
> > --- a/drivers/usb/dwc3/Makefile
> > +++ b/drivers/usb/dwc3/Makefile
> > @@ -31,4 +31,5 @@ endif
> >  
> >  obj-$(CONFIG_USB_DWC3_OMAP)		+= dwc3-omap.o
> >  obj-$(CONFIG_USB_DWC3_EXYNOS)		+= dwc3-exynos.o
> > +obj-$(CONFIG_USB_DWC3_MSM)		+= dwc3-msm.o
> >  obj-$(CONFIG_USB_DWC3_PCI)		+= dwc3-pci.o
> > diff --git a/drivers/usb/dwc3/dwc3-msm.c b/drivers/usb/dwc3/dwc3-msm.c
> > new file mode 100644
> > index 0000000..1d73f92
> > --- /dev/null
> > +++ b/drivers/usb/dwc3/dwc3-msm.c
> > @@ -0,0 +1,168 @@
> > +/* Copyright (c) 2013, The Linux Foundation. All rights reserved.
> > + *
> > + * This program is free software; you can redistribute it and/or modify
> > + * it under the terms of the GNU General Public License version 2 and
> > + * only version 2 as published by the Free Software Foundation.
> > + *
> > + * This program is distributed in the hope that it will be useful,
> > + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> > + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> > + * GNU General Public License for more details.
> > + */
> > +
> > +#include <linux/clk.h>
> > +#include <linux/err.h>
> > +#include <linux/io.h>
> > +#include <linux/module.h>
> > +#include <linux/of.h>
> > +#include <linux/of_platform.h>
> > +#include <linux/platform_device.h>
> > +#include <linux/regulator/consumer.h>
> > +#include <linux/usb/phy.h>
> > +
> > +struct dwc3_msm {
> > +	struct device		*dev;
> > +
> > +	struct clk		*core_clk;
> > +	struct clk		*iface_clk;
> > +	struct clk		*sleep_clk;
> > +	struct clk		*utmi_clk;
> > +
> > +	struct regulator	*gdsc;
> > +};
> > +
> > +static int dwc3_msm_probe(struct platform_device *pdev)
> > +{
> > +	struct device_node *node = pdev->dev.of_node;
> > +	struct dwc3_msm *mdwc;
> > +	struct resource *res;
> > +	void __iomem *tcsr;
> > +	int ret = 0;
> > +
> > +	mdwc = devm_kzalloc(&pdev->dev, sizeof(*mdwc), GFP_KERNEL);
> > +	if (!mdwc)
> > +		return -ENOMEM;
> > +
> > +	platform_set_drvdata(pdev, mdwc);
> > +
> > +	mdwc->dev = &pdev->dev;
> > +
> > +	mdwc->gdsc = devm_regulator_get(mdwc->dev, "gdsc");
> > +
> > +	mdwc->core_clk = devm_clk_get(mdwc->dev, "core");
> > +	if (IS_ERR(mdwc->core_clk)) {
> > +		dev_dbg(mdwc->dev, "failed to get core clock\n");
> > +		return PTR_ERR(mdwc->core_clk);
> > +	}
> > +
> > +	mdwc->iface_clk = devm_clk_get(mdwc->dev, "iface");
> > +	if (IS_ERR(mdwc->iface_clk)) {
> > +		dev_dbg(mdwc->dev, "failed to get iface clock\n");
> > +		return PTR_ERR(mdwc->iface_clk);
> > +	}
> > +
> > +	mdwc->sleep_clk = devm_clk_get(mdwc->dev, "sleep");
> > +	if (IS_ERR(mdwc->sleep_clk)) {
> > +		dev_dbg(mdwc->dev, "failed to get sleep clock\n");
> > +		return  PTR_ERR(mdwc->sleep_clk);
> > +	}
> > +
> > +	mdwc->utmi_clk = devm_clk_get(mdwc->dev, "utmi");
> > +	if (IS_ERR(mdwc->utmi_clk)) {
> > +		dev_dbg(mdwc->dev, "failed to get utmi clock\n");
> > +		return  PTR_ERR(mdwc->utmi_clk);
> > +	}
> 
> I'm not sure that those dev_dbg() are useful at all.

They are, if you deal with WIP clocks and regulators implementations,
which is the case for this platform.

> 
> > +
> > +	if (!IS_ERR(mdwc->gdsc)) {
> > +		ret = regulator_enable(mdwc->gdsc);
> > +		if (ret)
> > +			dev_err(mdwc->dev, "cannot enable gdsc\n");
> > +	}
> > +
> > +	/*
> > +	 * DWC3 Core requires its CORE CLK (aka master / bus clk) to
> > +	 * run at 125Mhz in SSUSB mode and >60MHZ for HSUSB mode.
> > +	 */
> > +	clk_set_rate(mdwc->core_clk, 125000000);
> > +	clk_prepare_enable(mdwc->core_clk);
> > +	clk_prepare_enable(mdwc->iface_clk);
> > +	clk_prepare_enable(mdwc->sleep_clk);
> > +	clk_prepare_enable(mdwc->utmi_clk);
> 
> All function calls above could return errors. Aren't those clocks fatal?

Yes, errors are fatal, I will add checks here.

> 
> regadrs,
> Stan
> 

Thanks, 
Ivan


