Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932652AbaFLHpm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 03:45:42 -0400
Received: from mail-bn1lp0139.outbound.protection.outlook.com ([207.46.163.139]:27686
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932252AbaFLHpl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 03:45:41 -0400
From: "Li.Xiubo@freescale.com" <Li.Xiubo@freescale.com>
To: Stephen Boyd <sboyd@codeaurora.org>
CC: Marc Zyngier <Marc.Zyngier@arm.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "daniel.lezcano@linaro.org" <daniel.lezcano@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: RE: [PATCH] clocksource: arch_arm_timer: Fix timecounter
 initialization
Thread-Topic: [PATCH] clocksource: arch_arm_timer: Fix timecounter
 initialization
Thread-Index: AQHPhVaZaAwMcHJxwkqppjA7z49YUZtsRJ0AgAC3XqA=
Date: Thu, 12 Jun 2014 07:45:36 +0000
Message-ID: <bce193f3fc264abf82ff52ef69f0b86a@BY2PR03MB505.namprd03.prod.outlook.com>
References: <1402475861-15354-1-git-send-email-Li.Xiubo@freescale.com>
 <5398A7B2.6030807@codeaurora.org>
In-Reply-To: <5398A7B2.6030807@codeaurora.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [123.151.195.49]
x-microsoft-antispam: BL:0;ACTION:Default;RISK:Low;SCL:0;SPMLVL:NotSpam;PCL:0;RULEID:
x-forefront-prvs: 02408926C4
x-forefront-antispam-report: SFV:NSPM;SFS:(6009001)(428001)(51704005)(189002)(199002)(164054003)(377424004)(80022001)(4396001)(64706001)(77096999)(86362001)(81342001)(54356999)(2656002)(66066001)(21056001)(76176999)(19580395003)(81542001)(46102001)(76576001)(74316001)(77982001)(99286001)(74502001)(74662001)(33646001)(101416001)(20776003)(87936001)(50986999)(83322001)(85852003)(76482001)(83072002)(24736002);DIR:OUT;SFP:;SCL:1;SRVR:BY2PR03MB507;H:BY2PR03MB505.namprd03.prod.outlook.com;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Li.Xiubo@freescale.com; 
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >  drivers/clocksource/arm_arch_timer.c | 5 +++--
> >  1 file changed, 3 insertions(+), 2 deletions(-)
> >
> > diff --git a/drivers/clocksource/arm_arch_timer.c
> b/drivers/clocksource/arm_arch_timer.c
> > index 5163ec1..6c3cfd8 100644
> > --- a/drivers/clocksource/arm_arch_timer.c
> > +++ b/drivers/clocksource/arm_arch_timer.c
> > @@ -426,7 +426,7 @@ struct timecounter *arch_timer_get_timecounter(void)
> >
> >  static void __init arch_counter_register(unsigned type)
> >  {
> > -	u64 start_count;
> > +	u64 start_count, start_ns;
> >
> >  	/* Register the CP15 based counter if we have one */
> >  	if (type & ARCH_CP15_TIMER)
> > @@ -438,7 +438,8 @@ static void __init arch_counter_register(unsigned type)
> >  	clocksource_register_hz(&clocksource_counter, arch_timer_rate);
> >  	cyclecounter.mult = clocksource_counter.mult;
> >  	cyclecounter.shift = clocksource_counter.shift;
> > -	timecounter_init(&timecounter, &cyclecounter, start_count);
> > +	start_ns = cyclecounter_cyc2ns(&cyclecounter, start_count);
> > +	timecounter_init(&timecounter, &cyclecounter, start_ns);
> >
> >  	/* 56 bits minimum, so we assume worst case rollover */
> >  	sched_clock_register(arch_timer_read_counter, 56, arch_timer_rate);
> 
> This doesn't make much sense. We're converting start_count, which could
> be a very large number, into nanoseconds. It looks like we're assuming
> the counter always starts at 0 which is not always true if you sit in a
> bootloader for a long time. 

Yes, the counter here may usually start counting at bootloader time from zero.


> Perhaps it would be better to just do
> 
>     timecounter_init(&timecounter, &cyclecounter, 0);
> 
> or
> 
>     timecounter_init(&timecounter, &cyclecounter,
> ktime_to_ns(ktime_get_real()));
> 

Here the ktime_get_real() will always return 0, before setting the system clock,
Like:

"rtc-ds3232 1-0068: setting system clock to 2014-06-12 13:01:24 UTC (1402578084)"

And if so, why not just set it to 0 ? And by the way, 0 is must here ?

Thanks,
BRs
Xiubo
