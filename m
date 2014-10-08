Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754479AbaJHGaU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 02:30:20 -0400
Received: from mail-bn1on0131.outbound.protection.outlook.com ([157.56.110.131]:14272
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750705AbaJHGaS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 02:30:18 -0400
From: Yao Yuan <yao.yuan@freescale.com>
To: Wolfram Sang <wsa@the-dreams.de>
CC: "marex@denx.de" <marex@denx.de>,
        "LW@KARO-electronics.de" <LW@KARO-electronics.de>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "fugang.duan@freescale.com" <fugang.duan@freescale.com>,
        "shawn.guo@linaro.org" <shawn.guo@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>
Subject: RE: [PATCH v8 1/2] i2c: imx: add DMA support for freescale i2c driver
Thread-Topic: [PATCH v8 1/2] i2c: imx: add DMA support for freescale i2c
 driver
Thread-Index: AQHP2J/6bTKAgO1WJ0e+ynaEgW5au5weDVOAgAeH1DA=
Date: Wed, 8 Oct 2014 06:30:14 +0000
Message-ID: <3cd0b028391140b9a75cddf58dbe40b8@DM2PR03MB349.namprd03.prod.outlook.com>
References: <1411632689-31531-1-git-send-email-yao.yuan@freescale.com>
 <1411632689-31531-2-git-send-email-yao.yuan@freescale.com>
 <20141003075441.GA1349@katana>
In-Reply-To: <20141003075441.GA1349@katana>
Accept-Language: en-US, zh-CN
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [123.151.195.50]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:;SRVR:DM2PR03MB381;
x-forefront-prvs: 0358535363
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(6009001)(189002)(51704005)(377454003)(13464003)(199003)(106116001)(2656002)(21056001)(106356001)(87936001)(74316001)(66066001)(108616004)(110136001)(120916001)(31966008)(76482002)(40100002)(95666004)(85306004)(105586002)(122556002)(97736003)(4396001)(50986999)(20776003)(33646002)(19580405001)(19580395003)(76176999)(86362001)(107046002)(64706001)(85852003)(46102003)(80022003)(99396003)(92566001)(101416001)(54356999)(24736002);DIR:OUT;SFP:1102;SCL:1;SRVR:DM2PR03MB381;H:DM2PR03MB349.namprd03.prod.outlook.com;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Wolfram Sang [mailto:wsa@the-dreams.de]
> Sent: Friday, October 03, 2014 3:55 PM
> To: Yuan Yao-B46683
> Cc: marex@denx.de; LW@KARO-electronics.de; mark.rutland@arm.com; Duan
> Fugang-B38611; shawn.guo@linaro.org; linux-kernel@vger.kernel.org; linux-
> arm-kernel@lists.infradead.org; linux-i2c@vger.kernel.org
> Subject: Re: [PATCH v8 1/2] i2c: imx: add DMA support for freescale i2c
> driver
> > -#include <linux/init.h>
> > -#include <linux/kernel.h>
> > -#include <linux/module.h>
> > +#include <linux/clk.h>
> > +#include <linux/completion.h>
> > +#include <linux/delay.h>
> > +#include <linux/dma-mapping.h>
> > +#include <linux/dmaengine.h>
> > +#include <linux/dmapool.h>
> >  #include <linux/errno.h>
> >  #include <linux/err.h>
> >  #include <linux/interrupt.h>
> > -#include <linux/delay.h>
> >  #include <linux/i2c.h>
> > +#include <linux/init.h>
> >  #include <linux/io.h>
> > -#include <linux/sched.h>
> > -#include <linux/platform_device.h>
> > -#include <linux/clk.h>
> > -#include <linux/slab.h>
> > +#include <linux/kernel.h>
> > +#include <linux/module.h>
> >  #include <linux/of.h>
> >  #include <linux/of_device.h>
> > +#include <linux/of_dma.h>
> >  #include <linux/platform_data/i2c-imx.h>
> > +#include <linux/platform_device.h>
> > +#include <linux/sched.h>
> > +#include <linux/slab.h>
> 
> This is a seperate patch.

[Yuan Yao] 
Here I just adjust the order of the include file as alphabetical order.
If it looks strange I can only add the include files about DMA.

> 
> 
> > +	while (1) {
> > +		temp = imx_i2c_read_reg(i2c_imx, IMX_I2C_I2SR);
> > +		if (temp & I2SR_ICF)
> > +			break;
> > +		if (time_after(jiffies, orig_jiffies +
> > +				msecs_to_jiffies(IMX_I2C_DMA_TIMEOUT))) {
> > +			dev_dbg(dev, "<%s> Timeout\n", __func__);
> > +			return -ETIMEDOUT;
> > +		}
> > +		schedule();
> 
> That might have been asked before. Is there no interrupt for this?
> 

[Yuan Yao] No, there is no interrupt.
After DMA callback, I must wait until the last byte transfer completely.
It's a very short time which less than 10us.
By the way, how about use udelay(10) instead of schedule()?
udelay(10) is waiting a appropriate time.
schedule() is waiting too long for i2c but may be good for whole system.
Can you give me some suggestion?

Thanks for your review.

Best Regards,
Yuan Yao
