Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751873Ab3KJQoM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Nov 2013 11:44:12 -0500
Received: from mail-ee0-f47.google.com ([74.125.83.47]:42016 "EHLO
	mail-ee0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751531Ab3KJQoJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Nov 2013 11:44:09 -0500
From: Tomasz Figa <tomasz.figa@gmail.com>
To: Kamil Debski <k.debski@samsung.com>
Cc: linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-usb@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm@vger.kernel.org, kyungmin.park@samsung.com, kishon@ti.com,
        t.figa@samsung.com, s.nawrocki@samsung.com, m.szyprowski@samsung.com,
        gautam.vivek@samsung.com, mat.krawczuk@gmail.com,
        yulgon.kim@samsung.com, p.paneri@samsung.com,
        av.tikhomirov@samsung.com, jg1.han@samsung.com, galak@codeaurora.org
Subject: Re: [PATCH v3 2/3] usb: ehci-s5p: Change to use phy provided by the generic phy framework
Date: Sun, 10 Nov 2013 17:44:06 +0100
Message-ID: <1812380.ydpHiWF2nC@flatron>
User-Agent: KMail/4.11.3 (Linux/3.12.0-gentoo; KDE/4.11.3; x86_64; ; )
In-Reply-To: <1383668001-19141-3-git-send-email-k.debski@samsung.com>
References: <1383668001-19141-1-git-send-email-k.debski@samsung.com> <1383668001-19141-3-git-send-email-k.debski@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kamil,

On Tuesday 05 of November 2013 17:13:20 Kamil Debski wrote:
> Change the phy provider used from the old usb phy specific to a new one
> using the generic phy framework.

I believe that until Exynos5250 also gets converted to the new PHY driver,
support for the old USB PHY API should remain in this driver.

As for the patch itself, please see my comments inline.

> 
> Signed-off-by: Kamil Debski <k.debski@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---
>  drivers/usb/host/ehci-exynos.c |   34 +++++++++++-----------------------
>  1 file changed, 11 insertions(+), 23 deletions(-)
> 

This patch is changing a DT binding, but there is no update to the
documentation.

> diff --git a/drivers/usb/host/ehci-exynos.c b/drivers/usb/host/ehci-exynos.c
> index 8898c01..974001b 100644
> --- a/drivers/usb/host/ehci-exynos.c
> +++ b/drivers/usb/host/ehci-exynos.c
> @@ -19,12 +19,12 @@
>  #include <linux/module.h>
>  #include <linux/of.h>
>  #include <linux/of_gpio.h>
> +#include <linux/phy/phy.h>
>  #include <linux/platform_device.h>
>  #include <linux/usb/phy.h>
>  #include <linux/usb/samsung_usb_phy.h>
>  #include <linux/usb.h>
>  #include <linux/usb/hcd.h>
> -#include <linux/usb/otg.h>
>  
>  #include "ehci.h"
>  
> @@ -44,8 +44,7 @@ static struct hc_driver __read_mostly exynos_ehci_hc_driver;
>  
>  struct exynos_ehci_hcd {
>  	struct clk *clk;
> -	struct usb_phy *phy;
> -	struct usb_otg *otg;
> +	struct phy *phy;
>  };
>  
>  #define to_exynos_ehci(hcd) (struct exynos_ehci_hcd *)(hcd_to_ehci(hcd)->priv)
> @@ -75,7 +74,8 @@ static int exynos_ehci_probe(struct platform_device *pdev)
>  	struct usb_hcd *hcd;
>  	struct ehci_hcd *ehci;
>  	struct resource *res;
> -	struct usb_phy *phy;
> +	struct phy *phy;
> +	const char *phy_name;
>  	int irq;
>  	int err;
>  
> @@ -98,12 +98,12 @@ static int exynos_ehci_probe(struct platform_device *pdev)
>  		return -ENOMEM;
>  	}
>  	exynos_ehci = to_exynos_ehci(hcd);
> -
>  	if (of_device_is_compatible(pdev->dev.of_node,
>  					"samsung,exynos5440-ehci"))
>  		goto skip_phy;
>  
> -	phy = devm_usb_get_phy(&pdev->dev, USB_PHY_TYPE_USB2);
> +	phy_name = of_get_property(pdev->dev.of_node, "phy-names", NULL);
> +	phy =  devm_phy_get(&pdev->dev, phy_name);

This is definitely not the way you should parse PHY DT bindings. PHY names
are supposed to be fixed in the binding for each compatible value, which
means that you should call here devm_phy_get() with a static name.

Moreover, this driver needs one PHY per port, not just one PHY, so the
design needs to be completely changed and this patch is not really enough
to correctly support USB 2.0 on Exynos.

Best regards,
Tomasz

