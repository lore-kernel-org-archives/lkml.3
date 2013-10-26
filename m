Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751525Ab3JZJlf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Oct 2013 05:41:35 -0400
Received: from mail-bk0-f44.google.com ([209.85.214.44]:44519 "EHLO
	mail-bk0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751305Ab3JZJlc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Oct 2013 05:41:32 -0400
MIME-Version: 1.0
In-Reply-To: <1382710529-12082-5-git-send-email-k.debski@samsung.com>
References: <1382710529-12082-1-git-send-email-k.debski@samsung.com>
	<1382710529-12082-5-git-send-email-k.debski@samsung.com>
Date: Sat, 26 Oct 2013 15:11:29 +0530
Message-ID: <CAFp+6iExOPunF=ND7_17PZXA217K_4im4ZJvR=mW2Ym_gnA0GQ@mail.gmail.com>
Subject: Re: [PATCH 4/5] usb: ehci-s5p: Change to use phy provided by the
 generic phy framework
From: Vivek Gautam <gautamvivek1987@gmail.com>
To: Kamil Debski <k.debski@samsung.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        Linux USB Mailing List <linux-usb@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        linux-arm@vger.kernel.org, Kyungmin Park <kyungmin.park@samsung.com>,
        kishon <kishon@ti.com>, Tomasz Figa <t.figa@samsung.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Vivek Gautam <gautam.vivek@samsung.com>, mat.krawczuk@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kamil,


On Fri, Oct 25, 2013 at 7:45 PM, Kamil Debski <k.debski@samsung.com> wrote:
> Change the phy provider used from the old usb phy specific to a new one
> using the generic phy framework.
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
>         struct clk *clk;
> -       struct usb_phy *phy;
> +       struct phy *phy;
>         struct usb_otg *otg;
>         struct s5p_ehci_platdata *pdata;
>  };
> @@ -77,10 +78,11 @@ static int s5p_ehci_probe(struct platform_device *pdev)
>  {
>         struct s5p_ehci_platdata *pdata = pdev->dev.platform_data;
>         struct s5p_ehci_hcd *s5p_ehci;
> +       struct phy *phy;

just a nit here:
Lets keep the pointer to 'phy' and 'phy_name' together ?
and move this above phy_name ?

>         struct usb_hcd *hcd;
>         struct ehci_hcd *ehci;
>         struct resource *res;
> -       struct usb_phy *phy;
> +       const char *phy_name;
>         int irq;
>         int err;
>
> @@ -103,14 +105,14 @@ static int s5p_ehci_probe(struct platform_device *pdev)
>                 return -ENOMEM;
>         }
>         s5p_ehci = to_s5p_ehci(hcd);
> -
> +       phy_name = of_get_property(pdev->dev.of_node, "phy-names", NULL);
> +       phy =  devm_phy_get(&pdev->dev, phy_name);

Below check for exynos5440 was supposed to skip any request phy.
So shouldn't we place above two assignments to the original place
where devm_usb_get_phy()
was called ?
May be i am not getting you intention of changing the place.

>         if (of_device_is_compatible(pdev->dev.of_node,
>                                         "samsung,exynos5440-ehci")) {
>                 s5p_ehci->pdata = &empty_platdata;
>                 goto skip_phy;
>         }
>
> -       phy = devm_usb_get_phy(&pdev->dev, USB_PHY_TYPE_USB2);
>         if (IS_ERR(phy)) {
>                 /* Fallback to pdata */
>                 if (!pdata) {
> @@ -122,7 +124,6 @@ static int s5p_ehci_probe(struct platform_device *pdev)
>                 }
>         } else {
>                 s5p_ehci->phy = phy;
> -               s5p_ehci->otg = phy->otg;
>         }
>
>  skip_phy:
> @@ -166,7 +167,7 @@ skip_phy:
>                 s5p_ehci->otg->set_host(s5p_ehci->otg, &hcd->self);

Lets remove this line and similar calls to 'set_host()' in the driver,
since we don't have
s5p_ehci->otg anymore after the same is removed above.
Anyways this was helping the old phy-samsung-usb2 driver, and not needed now.

>
>         if (s5p_ehci->phy)
> -               usb_phy_init(s5p_ehci->phy);
> +               phy_power_on(s5p_ehci->phy);
>         else if (s5p_ehci->pdata->phy_init)
>                 s5p_ehci->pdata->phy_init(pdev, USB_PHY_TYPE_HOST);
>
> @@ -188,7 +189,7 @@ skip_phy:
>
>  fail_add_hcd:
>         if (s5p_ehci->phy)
> -               usb_phy_shutdown(s5p_ehci->phy);
> +               phy_power_off(s5p_ehci->phy);
>         else if (s5p_ehci->pdata->phy_exit)
>                 s5p_ehci->pdata->phy_exit(pdev, USB_PHY_TYPE_HOST);
>  fail_io:
> @@ -209,7 +210,7 @@ static int s5p_ehci_remove(struct platform_device *pdev)
>                 s5p_ehci->otg->set_host(s5p_ehci->otg, &hcd->self);

ditto

>
>         if (s5p_ehci->phy)
> -               usb_phy_shutdown(s5p_ehci->phy);
> +               phy_power_off(s5p_ehci->phy);
>         else if (s5p_ehci->pdata->phy_exit)
>                 s5p_ehci->pdata->phy_exit(pdev, USB_PHY_TYPE_HOST);
>
> @@ -244,7 +245,7 @@ static int s5p_ehci_suspend(struct device *dev)
>                 s5p_ehci->otg->set_host(s5p_ehci->otg, &hcd->self);
ditto

>
>         if (s5p_ehci->phy)
> -               usb_phy_shutdown(s5p_ehci->phy);
> +               phy_power_off(s5p_ehci->phy);
>         else if (s5p_ehci->pdata->phy_exit)
>                 s5p_ehci->pdata->phy_exit(pdev, USB_PHY_TYPE_HOST);
>
> @@ -265,7 +266,7 @@ static int s5p_ehci_resume(struct device *dev)
>                 s5p_ehci->otg->set_host(s5p_ehci->otg, &hcd->self);
ditto

>
>         if (s5p_ehci->phy)
> -               usb_phy_init(s5p_ehci->phy);
> +               phy_power_on(s5p_ehci->phy);
>         else if (s5p_ehci->pdata->phy_init)
>                 s5p_ehci->pdata->phy_init(pdev, USB_PHY_TYPE_HOST);
>
[..] Rest looks good. :-)



-- 
Best Regards
Vivek
