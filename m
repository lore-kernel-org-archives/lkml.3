Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753754AbaCYMMu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 08:12:50 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:49329 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753224AbaCYMMs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 08:12:48 -0400
Message-ID: <5331728F.1090301@mev.co.uk>
Date: Tue, 25 Mar 2014 12:11:59 +0000
From: Ian Abbott <abbotti@mev.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Chase Southwood <chase.southwood@yahoo.com>, gregkh@linuxfoundation.org
CC: hsweeten@visionengravers.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: comedi: s626: use comedi_timeout() on remaining
 loops
References: <1395724172-30183-1-git-send-email-chase.southwood@yahoo.com>
In-Reply-To: <1395724172-30183-1-git-send-email-chase.southwood@yahoo.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-03-25 05:09, Chase Southwood wrote:
> There were just a handful of more while loops in this file that need timeouts,
> and this patch takes care of them, using comedi_timeout().  A couple of new
> callbacks are introduced, but there was one case where the appropriate callback
> function was already defined; in this case I have just used that.
>
> Signed-off-by: Chase Southwood <chase.southwood@yahoo.com>

I think it can be simplified a bit as described below.

> ---
>   drivers/staging/comedi/drivers/s626.c | 66 ++++++++++++++++++++++++++++++-----
>   1 file changed, 58 insertions(+), 8 deletions(-)
>
> diff --git a/drivers/staging/comedi/drivers/s626.c b/drivers/staging/comedi/drivers/s626.c
> index 95fadf3..4dc5659 100644
> --- a/drivers/staging/comedi/drivers/s626.c
> +++ b/drivers/staging/comedi/drivers/s626.c
> @@ -295,10 +295,24 @@ static void s626_debi_replace(struct comedi_device *dev, unsigned int addr,
>
>   /* **************  EEPROM ACCESS FUNCTIONS  ************** */
>
> +static int s626_i2c_handshake_eoc(struct comedi_device *dev,
> +				 struct comedi_subdevice *s,
> +				 struct comedi_insn *insn,
> +				 unsigned long context)
> +{
> +	unsigned int status;
> +
> +	status = s626_mc_test(dev, S626_MC2_UPLD_IIC, S626_P_MC2);
> +	if (status)
> +		return 0;
> +	return -EBUSY;
> +}
> +

So s626_i2c_handshake_eoc() tests the S626_MC2_UPLD_IIC bit of the 
S626_P_MC2 register and returns 0 if the bit is high or -EBUSY if it is low.

>   static uint32_t s626_i2c_handshake(struct comedi_device *dev, uint32_t val)
>   {
>   	struct s626_private *devpriv = dev->private;
>   	unsigned int ctrl;
> +	uint32_t ret;
>
>   	/* Write I2C command to I2C Transfer Control shadow register */
>   	writel(val, devpriv->mmio + S626_P_I2CCTRL);
> @@ -308,8 +322,9 @@ static uint32_t s626_i2c_handshake(struct comedi_device *dev, uint32_t val)
>   	 * wait for upload confirmation.
>   	 */
>   	s626_mc_enable(dev, S626_MC2_UPLD_IIC, S626_P_MC2);
> -	while (!s626_mc_test(dev, S626_MC2_UPLD_IIC, S626_P_MC2))
> -		;
> +	ret = comedi_timeout(dev, NULL, NULL, s626_i2c_handshake_eoc, 0);
> +	if (ret)
> +		return ret;

That's fine.  Both the original while loop and the comedi_timeout() call 
are waiting for the S626_MC_UPLD_IIC bit to go high.

>
>   	/* Wait until I2C bus transfer is finished or an error occurs */
>   	do {
> @@ -2029,8 +2044,9 @@ static int s626_ai_insn_read(struct comedi_device *dev,
>   	/* Wait for the data to arrive in FB BUFFER 1 register. */
>
>   	/* Wait for ADC done */
> -	while (!(readl(devpriv->mmio + S626_P_PSR) & S626_PSR_GPIO2))
> -		;
> +	ret = comedi_timeout(dev, s, insn, s626_ai_eoc, 0);
> +	if (ret)
> +		return ret;
>
>   	/* Fetch ADC data from audio interface's input shift register. */
>
> @@ -2641,6 +2657,36 @@ static int s626_allocate_dma_buffers(struct comedi_device *dev)
>   	return 0;
>   }
>
> +enum {
> +	s626_initialize_wait_i2c_abort,
> +	s626_initialize_wait_i2c_err_reset
> +};
> +
> +static int s626_initialize_eoc(struct comedi_device *dev,
> +			      struct comedi_subdevice *s,
> +			      struct comedi_insn *insn,
> +			      unsigned long context)
> +{
> +	struct s626_private *devpriv = dev->private;
> +	unsigned int status;
> +
> +	switch (context) {
> +	case s626_initialize_wait_i2c_abort:
> +		status = readl(devpriv->mmio + S626_P_MC2);
> +		if (status & S626_MC2_UPLD_IIC)
> +			return 0;
> +		break;

The 's626_initialize_wait_i2c_abort' case returns 0 if the 
S626_MC2_UPLD_IIC bit is high and the function around it will return 
-EBUSY otherwise.  That's basically the same as the 
s626_i2c_handshake_eoc() callback except it doesn't call s626_mc_test() 
to read the register and check the bit, it does it itself.

> +	case s626_initialize_wait_i2c_err_reset:
> +		status = s626_mc_test(dev, S626_MC2_UPLD_IIC, S626_P_MC2);
> +		if (status)
> +			return 0;
> +		break;

The 's626_initialize_wait_i2c_err_reset' case is also basically the same 
as the s626_i2c_handshake_eoc() callback.

> +	default:
> +		return -EINVAL;
> +	}
> +	return -EBUSY;
> +}
> +

It seems both supported context case values of the s626_initialize_eoc() 
callback basically do the same thing as the s626_i2c_handshake_eoc() 
callback, so you could use that callback instead of this one.

>   static int s626_initialize(struct comedi_device *dev)
>   {
>   	struct s626_private *devpriv = dev->private;
> @@ -2681,8 +2727,10 @@ static int s626_initialize(struct comedi_device *dev)
>   	writel(S626_I2C_CLKSEL | S626_I2C_ABORT,
>   	       devpriv->mmio + S626_P_I2CSTAT);
>   	s626_mc_enable(dev, S626_MC2_UPLD_IIC, S626_P_MC2);
> -	while (!(readl(devpriv->mmio + S626_P_MC2) & S626_MC2_UPLD_IIC))
> -		;
> +	ret = comedi_timeout(dev, NULL, NULL, s626_initialize_eoc,
> +			     s626_initialize_wait_i2c_abort);
> +	if (ret)
> +		return ret;

That's fine.  The original while loop is waiting for the 
S626_MC2_UPLD_IIC bit to go high and so is the comedi_timeout() call. 
But you could re-use the s626_i2c_handshake_eoc() callback instead of 
the s626_initialize_wait_i2c_abort() as described above.

>
>   	/*
>   	 * Per SAA7146 data sheet, write to STATUS
> @@ -2691,8 +2739,10 @@ static int s626_initialize(struct comedi_device *dev)
>   	for (i = 0; i < 2; i++) {
>   		writel(S626_I2C_CLKSEL, devpriv->mmio + S626_P_I2CSTAT);
>   		s626_mc_enable(dev, S626_MC2_UPLD_IIC, S626_P_MC2);
> -		while (!s626_mc_test(dev, S626_MC2_UPLD_IIC, S626_P_MC2))
> -			;
> +		ret = comedi_timeout(dev, NULL, NULL, s626_initialize_eoc,
> +				     s626_initialize_wait_i2c_err_reset);
> +		if (ret)
> +			return ret;

As above, the original while loop is waiting for the S626_MC2_UPLD_IIC 
bit to go high, so you could re-use the s626_i2c_handshake_eoc() callback.

>   	}
>
>   	/*
>

Best regards,
Ian.

-- 
-=( Ian Abbott @ MEV Ltd.    E-mail: <abbotti@mev.co.uk>        )=-
-=( Tel: +44 (0)161 477 1898   FAX: +44 (0)161 718 3587         )=-
