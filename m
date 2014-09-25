Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751677AbaIYFU0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 01:20:26 -0400
Received: from mail-qg0-f53.google.com ([209.85.192.53]:54493 "EHLO
	mail-qg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750774AbaIYFUX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 01:20:23 -0400
MIME-Version: 1.0
In-Reply-To: <1411364719-28064-1-git-send-email-gautam.vivek@samsung.com>
References: <CAFp+6iGXLKhtGaHm=dFDGCpN38G=w6mX0PuatskBhvcL_HA=Bg@mail.gmail.com>
	<1411364719-28064-1-git-send-email-gautam.vivek@samsung.com>
Date: Thu, 25 Sep 2014 10:50:22 +0530
X-Google-Sender-Auth: SsT40SP-XnGsQcdJgxZrbWqa8TA
Message-ID: <CAFp+6iE0DGZ722kqFmBSDSzKLJ38=n3yfzx8t8knncjGbuAkyA@mail.gmail.com>
Subject: Re: [PATCH v5 1/2] usb: host: ehci-exynos: Remove unnecessary usb-phy support
From: Vivek Gautam <gautam.vivek@samsung.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Kukjin Kim <kgene.kim@samsung.com>, Jingoo Han <jg1.han@samsung.com>,
        Vivek Gautam <gautam.vivek@samsung.com>,
        Linux USB Mailing List <linux-usb@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,


On Mon, Sep 22, 2014 at 11:15 AM, Vivek Gautam <gautam.vivek@samsung.com> wrote:
> Now that we have completely moved from older USB-PHY drivers
> to newer GENERIC-PHY drivers for PHYs available with USB controllers
> on Exynos series of SoCs, we can remove the support for the same
> in our host drivers too.
>
> We also defer the probe for our host in case we end up getting
> EPROBE_DEFER error when getting PHYs.
>
> Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
> Acked-by: Jingoo Han <jg1.han@samsung.com>
> Acked-by: Alan Stern <stern@rowland.harvard.edu>
> ---

Did this one got missed for usb-next ?
I can only see "usb: host: ohci-exynos: Remove unnecessary usb-phy support"
in the next branch.

Ignore me if you have already taken care of this, and plan to queue it up.

>
> Changes since v4:
>  - returning 'ret' instead of PTR_ERR(phy), since ret is nothing but that only.
>
> Changes since v3:
>  - Addressed review comments by Alan:
>    -- Skipped renaming 'phy_number' variable,
>    -- resorted to just adding minimal change required for phy assignment.
>    -- updated patch description to mention EPROBE_DEFER support.
>
>  drivers/usb/host/ehci-exynos.c |   74 +++++++++++-----------------------------
>  1 file changed, 20 insertions(+), 54 deletions(-)
>
> diff --git a/drivers/usb/host/ehci-exynos.c b/drivers/usb/host/ehci-exynos.c
> index 2eed9a4..7189f2e 100644
> --- a/drivers/usb/host/ehci-exynos.c
> +++ b/drivers/usb/host/ehci-exynos.c
> @@ -21,11 +21,8 @@
>  #include <linux/of_gpio.h>
>  #include <linux/phy/phy.h>
>  #include <linux/platform_device.h>
> -#include <linux/usb/phy.h>
> -#include <linux/usb/samsung_usb_phy.h>
>  #include <linux/usb.h>
>  #include <linux/usb/hcd.h>
> -#include <linux/usb/otg.h>
>
>  #include "ehci.h"
>
> @@ -47,9 +44,7 @@ static struct hc_driver __read_mostly exynos_ehci_hc_driver;
>
>  struct exynos_ehci_hcd {
>         struct clk *clk;
> -       struct usb_phy *phy;
> -       struct usb_otg *otg;
> -       struct phy *phy_g[PHY_NUMBER];
> +       struct phy *phy[PHY_NUMBER];
>  };
>
>  #define to_exynos_ehci(hcd) (struct exynos_ehci_hcd *)(hcd_to_ehci(hcd)->priv)
> @@ -60,8 +55,9 @@ static int exynos_ehci_get_phy(struct device *dev,
>         struct device_node *child;
>         struct phy *phy;
>         int phy_number;
> -       int ret = 0;
> +       int ret;
>
> +       /* Get PHYs for the controller */
>         for_each_available_child_of_node(dev->of_node, child) {
>                 ret = of_property_read_u32(child, "reg", &phy_number);
>                 if (ret) {
> @@ -77,31 +73,21 @@ static int exynos_ehci_get_phy(struct device *dev,
>                 }
>
>                 phy = devm_of_phy_get(dev, child, NULL);
> +               exynos_ehci->phy[phy_number] = phy;
>                 of_node_put(child);
> -               if (IS_ERR(phy))
> -                       /* Lets fallback to older USB-PHYs */
> -                       goto usb_phy_old;
> -               exynos_ehci->phy_g[phy_number] = phy;
> -               /* Make the older PHYs unavailable */
> -               exynos_ehci->phy = ERR_PTR(-ENXIO);
> -       }
> -
> -       return 0;
> -
> -usb_phy_old:
> -       exynos_ehci->phy = devm_usb_get_phy(dev, USB_PHY_TYPE_USB2);
> -       if (IS_ERR(exynos_ehci->phy)) {
> -               ret = PTR_ERR(exynos_ehci->phy);
> -               if (ret != -ENXIO && ret != -ENODEV) {
> -                       dev_err(dev, "no usb2 phy configured\n");
> -                       return ret;
> +               if (IS_ERR(phy)) {
> +                       ret = PTR_ERR(phy);
> +                       if (ret == -EPROBE_DEFER) {
> +                               return ret;
> +                       } else if (ret != -ENOSYS && ret != -ENODEV) {
> +                               dev_err(dev,
> +                                       "Error retrieving usb2 phy: %d\n", ret);
> +                               return ret;
> +                       }
>                 }
> -               dev_dbg(dev, "Failed to get usb2 phy\n");
> -       } else {
> -               exynos_ehci->otg = exynos_ehci->phy->otg;
>         }
>
> -       return ret;
> +       return 0;
>  }
>
>  static int exynos_ehci_phy_enable(struct device *dev)
> @@ -111,16 +97,13 @@ static int exynos_ehci_phy_enable(struct device *dev)
>         int i;
>         int ret = 0;
>
> -       if (!IS_ERR(exynos_ehci->phy))
> -               return usb_phy_init(exynos_ehci->phy);
> -
>         for (i = 0; ret == 0 && i < PHY_NUMBER; i++)
> -               if (!IS_ERR(exynos_ehci->phy_g[i]))
> -                       ret = phy_power_on(exynos_ehci->phy_g[i]);
> +               if (!IS_ERR(exynos_ehci->phy[i]))
> +                       ret = phy_power_on(exynos_ehci->phy[i]);
>         if (ret)
>                 for (i--; i >= 0; i--)
> -                       if (!IS_ERR(exynos_ehci->phy_g[i]))
> -                               phy_power_off(exynos_ehci->phy_g[i]);
> +                       if (!IS_ERR(exynos_ehci->phy[i]))
> +                               phy_power_off(exynos_ehci->phy[i]);
>
>         return ret;
>  }
> @@ -131,14 +114,9 @@ static void exynos_ehci_phy_disable(struct device *dev)
>         struct exynos_ehci_hcd *exynos_ehci = to_exynos_ehci(hcd);
>         int i;
>
> -       if (!IS_ERR(exynos_ehci->phy)) {
> -               usb_phy_shutdown(exynos_ehci->phy);
> -               return;
> -       }
> -
>         for (i = 0; i < PHY_NUMBER; i++)
> -               if (!IS_ERR(exynos_ehci->phy_g[i]))
> -                       phy_power_off(exynos_ehci->phy_g[i]);
> +               if (!IS_ERR(exynos_ehci->phy[i]))
> +                       phy_power_off(exynos_ehci->phy[i]);
>  }
>
>  static void exynos_setup_vbus_gpio(struct device *dev)
> @@ -231,9 +209,6 @@ skip_phy:
>                 goto fail_io;
>         }
>
> -       if (exynos_ehci->otg)
> -               exynos_ehci->otg->set_host(exynos_ehci->otg, &hcd->self);
> -
>         err = exynos_ehci_phy_enable(&pdev->dev);
>         if (err) {
>                 dev_err(&pdev->dev, "Failed to enable USB phy\n");
> @@ -273,9 +248,6 @@ static int exynos_ehci_remove(struct platform_device *pdev)
>
>         usb_remove_hcd(hcd);
>
> -       if (exynos_ehci->otg)
> -               exynos_ehci->otg->set_host(exynos_ehci->otg, &hcd->self);
> -
>         exynos_ehci_phy_disable(&pdev->dev);
>
>         clk_disable_unprepare(exynos_ehci->clk);
> @@ -298,9 +270,6 @@ static int exynos_ehci_suspend(struct device *dev)
>         if (rc)
>                 return rc;
>
> -       if (exynos_ehci->otg)
> -               exynos_ehci->otg->set_host(exynos_ehci->otg, &hcd->self);
> -
>         exynos_ehci_phy_disable(dev);
>
>         clk_disable_unprepare(exynos_ehci->clk);
> @@ -316,9 +285,6 @@ static int exynos_ehci_resume(struct device *dev)
>
>         clk_prepare_enable(exynos_ehci->clk);
>
> -       if (exynos_ehci->otg)
> -               exynos_ehci->otg->set_host(exynos_ehci->otg, &hcd->self);
> -
>         ret = exynos_ehci_phy_enable(dev);
>         if (ret) {
>                 dev_err(dev, "Failed to enable USB phy\n");
> --
> 1.7.10.4
>



-- 
Best Regards
Vivek Gautam
Samsung R&D Institute, Bangalore
India
