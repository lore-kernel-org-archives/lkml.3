Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757256Ab3LESwt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 13:52:49 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:57770 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756773Ab3LESwr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 13:52:47 -0500
Date: Thu, 5 Dec 2013 13:52:46 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Kamil Debski <k.debski@samsung.com>
cc: linux-kernel@vger.kernel.org, <linux-samsung-soc@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <kyungmin.park@samsung.com>, <kishon@ti.com>, <t.figa@samsung.com>,
        <s.nawrocki@samsung.com>, <m.szyprowski@samsung.com>,
        <gautam.vivek@samsung.com>, <mat.krawczuk@gmail.com>,
        <yulgon.kim@samsung.com>, <p.paneri@samsung.com>,
        <av.tikhomirov@samsung.com>, <jg1.han@samsung.com>,
        <galak@codeaurora.org>, <matt.porter@linaro.org>
Subject: Re: [PATCH v4 4/9] usb: ehci-s5p: Change to use phy provided by the
 generic phy framework
In-Reply-To: <1386246579-25141-5-git-send-email-k.debski@samsung.com>
Message-ID: <Pine.LNX.4.44L0.1312051342300.869-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 5 Dec 2013, Kamil Debski wrote:

> Change the phy provider used from the old usb phy specific to a new one
> using the generic phy framework.
> 
> Signed-off-by: Kamil Debski <k.debski@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>

> --- a/drivers/usb/host/ehci-exynos.c
> +++ b/drivers/usb/host/ehci-exynos.c

> @@ -42,10 +42,10 @@
>  static const char hcd_name[] = "ehci-exynos";
>  static struct hc_driver __read_mostly exynos_ehci_hc_driver;
>  
> +#define PHY_NUMBER 3
>  struct exynos_ehci_hcd {
>  	struct clk *clk;
> -	struct usb_phy *phy;
> -	struct usb_otg *otg;

Are you sure you want to remove that line?

> +	struct phy *phy[PHY_NUMBER];
>  };
>  
>  #define to_exynos_ehci(hcd) (struct exynos_ehci_hcd *)(hcd_to_ehci(hcd)->priv)

> @@ -102,13 +132,24 @@ static int exynos_ehci_probe(struct platform_device *pdev)
>  					"samsung,exynos5440-ehci"))
>  		goto skip_phy;
>  
> -	phy = devm_usb_get_phy(&pdev->dev, USB_PHY_TYPE_USB2);
> -	if (IS_ERR(phy)) {
> -		usb_put_hcd(hcd);
> -		dev_warn(&pdev->dev, "no platform data or transceiver defined\n");
> -		return -EPROBE_DEFER;
> -	} else {
> -		exynos_ehci->phy = phy;
> +	for_each_available_child_of_node(pdev->dev.of_node, child) {
> +		err = of_property_read_u32(child, "reg", &phy_number);
> +		if (err) {
> +			dev_err(&pdev->dev, "Failed to parse device tree\n");
> +			return err;
> +		}
> +		if (phy_number >= PHY_NUMBER) {
> +			dev_err(&pdev->dev, "Failed to parse device tree - number out of range\n");
> +			return -EINVAL;

Do you need to call of_node_put(child) before each of these return 
statements?

> +		}
> +		phy = devm_of_phy_get(&pdev->dev, child, 0);
> +		of_node_put(child);
> +		if (IS_ERR(phy)) {
> +			dev_err(&pdev->dev, "Failed to get phy number %d",
> +								phy_number);
> +			return PTR_ERR(phy);
> +		}
> +		exynos_ehci->phy[phy_number] = phy;
>  		exynos_ehci->otg = phy->otg;

Did you intend to remove this line?  Above, you removed the
exynos_ehci->otg field.  I can't see how this patch would ever compile
without an error.

>  	}
>  
> @@ -149,11 +190,11 @@ skip_phy:
>  		goto fail_io;
>  	}
>  
> -	if (exynos_ehci->otg)
> -		exynos_ehci->otg->set_host(exynos_ehci->otg, &hcd->self);
> -
> -	if (exynos_ehci->phy)
> -		usb_phy_init(exynos_ehci->phy);
> +	err = exynos_phys_on(exynos_ehci->phy);
> +	if (err) {
> +		dev_err(&pdev->dev, "Failed to enabled phys\n");
> +		goto fail_phys_on;

Why add a new statement label?  Just goto fail_io.

> +	}
>  
>  	ehci = hcd_to_ehci(hcd);
>  	ehci->caps = hcd->regs;
> @@ -172,8 +213,8 @@ skip_phy:
>  	return 0;
>  
>  fail_add_hcd:
> -	if (exynos_ehci->phy)
> -		usb_phy_shutdown(exynos_ehci->phy);
> +	exynos_phys_off(exynos_ehci->phy);
> +fail_phys_on:
>  fail_io:
>  	clk_disable_unprepare(exynos_ehci->clk);
>  fail_clk:

Alan Stern

