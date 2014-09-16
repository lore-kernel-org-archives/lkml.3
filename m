Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755444AbaIPUCS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 16:02:18 -0400
Received: from mail-out.m-online.net ([212.18.0.9]:42318 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752198AbaIPUCP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 16:02:15 -0400
X-Auth-Info: IpPDFoETC114ROkW6YFBBM6SnW4xfCKZf4fLLsbDtxw=
From: Marek Vasut <marex@denx.de>
To: Yao Yuan <yao.yuan@freescale.com>
Subject: Re: [PATCH v7 1/2] i2c: imx: add DMA support for freescale i2c driver
Date: Tue, 16 Sep 2014 20:17:06 +0200
User-Agent: KMail/1.13.7 (Linux/3.13-trunk-amd64; KDE/4.13.1; x86_64; ; )
Cc: "wsa@the-dreams.de" <wsa@the-dreams.de>,
        "LW@karo-electronics.de" <LW@karo-electronics.de>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "fugang.duan@freescale.com" <fugang.duan@freescale.com>,
        "shawn.guo@linaro.org" <shawn.guo@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>
References: <1407923215-3749-1-git-send-email-yao.yuan@freescale.com> <201409051240.44469.marex@denx.de> <1410360473732.53953@freescale.com>
In-Reply-To: <1410360473732.53953@freescale.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201409162017.06439.marex@denx.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, September 10, 2014 at 04:48:01 PM, Yao Yuan wrote:
> On Friday, September 05, 2014 6:41 PM, Marek Vasut wrote:
> > On Friday, September 05, 2014 at 12:32:40 PM, Yao Yuan wrote:
> > [...]
> > 
> > > > > +static int i2c_imx_dma_write(struct imx_i2c_struct *i2c_imx,
> > > > > +					struct i2c_msg *msgs)
> > > > > +{
> > > > > +	int result;
> > > > > +	unsigned int temp = 0;
> > > > > +	unsigned long orig_jiffies = jiffies;
> > > > > +	struct imx_i2c_dma *dma = i2c_imx->dma;
> > > > > +	struct device *dev = &i2c_imx->adapter.dev;
> > > > > +
> > > > > +	dev_dbg(dev, "<%s> write slave address: addr=0x%x\n",
> > > > > +		__func__, msgs->addr << 1);
> > > > > +
> > > > > +	reinit_completion(&i2c_imx->dma->cmd_complete);
> > > > > +	dma->chan_using = dma->chan_tx;
> > > > > +	dma->dma_transfer_dir = DMA_MEM_TO_DEV;
> > > > > +	dma->dma_data_dir = DMA_TO_DEVICE;
> > > > > +	dma->dma_len = msgs->len - 1;
> > > > > +	result = i2c_imx_dma_xfer(i2c_imx, msgs);
> > > > > +	if (result)
> > > > > +		return result;
> > > > > +
> > > > > +	temp = imx_i2c_read_reg(i2c_imx, IMX_I2C_I2CR);
> > > > > +	temp |= I2CR_DMAEN;
> > > > > +	imx_i2c_write_reg(temp, i2c_imx, IMX_I2C_I2CR);
> > > > > +
> > > > > +	/*
> > > > > +	 * Write slave address.
> > > > > +	 * The first byte muse be transmitted by the CPU.
> > > > > +	 */
> > > > > +	imx_i2c_write_reg(msgs->addr << 1, i2c_imx, IMX_I2C_I2DR);
> > > > > +	result = wait_for_completion_interruptible_timeout(
> > > > > +				&i2c_imx->dma->cmd_complete,
> > > > > +				msecs_to_jiffies(IMX_I2C_DMA_TIMEOUT));
> > > > > +	if (result <= 0) {
> > > > > +		dmaengine_terminate_all(dma->chan_using);
> > > > > +		if (result)
> > > > > +			return result;
> > > > > +		else
> > > > > +			return -ETIMEDOUT;
> > > > 
> > > > Shouldn't you force-disable the DMA here somehow (like unsetting
> > > > I2CR_DMAEN bit), if it failed or timed out?
> > > 
> > > [Yuan Yao] Yes, I put the code for force-disable DMA in
> > > i2c_imx_start(). In order to make sure any DMA error will not effect
> > > the I2C.
> > > It seems almost the same as put the code here, how about your think?
> > 
> > Would that mean that the "crashed" DMA would be running until the next
> > transmission is scheduled ?
> 
> [Yuan Yao] No, In fact any DMA timeout will result the failure of I2C
> transmission and then it will turn to report the exception and wait for
> next transmission.

Can you tell when the next transmission will happen? What if I issue a single 
transmission and that one fails ? Will the DMA run until who knows when ?

> The only thing I worried about is I2C may still receive
> some feedbacks after DMA timeout. In this case the feedbacks may lead to
> abnormal state in PIO mode.But it will be ignored in DMA model.
> That's why I tend to delay force-disable DMA until the next transmission
> begin. Could you please give me some suggestion?

No, this design just seems flawed to me. You should stop the DMA immediatelly if 
there is an error to avoid wasting resources and prevent possible other adverse 
effects.

Best regards,
Marek Vasut
