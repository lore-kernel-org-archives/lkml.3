Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756336AbaGIR4s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 13:56:48 -0400
Received: from mail-oa0-f45.google.com ([209.85.219.45]:34033 "EHLO
	mail-oa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754910AbaGIR4p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 13:56:45 -0400
MIME-Version: 1.0
In-Reply-To: <1404900096-1721-3-git-send-email-gautam.vivek@samsung.com>
References: <1404900096-1721-1-git-send-email-gautam.vivek@samsung.com>
	<1404900096-1721-3-git-send-email-gautam.vivek@samsung.com>
Date: Wed, 9 Jul 2014 10:56:45 -0700
X-Google-Sender-Auth: GBtg6-Mt99c_2YG9sg02Q4zBD24
Message-ID: <CAODwPW_2prSQj_vx96cZfG4_yjhL2HCmpBZohezYDdQUoq2mPA@mail.gmail.com>
Subject: Re: [PATCH v2 2/4] usb: host: xhci-plat: Get PHYs for xhci's hcds
From: Julius Werner <jwerner@chromium.org>
To: Vivek Gautam <gautam.vivek@samsung.com>
Cc: "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        kishon <kishon@ti.com>, Kukjin Kim <kgene.kim@samsung.com>,
        Mathias Nyman <mathias.nyman@intel.com>,
        Julius Werner <jwerner@chromium.org>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        heikki.krogerus@linux.intel.com, pratyush.anand@st.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 9, 2014 at 3:01 AM, Vivek Gautam <gautam.vivek@samsung.com> wrote:
> The host controller by itself may sometimes need to handle PHY
> and/or calibrate some of the PHY settings to get full support out
> of the PHY controller. The PHY core provides a calibration
> funtionality now to do so.
> Therefore, facilitate getting the two possible PHYs, viz.
> USB 2.0 type (UTMI+) and USB 3.0 type (PIPE3), provided
> by the parent - Synopsys's DWC3 controller
>
> Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
> ---
>  drivers/usb/host/xhci-plat.c |   36 ++++++++++++++++++++++++++++++++++++
>  1 file changed, 36 insertions(+)
>
> diff --git a/drivers/usb/host/xhci-plat.c b/drivers/usb/host/xhci-plat.c
> index 29d8adb..e50bd7d 100644
> --- a/drivers/usb/host/xhci-plat.c
> +++ b/drivers/usb/host/xhci-plat.c
> @@ -16,6 +16,7 @@
>  #include <linux/module.h>
>  #include <linux/of.h>
>  #include <linux/platform_device.h>
> +#include <linux/phy/phy.h>
>  #include <linux/slab.h>
>
>  #include "xhci.h"
> @@ -101,6 +102,7 @@ static int xhci_plat_probe(struct platform_device *pdev)
>         struct clk              *clk;
>         int                     ret;
>         int                     irq;
> +       struct device           *parent;
>
>         if (usb_disabled())
>                 return -ENODEV;
> @@ -165,6 +167,23 @@ static int xhci_plat_probe(struct platform_device *pdev)
>                         goto unmap_registers;
>         }
>
> +       parent = pdev->dev.parent;
> +       /*
> +        * Get possile USB 2.0 type PHY (UTMI+) registered by xhci's parent:
> +        * Synopsys-dwc3
> +        */
> +       if (of_device_is_compatible(parent->of_node, "synopsys,dwc3") ||
> +           of_device_is_compatible(parent->of_node, "snps,dwc3")) {
> +               hcd->gen_phy = devm_phy_get(&pdev->dev, "usb2-phy");
> +               if (IS_ERR(hcd->gen_phy)) {
> +                       ret = PTR_ERR(hcd->gen_phy);
> +                       if (ret != -ENOSYS && ret != -ENODEV) {
> +                               dev_err(&pdev->dev, "no usb2 phy configured\n");
> +                               return ret;
> +                       }
> +               }
> +       }

Why does this need to check for DWC3? I think this code should be as
generic as possible. Can't you just devm_phy_get("usb2-phy"), and keep
going with a dev_dbg() message if it fails? If the platform has a phy
it will find it, if not that's fine too.

Looks like Heikki's patch assigns the phy names in DWC3-specific code,
so I'm not sure if they are supposed to be specific to that
controller... but DWC3 is the only merged XHCI controller this applys
to right now, so why not make that a general convention? The concept
of having one "usb2-phy" and one "usb3-phy" is probably common across
most xHC implementations (unless they share a single phy in which case
they could just leave one of them unset), so it will be much easier to
handle if they all chose the same two names for those (and we can
avoid a big list of special cases here).

> +
>         ret = usb_add_hcd(hcd, irq, IRQF_SHARED);
>         if (ret)
>                 goto disable_clk;
> @@ -191,6 +210,23 @@ static int xhci_plat_probe(struct platform_device *pdev)
>         if (HCC_MAX_PSA(xhci->hcc_params) >= 4)
>                 xhci->shared_hcd->can_do_streams = 1;
>
> +       /*
> +        * Get possile USB 3.0 type PHY (PIPE3) registered by xhci's parent:
> +        * Synopsys-dwc3
> +        */
> +       if (of_device_is_compatible(parent->of_node, "synopsys,dwc3") ||
> +           of_device_is_compatible(parent->of_node, "snps,dwc3")) {
> +               xhci->shared_hcd->gen_phy = devm_phy_get(&pdev->dev,
> +                                                        "usb3-phy");
> +               if (IS_ERR(xhci->shared_hcd->gen_phy)) {
> +                       ret = PTR_ERR(xhci->shared_hcd->gen_phy);
> +                       if (ret != -ENOSYS && ret != -ENODEV) {
> +                               dev_err(&pdev->dev, "no usb3 phy configured\n");
> +                               return ret;
> +                       }
> +               }
> +       }
> +
>         ret = usb_add_hcd(xhci->shared_hcd, irq, IRQF_SHARED);
>         if (ret)
>                 goto put_usb3_hcd;
> --
> 1.7.10.4
>
