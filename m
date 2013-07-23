Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752907Ab3GWCGD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 22:06:03 -0400
Received: from mail-pb0-f41.google.com ([209.85.160.41]:63290 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752015Ab3GWCGA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 22:06:00 -0400
MIME-Version: 1.0
In-Reply-To: <1374488380-26428-1-git-send-email-manjunath.goudar@linaro.org>
References: <1372347109-5563-1-git-send-email-manjunath.goudar@linaro.org> <1374488380-26428-1-git-send-email-manjunath.goudar@linaro.org>
From: Wan ZongShun <mcuos.com@gmail.com>
Date: Tue, 23 Jul 2013 10:05:39 +0800
Message-ID: <CAKT61h_fdTHH=K2-6oHM4L+Ec6h2zRjS19gDKOZVyv2BCrpJhA@mail.gmail.com>
Subject: Re: [PATCH V2] USB: EHCI: make ehci-w90X900 a separate driver
To: Manjunath Goudar <manjunath.goudar@linaro.org>
Cc: linux-usb@vger.kernel.org,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        patches@linaro.org, Alan Stern <stern@rowland.harvard.edu>,
        Arnd Bergmann <arnd@linaro.org>, linaro-kernel@lists.linaro.org,
        Greg KH <greg@kroah.com>, linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/7/22 Manjunath Goudar <manjunath.goudar@linaro.org>:
> Separate the W90X900(W90P910) on-chip host controller driver from
> ehci-hcd host code so that it can be built as a separate driver module.
> This work is part of enabling multi-platform kernels on ARM;
> however, note that other changes are still needed before W90X900(W90P910)
> can be booted with a multi-platform kernel
>
> and an ehci driver that only works on one of them.
>
> With the infrastructure added by Alan Stern in patch 3e0232039
> "USB: EHCI: prepare to make ehci-hcd a library module", we can
> avoid this problem by turning a bus glue into a separate
> module, as we do here for the w90X900 bus glue.
>
> Signed-off-by: Manjunath Goudar <manjunath.goudar@linaro.org>
> Acked-by: Arnd Bergmann <arnd@arndb.de>
> Cc: Greg KH <greg@kroah.com>
> Cc: Alan Stern <stern@rowland.harvard.edu>
> Cc: Wan ZongShun <mcuos.com@gmail.com>
> Cc: linux-usb@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
>

Manjunath,

Thanks for your patch, it is good to me.

Acked-by: Wan Zongshun <mcuos.com@gmail.com>

> V2:
>  -Arranged  #include's in alphabetical order.
>  -Replaced "w90p910" by "w90x900" because it is supports
>   all series of w90x900.
> ---
>  drivers/usb/host/Kconfig        |    2 +-
>  drivers/usb/host/Makefile       |    1 +
>  drivers/usb/host/ehci-hcd.c     |    5 ---
>  drivers/usb/host/ehci-w90x900.c |   85 ++++++++++++++++-----------------------
>  4 files changed, 37 insertions(+), 56 deletions(-)
>
> diff --git a/drivers/usb/host/Kconfig b/drivers/usb/host/Kconfig
> index ba52912..7bc598b 100644
> --- a/drivers/usb/host/Kconfig
> +++ b/drivers/usb/host/Kconfig
> @@ -244,7 +244,7 @@ config USB_EHCI_MV
>           SoCs, see USB_EHCI_HCD_ORION for those.
>
>  config USB_W90X900_EHCI
> -       bool "W90X900(W90P910) EHCI support"
> +       tristate "W90X900(W90P910) EHCI support"
>         depends on ARCH_W90X900
>         ---help---
>                 Enables support for the W90X900 USB controller
> diff --git a/drivers/usb/host/Makefile b/drivers/usb/host/Makefile
> index 7664db8..28adb3f 100644
> --- a/drivers/usb/host/Makefile
> +++ b/drivers/usb/host/Makefile
> @@ -35,6 +35,7 @@ obj-$(CONFIG_USB_EHCI_HCD_AT91) += ehci-atmel.o
>  obj-$(CONFIG_USB_EHCI_MSM)     += ehci-msm.o
>  obj-$(CONFIG_USB_EHCI_TEGRA)   += ehci-tegra.o
>  obj-$(CONFIG_USB_EHCI_MV)       += ehci-mv.o
> +obj-$(CONFIG_USB_W90X900_EHCI) += ehci-w90x900.o
>
>  obj-$(CONFIG_USB_OXU210HP_HCD) += oxu210hp-hcd.o
>  obj-$(CONFIG_USB_ISP116X_HCD)  += isp116x-hcd.o
> diff --git a/drivers/usb/host/ehci-hcd.c b/drivers/usb/host/ehci-hcd.c
> index 5717dcd..4a5644e 100644
> --- a/drivers/usb/host/ehci-hcd.c
> +++ b/drivers/usb/host/ehci-hcd.c
> @@ -1249,11 +1249,6 @@ MODULE_LICENSE ("GPL");
>  #define XILINX_OF_PLATFORM_DRIVER      ehci_hcd_xilinx_of_driver
>  #endif
>
> -#ifdef CONFIG_USB_W90X900_EHCI
> -#include "ehci-w90x900.c"
> -#define        PLATFORM_DRIVER         ehci_hcd_w90x900_driver
> -#endif
> -
>  #ifdef CONFIG_USB_OCTEON_EHCI
>  #include "ehci-octeon.c"
>  #define PLATFORM_DRIVER                ehci_octeon_driver
> diff --git a/drivers/usb/host/ehci-w90x900.c b/drivers/usb/host/ehci-w90x900.c
> index 59e0e24..4d6631d 100644
> --- a/drivers/usb/host/ehci-w90x900.c
> +++ b/drivers/usb/host/ehci-w90x900.c
> @@ -11,13 +11,28 @@
>   *
>   */
>
> +#include <linux/dma-mapping.h>
> +#include <linux/io.h>
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/of.h>
>  #include <linux/platform_device.h>
> +#include <linux/usb.h>
> +#include <linux/usb/hcd.h>
> +
> +#include "ehci.h"
>
>  /* enable phy0 and phy1 for w90p910 */
>  #define        ENPHY           (0x01<<8)
>  #define PHY0_CTR       (0xA4)
>  #define PHY1_CTR       (0xA8)
>
> +#define DRIVER_DESC "EHCI w90x900 driver"
> +
> +static const char hcd_name[] = "ehci-w90x900 ";
> +
> +static struct hc_driver __read_mostly ehci_w90x900_hc_driver;
> +
>  static int usb_w90x900_probe(const struct hc_driver *driver,
>                       struct platform_device *pdev)
>  {
> @@ -99,54 +114,6 @@ void usb_w90x900_remove(struct usb_hcd *hcd, struct platform_device *pdev)
>         usb_put_hcd(hcd);
>  }
>
> -static const struct hc_driver ehci_w90x900_hc_driver = {
> -       .description = hcd_name,
> -       .product_desc = "Nuvoton w90x900 EHCI Host Controller",
> -       .hcd_priv_size = sizeof(struct ehci_hcd),
> -
> -       /*
> -        * generic hardware linkage
> -        */
> -       .irq = ehci_irq,
> -       .flags = HCD_USB2|HCD_MEMORY,
> -
> -       /*
> -        * basic lifecycle operations
> -        */
> -       .reset = ehci_setup,
> -       .start = ehci_run,
> -
> -       .stop = ehci_stop,
> -       .shutdown = ehci_shutdown,
> -
> -       /*
> -        * managing i/o requests and associated device resources
> -        */
> -       .urb_enqueue = ehci_urb_enqueue,
> -       .urb_dequeue = ehci_urb_dequeue,
> -       .endpoint_disable = ehci_endpoint_disable,
> -       .endpoint_reset = ehci_endpoint_reset,
> -
> -       /*
> -        * scheduling support
> -        */
> -       .get_frame_number = ehci_get_frame,
> -
> -       /*
> -        * root hub support
> -        */
> -       .hub_status_data = ehci_hub_status_data,
> -       .hub_control = ehci_hub_control,
> -#ifdef CONFIG_PM
> -       .bus_suspend = ehci_bus_suspend,
> -       .bus_resume = ehci_bus_resume,
> -#endif
> -       .relinquish_port        = ehci_relinquish_port,
> -       .port_handed_over       = ehci_port_handed_over,
> -
> -       .clear_tt_buffer_complete = ehci_clear_tt_buffer_complete,
> -};
> -
>  static int ehci_w90x900_probe(struct platform_device *pdev)
>  {
>         if (usb_disabled())
> @@ -173,7 +140,25 @@ static struct platform_driver ehci_hcd_w90x900_driver = {
>         },
>  };
>
> +static int __init ehci_w90X900_init(void)
> +{
> +       if (usb_disabled())
> +               return -ENODEV;
> +
> +       pr_info("%s: " DRIVER_DESC "\n", hcd_name);
> +
> +       ehci_init_driver(&ehci_w90x900_hc_driver, NULL);
> +       return platform_driver_register(&ehci_hcd_w90x900_driver);
> +}
> +module_init(ehci_w90X900_init);
> +
> +static void __exit ehci_w90X900_cleanup(void)
> +{
> +       platform_driver_unregister(&ehci_hcd_w90x900_driver);
> +}
> +module_exit(ehci_w90X900_cleanup);
> +
> +MODULE_DESCRIPTION(DRIVER_DESC);
>  MODULE_AUTHOR("Wan ZongShun <mcuos.com@gmail.com>");
> -MODULE_DESCRIPTION("w90p910 usb ehci driver!");
> -MODULE_LICENSE("GPL");
>  MODULE_ALIAS("platform:w90p910-ehci");
> +MODULE_LICENSE("GPL v2");
> --
> 1.7.9.5
>



--
Wan ZongShun.
www.mcuos.com
