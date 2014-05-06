Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754010AbaEFTHB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 15:07:01 -0400
Received: from mail-bn1blp0188.outbound.protection.outlook.com ([207.46.163.188]:8003
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751930AbaEFTHA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 15:07:00 -0400
From: Bryan Evenson <bevenson@melinkcorp.com>
To: Boris BREZILLON <boris.brezillon@free-electrons.com>
CC: Andrew Victor <linux@maxim.org.za>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Alessandro Zummo <a.zummo@towertech.it>,
        "rtc-linux@googlegroups.com" <rtc-linux@googlegroups.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] rtc: rtc-at91rm9200: fix infinite wait for ACKUPD irq
Thread-Topic: [PATCH] rtc: rtc-at91rm9200: fix infinite wait for ACKUPD irq
Thread-Index: AQHPaTdn2DsGCuuDv0qEn/+YwaYxfZsz511A
Date: Tue, 6 May 2014 19:06:56 +0000
Message-ID: <aed75d16aa46476eb6f6c5b0d4bef30d@BLUPR05MB037.namprd05.prod.outlook.com>
References: <94c06375c1b44c8eb5233b0ccf2e4b13@BY2PR05MB048.namprd05.prod.outlook.com>
 <1399386481-18643-1-git-send-email-boris.brezillon@free-electrons.com>
In-Reply-To: <1399386481-18643-1-git-send-email-boris.brezillon@free-electrons.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-vipre-scanned: 019FF9D1007100019FFB1E
x-originating-ip: [98.100.91.242]
x-forefront-prvs: 0203C93D51
x-forefront-antispam-report: SFV:NSPM;SFS:(10009001)(6009001)(428001)(199002)(189002)(377454003)(51704005)(13464003)(101416001)(76576001)(81542001)(87936001)(85852003)(21056001)(99396002)(81342001)(33646001)(99286001)(4396001)(2656002)(83072002)(76482001)(19580395003)(83322001)(46102001)(77982001)(76176999)(50986999)(19580405001)(54356999)(64706001)(20776003)(79102001)(92566001)(74662001)(66066001)(31966008)(80022001)(74502001)(74316001)(86362001)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:BLUPR05MB040;H:BLUPR05MB037.namprd05.prod.outlook.com;FPR:;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=bevenson@melinkcorp.com; 
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: melinkcorp.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Boris,

