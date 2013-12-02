Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753296Ab3LBJvO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 04:51:14 -0500
Received: from mail-we0-f181.google.com ([74.125.82.181]:35762 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753262Ab3LBJvK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 04:51:10 -0500
MIME-Version: 1.0
In-Reply-To: <529C5537.3080300@ti.com>
References: <1385730118-26402-1-git-send-email-rogerq@ti.com>
	<1385730118-26402-2-git-send-email-rogerq@ti.com>
	<CAOf5uwnttvOQ26USuDK1naq1nNtVbHo4c0UAfdep64bK2wyvBA@mail.gmail.com>
	<529C5537.3080300@ti.com>
Date: Mon, 2 Dec 2013 10:51:08 +0100
Message-ID: <CAOf5uwmpiOv_GED23hWDArcOvs6DpHNEy=OJ9vnKem1pg8jSgw@mail.gmail.com>
Subject: Re: [PATCH 1/1] mfd: omap-usb-host: Fix USB device detection problems
 on OMAP4 Panda
From: Michael Trimarchi <michael@amarulasolutions.com>
To: Roger Quadros <rogerq@ti.com>
Cc: Lee Jones <lee.jones@linaro.org>, sameo@linux.intel.com,
        tomi.valkeinen@ti.com, Felipe Balbi <balbi@ti.com>,
        Stefan Roese <sr@denx.de>, ljkenny.mailinglists@gmail.com,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        USB list <linux-usb@vger.kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Benoit Cousson <bcousson@baylibre.com>,
        "tony@atomide.com" <tony@atomide.com>, Paul Walmsley <paul@pwsan.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Roger

On Mon, Dec 2, 2013 at 10:39 AM, Roger Quadros <rogerq@ti.com> wrote:
> +Benoit, Tony, Paul.
>
> Hi Michael,
>
> On 11/30/2013 06:48 AM, Michael Trimarchi wrote:
>> Hi Roger
>>
>> On Fri, Nov 29, 2013 at 2:01 PM, Roger Quadros <rogerq@ti.com> wrote:
>>> With u-boot 2013.10, USB devices are sometimes not detected
>>> on OMAP4 Panda. To make us independent of what bootloader does
>>> with the USB Host module, we must RESET it to get it to a known
>>> good state. This patch Soft RESETs the USB Host module.
>>>
>>> Reported-by: Tomi Valkeinen <tomi.valkeinen@ti.com>
>>> Cc: <stable@vger.kernel.org> # 3.10+
>>> Signed-off-by: Roger Quadros <rogerq@ti.com>
>>> ---
>>>  drivers/mfd/omap-usb-host.c | 115 +++++++++++++++++++++++++++++++++++++++++---
>>>  1 file changed, 109 insertions(+), 6 deletions(-)
>>>
>>> diff --git a/drivers/mfd/omap-usb-host.c b/drivers/mfd/omap-usb-host.c
>>> index 142650f..d4bd464 100644
>>> --- a/drivers/mfd/omap-usb-host.c
>>> +++ b/drivers/mfd/omap-usb-host.c
>>> @@ -43,14 +43,18 @@
>>>  /* UHH Register Set */
>>>  #define        OMAP_UHH_REVISION                               (0x00)
>>>  #define        OMAP_UHH_SYSCONFIG                              (0x10)
>>> -#define        OMAP_UHH_SYSCONFIG_MIDLEMODE                    (1 << 12)
>>> +#define        OMAP_UHH_SYSCONFIG_MIDLEMASK                    (3 << 12)
>>> +#define OMAP_UHH_SYSCONFIG_MIDLESHIFT                  (12)
>>>  #define        OMAP_UHH_SYSCONFIG_CACTIVITY                    (1 << 8)
>>> -#define        OMAP_UHH_SYSCONFIG_SIDLEMODE                    (1 << 3)
>>> +#define        OMAP_UHH_SYSCONFIG_SIDLEMASK                    (3 << 3)
>>> +#define        OMAP_UHH_SYSCONFIG_SIDLESHIFT                   (3)
>>>  #define        OMAP_UHH_SYSCONFIG_ENAWAKEUP                    (1 << 2)
>>>  #define        OMAP_UHH_SYSCONFIG_SOFTRESET                    (1 << 1)
>>>  #define        OMAP_UHH_SYSCONFIG_AUTOIDLE                     (1 << 0)
>>>
>>>  #define        OMAP_UHH_SYSSTATUS                              (0x14)
>>> +#define OMAP_UHH_SYSSTATUS_RESETDONE                   (1 << 0)
>>> +
>>>  #define        OMAP_UHH_HOSTCONFIG                             (0x40)
>>>  #define        OMAP_UHH_HOSTCONFIG_ULPI_BYPASS                 (1 << 0)
>>>  #define        OMAP_UHH_HOSTCONFIG_ULPI_P1_BYPASS              (1 << 0)
>>> @@ -66,10 +70,10 @@
>>>  #define OMAP4_UHH_HOSTCONFIG_APP_START_CLK             (1 << 31)
>>>
>>>  /* OMAP4-specific defines */
>>> -#define OMAP4_UHH_SYSCONFIG_IDLEMODE_CLEAR             (3 << 2)
>>> -#define OMAP4_UHH_SYSCONFIG_NOIDLE                     (1 << 2)
>>> -#define OMAP4_UHH_SYSCONFIG_STDBYMODE_CLEAR            (3 << 4)
>>> -#define OMAP4_UHH_SYSCONFIG_NOSTDBY                    (1 << 4)
>>> +#define OMAP4_UHH_SYSCONFIG_MIDLEMASK                  (3 << 2)
>>> +#define OMAP4_UHH_SYSCONFIG_MIDLESHIFT                 (2)
>>> +#define OMAP4_UHH_SYSCONFIG_SIDLEMASK                  (3 << 4)
>>> +#define OMAP4_UHH_SYSCONFIG_SIDLESHIFT                 (4)
>>>  #define OMAP4_UHH_SYSCONFIG_SOFTRESET                  (1 << 0)
>>>
>>>  #define OMAP4_P1_MODE_CLEAR                            (3 << 16)
>>> @@ -81,6 +85,12 @@
>>>
>>>  #define        OMAP_UHH_DEBUG_CSR                              (0x44)
>>>
>>> +/* MIDLE modes */
>>> +#define OMAP_UHH_SYSCONFIG_MIDLE_NOSTANDBY             (1)
>>> +
>>> +/* SIDLE modes */
>>> +#define OMAP_UHH_SYSCONFIG_SIDLE_NOIDLE                        (1)
>>> +
>>>  /* Values of UHH_REVISION - Note: these are not given in the TRM */
>>>  #define OMAP_USBHS_REV1                0x00000010      /* OMAP3 */
>>>  #define OMAP_USBHS_REV2                0x50700100      /* OMAP4 */
>>> @@ -474,6 +484,97 @@ static unsigned omap_usbhs_rev2_hostconfig(struct usbhs_hcd_omap *omap,
>>>         return reg;
>>>  }
>>>
>>
>> I'm digging in the code but as I understand this should be done by
>> omap_hwmod and
>> i660 avoid reset of the ehci module. This is done by ocp_softreset?
>>
>
> It won't be done by omap_hwmod as we set HWMOD_INIT_NO_RESET flag in the hwmod data [1].
>
> Question is do we do it in the driver of leave it to hwmod?
>
> The other concern about i660 is in this comment [1]
>

I don't find any description of this errata for omap4. Is this errata valid?

My change was to remove the NO_INIT and add 2uS as you have done

>         /*
>          * During system oot; If the hwmod framework resets the module
>          * the module will have smart idle settings; which can lead to deadlock
>          * (above Errata Id:i660); so, dont reset the module during boot;
>          * Use HWMOD_INIT_NO_RESET.
>          */
>
> But if you look at the errata document [2], Advisory 1.108, it doesn't say that we can't be in smart-idle, but
> only that we should put the module in force-idle, before cutting the module's functional clock. It also states
> that the only way to recover from a lockup condition is to soft reset the module. So I'm not sure if the above comment
> in the code is really valid. What if the lockup happens in the bootloader? In that case we will have to reset the module in
> the kernel.

Michael

>
> Doing the reset in probe does solve a problem for now i.e. eliminates dependency on bootloader.
>
> [1] - http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/tree/arch/arm/mach-omap2/omap_hwmod_3xxx_data.c#n2024
> [2] - http://www.ti.com/litv/pdf/sprz318e
>
>>
>>> +static void omap_usbhs_rev1_reset(struct device *dev)
>>> +{
>>> +       struct usbhs_hcd_omap *omap = dev_get_drvdata(dev);
>>> +       u32 reg;
>>> +       unsigned long timeout;
>>> +
>>> +       reg = usbhs_read(omap->uhh_base, OMAP_UHH_SYSCONFIG);
>>> +
>>> +       /* Soft Reset */
>>> +       usbhs_write(omap->uhh_base, OMAP_UHH_SYSCONFIG,
>>> +                   reg | OMAP_UHH_SYSCONFIG_SOFTRESET);
>>> +
>>> +       timeout = jiffies + msecs_to_jiffies(100);
>>> +       while (!(usbhs_read(omap->uhh_base, OMAP_UHH_SYSSTATUS)
>>> +                       & OMAP_UHH_SYSSTATUS_RESETDONE)) {
>>> +               cpu_relax();
>>> +
>>> +               if (time_after(jiffies, timeout)) {
>>> +                       dev_err(dev, "Soft RESET operation timed out\n");
>>> +                       break;
>>> +               }
>>> +       }
>>> +
>>> +       /* Set No-Standby */
>>> +       reg &= ~OMAP_UHH_SYSCONFIG_MIDLEMASK;
>>> +       reg |= OMAP_UHH_SYSCONFIG_MIDLE_NOSTANDBY
>>> +               << OMAP_UHH_SYSCONFIG_MIDLESHIFT;
>>> +
>>> +       /* Set No-Idle */
>>> +       reg &= ~OMAP_UHH_SYSCONFIG_SIDLEMASK;
>>> +       reg |= OMAP_UHH_SYSCONFIG_SIDLE_NOIDLE
>>> +               << OMAP_UHH_SYSCONFIG_SIDLESHIFT;
>>> +
>>> +       usbhs_write(omap->uhh_base, OMAP_UHH_SYSCONFIG, reg);
>>> +}
>>> +
>>> +static void omap_usbhs_rev2_reset(struct device *dev)
>>> +{
>>> +       struct usbhs_hcd_omap *omap = dev_get_drvdata(dev);
>>> +       u32 reg;
>>> +       unsigned long timeout;
>>> +
>>> +       reg = usbhs_read(omap->uhh_base, OMAP_UHH_SYSCONFIG);
>>> +
>>> +       /* Soft Reset */
>>> +       usbhs_write(omap->uhh_base, OMAP_UHH_SYSCONFIG,
>>> +                   reg | OMAP4_UHH_SYSCONFIG_SOFTRESET);
>>> +
>>> +       /* OMAP4: Need to wait before SYSCONFIG can be accessed */
>>> +       udelay(2);
>>
>> is this the srst_udelay?
>
> It was supposed to be, but it doesn't seem to be necessary for the UHH module. So I'll get rid of that.
>

Ok

> cheers,
> -roger
>

Michael
