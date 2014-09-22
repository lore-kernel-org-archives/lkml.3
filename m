Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753869AbaIVKKG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 06:10:06 -0400
Received: from rtits2.realtek.com ([60.250.210.242]:34880 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751058AbaIVKKE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 06:10:04 -0400
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.49 with qID s8MA9W1H008220, This message is accepted by code: ctloc85258
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
Thread-Index: AQHP04WDQdGgh34FlUGGFNVQtE8cSpwMbesA
Date: Mon, 22 Sep 2014 10:09:32 +0000
Message-ID: <1411380672.24091.18.camel@debian-rtk5880>
References: <1410485999-10939-1-git-send-email-micky_ching@realsil.com.cn>
	 <CAPDyKFqcbK9OuQXbegignwiS7rz3L8resQ7Jfc8WvqXEKTcWVA@mail.gmail.com>
	 <54195036.2010409@realsil.com.cn>
	 <CAPDyKFrbMaDxU3VkhMO63+tLRMipKPqGvYC5cT2PTeVU1CTTQg@mail.gmail.com>
	 <1411024883.27455.11.camel@debian-rtk5880>
	 <CAPDyKFqokjwerEC+6A=2h4cPH29rnX0tyW=2=KQX2rSE=SEKHw@mail.gmail.com>
In-Reply-To: <CAPDyKFqokjwerEC+6A=2h4cPH29rnX0tyW=2=KQX2rSE=SEKHw@mail.gmail.com>
Accept-Language: en-US, zh-TW
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.81.121]
Content-Type: text/plain; charset="utf-8"
Content-ID: <A949DEFED3A09848AE1D9E669F51FE8D@realtek.com>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s8MAABK0027524

On Thu, 2014-09-18 at 23:14 +0200, Ulf Hansson wrote:
> [...]
> 
> >>
> >> In that case, don't forget to enable MMC_CAP2_FULL_PWR_CYCLE.
> >>
> >> >
> >> > if MMC_CAP2_NO_PRESCAN_POWERUP enable, will call mmc_power_off() at start,
> >> > then it will check ios.power_mode, but the state is MMC_POWER_OFF and just
> >> > return.
> >>
> >> Uhh, that's right! So, I wonder why we invokes mmc_power_off() from
> >> that path at all.
> >>
> >> Hmm, I think we should change the behavior in mmc_start_host(), like below:
> >> 1) Add a "MMC_POWER_UNDEFINED" state which is what the power state
> >> should be assigned to at allocation.
> >> 2 ) From mmc_start_host(), invoke mmc_power_off() when
> >> MMC_CAP2_NO_PRESCAN_POWERUP and MMC_CAP2_FULL_PWR_CYCLE is set.
> >>
> >> Would that work?
> > Yes. I have confirmed this by following changes. The MMC_POWER_UNDEFINED
> > designation in mmc_start_host() will eventually cause a power-off
> > operation.
> >
> > But I wonder if we need to additionally check MMC_CAP2_FULL_PWR_CYCLE
> > before calling mmc_power_off()?
> 
> The intent from my side was to keep the current behaviour for those
> that already used MMC_CAP2_NO_PRESCAN_POWERUP, but it's s not a big
> deal.
> 

I checked the log and found the commit that invokes mmc_power_off():
a08b17be8b984a7c51cd5a480cd977363df353f9
0d3e3350d5871c53464be4c92d57198744247005
(https://www.mail-archive.com/linux-mmc@vger.kernel.org/msg19638.html )

The proposed change might bring back some delay since invoking
mmc_power_off() in mmc_start_host() is more than NOP now and triggers
real power-off and re-init in sdhci.

Will this be OK?

> So, let's try your proposal, thus don't check MMC_CAP2_FULL_PWR_CYCLE.
> 
> Can you repost new version of your patches and please split them up on
> core and host separately.
> 
> Kind regards
> Uffe
> 
> ------Please consider the environment before printing this e-mail.

-- 
Best regards,
Roger Tseng
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
