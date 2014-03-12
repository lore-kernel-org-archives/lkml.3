Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754636AbaCLDoc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 23:44:32 -0400
Received: from mga09.intel.com ([134.134.136.24]:27716 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752789AbaCLDoa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 23:44:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,635,1389772800"; 
   d="scan'208";a="470653602"
From: "Dong, Chuanxiao" <chuanxiao.dong@intel.com>
To: "Lu, Aaron" <aaron.lu@intel.com>, Ulf Hansson <ulf.hansson@linaro.org>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        Chris Ball <chris@printf.net>,
        "Liu, Chuansheng" <chuansheng.liu@intel.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        NeilBrown <neilb@suse.de>, "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "Wang, Xiaoming" <xiaoming.wang@intel.com>
Subject: RE: [RFC PATCH] mmc: core: Invoke sdio func driver's PM callbacks
 from the sdio bus
Thread-Topic: [RFC PATCH] mmc: core: Invoke sdio func driver's PM callbacks
 from the sdio bus
Thread-Index: AQHPPZu6cxFmTtb4JkCD2TnJYJX/EZrczljw
Date: Wed, 12 Mar 2014 03:44:26 +0000
Message-ID: <17296D9F8FF2234F831FC3DF505A87A911A096AA@shsmsx102.ccr.corp.intel.com>
References: <1393588140-20605-1-git-send-email-ulf.hansson@linaro.org>
 <531FC803.1030403@intel.com>
In-Reply-To: <531FC803.1030403@intel.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s2C3it7H030140

Hi Aaron,

This patch is tested on Intel platform, and SDIO function driver's suspend/resume callback will only be called once, which fixed this issue. Previously, they can be called twice.

Here is the tested-by:

Tested-by: xiaoming wang <xiaoming.wang@intel.com>
Tested-by: Chuanxiao Dong <chuanxiao.dong@intel.com>

Thanks
Chuanxiao

> -----Original Message-----
> From: Lu, Aaron
> Sent: Wednesday, March 12, 2014 10:36 AM
> To: Ulf Hansson; linux-mmc@vger.kernel.org; Chris Ball; Liu, Chuansheng; Dong,
> Chuanxiao
> Cc: linux-kernel@vger.kernel.org; NeilBrown; Rafael J. Wysocki
> Subject: Re: [RFC PATCH] mmc: core: Invoke sdio func driver's PM callbacks from the
> sdio bus
> 
> Hi Chuansheng & Chuanxiao,
> 
> Can you please help us testing this patch on your platform and let us know the test
> result? Thanks.
> 
> -Aaron
> 
> On 02/28/2014 07:49 PM, Ulf Hansson wrote:
> > The sdio func device is added to the driver model after the card
> > device.
> >
> > This means the sdio func device will be suspend before the card device
> > and thus resumed after. The consequence are the mmc core don't
> > explicity need to protect itself from receiving sdio requests in
> > suspended state. Instead that can be handled from the sdio bus, which
> > is thus invokes the PM callbacks instead of old dummy function.
> >
> > In the case were the sdio func driver don't implement the PM callbacks
> > the mmc core will in the early phase of system suspend, remove the
> > card from the driver model and thus power off it.
> >
> > Cc: Aaron Lu <aaron.lu@intel.com>
> > Cc: NeilBrown <neilb@suse.de>
> > Cc: Rafael J. Wysocki <rjw@rjwysocki.net>
> > Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
> > ---
> >
> > Note, this patch has only been compile tested. Would appreciate if
> > some with SDIO and a sdio func driver could help out to test this.
> > Especially the libertas driver would be nice.
> >
> > ---
> >  drivers/mmc/core/sdio.c     |   45 ++++---------------------------------------
> >  drivers/mmc/core/sdio_bus.c |   14 +-------------
> >  2 files changed, 5 insertions(+), 54 deletions(-)
> >
> > diff --git a/drivers/mmc/core/sdio.c b/drivers/mmc/core/sdio.c index
> > 4d721c6..9933e42 100644
> > --- a/drivers/mmc/core/sdio.c
> > +++ b/drivers/mmc/core/sdio.c
> > @@ -943,40 +943,21 @@ static int mmc_sdio_pre_suspend(struct mmc_host
> *host)
> >   */
> >  static int mmc_sdio_suspend(struct mmc_host *host)  {
> > -	int i, err = 0;
> > -
> > -	for (i = 0; i < host->card->sdio_funcs; i++) {
> > -		struct sdio_func *func = host->card->sdio_func[i];
> > -		if (func && sdio_func_present(func) && func->dev.driver) {
> > -			const struct dev_pm_ops *pmops = func->dev.driver->pm;
> > -			err = pmops->suspend(&func->dev);
> > -			if (err)
> > -				break;
> > -		}
> > -	}
> > -	while (err && --i >= 0) {
> > -		struct sdio_func *func = host->card->sdio_func[i];
> > -		if (func && sdio_func_present(func) && func->dev.driver) {
> > -			const struct dev_pm_ops *pmops = func->dev.driver->pm;
> > -			pmops->resume(&func->dev);
> > -		}
> > -	}
> > -
> > -	if (!err && mmc_card_keep_power(host) && mmc_card_wake_sdio_irq(host))
> {
> > +	if (mmc_card_keep_power(host) && mmc_card_wake_sdio_irq(host)) {
> >  		mmc_claim_host(host);
> >  		sdio_disable_wide(host->card);
> >  		mmc_release_host(host);
> >  	}
> >
> > -	if (!err && !mmc_card_keep_power(host))
> > +	if (!mmc_card_keep_power(host))
> >  		mmc_power_off(host);
> >
> > -	return err;
> > +	return 0;
> >  }
> >
> >  static int mmc_sdio_resume(struct mmc_host *host)  {
> > -	int i, err = 0;
> > +	int err = 0;
> >
> >  	BUG_ON(!host);
> >  	BUG_ON(!host->card);
> > @@ -1019,24 +1000,6 @@ static int mmc_sdio_resume(struct mmc_host *host)
> >  		wake_up_process(host->sdio_irq_thread);
> >  	mmc_release_host(host);
> >
> > -	/*
> > -	 * If the card looked to be the same as before suspending, then
> > -	 * we proceed to resume all card functions.  If one of them returns
> > -	 * an error then we simply return that error to the core and the
> > -	 * card will be redetected as new.  It is the responsibility of
> > -	 * the function driver to perform further tests with the extra
> > -	 * knowledge it has of the card to confirm the card is indeed the
> > -	 * same as before suspending (same MAC address for network cards,
> > -	 * etc.) and return an error otherwise.
> > -	 */
> > -	for (i = 0; !err && i < host->card->sdio_funcs; i++) {
> > -		struct sdio_func *func = host->card->sdio_func[i];
> > -		if (func && sdio_func_present(func) && func->dev.driver) {
> > -			const struct dev_pm_ops *pmops = func->dev.driver->pm;
> > -			err = pmops->resume(&func->dev);
> > -		}
> > -	}
> > -
> >  	host->pm_flags &= ~MMC_PM_KEEP_POWER;
> >  	return err;
> >  }
> > diff --git a/drivers/mmc/core/sdio_bus.c b/drivers/mmc/core/sdio_bus.c
> > index 92d1ba8..4fa8fef9 100644
> > --- a/drivers/mmc/core/sdio_bus.c
> > +++ b/drivers/mmc/core/sdio_bus.c
> > @@ -197,20 +197,8 @@ static int sdio_bus_remove(struct device *dev)
> >
> >  #ifdef CONFIG_PM
> >
> > -#ifdef CONFIG_PM_SLEEP
> > -static int pm_no_operation(struct device *dev) -{
> > -	/*
> > -	 * Prevent the PM core from calling SDIO device drivers' suspend
> > -	 * callback routines, which it is not supposed to do, by using this
> > -	 * empty function as the bus type suspend callaback for SDIO.
> > -	 */
> > -	return 0;
> > -}
> > -#endif
> > -
> >  static const struct dev_pm_ops sdio_bus_pm_ops = {
> > -	SET_SYSTEM_SLEEP_PM_OPS(pm_no_operation, pm_no_operation)
> > +	SET_SYSTEM_SLEEP_PM_OPS(pm_generic_suspend, pm_generic_resume)
> >  	SET_RUNTIME_PM_OPS(
> >  		pm_generic_runtime_suspend,
> >  		pm_generic_runtime_resume,
> >

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
