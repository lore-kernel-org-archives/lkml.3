Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756769AbaIDCGv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 22:06:51 -0400
Received: from mail-bn1lp0145.outbound.protection.outlook.com ([207.46.163.145]:15932
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756067AbaIDCGu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 22:06:50 -0400
From: "Li.Xiubo@freescale.com" <Li.Xiubo@freescale.com>
To: Thomas Gleixner <tglx@linutronix.de>
CC: "daniel.lezcano@linaro.org" <daniel.lezcano@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 5/5] Clocksource: Flextimer: Use Macro for clock source
 selection.
Thread-Topic: [PATCH 5/5] Clocksource: Flextimer: Use Macro for clock source
 selection.
Thread-Index: AQHPwPGlRpxrlbgW4kSWCyKr9o5FSJvvW6gAgADrvpA=
Date: Thu, 4 Sep 2014 02:06:46 +0000
Message-ID: <0d12608f04674dcc8138bb23431c8ca4@BY2PR0301MB0613.namprd03.prod.outlook.com>
References: <1409031951-39021-1-git-send-email-Li.Xiubo@freescale.com>
 <1409031951-39021-6-git-send-email-Li.Xiubo@freescale.com>
 <alpine.DEB.2.10.1409031346220.3333@nanos>
In-Reply-To: <alpine.DEB.2.10.1409031346220.3333@nanos>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [123.151.195.49]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:;UriScan:;
x-forefront-prvs: 0324C2C0E2
x-forefront-antispam-report: SFV:NSPM;SFS:(6009001)(24454002)(189002)(199003)(164054003)(51704005)(54356999)(50986999)(106356001)(101416001)(46102001)(33646002)(76176999)(105586002)(90102001)(77982001)(74502001)(20776003)(95666004)(31966008)(83072002)(107046002)(99286002)(74662001)(85306004)(77096002)(74316001)(85852003)(83322001)(76576001)(106116001)(87936001)(81342001)(21056001)(66066001)(575784001)(2656002)(110136001)(108616004)(81542001)(80022001)(76482001)(99396002)(79102001)(64706001)(4396001)(86362001)(92566001)(24736002);DIR:OUT;SFP:;SCL:1;SRVR:BY2PR0301MB0614;H:BY2PR0301MB0613.namprd03.prod.outlook.com;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Subject: Re: [PATCH 5/5] Clocksource: Flextimer: Use Macro for clock source
> selection.
> 
> On Tue, 26 Aug 2014, Xiubo Li wrote:
> > FTM source clock is selectable:
> > Source clock can be the system clock, the fixed frequency clock,
> > or an external clock.
> > Fixed frequency clock is an additional clock input to allow the
> > selection of an on chip clock source other than the system clock.
> > Selecting external clock connects FTM clock to a chip level input
> > pin therefore allowing to synchronize the FTM counter with an off
> > chip clock source
> >
> > Clock Source Selection:
> > Selects one of the three FTM counter clock sources.
> >
> > 00 No clock selected. This in effect disables the FTM counter.
> > 01 System clock
> > ---
> > 10 Fixed frequency clock
> > 11 External clock
> >
> > These two will be useful for the alarm on LS1 platform in late future,
> > the system clock's frequency is too high to get a long delay timer when
> > go to sleep, so the fixed or external clock could be used instead.
> 
> And how is that relevant to changing the mask from a hardcoded value
> to a constant? It's still hardcoded at compile time and I don't see
> how that helps chosing the clock at runtime for a particular use case.
> 
> >  #define FTM_SC		0x00
> > +#define FTM_SC_CLKS_NON		0
> > +#define FTM_SC_CLKS_SYS		1
> >  #define FTM_SC_CLK_SHIFT	3
> >  #define FTM_SC_CLK_MASK	(0x3 << FTM_SC_CLK_SHIFT)
> >  #define FTM_SC_CLK(c)	((c) << FTM_SC_CLK_SHIFT)
> > @@ -67,7 +69,7 @@ static inline void ftm_counter_enable(void __iomem *base)
> >  	/* select and enable counter clock source */
> >  	val = ftm_readl(base + FTM_SC);
> >  	val &= ~(FTM_SC_PS_MASK | FTM_SC_CLK_MASK);
> > -	val |= priv->ps | FTM_SC_CLK(1);
> > +	val |= priv->ps | FTM_SC_CLK(FTM_SC_CLKS_SYS);
> >  	ftm_writel(val, base + FTM_SC);
> >  }
> >
> > @@ -77,7 +79,8 @@ static inline void ftm_counter_disable(void __iomem *base)
> >
> >  	/* disable counter clock source */
> >  	val = ftm_readl(base + FTM_SC);
> > -	val &= ~(FTM_SC_PS_MASK | FTM_SC_CLK_MASK);
> > +	val &= ~(FTM_SC_CLK_MASK);
> 
> So you remove the FTM_SC_PS_MASK without mentioning it in the
> changelog. Either this is by mistake or it wants to be documented WHY
> it is not needed in the first place.
> 

This is just prepare for the other new features in the future.

And delay this changes maybe better.

Thanks,

BRs
Xiubo

