Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756263AbaIRHWL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 03:22:11 -0400
Received: from rtits2.realtek.com ([60.250.210.242]:51690 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751217AbaIRHWJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 03:22:09 -0400
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.49 with qID s8I7Jofv031931, This message is accepted by code: ctloc85258
From: Roger Tseng <rogerable@realtek.com>
To: Ulf Hansson <ulf.hansson@linaro.org>
CC: micky <micky_ching@realsil.com.cn>, Chris Ball <chris@printf.net>,
        "Samuel Ortiz" <sameo@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        "driverdev-devel@linuxdriverproject.org" 
	<devel@linuxdriverproject.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-mmc <linux-mmc@vger.kernel.org>,
        Wei_wang <wei_wang@realsil.com.cn>
Subject: Re: [PATCH] mmc: rtsx: add card power off during probe
Thread-Topic: [PATCH] mmc: rtsx: add card power off during probe
Thread-Index: AQHPzip4QdGgh34FlUGGFNVQtE8cSpwDjfuAgAD+QQCAAKyXgIAAxwiA
Date: Thu, 18 Sep 2014 07:19:47 +0000
Message-ID: <1411024883.27455.11.camel@debian-rtk5880>
References: <1410485999-10939-1-git-send-email-micky_ching@realsil.com.cn>
	 <CAPDyKFqcbK9OuQXbegignwiS7rz3L8resQ7Jfc8WvqXEKTcWVA@mail.gmail.com>
	 <54195036.2010409@realsil.com.cn>
	 <CAPDyKFrbMaDxU3VkhMO63+tLRMipKPqGvYC5cT2PTeVU1CTTQg@mail.gmail.com>
In-Reply-To: <CAPDyKFrbMaDxU3VkhMO63+tLRMipKPqGvYC5cT2PTeVU1CTTQg@mail.gmail.com>
Accept-Language: en-US, zh-TW
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.0.1.1]
Content-Type: text/plain; charset="utf-8"
Content-ID: <95890B71182D7543B66998E6F2AB86B3@realtek.com>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s8I7MIxs007930

On Wed, 2014-09-17 at 21:29 +0200, Ulf Hansson wrote:
> On 17 September 2014 11:11, micky <micky_ching@realsil.com.cn> wrote:
> > On 09/17/2014 02:01 AM, Ulf Hansson wrote:
> >>
> >> On 12 September 2014 03:39,  <micky_ching@realsil.com.cn> wrote:
> >>>
> >>> From: Roger Tseng <rogerable@realtek.com>
> >>>
> >>> Some platform have both UEFI driver and MFD/mmc driver, if entering
> >>> linux while card in the slot, the card power is already on, and rtsx-mmc
> >>> driver have no chance to make card power off. This will lead UHSI card
> >>> failed to enter UHSI mode.
> >>>
> >>> It is hard to control the UEFI driver leaving state, so we power off the
> >>> card power during probe.
> >>>
> >>> Signed-off-by: Roger Tseng <rogerable@realtek.com>
> >>> Signed-off-by: Micky Ching <micky_ching@realsil.com.cn>
> >>> ---
> >>>   drivers/mmc/host/rtsx_pci_sdmmc.c |    7 ++++++-
> >>>   1 file changed, 6 insertions(+), 1 deletion(-)
> >>>
> >>> diff --git a/drivers/mmc/host/rtsx_pci_sdmmc.c
> >>> b/drivers/mmc/host/rtsx_pci_sdmmc.c
> >>> index dfde4a2..57b0796 100644
> >>> --- a/drivers/mmc/host/rtsx_pci_sdmmc.c
> >>> +++ b/drivers/mmc/host/rtsx_pci_sdmmc.c
> >>> @@ -1341,8 +1341,13 @@ static int rtsx_pci_sdmmc_drv_probe(struct
> >>> platform_device *pdev)
> >>>          host->pcr = pcr;
> >>>          host->mmc = mmc;
> >>>          host->pdev = pdev;
> >>> -       host->power_state = SDMMC_POWER_OFF;
> >>>          INIT_WORK(&host->work, sd_request);
> >>> +       sd_power_off(host);
> >>> +       /*
> >>> +        * ref: SD spec 3.01: 6.4.1.2 Power On or Power Cycle
> >>> +        */
> >>> +       usleep_range(1000, 2000);
> >>> +
> >>
> >> This won't work in cases were you power off eMMC cards, unless you can
> >> do a full power cycle - cut both VCC and VCCQ. Can you?
> >
> > Hi Uffe,
> >
> > VCCQ will poweroff at the same time.
> 
> In that case, don't forget to enable MMC_CAP2_FULL_PWR_CYCLE.
> 
> >
> > if MMC_CAP2_NO_PRESCAN_POWERUP enable, will call mmc_power_off() at start,
> > then it will check ios.power_mode, but the state is MMC_POWER_OFF and just
> > return.
> 
> Uhh, that's right! So, I wonder why we invokes mmc_power_off() from
> that path at all.
> 
> Hmm, I think we should change the behavior in mmc_start_host(), like below:
> 1) Add a "MMC_POWER_UNDEFINED" state which is what the power state
> should be assigned to at allocation.
> 2 ) From mmc_start_host(), invoke mmc_power_off() when
> MMC_CAP2_NO_PRESCAN_POWERUP and MMC_CAP2_FULL_PWR_CYCLE is set.
> 
> Would that work?
Yes. I have confirmed this by following changes. The MMC_POWER_UNDEFINED
designation in mmc_start_host() will eventually cause a power-off
operation.

