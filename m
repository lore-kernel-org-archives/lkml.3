Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757521AbaCFCju (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 21:39:50 -0500
Received: from mail-out.m-online.net ([212.18.0.9]:42459 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756064AbaCFCjr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 21:39:47 -0500
X-Auth-Info: VHsiI41zJF1qCBuDYCCphUwnMin0s5cyrBhWUWw77Bw=
From: Marek Vasut <marex@denx.de>
To: Yuan Yao <yao.yuan@freescale.com>
Subject: Re: [PATCH v2 1/2] i2c: add DMA support for freescale i2c driver
Date: Thu, 6 Mar 2014 03:39:45 +0100
User-Agent: KMail/1.13.7 (Linux/3.13-trunk-amd64; KDE/4.11.3; x86_64; ; )
Cc: wsa@the-dreams.de, mark.rutland@arm.com, shawn.guo@linaro.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-i2c@vger.kernel.org
References: <1394002352-8380-1-git-send-email-yao.yuan@freescale.com> <1394002352-8380-2-git-send-email-yao.yuan@freescale.com>
In-Reply-To: <1394002352-8380-2-git-send-email-yao.yuan@freescale.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201403060339.45611.marex@denx.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, March 05, 2014 at 07:52:31 AM, Yuan Yao wrote:
> Add dma support for i2c. This function depend on DMA driver.
> You can turn on it by write both the dmas and dma-name properties in dts
> node.
> 
> Signed-off-by: Yuan Yao <yao.yuan@freescale.com>
> ---

[...]

>  struct imx_i2c_struct {
>  	struct i2c_adapter	adapter;
>  	struct clk		*clk;
> @@ -184,6 +205,9 @@ struct imx_i2c_struct {
>  	int			stopped;
>  	unsigned int		ifdr; /* IMX_I2C_IFDR */
>  	const struct imx_i2c_hwdata	*hwdata;
> +
> +	bool			use_dma;
> +	struct imx_i2c_dma	*dma;

I'd suggest you check how big this structure would be if you swapped the 
'bool...' and 'struct imx_i2c_dma...' entries and compare it to the original. I 
think due to natural alignment, having the bool first would create more slop 
[1].

>  };
> 
>  static const struct imx_i2c_hwdata imx1_i2c_hwdata  = {
> @@ -254,9 +278,120 @@ static inline unsigned char imx_i2c_read_reg(struct
> imx_i2c_struct *i2c_imx, return readb(i2c_imx->base + (reg <<
> i2c_imx->hwdata->regshift)); }
> 
> +/** Functions for DMA support
> ************************************************
> +*************************************************************************
> *****/

I can't say I am too fond of this style of comment, especially since it violates 
coding style (it's not a kernel-doc style comment either). Just use

/*
 * Functions for DMA
 */

if you really want to make the comment big.

> +static int i2c_imx_dma_request(struct imx_i2c_struct *i2c_imx, u32
> phy_addr) +{
> +	struct imx_i2c_dma *dma = i2c_imx->dma;
> +	struct dma_slave_config dma_sconfig;
> +	int ret;
> +
> +	dma->chan_tx = dma_request_slave_channel(&i2c_imx->adapter.dev, "tx");

Why don't you define a new variable for this dev pointer ?

struct device *dev = &i2c_imx->adapter.dev;

Then use this 'dev' all around isntead of spelling the entire path everywhere. 
That'd trim the amount of code down too, not to mention you'd be able to avoid 
multi-line function args more often.

> +	if (!dma->chan_tx) {
> +		dev_err(&i2c_imx->adapter.dev,
> +				"Dma tx channel request failed!\n");
> +		return -ENODEV;
> +	}
> +
> +	dma_sconfig.dst_addr = (dma_addr_t)phy_addr +

Why don't you pass the 'phy_addr' as 'dma_addr_t' into this function in the 
first place ?

> +				(IMX_I2C_I2DR << i2c_imx->hwdata->regshift);
> +	dma_sconfig.dst_addr_width = DMA_SLAVE_BUSWIDTH_1_BYTE;
> +	dma_sconfig.dst_maxburst = 1;
> +	dma_sconfig.direction = DMA_MEM_TO_DEV;
> +	ret = dmaengine_slave_config(dma->chan_tx, &dma_sconfig);
> +	if (ret < 0) {
> +		dev_err(&i2c_imx->adapter.dev,
> +				"Dma slave config failed, err = %d\n", ret);
> +		dma_release_channel(dma->chan_tx);

Use 'goto fail' or such here to implement a failpath. Then handle the release of 
tx channel in the failpath. You do duplicate this call below.

> +		return ret;
> +	}
> +
> +	dma->chan_rx = dma_request_slave_channel(&i2c_imx->adapter.dev, "rx");
> +	if (!dma->chan_rx) {
> +		dev_err(&i2c_imx->adapter.dev,
> +				"Dma rx channel request failed!\n");
> +		return -ENODEV;
> +	}
> +
> +	dma_sconfig.src_addr = (dma_addr_t)phy_addr +
> +				(IMX_I2C_I2DR << i2c_imx->hwdata->regshift);
> +	dma_sconfig.src_addr_width = DMA_SLAVE_BUSWIDTH_1_BYTE;
> +	dma_sconfig.src_maxburst = 1;
> +	dma_sconfig.direction = DMA_DEV_TO_MEM;
> +	ret = dmaengine_slave_config(dma->chan_rx, &dma_sconfig);
> +	if (ret < 0) {
> +		dev_err(&i2c_imx->adapter.dev,
> +				"Dma slave config failed, err = %d\n", ret);
> +		dma_release_channel(dma->chan_rx);
> +		return ret;
> +	}
> +
> +	init_completion(&dma->cmd_complete);
> +
> +	return 0;
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
> +				struct i2c_msg *msgs)
> +{
> +	struct imx_i2c_dma *dma = i2c_imx->dma;
> +	struct dma_async_tx_descriptor *txdesc;
> +
> +	dma->dma_buf = dma_map_single(dma->chan_using->device->dev, msgs->buf,
> +					dma->dma_len, dma->dma_data_dir);
> +	if (dma_mapping_error(dma->chan_using->device->dev, dma->dma_buf)) {
> +		dev_err(&i2c_imx->adapter.dev, "dma_map_single failed\n");
> +		return -EINVAL;
> +	}
> +
> +	txdesc = dmaengine_prep_slave_single(dma->chan_using, dma->dma_buf,
> +					dma->dma_len, dma->dma_transfer_dir,
> +					DMA_PREP_INTERRUPT | DMA_CTRL_ACK);
> +	if (!txdesc) {
> +		dev_err(&i2c_imx->adapter.dev,
> +				"Not able to get desc for dma xfer\n");
> +		return -EINVAL;

If we fail here, we will still have dma_buf mapped , right ?

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
> +	struct dma_chan *dma_chan;
> +
> +	dma->dma_buf = 0;
> +	dma->dma_len = 0;
> +
> +	dma_chan = dma->chan_tx;
> +	dma_release_channel(dma_chan);
> +	dma->chan_tx = NULL;

Here you can just drop the special variable.

> +	dma_chan = dma->chan_rx;
> +	dma_release_channel(dma_chan);
> +	dma->chan_rx = NULL;
> +
> +	dma->chan_using = NULL;
> +}
> +
>  /** Functions for IMX I2C adapter driver
> ***************************************
> **************************************************************************
> *****/ -
>  static int i2c_imx_bus_busy(struct imx_i2c_struct *i2c_imx, int for_busy)
>  {
>  	unsigned long orig_jiffies = jiffies;
> @@ -427,46 +562,98 @@ static irqreturn_t i2c_imx_isr(int irq, void *dev_id)
> 
>  static int i2c_imx_write(struct imx_i2c_struct *i2c_imx, struct i2c_msg
> *msgs) {
> -	int i, result;
> +	int i, result, timeout = IMX_I2C_DMA_TIMEOUT;
> +	unsigned int temp = 0;
> +	struct imx_i2c_dma *dma = i2c_imx->dma;
> 
>  	dev_dbg(&i2c_imx->adapter.dev, "<%s> write slave address: addr=0x%x\n",
>  		__func__, msgs->addr << 1);
> 
> -	/* write slave address */
> -	imx_i2c_write_reg(msgs->addr << 1, i2c_imx, IMX_I2C_I2DR);
> -	result = i2c_imx_trx_complete(i2c_imx);
> -	if (result)
> -		return result;
> -	result = i2c_imx_acked(i2c_imx);
> -	if (result)
> -		return result;
> -	dev_dbg(&i2c_imx->adapter.dev, "<%s> write data\n", __func__);
> +	if (i2c_imx->use_dma && msgs->len >= IMX_I2C_DMA_THRESHOLD) {
> +		reinit_completion(&i2c_imx->dma->cmd_complete);
> +		dma->chan_using = dma->chan_tx;
> +		dma->dma_transfer_dir = DMA_MEM_TO_DEV;
> +		dma->dma_data_dir = DMA_TO_DEVICE;
> +		dma->dma_len = msgs->len - 1;
> +		result = i2c_imx_dma_xfer(i2c_imx, msgs);
> +		if (result)
> +			return result;
> 
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
> +		if (result == 0)
> +			return  -ETIMEDOUT;

You need to handle result < 0 as well, since that happens if this was 
interrupted.

> +
> +		/* waiting for Transfer complete. */
> +		while (timeout--) {
> +			temp = imx_i2c_read_reg(i2c_imx, IMX_I2C_I2SR);
> +			if (temp & 0x80)

What's this magic value of 0x80 here ?

> +				break;
> +			udelay(10);
> +		}
> +
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

Define and use 'dev' variable here, as mentioned above.

> +		/* write data */
> +		for (i = 0; i < msgs->len; i++) {
> +			dev_dbg(&i2c_imx->adapter.dev,
> +				"<%s> write byte: B%d=0x%X\n",
> +				__func__, i, msgs->buf[i]);
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
> 
>  static int i2c_imx_read(struct imx_i2c_struct *i2c_imx, struct i2c_msg
> *msgs) {
> -	int i, result;
> +	int i, result, timeout = IMX_I2C_DMA_TIMEOUT;
>  	unsigned int temp;
> +	struct imx_i2c_dma *dma = i2c_imx->dma;
> 
>  	dev_dbg(&i2c_imx->adapter.dev,
>  		"<%s> write slave address: addr=0x%x\n",
>  		__func__, (msgs->addr << 1) | 0x01);
> 
> +
>  	/* write slave address */
>  	imx_i2c_write_reg((msgs->addr << 1) | 0x01, i2c_imx, IMX_I2C_I2DR);
>  	result = i2c_imx_trx_complete(i2c_imx);
> @@ -488,33 +675,71 @@ static int i2c_imx_read(struct imx_i2c_struct
> *i2c_imx, struct i2c_msg *msgs)
> 
>  	dev_dbg(&i2c_imx->adapter.dev, "<%s> read data\n", __func__);
> 
> -	/* read data */
> -	for (i = 0; i < msgs->len; i++) {
> -		result = i2c_imx_trx_complete(i2c_imx);
> +	if (i2c_imx->use_dma && msgs->len >= IMX_I2C_DMA_THRESHOLD) {
> +		temp = imx_i2c_read_reg(i2c_imx, IMX_I2C_I2CR);
> +		temp |= I2CR_DMAEN;
> +		imx_i2c_write_reg(temp, i2c_imx, IMX_I2C_I2CR);
> +
> +		reinit_completion(&i2c_imx->dma->cmd_complete);
> +		dma->chan_using = dma->chan_rx;
> +		dma->dma_transfer_dir = DMA_DEV_TO_MEM;
> +		dma->dma_data_dir = DMA_FROM_DEVICE;
> +		dma->dma_len = msgs->len - 2;
> +		result = i2c_imx_dma_xfer(i2c_imx, msgs);
>  		if (result)
>  			return result;
> -		if (i == (msgs->len - 1)) {
> -			/* It must generate STOP before read I2DR to prevent
> -			   controller from generating another clock cycle */
> -			dev_dbg(&i2c_imx->adapter.dev,
> -				"<%s> clear MSTA\n", __func__);
> -			temp = imx_i2c_read_reg(i2c_imx, IMX_I2C_I2CR);
> -			temp &= ~(I2CR_MSTA | I2CR_MTX);
> -			imx_i2c_write_reg(temp, i2c_imx, IMX_I2C_I2CR);
> -			i2c_imx_bus_busy(i2c_imx, 0);
> -			i2c_imx->stopped = 1;
> -		} else if (i == (msgs->len - 2)) {
> +
> +		result = wait_for_completion_interruptible_timeout(
> +					&i2c_imx->dma->cmd_complete,
> +					msecs_to_jiffies(IMX_I2C_DMA_TIMEOUT));
> +		if (result == 0)
> +			return  -ETIMEDOUT;
> +
> +		/* waiting for Transfer complete. */
> +		while (timeout--) {
> +			temp = imx_i2c_read_reg(i2c_imx, IMX_I2C_I2SR);
> +			if (temp & 0x80)

Magic value here, please fix.

> +				break;
> +			udelay(10);
> +		}
> +
> +		temp = imx_i2c_read_reg(i2c_imx, IMX_I2C_I2CR);
> +		temp &= ~I2CR_DMAEN;
> +		imx_i2c_write_reg(temp, i2c_imx, IMX_I2C_I2CR);
> +	} else {
> +		/* read data */
> +		for (i = 0; i < msgs->len - 2; i++) {
> +			result = i2c_imx_trx_complete(i2c_imx);
> +			if (result)
> +				return result;
> +			msgs->buf[i] = imx_i2c_read_reg(i2c_imx, IMX_I2C_I2DR);
>  			dev_dbg(&i2c_imx->adapter.dev,
> -				"<%s> set TXAK\n", __func__);
> -			temp = imx_i2c_read_reg(i2c_imx, IMX_I2C_I2CR);
> -			temp |= I2CR_TXAK;
> -			imx_i2c_write_reg(temp, i2c_imx, IMX_I2C_I2CR);
> +				"<%s> read byte: B%d=0x%X\n",
> +				__func__, i, msgs->buf[i]);
>  		}
> -		msgs->buf[i] = imx_i2c_read_reg(i2c_imx, IMX_I2C_I2DR);
> -		dev_dbg(&i2c_imx->adapter.dev,
> -			"<%s> read byte: B%d=0x%X\n",
> -			__func__, i, msgs->buf[i]);
> +		result = i2c_imx_trx_complete(i2c_imx);
>  	}
> +
> +	/* read n-1 byte data */
> +	temp = imx_i2c_read_reg(i2c_imx, IMX_I2C_I2CR);
> +	temp |= I2CR_TXAK;
> +	imx_i2c_write_reg(temp, i2c_imx, IMX_I2C_I2CR);
> +
> +	msgs->buf[msgs->len-2] = imx_i2c_read_reg(i2c_imx, IMX_I2C_I2DR);
> +	/* read n byte data */
> +	result = i2c_imx_trx_complete(i2c_imx);
> +	if (result)
> +		return result;
> +
> +	/* It must generate STOP before read I2DR to prevent
> +	   controller from generating another clock cycle */

Again, comment style is wrong. For multiline comments, use this:

/*
 * foo bar
 * baz quux
 */

> +	temp = imx_i2c_read_reg(i2c_imx, IMX_I2C_I2CR);
> +	temp &= ~(I2CR_MSTA | I2CR_MTX);
> +	imx_i2c_write_reg(temp, i2c_imx, IMX_I2C_I2CR);
> +	i2c_imx_bus_busy(i2c_imx, 0);
> +	i2c_imx->stopped = 1;
> +	msgs->buf[msgs->len-1] = imx_i2c_read_reg(i2c_imx, IMX_I2C_I2DR);
> +
>  	return 0;
>  }
> 
> @@ -601,6 +826,7 @@ static int i2c_imx_probe(struct platform_device *pdev)
>  	void __iomem *base;
>  	int irq, ret;
>  	u32 bitrate;
> +	u32 phy_addr;
> 
>  	dev_dbg(&pdev->dev, "<%s>\n", __func__);
> 
> @@ -611,6 +837,7 @@ static int i2c_imx_probe(struct platform_device *pdev)
>  	}
> 
>  	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	phy_addr = res->start;

Uh ... Shawn, I really think I am lost here. Don't you need to map this memory 
before you can use it for DMA ? The DMA mapping function should give you the 
physical address and is the right way to go about this instead of pulling the 
address from here, no ?

I might be wrong here, I am rather uncertain, so please help me out. Thanks!

>  	base = devm_ioremap_resource(&pdev->dev, res);
>  	if (IS_ERR(base))
>  		return PTR_ERR(base);
> @@ -696,6 +923,21 @@ static int i2c_imx_probe(struct platform_device *pdev)
>  		i2c_imx->adapter.name);
>  	dev_info(&i2c_imx->adapter.dev, "IMX I2C adapter registered\n");
> 
> +	/* Init DMA config if support*/
> +	i2c_imx->dma = devm_kzalloc(&pdev->dev, sizeof(struct imx_i2c_dma),
> +					GFP_KERNEL);
> +	if (!i2c_imx->dma) {
> +		dev_info(&pdev->dev,
> +				"can't allocate dma struct faild use dma.\n");
> +		i2c_imx->use_dma = false;
> +	} else if (i2c_imx_dma_request(i2c_imx, phy_addr)) {
> +		dev_info(&pdev->dev,
> +				"can't request dma chan, faild use dma.\n");
> +		i2c_imx->use_dma = false;
> +	} else {
> +		i2c_imx->use_dma = true;
> +	}
> +
>  	return 0;   /* Return OK */
>  }
> 
> @@ -707,6 +949,9 @@ static int i2c_imx_remove(struct platform_device *pdev)
>  	dev_dbg(&i2c_imx->adapter.dev, "adapter removed\n");
>  	i2c_del_adapter(&i2c_imx->adapter);
> 
> +	if (i2c_imx->use_dma)
> +		i2c_imx_dma_free(i2c_imx);
> +
>  	/* setup chip registers to defaults */
>  	imx_i2c_write_reg(0, i2c_imx, IMX_I2C_IADR);
>  	imx_i2c_write_reg(0, i2c_imx, IMX_I2C_IFDR);

[1] http://www.catb.org/esr/structure-packing/
