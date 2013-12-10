Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755648Ab3LJSZi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 13:25:38 -0500
Received: from mail-ob0-f174.google.com ([209.85.214.174]:50858 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755153Ab3LJSZc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 13:25:32 -0500
MIME-Version: 1.0
In-Reply-To: <1386672926-26885-3-git-send-email-gautam.vivek@samsung.com>
References: <1386672926-26885-1-git-send-email-gautam.vivek@samsung.com>
	<1386672926-26885-3-git-send-email-gautam.vivek@samsung.com>
Date: Tue, 10 Dec 2013 10:25:31 -0800
X-Google-Sender-Auth: 2viSxpijLNCSFcw0TPMFmY3lsHw
Message-ID: <CAODwPW8XMESHi=_ovcTRcyxv6zS6fMuTmSW2qrE-fbQvtHks=g@mail.gmail.com>
Subject: Re: [PATCH RFC 2/4] xhci: Add quirk for DWC3-Exynos controller
From: Julius Werner <jwerner@chromium.org>
To: Vivek Gautam <gautam.vivek@samsung.com>
Cc: "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        linux-omap@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Felipe Balbi <balbi@ti.com>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Kukjin Kim <kgene.kim@samsung.com>, kishon <kishon@ti.com>,
        Jingoo Han <jg1.han@samsung.com>, Julius Werner <jwerner@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 10, 2013 at 2:55 AM, Vivek Gautam <gautam.vivek@samsung.com> wrote:
> The DWC3-exynos eXtensible host controller on Exynos5420 SoC
> is quirky in a way that the PHY needs to be tuned to get it
> working at SuperSpeed.
> By default this PHY works as High-speed phy and therefore
> detects even Super-speed devices as high-speed ones.
> So, the PHY needs to be tuned after controller has been reset.
>
> Adding a xHCI quirk for this purpose.
>
> Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
> ---
>  drivers/usb/host/xhci-plat.c |   19 +++++++++++++++++++
>  drivers/usb/host/xhci.h      |    1 +
>  2 files changed, 20 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/usb/host/xhci-plat.c b/drivers/usb/host/xhci-plat.c
> index d9c169f..395c9e9 100644
> --- a/drivers/usb/host/xhci-plat.c
> +++ b/drivers/usb/host/xhci-plat.c
> @@ -21,6 +21,25 @@
>
>  static void xhci_plat_quirks(struct device *dev, struct xhci_hcd *xhci)
>  {
> +       struct device *parent_dev;
> +       struct device *vendor_parent_dev;
> +
> +       parent_dev = dev->parent;
> +       vendor_parent_dev = parent_dev->parent;

Is this guaranteed to exist for all current and future xhci-plat
controllers or should you maybe check one or both for NULL?

> +
> +       /*
> +        * The DWC3-exynos host controller on Exynos5420 SoC is quirky
> +        * in a way that the PHY needs to be tuned to get it working
> +        * at SuperSpeed. By default this PHY works as High-speed phy
> +        * and so detects even Super-speed devices as high-speed ones.
> +        * Therefor the PHY needs to be tuned after controller
> +        * has been reset, since a controller reset actually forces the
> +        * PHY to fall back to its default state wherein it works as
> +        * High-Speed PHY only.
> +        */
> +       if (!strstr(dev_name(vendor_parent_dev), "exynos"))
> +               xhci->quirks |= XHCI_DWC3_EXYNOS;
> +
>         /*
>          * As of now platform drivers don't provide MSI support so we ensure
>          * here that the generic code does not try to make a pci_dev from our
> diff --git a/drivers/usb/host/xhci.h b/drivers/usb/host/xhci.h
> index 7807f62..f69af8c 100644
> --- a/drivers/usb/host/xhci.h
> +++ b/drivers/usb/host/xhci.h
> @@ -1560,6 +1560,7 @@ struct xhci_hcd {
>  #define XHCI_PLAT              (1 << 16)
>  #define XHCI_SLOW_SUSPEND      (1 << 17)
>  #define XHCI_SPURIOUS_WAKEUP   (1 << 18)
> +#define XHCI_DWC3_EXYNOS       (1 << 19)

I think in general it's better to name quirks after what they do
rather than a specific device, that way you might be able to reuse
them. How about XHCI_TUNE_AFTER_RESET? (Or you could leave out the
quirk completely and just differentiate by whether the PHY implements
the tune() method or not.)

>         unsigned int            num_active_eps;
>         unsigned int            limit_active_eps;
>         /* There are two roothubs to keep track of bus suspend info for */
> --
> 1.7.6.5
>
