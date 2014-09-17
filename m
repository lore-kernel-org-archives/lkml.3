Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755897AbaIQPXO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 11:23:14 -0400
Received: from mail-bn1on0138.outbound.protection.outlook.com ([157.56.110.138]:47808
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755400AbaIQPXM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 11:23:12 -0400
X-Greylist: delayed 1056 seconds by postgrey-1.27 at vger.kernel.org; Wed, 17 Sep 2014 11:23:11 EDT
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
Subject: RE: [PATCH v7 1/2] i2c: imx: add DMA support for freescale i2c driver
Thread-Topic: [PATCH v7 1/2] i2c: imx: add DMA support for freescale i2c
 driver
Thread-Index: AQHPtuKa1yGA2bLpA0aZlDBgfnstDpvxLheAgADaxYCAAHUPAIAGMlDggAuW1wCAAISEIA==
Date: Wed, 17 Sep 2014 14:50:34 +0000
Message-ID: <1410965416759.91038@freescale.com>
References: <1407923215-3749-1-git-send-email-yao.yuan@freescale.com>
 <201409051240.44469.marex@denx.de> <1410360473732.53953@freescale.com>
 <201409162017.06439.marex@denx.de>
In-Reply-To: <201409162017.06439.marex@denx.de>
Accept-Language: en-US, zh-CN
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [125.39.108.75]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:;UriScan:;
x-forefront-prvs: 0337AFFE9A
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(6009001)(24454002)(51704005)(377454003)(199003)(189002)(92566001)(85852003)(107046002)(110136001)(20776003)(74662003)(83322001)(105586002)(46102003)(81342003)(90102001)(95666004)(80022003)(99286002)(74502003)(117636001)(66066001)(106116001)(99396002)(81542003)(76482002)(54356999)(31966008)(101416001)(87936001)(19580395003)(64706001)(50986999)(21056001)(86362001)(2656002)(85306004)(4396001)(92726001)(97736003)(79102003)(83072002)(77982003)(36756003)(76176999)(93886004)(106356001);DIR:OUT;SFP:1102;SCL:1;SRVR:BL2PR03MB369;H:BL2PR03MB338.namprd03.prod.outlook.com;FPR:;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, September 17, 2014 2:17 AM, Marek Vasut wrote:
> On Wednesday, September 10, 2014 at 04:48:01 PM, Yao Yuan wrote:
> > On Friday, September 05, 2014 6:41 PM, Marek Vasut wrote:
> > > On Friday, September 05, 2014 at 12:32:40 PM, Yao Yuan wrote:
> > > [...]
> > >
> > > > > > +static int i2c_imx_dma_write(struct imx_i2c_struct *i2c_imx,
> > > > > > +					struct i2c_msg *msgs)
> > > > > > +{
> > > > > > +	int result;
> > > > > > +	unsigned int temp = 0;
> > > > > > +	unsigned long orig_jiffies = jiffies;
> > > > > > +	struct imx_i2c_dma *dma = i2c_imx->dma;
> > > > > > +	struct device *dev = &i2c_imx->adapter.dev;
> > > > > > +
> > > > > > +	dev_dbg(dev, "<%s> write slave address: addr=0x%x\n",
> > > > > > +		__func__, msgs->addr << 1);
> > > > > > +
> > > > > > +	reinit_completion(&i2c_imx->dma->cmd_complete);
> > > > > > +	dma->chan_using = dma->chan_tx;
> > > > > > +	dma->dma_transfer_dir = DMA_MEM_TO_DEV;
> > > > > > +	dma->dma_data_dir = DMA_TO_DEVICE;
> > > > > > +	dma->dma_len = msgs->len - 1;
> > > > > > +	result = i2c_imx_dma_xfer(i2c_imx, msgs);
> > > > > > +	if (result)
> > > > > > +		return result;
> > > > > > +
> > > > > > +	temp = imx_i2c_read_reg(i2c_imx, IMX_I2C_I2CR);
> > > > > > +	temp |= I2CR_DMAEN;
> > > > > > +	imx_i2c_write_reg(temp, i2c_imx, IMX_I2C_I2CR);
> > > > > > +
> > > > > > +	/*
> > > > > > +	 * Write slave address.
> > > > > > +	 * The first byte muse be transmitted by the CPU.
> > > > > > +	 */
> > > > > > +	imx_i2c_write_reg(msgs->addr << 1, i2c_imx, IMX_I2C_I2DR);
> > > > > > +	result = wait_for_completion_interruptible_timeout(
> > > > > > +				&i2c_imx->dma->cmd_complete,
> > > > > > +				msecs_to_jiffies(IMX_I2C_DMA_TIMEOUT));
> > > > > > +	if (result <= 0) {
> > > > > > +		dmaengine_terminate_all(dma->chan_using);
> > > > > > +		if (result)
> > > > > > +			return result;
> > > > > > +		else
> > > > > > +			return -ETIMEDOUT;
> > > > >
> > > > > Shouldn't you force-disable the DMA here somehow (like unsetting
> > > > > I2CR_DMAEN bit), if it failed or timed out?
> > > >
> > > > [Yuan Yao] Yes, I put the code for force-disable DMA in
> > > > i2c_imx_start(). In order to make sure any DMA error will not
> > > > effect the I2C.
> > > > It seems almost the same as put the code here, how about your think?
> > >
> > > Would that mean that the "crashed" DMA would be running until the
> > > next transmission is scheduled ?
> >
> > [Yuan Yao] No, In fact any DMA timeout will result the failure of I2C
> > transmission and then it will turn to report the exception and wait
> > for next transmission.
> 
> Can you tell when the next transmission will happen? What if I issue a
> single transmission and that one fails ? Will the DMA run until who knows
> when ?

[Yuan Yao] 
Sorry for my unclear description. In fact, During the DMA transmission  if
an error happened or time out, DMA will stop at once and be disabled.
I just continue to route the TX and RX request to signal the DMA controller.
Because the DMA is disabled, it will ignore those signals.

In a word, I just want to block the I2C TX, RX and interrupt signal when
DMA mode failed until the next I2C transmission start.

In fact, the bit "I2CR_DMAEN" is a switch which decide whether I2C route
the TX, RX and interrupt signal to DMA controller. 

> > The only thing I worried about is I2C may still receive some feedbacks
> > after DMA timeout. In this case the feedbacks may lead to abnormal
> > state in PIO mode.But it will be ignored in DMA model.
> > That's why I tend to delay force-disable DMA until the next
> > transmission begin. Could you please give me some suggestion?
> 
> No, this design just seems flawed to me. You should stop the DMA
> immediatelly if there is an error to avoid wasting resources and prevent
> possible other adverse effects.
>
[Yuan Yao] 
Yes, I have stopped the DMA immediately. However I keep the I2C DMA
single route.

I don't have the exact evidence to prove that my design is acceptable.
So if you are sure it's flawed, I will change it in the next version(V8).

Best regards,
Yuan Yao
