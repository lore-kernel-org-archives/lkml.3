Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753257Ab3BEGce (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 01:32:34 -0500
Received: from mail-bk0-f50.google.com ([209.85.214.50]:43300 "EHLO
	mail-bk0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750786Ab3BEGcb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 01:32:31 -0500
MIME-Version: 1.0
In-Reply-To: <077e01cdfeae$8fbc2850$af3478f0$@samsung.com>
References: <1358168377-22919-2-git-send-email-gautam.vivek@samsung.com>
	<1359368690-30178-1-git-send-email-gautam.vivek@samsung.com>
	<077e01cdfeae$8fbc2850$af3478f0$@samsung.com>
Date: Tue, 5 Feb 2013 12:02:29 +0530
Message-ID: <CAFp+6iGDONL0wMs0uqxyk0JP+H=9Zq7YOsBxo-_s87RojYgTBw@mail.gmail.com>
Subject: Re: [PATCH v4 1/2] usb: phy: samsung: Common out the generic stuff
From: Vivek Gautam <gautamvivek1987@gmail.com>
To: Kukjin Kim <kgene.kim@samsung.com>
Cc: Vivek Gautam <gautam.vivek@samsung.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        linux-samsung-soc@vger.kernel.org, gregkh@linuxfoundation.org,
        balbi@ti.com, grant.likely@secretlab.ca, sylvester.nawrocki@gmail.com,
        tomasz.figa@gmail.com, av.tikhomirov@samsung.com,
        dianders@chromium.org, p.paneri@samsung.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kukjin,


On Wed, Jan 30, 2013 at 11:26 AM, Kukjin Kim <kgene.kim@samsung.com> wrote:
> Vivek Gautam wrote:
>>
>> Moving register and structure definitions to header file,
>> and keeping the generic functions to be used across
>> multiple PHYs in common file "samsung-usbphy.c".
>> Also renaming the usb 2.0 phy driver to "samsung-usb2.c"
>
> Just in my opinion, Samsung-usb2phy is more clear?...In addition, I looked
> at using SAMSUNG_USB2PHY as a statement.
>

Sure will change the file names as suggested
samsung-usbphy.c : common PHY controller driver
samsung-usb2phy.c : USB 2.0 PHY controller driver

Will change the names for CONFIG_XX also accordingly.

>>
>> Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
>> ---
>>
>> Changes from v3:
>>  - Using separate config SAMSUNG_USB2PHY dependent on
>>    SAMSUNG_USBPHY for samsung-usb2 type PHY controller.
>>
>>  drivers/usb/phy/Kconfig          |   14 +-
>>  drivers/usb/phy/Makefile         |    1 +
>>  drivers/usb/phy/samsung-usb2.c   |  511 +++++++++++++++++++++++++++
>>  drivers/usb/phy/samsung-usbphy.c |  714
> +-------------------------------------
>>  drivers/usb/phy/samsung-usbphy.h |  247 +++++++++++++
>>  5 files changed, 778 insertions(+), 709 deletions(-)
>>  create mode 100644 drivers/usb/phy/samsung-usb2.c
>>  create mode 100644 drivers/usb/phy/samsung-usbphy.h
>>
>> diff --git a/drivers/usb/phy/Kconfig b/drivers/usb/phy/Kconfig
>> index fae4d08..cc0d230 100644
>> --- a/drivers/usb/phy/Kconfig
>> +++ b/drivers/usb/phy/Kconfig
>> @@ -48,8 +48,18 @@ config USB_RCAR_PHY
>>
>>  config SAMSUNG_USBPHY
>>       bool "Samsung USB PHY controller Driver"
>> -     depends on USB_S3C_HSOTG || USB_EHCI_S5P ||
>> USB_OHCI_EXYNOS
>
> So this can be selected without any dependency?
>

The idea was SAMSUNG_USBPHY is selected for usb2 type PHY as well as
usb 3 type PHY.
But this seems to be bad :-(
Better we do something like this ?

config SAMSUNG_USB2
        bool "Samsung USB 2.0 PHY controller Driver"
        select SAMSUNG_USBPHY
        select USB_OTG_UTILS
        help
          Enable this to support Samsung USB 2.0 (High Speed) PHY controller
          driver for Samsung SoCs.

config SAMSUNG_USBPHY
        bool "Samsung USB PHY controller Driver"
        help
          Enable this to support Samsung USB phy helper driver for Samsung SoCs.
          This driver provides common interface for Samsung USB 2.0 PHY driver
          and later for Samsung USB 3.0 PHY driver.

>>       select USB_OTG_UTILS
>>       help
>> -       Enable this to support Samsung USB phy controller for samsung
>> +       Enable this to support Samsung USB phy controllers for Samsung
>>         SoCs.
>
> Hmm, according to above comments, this should be enabled under Samsung SoC?
>

May we just add these configs under USB as mentioned above ?

>> +
>> +if SAMSUNG_USBPHY
>
> Why is this needed here?
>

We will not need this if we change to something like mentioned above.

>> +
>> +config SAMSUNG_USB2PHY
>> +     bool "Samsung USB 2.0 PHY controller Driver"
>> +     depends on USB_S3C_HSOTG || USB_EHCI_S5P ||
>> USB_OHCI_EXYNOS
>> +     help
>> +       Enable this to support Samsung USB 2.0 (High Speed) phy controller
>> +       for Samsung SoCs.
>> +
>> +endif
>> diff --git a/drivers/usb/phy/Makefile b/drivers/usb/phy/Makefile
>> index ec304f6..7ba9862 100644
>> --- a/drivers/usb/phy/Makefile
>> +++ b/drivers/usb/phy/Makefile
>> @@ -10,3 +10,4 @@ obj-$(CONFIG_MV_U3D_PHY)            +=
>> mv_u3d_phy.o
>>  obj-$(CONFIG_USB_EHCI_TEGRA) += tegra_usb_phy.o
>>  obj-$(CONFIG_USB_RCAR_PHY)           += rcar-phy.o
>>  obj-$(CONFIG_SAMSUNG_USBPHY)         += samsung-usbphy.o
>> +obj-$(CONFIG_SAMSUNG_USB2PHY)                += samsung-usb2.o
>> diff --git a/drivers/usb/phy/samsung-usb2.c b/drivers/usb/phy/samsung-
>> usb2.c
>> new file mode 100644
>> index 0000000..9a9d1d0
>> --- /dev/null
>> +++ b/drivers/usb/phy/samsung-usb2.c
>> @@ -0,0 +1,511 @@
>> +/* linux/drivers/usb/phy/samsung-usb2.c
>> + *
>> + * Copyright (c) 2012 Samsung Electronics Co., Ltd.
>> + *              http://www.samsung.com
>> + *
>> + * Author: Praveen Paneri <p.paneri@samsung.com>
>> + *
>> + * Samsung USB2.0 PHY transceiver; talks to S3C HS OTG controller,
> EHCI-S5P
>> and
>> + * OHCI-EXYNOS controllers.
>> + *
>> + * This program is free software; you can redistribute it and/or modify
>> + * it under the terms of the GNU General Public License version 2 as
>> + * published by the Free Software Foundation.
>> + *
>> + * This program is distributed in the hope that it will be useful,
>> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
>> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>> + * GNU General Public License for more details.
>> + */
>> +
>> +#include <linux/module.h>
>> +#include <linux/platform_device.h>
>> +#include <linux/clk.h>
>> +#include <linux/delay.h>
>> +#include <linux/device.h>
>> +#include <linux/err.h>
>> +#include <linux/io.h>
>> +#include <linux/of.h>
>> +#include <linux/usb/otg.h>
>> +#include <linux/usb/samsung_usb_phy.h>
>> +#include <linux/platform_data/samsung-usbphy.h>
>> +
>> +#include "samsung-usbphy.h"
>> +
>> +int samsung_usbphy_set_host(struct usb_otg *otg, struct usb_bus *host)
>
> For naming, if you want to support usb 2.0 phy here, the name of fuction
> should be changed to more clear name such as usb2phy or whatever.
>
> As I'm understanding, the samsung-usbphy.c can be used for common stuff and
> this is for only usb 2.0 phy.
>

True.
Will keep the naming as suggested. usb2phy naming for functions
specific to SAMSUNG_USB2PHY

> [...]
>
>> +#ifdef CONFIG_OF
>> +static const struct of_device_id samsung_usbphy_dt_match[] = {
>> +     {
>> +             .compatible = "samsung,s3c64xx-usbphy",
>> +             .data = &usbphy_s3c64xx,
>> +     }, {
>> +             .compatible = "samsung,exynos4210-usbphy",
>> +             .data = &usbphy_exynos4,
>> +     }, {
>> +             .compatible = "samsung,exynos5250-usbphy",
>> +             .data = &usbphy_exynos5
>> +     },
>> +     {},
>> +};
>> +MODULE_DEVICE_TABLE(of, samsung_usbphy_dt_match);
>> +#endif
>> +
>> +static struct platform_device_id samsung_usbphy_driver_ids[] = {
>> +     {
>> +             .name           = "s3c64xx-usbphy",
>> +             .driver_data    = (unsigned long)&usbphy_s3c64xx,
>> +     }, {
>> +             .name           = "exynos4210-usbphy",
>> +             .driver_data    = (unsigned long)&usbphy_exynos4,
>> +     }, {
>> +             .name           = "exynos5250-usbphy",
>> +             .driver_data    = (unsigned long)&usbphy_exynos5,
>> +     },
>> +     {},
>> +};
>> +
>> +MODULE_DEVICE_TABLE(platform, samsung_usbphy_driver_ids);
>> +
>> +static struct platform_driver samsung_usbphy_driver = {
>> +     .probe          = samsung_usbphy_probe,
>> +     .remove         = samsung_usbphy_remove,
>> +     .id_table       = samsung_usbphy_driver_ids,
>> +     .driver         = {
>> +             .name   = "samsung-usbphy",
>> +             .owner  = THIS_MODULE,
>> +             .of_match_table =
>> of_match_ptr(samsung_usbphy_dt_match),
>> +     },
>> +};
>> +
>> +module_platform_driver(samsung_usbphy_driver);
>> +
>> +MODULE_DESCRIPTION("Samsung USB phy controller");
>
> USB 2.0 Phy?
>

Yes, will amend this.

>> +MODULE_AUTHOR("Praveen Paneri <p.paneri@samsung.com>");
>> +MODULE_LICENSE("GPL");
>> +MODULE_ALIAS("platform:samsung-usbphy");
>
> Is this for samsung-usbphy or samsung-usb2/samsung-usb2phy?
>

Must be changed to samsung-usb2phy.

> [...]
>
> I know why you create separated phy file samsung-usbphy.c and samsung-usb2.c
> here, but I think for that, would be better if you could consider the name
> and so on.
>

Yes, sure will keep the naming convention as suggested.


-- 
Thanks & Regards
Vivek
