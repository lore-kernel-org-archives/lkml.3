Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752056AbaA2Umw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jan 2014 15:42:52 -0500
Received: from netrider.rowland.org ([192.131.102.5]:59994 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751883AbaA2Umu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jan 2014 15:42:50 -0500
Date: Wed, 29 Jan 2014 15:42:49 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Kamil Debski <k.debski@samsung.com>
cc: linux-kernel@vger.kernel.org, <linux-samsung-soc@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <kyungmin.park@samsung.com>, <kishon@ti.com>, <t.figa@samsung.com>,
        <s.nawrocki@samsung.com>, <m.szyprowski@samsung.com>,
        <gautam.vivek@samsung.com>, <mat.krawczuk@gmail.com>,
        <yulgon.kim@samsung.com>, <p.paneri@samsung.com>,
        <av.tikhomirov@samsung.com>, <jg1.han@samsung.com>,
        <galak@codeaurora.org>, <matt.porter@linaro.org>,
        <tjakobi@math.uni-bielefeld.de>
Subject: Re: [PATCH v6 8/8] usb: ehci-exynos: Change to use phy provided by
 the generic phy framework
In-Reply-To: <1391016574-25237-9-git-send-email-k.debski@samsung.com>
Message-ID: <Pine.LNX.4.44L0.1401291530001.23560-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 29 Jan 2014, Kamil Debski wrote:

> Change the phy provider used from the old one using the USB phy
> framework to a new one using the Generic phy framework.
> 
> Signed-off-by: Kamil Debski <k.debski@samsung.com>
> ---
>  .../devicetree/bindings/usb/exynos-usb.txt         |   13 +++
>  drivers/usb/host/ehci-exynos.c                     |   97 +++++++++++++-------
>  2 files changed, 76 insertions(+), 34 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/usb/exynos-usb.txt b/Documentation/devicetree/bindings/usb/exynos-usb.txt
> index d967ba1..25e199a 100644
> --- a/Documentation/devicetree/bindings/usb/exynos-usb.txt
> +++ b/Documentation/devicetree/bindings/usb/exynos-usb.txt
> @@ -12,6 +12,10 @@ Required properties:
>   - interrupts: interrupt number to the cpu.
>   - clocks: from common clock binding: handle to usb clock.
>   - clock-names: from common clock binding: Shall be "usbhost".
> +  - port: if in the SoC there are EHCI phys, they should be listed here.
> +One phy per port. Each port should have its reg entry with a consecutive
> +number. Also it should contain phys and phy-names entries specifying the
> +phy used by the port.

What is the reg entry number used for?  As far as I can see, it isn't 
used for anything.  In which case, why have it at all?

> @@ -42,10 +42,10 @@
>  static const char hcd_name[] = "ehci-exynos";
>  static struct hc_driver __read_mostly exynos_ehci_hc_driver;
>  
> +#define PHY_NUMBER 3
>  struct exynos_ehci_hcd {
>  	struct clk *clk;
> -	struct usb_phy *phy;
> -	struct usb_otg *otg;

You have removed all the OTG stuff from the driver.  This wasn't
mentioned in the patch description, and it has no connection with the
PHY work.

> +	struct phy *phy[PHY_NUMBER];
>  };
>  
>  #define to_exynos_ehci(hcd) (struct exynos_ehci_hcd *)(hcd_to_ehci(hcd)->priv)
> @@ -69,13 +69,43 @@ static void exynos_setup_vbus_gpio(struct platform_device *pdev)
>  		dev_err(dev, "can't request ehci vbus gpio %d", gpio);
>  }
>  
> +static int exynos_phys_on(struct phy *p[])
> +{
> +	int i;
> +	int ret = 0;
> +
> +	for (i = 0; ret == 0 && i < PHY_NUMBER; i++)
> +		if (p[i])
> +			ret = phy_power_on(p[i]);
> +	if (ret)
> +		for (i--; i > 0; i--)
> +			if (p[i])
> +				phy_power_off(p[i]);

This loop runs while i > 0.  Therefore you will never turn off the 
power to p[0].

> @@ -102,14 +132,26 @@ static int exynos_ehci_probe(struct platform_device *pdev)
>  					"samsung,exynos5440-ehci"))
>  		goto skip_phy;
>  
> -	phy = devm_usb_get_phy(&pdev->dev, USB_PHY_TYPE_USB2);
> -	if (IS_ERR(phy)) {
> -		usb_put_hcd(hcd);

You omitted this line from the new error returns below.

> -		dev_warn(&pdev->dev, "no platform data or transceiver defined\n");
> -		return -EPROBE_DEFER;
> -	} else {
> -		exynos_ehci->phy = phy;
> -		exynos_ehci->otg = phy->otg;
> +	for_each_available_child_of_node(pdev->dev.of_node, child) {
> +		err = of_property_read_u32(child, "reg", &phy_number);
> +		if (err) {
> +			dev_err(&pdev->dev, "Failed to parse device tree\n");
> +			of_node_put(child);
> +			return err;

Here, for example.  Wouldn't it be better to goto fail_clk?

Alan Stern

