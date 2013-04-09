Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964901Ab3DIHSW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 03:18:22 -0400
Received: from mail1.bemta7.messagelabs.com ([216.82.254.100]:6897 "EHLO
	mail1.bemta7.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934419Ab3DIHSV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 03:18:21 -0400
X-Env-Sender: Hector.Palacios@digi.com
X-Msg-Ref: server-3.tower-200.messagelabs.com!1365491898!12841046!1
X-Originating-IP: [66.77.174.13]
X-StarScan-Received: 
X-StarScan-Version: 6.8.6.1; banners=-,-,-
X-VirusChecked: Checked
Message-ID: <5163C0B4.60501@digi.com>
Date: Tue, 9 Apr 2013 09:18:12 +0200
From: Hector Palacios <hector.palacios@digi.com>
Organization: Digi International
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Marek Vasut <marex@denx.de>
CC: Shawn Guo <shawn.guo@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "maxime.ripard@free-electrons.com" <maxime.ripard@free-electrons.com>,
        "fabio.estevam@freescale.com" <fabio.estevam@freescale.com>,
        <linux-mmc@vger.kernel.org>
Subject: Re: [PATCH RFC] ARM: dts: mxs: leave card detect out of common mmc
 pins config
References: <1365415940-11609-1-git-send-email-hector.palacios@digi.com> <5162CCED.4070707@digi.com> <20130408145019.GD5044@S2101-09.ap.freescale.net> <201304081828.27127.marex@denx.de>
In-Reply-To: <201304081828.27127.marex@denx.de>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Marek Vasut,

On 04/08/2013 06:28 PM, Marek Vasut wrote:
> Dear Shawn Guo,
>
>> On Mon, Apr 08, 2013 at 03:58:05PM +0200, Hector Palacios wrote:
>>> On 04/08/2013 02:48 PM, Shawn Guo wrote:
>>>> On Mon, Apr 08, 2013 at 12:12:20PM +0200, Hector Palacios wrote:
>>>>> MicroSD card sockets don't usually have card detect line. This pin
>>>>> is actually not needed for the MMC to work and it is more of a
>>>>> platform design decission to have it.
>>>>> The card detect pin already has a configuration entry of its own:
>>>>> 'mmc0_cd_cfg' so we complete the iomux configuration here and let
>>>>> platforms to include it or not depending on whether the card detect
>>>>> line is routed to the SD socket.
>>>>
>>>> Sounds sensible.
>>>>
>>>>> Signed-off-by: Hector Palacios <hector.palacios@digi.com>
>>>>> ---
>>>>>
>>>>> Hello,
>>>>>
>>>>> All imx28 based platforms except 'bluegiga,apx4devkit' and
>>>>> 'schulercontrol,imx28-sps1', use 'mmc0_cd_cfg' in their mmc
>>>>> configuration so please check whether this patch would break these
>>>>> platforms.
>>>>
>>>> I just tested the patch on imx28-evk and card-detection still works.  So
>>>> patches applied, thanks.
>>>
>>> The EVK and most platforms will work because they are using
>>> 'mmc0_cd_cfg' so actually this patch does not change anything on
>>> them.
>>> Platforms 'bluegiga,apx4devkit' and 'schulercontrol,imx28-sps1'
>>> however are not referencing 'mmc0_cd_cfg' so after applying this
>>> patch they will have unconfigured CD line and they may break.
>>
>> Ah, yes.  I thought that any board that has CD support has to reference
>> 'mmc0_cd_cfg'.  That's not necessarily true.
>>
>>> The driver will call get_cd() upon probing, which returns the status of
>>> the CD line. Please check these two platforms before applying.
>>
>> Ok, let's wait for people owning the boards to confirm.
>
> Maybe you want to use MMC_CAP_NEEDS_POLL as was noted by someone before on the
> olinuxino -- the slot is there, it's just the CD line that's missing.

I'm not sure of what you mean. The mxs-mmc.c driver already sets the 
MMC_CAP_NEEDS_POLL flag by default in the probe() function. My platform does not even 
route the CD line because the microSD socket does not have it.
So what I have done is modify the driver to parse the property 'non-removable' from 
the device tree in order to set the MMC_CAP_NONREMOVABLE flag:

diff --git a/drivers/mmc/host/mxs-mmc.c b/drivers/mmc/host/mxs-mmc.c
index 206fe49..2a3b9c9 100644
--- a/drivers/mmc/host/mxs-mmc.c
+++ b/drivers/mmc/host/mxs-mmc.c
@@ -679,15 +682,20 @@ static int mxs_mmc_probe(struct platform_device *pdev)
         /* set mmc core parameters */
         mmc->ops = &mxs_mmc_ops;
         mmc->caps = MMC_CAP_SD_HIGHSPEED | MMC_CAP_MMC_HIGHSPEED |
-                   MMC_CAP_SDIO_IRQ | MMC_CAP_NEEDS_POLL;
+                   MMC_CAP_SDIO_IRQ;

         of_property_read_u32(np, "bus-width", &bus_width);
         if (bus_width == 4)
                 mmc->caps |= MMC_CAP_4_BIT_DATA;
         else if (bus_width == 8)
                 mmc->caps |= MMC_CAP_4_BIT_DATA | MMC_CAP_8_BIT_DATA;
-       host->wp_gpio = of_get_named_gpio_flags(np, "wp-gpios", 0, &flags);

+       if (of_find_property(np, "non-removable", NULL))
+               mmc->caps |= MMC_CAP_NONREMOVABLE;
+       else
+               mmc->caps |= MMC_CAP_NEEDS_POLL;
+
+       host->wp_gpio = of_get_named_gpio_flags(np, "wp-gpios", 0, &flags);
         if (flags & OF_GPIO_ACTIVE_LOW)
                 host->wp_inverted = 1;


In theory, and according to the mmc bindings doc, this flag must assume the card is 
always present. However the MMC core function mmc_rescan() will still call at least 
once the get_cd() hook, which in the mxs-mmc.c returns the value of the CD line. In my 
platform (where the CD line is not connected) this is returning 0, so I needed to do 
the following:

diff --git a/drivers/mmc/host/mxs-mmc.c b/drivers/mmc/host/mxs-mmc.c
index 206fe49..2a3b9c9 100644
--- a/drivers/mmc/host/mxs-mmc.c
+++ b/drivers/mmc/host/mxs-mmc.c
@@ -95,6 +95,9 @@ static int mxs_mmc_get_cd(struct mmc_host *mmc)
         struct mxs_mmc_host *host = mmc_priv(mmc);
         struct mxs_ssp *ssp = &host->ssp;

+       if (mmc->caps & MMC_CAP_NONREMOVABLE)
+               return 1;
+
         return !(readl(ssp->base + HW_SSP_STATUS(ssp)) &
                  BM_SSP_STATUS_CARD_DETECT);
  }

to return a 1 when the driver should assume that the card is there. I wonder however 
if this should be a global mmc patch instead, and have mmc_rescan() not call the host 
get_cd() hook at all if MMC_CAP_NONREMOVABLE is set.

Regards,
-- 
Héctor Palacios
