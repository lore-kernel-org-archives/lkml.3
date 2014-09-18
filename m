Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757084AbaIRPqL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 11:46:11 -0400
Received: from mail-bl2on0120.outbound.protection.outlook.com ([65.55.169.120]:44976
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756415AbaIRPqI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 11:46:08 -0400
From: Yao Yuan <yao.yuan@freescale.com>
To: Marek Vasut <marex@denx.de>
CC: "wsa@the-dreams.de" <wsa@the-dreams.de>,
        "LW@karo-electronics.de" <LW@karo-electronics.de>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "fugang.duan@freescale.com" <fugang.duan@freescale.com>,
        "shawn.guo@linaro.org" <shawn.guo@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>
Subject: Re: [PATCH v7 1/2] i2c: imx: add DMA support for freescale i2c driver
Thread-Topic: [PATCH v7 1/2] i2c: imx: add DMA support for freescale i2c
 driver
Thread-Index: AQHPtuKa1yGA2bLpA0aZlDBgfnstDpvxLheAgADaxYCAAHUPAIAGMlDggAuW1wCAAISEIIABHeIAgAFV2dg=
Date: Thu, 18 Sep 2014 15:46:04 +0000
Message-ID: <1411055145666.72178@freescale.com>
References: <1407923215-3749-1-git-send-email-yao.yuan@freescale.com>
 <201409162017.06439.marex@denx.de>
 <1410965416759.91038@freescale.com>,<201409172114.36617.marex@denx.de>
In-Reply-To: <201409172114.36617.marex@denx.de>
Accept-Language: en-US, zh-CN
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [124.205.104.251]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:;UriScan:;
x-forefront-prvs: 033857D0BD
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(6009001)(51704005)(24454002)(377454003)(199003)(189002)(85852003)(92566001)(74502003)(81542003)(106116001)(46102003)(20776003)(110136001)(107046002)(105586002)(95666004)(90102001)(80022003)(117636001)(66066001)(76482002)(54356999)(83322001)(81342003)(99396002)(31966008)(101416001)(87936001)(19580395003)(64706001)(50986999)(21056001)(86362001)(2656002)(4396001)(85306004)(36756003)(92726001)(83072002)(77982003)(74662003)(79102003)(76176999)(93886004)(97736003)(106356001);DIR:OUT;SFP:1102;SCL:1;SRVR:BL2PR03MB369;H:BL2PR03MB338.namprd03.prod.outlook.com;FPR:;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Marek Vasut wrote:
> On Wednesday, September 17, 2014 at 04:50:34 PM, Yao Yuan wrote:
> [...]
> > > > > Would that mean that the "crashed" DMA would be running until the
> > > > > next transmission is scheduled ?
> > > >
> > > > [Yuan Yao] No, In fact any DMA timeout will result the failure of I2C
> > > > transmission and then it will turn to report the exception and wait
> > > > for next transmission.
> > >
> > > Can you tell when the next transmission will happen? What if I issue a
> > > single transmission and that one fails ? Will the DMA run until who knows
> > > when ?
> >
> > [Yuan Yao]
> > Sorry for my unclear description. In fact, During the DMA transmission  if
> > an error happened or time out, DMA will stop at once and be disabled.
> > I just continue to route the TX and RX request to signal the DMA
> > controller. Because the DMA is disabled, it will ignore those signals.
> >
> > In a word, I just want to block the I2C TX, RX and interrupt signal when
> > DMA mode failed until the next I2C transmission start.

> So the I2C block is in error state until you clean it up upon next transmission?
[Yuan Yao]
No, just DMAEN bit.
Other I2C error state will clean soon.

> > In fact, the bit "I2CR_DMAEN" is a switch which decide whether I2C route
> > the TX, RX and interrupt signal to DMA controller.
> >
> > > The only thing I worried about is I2C may still receive some feedbacks
> > > after DMA timeout. In this case the feedbacks may lead to abnormal
> > > state in PIO mode.But it will be ignored in DMA model.
> > > That's why I tend to delay force-disable DMA until the next
> > > transmission begin. Could you please give me some suggestion?
> >
> > > No, this design just seems flawed to me. You should stop the DMA
> > > immediatelly if there is an error to avoid wasting resources and prevent
> > > possible other adverse effects.
> >
> > [Yuan Yao]
> > Yes, I have stopped the DMA immediately. However I keep the I2C DMA
> > single route.
> >
> > I don't have the exact evidence to prove that my design is acceptable.
> > So if you are sure it's flawed, I will change it in the next version(V8).

> I'm just trying to understand it.

[Yuan Yao]
Both of us know that we should stop DMA immediately when issue happened.
The only argument is that I want to set the DMAEN bit just before the next 
transmission starts. But you think when I stop the DMA I should set it at the same
time. The bit is the switch which is used to decide whether Rx and Tx signal can
be routed to DMA. In fact, I deeply think about what is the difference between
our arguments for those days. I think the two ways are almost the same.
Your way is more acceptable because people tend to clear the DMA status
just after stopping it. So I think your way is better.

Best regards,
Yuan Yao
