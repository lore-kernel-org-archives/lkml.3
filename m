Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756630AbaGIR6F (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 13:58:05 -0400
Received: from mail-ob0-f169.google.com ([209.85.214.169]:64547 "EHLO
	mail-ob0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754666AbaGIR6D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 13:58:03 -0400
MIME-Version: 1.0
In-Reply-To: <1404900096-1721-4-git-send-email-gautam.vivek@samsung.com>
References: <1404900096-1721-1-git-send-email-gautam.vivek@samsung.com>
	<1404900096-1721-4-git-send-email-gautam.vivek@samsung.com>
Date: Wed, 9 Jul 2014 10:58:01 -0700
X-Google-Sender-Auth: P5uAE3R_4_OUD7hhEKcp6aTYWp8
Message-ID: <CAODwPW92VpQpAK1X57cW7X6Y1q7=ESF7qxxtcpk4CBg1+n8BqA@mail.gmail.com>
Subject: Re: [PATCH v2 3/4] usb: host: xhci-plat: Caibrate PHY post host reset
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
> Some quirky PHYs may require to be calibrated post the host
> controller initialization.
> The USB 3.0 DRD PHY on Exynos5420/5800 systems, coming along with
> Synopsys's DWC3 controller, is one such PHY which needs to be
> calibrated post xhci's reset at initialization time and at
> resume time, to get the controller work at SuperSpeed.
>
> Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
> ---
>  drivers/usb/host/xhci-plat.c |   39 +++++++++++++++++++++++++++++++++++++--
>  1 file changed, 37 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/usb/host/xhci-plat.c b/drivers/usb/host/xhci-plat.c
> index e50bd7d..decf349 100644
> --- a/drivers/usb/host/xhci-plat.c
> +++ b/drivers/usb/host/xhci-plat.c
> @@ -35,7 +35,27 @@ static void xhci_plat_quirks(struct device *dev, struct xhci_hcd *xhci)
>  /* called during probe() after chip reset completes */
>  static int xhci_plat_setup(struct usb_hcd *hcd)
>  {
> -       return xhci_gen_setup(hcd, xhci_plat_quirks);
> +       struct device *parent;
> +       int ret;
> +
> +       ret = xhci_gen_setup(hcd, xhci_plat_quirks);
> +       if (ret) {
> +               dev_err(hcd->self.controller, "xhci setup failed\n");
> +               return ret;
> +       }
> +
> +       parent = hcd->self.controller->parent;
> +       if (of_device_is_compatible(parent->of_node, "synopsys,dwc3") ||
> +           of_device_is_compatible(parent->of_node, "snps,dwc3")) {
> +               if (!IS_ERR(hcd->gen_phy)) {
> +                       ret = phy_calibrate(hcd->gen_phy);
> +                       if (ret < 0 && ret != -ENOTSUPP)
> +                               dev_err(hcd->self.controller,
> +                                       "failed to calibrate USB PHY\n");
> +               }
> +       }

Here as well, is it really necessary to special-case it so much? I'd
say if there is a PHY and it has a calibrate function bound we call
it, and if not we just go ahead.

I also think that this would fit better in core/hcd.c since it's not
really XHCI specific... it's conceivable that an EHCI controller might
also need to tune some PHY settings after reset (in fact Tegra does
something similar, although it already has another hack for that now),
so if we introduce this general facility why not offer it to
everyone?.

> +
> +       return ret;
>  }
>
>  static int xhci_plat_start(struct usb_hcd *hcd)
> @@ -288,8 +308,23 @@ static int xhci_plat_resume(struct device *dev)
>  {
>         struct usb_hcd  *hcd = dev_get_drvdata(dev);
>         struct xhci_hcd *xhci = hcd_to_xhci(hcd);
> +       int ret;
> +
> +       ret = xhci_resume(xhci, 0);
> +       if (ret)
> +               return ret;
>
> -       return xhci_resume(xhci, 0);
> +       if (of_device_is_compatible(dev->parent->of_node, "synopsys,dwc3") ||
> +           of_device_is_compatible(dev->parent->of_node, "snps,dwc3")) {
> +               if (!IS_ERR(hcd->gen_phy)) {
> +                       ret = phy_calibrate(hcd->gen_phy);
> +                       if (ret < 0 && ret != -ENOTSUPP)
> +                               dev_err(hcd->self.controller,
> +                                       "failed to calibrate USB PHY\n");
> +               }
> +       }
> +
> +       return ret;
>  }
>
>  static const struct dev_pm_ops xhci_plat_pm_ops = {
> --
> 1.7.10.4
>
