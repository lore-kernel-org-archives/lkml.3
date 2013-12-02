Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753288Ab3LBJmN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 04:42:13 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:51232 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752631Ab3LBJmK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 04:42:10 -0500
Message-ID: <529C55DF.3000808@ti.com>
Date: Mon, 2 Dec 2013 11:41:51 +0200
From: Roger Quadros <rogerq@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Michael Trimarchi <michael@amarulasolutions.com>,
        Felipe Balbi <balbi@ti.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
CC: <lee.jones@linaro.org>, <sameo@linux.intel.com>, <tomi.valkeinen@ti.com>,
        Stefan Roese <sr@denx.de>, <ljkenny.mailinglists@gmail.com>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        USB list <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <stable@vger.kernel.org>
Subject: Re: [PATCH 1/1] mfd: omap-usb-host: Fix USB device detection problems
 on OMAP4 Panda
References: <1385730118-26402-1-git-send-email-rogerq@ti.com>	<1385730118-26402-2-git-send-email-rogerq@ti.com> <CAOf5uwmEkzFd=e3j8m8=qdTCAMkk_-DPw0fTm=7Vzy0PbE2oDQ@mail.gmail.com>
In-Reply-To: <CAOf5uwmEkzFd=e3j8m8=qdTCAMkk_-DPw0fTm=7Vzy0PbE2oDQ@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michael,

On 11/29/2013 05:32 PM, Michael Trimarchi wrote:
> Hi Roger
> 
> On Fri, Nov 29, 2013 at 2:01 PM, Roger Quadros <rogerq@ti.com> wrote:
>> With u-boot 2013.10, USB devices are sometimes not detected
>> on OMAP4 Panda. To make us independent of what bootloader does
>> with the USB Host module, we must RESET it to get it to a known
>> good state. This patch Soft RESETs the USB Host module.
>>
> 
> Do you think that we need something similar of usb musb?
> I have seen the OTG_SYSCONFIG is touched in uboot and
> only readed in omap2430.c.

I'm not sure about musb. Maybe Sebastian/Felipe have better idea.
In general I believe that all modules must be reset by the kernel.

