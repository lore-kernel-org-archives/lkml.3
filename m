Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752040AbaDRDr3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 23:47:29 -0400
Received: from mail-bn1blp0181.outbound.protection.outlook.com ([207.46.163.181]:48849
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751661AbaDRDr0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 23:47:26 -0400
From: "Li.Xiubo@freescale.com" <Li.Xiubo@freescale.com>
To: Daniel Lezcano <daniel.lezcano@linaro.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "shawn.guo@linaro.org" <shawn.guo@linaro.org>,
        Jingchang Lu <jingchang.lu@freescale.com>,
        "Jason.Jin@freescale.com" <Jason.Jin@freescale.com>,
        "Dongsheng.Wang@freescale.com" <Dongsheng.Wang@freescale.com>
CC: "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [RFC][PATCH 3/3] clocksource: Add Freescale FlexTimer Module
 (FTM) timer support
Thread-Topic: [RFC][PATCH 3/3] clocksource: Add Freescale FlexTimer Module
 (FTM) timer support
Thread-Index: AQHPWSBc9k7OgjbNkEijY/VC8/wPu5sV3s2AgADf4bA=
Date: Fri, 18 Apr 2014 03:47:22 +0000
Message-ID: <0604781786e540b5baa98a07d0809c92@BY2PR03MB505.namprd03.prod.outlook.com>
References: <1397614787-8300-1-git-send-email-Li.Xiubo@freescale.com>
 <1397614787-8300-4-git-send-email-Li.Xiubo@freescale.com>
 <534FE3C1.4060509@linaro.org>
In-Reply-To: <534FE3C1.4060509@linaro.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [123.151.195.49]
x-forefront-prvs: 018577E36E
x-forefront-antispam-report: SFV:NSPM;SFS:(10009001)(6009001)(428001)(199002)(189002)(51704005)(164054003)(2201001)(54356999)(81542001)(80976001)(99396002)(80022001)(77096999)(76176999)(20776003)(66066001)(79102001)(87936001)(99286001)(92566001)(2656002)(50986999)(46102001)(74502001)(31966008)(85852003)(83322001)(33646001)(83072002)(4396001)(76576001)(86362001)(81342001)(76482001)(575784001)(74662001)(74316001)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2PR03MB380;H:BY2PR03MB505.namprd03.prod.outlook.com;FPR:B02EC83F.80E3DFBB.BBF11D73.C5A2F484.2026F;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s3I3lX1m017622

> > Here using the FTM0 as clock event device and the FTM1 as clock
> > source device.
> 
> As it is a new driver, please add a more elaborated description of the
> timer.
> 

Please see the next version.


> > +#include <linux/clk.h>
> > +#include <linux/clockchips.h>
> > +#include <linux/clocksource.h>
> > +#include <linux/err.h>
> > +#include <linux/interrupt.h>
> > +#include <linux/io.h>
> > +#include <linux/kernel.h>
> > +#include <linux/module.h>
> > +#include <linux/of_address.h>
> > +#include <linux/of_irq.h>
> > +#include <linux/sched_clock.h>
> 
> Could you check all these headers are effectively needed ?
> 

Yes, I will.



> > +#define FTM_OFFSET(n)	(0x1000 * n)
> > +
> > +#define FTM_SC		0x00
> > +#define FTM_SC_CLK_SHIFT	3
> > +#define FTM_SC_CLK_MASK	(0x3 << FTM_SC_CLK_SHIFT)
> > +#define FTM_SC_CLK(c)	((c) << FTM_SC_CLK_SHIFT)
> > +#define FTM_SC_PS_MASK	0x7
> > +#define FTM_SC_TOIE	BIT(6)
> > +#define FTM_SC_TOF	BIT(7)
> > +
> > +#define FTM_CNT		0x04
> > +#define FTM_MOD		0x08
> > +
> > +#define FTM_CSC_BASE	0x0C
> > +#define FTM_CSC_MSB	BIT(5)
> > +#define FTM_CSC_MSA	BIT(4)
> > +#define FTM_CSC_ELSB	BIT(3)
> > +#define FTM_CSC_ELSA	BIT(2)
> > +
> > +#define FTM_CV_BASE	0x10
> > +#define FTM_CNTIN	0x4C
> > +#define FTM_STATUS	0x50
> > +
> > +#define FTM_MODE	0x54
> > +#define FTM_MODE_FTMEN	BIT(0)
> > +#define FTM_MODE_WPDIS	BIT(2)
> > +#define FTM_MODE_PWMSYNC	BIT(3)
> > +
> > +#define FTM_SYNC	0x58
> > +#define FTM_OUTINIT	0x5C
> > +#define FTM_OUTMASK	0x60
> > +#define FTM_COMBINE	0x64
> > +#define FTM_DEADTIME	0x68
> > +#define FTM_EXTTRIG	0x6C
> > +#define FTM_POL		0x70
> > +#define FTM_FMS		0x74
> > +#define FTM_FILTER	0x78
> > +#define FTM_FLTCTRL	0x7C
> > +#define FTM_QDCTRL	0x80
> > +#define FTM_CONF	0x84
> > +#define FTM_FLTPOL	0x88
> > +#define FTM_SYNCONF	0x8C
> > +#define FTM_INVCTRL	0x90
> > +#define FTM_SWOCTRL	0x94
> > +#define FTM_PWMLOAD	0x98
> 
> Please remove the unused macros.
> 

Okay.


> > +
> > +	freq = clk_get_rate(ftm_clk);
> > +
> > +	calc_closest_cound_cyc(freq);
> > +
> > +	BUG_ON(ftm_clocksource_init(freq));
> > +
> > +	BUG_ON(ftm_clockevent_init(freq, irq));
> > +}
> > +CLOCKSOURCE_OF_DECLARE(vf610, "fsl,vf610-ftm-timer", ftm_timer_init);
> 
> 
> I am not a big fan of those BUG_ON every line. Could you please replace
> it by dev_err().
> 
> That is also not in the logic of a single zImage.
> 

Yes, if so, I will revise this.


Thanks,

BRs
Xiubo



ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
