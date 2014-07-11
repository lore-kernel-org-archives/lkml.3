Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752389AbaGKIUa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 04:20:30 -0400
Received: from mail-ig0-f174.google.com ([209.85.213.174]:35526 "EHLO
	mail-ig0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752242AbaGKIUU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 04:20:20 -0400
Date: Fri, 11 Jul 2014 09:20:13 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Peter Griffin <peter.griffin@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        maxime.coquelin@st.com, patrice.chotard@st.com,
        gregkh@linuxfoundation.org, srinivas.kandagatla@gmail.com,
        linux-usb@vger.kernel.org, devicetree@vger.kernel.org
Subject: Re: [PATCH 1/3] usb: host: st-hcd: Add USB HCD support for STi SoCs
Message-ID: <20140711082013.GH11948@lee--X1>
References: <1405005486-26355-1-git-send-email-peter.griffin@linaro.org>
 <1405005486-26355-2-git-send-email-peter.griffin@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1405005486-26355-2-git-send-email-peter.griffin@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 Jul 2014, Peter Griffin wrote:

> This driver adds support for the USB HCD present in STi
> SoC's from STMicroelectronics. It has been tested on the
> stih416-b2020 board.
> 
> Signed-off-by: Peter Griffin <peter.griffin@linaro.org>
> ---
>  drivers/usb/host/Kconfig  |  17 ++
>  drivers/usb/host/Makefile |   1 +
>  drivers/usb/host/st-hcd.c | 471 ++++++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 489 insertions(+)
>  create mode 100644 drivers/usb/host/st-hcd.c
> 
> diff --git a/drivers/usb/host/Kconfig b/drivers/usb/host/Kconfig
> index 61b7817..dc0358e 100644
> --- a/drivers/usb/host/Kconfig
> +++ b/drivers/usb/host/Kconfig
> @@ -753,6 +753,23 @@ config USB_HCD_SSB
>  
>  	  If unsure, say N.
>  
> +config USB_HCD_ST
> +	tristate "STMicroelectronics STi family HCD support"
> +	depends on ARCH_STI
> +	select USB_OHCI_HCD_PLATFORM if USB_OHCI_HCD
> +	select USB_EHCI_HCD_PLATFORM if USB_EHCI_HCD
> +	select MFD_SYSCON

Are you still using Syscon?  If not, this and the header file can be
removed.

> +	select GENERIC_PHY
> +	help
> +	  Enable support for the EHCI and OCHI host controller on ST
> +	  consumer electronics SoCs.
> +
> +	  It converts the ST driver into two platform device drivers
> +	  for EHCI and OHCI and provides bus configuration, clock and power
> +	  management for the combined hardware block.
> +
> +	  If unsure, say N.
> +
>  config USB_HCD_TEST_MODE
>  	bool "HCD test mode support"
>  	---help---
> diff --git a/drivers/usb/host/Makefile b/drivers/usb/host/Makefile
> index af89a90..af0b81d 100644
> --- a/drivers/usb/host/Makefile
> +++ b/drivers/usb/host/Makefile
> @@ -74,3 +74,4 @@ obj-$(CONFIG_USB_HCD_SSB)	+= ssb-hcd.o
>  obj-$(CONFIG_USB_FUSBH200_HCD)	+= fusbh200-hcd.o
>  obj-$(CONFIG_USB_FOTG210_HCD)	+= fotg210-hcd.o
>  obj-$(CONFIG_USB_MAX3421_HCD)	+= max3421-hcd.o
> +obj-$(CONFIG_USB_HCD_ST)	+= st-hcd.o
> diff --git a/drivers/usb/host/st-hcd.c b/drivers/usb/host/st-hcd.c
> new file mode 100644
> index 0000000..8a9636c
> --- /dev/null
> +++ b/drivers/usb/host/st-hcd.c
> @@ -0,0 +1,471 @@
> +/*
> + * STMicroelectronics HCD (Host Controller Driver) for USB 2.0 and 1.1.
> + *
> + * Copyright (c) 2013 STMicroelectronics (R&D) Ltd.
> + * Authors: Stephen Gallimore <stephen.gallimore@st.com>
> + *          Peter Griffin <peter.griffin@linaro.org>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2, as
> + * published by the Free Software Foundation.
> + */
> +
> +#include <linux/platform_device.h>
> +#include <linux/slab.h>
> +#include <linux/dma-mapping.h>
> +#include <linux/of.h>
> +#include <linux/pm_runtime.h>
> +#include <linux/pm_clock.h>
> +#include <linux/delay.h>
> +#include <linux/usb.h>
> +#include <linux/usb/hcd.h>
> +#include <linux/clk.h>
> +#include <linux/io.h>
> +#include <linux/module.h>
> +#include <linux/reset.h>
> +#include <linux/regmap.h>

Is this used?

> +#include <linux/phy/phy.h>
> +#include <linux/mfd/syscon.h>

Is this used?

> +#include <linux/usb/ohci_pdriver.h>
> +#include <linux/usb/ehci_pdriver.h>
> +
> +#include "ohci.h"
> +
> +#define EHCI_CAPS_SIZE 0x10
> +#define AHB2STBUS_INSREG01 (EHCI_CAPS_SIZE + 0x84)
> +
> +struct st_hcd_dev {
> +	int port_nr;
> +	struct platform_device *ehci_device;
> +	struct platform_device *ohci_device;
> +	struct clk *ic_clk; /* Interconnect clock to the controller block */
> +	struct clk *ohci_clk; /* 48MHz clock for OHCI */
> +	struct reset_control *pwr;
> +	struct reset_control *rst;
> +	struct phy *phy;
> +};

As there are comments, consider using kerneldoc instead.

> +static inline void st_ehci_configure_bus(void __iomem *regs)
> +{
> +	/* Set EHCI packet buffer IN/OUT threshold to 128 bytes */
> +	u32 threshold = 128 | (128 << 16);
> +
> +	writel(threshold, regs + AHB2STBUS_INSREG01);
> +}
> +
> +static int st_hcd_enable_clocks(struct device *dev,
> +				struct st_hcd_dev *hcd_dev)
> +{
> +	int err;

Separate code (and comments) from declaration.

> +	/*
> +	 * The interconnect input clock have either fixed

s/have either/has either a/

> +	 * rate or the rate is defined on boot, so we are only concerned about
> +	 * enabling any gates for this clock.
> +	 */
> +	err = clk_prepare_enable(hcd_dev->ic_clk);
> +	if (err) {
> +		dev_err(dev, "can't enable ic clock\n");
> +		return err;
> +	}

Nit: '\n'

> +	/*
> +	 * The 48MHz OHCI clock is usually provided by a programmable
> +	 * frequency synthesizer, which is often not programmed on boot/chip
> +	 * reset, so we set its rate here to ensure it is correct.
> +	 *
> +	 * However not all SoC's have a dedicated ohci clock so it isn't fatal

s/ohci/OHCI

> +	 * for this not to  exist.

                        --^

> +	 */
> +	if (!IS_ERR(hcd_dev->ohci_clk)) {

This is ugly.  If it's not found NULL it, then check for:

	if (hcd_dev->ohci_clk) {

Or, even better, do:

	if (hcd_dev->ohci_clk)
		return 0;

Then de-indent this:

> +		err = clk_set_rate(hcd_dev->ohci_clk, 48000000);
> +		if (err) {
> +			dev_err(dev, "can't set ohci_clk rate\n");
> +			goto error;
> +		}
> +
> +		err = clk_prepare_enable(hcd_dev->ohci_clk);
> +		if (err) {
> +			dev_err(dev, "can't enable ohci_clk\n");
> +			goto error;
> +		}
> +	}
> +
> +	return 0;
> +error:
> +	clk_disable_unprepare(hcd_dev->ic_clk);
> +	return err;
> +}
> +
> +

Remove the superfluous '\n'.

> +static void st_hcd_disable_clocks(struct st_hcd_dev *hcd_dev)
> +{
> +	/* not all SoCs provide a dedicated ohci_clk */


Really small nit:
  All but two of the comments in this file start with uppercase.

> +	if (!IS_ERR(hcd_dev->ohci_clk))

You don't need to worry about this here.  The clk framework already
does this check for you, so you can omit it.

> +		clk_disable_unprepare(hcd_dev->ohci_clk);
> +
> +	clk_disable_unprepare(hcd_dev->ic_clk);
> +}
> +
> +static void st_hcd_assert_resets(struct device *dev,
> +				struct st_hcd_dev *hcd_dev)
> +{
> +	int err;
> +
> +	err = reset_control_assert(hcd_dev->pwr);
> +	if (err)
> +		dev_err(dev, "unable to put into powerdown\n");
> +
> +	err = reset_control_assert(hcd_dev->rst);
> +	if (err)
> +		dev_err(dev, "unable to put into softreset\n");
> +}
> +
> +static int st_hcd_deassert_resets(struct device *dev,
> +				struct st_hcd_dev *hcd_dev)
> +{
> +	int err;
> +
> +	err = reset_control_deassert(hcd_dev->pwr);
> +	if (err) {
> +		dev_err(dev, "unable to bring out of powerdown\n");
> +		return err;
> +	}
> +
> +	err = reset_control_deassert(hcd_dev->rst);
> +	if (err) {
> +		dev_err(dev, "unable to bring out of softreset\n");
> +		goto err_assert_power;
> +	}
> +
> +	return 0;
> +
> +err_assert_power:
> +	reset_control_assert(hcd_dev->pwr);

I would put this in reset_control_deassert()'s error path and rid the
goto.

> +	return err;
> +}
> +
> +static const struct usb_ehci_pdata ehci_pdata = {
> +};
> +
> +static const struct usb_ohci_pdata ohci_pdata = {
> +};
> +
> +static int st_hcd_remove(struct platform_device *pdev)

.remove() usually goes below (or at least near) .probe().

> +{
> +	struct st_hcd_dev *hcd_dev = platform_get_drvdata(pdev);
> +
> +	platform_device_unregister(hcd_dev->ehci_device);
> +	platform_device_unregister(hcd_dev->ohci_device);
> +
> +	phy_power_off(hcd_dev->phy);
> +
> +	phy_exit(hcd_dev->phy);
> +
> +	st_hcd_assert_resets(&pdev->dev, hcd_dev);
> +
> +	st_hcd_disable_clocks(hcd_dev);
> +
> +	return 0;
> +}
> +
> +static struct platform_device *st_hcd_device_create(const char *name, int id,
> +		struct platform_device *parent)
> +{
> +	struct platform_device *pdev;
> +	const char *platform_name;
> +	struct resource *res;
> +	struct resource hcd_res[2];
> +	int ret;
> +
> +	res = platform_get_resource_byname(parent, IORESOURCE_MEM, name);
> +	if (!res)
> +		return ERR_PTR(-ENODEV);
> +
> +	hcd_res[0] = *res;
> +
> +	res = platform_get_resource_byname(parent, IORESOURCE_IRQ, name);
> +	if (!res)
> +		return ERR_PTR(-ENODEV);
> +
> +	hcd_res[1] = *res;
> +
> +	platform_name = kasprintf(GFP_KERNEL, "%s-platform", name);
> +	if (!platform_name)
> +		return ERR_PTR(-ENOMEM);
> +
> +	pdev = platform_device_alloc(platform_name, id);
> +
> +	kfree(platform_name);
> +
> +	if (!pdev)
> +		return ERR_PTR(-ENOMEM);
> +
> +	pdev->dev.parent = &parent->dev;
> +	pdev->dev.dma_mask = &pdev->dev.coherent_dma_mask;
> +	pdev->dev.coherent_dma_mask = DMA_BIT_MASK(32);
> +
> +	ret = platform_device_add_resources(pdev, hcd_res, ARRAY_SIZE(hcd_res));
> +	if (ret)
> +		goto error;
> +
> +	if (!strcmp(name, "ohci"))
> +		ret = platform_device_add_data(pdev, &ohci_pdata,
> +					       sizeof(ohci_pdata));
> +	else
> +		ret = platform_device_add_data(pdev, &ehci_pdata,
> +					       sizeof(ehci_pdata));
> +
> +	if (ret)
> +		goto error;
> +
> +	ret = platform_device_add(pdev);
> +	if (ret)
> +		goto error;
> +
> +	return pdev;
> +
> +error:
> +	platform_device_put(pdev);
> +	return ERR_PTR(ret);
> +}
> +
> +#ifdef CONFIG_PM_SLEEP
> +static int st_hcd_resume(struct device *dev)
> +{
> +	struct st_hcd_dev *hcd_dev = dev_get_drvdata(dev);
> +	struct usb_hcd *ehci_hcd = platform_get_drvdata(hcd_dev->ehci_device);
> +	int err;
> +
> +	pinctrl_pm_select_default_state(dev);
> +
> +	err = st_hcd_enable_clocks(dev, hcd_dev);
> +	if (err)
> +		return err;
> +
> +	err = phy_init(hcd_dev->phy);
> +	if (err) {
> +		dev_err(dev, "phy initialization failed\n");
> +		goto err_disable_clocks;
> +	}
> +
> +	err = phy_power_on(hcd_dev->phy);
> +	if (err && (err != -ENOTSUPP)) {
> +		dev_err(dev, "phy power on failed\n");
> +		goto err_phy_exit;
> +	}
> +
> +	err = st_hcd_deassert_resets(dev, hcd_dev);
> +	if (err)
> +		goto err_phy_off;
> +
> +	st_ehci_configure_bus(ehci_hcd->regs);
> +
> +	return 0;
> +
> +err_phy_off:
> +	phy_power_off(hcd_dev->phy);
> +err_phy_exit:
> +	phy_exit(hcd_dev->phy);
> +err_disable_clocks:
> +	st_hcd_disable_clocks(hcd_dev);
> +
> +	return err;
> +}
> +
> +static int st_hcd_suspend(struct device *dev)
> +{
> +	struct st_hcd_dev *hcd_dev = dev_get_drvdata(dev);
> +	int err;
> +
> +	err = reset_control_assert(hcd_dev->pwr);
> +	if (err) {
> +		dev_err(dev, "unable to put into powerdown\n");
> +		return err;
> +	}
> +
> +	err = reset_control_assert(hcd_dev->rst);
> +	if (err) {
> +		dev_err(dev, "unable to put into softreset\n");
> +		return err;
> +	}
> +
> +	err = phy_power_off(hcd_dev->phy);
> +	if (err && (err != -ENOTSUPP)) {
> +		dev_err(dev, "phy power off failed\n");
> +		return err;
> +	}
> +
> +	phy_exit(hcd_dev->phy);
> +
> +	st_hcd_disable_clocks(hcd_dev);
> +
> +	pinctrl_pm_select_sleep_state(dev);
> +
> +	return 0;
> +}
> +#endif
> +
> +static SIMPLE_DEV_PM_OPS(st_hcd_pm, st_hcd_suspend, st_hcd_resume);
> +
> +static struct of_device_id st_hcd_match[] = {

const?

> +	{ .compatible = "st,usb-300x" },
> +	{ /* sentinel */ },
> +};
> +MODULE_DEVICE_TABLE(of, st_hcd_match);

Why is this all the way up here?  As you're not using
of_match_device() you can place this down by the platform driver
struct.

> +static int st_hcd_probe_clocks(struct device *dev,
> +				struct st_hcd_dev *hcd_dev)
> +{
> +	hcd_dev->ic_clk = devm_clk_get(dev, "ic");
> +	if (IS_ERR(hcd_dev->ic_clk)) {
> +		dev_err(dev, "ic clk not found\n");
> +		return PTR_ERR(hcd_dev->ic_clk);
> +	}
> +
> +	/* some SoCs don't have a dedicated ohci clk */

Really small nit:
  All but two of the comments in this file start with uppercase.

> +	hcd_dev->ohci_clk = devm_clk_get(dev, "ohci");
> +	if (IS_ERR(hcd_dev->ohci_clk))
> +		dev_info(dev, "48MHz ohci clk not found\n");

s/ohci/OHCI

Also just be aware that some maintainers like s/clk/clock in error
messages.

> +	return st_hcd_enable_clocks(dev, hcd_dev);
> +}
> +
> +

--^

> +static int st_hcd_probe_resets(struct device *dev,
> +				struct st_hcd_dev *hcd_dev)
> +{
> +	hcd_dev->pwr = devm_reset_control_get(dev, "power");
> +	if (IS_ERR(hcd_dev->pwr)) {
> +		dev_err(dev, "power reset control not found\n");
> +		return PTR_ERR(hcd_dev->pwr);
> +	}
> +
> +	hcd_dev->rst = devm_reset_control_get(dev, "softreset");
> +	if (IS_ERR(hcd_dev->rst)) {
> +		dev_err(dev, "soft reset control not found\n");
> +		return PTR_ERR(hcd_dev->rst);
> +	}
> +
> +	return st_hcd_deassert_resets(dev, hcd_dev);
> +}
> +
> +static int st_hcd_probe_ehci_setup(struct platform_device *pdev)
> +{
> +	struct resource *res;
> +	void __iomem *ehci_regs;
> +
> +	/*
> +	 * We need to do some integration specific setup in the EHCI
> +	 * controller, which the EHCI platform driver does not provide any
> +	 * hooks to allow us to do during it's initialisation.

Nit: "Its" can not be expressed as possessive.

> +	 */
> +	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "ehci");
> +	if (!res)
> +		return -ENODEV;
> +
> +	ehci_regs = devm_ioremap(&pdev->dev, res->start, resource_size(res));

Use devm_ioremap_resource()

> +	if (!ehci_regs)
> +		return -ENOMEM;
> +
> +	st_ehci_configure_bus(ehci_regs);
> +	devm_iounmap(&pdev->dev, ehci_regs);
> +
> +	return 0;
> +}
> +
> +static int st_hcd_probe(struct platform_device *pdev)
> +{
> +	struct st_hcd_dev *hcd_dev;
> +	int id;
> +	int err;
> +
> +	if (!pdev->dev.of_node)
> +		return -ENODEV;

No need for this if you depend on OF.

> +	id = of_alias_get_id(pdev->dev.of_node, "usb");
> +

Remove the '\n' between get and check.

> +	if (id < 0) {
> +		dev_err(&pdev->dev, "No ID specified via DT alias\n");
> +		return -ENODEV;
> +	}
> +
> +	hcd_dev = devm_kzalloc(&pdev->dev, sizeof(*hcd_dev), GFP_KERNEL);
> +	if (!hcd_dev)
> +		return -ENOMEM;
> +
> +	hcd_dev->port_nr = id;
> +
> +	err = st_hcd_probe_clocks(&pdev->dev, hcd_dev);
> +	if (err)
> +		return err;
> +
> +	err = st_hcd_probe_resets(&pdev->dev, hcd_dev);
> +	if (err)
> +		goto err_disable_clocks;
> +
> +	err = st_hcd_probe_ehci_setup(pdev);
> +	if (err)
> +		goto err_assert_resets;
> +
> +	hcd_dev->phy = devm_phy_get(&pdev->dev, "usb2-phy");
> +	if (IS_ERR(hcd_dev->phy)) {
> +		dev_err(&pdev->dev, "no PHY configured\n");
> +		err = PTR_ERR(hcd_dev->phy);
> +		goto err_assert_resets;
> +	}
> +
> +	err = phy_init(hcd_dev->phy);
> +	if (err) {
> +		dev_err(&pdev->dev, "phy initialization failed\n");
> +		goto err_assert_resets;
> +	}
> +
> +	err = phy_power_on(hcd_dev->phy);
> +	if (err && (err != -ENOTSUPP)) {
> +		dev_err(&pdev->dev, "phy power on failed\n");
> +		goto err_phy_exit;
> +	}
> +
> +	hcd_dev->ehci_device = st_hcd_device_create("ehci", id, pdev);
> +	if (IS_ERR(hcd_dev->ehci_device)) {
> +		err = PTR_ERR(hcd_dev->ehci_device);
> +		goto err_phy_off;
> +	}
> +
> +	hcd_dev->ohci_device = st_hcd_device_create("ohci", id, pdev);
> +	if (IS_ERR(hcd_dev->ohci_device)) {
> +		platform_device_del(hcd_dev->ehci_device);

Why do you break convention here?  Place this down in amongst the
gotos.

> +		err = PTR_ERR(hcd_dev->ohci_device);
> +		goto err_phy_off;
> +	}
> +
> +	platform_set_drvdata(pdev, hcd_dev);
> +
> +	return 0;
> +
> +err_phy_off:
> +	phy_power_off(hcd_dev->phy);
> +err_phy_exit:
> +	phy_exit(hcd_dev->phy);
> +err_assert_resets:
> +	st_hcd_assert_resets(&pdev->dev, hcd_dev);
> +err_disable_clocks:
> +	st_hcd_disable_clocks(hcd_dev);
> +
> +	return err;
> +}
> +
> +static struct platform_driver st_hcd_driver = {
> +	.probe = st_hcd_probe,
> +	.remove = st_hcd_remove,
> +	.driver = {
> +		.name = "st-hcd",
> +		.pm = &st_hcd_pm,
> +		.of_match_table = st_hcd_match,
> +	},
> +};
> +
> +module_platform_driver(st_hcd_driver);
> +
> +MODULE_DESCRIPTION("STMicroelectronics On-Chip USB Host Controller");
> +MODULE_AUTHOR("Stephen Gallimore <stephen.gallimore@st.com>");
> +MODULE_LICENSE("GPL v2");

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
