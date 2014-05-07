Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756218AbaEGOvn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 10:51:43 -0400
Received: from mail-by2lp0239.outbound.protection.outlook.com ([207.46.163.239]:1612
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751915AbaEGOvm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 10:51:42 -0400
From: Bryan Evenson <bevenson@melinkcorp.com>
To: Boris BREZILLON <boris.brezillon@free-electrons.com>
CC: Andrew Victor <linux@maxim.org.za>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Alessandro Zummo <a.zummo@towertech.it>,
        "rtc-linux@googlegroups.com" <rtc-linux@googlegroups.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH v2] rtc: rtc-at91rm9200: fix uninterruptible wait for
 ACKUPD
Thread-Topic: [PATCH v2] rtc: rtc-at91rm9200: fix uninterruptible wait for
 ACKUPD
Thread-Index: AQHPad8Tzhs2vJsf5EyeB/V1xl+kF5s1JU1Q
Date: Wed, 7 May 2014 14:51:39 +0000
Message-ID: <957b209589094df48ddedbc57c6ccdfd@BLUPR05MB037.namprd05.prod.outlook.com>
References: <1399458490-11870-1-git-send-email-boris.brezillon@free-electrons.com>
In-Reply-To: <1399458490-11870-1-git-send-email-boris.brezillon@free-electrons.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-vipre-scanned: 00AAA6CC00711C00AAA819
x-originating-ip: [98.100.91.242]
x-forefront-prvs: 0204F0BDE2
x-forefront-antispam-report: SFV:NSPM;SFS:(10009001)(6009001)(428001)(377454003)(51704005)(199002)(189002)(13464003)(83072002)(85852003)(92566001)(2656002)(101416001)(76176999)(21056001)(87936001)(50986999)(54356999)(74316001)(99396002)(99286001)(86362001)(66066001)(31966008)(64706001)(80022001)(33646001)(83322001)(19580405001)(19580395003)(76576001)(74502001)(81542001)(20776003)(77982001)(81342001)(76482001)(46102001)(4396001)(74662001)(79102001)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:BLUPR05MB037;H:BLUPR05MB037.namprd05.prod.outlook.com;FPR:;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
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
> Sent: Wednesday, May 07, 2014 6:28 AM
> To: Bryan Evenson
> Cc: Andrew Victor; Nicolas Ferre; Jean-Christophe Plagniol-Villard; linux-arm-
> kernel@lists.infradead.org; Alessandro Zummo; rtc-
> linux@googlegroups.com; linux-kernel@vger.kernel.org; Boris BREZILLON;
> stable@vger.kernel.org
> Subject: [PATCH v2] rtc: rtc-at91rm9200: fix uninterruptible wait for ACKUPD
> 
> The rtc user must wait at least 1 sec between each time/calandar update
> (see atmel's datasheet chapter "Updating Time/Calendar").
> 
> Use the SECEV interrupt (as suggested by the datasheet) to wait for the RTC
> to be ready for new updates.
> 
> Cc: <stable@vger.kernel.org> # v3.10+
> Signed-off-by: Boris BREZILLON <boris.brezillon@free-electrons.com>
> Reported-by: Bryan Evenson <bevenson@melinkcorp.com>
> ---
> Hello,
> 
> This patch fixes a deadlock in an uninterruptible wait when the RTC is
> updated more than once every second.
> AFAICT the bug is here from the beginning, but I think we should at least
> backport this fix to 3.10 and the following longterm and stable releases.
> 
> Best Regards,
> 
> Boris

Hang on, I found a problem.  My system works fine on a soft reboot, but during a power cycle my system hangs.  Last thing I see to print is "Uncompressing Linux... done, booting the kernel."  If I removde the backup battery for the RTC my system boots just fine.  Luckily this is very repeatable on my system.  This looks similar to the early rtt-interrupt bug which was fixed about 7 months ago (linux-stable commits 6ce3ee9af1ad697c71766067ffa1a35352dfdcfd and 54f830b7337ed016b6708cf5a2ac297d4cee227d).  I confirmed that the kernel I'm using has the relevant fix applied from 7 months ago.  Did this fix reintroduce the early rtt-interrupt bug?

Let me know if you would like me to test anything or more information.

Regards,
Bryan

> 
> Changes since v1:
> - disable SECEV interrupt when the RTC is ready to accept new time updates
> 
>  drivers/rtc/rtc-at91rm9200.c | 16 ++++++++++++++--
>  1 file changed, 14 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/rtc/rtc-at91rm9200.c b/drivers/rtc/rtc-at91rm9200.c index
> 3281c90..44fe83e 100644
> --- a/drivers/rtc/rtc-at91rm9200.c
> +++ b/drivers/rtc/rtc-at91rm9200.c
> @@ -48,6 +48,7 @@ struct at91_rtc_config {
> 
>  static const struct at91_rtc_config *at91_rtc_config;  static
> DECLARE_COMPLETION(at91_rtc_updated);
> +static DECLARE_COMPLETION(at91_rtc_upd_rdy);
>  static unsigned int at91_alarm_year = AT91_RTC_EPOCH;  static void
> __iomem *at91_rtc_regs;  static int irq; @@ -161,6 +162,8 @@ static int
> at91_rtc_settime(struct device *dev, struct rtc_time *tm)
>  		1900 + tm->tm_year, tm->tm_mon, tm->tm_mday,
>  		tm->tm_hour, tm->tm_min, tm->tm_sec);
> 
> +	wait_for_completion(&at91_rtc_upd_rdy);
> +
>  	/* Stop Time/Calendar from counting */
>  	cr = at91_rtc_read(AT91_RTC_CR);
>  	at91_rtc_write(AT91_RTC_CR, cr | AT91_RTC_UPDCAL |
> AT91_RTC_UPDTIM); @@ -183,7 +186,9 @@ static int
> at91_rtc_settime(struct device *dev, struct rtc_time *tm)
> 
>  	/* Restart Time/Calendar */
>  	cr = at91_rtc_read(AT91_RTC_CR);
> +	at91_rtc_write(AT91_RTC_SCCR, AT91_RTC_SECEV);
>  	at91_rtc_write(AT91_RTC_CR, cr & ~(AT91_RTC_UPDCAL |
> AT91_RTC_UPDTIM));
> +	at91_rtc_write_ier(AT91_RTC_SECEV);
> 
>  	return 0;
>  }
> @@ -290,8 +295,10 @@ static irqreturn_t at91_rtc_interrupt(int irq, void
> *dev_id)
>  	if (rtsr) {		/* this interrupt is shared!  Is it ours? */
>  		if (rtsr & AT91_RTC_ALARM)
>  			events |= (RTC_AF | RTC_IRQF);
> -		if (rtsr & AT91_RTC_SECEV)
> -			events |= (RTC_UF | RTC_IRQF);
> +		if (rtsr & AT91_RTC_SECEV) {
> +			complete(&at91_rtc_upd_rdy);
> +			at91_rtc_write_idr(AT91_RTC_SECEV);
> +		}
>  		if (rtsr & AT91_RTC_ACKUPD)
>  			complete(&at91_rtc_updated);
> 
> @@ -413,6 +420,11 @@ static int __init at91_rtc_probe(struct
> platform_device *pdev)
>  		return PTR_ERR(rtc);
>  	platform_set_drvdata(pdev, rtc);
> 
> +	/* enable SECEV interrupt in order to initialize at91_rtc_upd_rdy
> +	 * completion.
> +	 */
> +	at91_rtc_write_ier(AT91_RTC_SECEV);
> +
>  	dev_info(&pdev->dev, "AT91 Real Time Clock driver.\n");
>  	return 0;
>  }
> --
> 1.8.3.2

