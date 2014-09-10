Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751711AbaIJPC5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 11:02:57 -0400
Received: from mail-bl2on0145.outbound.protection.outlook.com ([65.55.169.145]:13117
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750734AbaIJPCz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 11:02:55 -0400
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
Thread-Index: AQHPtuKa1yGA2bLpA0aZlDBgfnstDpvxLheAgADaxYCAAHUPAIAGMlDg
Date: Wed, 10 Sep 2014 14:48:01 +0000
Message-ID: <1410360473732.53953@freescale.com>
References: <1407923215-3749-1-git-send-email-yao.yuan@freescale.com>
 <201409041638.45537.marex@denx.de>
 <c10c1960255e4dbca2a281b995290c6d@BL2PR03MB338.namprd03.prod.outlook.com>
 <201409051240.44469.marex@denx.de>
In-Reply-To: <201409051240.44469.marex@denx.de>
Accept-Language: en-US, zh-CN
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [124.202.191.141]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:;UriScan:;
x-forefront-prvs: 033054F29A
x-forefront-antispam-report: SFV:NSPM;SFS:(10019019)(979002)(6009001)(189002)(24454002)(51704005)(199003)(377454003)(83072002)(83322001)(85852003)(101416001)(86362001)(99396002)(4396001)(2656002)(81342001)(64706001)(20776003)(85306004)(93886004)(74662001)(106356001)(107046002)(80022001)(106116001)(21056001)(36756003)(92726001)(76482001)(46102001)(74502001)(50986999)(19580395003)(31966008)(77982001)(97736003)(66066001)(95666004)(79102001)(117636001)(54356999)(110136001)(92566001)(99286002)(81542001)(76176999)(105586002)(87936001)(90102001)(969003)(989001)(999001)(1009001)(1019001);DIR:OUT;SFP:1102;SCL:1;SRVR:BL2PR03MB369;H:BL2PR03MB338.namprd03.prod.outlook.com;FPR:;MLV:ovrnspm;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, September 05, 2014 6:41 PM, Marek Vasut wrote:
> On Friday, September 05, 2014 at 12:32:40 PM, Yao Yuan wrote:
> [...]
> > > > +static int i2c_imx_dma_write(struct imx_i2c_struct *i2c_imx,
> > > > +					struct i2c_msg *msgs)
> > > > +{
> > > > +	int result;
> > > > +	unsigned int temp = 0;
> > > > +	unsigned long orig_jiffies = jiffies;
> > > > +	struct imx_i2c_dma *dma = i2c_imx->dma;
> > > > +	struct device *dev = &i2c_imx->adapter.dev;
> > > > +
> > > > +	dev_dbg(dev, "<%s> write slave address: addr=0x%x\n",
> > > > +		__func__, msgs->addr << 1);
> > > > +
> > > > +	reinit_completion(&i2c_imx->dma->cmd_complete);
> > > > +	dma->chan_using = dma->chan_tx;
> > > > +	dma->dma_transfer_dir = DMA_MEM_TO_DEV;
> > > > +	dma->dma_data_dir = DMA_TO_DEVICE;
> > > > +	dma->dma_len = msgs->len - 1;
> > > > +	result = i2c_imx_dma_xfer(i2c_imx, msgs);
> > > > +	if (result)
> > > > +		return result;
> > > > +
> > > > +	temp = imx_i2c_read_reg(i2c_imx, IMX_I2C_I2CR);
> > > > +	temp |= I2CR_DMAEN;
> > > > +	imx_i2c_write_reg(temp, i2c_imx, IMX_I2C_I2CR);
> > > > +
> > > > +	/*
> > > > +	 * Write slave address.
> > > > +	 * The first byte muse be transmitted by the CPU.
> > > > +	 */
> > > > +	imx_i2c_write_reg(msgs->addr << 1, i2c_imx, IMX_I2C_I2DR);
> > > > +	result = wait_for_completion_interruptible_timeout(
> > > > +				&i2c_imx->dma->cmd_complete,
> > > > +				msecs_to_jiffies(IMX_I2C_DMA_TIMEOUT));
> > > > +	if (result <= 0) {
> > > > +		dmaengine_terminate_all(dma->chan_using);
> > > > +		if (result)
> > > > +			return result;
> > > > +		else
> > > > +			return -ETIMEDOUT;
> > >
> > > Shouldn't you force-disable the DMA here somehow (like unsetting
> > > I2CR_DMAEN bit), if it failed or timed out?
> >
> > [Yuan Yao] Yes, I put the code for force-disable DMA in i2c_imx_start().
> > In order to make sure any DMA error will not effect the I2C.
> > It seems almost the same as put the code here, how about your think?
> 
> Would that mean that the "crashed" DMA would be running until the next
> transmission is scheduled ?
> 
[Yuan Yao] No, In fact any DMA timeout will result the failure of I2C transmission
and then it will turn to report the exception and wait for next transmission.
The only thing I worried about is I2C may still receive some feedbacks after DMA timeout.
In this case the feedbacks may lead to abnormal state in PIO mode.But it will be ignored
in DMA model.
That's why I tend to delay force-disable DMA until the next transmission begin.
Could you please give me some suggestion?

Thanks & Best regards,
Yuan Yao