But I wonder if we need to additionally check MMC_CAP2_FULL_PWR_CYCLE
before calling mmc_power_off()?

diff --git a/drivers/mmc/core/core.c b/drivers/mmc/core/core.c
index d03a080fb9cd..3457b0f74b71 100644
--- a/drivers/mmc/core/core.c
+++ b/drivers/mmc/core/core.c
@@ -2489,7 +2489,9 @@ void mmc_start_host(struct mmc_host *host)
 {
        host->f_init = max(freqs[0], host->f_min);
        host->rescan_disable = 0;
-       if (host->caps2 & MMC_CAP2_NO_PRESCAN_POWERUP)
+       host->ios.power_mode = MMC_POWER_UNDEFINED;
+       if (host->caps2 & (MMC_CAP2_NO_PRESCAN_POWERUP |
+           MMC_CAP2_FULL_PWR_CYCLE))
                mmc_power_off(host);
        else
                mmc_power_up(host, host->ocr_avail);
diff --git a/drivers/mmc/host/rtsx_pci_sdmmc.c
b/drivers/mmc/host/rtsx_pci_sdmmc.c
index dfde4a210238..d49460b5ff07 100644
--- a/drivers/mmc/host/rtsx_pci_sdmmc.c
+++ b/drivers/mmc/host/rtsx_pci_sdmmc.c
@@ -1292,6 +1292,7 @@ static void realtek_init_host(struct
realtek_pci_sdmmc *host)
        mmc->caps = MMC_CAP_4_BIT_DATA | MMC_CAP_SD_HIGHSPEED |
                MMC_CAP_MMC_HIGHSPEED | MMC_CAP_BUS_WIDTH_TEST |
                MMC_CAP_UHS_SDR12 | MMC_CAP_UHS_SDR25;
+       mmc->caps2 = MMC_CAP2_NO_PRESCAN_POWERUP |
MMC_CAP2_FULL_PWR_CYCLE;
        mmc->max_current_330 = 400;
        mmc->max_current_180 = 800;
        mmc->ops = &realtek_pci_sdmmc_ops;
diff --git a/include/linux/mmc/host.h b/include/linux/mmc/host.h
index 7960424d0bc0..b3bfa609816a 100644
--- a/include/linux/mmc/host.h
+++ b/include/linux/mmc/host.h
@@ -42,6 +42,7 @@ struct mmc_ios {
 #define MMC_POWER_OFF          0
 #define MMC_POWER_UP           1
 #define MMC_POWER_ON           2
+#define MMC_POWER_UNDEFINED    3
 
        unsigned char   bus_width;              /* data bus width */

> Kind regards
> Uffe
> 
> > Best Regards.
> > micky.
> >
> >> There are also another option you might want to use,
> >> MMC_CAP2_NO_PRESCAN_POWERUP. But again, it must only be used for those
> >> hosts that you are able to do a full power cycle for.
> >>
> >> Kind regards
> >> Uffe
> >>
> >>>          platform_set_drvdata(pdev, host);
> >>>          pcr->slots[RTSX_SD_CARD].p_dev = pdev;
> >>>          pcr->slots[RTSX_SD_CARD].card_event = rtsx_pci_sdmmc_card_event;
> >>> --
> >>> 1.7.9.5
> >>>
> >> .
> >>
> >
> 
> ------Please consider the environment before printing this e-mail.

-- 
Best regards,
Roger Tseng
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
