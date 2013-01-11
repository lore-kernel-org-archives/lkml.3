Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755643Ab3AKNsH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2013 08:48:07 -0500
Received: from mail-bk0-f54.google.com ([209.85.214.54]:64358 "EHLO
	mail-bk0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755387Ab3AKNsF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2013 08:48:05 -0500
MIME-Version: 1.0
In-Reply-To: <20130111125841.GB12715@arwen.pp.htv.fi>
References: <1355841786-13307-1-git-send-email-gautam.vivek@samsung.com>
	<1355841786-13307-3-git-send-email-gautam.vivek@samsung.com>
	<CAD=FV=WMjqszsTQja82_uZc4Ue50TfTmSNO2yOhSMCX1w1L5Dg@mail.gmail.com>
	<CAFp+6iHYRRS3uSWnmdqBvfOgUDKKJUzMvqoj1HP2uXS=Fdaifg@mail.gmail.com>
	<20130111125841.GB12715@arwen.pp.htv.fi>
Date: Fri, 11 Jan 2013 19:18:02 +0530
Message-ID: <CAFp+6iHfqFqmoMjmdbbD=DwNtRUPCfPfb5rFAdbTLv65cb7eCw@mail.gmail.com>
Subject: Re: [PATCH v5 2/4] usb: phy: samsung: Add host phy support to
 samsung-phy driver
From: Vivek Gautam <gautamvivek1987@gmail.com>
To: balbi@ti.com
Cc: Doug Anderson <dianders@chromium.org>,
        Vivek Gautam <gautam.vivek@samsung.com>, linux-usb@vger.kernel.org,
        yulgon.kim@samsung.com, linux-samsung-soc@vger.kernel.org,
        Praveen Paneri <p.paneri@samsung.com>, gregkh@linuxfoundation.org,
        devicetree-discuss@lists.ozlabs.org, jg1.han@samsung.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        kishon@ti.com, Kukjin Kim <kgene.kim@samsung.com>,
        stern@rowland.harvard.edu, rob.herring@calxeda.com,
        sylvester.nawrocki@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Felipe,


On Fri, Jan 11, 2013 at 6:28 PM, Felipe Balbi <balbi@ti.com> wrote:
> Hi,
>
> On Fri, Jan 11, 2013 at 06:10:48PM +0530, Vivek Gautam wrote:
>> Hi Doug,
>>
>> Sorry!!  for the delayed response.
>>
>>
>> On Thu, Dec 20, 2012 at 4:31 AM, Doug Anderson <dianders@chromium.org> wrote:
>> > Vivek,
>> >
>> > I don't really have a good 10000 foot view about how all of the USB
>> > bits fit together, but a few detail-oriented comments below.
>> >
>> >
>> > On Tue, Dec 18, 2012 at 6:43 AM, Vivek Gautam <gautam.vivek@samsung.com> wrote:
>> >> This patch adds host phy support to samsung-usbphy.c and
>> >> further adds support for samsung's exynos5250 usb-phy.
>> >>
>> >> Signed-off-by: Praveen Paneri <p.paneri@samsung.com>
>> >> Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
>> >> ---
>> >>  .../devicetree/bindings/usb/samsung-usbphy.txt     |   25 +-
>> >>  drivers/usb/phy/Kconfig                            |    2 +-
>> >>  drivers/usb/phy/samsung-usbphy.c                   |  465 ++++++++++++++++++--
>> >>  include/linux/usb/samsung_usb_phy.h                |   13 +
>> >>  4 files changed, 454 insertions(+), 51 deletions(-)
>> >>
>> >> diff --git a/Documentation/devicetree/bindings/usb/samsung-usbphy.txt b/Documentation/devicetree/bindings/usb/samsung-usbphy.txt
>> >> index a7b28b2..2ec5400 100644
>> >> --- a/Documentation/devicetree/bindings/usb/samsung-usbphy.txt
>> >> +++ b/Documentation/devicetree/bindings/usb/samsung-usbphy.txt
>> >> @@ -1,23 +1,38 @@
>> >>  * Samsung's usb phy transceiver
>> >>
>> >> -The Samsung's phy transceiver is used for controlling usb otg phy for
>> >> -s3c-hsotg usb device controller.
>> >> +The Samsung's phy transceiver is used for controlling usb phy for
>> >> +s3c-hsotg as well as ehci-s5p and ohci-exynos usb controllers
>> >> +across Samsung SOCs.
>> >>  TODO: Adding the PHY binding with controller(s) according to the under
>> >>  developement generic PHY driver.
>> >>
>> >>  Required properties:
>> >> +
>> >> +Exynos4210:
>> >>  - compatible : should be "samsung,exynos4210-usbphy"
>> >>  - reg : base physical address of the phy registers and length of memory mapped
>> >>         region.
>> >>
>> >> +Exynos5250:
>> >> +- compatible : should be "samsung,exynos5250-usbphy"
>> >> +- reg : base physical address of the phy registers and length of memory mapped
>> >> +       region.
>> >> +
>> >>  Optional properties:
>> >>  - samsung,usb-phyhandle : should point to usb-phyhandle sub-node which provides
>> >>                         binding data to enable/disable device PHY handled by
>> >> -                       PMU register.
>> >> +                       PMU register; or to configure usb2.0 phy handled by
>> >> +                       SYSREG.
>> >>
>> >>                         Required properties:
>> >>                         - compatible : should be "samsung,usbdev-phyctrl" for
>> >> -                                       DEVICE type phy.
>> >> +                                      DEVICE type phy; or
>> >> +                                      should be "samsung,usbhost-phyctrl" for
>> >> +                                      HOST type phy; or
>> >> +                                      should be "samsung,usb-phycfg" for
>> >> +                                      USB2.0 PHY_CFG.
>> >>                         - samsung,phyhandle-reg: base physical address of
>> >> -                                               PHY_CONTROL register in PMU.
>> >> +                                                PHY_CONTROL register in PMU;
>> >> +                                                or USB2.0 PHY_CFG register
>> >> +                                                in SYSREG.
>> >>  - samsung,enable-mask : should be '1'
>> >> diff --git a/drivers/usb/phy/Kconfig b/drivers/usb/phy/Kconfig
>> >> index 17ad743..13c0eaf 100644
>> >> --- a/drivers/usb/phy/Kconfig
>> >> +++ b/drivers/usb/phy/Kconfig
>> >> @@ -47,7 +47,7 @@ config USB_RCAR_PHY
>> >>
>> >>  config SAMSUNG_USBPHY
>> >>         bool "Samsung USB PHY controller Driver"
>> >> -       depends on USB_S3C_HSOTG
>> >> +       depends on USB_S3C_HSOTG || USB_EHCI_S5P || USB_OHCI_EXYNOS
>> >>         select USB_OTG_UTILS
>> >>         help
>> >>           Enable this to support Samsung USB phy controller for samsung
>> >> diff --git a/drivers/usb/phy/samsung-usbphy.c b/drivers/usb/phy/samsung-usbphy.c
>> >> index 4ceabe3..621348a 100644
>> >> --- a/drivers/usb/phy/samsung-usbphy.c
>> >> +++ b/drivers/usb/phy/samsung-usbphy.c
>> >> @@ -5,7 +5,8 @@
>> >>   *
>> >>   * Author: Praveen Paneri <p.paneri@samsung.com>
>> >>   *
>> >> - * Samsung USB2.0 High-speed OTG transceiver, talks to S3C HS OTG controller
>> >> + * Samsung USB-PHY transceiver; talks to S3C HS OTG controller, EHCI-S5P and
>> >> + * OHCI-EXYNOS controllers.
>> >>   *
>> >>   * This program is free software; you can redistribute it and/or modify
>> >>   * it under the terms of the GNU General Public License version 2 as
>> >> @@ -24,7 +25,7 @@
>> >>  #include <linux/err.h>
>> >>  #include <linux/io.h>
>> >>  #include <linux/of.h>
>> >> -#include <linux/usb/otg.h>
>> >> +#include <linux/usb/samsung_usb_phy.h>
>> >>  #include <linux/platform_data/samsung-usbphy.h>
>> >>
>> >>  /* Register definitions */
>> >> @@ -56,6 +57,103 @@
>> >>  #define RSTCON_HLINK_SWRST                     (0x1 << 1)
>> >>  #define RSTCON_SWRST                           (0x1 << 0)
>> >>
>> >> +/* EXYNOS5 */
>> >> +#define EXYNOS5_PHY_HOST_CTRL0                 (0x00)
>> >> +
>> >> +#define HOST_CTRL0_PHYSWRSTALL                 (0x1 << 31)
>> >> +
>> >> +#define HOST_CTRL0_REFCLKSEL_MASK              (0x3)
>> >> +#define HOST_CTRL0_REFCLKSEL_XTAL              (0x0 << 19)
>> >> +#define HOST_CTRL0_REFCLKSEL_EXTL              (0x1 << 19)
>> >> +#define HOST_CTRL0_REFCLKSEL_CLKCORE           (0x2 << 19)
>> >> +
>> >> +#define HOST_CTRL0_FSEL_MASK                   (0x7 << 16)
>> >> +#define HOST_CTRL0_FSEL(_x)                    ((_x) << 16)
>> >> +#define HOST_CTRL0_FSEL_CLKSEL_50M             (0x7)
>> >> +#define HOST_CTRL0_FSEL_CLKSEL_24M             (0x5)
>> >> +#define HOST_CTRL0_FSEL_CLKSEL_20M             (0x4)
>> >> +#define HOST_CTRL0_FSEL_CLKSEL_19200K          (0x3)
>> >> +#define HOST_CTRL0_FSEL_CLKSEL_12M             (0x2)
>> >> +#define HOST_CTRL0_FSEL_CLKSEL_10M             (0x1)
>> >> +#define HOST_CTRL0_FSEL_CLKSEL_9600K           (0x0)
>> >
>> > Add the shifts to the #defines and remove HOST_CTRL0_FSEL(_x).  That
>> > makes it match the older phy more closely.
>> >
>> Wouldn't it hamper the readability when shifts are used ??
>> I mean if we have something like this -
>>
>> phyhost |= HOST_CTRL0_FSEL(phyclk)
>
> this one looks better to my eyes.
>

Ok, better we keep this.

>> >> +                       refclk_freq |= HOST_CTRL0_FSEL_CLKSEL_9600K;
>> >
>> > Why |= with 0?
>> >
>> kept this just to keep things look similar :-). will remove this line,
>
> I would rather keep it. Compiler will optimize it out anyway and it
> makes things logical, I mean, we can see that you're telling IP that
> reference clock is 9600KHz.
>

ditto !


-- 
Thanks & Regards
Vivek
