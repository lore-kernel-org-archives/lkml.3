Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754938AbaCZDKk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 23:10:40 -0400
Received: from [207.46.163.204] ([207.46.163.204]:21201 "EHLO
	na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752779AbaCZDKi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 23:10:38 -0400
From: Yao Yuan <yao.yuan@freescale.com>
To: Marek Vasut <marex@denx.de>
CC: "wsa@the-dreams.de" <wsa@the-dreams.de>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "shawn.guo@linaro.org" <shawn.guo@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>
Subject: RE: [PATCH v3 1/2] i2c: add DMA support for freescale i2c driver
Thread-Topic: [PATCH v3 1/2] i2c: add DMA support for freescale i2c driver
Thread-Index: AQHPPmRgi32QYprDqku8DK7ziduPl5ruGRqAgASY2hA=
Date: Wed, 26 Mar 2014 03:08:27 +0000
Message-ID: <1e17ce716618472f9a0146c48f20b976@BL2PR03MB338.namprd03.prod.outlook.com>
References: <1394675277-24913-1-git-send-email-yao.yuan@freescale.com>
 <1394675277-24913-2-git-send-email-yao.yuan@freescale.com>
 <201403230449.51515.marex@denx.de>
In-Reply-To: <201403230449.51515.marex@denx.de>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [123.151.195.50]
x-forefront-prvs: 0162ACCC24
x-forefront-antispam-report: SFV:NSPM;SFS:(10009001)(6009001)(428001)(51704005)(377454003)(24454002)(199002)(189002)(54534003)(63696002)(97336001)(74662001)(74316001)(74502001)(90146001)(85852003)(50986001)(47736001)(20776003)(31966008)(47976001)(74706001)(81542001)(19580405001)(33646001)(4396001)(74876001)(83072002)(47446002)(49866001)(65816001)(97186001)(80022001)(69226001)(66066001)(81342001)(85306002)(46102001)(59766001)(93136001)(76576001)(80976001)(51856001)(83322001)(95416001)(54356001)(87266001)(94316002)(87936001)(19580395003)(93516002)(86362001)(94946001)(95666003)(53806001)(92566001)(98676001)(81816001)(74366001)(77982001)(2656002)(54316002)(76482001)(81686001)(79102001)(56776001)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:BL2PR03MB339;H:BL2PR03MB338.namprd03.prod.outlook.com;FPR:A6B00053.7FFEA427.31E4B38B.50D8B882.201F7;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s2Q3BOLA026830

On Sunday, March 23, 2014 @ 11:50:00 AM, Marek Vasut wrote:
> On Thursday, March 13, 2014 at 02:47:56 AM, Yuan Yao wrote:
> > Add dma support for i2c. This function depend on DMA driver.
> > You can turn on it by write both the dmas and dma-name properties in
> > dts node.
> >
> > Signed-off-by: Yuan Yao <yao.yuan@freescale.com>
> > ---
> >  drivers/i2c/busses/i2c-imx.c | 354
> > +++++++++++++++++++++++++++++++++++++------ 1 file changed, 306
> > insertions(+), 48 deletions(-)
> 
> Changelog is missing.

Sorry for this, Maybe the changelog is in the junk box. It's named "[PATCH v3 0/2] i2c: add DMA support for freescale i2c driver". 

> [...]
> 
> > +/* Functions for DMA support */
> > +static int i2c_imx_dma_request(struct imx_i2c_struct *i2c_imx,
> > +						dma_addr_t phy_addr)
> > +{
> > +	struct imx_i2c_dma *dma = i2c_imx->dma;
> > +	struct dma_slave_config dma_sconfig;
> > +	struct device *dev = &i2c_imx->adapter.dev;
> > +	int ret;
> > +
> > +	dma->chan_tx = dma_request_slave_channel(dev, "tx");
> > +	if (!dma->chan_tx) {
> > +		dev_err(dev, "Dma tx channel request failed!\n");
> 
> DMA is written in all caps, it's an abbrev. for Direct Memory Access .
> Please fix globally.
> 

Ok, I will fix it globally.

> [...]
> 
> >  static int i2c_imx_write(struct imx_i2c_struct *i2c_imx, struct
> > i2c_msg
> > *msgs) {
> 
> [...]
> 
> > -	/* write data */
> > -	for (i = 0; i < msgs->len; i++) {
> > -		dev_dbg(&i2c_imx->adapter.dev,
> > -			"<%s> write byte: B%d=0x%X\n",
> > -			__func__, i, msgs->buf[i]);
> > -		imx_i2c_write_reg(msgs->buf[i], i2c_imx, IMX_I2C_I2DR);
> > +		temp = imx_i2c_read_reg(i2c_imx, IMX_I2C_I2CR);
> > +		temp |= I2CR_DMAEN;
> > +		imx_i2c_write_reg(temp, i2c_imx, IMX_I2C_I2CR);
> > +
> > +		/* write slave address */
> > +		imx_i2c_write_reg(msgs->addr << 1, i2c_imx, IMX_I2C_I2DR);
> > +		result = wait_for_completion_interruptible_timeout(
> > +					&i2c_imx->dma->cmd_complete,
> > +					msecs_to_jiffies(IMX_I2C_DMA_TIMEOUT));
> > +		if (result <= 0) {
> > +			dmaengine_terminate_all(dma->chan_using);
> > +			if (result)
> > +				return result;
> > +			else
> > +				return -ETIMEDOUT;
> > +		}
> > +
> > +		/* waiting for Transfer complete. */
> > +		while (timeout--) {
> > +			temp = imx_i2c_read_reg(i2c_imx, IMX_I2C_I2SR);
> > +			if (temp & I2SR_ICF)
> > +				break;
> > +			udelay(10);
> > +		}
> 
> Do you ever check if this really timed out and handle such case at all ?
> I don't see it , but I might be wrong ...
> 

Oh, It's a bug, Thank you very much.

> > +		temp = imx_i2c_read_reg(i2c_imx, IMX_I2C_I2CR);
> > +		temp &= ~I2CR_DMAEN;
> > +		imx_i2c_write_reg(temp, i2c_imx, IMX_I2C_I2CR);
> > +
> > +		/* write the last byte */
> > +		imx_i2c_write_reg(msgs->buf[msgs->len-1],
> > +					i2c_imx, IMX_I2C_I2DR);
> >  		result = i2c_imx_trx_complete(i2c_imx);
> >  		if (result)
> >  			return result;
> > +
> >  		result = i2c_imx_acked(i2c_imx);
> >  		if (result)
> >  			return result;
> > +	} else {
> > +		/* write slave address */
> > +		imx_i2c_write_reg(msgs->addr << 1, i2c_imx, IMX_I2C_I2DR);
> > +		result = i2c_imx_trx_complete(i2c_imx);
> > +		if (result)
> > +			return result;
> > +
> > +		result = i2c_imx_acked(i2c_imx);
> > +		if (result)
> > +			return result;
> > +
> > +		dev_dbg(&i2c_imx->adapter.dev, "<%s> write data\n", __func__);
> > +
> > +		/* write data */
> > +		for (i = 0; i < msgs->len; i++) {
> > +			dev_dbg(&i2c_imx->adapter.dev,
> > +				"<%s> write byte: B%d=0x%X\n",
> > +				__func__, i, msgs->buf[i]);
> 
> Can you not just have a variable $dev here and avoid having such a long
> noodle in the dev_dbg() call ?
> 

Ok, And I don't think the dev_dbg() is very helpful here now. 

> > +			imx_i2c_write_reg(msgs->buf[i], i2c_imx, IMX_I2C_I2DR);
> > +			result = i2c_imx_trx_complete(i2c_imx);
> > +			if (result)
> > +				return result;
> > +			result = i2c_imx_acked(i2c_imx);
> > +			if (result)
> > +				return result;
> > +		}
> >  	}
> >  	return 0;
> >  }
> [...]
> 
> > +		/* waiting for Transfer complete. */
> > +		while (timeout--) {
> > +			temp = imx_i2c_read_reg(i2c_imx, IMX_I2C_I2SR);
> > +			if (temp & I2SR_ICF)
> > +				break;
> > +			udelay(10);
> > +		}
> 
> Timeout handling here as well ...
> 
> [...]
> 
> > @@ -696,6 +936,21 @@ static int i2c_imx_probe(struct platform_device
> *pdev)
> >  		i2c_imx->adapter.name);
> >  	dev_info(&i2c_imx->adapter.dev, "IMX I2C adapter registered\n");
> >
> > +	/* Init DMA config if support*/
> > +	i2c_imx->dma = devm_kzalloc(&pdev->dev, sizeof(struct imx_i2c_dma),
> > +					GFP_KERNEL);
> > +	if (!i2c_imx->dma) {
> > +		dev_info(&pdev->dev,
> > +				"can't allocate dma struct faild use dma.\n");
> 
> Or just have $dev variable and you won't have to break the line at all ...
> 
> > +		i2c_imx->use_dma = false;
> > +	} else if (i2c_imx_dma_request(i2c_imx, (dma_addr_t)phy_addr)) {
> > +		dev_info(&pdev->dev,
> > +				"can't request dma chan, faild use dma.\n");
> > +		i2c_imx->use_dma = false;
> > +	} else {
> > +		i2c_imx->use_dma = true;
> > +	}
> 
> Can you not just check if i2c_imx->dma is valid pointer or NULL pointer ?
> Then you won't need a separate variable, for this purpose ... right ?

Sorry and I think what I know is just to check whether it is NULL.
Then for the second question, maybe there are some other ways, But I think it is more tidy and easier 
understanding for using a separate variable, for this purpose.

> [...]
> 

Best regards,
Yuan Yao
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