> -----Original Message-----
> From: Boris BREZILLON [mailto:boris.brezillon@free-electrons.com]
> Sent: Tuesday, May 06, 2014 10:28 AM
> To: Bryan Evenson
> Cc: Andrew Victor; Nicolas Ferre; Jean-Christophe Plagniol-Villard; linux-arm-
> kernel@lists.infradead.org; Alessandro Zummo; rtc-
> linux@googlegroups.com; linux-kernel@vger.kernel.org; Boris BREZILLON
> Subject: [PATCH] rtc: rtc-at91rm9200: fix infinite wait for ACKUPD irq
> 
> The rtc user must wait at least 1 sec between each time/calandar update
> (see atmel's datasheet chapter "Updating Time/Calendar").
> 
> Use the 1Hz interrupt to update the at91_rtc_upd_rdy flag and wait for
> the at91_rtc_wait_upd_rdy event if the rtc is not ready.
> 
> Signed-off-by: Boris BREZILLON <boris.brezillon@free-electrons.com>
> Reported-by: Bryan Evenson <bevenson@melinkcorp.com>
> ---
> Hello Bryan,
> 
> I reproduced your bug (using your script) and this patch seems to fix the
> problem.
> 
> Could you try it and let me know if it works for you ?

Looks good to me.  I modified the test script as follows:

----------
#!/bin/sh
i=0
while [ 1 ]; do
  hwclock -w -u > /dev/null 2>&1
  echo $$ $i $?
  : $((i++))
done
----------

This version then attempts to write to the RTC as often as possible (script change was due to a suggestion on the Busybox mailing list).  I ran two instances of the script, which each looped through about 60,000 times over a 30 minute run.  At no point has access to the RTC been permanently locked out on my system.  I'd call this fixed.

I'd assume this patch would be backported to the longterm releases?

Regards,
Bryan

> 
> Best Regards,
> 
> Boris
> 
>  drivers/rtc/rtc-at91rm9200.c | 14 +++++++++++++-
>  1 file changed, 13 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/rtc/rtc-at91rm9200.c b/drivers/rtc/rtc-at91rm9200.c
> index 3281c90..e3fe54c 100644
> --- a/drivers/rtc/rtc-at91rm9200.c
> +++ b/drivers/rtc/rtc-at91rm9200.c
> @@ -48,11 +48,13 @@ struct at91_rtc_config {
> 
>  static const struct at91_rtc_config *at91_rtc_config;
>  static DECLARE_COMPLETION(at91_rtc_updated);
> +static DECLARE_COMPLETION(at91_rtc_wait_upd_rdy);
>  static unsigned int at91_alarm_year = AT91_RTC_EPOCH;
>  static void __iomem *at91_rtc_regs;
>  static int irq;
>  static DEFINE_SPINLOCK(at91_rtc_lock);
>  static u32 at91_rtc_shadow_imr;
> +static bool at91_rtc_upd_rdy;
> 
>  static void at91_rtc_write_ier(u32 mask)
>  {
> @@ -161,6 +163,8 @@ static int at91_rtc_settime(struct device *dev, struct
> rtc_time *tm)
>  		1900 + tm->tm_year, tm->tm_mon, tm->tm_mday,
>  		tm->tm_hour, tm->tm_min, tm->tm_sec);
> 
> +	wait_for_completion(&at91_rtc_wait_upd_rdy);
> +
>  	/* Stop Time/Calendar from counting */
>  	cr = at91_rtc_read(AT91_RTC_CR);
>  	at91_rtc_write(AT91_RTC_CR, cr | AT91_RTC_UPDCAL |
> AT91_RTC_UPDTIM);
> @@ -183,6 +187,7 @@ static int at91_rtc_settime(struct device *dev, struct
> rtc_time *tm)
> 
>  	/* Restart Time/Calendar */
>  	cr = at91_rtc_read(AT91_RTC_CR);
> +	at91_rtc_upd_rdy = 0;
>  	at91_rtc_write(AT91_RTC_CR, cr & ~(AT91_RTC_UPDCAL |
> AT91_RTC_UPDTIM));
> 
>  	return 0;
> @@ -290,8 +295,13 @@ static irqreturn_t at91_rtc_interrupt(int irq, void
> *dev_id)
>  	if (rtsr) {		/* this interrupt is shared!  Is it ours? */
>  		if (rtsr & AT91_RTC_ALARM)
>  			events |= (RTC_AF | RTC_IRQF);
> -		if (rtsr & AT91_RTC_SECEV)
> +		if (rtsr & AT91_RTC_SECEV) {
>  			events |= (RTC_UF | RTC_IRQF);
> +			if (!at91_rtc_upd_rdy) {
> +				at91_rtc_upd_rdy = 1;
> +				complete(&at91_rtc_wait_upd_rdy);
> +			}
> +		}
>  		if (rtsr & AT91_RTC_ACKUPD)
>  			complete(&at91_rtc_updated);
> 
> @@ -413,6 +423,8 @@ static int __init at91_rtc_probe(struct
> platform_device *pdev)
>  		return PTR_ERR(rtc);
>  	platform_set_drvdata(pdev, rtc);
> 
> +	/* Enable 1Hz events */
> +	at91_rtc_write_ier(AT91_RTC_SECEV);
>  	dev_info(&pdev->dev, "AT91 Real Time Clock driver.\n");
>  	return 0;
>  }
> --
> 1.8.3.2

