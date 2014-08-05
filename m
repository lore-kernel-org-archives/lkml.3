Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754817AbaHELuO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 07:50:14 -0400
Received: from mail-pa0-f51.google.com ([209.85.220.51]:40475 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753748AbaHELuM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 07:50:12 -0400
Message-ID: <53E0C498.6070608@gmail.com>
Date: Tue, 05 Aug 2014 17:18:40 +0530
From: Varka Bhadram <varkabhadram@gmail.com>
Organization: CDAC-HYD
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Yuan Yao <yao.yuan@freescale.com>, wsa@the-dreams.de, marex@denx.de
CC: LW@KARO-electronics.de, mark.rutland@arm.com, shawn.guo@linaro.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-i2c@vger.kernel.org
Subject: Re: [PATCH v6 1/2] i2c: imx: add DMA support for freescale i2c driver
References: <1407232563-10856-1-git-send-email-yao.yuan@freescale.com> <1407232563-10856-2-git-send-email-yao.yuan@freescale.com>
In-Reply-To: <1407232563-10856-2-git-send-email-yao.yuan@freescale.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/05/2014 03:26 PM, Yuan Yao wrote:

(...)

> +/* Functions for DMA support */
> +static int i2c_imx_dma_request(struct imx_i2c_struct *i2c_imx,
> +						dma_addr_t phy_addr)

should match open parenthesis...

static int i2c_imx_dma_request(struct imx_i2c_struct *i2c_imx,
			       dma_addr_t phy_addr)

> +{
> +	struct imx_i2c_dma *dma;
> +	struct dma_slave_config dma_sconfig;
> +	struct device *dev = &i2c_imx->adapter.dev;
> +	int ret;
> +
> +	dma = devm_kzalloc(dev, sizeof(struct imx_i2c_dma), GFP_KERNEL);

sizeof(*dma) ....?

> +	if (!dma)
> +		return -ENOMEM;
> +
> +	dma->chan_tx = dma_request_slave_channel(dev, "tx");
> +	if (!dma->chan_tx) {
> +		dev_dbg(dev, "can't request DMA tx channel\n");
> +		ret = -ENODEV;
> +		goto fail_al;
> +	}
> +
> +	dma_sconfig.dst_addr = phy_addr +
> +				(IMX_I2C_I2DR << i2c_imx->hwdata->regshift);
> +	dma_sconfig.dst_addr_width = DMA_SLAVE_BUSWIDTH_1_BYTE;
> +	dma_sconfig.dst_maxburst = 1;
> +	dma_sconfig.direction = DMA_MEM_TO_DEV;
> +	ret = dmaengine_slave_config(dma->chan_tx, &dma_sconfig);
> +	if (ret < 0) {
> +		dev_dbg(dev, "can't configure tx channel\n");
> +		goto fail_tx;
> +	}
> +
> +	dma->chan_rx = dma_request_slave_channel(dev, "rx");
> +	if (!dma->chan_rx) {
> +		dev_dbg(dev, "can't request DMA rx channel\n");
> +		ret = -ENODEV;
> +		goto fail_tx;
> +	}
> +
> +	dma_sconfig.src_addr = phy_addr +
> +				(IMX_I2C_I2DR << i2c_imx->hwdata->regshift);
> +	dma_sconfig.src_addr_width = DMA_SLAVE_BUSWIDTH_1_BYTE;
> +	dma_sconfig.src_maxburst = 1;
> +	dma_sconfig.direction = DMA_DEV_TO_MEM;
> +	ret = dmaengine_slave_config(dma->chan_rx, &dma_sconfig);
> +	if (ret < 0) {
> +		dev_dbg(dev, "can't configure rx channel\n");
> +		goto fail_rx;
> +	}
> +
> +	i2c_imx->dma = dma;
> +	init_completion(&dma->cmd_complete);
> +	dev_info(dev, "using %s (tx) and %s (rx) for DMA transfers\n",
> +		dma_chan_name(dma->chan_tx), dma_chan_name(dma->chan_rx));
> +
> +	return 0;
> +
> +fail_rx:
> +	dma_release_channel(dma->chan_rx);
> +fail_tx:
> +	dma_release_channel(dma->chan_tx);
> +fail_al:
> +	devm_kfree(dev, dma);

no need to use devm_kfree() if we use devm_kzalloc()...

> +	dev_info(dev, "can't use DMA\n");
> +
> +	return ret;
> +}
> +
> +static void i2c_imx_dma_callback(void *arg)
> +{
> +	struct imx_i2c_struct *i2c_imx = (struct imx_i2c_struct *)arg;
> +	struct imx_i2c_dma *dma = i2c_imx->dma;
> +
> +	dma_unmap_single(dma->chan_using->device->dev, dma->dma_buf,
> +			dma->dma_len, dma->dma_data_dir);
> +	complete(&dma->cmd_complete);
> +}
> +
> +static int i2c_imx_dma_xfer(struct imx_i2c_struct *i2c_imx,
> +					struct i2c_msg *msgs)

static int i2c_imx_dma_xfer(struct imx_i2c_struct *i2c_imx,
			    struct i2c_msg *msgs)

> +{
> +	struct imx_i2c_dma *dma = i2c_imx->dma;
> +	struct dma_async_tx_descriptor *txdesc;
> +	struct device *dev = &i2c_imx->adapter.dev;
> +	struct device *chan_dev = dma->chan_using->device->dev;
> +
> +	dma->dma_buf = dma_map_single(chan_dev, msgs->buf,
> +					dma->dma_len, dma->dma_data_dir);

dma_map_single(chan_dev, msgs->buf,
	       dma->dma_len, dma->dma_data_dir);

> +	if (dma_mapping_error(chan_dev, dma->dma_buf)) {
> +		dev_err(dev, "DMA mapping failed\n");
> +		return -EINVAL;
> +	}
> +
> +	txdesc = dmaengine_prep_slave_single(dma->chan_using, dma->dma_buf,
> +					dma->dma_len, dma->dma_transfer_dir,
> +					DMA_PREP_INTERRUPT | DMA_CTRL_ACK);

  dmaengine_prep_slave_single(dma->chan_using, dma->dma_buf,
			     dma->dma_len, dma->dma_transfer_dir,
			     DMA_PREP_INTERRUPT | DMA_CTRL_ACK);

> +	if (!txdesc) {
> +		dev_err(dev, "Not able to get desc for DMA xfer\n");
> +		dma_unmap_single(chan_dev, dma->dma_buf,
> +					dma->dma_len, dma->dma_data_dir);
> +		return -EINVAL;
> +	}
> +
> +	txdesc->callback = i2c_imx_dma_callback;
> +	txdesc->callback_param = i2c_imx;
> +	dmaengine_submit(txdesc);
> +	dma_async_issue_pending(dma->chan_using);
> +
> +	return 0;
> +}
> +
> +static void i2c_imx_dma_free(struct imx_i2c_struct *i2c_imx)
> +{
> +	struct imx_i2c_dma *dma = i2c_imx->dma;
> +
> +	dma->dma_buf = 0;
> +	dma->dma_len = 0;
> +
> +	dma_release_channel(dma->chan_tx);
> +	dma->chan_tx = NULL;
> +
> +	dma_release_channel(dma->chan_rx);
> +	dma->chan_rx = NULL;
> +
> +	dma->chan_using = NULL;
> +}
> +
>   /** Functions for IMX I2C adapter driver ***************************************
>   *******************************************************************************/
>   
> @@ -379,6 +530,7 @@ static int i2c_imx_start(struct imx_i2c_struct *i2c_imx)
>   	i2c_imx->stopped = 0;
>   
>   	temp |= I2CR_IIEN | I2CR_MTX | I2CR_TXAK;
> +	temp &= ~I2CR_DMAEN;
>   	imx_i2c_write_reg(temp, i2c_imx, IMX_I2C_I2CR);
>   	return result;
>   }
> @@ -432,6 +584,160 @@ static irqreturn_t i2c_imx_isr(int irq, void *dev_id)
>   	return IRQ_NONE;
>   }
>   
> +static int i2c_imx_dma_write(struct imx_i2c_struct *i2c_imx,
> +					struct i2c_msg *msgs)

static int i2c_imx_dma_write(struct imx_i2c_struct *i2c_imx,
			     struct i2c_msg *msgs)

run checkpatch.pl on this patch...

-- 
Regards,
Varka Bhadram.

