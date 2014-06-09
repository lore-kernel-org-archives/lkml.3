Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932130AbaFIUWR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 16:22:17 -0400
Received: from mail-ob0-f177.google.com ([209.85.214.177]:63916 "EHLO
	mail-ob0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751879AbaFIUWP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 16:22:15 -0400
MIME-Version: 1.0
In-Reply-To: <1402056736-12674-3-git-send-email-gautam.vivek@samsung.com>
References: <1402056736-12674-1-git-send-email-gautam.vivek@samsung.com>
	<1402056736-12674-3-git-send-email-gautam.vivek@samsung.com>
Date: Mon, 9 Jun 2014 13:22:14 -0700
X-Google-Sender-Auth: svzLkz4Q9-2VxEaNNmhxpeWIqig
Message-ID: <CAODwPW-2tbDht8P=KsTyTyeBivFtFMiyCpxd0QFa-cUSRTpJjQ@mail.gmail.com>
Subject: Re: [PATCH 2/4] usb: host: xhci-plat: Add support to get PHYs
From: Julius Werner <jwerner@chromium.org>
To: Vivek Gautam <gautam.vivek@samsung.com>
Cc: "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        kishon <kishon@ti.com>, Mathias Nyman <mathias.nyman@intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Julius Werner <jwerner@chromium.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> diff --git a/drivers/usb/host/xhci.h b/drivers/usb/host/xhci.h
> index 9ffecd5..453d89e 100644
> --- a/drivers/usb/host/xhci.h
> +++ b/drivers/usb/host/xhci.h
> @@ -1582,6 +1582,9 @@ struct xhci_hcd {
>         u32                     port_status_u0;
>  /* Compliance Mode Timer Triggered every 2 seconds */
>  #define COMP_MODE_RCVRY_MSECS 2000
> +       /* phys for the controller */
> +       struct phy              *phy2_gen;
> +       struct phy              *phy3_gen;
>  };

I don't think adding new variables here and restricting most of this
logic to xhci-plat.c (in the next patch) is the best way to do it.
There's no conceptual reason why other host controllers (e.g. xhci-pci
or even EHCI) could not have a similar need to tune their PHY after
reset. PHYs are universal to all host controllers.

There is already a 'phy' member in struct usb_hcd which I think is
mostly unused right now. I think it would be much less
confusing/redundant to reuse that member for this purpose (you could
still set it up from xhci_plat_probe(), and then call it from
hcd_bus_resume() or something like that). Since XHCI host controllers
already conveniently have two struct usb_hcd (one for 2.0 and one for
3.0), you can cleanly store references to your two PHYs in there.
