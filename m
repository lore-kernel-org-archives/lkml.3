Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933811Ab3BNKSp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 05:18:45 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:49916 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757180Ab3BNKSo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 05:18:44 -0500
Message-ID: <511CB9E9.5050804@ti.com>
Date: Thu, 14 Feb 2013 12:18:17 +0200
From: Roger Quadros <rogerq@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: <gregkh@linuxfoundation.org>
CC: Roger Quadros <rogerq@ti.com>, <sameo@linux.intel.com>, <balbi@ti.com>,
        <tony@atomide.com>, <kishon@ti.com>, <sshtylyov@mvista.com>,
        <bjorn@mork.no>, <linux@arm.linux.org.uk>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH v9 02/20] mfd: omap-usb-host: Consolidate OMAP USB-HS
 platform data
References: <1358937492-8129-1-git-send-email-rogerq@ti.com> <1358937492-8129-3-git-send-email-rogerq@ti.com>
In-Reply-To: <1358937492-8129-3-git-send-email-rogerq@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

On 01/23/2013 12:37 PM, Roger Quadros wrote:
> Let's have a single platform data structure for the OMAP's High-Speed
> USB host subsystem instead of having 3 separate ones i.e. one for
> board data, one for USB Host (UHH) module and one for USB-TLL module.
> 
> This makes the code much simpler and avoids creating multiple copies of
> platform data.
> 
> CC: Alan Stern <stern@rowland.harvard.edu>
> 
> Signed-off-by: Roger Quadros <rogerq@ti.com>
> Reviewed-by: Felipe Balbi <balbi@ti.com>
> For the ehci-omap.c part:
> Acked-by: Alan Stern <stern@rowland.harvard.edu>

Could you please ACK the drivers/usb/host/ehci-omap.c part
so that this can go through the MFD tree. Thanks.

The reason it needs to go through MFD is that it depends on
a platform header change which Samuel and Tony have agreed to share.

cheers,
-roger

> ---
>  arch/arm/mach-omap2/board-3430sdp.c        |    2 +-
>  arch/arm/mach-omap2/board-3630sdp.c        |    2 +-
>  arch/arm/mach-omap2/board-am3517crane.c    |    2 +-
>  arch/arm/mach-omap2/board-am3517evm.c      |    2 +-
>  arch/arm/mach-omap2/board-cm-t35.c         |    2 +-
>  arch/arm/mach-omap2/board-cm-t3517.c       |    2 +-
>  arch/arm/mach-omap2/board-devkit8000.c     |    2 +-
>  arch/arm/mach-omap2/board-igep0020.c       |    4 +-
>  arch/arm/mach-omap2/board-omap3beagle.c    |    2 +-
>  arch/arm/mach-omap2/board-omap3evm.c       |    2 +-
>  arch/arm/mach-omap2/board-omap3pandora.c   |    2 +-
>  arch/arm/mach-omap2/board-omap3stalker.c   |    2 +-
>  arch/arm/mach-omap2/board-omap3touchbook.c |    2 +-
>  arch/arm/mach-omap2/board-omap4panda.c     |    2 +-
>  arch/arm/mach-omap2/board-overo.c          |    2 +-
>  arch/arm/mach-omap2/board-zoom.c           |    2 +-
>  arch/arm/mach-omap2/usb-host.c             |   29 ++-----------
>  arch/arm/mach-omap2/usb.h                  |   20 +--------
>  drivers/mfd/omap-usb-host.c                |   63 +++++++++++----------------
>  drivers/mfd/omap-usb-tll.c                 |   11 ++---
>  drivers/usb/host/ehci-omap.c               |    6 +-
>  include/linux/platform_data/usb-omap.h     |   23 ++--------
>  22 files changed, 61 insertions(+), 125 deletions(-)
> 

<snip>

> diff --git a/drivers/usb/host/ehci-omap.c b/drivers/usb/host/ehci-omap.c
> index e9d9b09..b96a4bf 100644
> --- a/drivers/usb/host/ehci-omap.c
> +++ b/drivers/usb/host/ehci-omap.c
> @@ -107,7 +107,7 @@ static int omap_ehci_init(struct usb_hcd *hcd)
>  {
>  	struct ehci_hcd		*ehci = hcd_to_ehci(hcd);
>  	int			rc;
> -	struct ehci_hcd_omap_platform_data	*pdata;
> +	struct usbhs_omap_platform_data	*pdata;
>  
>  	pdata = hcd->self.controller->platform_data;
>  
> @@ -151,7 +151,7 @@ static int omap_ehci_init(struct usb_hcd *hcd)
>  }
>  
>  static void disable_put_regulator(
> -		struct ehci_hcd_omap_platform_data *pdata)
> +		struct usbhs_omap_platform_data *pdata)
>  {
>  	int i;
>  
> @@ -176,7 +176,7 @@ static void disable_put_regulator(
>  static int ehci_hcd_omap_probe(struct platform_device *pdev)
>  {
>  	struct device				*dev = &pdev->dev;
> -	struct ehci_hcd_omap_platform_data	*pdata = dev->platform_data;
> +	struct usbhs_omap_platform_data		*pdata = dev->platform_data;
>  	struct resource				*res;
>  	struct usb_hcd				*hcd;
>  	void __iomem				*regs;
> diff --git a/include/linux/platform_data/usb-omap.h b/include/linux/platform_data/usb-omap.h
> index ef65b67..04c7537 100644
> --- a/include/linux/platform_data/usb-omap.h
> +++ b/include/linux/platform_data/usb-omap.h
> @@ -38,30 +38,15 @@ enum usbhs_omap_port_mode {
>  	OMAP_OHCI_PORT_MODE_TLL_2PIN_DPDM
>  };
>  
> -struct usbtll_omap_platform_data {
> -	enum usbhs_omap_port_mode		port_mode[OMAP3_HS_USB_PORTS];
> -};
> -
> -struct ehci_hcd_omap_platform_data {
> +struct usbhs_omap_platform_data {
>  	enum usbhs_omap_port_mode	port_mode[OMAP3_HS_USB_PORTS];
>  	int				reset_gpio_port[OMAP3_HS_USB_PORTS];
>  	struct regulator		*regulator[OMAP3_HS_USB_PORTS];
> -	unsigned			phy_reset:1;
> -};
> -
> -struct ohci_hcd_omap_platform_data {
> -	enum usbhs_omap_port_mode	port_mode[OMAP3_HS_USB_PORTS];
> -	unsigned			es2_compatibility:1;
> -};
> -
> -struct usbhs_omap_platform_data {
> -	enum usbhs_omap_port_mode		port_mode[OMAP3_HS_USB_PORTS];
> -
> -	struct ehci_hcd_omap_platform_data	*ehci_data;
> -	struct ohci_hcd_omap_platform_data	*ohci_data;
>  
>  	/* OMAP3 <= ES2.1 have a single ulpi bypass control bit */
> -	unsigned				single_ulpi_bypass:1;
> +	unsigned			single_ulpi_bypass:1;
> +	unsigned			es2_compatibility:1;
> +	unsigned			phy_reset:1;
>  };
>  
>  /*-------------------------------------------------------------------------*/
> 

