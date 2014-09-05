Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932238AbaIEMGE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 08:06:04 -0400
Received: from mail-bl2on0134.outbound.protection.outlook.com ([65.55.169.134]:27376
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756840AbaIEMGB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 08:06:01 -0400
X-Greylist: delayed 3602 seconds by postgrey-1.27 at vger.kernel.org; Fri, 05 Sep 2014 08:06:01 EDT
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
Thread-Index: AQHPtuKa1yGA2bLpA0aZlDBgfnstDpvxLheAgADaxYA=
Date: Fri, 5 Sep 2014 10:32:40 +0000
Message-ID: <c10c1960255e4dbca2a281b995290c6d@BL2PR03MB338.namprd03.prod.outlook.com>
References: <1407923215-3749-1-git-send-email-yao.yuan@freescale.com>
 <1407923215-3749-2-git-send-email-yao.yuan@freescale.com>
 <201409041638.45537.marex@denx.de>
In-Reply-To: <201409041638.45537.marex@denx.de>
Accept-Language: en-US, zh-CN
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [123.151.195.50]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:;UriScan:;
x-forefront-prvs: 0325F6C77B
x-forefront-antispam-report: SFV:NSPM;SFS:(10019016)(6009001)(189002)(377454003)(199003)(24454002)(51704005)(81342001)(66066001)(80022001)(85852003)(76482001)(46102001)(74502001)(64706001)(20776003)(33646002)(77982001)(2656002)(79102001)(76576001)(106116001)(74316001)(87936001)(83072002)(101416001)(86362001)(90102001)(19580395003)(19580405001)(83322001)(31966008)(105586002)(107046002)(92566001)(85306004)(54356999)(108616004)(76176999)(99396002)(4396001)(50986999)(110136001)(21056001)(99286002)(95666004)(74662001)(106356001)(81542001)(24736002);DIR:OUT;SFP:1102;SCL:1;SRVR:BL2PR03MB370;H:BL2PR03MB338.namprd03.prod.outlook.com;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, September 04, 2014 10:39 PM, Marek Vasut wrote:
> On Wednesday, August 13, 2014 at 11:46:54 AM, Yuan Yao wrote:
> > Add dma support for i2c. This function depend on DMA driver.
> > You can turn on it by write both the dmas and dma-name properties in
> > dts node. DMA is optional, even DMA request unsuccessfully, i2c can
> > also work well.
> >
> > Signed-off-by: Yuan Yao <yao.yuan@freescale.com>
> 
> [...]
> 
> > +/* Enable DMA if transfer byte size is bigger than this threshold.
> > + * As the hardware request, it must bigger than 4.
> 
> The comment is unclear, just by reading it, I have no clue what are the
> units for this value. I can guess those would be bytes, but it would be a
> good idea to be explicit.
> 
> Also, wasn't kernel comment style starting with leading /* , with the
> text starting only on the next line ?
> 

[Yuan Yao] Thanks for your review. I will correct it in the next version.

> > + */
> > +#define IMX_I2C_DMA_THRESHOLD	16
> > +#define IMX_I2C_DMA_TIMEOUT	1000
> > +
> 
> [...]
> 
> > +static int i2c_imx_dma_write(struct imx_i2c_struct *i2c_imx,
> > +					struct i2c_msg *msgs)
> > +{
> > +	int result;
> > +	unsigned int temp = 0;
> > +	unsigned long orig_jiffies = jiffies;
> > +	struct imx_i2c_dma *dma = i2c_imx->dma;
> > +	struct device *dev = &i2c_imx->adapter.dev;
> > +
> > +	dev_dbg(dev, "<%s> write slave address: addr=0x%x\n",
> > +		__func__, msgs->addr << 1);
> > +
> > +	reinit_completion(&i2c_imx->dma->cmd_complete);
> > +	dma->chan_using = dma->chan_tx;
> > +	dma->dma_transfer_dir = DMA_MEM_TO_DEV;
> > +	dma->dma_data_dir = DMA_TO_DEVICE;
> > +	dma->dma_len = msgs->len - 1;
> > +	result = i2c_imx_dma_xfer(i2c_imx, msgs);
> > +	if (result)
> > +		return result;
> > +
> > +	temp = imx_i2c_read_reg(i2c_imx, IMX_I2C_I2CR);
> > +	temp |= I2CR_DMAEN;
> > +	imx_i2c_write_reg(temp, i2c_imx, IMX_I2C_I2CR);
> > +
> > +	/*
> > +	 * Write slave address.
> > +	 * The first byte muse be transmitted by the CPU.
> > +	 */
> > +	imx_i2c_write_reg(msgs->addr << 1, i2c_imx, IMX_I2C_I2DR);
> > +	result = wait_for_completion_interruptible_timeout(
> > +				&i2c_imx->dma->cmd_complete,
> > +				msecs_to_jiffies(IMX_I2C_DMA_TIMEOUT));
> > +	if (result <= 0) {
> > +		dmaengine_terminate_all(dma->chan_using);
> > +		if (result)
> > +			return result;
> > +		else
> > +			return -ETIMEDOUT;
> 
> Shouldn't you force-disable the DMA here somehow (like unsetting
> I2CR_DMAEN bit), if it failed or timed out?

[Yuan Yao] Yes, I put the code for force-disable DMA in i2c_imx_start().
In order to make sure any DMA error will not effect the I2C.
It seems almost the same as put the code here, how about your think?

Thanks!

> > +	}
> > +
> > +	/* Waiting for Transfer complete. */
> > +	while (1) {
> > +		temp = imx_i2c_read_reg(i2c_imx, IMX_I2C_I2SR);
> > +		if (temp & I2SR_ICF)
> > +			break;
> > +		if (time_after(jiffies, orig_jiffies +
> > +				msecs_to_jiffies(IMX_I2C_DMA_TIMEOUT))) {
> > +			dev_dbg(&i2c_imx->adapter.dev, "<%s> Timeout\n",
> > +				__func__);
> > +			return -ETIMEDOUT;
> > +		}
> > +		schedule();
> > +	}
> > +
> > +	temp = imx_i2c_read_reg(i2c_imx, IMX_I2C_I2CR);
> > +	temp &= ~I2CR_DMAEN;
> > +	imx_i2c_write_reg(temp, i2c_imx, IMX_I2C_I2CR);
> > +
> > +	/* The last data byte must be transferred by the CPU. */
> > +	imx_i2c_write_reg(msgs->buf[msgs->len-1],
> > +				i2c_imx, IMX_I2C_I2DR);
> > +	result = i2c_imx_trx_complete(i2c_imx);
> > +	if (result)
> > +		return result;
> > +
> > +	result = i2c_imx_acked(i2c_imx);
> > +	if (result)
> > +		return result;
> > +
> > +	return 0;
> > +}
> [...]
> 
> Thanks!
