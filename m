Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753087AbaDDO27 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 10:28:59 -0400
Received: from mail-out.m-online.net ([212.18.0.9]:35258 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752615AbaDDO25 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 10:28:57 -0400
X-Auth-Info: jex3s9jJblTcc7TSNCL+W18ywq1Vbfs+jkGw4GKCN/M=
From: Marek Vasut <marex@denx.de>
To: Yuan Yao <yao.yuan@freescale.com>
Subject: Re: [PATCH v4 1/2] i2c: add DMA support for freescale i2c driver
Date: Fri, 4 Apr 2014 16:28:55 +0200
User-Agent: KMail/1.13.7 (Linux/3.13-trunk-amd64; KDE/4.11.3; x86_64; ; )
Cc: wsa@the-dreams.de, mark.rutland@arm.com, shawn.guo@linaro.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-i2c@vger.kernel.org
References: <1396579272-19542-1-git-send-email-yao.yuan@freescale.com> <1396579272-19542-2-git-send-email-yao.yuan@freescale.com>
In-Reply-To: <1396579272-19542-2-git-send-email-yao.yuan@freescale.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201404041628.55471.marex@denx.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, April 04, 2014 at 04:41:11 AM, Yuan Yao wrote:
> Add dma support for i2c. This function depend on DMA driver.
> You can turn on it by write both the dmas and dma-name properties in dts
> node.
> 
> Signed-off-by: Yuan Yao <yao.yuan@freescale.com>

[...]

Since you will be fixing that superfluous return 0; (I actually wonder, did you 
really test the driver at all before submitting it?) ...

> +static int i2c_imx_dma_xfer(struct imx_i2c_struct *i2c_imx,
> +					struct i2c_msg *msgs)
> +{
> +	struct imx_i2c_dma *dma = i2c_imx->dma;
> +	struct dma_async_tx_descriptor *txdesc;
> +	struct device *dev = &i2c_imx->adapter.dev;
> +
> +	dma->dma_buf = dma_map_single(dma->chan_using->device->dev, msgs->buf,

Please fix this "noodle" here too, the chain of pointers is quite long, you can 
just define a variable for that.

> +					dma->dma_len, dma->dma_data_dir);
> +	if (dma_mapping_error(dma->chan_using->device->dev, dma->dma_buf)) {
> +		dev_err(dev, "DMA mapping failed\n");
> +		return -EINVAL;
> +	}
> +
> +	txdesc = dmaengine_prep_slave_single(dma->chan_using, dma->dma_buf,
> +					dma->dma_len, dma->dma_transfer_dir,
> +					DMA_PREP_INTERRUPT | DMA_CTRL_ACK);
> +	if (!txdesc) {
> +		dev_err(dev, "Not able to get desc for DMA xfer\n");
> +		dma_unmap_single(dma->chan_using->device->dev, dma->dma_buf,
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
[...]

Other than those two things,

Reviewed-by: Marek Vasut <marex@denx.de>
