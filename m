Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753684Ab3JYPwt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Oct 2013 11:52:49 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:52994 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752086Ab3JYPwr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Oct 2013 11:52:47 -0400
Message-ID: <526A93C5.7050503@ti.com>
Date: Fri, 25 Oct 2013 21:22:37 +0530
From: Kishon Vijay Abraham I <kishon@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Kamil Debski <k.debski@samsung.com>
CC: <linux-kernel@vger.kernel.org>, <linux-samsung-soc@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-arm@vger.kernel.org>, <kyungmin.park@samsung.com>,
        <t.figa@samsung.com>, <s.nawrocki@samsung.com>,
        <m.szyprowski@samsung.com>, <gautam.vivek@samsung.com>,
        <mat.krawczuk@gmail.com>
Subject: Re: [PATCH 4/5] usb: ehci-s5p: Change to use phy provided by the
 generic phy framework
References: <1382710529-12082-1-git-send-email-k.debski@samsung.com> <1382710529-12082-5-git-send-email-k.debski@samsung.com>
In-Reply-To: <1382710529-12082-5-git-send-email-k.debski@samsung.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Friday 25 October 2013 07:45 PM, Kamil Debski wrote:
> Change the phy provider used from the old usb phy specific to a new one
> using the generic phy framework.

looks good :-)

Thanks
Kishon

> 
> Signed-off-by: Kamil Debski <k.debski@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---
>  drivers/usb/host/ehci-s5p.c |   21 +++++++++++----------
>  1 file changed, 11 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/usb/host/ehci-s5p.c b/drivers/usb/host/ehci-s5p.c
> index 7cc26e6..76606ff 100644
> --- a/drivers/usb/host/ehci-s5p.c
> +++ b/drivers/usb/host/ehci-s5p.c
> @@ -19,6 +19,7 @@
>  #include <linux/module.h>
>  #include <linux/of.h>
>  #include <linux/of_gpio.h>
> +#include <linux/phy/phy.h>
>  #include <linux/platform_device.h>
>  #include <linux/platform_data/usb-ehci-s5p.h>
>  #include <linux/usb/phy.h>
> @@ -45,7 +46,7 @@ static struct hc_driver __read_mostly s5p_ehci_hc_driver;
>  
>  struct s5p_ehci_hcd {
>  	struct clk *clk;
> -	struct usb_phy *phy;
> +	struct phy *phy;
>  	struct usb_otg *otg;
>  	struct s5p_ehci_platdata *pdata;
>  };
> @@ -77,10 +78,11 @@ static int s5p_ehci_probe(struct platform_device *pdev)
>  {
>  	struct s5p_ehci_platdata *pdata = pdev->dev.platform_data;
>  	struct s5p_ehci_hcd *s5p_ehci;
> +	struct phy *phy;
>  	struct usb_hcd *hcd;
>  	struct ehci_hcd *ehci;
>  	struct resource *res;
> -	struct usb_phy *phy;
> +	const char *phy_name;
>  	int irq;
>  	int err;
>  
> @@ -103,14 +105,14 @@ static int s5p_ehci_probe(struct platform_device *pdev)
>  		return -ENOMEM;
>  	}
>  	s5p_ehci = to_s5p_ehci(hcd);
> -
> +	phy_name = of_get_property(pdev->dev.of_node, "phy-names", NULL);
> +	phy =  devm_phy_get(&pdev->dev, phy_name);
>  	if (of_device_is_compatible(pdev->dev.of_node,
>  					"samsung,exynos5440-ehci")) {
>  		s5p_ehci->pdata = &empty_platdata;
>  		goto skip_phy;
>  	}
>  
> -	phy = devm_usb_get_phy(&pdev->dev, USB_PHY_TYPE_USB2);
>  	if (IS_ERR(phy)) {
>  		/* Fallback to pdata */
>  		if (!pdata) {
> @@ -122,7 +124,6 @@ static int s5p_ehci_probe(struct platform_device *pdev)
>  		}
>  	} else {
>  		s5p_ehci->phy = phy;
> -		s5p_ehci->otg = phy->otg;
>  	}
>  
>  skip_phy:
> @@ -166,7 +167,7 @@ skip_phy:
>  		s5p_ehci->otg->set_host(s5p_ehci->otg, &hcd->self);
>  
>  	if (s5p_ehci->phy)
> -		usb_phy_init(s5p_ehci->phy);
> +		phy_power_on(s5p_ehci->phy);
>  	else if (s5p_ehci->pdata->phy_init)
>  		s5p_ehci->pdata->phy_init(pdev, USB_PHY_TYPE_HOST);
>  
> @@ -188,7 +189,7 @@ skip_phy:
>  
>  fail_add_hcd:
>  	if (s5p_ehci->phy)
> -		usb_phy_shutdown(s5p_ehci->phy);
> +		phy_power_off(s5p_ehci->phy);
>  	else if (s5p_ehci->pdata->phy_exit)
>  		s5p_ehci->pdata->phy_exit(pdev, USB_PHY_TYPE_HOST);
>  fail_io:
> @@ -209,7 +210,7 @@ static int s5p_ehci_remove(struct platform_device *pdev)
>  		s5p_ehci->otg->set_host(s5p_ehci->otg, &hcd->self);
>  
>  	if (s5p_ehci->phy)
> -		usb_phy_shutdown(s5p_ehci->phy);
> +		phy_power_off(s5p_ehci->phy);
>  	else if (s5p_ehci->pdata->phy_exit)
>  		s5p_ehci->pdata->phy_exit(pdev, USB_PHY_TYPE_HOST);
>  
> @@ -244,7 +245,7 @@ static int s5p_ehci_suspend(struct device *dev)
>  		s5p_ehci->otg->set_host(s5p_ehci->otg, &hcd->self);
>  
>  	if (s5p_ehci->phy)
> -		usb_phy_shutdown(s5p_ehci->phy);
> +		phy_power_off(s5p_ehci->phy);
>  	else if (s5p_ehci->pdata->phy_exit)
>  		s5p_ehci->pdata->phy_exit(pdev, USB_PHY_TYPE_HOST);
>  
> @@ -265,7 +266,7 @@ static int s5p_ehci_resume(struct device *dev)
>  		s5p_ehci->otg->set_host(s5p_ehci->otg, &hcd->self);
>  
>  	if (s5p_ehci->phy)
> -		usb_phy_init(s5p_ehci->phy);
> +		phy_power_on(s5p_ehci->phy);
>  	else if (s5p_ehci->pdata->phy_init)
>  		s5p_ehci->pdata->phy_init(pdev, USB_PHY_TYPE_HOST);
>  
> 

