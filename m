Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751823AbaB0Ujy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 15:39:54 -0500
Received: from mail-out.m-online.net ([212.18.0.9]:33203 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751640AbaB0Ujx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 15:39:53 -0500
X-Auth-Info: GIaPffbUqYg9Hskkn9cJCUch2/y8WMkgXPG9yY/n9kE=
From: Marek Vasut <marex@denx.de>
To: linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/3] i2c: add DMA support for freescale i2c driver
Date: Thu, 27 Feb 2014 21:39:35 +0100
User-Agent: KMail/1.13.7 (Linux/3.13-trunk-amd64; KDE/4.11.3; x86_64; ; )
Cc: Yuan Yao <yao.yuan@freescale.com>, wsa@the-dreams.de, mark.rutland@arm.com,
        shawn.guo@linaro.org, linux-kernel@vger.kernel.org,
        linux-i2c@vger.kernel.org
References: <1393481115-22136-1-git-send-email-yao.yuan@freescale.com> <1393481115-22136-2-git-send-email-yao.yuan@freescale.com>
In-Reply-To: <1393481115-22136-2-git-send-email-yao.yuan@freescale.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201402272139.36076.marex@denx.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, February 27, 2014 at 07:05:14 AM, Yuan Yao wrote:

[...]

> *****/ @@ -63,6 +68,9 @@
>  /* Default value */
>  #define IMX_I2C_BIT_RATE	100000	/* 100kHz */
> 
> +/* enable DMA if transfer size is bigger than this threshold */
> +#define IMX_I2C_DMA_THRESHOLD	16

So what's the unit here , potatoes or beers or what ? I suppose it's bytes , but 
please make it explicit in the comment ...

[...]

