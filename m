Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751883AbaCWDt4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Mar 2014 23:49:56 -0400
Received: from mail-out.m-online.net ([212.18.0.10]:49766 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750798AbaCWDty (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Mar 2014 23:49:54 -0400
X-Auth-Info: q5NOOygc9dCNpeoomn96XqLTnYMrJYQyapZJYtIB/mA=
From: Marek Vasut <marex@denx.de>
To: Yuan Yao <yao.yuan@freescale.com>
Subject: Re: [PATCH v3 1/2] i2c: add DMA support for freescale i2c driver
Date: Sun, 23 Mar 2014 04:49:51 +0100
User-Agent: KMail/1.13.7 (Linux/3.13-trunk-amd64; KDE/4.11.3; x86_64; ; )
Cc: wsa@the-dreams.de, mark.rutland@arm.com, shawn.guo@linaro.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-i2c@vger.kernel.org
References: <1394675277-24913-1-git-send-email-yao.yuan@freescale.com> <1394675277-24913-2-git-send-email-yao.yuan@freescale.com>
In-Reply-To: <1394675277-24913-2-git-send-email-yao.yuan@freescale.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201403230449.51515.marex@denx.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, March 13, 2014 at 02:47:56 AM, Yuan Yao wrote:
> Add dma support for i2c. This function depend on DMA driver.
> You can turn on it by write both the dmas and dma-name properties in dts
> node.
> 
> Signed-off-by: Yuan Yao <yao.yuan@freescale.com>
> ---
>  drivers/i2c/busses/i2c-imx.c | 354
> +++++++++++++++++++++++++++++++++++++------ 1 file changed, 306
> insertions(+), 48 deletions(-)

Changelog is missing.

[...]

> +/* Functions for DMA support */
> +static int i2c_imx_dma_request(struct imx_i2c_struct *i2c_imx,
> +						dma_addr_t phy_addr)
> +{
> +	struct imx_i2c_dma *dma = i2c_imx->dma;
> +	struct dma_slave_config dma_sconfig;
> +	struct device *dev = &i2c_imx->adapter.dev;
> +	int ret;
> +
> +	dma->chan_tx = dma_request_slave_channel(dev, "tx");
> +	if (!dma->chan_tx) {
> +		dev_err(dev, "Dma tx channel request failed!\n");

DMA is written in all caps, it's an abbrev. for Direct Memory Access . Please 
fix globally.

[...]

>  static int i2c_imx_write(struct imx_i2c_struct *i2c_imx, struct i2c_msg
> *msgs) {

[...]

> -	/* write data */
> -	for (i = 0; i < msgs->len; i++) {
> -		dev_dbg(&i2c_imx->adapter.dev,
> -			"<%s> write byte: B%d=0x%X\n",
> -			__func__, i, msgs->buf[i]);
> -		imx_i2c_write_reg(msgs->buf[i], i2c_imx, IMX_I2C_I2DR);
> +		temp = imx_i2c_read_reg(i2c_imx, IMX_I2C_I2CR);
> +		temp |= I2CR_DMAEN;
> +		imx_i2c_write_reg(temp, i2c_imx, IMX_I2C_I2CR);
> +
> +		/* write slave address */
> +		imx_i2c_write_reg(msgs->addr << 1, i2c_imx, IMX_I2C_I2DR);
> +		result = wait_for_completion_interruptible_timeout(
> +					&i2c_imx->dma->cmd_complete,
> +					msecs_to_jiffies(IMX_I2C_DMA_TIMEOUT));
> +		if (result <= 0) {
> +			dmaengine_terminate_all(dma->chan_using);
> +			if (result)
> +				return result;
> +			else
> +				return -ETIMEDOUT;
> +		}
> +
> +		/* waiting for Transfer complete. */
> +		while (timeout--) {
> +			temp = imx_i2c_read_reg(i2c_imx, IMX_I2C_I2SR);
> +			if (temp & I2SR_ICF)
> +				break;
> +			udelay(10);
> +		}

Do you ever check if this really timed out and handle such case at all ? I don't 
see it , but I might be wrong ...

> +		temp = imx_i2c_read_reg(i2c_imx, IMX_I2C_I2CR);
> +		temp &= ~I2CR_DMAEN;
> +		imx_i2c_write_reg(temp, i2c_imx, IMX_I2C_I2CR);
> +
> +		/* write the last byte */
> +		imx_i2c_write_reg(msgs->buf[msgs->len-1],
> +					i2c_imx, IMX_I2C_I2DR);
>  		result = i2c_imx_trx_complete(i2c_imx);
>  		if (result)
>  			return result;
> +
>  		result = i2c_imx_acked(i2c_imx);
>  		if (result)
>  			return result;
> +	} else {
> +		/* write slave address */
> +		imx_i2c_write_reg(msgs->addr << 1, i2c_imx, IMX_I2C_I2DR);
> +		result = i2c_imx_trx_complete(i2c_imx);
> +		if (result)
> +			return result;
> +
> +		result = i2c_imx_acked(i2c_imx);
> +		if (result)
> +			return result;
> +
> +		dev_dbg(&i2c_imx->adapter.dev, "<%s> write data\n", __func__);
> +
> +		/* write data */
> +		for (i = 0; i < msgs->len; i++) {
> +			dev_dbg(&i2c_imx->adapter.dev,
> +				"<%s> write byte: B%d=0x%X\n",
> +				__func__, i, msgs->buf[i]);

Can you not just have a variable $dev here and avoid having such a long noodle 
in the dev_dbg() call ?

> +			imx_i2c_write_reg(msgs->buf[i], i2c_imx, IMX_I2C_I2DR);
> +			result = i2c_imx_trx_complete(i2c_imx);
> +			if (result)
> +				return result;
> +			result = i2c_imx_acked(i2c_imx);
> +			if (result)
> +				return result;
> +		}
>  	}
>  	return 0;
>  }
[...]

> +		/* waiting for Transfer complete. */
> +		while (timeout--) {
> +			temp = imx_i2c_read_reg(i2c_imx, IMX_I2C_I2SR);
> +			if (temp & I2SR_ICF)
> +				break;
> +			udelay(10);
> +		}

Timeout handling here as well ...

[...]

> @@ -696,6 +936,21 @@ static int i2c_imx_probe(struct platform_device *pdev)
>  		i2c_imx->adapter.name);
>  	dev_info(&i2c_imx->adapter.dev, "IMX I2C adapter registered\n");
> 
> +	/* Init DMA config if support*/
> +	i2c_imx->dma = devm_kzalloc(&pdev->dev, sizeof(struct imx_i2c_dma),
> +					GFP_KERNEL);
> +	if (!i2c_imx->dma) {
> +		dev_info(&pdev->dev,
> +				"can't allocate dma struct faild use dma.\n");

Or just have $dev variable and you won't have to break the line at all ...

> +		i2c_imx->use_dma = false;
> +	} else if (i2c_imx_dma_request(i2c_imx, (dma_addr_t)phy_addr)) {
> +		dev_info(&pdev->dev,
> +				"can't request dma chan, faild use dma.\n");
> +		i2c_imx->use_dma = false;
> +	} else {
> +		i2c_imx->use_dma = true;
> +	}

Can you not just check if i2c_imx->dma is valid pointer or NULL pointer ? Then 
you won't need a separate variable, for this purpose ... right ?
[...]
