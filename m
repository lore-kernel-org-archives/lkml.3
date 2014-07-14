Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753763AbaGNJIN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 05:08:13 -0400
Received: from mail-qc0-f181.google.com ([209.85.216.181]:50497 "EHLO
	mail-qc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751282AbaGNJIE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 05:08:04 -0400
MIME-Version: 1.0
In-Reply-To: <1404901036-27682-4-git-send-email-antoine.tenart@free-electrons.com>
References: <1404901036-27682-1-git-send-email-antoine.tenart@free-electrons.com>
	<1404901036-27682-4-git-send-email-antoine.tenart@free-electrons.com>
Date: Mon, 14 Jul 2014 14:38:03 +0530
X-Google-Sender-Auth: ncez48qpWaYAtqJ5B3rPDcSb6qw
Message-ID: <CAFp+6iELkaXOQiM0=JzUj=YZGqfMjOPFt+-dnEs4=Q3EzyBJBQ@mail.gmail.com>
Subject: Re: [PATCH 3/4] usb: add support to the PHY framework for HCD
From: Vivek Gautam <gautam.vivek@samsung.com>
To: =?UTF-8?Q?Antoine_T=C3=A9nart?= <antoine.tenart@free-electrons.com>
Cc: Felipe Balbi <balbi@ti.com>, Greg KH <gregkh@linuxfoundation.org>,
        Peter.Chen@freescale.com, kishon <kishon@ti.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        alexandre.belloni@free-electrons.com,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        zhiming Xu <zmxu@marvell.com>, jszhang@marvell.com,
        Linux USB Mailing List <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

CC: Sergei, Yoshihiro

On Wed, Jul 9, 2014 at 3:47 PM, Antoine Ténart
<antoine.tenart@free-electrons.com> wrote:
> This patch adds the support to PHY framework in HCD code while keeping
> the USB PHY compatibility. Changes are done in both the HCD common code
> and in the drivers accessing its PHY. This is done in two steps:
> renaming 'phy' into 'usb_phy' and adding a new 'phy' member into the
> usb_hcd structure.
>
> Signed-off-by: Antoine Ténart <antoine.tenart@free-electrons.com>
> ---
>  drivers/usb/chipidea/host.c   |  2 +-
>  drivers/usb/core/hcd.c        | 61 +++++++++++++++++++++++++++++++------------
>  drivers/usb/core/hub.c        |  8 +++---
>  drivers/usb/host/ehci-fsl.c   | 16 ++++++------
>  drivers/usb/host/ehci-hub.c   |  2 +-
>  drivers/usb/host/ehci-msm.c   |  4 +--
>  drivers/usb/host/ehci-tegra.c | 16 ++++++------
>  drivers/usb/host/ohci-omap.c  | 20 +++++++-------
>  include/linux/usb/hcd.h       |  5 +++-
>  9 files changed, 82 insertions(+), 52 deletions(-)
>
> diff --git a/drivers/usb/chipidea/host.c b/drivers/usb/chipidea/host.c
> index a93d950e9468..fc7541c906a2 100644
> --- a/drivers/usb/chipidea/host.c
> +++ b/drivers/usb/chipidea/host.c
> @@ -59,7 +59,7 @@ static int host_start(struct ci_hdrc *ci)
>         hcd->has_tt = 1;
>
>         hcd->power_budget = ci->platdata->power_budget;
> -       hcd->phy = ci->transceiver;
> +       hcd->usb_phy = ci->transceiver;
>
>         ehci = hcd_to_ehci(hcd);
>         ehci->caps = ci->hw_bank.cap;
> diff --git a/drivers/usb/core/hcd.c b/drivers/usb/core/hcd.c
> index bec31e2efb88..b985af5b167c 100644
> --- a/drivers/usb/core/hcd.c
> +++ b/drivers/usb/core/hcd.c
> @@ -42,6 +42,7 @@
>  #include <linux/pm_runtime.h>
>  #include <linux/types.h>
>
> +#include <linux/phy/phy.h>
>  #include <linux/usb.h>
>  #include <linux/usb/hcd.h>
>  #include <linux/usb/phy.h>
> @@ -2631,21 +2632,35 @@ int usb_add_hcd(struct usb_hcd *hcd,
>         int retval;
>         struct usb_device *rhdev;
>
> -       if (IS_ENABLED(CONFIG_USB_PHY) && !hcd->phy) {
> -               struct usb_phy *phy = usb_get_phy_dev(hcd->self.controller, 0);
> +       if (IS_ENABLED(CONFIG_USB_PHY) && !hcd->phy && !hcd->usb_phy) {
> +               struct phy *phy = of_phy_get(hcd->self.controller->of_node, 0);
>
> -               if (IS_ERR(phy)) {
> -                       retval = PTR_ERR(phy);
> -                       if (retval == -EPROBE_DEFER)
> -                               return retval;
> -               } else {
> -                       retval = usb_phy_init(phy);
> +               if (!IS_ERR(phy)) {
> +                       retval = phy_init(hcd->phy);
>                         if (retval) {
> -                               usb_put_phy(phy);
> +                               phy_exit(hcd->phy);
>                                 return retval;
>                         }
> +                       retval = phy_power_on(hcd->phy);
>                         hcd->phy = phy;
>                         hcd->remove_phy = 1;
> +               } else {
> +                       struct usb_phy *phy =
> +                               usb_get_phy_dev(hcd->self.controller, 0);
> +
> +                       if (IS_ERR(phy)) {
> +                               retval = PTR_ERR(phy);
> +                               if (retval == -EPROBE_DEFER)
> +                                       return retval;
> +                       } else {
> +                               retval = usb_phy_init(phy);
> +                               if (retval) {
> +                                       usb_put_phy(phy);
> +                                       return retval;
> +                               }
> +                               hcd->usb_phy = phy;
> +                               hcd->remove_phy = 1;
> +                       }
>                 }
>         }

Just a note here:
There had already been a patch for adding the generic phy support in
usb/core/hcd.c in 3.16 cycle by
Sergei and Yoshihiro [1], though structurally a bit different, was not
picked since there wasn't any user of the patch
till then. Do you mind modifying on top of that patch

[1] https://www.mail-archive.com/linux-usb@vger.kernel.org/msg43471.html

>
> @@ -2792,10 +2807,16 @@ err_allocate_root_hub:
>  err_register_bus:
>         hcd_buffer_destroy(hcd);
>  err_remove_phy:
> -       if (hcd->remove_phy && hcd->phy) {
> -               usb_phy_shutdown(hcd->phy);
> -               usb_put_phy(hcd->phy);
> -               hcd->phy = NULL;
> +       if (hcd->remove_phy) {
> +               if (hcd->phy) {
> +                       phy_power_off(hcd->phy);
> +                       phy_exit(hcd->phy);
> +                       hcd->phy = NULL;
> +               } else if (hcd->usb_phy) {
> +                       usb_phy_shutdown(hcd->usb_phy);
> +                       usb_put_phy(hcd->usb_phy);
> +                       hcd->usb_phy = NULL;
> +               }
>         }
>         return retval;
>  }
> @@ -2868,10 +2889,16 @@ void usb_remove_hcd(struct usb_hcd *hcd)
>
>         usb_deregister_bus(&hcd->self);
>         hcd_buffer_destroy(hcd);
> -       if (hcd->remove_phy && hcd->phy) {
> -               usb_phy_shutdown(hcd->phy);
> -               usb_put_phy(hcd->phy);
> -               hcd->phy = NULL;
> +       if (hcd->remove_phy) {
> +               if (hcd->phy) {
> +                       phy_power_off(hcd->phy);
> +                       phy_exit(hcd->phy);
> +                       hcd->phy = NULL;
> +               } else if (hcd->usb_phy) {
> +                       usb_phy_shutdown(hcd->usb_phy);
> +                       usb_put_phy(hcd->usb_phy);
> +                       hcd->usb_phy = NULL;
> +               }
>         }
>
>         usb_put_invalidate_rhdev(hcd);

[snip]



-- 
Best Regards
Vivek Gautam
Samsung R&D Institute, Bangalore
India
