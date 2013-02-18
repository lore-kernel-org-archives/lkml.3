Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757483Ab3BRJvr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 04:51:47 -0500
Received: from nasmtp02.atmel.com ([204.2.163.16]:41283 "EHLO
	nasmtp02.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756840Ab3BRJvp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 04:51:45 -0500
X-Greylist: delayed 309 seconds by postgrey-1.27 at vger.kernel.org; Mon, 18 Feb 2013 04:51:45 EST
Message-ID: <5121F80E.1010501@atmel.com>
Date: Mon, 18 Feb 2013 17:44:46 +0800
From: Bo Shen <voice.shen@atmel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Manjunath Goudar <manjunath.goudar@linaro.org>
CC: <linux-usb@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <patches@linaro.org>, <stern@rowland.harvard.edu>, <arnd@linaro.org>,
        <gregkh@linuxfoundation.org>, Greg KH <greg@kroah.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        "Andrew Victor" <linux@maxim.org.za>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [V2 2/8] USB: EHCI: make ehci-atmel a separate driver
References: <1360923853-7875-1-git-send-email-manjunath.goudar@linaro.org> <1360923853-7875-3-git-send-email-manjunath.goudar@linaro.org>
In-Reply-To: <1360923853-7875-3-git-send-email-manjunath.goudar@linaro.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.168.5.13]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/15/2013 06:24 PM, Manjunath Goudar wrote:
> Separate the Atmel host controller driver from ehci-hcd host code
> into its own driver module.
>
> In V2:
> Resolved below compiler error.
> drivers/usb/host/ehci-atmel.c: In function 'ehci_atmel_drv_remove':
> drivers/usb/host/ehci-atmel.c:167: error: implicit declaration of function 'ehci_shutdown'
>
> Signed-off-by: Manjunath Goudar<manjunath.goudar@linaro.org>
> Cc: Alan Stern<stern@rowland.harvard.edu>
> Cc: Greg KH<greg@kroah.com>
> Cc: Grant Likely<grant.likely@secretlab.ca>
> Cc: Rob Herring<rob.herring@calxeda.com>
> Cc: Andrew Victor<linux@maxim.org.za>
> Cc: Nicolas Ferre<nicolas.ferre@atmel.com>
> Cc: Jean-Christophe Plagniol-Villard<plagnioj@jcrosoft.com>
> Cc: linux-usb@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> ---
>   drivers/usb/host/Kconfig      |    8 +++++
>   drivers/usb/host/Makefile     |    1 +
>   drivers/usb/host/ehci-atmel.c |   76 ++++++++++++++++++++++-------------------
>   drivers/usb/host/ehci-hcd.c   |   10 ++----
>   drivers/usb/host/ehci.h       |    2 +-
>   5 files changed, 53 insertions(+), 44 deletions(-)
>
> diff --git a/drivers/usb/host/Kconfig b/drivers/usb/host/Kconfig
> index 15e8032..1ef37d7 100644
> --- a/drivers/usb/host/Kconfig
> +++ b/drivers/usb/host/Kconfig
> @@ -170,6 +170,14 @@ config USB_EHCI_HCD_SPEAR
>             Enables support for the on-chip EHCI controller on
>             ST SPEAr chips.
>
> +config USB_EHCI_HCD_AT91
> +        tristate  "Support for Atmel on-chip EHCI USB controller"
> +        depends on USB_EHCI_HCD&&  ARCH_AT91
> +        default y
> +        ---help---
> +          Enables support for the on-chip EHCI controller on
> +          Atmel chips.
> +
>   config USB_EHCI_MSM
>   	bool "Support for MSM on-chip EHCI USB controller"
>   	depends on USB_EHCI_HCD&&  ARCH_MSM
> diff --git a/drivers/usb/host/Makefile b/drivers/usb/host/Makefile
> index c8fcde9..b301243 100644
> --- a/drivers/usb/host/Makefile
> +++ b/drivers/usb/host/Makefile
> @@ -29,6 +29,7 @@ obj-$(CONFIG_USB_EHCI_HCD_PLATFORM)	+= ehci-platform.o
>   obj-$(CONFIG_USB_EHCI_MXC)	+= ehci-mxc.o
>   obj-$(CONFIG_USB_EHCI_HCD_SPEAR)+= ehci-spear.o
>   obj-$(CONFIG_USB_OXU210HP_HCD)	+= oxu210hp-hcd.o
> +obj-$(CONFIG_USB_EHCI_HCD_AT91) += ehci-atmel.o
>   obj-$(CONFIG_USB_ISP116X_HCD)	+= isp116x-hcd.o
>   obj-$(CONFIG_USB_ISP1362_HCD)	+= isp1362-hcd.o
>   obj-$(CONFIG_USB_OHCI_HCD)	+= ohci-hcd.o
> diff --git a/drivers/usb/host/ehci-atmel.c b/drivers/usb/host/ehci-atmel.c
> index 27639487..3cd0dd4 100644
> --- a/drivers/usb/host/ehci-atmel.c
> +++ b/drivers/usb/host/ehci-atmel.c
> @@ -15,6 +15,19 @@
>   #include<linux/platform_device.h>
>   #include<linux/of.h>
>   #include<linux/of_platform.h>
> +#include<linux/kernel.h>
> +#include<linux/module.h>
> +#include<linux/usb.h>
> +#include<linux/usb/hcd.h>
> +#include<linux/io.h>
> +#include<linux/dma-mapping.h>
> +
> +#include "ehci.h"
> +
> +#define DRIVER_DESC "EHCI atmel driver"
> +
> +static const char hcd_name[] = "ehci-atmel";
> +static struct hc_driver __read_mostly ehci_atmel_hc_driver;
>
>   /* interface and function clocks */
>   static struct clk *iclk, *fclk;
> @@ -60,41 +73,6 @@ static int ehci_atmel_setup(struct usb_hcd *hcd)
>   	return ehci_setup(hcd);
>   }
>
> -static const struct hc_driver ehci_atmel_hc_driver = {
> -	.description		= hcd_name,
> -	.product_desc		= "Atmel EHCI UHP HS",
> -	.hcd_priv_size		= sizeof(struct ehci_hcd),
> -
> -	/* generic hardware linkage */
> -	.irq			= ehci_irq,
> -	.flags			= HCD_MEMORY | HCD_USB2,
> -
> -	/* basic lifecycle operations */
> -	.reset			= ehci_atmel_setup,
> -	.start			= ehci_run,
> -	.stop			= ehci_stop,
> -	.shutdown		= ehci_shutdown,
> -
> -	/* managing i/o requests and associated device resources */
> -	.urb_enqueue		= ehci_urb_enqueue,
> -	.urb_dequeue		= ehci_urb_dequeue,
> -	.endpoint_disable	= ehci_endpoint_disable,
> -	.endpoint_reset		= ehci_endpoint_reset,
> -
> -	/* scheduling support */
> -	.get_frame_number	= ehci_get_frame,
> -
> -	/* root hub support */
> -	.hub_status_data	= ehci_hub_status_data,
> -	.hub_control		= ehci_hub_control,
> -	.bus_suspend		= ehci_bus_suspend,
> -	.bus_resume		= ehci_bus_resume,
> -	.relinquish_port	= ehci_relinquish_port,
> -	.port_handed_over	= ehci_port_handed_over,
> -
> -	.clear_tt_buffer_complete	= ehci_clear_tt_buffer_complete,
> -};
> -
>   static u64 at91_ehci_dma_mask = DMA_BIT_MASK(32);
>
>   static int ehci_atmel_drv_probe(struct platform_device *pdev)
> @@ -210,7 +188,33 @@ static struct platform_driver ehci_atmel_driver = {
>   	.remove		= ehci_atmel_drv_remove,
>   	.shutdown	= usb_hcd_platform_shutdown,
>   	.driver		= {
> -		.name	= "atmel-ehci",
> +		.name	= hcd_name,

This change will cause atmel ehci won't work with the none device tree 
kernel.

it can be fixed with replace other places using "atmel-ehci" with 
<hcd_name>, that means replace "atmel-ehci" with "ehci-atmel" at other 
places.

Best Regards,
Bo Shen


