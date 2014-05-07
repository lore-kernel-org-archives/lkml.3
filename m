Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751865AbaEGSoi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 14:44:38 -0400
Received: from mail-by2lp0237.outbound.protection.outlook.com ([207.46.163.237]:30804
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751069AbaEGSoh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 14:44:37 -0400
From: Bryan Evenson <bevenson@melinkcorp.com>
To: Boris BREZILLON <boris.brezillon@free-electrons.com>
CC: Andrew Victor <linux@maxim.org.za>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] ARM: at91: fix rtc irq mask for sam9x5 SoCs
Thread-Topic: [PATCH] ARM: at91: fix rtc irq mask for sam9x5 SoCs
Thread-Index: AQHPahBVbmZEoWtbAUypC+ZQ4uYpC5s1cRGQ
Date: Wed, 7 May 2014 18:44:33 +0000
Message-ID: <edaf5835a7b14b9a8c053dcd40f2b591@BLUPR05MB037.namprd05.prod.outlook.com>
References: <957b209589094df48ddedbc57c6ccdfd@BLUPR05MB037.namprd05.prod.outlook.com>
 <1399479649-3247-1-git-send-email-boris.brezillon@free-electrons.com>
In-Reply-To: <1399479649-3247-1-git-send-email-boris.brezillon@free-electrons.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-vipre-scanned: 018CF5AB007122018CF6F8
x-originating-ip: [98.100.91.242]
x-forefront-prvs: 0204F0BDE2
x-forefront-antispam-report: SFV:NSPM;SFS:(10009001)(6009001)(6029001)(428001)(377454003)(199002)(189002)(13464003)(51704005)(99286001)(81542001)(64706001)(83322001)(19580405001)(19580395003)(81342001)(2656002)(87936001)(99396002)(4396001)(31966008)(74502001)(74662001)(80022001)(77982001)(66066001)(20776003)(85852003)(83072002)(92566001)(86362001)(76482001)(74316001)(50986999)(101416001)(76176999)(54356999)(21056001)(33646001)(76576001)(46102001)(79102001)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:BLUPR05MB039;H:BLUPR05MB037.namprd05.prod.outlook.com;FPR:;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
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
> Sent: Wednesday, May 07, 2014 12:21 PM
> To: Bryan Evenson
> Cc: Andrew Victor; Nicolas Ferre; Jean-Christophe Plagniol-Villard; linux-arm-
> kernel@lists.infradead.org; linux-kernel@vger.kernel.org; Boris BREZILLON
> Subject: [PATCH] ARM: at91: fix rtc irq mask for sam9x5 SoCs
> 
> The RTC IMR register is not reliable on sam9x5 SoCs, hence why me have to
> mask all interrupts no matter what IMR claims about already masked irqs.
> 
> Signed-off-by: Boris BREZILLON <boris.brezillon@free-electrons.com>
> Reported-by: Bryan Evenson <bevenson@melinkcorp.com>
> ---
> Hello Bryan,
> 
> Yet another patch for you ;-).
> 
> As usual, could you tell me if it fixes your bug.
> 
> BTW, thanks for your tests.
> 
> Best Regards,
> 
> Boris

This fixes the issue on my system.  I disconnected my system from the network to guarantee ntp didn't adjust the time.  I power cycled my system 15 times with the RTC backup battery in place, and each time it booted without issue and the RTC kept the correct time.  Before this patch my system would never complete booting with the RTC battery installed.  I also used my previous test script for the previous patch to verify that I could not lockup access to the RTC.

Tested-by: Bryan Evenson <bevenson@melinkcorp.com>

Regards,
Bryan

> 
>  arch/arm/mach-at91/sysirq_mask.c | 7 +------
>  1 file changed, 1 insertion(+), 6 deletions(-)
> 
> diff --git a/arch/arm/mach-at91/sysirq_mask.c b/arch/arm/mach-
> at91/sysirq_mask.c
> index 2ba694f..eb3d2a5 100644
> --- a/arch/arm/mach-at91/sysirq_mask.c
> +++ b/arch/arm/mach-at91/sysirq_mask.c
> @@ -37,12 +37,7 @@ void __init at91_sysirq_mask_rtc(u32 rtc_base)
>  	if (!base)
>  		return;
> 
> -	mask = readl_relaxed(base + AT91_RTC_IMR);
> -	if (mask) {
> -		pr_info("AT91: Disabling rtc irq\n");
> -		writel_relaxed(mask, base + AT91_RTC_IDR);
> -		(void)readl_relaxed(base + AT91_RTC_IMR);	/* flush */
> -	}
> +	writel_relaxed(0x1f, base + AT91_RTC_IDR);
> 
>  	iounmap(base);
>  }
> --
> 1.8.3.2

