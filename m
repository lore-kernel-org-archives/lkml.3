Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752449AbaESC0r (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2014 22:26:47 -0400
Received: from mail-by2lp0236.outbound.protection.outlook.com ([207.46.163.236]:32216
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752221AbaESC0p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2014 22:26:45 -0400
From: "Li.Xiubo@freescale.com" <Li.Xiubo@freescale.com>
To: Daniel Lezcano <daniel.lezcano@linaro.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "shawn.guo@linaro.org" <shawn.guo@linaro.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Jingchang Lu <jingchang.lu@freescale.com>
Subject: RE: [PATCHv3 3/3] clocksource: Add Freescale FlexTimer Module (FTM)
 timer support
Thread-Topic: [PATCHv3 3/3] clocksource: Add Freescale FlexTimer Module
 (FTM) timer support
Thread-Index: AQHPY1ed3mDRWUd51kaK8D+dt0JVM5tDaoGAgAPcT4A=
Date: Mon, 19 May 2014 02:26:41 +0000
Message-ID: <0a6cb1e6380f42279a583ebf7e27dd54@BY2PR03MB505.namprd03.prod.outlook.com>
References: <1398737939-5334-1-git-send-email-Li.Xiubo@freescale.com>
 <1398737939-5334-4-git-send-email-Li.Xiubo@freescale.com>
 <537629C3.30507@linaro.org>
In-Reply-To: <537629C3.30507@linaro.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [123.151.195.49]
x-forefront-prvs: 021670B4D2
x-forefront-antispam-report: SFV:NSPM;SFS:(6009001)(428001)(189002)(199002)(52604005)(51704005)(74316001)(66066001)(85852003)(83072002)(87936001)(86362001)(575784001)(80022001)(79102001)(21056001)(4396001)(2656002)(20776003)(64706001)(33646001)(101416001)(76576001)(76482001)(81542001)(81342001)(83322001)(77982001)(74502001)(46102001)(99396002)(99286001)(50986999)(31966008)(74662001)(92566001)(2201001)(76176999)(54356999)(77096999)(24736002);DIR:OUT;SFP:;SCL:1;SRVR:BY2PR03MB474;H:BY2PR03MB505.namprd03.prod.outlook.com;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Li.Xiubo@freescale.com; 
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s4J2R1o7032096

> > +#define FTM_CNTIN	0x4C
> > +
> > +static void __iomem *clksrc_base;
> > +static void __iomem *clkevt_base;
> > +static unsigned long peroidic_cyc;
> > +static unsigned long ps;
> > +bool big_endian;
> > +
> 
> Usually this is encaspulated in a structure.
> 
> struct ftm_clock_device {
> 	void __iomem *clksrc_base;
> 	...
> };
>
> 
> > +static inline u32 ftm_readl(void __iomem *addr)
> > +{
> > +	if (big_endian)
> 
> I am not a big fan of addressing global variables in the functions, so
> if you can pass the structure pointer around here and the other
> functions instead that would be nice.
> 
> Otherwise the patch sounds ok. Thanks for taking care of encapsulating
> well the functions and commenting the code.
> 

Yes, I did think so.

But some callbacks like ï¼š
+ static u64 ftm_read_sched_clock(void)
+ {
+         return ftm_readl(clksrc_base + FTM_CNT);
+ }

Used by :
+ sched_clock_register(ftm_read_sched_clock,....);

If they are encapsulated in a structure, and should the struct instance
be one global instance too ? I'm doubting whether will this make sense ?


> > +static int __init ftm_calc_closest_round_cyc(unsigned long freq)
> > +{
> > +	ps = 0;
> > +
> > +	do {
> > +		peroidic_cyc = DIV_ROUND_CLOSEST(freq, HZ * (1 << ps++));
> > +	} while (peroidic_cyc > 0xFFFF);
> > +
> > +	if (ps > 7) {
> > +		pr_err("ftm: the max prescaler is %lu > 7\n", ps);
> > +		return -EINVAL;
> > +	}
> > +
> 
> Can you explain how this error can happen ?
> 

Yes, the hardware limitation of the 'ps' is 0~7, and the counter register
Is only using the lower 16 bits.
If the 'freq' value is too big here, then the periodic_cyc may exceed 0xFFFF.

Or should I add some comment here ?


Thanks very much,
BRs
Xiubo


ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