>  static const struct imx_i2c_hwdata imx1_i2c_hwdata  = {
> @@ -193,6 +216,7 @@ static const struct imx_i2c_hwdata imx1_i2c_hwdata  = {
>  	.ndivs			= ARRAY_SIZE(imx_i2c_clk_div),
>  	.i2sr_clr_opcode	= I2SR_CLR_OPCODE_W0C,
>  	.i2cr_ien_opcode	= I2CR_IEN_OPCODE_1,
> +	.has_dma_support	= false,
> 
>  };
> 
> @@ -203,6 +227,7 @@ static const struct imx_i2c_hwdata imx21_i2c_hwdata  =
> { .ndivs			= ARRAY_SIZE(imx_i2c_clk_div),
>  	.i2sr_clr_opcode	= I2SR_CLR_OPCODE_W0C,
>  	.i2cr_ien_opcode	= I2CR_IEN_OPCODE_1,
> +	.has_dma_support	= false,
> 
>  };
> 
> @@ -213,6 +238,7 @@ static struct imx_i2c_hwdata vf610_i2c_hwdata = {
>  	.ndivs			= ARRAY_SIZE(vf610_i2c_clk_div),
>  	.i2sr_clr_opcode	= I2SR_CLR_OPCODE_W1C,
>  	.i2cr_ien_opcode	= I2CR_IEN_OPCODE_0,
> +	.has_dma_support	= true,

So why exactly don't we have a DT prop for determining whether the controller 
has DMA support ?

What about the other controllers, do they not support DMA for some specific 
reason? Please elaborate on that, thank you !
[...]

> +static void i2c_imx_dma_tx_callback(void *arg)
[...]
> +static int i2c_imx_dma_tx(struct imx_i2c_struct *i2c_imx, struct i2c_msg
> *msgs) +{
[...]
> +static void i2c_imx_dma_rx_callback(void *arg)
[...]
> +static int i2c_imx_dma_rx(struct imx_i2c_struct *i2c_imx, struct i2c_msg
> *msgs) +{
[...]

Looks like there's quite a bit of code duplication in the four functions above, 
can you not unify them ?

Also, can the DMA not do full-duplex operation ? What I see here is just half-
duplex operations , one for RX and the other one for TX .

> +static void i2c_imx_dma_free(struct imx_i2c_struct *i2c_imx)
> +{
> +	struct imx_i2c_dma *dma = i2c_imx->dma;
> +	struct dma_chan *dma_chan;
> +
> +	dma_chan = dma->chan_tx;
> +	dma->chan_tx = NULL;
> +	dma->buf_tx = 0;
> +	dma->len_tx = 0;
> +	dma_release_channel(dma_chan);
> +
> +	dma_chan = dma->chan_rx;
> +	dma->chan_tx = NULL;
> +	dma->buf_rx = 0;
> +	dma->len_rx = 0;
> +	dma_release_channel(dma_chan);

You must make _DEAD_ _SURE_ this function is not ever called while the DMA is 
still active. In your case, I have a feeling that's not handled.

> +}
>  /** Functions for IMX I2C adapter driver
> ***************************************
> **************************************************************************
> *****/
> 
> @@ -425,7 +600,8 @@ static irqreturn_t i2c_imx_isr(int irq, void *dev_id)
>  	return IRQ_NONE;
>  }
> 
> -static int i2c_imx_write(struct imx_i2c_struct *i2c_imx, struct i2c_msg
> *msgs) +static int i2c_imx_pio_write(struct imx_i2c_struct *i2c_imx,
> +							struct i2c_msg *msgs)
>  {
>  	int i, result;
> 
> @@ -458,7 +634,56 @@ static int i2c_imx_write(struct imx_i2c_struct
> *i2c_imx, struct i2c_msg *msgs) return 0;
>  }
> 
> -static int i2c_imx_read(struct imx_i2c_struct *i2c_imx, struct i2c_msg
> *msgs) +static int i2c_imx_dma_write(struct imx_i2c_struct *i2c_imx,
> +							struct i2c_msg *msgs)
> +{
> +	int result, timeout=1000;
> +	unsigned int temp = 0;
> +
> +	reinit_completion(&i2c_imx->dma->cmd_complete);
> +	result = i2c_imx_dma_tx(i2c_imx, msgs);
> +	if(result)
> +		return result;
> +
> +	temp = imx_i2c_read_reg(i2c_imx, IMX_I2C_I2CR);
> +	temp |= I2CR_DMAEN;
> +	imx_i2c_write_reg(temp, i2c_imx, IMX_I2C_I2CR);
> +
> +	/* write slave address */
> +	imx_i2c_write_reg(msgs->addr << 1, i2c_imx, IMX_I2C_I2DR);
> +	result = wait_for_completion_interruptible_timeout(
> +						&i2c_imx->dma->cmd_complete,
> +						msecs_to_jiffies(1000));

Pull the magic constant of 1000 out and #define it as some I2C_IMX_DMA_TIMEOUT 
please .

> +	if (result == 0)
> +		return  -ETIMEDOUT;
> +
> +	/* waiting for Transfer complete. */
> +	while(timeout--) {
> +		temp = imx_i2c_read_reg(i2c_imx, IMX_I2C_I2SR);
> +		if (temp & 0x80)
> +			break;
> +		udelay(10);
> +	}
> +
> +	temp = imx_i2c_read_reg(i2c_imx, IMX_I2C_I2CR);
> +	temp &= ~I2CR_DMAEN;
> +	imx_i2c_write_reg(temp, i2c_imx, IMX_I2C_I2CR);
> +
> +	/* write the last byte */
> +	imx_i2c_write_reg(msgs->buf[msgs->len-1], i2c_imx, IMX_I2C_I2DR);
> +	result = i2c_imx_trx_complete(i2c_imx);
> +	if (result)
> +		return result;
> +
> +	result = i2c_imx_acked(i2c_imx);
> +	if (result)
> +		return result;
> +
> +	return 0;
> +}
> +
> +static int i2c_imx_pio_read(struct imx_i2c_struct *i2c_imx,
> +							struct i2c_msg *msgs)
>  {
>  	int i, result;
>  	unsigned int temp;
> @@ -518,6 +743,80 @@ static int i2c_imx_read(struct imx_i2c_struct
> *i2c_imx, struct i2c_msg *msgs) return 0;
>  }
> 
> +static int i2c_imx_dma_read(struct imx_i2c_struct *i2c_imx,
> +							struct i2c_msg *msgs)
> +{

Looks like almost an duplication as well...

Besides, full-duplex DMA operation is missing, please explain why.

THanks!