cheers,
-roger
> 
>> Reported-by: Tomi Valkeinen <tomi.valkeinen@ti.com>
>> Cc: <stable@vger.kernel.org> # 3.10+
>> Signed-off-by: Roger Quadros <rogerq@ti.com>
>> ---
>>  drivers/mfd/omap-usb-host.c | 115 +++++++++++++++++++++++++++++++++++++++++---
>>  1 file changed, 109 insertions(+), 6 deletions(-)
>>
>> diff --git a/drivers/mfd/omap-usb-host.c b/drivers/mfd/omap-usb-host.c
>> index 142650f..d4bd464 100644
>> --- a/drivers/mfd/omap-usb-host.c
>> +++ b/drivers/mfd/omap-usb-host.c
>> @@ -43,14 +43,18 @@
>>  /* UHH Register Set */
>>  #define        OMAP_UHH_REVISION                               (0x00)
>>  #define        OMAP_UHH_SYSCONFIG                              (0x10)
>> -#define        OMAP_UHH_SYSCONFIG_MIDLEMODE                    (1 << 12)
>> +#define        OMAP_UHH_SYSCONFIG_MIDLEMASK                    (3 << 12)
>> +#define OMAP_UHH_SYSCONFIG_MIDLESHIFT                  (12)
>>  #define        OMAP_UHH_SYSCONFIG_CACTIVITY                    (1 << 8)
>> -#define        OMAP_UHH_SYSCONFIG_SIDLEMODE                    (1 << 3)
>> +#define        OMAP_UHH_SYSCONFIG_SIDLEMASK                    (3 << 3)
>> +#define        OMAP_UHH_SYSCONFIG_SIDLESHIFT                   (3)
>>  #define        OMAP_UHH_SYSCONFIG_ENAWAKEUP                    (1 << 2)
>>  #define        OMAP_UHH_SYSCONFIG_SOFTRESET                    (1 << 1)
>>  #define        OMAP_UHH_SYSCONFIG_AUTOIDLE                     (1 << 0)
>>
>>  #define        OMAP_UHH_SYSSTATUS                              (0x14)
>> +#define OMAP_UHH_SYSSTATUS_RESETDONE                   (1 << 0)
>> +
>>  #define        OMAP_UHH_HOSTCONFIG                             (0x40)
>>  #define        OMAP_UHH_HOSTCONFIG_ULPI_BYPASS                 (1 << 0)
>>  #define        OMAP_UHH_HOSTCONFIG_ULPI_P1_BYPASS              (1 << 0)
>> @@ -66,10 +70,10 @@
>>  #define OMAP4_UHH_HOSTCONFIG_APP_START_CLK             (1 << 31)
>>
>>  /* OMAP4-specific defines */
>> -#define OMAP4_UHH_SYSCONFIG_IDLEMODE_CLEAR             (3 << 2)
>> -#define OMAP4_UHH_SYSCONFIG_NOIDLE                     (1 << 2)
>> -#define OMAP4_UHH_SYSCONFIG_STDBYMODE_CLEAR            (3 << 4)
>> -#define OMAP4_UHH_SYSCONFIG_NOSTDBY                    (1 << 4)
>> +#define OMAP4_UHH_SYSCONFIG_MIDLEMASK                  (3 << 2)
>> +#define OMAP4_UHH_SYSCONFIG_MIDLESHIFT                 (2)
>> +#define OMAP4_UHH_SYSCONFIG_SIDLEMASK                  (3 << 4)
>> +#define OMAP4_UHH_SYSCONFIG_SIDLESHIFT                 (4)
>>  #define OMAP4_UHH_SYSCONFIG_SOFTRESET                  (1 << 0)
>>
>>  #define OMAP4_P1_MODE_CLEAR                            (3 << 16)
>> @@ -81,6 +85,12 @@
>>
>>  #define        OMAP_UHH_DEBUG_CSR                              (0x44)
>>
>> +/* MIDLE modes */
>> +#define OMAP_UHH_SYSCONFIG_MIDLE_NOSTANDBY             (1)
>> +
>> +/* SIDLE modes */
>> +#define OMAP_UHH_SYSCONFIG_SIDLE_NOIDLE                        (1)
>> +
>>  /* Values of UHH_REVISION - Note: these are not given in the TRM */
>>  #define OMAP_USBHS_REV1                0x00000010      /* OMAP3 */
>>  #define OMAP_USBHS_REV2                0x50700100      /* OMAP4 */
>> @@ -474,6 +484,97 @@ static unsigned omap_usbhs_rev2_hostconfig(struct usbhs_hcd_omap *omap,
>>         return reg;
>>  }
>>
>> +static void omap_usbhs_rev1_reset(struct device *dev)
>> +{
>> +       struct usbhs_hcd_omap *omap = dev_get_drvdata(dev);
>> +       u32 reg;
>> +       unsigned long timeout;
>> +
>> +       reg = usbhs_read(omap->uhh_base, OMAP_UHH_SYSCONFIG);
>> +
>> +       /* Soft Reset */
>> +       usbhs_write(omap->uhh_base, OMAP_UHH_SYSCONFIG,
>> +                   reg | OMAP_UHH_SYSCONFIG_SOFTRESET);
>> +
>> +       timeout = jiffies + msecs_to_jiffies(100);
>> +       while (!(usbhs_read(omap->uhh_base, OMAP_UHH_SYSSTATUS)
>> +                       & OMAP_UHH_SYSSTATUS_RESETDONE)) {
>> +               cpu_relax();
>> +
>> +               if (time_after(jiffies, timeout)) {
>> +                       dev_err(dev, "Soft RESET operation timed out\n");
>> +                       break;
>> +               }
>> +       }
>> +
>> +       /* Set No-Standby */
>> +       reg &= ~OMAP_UHH_SYSCONFIG_MIDLEMASK;
>> +       reg |= OMAP_UHH_SYSCONFIG_MIDLE_NOSTANDBY
>> +               << OMAP_UHH_SYSCONFIG_MIDLESHIFT;
>> +
>> +       /* Set No-Idle */
>> +       reg &= ~OMAP_UHH_SYSCONFIG_SIDLEMASK;
>> +       reg |= OMAP_UHH_SYSCONFIG_SIDLE_NOIDLE
>> +               << OMAP_UHH_SYSCONFIG_SIDLESHIFT;
>> +
>> +       usbhs_write(omap->uhh_base, OMAP_UHH_SYSCONFIG, reg);
>> +}
>> +
>> +static void omap_usbhs_rev2_reset(struct device *dev)
>> +{
>> +       struct usbhs_hcd_omap *omap = dev_get_drvdata(dev);
>> +       u32 reg;
>> +       unsigned long timeout;
>> +
>> +       reg = usbhs_read(omap->uhh_base, OMAP_UHH_SYSCONFIG);
>> +
>> +       /* Soft Reset */
>> +       usbhs_write(omap->uhh_base, OMAP_UHH_SYSCONFIG,
>> +                   reg | OMAP4_UHH_SYSCONFIG_SOFTRESET);
>> +
>> +       /* OMAP4: Need to wait before SYSCONFIG can be accessed */
>> +       udelay(2);
>> +       timeout = jiffies + msecs_to_jiffies(100);
>> +
>> +       /* SOFTRESET bit clears when RESET completes */
>> +       while (usbhs_read(omap->uhh_base, OMAP_UHH_SYSCONFIG)
>> +                       & OMAP4_UHH_SYSCONFIG_SOFTRESET) {
>> +               cpu_relax();
>> +
>> +               if (time_after(jiffies, timeout)) {
>> +                       dev_err(dev, "Soft RESET operation timed out\n");
>> +                       break;
>> +               }
>> +       }
>> +
>> +       /* Set No-Standby */
>> +       reg &= ~OMAP4_UHH_SYSCONFIG_MIDLEMASK;
>> +       reg |= OMAP_UHH_SYSCONFIG_MIDLE_NOSTANDBY
>> +               << OMAP4_UHH_SYSCONFIG_MIDLESHIFT;
>> +
>> +       /* Set No-Idle */
>> +       reg &= ~OMAP4_UHH_SYSCONFIG_SIDLEMASK;
>> +       reg |= OMAP_UHH_SYSCONFIG_SIDLE_NOIDLE
>> +               << OMAP4_UHH_SYSCONFIG_SIDLESHIFT;
>> +
>> +       usbhs_write(omap->uhh_base, OMAP_UHH_SYSCONFIG, reg);
>> +}
>> +
>> +static void omap_usbhs_softreset(struct device *dev)
>> +{
>> +       struct usbhs_hcd_omap *omap = dev_get_drvdata(dev);
>> +
>> +       switch (omap->usbhs_rev) {
>> +       case OMAP_USBHS_REV1:
>> +               omap_usbhs_rev1_reset(dev);
>> +               break;
>> +
>> +       default:        /* Rev 2 onwards */
>> +               omap_usbhs_rev2_reset(dev);
>> +               break;
>> +       }
>> +}
>> +
>>  static void omap_usbhs_init(struct device *dev)
>>  {
>>         struct usbhs_hcd_omap           *omap = dev_get_drvdata(dev);
>> @@ -483,6 +584,8 @@ static void omap_usbhs_init(struct device *dev)
>>
>>         pm_runtime_get_sync(dev);
>>
>> +       omap_usbhs_softreset(dev);
>> +
>>         reg = usbhs_read(omap->uhh_base, OMAP_UHH_HOSTCONFIG);
>>         /* setup ULPI bypass and burst configurations */
>>         reg |= (OMAP_UHH_HOSTCONFIG_INCR4_BURST_EN
>> --
>> 1.8.3.2
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-omap" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-usb" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

