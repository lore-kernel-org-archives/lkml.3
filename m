Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751604AbaEARRH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 13:17:07 -0400
Received: from mail-qc0-f178.google.com ([209.85.216.178]:36109 "EHLO
	mail-qc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750985AbaEARRF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 13:17:05 -0400
Message-ID: <5362818D.1020602@gmail.com>
Date: Thu, 01 May 2014 19:17:01 +0200
From: Tomasz Figa <tomasz.figa@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Vivek Gautam <gautam.vivek@samsung.com>, linux-usb@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org
CC: linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        gregkh@linuxfoundation.org, balbi@ti.com, kgene.kim@samsung.com,
        k.debski@samsung.com, jg1.han@samsung.com,
        Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH v10 4/4] usb: ehci-exynos: Change to use phy provided
 by the generic phy framework
References: <1398835192-21634-1-git-send-email-gautam.vivek@samsung.com> <1398835192-21634-4-git-send-email-gautam.vivek@samsung.com>
In-Reply-To: <1398835192-21634-4-git-send-email-gautam.vivek@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Vivek,

I believe the same comments as for the patch for ohci-exynos apply for 
this patch as well.

Best regards,
Tomasz

On 30.04.2014 07:19, Vivek Gautam wrote:
> From: Kamil Debski <k.debski@samsung.com>
>
> Add the phy provider, supplied by new Exynos-usb2phy using
> Generic phy framework.
> Keeping the support for older USB phy intact right now, in order
> to prevent any functionality break in absence of relevant
> device tree side change for ehci-exynos.
> Once we move to new phy in the device nodes for ehci, we can
> remove the support for older phys.
>
> Signed-off-by: Kamil Debski <k.debski@samsung.com>
> [gautam.vivek@samsung.com: Addressed review comments from mailing list]
> [gautam.vivek@samsung.com: Kept the code for old usb-phy, and just
> added support for new exynos5-usb2phy in generic phy framework]
> [gautam.vivek@samsung.com: Edited the commit message]
> Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
> Cc: Jingoo Han <jg1.han@samsung.com>
> Cc: Alan Stern <stern@rowland.harvard.edu>
> ---
>
> Changes from v9:
>   - Calling usb_phy_shutdown() when exynos_ehci_phy_enable() is failing.
>   - Made exynos_ehci_phy_disable() return void, since its return value
>     did not serve any purpose.
>   - Calling clk_disable_unprepare() in exynos_ehci_resume() when
>     exynos_ehci_phy_enable() is failed.
>
>   .../devicetree/bindings/usb/exynos-usb.txt         |   18 +++
>   drivers/usb/host/ehci-exynos.c                     |  144 +++++++++++++++++---
>   2 files changed, 142 insertions(+), 20 deletions(-)
>
> diff --git a/Documentation/devicetree/bindings/usb/exynos-usb.txt b/Documentation/devicetree/bindings/usb/exynos-usb.txt
> index a90c973..126a7a9 100644
> --- a/Documentation/devicetree/bindings/usb/exynos-usb.txt
> +++ b/Documentation/devicetree/bindings/usb/exynos-usb.txt
> @@ -12,6 +12,15 @@ Required properties:
>    - interrupts: interrupt number to the cpu.
>    - clocks: from common clock binding: handle to usb clock.
>    - clock-names: from common clock binding: Shall be "usbhost".
> + - port: if in the SoC there are EHCI phys, they should be listed here.
> +   One phy per port. Each port should have following entries:
> +	- reg: port number on EHCI controller, e.g
> +	       On Exynos5250, port 0 is USB2.0 otg phy
> +			      port 1 is HSIC phy0
> +			      port 2 is HSIC phy1
> +	- phys: from the *Generic PHY* bindings; specifying phy used by port.
> +	- phy-names: from the *Generic PHY* bindings; specifying name of phy
> +		     used by the port.
>
>   Optional properties:
>    - samsung,vbus-gpio:  if present, specifies the GPIO that
> @@ -27,6 +36,15 @@ Example:
>
>   		clocks = <&clock 285>;
>   		clock-names = "usbhost";
> +
> +		#address-cells = <1>;
> +		#size-cells = <0>;
> +		port@0 {
> +		    reg = <0>;
> +		    phys = <&usb2phy 1>;
> +		    phy-names = "host";
> +		    status = "disabled";
> +		};
>   	};
>
>   OHCI
> diff --git a/drivers/usb/host/ehci-exynos.c b/drivers/usb/host/ehci-exynos.c
> index 4d763dc..931cfc8 100644
> --- a/drivers/usb/host/ehci-exynos.c
> +++ b/drivers/usb/host/ehci-exynos.c
> @@ -19,6 +19,7 @@
>   #include <linux/module.h>
>   #include <linux/of.h>
>   #include <linux/of_gpio.h>
> +#include <linux/phy/phy.h>
>   #include <linux/platform_device.h>
>   #include <linux/usb/phy.h>
>   #include <linux/usb/samsung_usb_phy.h>
> @@ -42,14 +43,119 @@
>   static const char hcd_name[] = "ehci-exynos";
>   static struct hc_driver __read_mostly exynos_ehci_hc_driver;
>
> +#define PHY_NUMBER 3
>   struct exynos_ehci_hcd {
>   	struct clk *clk;
>   	struct usb_phy *phy;
>   	struct usb_otg *otg;
> +	struct phy *phy_g[PHY_NUMBER];
>   };
>
>   #define to_exynos_ehci(hcd) (struct exynos_ehci_hcd *)(hcd_to_ehci(hcd)->priv)
>
> +static int exynos_ehci_get_phy(struct device *dev,
> +				struct exynos_ehci_hcd *exynos_ehci)
> +{
> +	struct device_node *child;
> +	struct phy *phy;
> +	int phy_number;
> +	int ret = 0;
> +
> +	exynos_ehci->phy = devm_usb_get_phy(dev, USB_PHY_TYPE_USB2);
> +	if (IS_ERR(exynos_ehci->phy)) {
> +		ret = PTR_ERR(exynos_ehci->phy);
> +		/* This is the case when PHY config is disabled */
> +		if (ret == -ENXIO || ret == -ENODEV) {
> +			dev_dbg(dev, "Failed to get usb2 phy\n");
> +			exynos_ehci->phy = NULL;
> +			ret = 0;
> +		} else if (ret == -EPROBE_DEFER) {
> +			goto fail_phy;
> +		} else {
> +			dev_err(dev, "no usb2 phy configured\n");
> +			goto fail_phy;
> +		}
> +	} else {
> +		exynos_ehci->otg = exynos_ehci->phy->otg;
> +	}
> +
> +	for_each_available_child_of_node(dev->of_node, child) {
> +		ret = of_property_read_u32(child, "reg", &phy_number);
> +		if (ret) {
> +			dev_err(dev, "Failed to parse device tree\n");
> +			of_node_put(child);
> +			goto fail_phy;
> +		}
> +		if (phy_number >= PHY_NUMBER) {
> +			dev_err(dev, "Invalid number of PHYs\n");
> +			of_node_put(child);
> +			ret = -EINVAL;
> +			goto fail_phy;
> +		}
> +		phy = devm_of_phy_get(dev, child, 0);
> +		of_node_put(child);
> +		if (IS_ERR(phy)) {
> +			ret = PTR_ERR(phy);
> +			/* This is the case when PHY config is disabled */
> +			if (ret == -ENOSYS || ret == -ENODEV) {
> +				dev_dbg(dev, "Failed to get usb2 phy\n");
> +				phy = NULL;
> +				ret = 0;
> +			} else if (ret == -EPROBE_DEFER) {
> +				goto fail_phy;
> +			} else {
> +				dev_err(dev, "no usb2 phy configured\n");
> +				goto fail_phy;
> +			}
> +		}
> +		exynos_ehci->phy_g[phy_number] = phy;
> +	}
> +
> +fail_phy:
> +	return ret;
> +}
> +
> +static int exynos_ehci_phy_enable(struct device *dev)
> +{
> +	struct usb_hcd *hcd = dev_get_drvdata(dev);
> +	struct exynos_ehci_hcd *exynos_ehci = to_exynos_ehci(hcd);
> +	int i;
> +	int ret = 0;
> +
> +	if (exynos_ehci->phy) {
> +		ret = usb_phy_init(exynos_ehci->phy);
> +		if (ret)
> +			return ret;
> +	}
> +
> +	for (i = 0; ret == 0 && i < PHY_NUMBER; i++)
> +		if (exynos_ehci->phy_g[i])
> +			ret = phy_power_on(exynos_ehci->phy_g[i]);
> +	if (ret) {
> +		for (i--; i >= 0; i--)
> +			if (exynos_ehci->phy_g[i])
> +				phy_power_off(exynos_ehci->phy_g[i]);
> +		if (exynos_ehci->phy)
> +			usb_phy_shutdown(exynos_ehci->phy);
> +	}
> +
> +	return ret;
> +}
> +
> +static void exynos_ehci_phy_disable(struct device *dev)
> +{
> +	struct usb_hcd *hcd = dev_get_drvdata(dev);
> +	struct exynos_ehci_hcd *exynos_ehci = to_exynos_ehci(hcd);
> +	int i;
> +
> +	if (exynos_ehci->phy)
> +		usb_phy_shutdown(exynos_ehci->phy);
> +
> +	for (i = 0; i < PHY_NUMBER; i++)
> +		if (exynos_ehci->phy_g[i])
> +			phy_power_off(exynos_ehci->phy_g[i]);
> +}
> +
>   static void exynos_setup_vbus_gpio(struct device *dev)
>   {
>   	int err;
> @@ -74,7 +180,6 @@ static int exynos_ehci_probe(struct platform_device *pdev)
>   	struct usb_hcd *hcd;
>   	struct ehci_hcd *ehci;
>   	struct resource *res;
> -	struct usb_phy *phy;
>   	int irq;
>   	int err;
>
> @@ -101,15 +206,9 @@ static int exynos_ehci_probe(struct platform_device *pdev)
>   					"samsung,exynos5440-ehci"))
>   		goto skip_phy;
>
> -	phy = devm_usb_get_phy(&pdev->dev, USB_PHY_TYPE_USB2);
> -	if (IS_ERR(phy)) {
> -		usb_put_hcd(hcd);
> -		dev_warn(&pdev->dev, "no platform data or transceiver defined\n");
> -		return -EPROBE_DEFER;
> -	} else {
> -		exynos_ehci->phy = phy;
> -		exynos_ehci->otg = phy->otg;
> -	}
> +	err = exynos_ehci_get_phy(&pdev->dev, exynos_ehci);
> +	if (err)
> +		goto fail_clk;
>
>   skip_phy:
>
> @@ -151,8 +250,11 @@ skip_phy:
>   	if (exynos_ehci->otg)
>   		exynos_ehci->otg->set_host(exynos_ehci->otg, &hcd->self);
>
> -	if (exynos_ehci->phy)
> -		usb_phy_init(exynos_ehci->phy);
> +	err = exynos_ehci_phy_enable(&pdev->dev);
> +	if (err) {
> +		dev_err(&pdev->dev, "Failed to enable USB phy\n");
> +		goto fail_io;
> +	}
>
>   	ehci = hcd_to_ehci(hcd);
>   	ehci->caps = hcd->regs;
> @@ -172,8 +274,7 @@ skip_phy:
>   	return 0;
>
>   fail_add_hcd:
> -	if (exynos_ehci->phy)
> -		usb_phy_shutdown(exynos_ehci->phy);
> +	exynos_ehci_phy_disable(&pdev->dev);
>   fail_io:
>   	clk_disable_unprepare(exynos_ehci->clk);
>   fail_clk:
> @@ -191,8 +292,7 @@ static int exynos_ehci_remove(struct platform_device *pdev)
>   	if (exynos_ehci->otg)
>   		exynos_ehci->otg->set_host(exynos_ehci->otg, &hcd->self);
>
> -	if (exynos_ehci->phy)
> -		usb_phy_shutdown(exynos_ehci->phy);
> +	exynos_ehci_phy_disable(&pdev->dev);
>
>   	clk_disable_unprepare(exynos_ehci->clk);
>
> @@ -217,8 +317,7 @@ static int exynos_ehci_suspend(struct device *dev)
>   	if (exynos_ehci->otg)
>   		exynos_ehci->otg->set_host(exynos_ehci->otg, &hcd->self);
>
> -	if (exynos_ehci->phy)
> -		usb_phy_shutdown(exynos_ehci->phy);
> +	exynos_ehci_phy_disable(dev);
>
>   	clk_disable_unprepare(exynos_ehci->clk);
>
> @@ -229,14 +328,19 @@ static int exynos_ehci_resume(struct device *dev)
>   {
>   	struct usb_hcd *hcd = dev_get_drvdata(dev);
>   	struct exynos_ehci_hcd *exynos_ehci = to_exynos_ehci(hcd);
> +	int ret;
>
>   	clk_prepare_enable(exynos_ehci->clk);
>
>   	if (exynos_ehci->otg)
>   		exynos_ehci->otg->set_host(exynos_ehci->otg, &hcd->self);
>
> -	if (exynos_ehci->phy)
> -		usb_phy_init(exynos_ehci->phy);
> +	ret = exynos_ehci_phy_enable(dev);
> +	if (ret) {
> +		dev_err(dev, "Failed to enable USB phy\n");
> +		clk_disable_unprepare(exynos_ehci->clk);
> +		return ret;
> +	}
>
>   	/* DMA burst Enable */
>   	writel(EHCI_INSNREG00_ENABLE_DMA_BURST, EHCI_INSNREG00(hcd->regs));
>
