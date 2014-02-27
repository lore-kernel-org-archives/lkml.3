Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752222AbaB0NVG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 08:21:06 -0500
Received: from co9ehsobe005.messaging.microsoft.com ([207.46.163.28]:7578 "EHLO
	co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751910AbaB0NVD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 08:21:03 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -2
X-BigFish: VS-2(zz98dIe0eah1432Izz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah21bch1fc6hzz1de098h17326ah8275bh8275dh1de097h186068hz2dh87h2a8h839h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1fe8h1ff5h209eh2216h22d0h2336h2438h2461h2487h24d7h2516h2545h255eh25cch1151h1155h)
X-FB-DOMAIN-IP-MATCH: fail
Date: Thu, 27 Feb 2014 21:21:15 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Yuan Yao <yao.yuan@freescale.com>
CC: <wsa@the-dreams.de>, <mark.rutland@arm.com>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-i2c@vger.kernel.org>, Fugang Duan <B38611@freescale.com>,
        <kernel@pengutronix.de>, Marek Vasut <marex@denx.de>
Subject: Re: [PATCH 1/3] i2c: add DMA support for freescale i2c driver
Message-ID: <20140227132108.GA28660@S2101-09.ap.freescale.net>
References: <1393481115-22136-1-git-send-email-yao.yuan@freescale.com>
 <1393481115-22136-2-git-send-email-yao.yuan@freescale.com>
 <20140227125543.GF13537@S2101-09.ap.freescale.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20140227125543.GF13537@S2101-09.ap.freescale.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: sigmatel.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%0$Dn%FREESCALE.MAIL.ONMICROSOFT.COM$RO%1$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 27, 2014 at 08:55:45PM +0800, Shawn Guo wrote:
> On Thu, Feb 27, 2014 at 02:05:14PM +0800, Yuan Yao wrote:
> > Add dma support for i2c. This function depend on DMA driver.
> > You can turn on it by write both the dmas and dma-name properties in dts node.
> > And you should set ".has_dma_support" as true for dma support in imx_i2c_hwdata struct.
> > 
> > Signed-off-by: Yuan Yao <yao.yuan@freescale.com>
> 
> Just added a few people who might be interested.

Still missed one - Marek.  Sorry.

Shawn

> 
> > ---
> >  drivers/i2c/busses/i2c-imx.c | 358 +++++++++++++++++++++++++++++++++++++++++--
> >  1 file changed, 344 insertions(+), 14 deletions(-)
> > 
> > diff --git a/drivers/i2c/busses/i2c-imx.c b/drivers/i2c/busses/i2c-imx.c
> > index db895fb..6ec392b 100644
> > --- a/drivers/i2c/busses/i2c-imx.c
> > +++ b/drivers/i2c/busses/i2c-imx.c
> > @@ -37,22 +37,27 @@
> >  /** Includes *******************************************************************
> >  *******************************************************************************/
> >  
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
> >  
> >  /** Defines ********************************************************************
> >  *******************************************************************************/
> > @@ -63,6 +68,9 @@
> >  /* Default value */
> >  #define IMX_I2C_BIT_RATE	100000	/* 100kHz */
> >  
> > +/* enable DMA if transfer size is bigger than this threshold */
> > +#define IMX_I2C_DMA_THRESHOLD	16
> > +
> >  /* IMX I2C registers:
> >   * the I2C register offset is different between SoCs,
> >   * to provid support for all these chips, split the
> > @@ -88,6 +96,7 @@
> >  #define I2SR_IBB	0x20
> >  #define I2SR_IAAS	0x40
> >  #define I2SR_ICF	0x80
> > +#define I2CR_DMAEN	0x02
> >  #define I2CR_RSTA	0x04
> >  #define I2CR_TXAK	0x08
> >  #define I2CR_MTX	0x10
> > @@ -172,6 +181,17 @@ struct imx_i2c_hwdata {
> >  	unsigned		ndivs;
> >  	unsigned		i2sr_clr_opcode;
> >  	unsigned		i2cr_ien_opcode;
> > +	bool			has_dma_support;
> > +};
> > +
> > +struct imx_i2c_dma {
> > +	struct dma_chan		*chan_tx;
> > +	struct dma_chan		*chan_rx;
> > +	dma_addr_t		buf_tx;
> > +	dma_addr_t		buf_rx;
> > +	unsigned int		len_tx;
> > +	unsigned int		len_rx;
> > +	struct completion	cmd_complete;
> >  };
> >  
> >  struct imx_i2c_struct {
> > @@ -184,6 +204,9 @@ struct imx_i2c_struct {
> >  	int			stopped;
> >  	unsigned int		ifdr; /* IMX_I2C_IFDR */
> >  	const struct imx_i2c_hwdata	*hwdata;
> > +
> > +	bool			use_dma;
> > +	struct imx_i2c_dma	*dma;
> >  };
> >  
> >  static const struct imx_i2c_hwdata imx1_i2c_hwdata  = {
> > @@ -193,6 +216,7 @@ static const struct imx_i2c_hwdata imx1_i2c_hwdata  = {
> >  	.ndivs			= ARRAY_SIZE(imx_i2c_clk_div),
> >  	.i2sr_clr_opcode	= I2SR_CLR_OPCODE_W0C,
> >  	.i2cr_ien_opcode	= I2CR_IEN_OPCODE_1,
> > +	.has_dma_support	= false,
> >  
> >  };
> >  
> > @@ -203,6 +227,7 @@ static const struct imx_i2c_hwdata imx21_i2c_hwdata  = {
> >  	.ndivs			= ARRAY_SIZE(imx_i2c_clk_div),
> >  	.i2sr_clr_opcode	= I2SR_CLR_OPCODE_W0C,
> >  	.i2cr_ien_opcode	= I2CR_IEN_OPCODE_1,
> > +	.has_dma_support	= false,
> >  
> >  };
> >  
> > @@ -213,6 +238,7 @@ static struct imx_i2c_hwdata vf610_i2c_hwdata = {
> >  	.ndivs			= ARRAY_SIZE(vf610_i2c_clk_div),
> >  	.i2sr_clr_opcode	= I2SR_CLR_OPCODE_W1C,
> >  	.i2cr_ien_opcode	= I2CR_IEN_OPCODE_0,
> > +	.has_dma_support	= true,
> >  
> >  };
> >  
> > @@ -254,6 +280,155 @@ static inline unsigned char imx_i2c_read_reg(struct imx_i2c_struct *i2c_imx,
> >  	return readb(i2c_imx->base + (reg << i2c_imx->hwdata->regshift));
> >  }
> >  
> > +/** Functions for DMA support ************************************************
> > +******************************************************************************/
> > +static int i2c_imx_dma_request(struct imx_i2c_struct *i2c_imx, u32 phy_addr)
> > +{
> > +	struct imx_i2c_dma *dma = i2c_imx->dma;
> > +	struct dma_slave_config dma_sconfig;
> > +	int ret;
> > +
> > +	dma->chan_tx = dma_request_slave_channel(&i2c_imx->adapter.dev, "tx");
> > +	if (!dma->chan_tx) {
> > +		dev_err(&i2c_imx->adapter.dev,
> > +				"Dma tx channel request failed!\n");
> > +		return -ENODEV;
> > +	}
> > +
> > +	dma_sconfig.dst_addr = (dma_addr_t)phy_addr +
> > +				(IMX_I2C_I2DR << i2c_imx->hwdata->regshift);
> > +	dma_sconfig.dst_addr_width = DMA_SLAVE_BUSWIDTH_1_BYTE;
> > +	dma_sconfig.dst_maxburst = 1;
> > +	dma_sconfig.direction = DMA_MEM_TO_DEV;
> > +	ret = dmaengine_slave_config(dma->chan_tx, &dma_sconfig);
> > +	if (ret < 0) {
> > +		dev_err(&i2c_imx->adapter.dev,
> > +				"Dma slave config failed, err = %d\n", ret);
> > +		dma_release_channel(dma->chan_tx);
> > +		return ret;
> > +	}
> > +
> > +	dma->chan_rx = dma_request_slave_channel(&i2c_imx->adapter.dev, "rx");
> > +	if (!dma->chan_rx) {
> > +		dev_err(&i2c_imx->adapter.dev,
> > +				"Dma rx channel request failed!\n");
> > +		return -ENODEV;
> > +	}
> > +
> > +	dma_sconfig.src_addr = (dma_addr_t)phy_addr +
> > +				(IMX_I2C_I2DR << i2c_imx->hwdata->regshift);
> > +	dma_sconfig.src_addr_width = DMA_SLAVE_BUSWIDTH_1_BYTE;
> > +	dma_sconfig.src_maxburst = 1;
> > +	dma_sconfig.direction = DMA_DEV_TO_MEM;
> > +	ret = dmaengine_slave_config(dma->chan_rx, &dma_sconfig);
> > +	if (ret < 0) {
> > +		dev_err(&i2c_imx->adapter.dev,
> > +				"Dma slave config failed, err = %d\n", ret);
> > +		dma_release_channel(dma->chan_rx);
> > +		return ret;
> > +	}
> > +
> > +	init_completion(&dma->cmd_complete);
> > +
> > +	return 0;
> > +}
> > +
> > +static void i2c_imx_dma_tx_callback(void *arg)
> > +{
> > +	struct imx_i2c_struct *i2c_imx = (struct imx_i2c_struct *)arg;
> > +	struct imx_i2c_dma *dma = i2c_imx->dma;
> > +
> > +	dma_unmap_single(dma->chan_tx->device->dev, dma->buf_tx,
> > +			dma->len_tx, DMA_TO_DEVICE);
> > +	complete(&dma->cmd_complete);
> > +}
> > +
> > +static int i2c_imx_dma_tx(struct imx_i2c_struct *i2c_imx, struct i2c_msg *msgs)
> > +{
> > +	struct imx_i2c_dma *dma = i2c_imx->dma;
> > +	struct dma_async_tx_descriptor *txdesc;
> > +
> > +	dma->len_tx = msgs->len-1;
> > +	dma->buf_tx = dma_map_single(dma->chan_tx->device->dev, msgs->buf,
> > +					dma->len_tx, DMA_TO_DEVICE);
> > +	if (dma_mapping_error(dma->chan_tx->device->dev, dma->buf_tx)) {
> > +		dev_err(&i2c_imx->adapter.dev, "dma_map_single tx failed\n");
> > +		return -EINVAL;
> > +	}
> > +
> > +	txdesc = dmaengine_prep_slave_single(dma->chan_tx, dma->buf_tx,
> > +					dma->len_tx, DMA_MEM_TO_DEV,
> > +					DMA_PREP_INTERRUPT | DMA_CTRL_ACK);
> > +	if (!txdesc) {
> > +		dev_err(&i2c_imx->adapter.dev,
> > +				"Not able to get desc for tx\n");
> > +		return -EINVAL;
> > +	}
> > +
> > +	txdesc->callback = i2c_imx_dma_tx_callback;
> > +	txdesc->callback_param = i2c_imx;
> > +	dmaengine_submit(txdesc);
> > +	dma_async_issue_pending(dma->chan_tx);
> > +	
> > +	return 0;
> > +}
> > +
> > +static void i2c_imx_dma_rx_callback(void *arg)
> > +{
> > +	struct imx_i2c_struct *i2c_imx = (struct imx_i2c_struct *)arg;
> > +	struct imx_i2c_dma *dma = i2c_imx->dma;
> > +
> > +	dma_unmap_single(dma->chan_rx->device->dev, dma->buf_rx,
> > +				dma->len_rx, DMA_FROM_DEVICE);
> > +	complete(&dma->cmd_complete);
> > +}
> > +
> > +static int i2c_imx_dma_rx(struct imx_i2c_struct *i2c_imx, struct i2c_msg *msgs)
> > +{
> > +	struct imx_i2c_dma *dma = i2c_imx->dma;
> > +	struct dma_async_tx_descriptor *txdesc;
> > +
> > +	dma->len_rx = msgs->len - 2;
> > +	dma->buf_rx = dma_map_single(dma->chan_rx->device->dev, msgs->buf,
> > +					dma->len_rx, DMA_FROM_DEVICE);
> > +	if (dma_mapping_error(dma->chan_rx->device->dev, dma->buf_rx)) {
> > +		dev_err(&i2c_imx->adapter.dev, "dma_map_single tx failed\n");
> > +		return -EINVAL;
> > +	}
> > +
> > +	txdesc = dmaengine_prep_slave_single(dma->chan_rx, dma->buf_rx,
> > +					dma->len_rx, DMA_DEV_TO_MEM,
> > +					DMA_PREP_INTERRUPT | DMA_CTRL_ACK);
> > +	if (!txdesc) {
> > +		dev_err(&i2c_imx->adapter.dev,
> > +				"Not able to get desc for rx\n");
> > +		return -EINVAL;
> > +	}
> > +
> > +	txdesc->callback = i2c_imx_dma_rx_callback;
> > +	txdesc->callback_param = i2c_imx;
> > +	dmaengine_submit(txdesc);
> > +	dma_async_issue_pending(dma->chan_rx);
> > +	
> > +	return 0;
> > +}
> > +static void i2c_imx_dma_free(struct imx_i2c_struct *i2c_imx)
> > +{
> > +	struct imx_i2c_dma *dma = i2c_imx->dma;
> > +	struct dma_chan *dma_chan;
> > +
> > +	dma_chan = dma->chan_tx;
> > +	dma->chan_tx = NULL;
> > +	dma->buf_tx = 0;
> > +	dma->len_tx = 0;
> > +	dma_release_channel(dma_chan);
> > +
> > +	dma_chan = dma->chan_rx;
> > +	dma->chan_tx = NULL;
> > +	dma->buf_rx = 0;
> > +	dma->len_rx = 0;
> > +	dma_release_channel(dma_chan);
> > +}
> >  /** Functions for IMX I2C adapter driver ***************************************
> >  *******************************************************************************/
> >  
> > @@ -425,7 +600,8 @@ static irqreturn_t i2c_imx_isr(int irq, void *dev_id)
> >  	return IRQ_NONE;
> >  }
> >  
> > -static int i2c_imx_write(struct imx_i2c_struct *i2c_imx, struct i2c_msg *msgs)
> > +static int i2c_imx_pio_write(struct imx_i2c_struct *i2c_imx,
> > +							struct i2c_msg *msgs)
> >  {
> >  	int i, result;
> >  
> > @@ -458,7 +634,56 @@ static int i2c_imx_write(struct imx_i2c_struct *i2c_imx, struct i2c_msg *msgs)
> >  	return 0;
> >  }
> >  
> > -static int i2c_imx_read(struct imx_i2c_struct *i2c_imx, struct i2c_msg *msgs)
> > +static int i2c_imx_dma_write(struct imx_i2c_struct *i2c_imx,
> > +							struct i2c_msg *msgs)
> > +{
> > +	int result, timeout=1000;
> > +	unsigned int temp = 0;
> > +
> > +	reinit_completion(&i2c_imx->dma->cmd_complete);
> > +	result = i2c_imx_dma_tx(i2c_imx, msgs);
> > +	if(result)
> > +		return result;
> > +
> > +	temp = imx_i2c_read_reg(i2c_imx, IMX_I2C_I2CR);
> > +	temp |= I2CR_DMAEN;
> > +	imx_i2c_write_reg(temp, i2c_imx, IMX_I2C_I2CR);
> > +
> > +	/* write slave address */
> > +	imx_i2c_write_reg(msgs->addr << 1, i2c_imx, IMX_I2C_I2DR);
> > +	result = wait_for_completion_interruptible_timeout(
> > +						&i2c_imx->dma->cmd_complete,
> > +						msecs_to_jiffies(1000));
> > +	if (result == 0)
> > +		return  -ETIMEDOUT;
> > +
> > +	/* waiting for Transfer complete. */
> > +	while(timeout--) {
> > +		temp = imx_i2c_read_reg(i2c_imx, IMX_I2C_I2SR);
> > +		if (temp & 0x80)
> > +			break;
> > +		udelay(10);
> > +	}
> > +
> > +	temp = imx_i2c_read_reg(i2c_imx, IMX_I2C_I2CR);
> > +	temp &= ~I2CR_DMAEN;
> > +	imx_i2c_write_reg(temp, i2c_imx, IMX_I2C_I2CR);
> > +
> > +	/* write the last byte */
> > +	imx_i2c_write_reg(msgs->buf[msgs->len-1], i2c_imx, IMX_I2C_I2DR);
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
> > +
> > +static int i2c_imx_pio_read(struct imx_i2c_struct *i2c_imx,
> > +							struct i2c_msg *msgs)
> >  {
> >  	int i, result;
> >  	unsigned int temp;
> > @@ -518,6 +743,80 @@ static int i2c_imx_read(struct imx_i2c_struct *i2c_imx, struct i2c_msg *msgs)
> >  	return 0;
> >  }
> >  
> > +static int i2c_imx_dma_read(struct imx_i2c_struct *i2c_imx,
> > +							struct i2c_msg *msgs)
> > +{
> > +	int result, timeout=1000;
> > +	unsigned int temp;
> > +
> > +	/* write slave address */
> > +	imx_i2c_write_reg((msgs->addr << 1) | 0x01, i2c_imx, IMX_I2C_I2DR);
> > +	result = i2c_imx_trx_complete(i2c_imx);
> > +	if (result)
> > +		return result;
> > +
> > +	result = i2c_imx_acked(i2c_imx);
> > +	if (result)
> > +		return result;
> > +
> > +	/* setup bus to read data */
> > +	temp = imx_i2c_read_reg(i2c_imx, IMX_I2C_I2CR);
> > +	temp &= ~I2CR_MTX;
> > +	if (msgs->len - 1)
> > +		temp &= ~I2CR_TXAK;
> > +	imx_i2c_write_reg(temp, i2c_imx, IMX_I2C_I2CR);
> > +	imx_i2c_read_reg(i2c_imx, IMX_I2C_I2DR); /* dummy read */
> > +
> > +	temp = imx_i2c_read_reg(i2c_imx, IMX_I2C_I2CR);
> > +	temp |= I2CR_DMAEN;
> > +	imx_i2c_write_reg(temp, i2c_imx, IMX_I2C_I2CR);
> > +
> > +	reinit_completion(&i2c_imx->dma->cmd_complete);
> > +	result = i2c_imx_dma_rx(i2c_imx, msgs);
> > +	if(result)
> > +		return result;
> > +
> > +	result = wait_for_completion_interruptible_timeout(
> > +						&i2c_imx->dma->cmd_complete,
> > +						msecs_to_jiffies(1000));
> > +	if (result == 0)
> > +		return  -ETIMEDOUT;
> > +
> > +	/* waiting for Transfer complete. */
> > +	while(timeout--) {
> > +		temp = imx_i2c_read_reg(i2c_imx, IMX_I2C_I2SR);
> > +		if (temp & 0x80)
> > +			break;
> > +		udelay(10);
> > +	}
> > +
> > +	temp = imx_i2c_read_reg(i2c_imx, IMX_I2C_I2CR);
> > +	temp &= ~I2CR_DMAEN;
> > +	imx_i2c_write_reg(temp, i2c_imx, IMX_I2C_I2CR);
> > +
> > +	/* read n-1 byte data */
> > +	temp = imx_i2c_read_reg(i2c_imx, IMX_I2C_I2CR);
> > +	temp |= I2CR_TXAK;
> > +	imx_i2c_write_reg(temp, i2c_imx, IMX_I2C_I2CR);
> > +
> > +	msgs->buf[msgs->len-2] = imx_i2c_read_reg(i2c_imx, IMX_I2C_I2DR);
> > +	/* read n byte data */
> > +	result = i2c_imx_trx_complete(i2c_imx);
> > +	if (result)
> > +		return result;
> > +
> > +	/* It must generate STOP before read I2DR to prevent
> > +	   controller from generating another clock cycle */
> > +	temp = imx_i2c_read_reg(i2c_imx, IMX_I2C_I2CR);
> > +	temp &= ~(I2CR_MSTA | I2CR_MTX);
> > +	imx_i2c_write_reg(temp, i2c_imx, IMX_I2C_I2CR);
> > +	i2c_imx_bus_busy(i2c_imx, 0);
> > +	i2c_imx->stopped = 1;
> > +	msgs->buf[msgs->len-1] = imx_i2c_read_reg(i2c_imx, IMX_I2C_I2DR);
> > +
> > +	return 0;
> > +}
> > +
> >  static int i2c_imx_xfer(struct i2c_adapter *adapter,
> >  						struct i2c_msg *msgs, int num)
> >  {
> > @@ -563,10 +862,18 @@ static int i2c_imx_xfer(struct i2c_adapter *adapter,
> >  			(temp & I2SR_SRW ? 1 : 0), (temp & I2SR_IIF ? 1 : 0),
> >  			(temp & I2SR_RXAK ? 1 : 0));
> >  #endif
> > -		if (msgs[i].flags & I2C_M_RD)
> > -			result = i2c_imx_read(i2c_imx, &msgs[i]);
> > -		else
> > -			result = i2c_imx_write(i2c_imx, &msgs[i]);
> > +		if(i2c_imx->use_dma && msgs[i].len >= IMX_I2C_DMA_THRESHOLD) {
> > +			if (msgs[i].flags & I2C_M_RD)
> > +				result = i2c_imx_dma_read(i2c_imx, &msgs[i]);
> > +			else
> > +				result = i2c_imx_dma_write(i2c_imx, &msgs[i]);
> > +		} else {
> > +			if (msgs[i].flags & I2C_M_RD)
> > +				result = i2c_imx_pio_read(i2c_imx, &msgs[i]);
> > +			else
> > +				result = i2c_imx_pio_write(i2c_imx, &msgs[i]);
> > +		}
> > +
> >  		if (result)
> >  			goto fail0;
> >  	}
> > @@ -601,6 +908,7 @@ static int i2c_imx_probe(struct platform_device *pdev)
> >  	void __iomem *base;
> >  	int irq, ret;
> >  	u32 bitrate;
> > +	u32 phy_addr;
> >  
> >  	dev_dbg(&pdev->dev, "<%s>\n", __func__);
> >  
> > @@ -611,6 +919,7 @@ static int i2c_imx_probe(struct platform_device *pdev)
> >  	}
> >  
> >  	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> > +	phy_addr = res->start;
> >  	base = devm_ioremap_resource(&pdev->dev, res);
> >  	if (IS_ERR(base))
> >  		return PTR_ERR(base);
> > @@ -696,6 +1005,24 @@ static int i2c_imx_probe(struct platform_device *pdev)
> >  		i2c_imx->adapter.name);
> >  	dev_info(&i2c_imx->adapter.dev, "IMX I2C adapter registered\n");
> >  
> > +	/* Init DMA config if support*/
> > +	if (i2c_imx->hwdata->has_dma_support) {
> > +		dev_info(&pdev->dev, "has_dma_support_begin.\n");
> > +		i2c_imx->dma = devm_kzalloc(&pdev->dev, sizeof(struct imx_i2c_dma),
> > +				GFP_KERNEL);
> > +		if (!i2c_imx->dma) {
> > +			dev_info(&pdev->dev, "can't allocate dma struct faild use dma.\n");
> > +			i2c_imx->use_dma = false;
> > +		}
> > +		else if (i2c_imx_dma_request(i2c_imx, phy_addr)) {
> > +			dev_info(&pdev->dev, "can't request dma chan, faild use dma.\n");
> > +			i2c_imx->use_dma = false;
> > +		}
> > +		else {
> > +			i2c_imx->use_dma = true;
> > +		}
> > +	}
> > +
> >  	return 0;   /* Return OK */
> >  }
> >  
> > @@ -707,6 +1034,9 @@ static int i2c_imx_remove(struct platform_device *pdev)
> >  	dev_dbg(&i2c_imx->adapter.dev, "adapter removed\n");
> >  	i2c_del_adapter(&i2c_imx->adapter);
> >  
> > +	if (i2c_imx->use_dma)
> > +		i2c_imx_dma_free(i2c_imx);
> > +
> >  	/* setup chip registers to defaults */
> >  	imx_i2c_write_reg(0, i2c_imx, IMX_I2C_IADR);
> >  	imx_i2c_write_reg(0, i2c_imx, IMX_I2C_IFDR);
> > -- 
> > 1.8.4
> > 
> > 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

