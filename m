Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756642AbaCEMJz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 07:09:55 -0500
Received: from mail.mev.co.uk ([62.49.15.74]:41785 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755164AbaCEMJx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 07:09:53 -0500
Message-ID: <531713F6.8030000@mev.co.uk>
Date: Wed, 5 Mar 2014 12:09:26 +0000
From: Ian Abbott <abbotti@mev.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Chase Southwood <chase.southwood@yahoo.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC: Ian Abbott <ian.abbott@mev.co.uk>,
        "hsweeten@visionengravers.com" <hsweeten@visionengravers.com>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 1/2] Staging: comedi: convert while loops to timeouts
 in s626.c
References: <1393572936-9676-1-git-send-email-chase.southwood@yahoo.com> <1393922628-27903-1-git-send-email-chase.southwood@yahoo.com>
In-Reply-To: <1393922628-27903-1-git-send-email-chase.southwood@yahoo.com>
Content-Type: text/plain; charset="us-ascii"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-03-04 08:43, Chase Southwood wrote:
> This patch changes a handful of while loops to timeouts to prevent
> infinite looping on hardware failure.  A couple such loops are in a
> function (s626_debi_transfer()) which is called from critical sections,
> so comedi_timeout() is unusable for them, and an iterative timeout is
> used instead.  For the while loops in a context where comedi_timeout() is
> allowed, a new callback function, s626_send_dac_eoc(), has been defined
> to evaluate the conditions that the while loops are testing.  The new
> callback employs a switch statement based on the register offset values
> that the status is to be checked from, as this information is enough to
> recreate the entire readl() call, and is passed in the 'context'
> parameter.  A couple of additional macros have been defined where this
> method is not completely sufficient.  The proper comedi_timeout() calls
> are then used.
>
> Signed-off-by: Chase Southwood <chase.southwood@yahoo.com>
> ---
> Ian, my idea for the callback function here is a bit iffy, I'd love to
> hear your feedback.  I've created the ret variable because patch 2/2
> propogates all errors upwards.
>
> 2: Now using comedi_timeout() where allowable.
>
>   drivers/staging/comedi/drivers/s626.c | 81 +++++++++++++++++++++++++++++------
>   1 file changed, 69 insertions(+), 12 deletions(-)
>
> diff --git a/drivers/staging/comedi/drivers/s626.c b/drivers/staging/comedi/drivers/s626.c
> index 5ba4b4a..5a7e1c0 100644
> --- a/drivers/staging/comedi/drivers/s626.c
> +++ b/drivers/staging/comedi/drivers/s626.c
> @@ -209,6 +209,8 @@ static const struct comedi_lrange s626_range_table = {
>   static void s626_debi_transfer(struct comedi_device *dev)
>   {
>   	struct s626_private *devpriv = dev->private;
> +	static const int timeout = 10000;
> +	int i;
>
>   	/* Initiate upload of shadow RAM to DEBI control register */
>   	s626_mc_enable(dev, S626_MC2_UPLD_DEBI, S626_P_MC2);
> @@ -217,12 +219,22 @@ static void s626_debi_transfer(struct comedi_device *dev)
>   	 * Wait for completion of upload from shadow RAM to
>   	 * DEBI control register.
>   	 */
> -	while (!s626_mc_test(dev, S626_MC2_UPLD_DEBI, S626_P_MC2))
> -		;
> +	for (i = 0; i < timeout; i++) {
> +		if (s626_mc_test(dev, S626_MC2_UPLD_DEBI, S626_P_MC2))
> +			break;
> +		udelay(1);
> +	}
> +	if (i == timeout)
> +		comedi_error(dev, "Timeout while uploading to DEBI control register.");
>
>   	/* Wait until DEBI transfer is done */
> -	while (readl(devpriv->mmio + S626_P_PSR) & S626_PSR_DEBI_S)
> -		;
> +	for (i = 0; i < timeout; i++) {
> +		if (!(readl(devpriv->mmio + S626_P_PSR) & S626_PSR_DEBI_S))
> +			break;
> +		udelay(1);
> +	}
> +	if (i == timeout)
> +		comedi_error(dev, "DEBI transfer timeout.");
>   }
>
>   /*
> @@ -351,6 +363,44 @@ static const uint8_t s626_trimadrs[] = {
>   	0x40, 0x41, 0x42, 0x50, 0x51, 0x52, 0x53, 0x60, 0x61, 0x62, 0x63
>   };
>
> +#define S626_P_FB_BUFFER2_MSB_00	0
> +#define S626_P_FB_BUFFER2_MSB_FF	1
> +
> +static int s626_send_dac_eoc(struct comedi_device *dev,
> +							struct comedi_subdevice *s,
> +							struct comedi_insn *insn,
> +							unsigned long context)
> +{
> +	struct s626_private *devpriv = dev->private;
> +	unsigned int status;
> +
> +	switch (context) {
> +	case S626_P_MC1:
> +		status = readl(devpriv->mmio + S626_P_MC1);
> +		if (!(status & S626_MC1_A2OUT))
> +			return 0;
> +		break;
> +	case S626_P_SSR:
> +		status = readl(devpriv->mmio + S626_P_SSR);
> +		if (status & S626_SSR_AF2_OUT)
> +			return 0;
> +		break;
> +	case S626_P_FB_BUFFER2_MSB_00:
> +		status = readl(devpriv->mmio + S626_P_FB_BUFFER2);
> +		if (!(status & 0xff000000))
> +			return 0;
> +		break;
> +	case S626_P_FB_BUFFER2_MSB_FF:
> +		status = readl(devpriv->mmio + S626_P_FB_BUFFER2);
> +		if (status & 0xff000000)
> +			return 0;
> +		break;
> +	default:
> +		return -EINVAL;
> +	}
> +	return -EBUSY;
> +}
> +

Rather than switching on a value that is either a register offset or 
some special value, it might be better to use an enum to define the 
context values you are switching on, e.g.:

enum {
	s626_send_dac_wait_not_mc1_a2out,
	s626_send_dac_wait_ssr_af2_out,
	s626_send_dac_wait_fb_buffer2_msb_00,
	s626_send_dac_wait_fb_buffer2_msb_ff
};

Alternatively, different callback functions could be used for each case.

One slight oddity about the original code that waits for the MSB of FB 
BUFFER2 to go from 0x00 to 0xFF is that it actually waits for it to 
become non-zero.  I'm presuming the intermediate values between 0x00 and 
0xFF are never seen.  (There is a non-Comedi, GPL'ed, Linux driver 
available from Sensoray that makes the same assumption, but I think the 
Comedi driver was derived from it.)

>   /*
>    * Private helper function: Transmit serial data to DAC via Audio
>    * channel 2.  Assumes: (1) TSL2 slot records initialized, and (2)
> @@ -359,6 +409,7 @@ static const uint8_t s626_trimadrs[] = {
>   static void s626_send_dac(struct comedi_device *dev, uint32_t val)
>   {
>   	struct s626_private *devpriv = dev->private;
> +	int ret;
>
>   	/* START THE SERIAL CLOCK RUNNING ------------- */
>
> @@ -404,8 +455,9 @@ static void s626_send_dac(struct comedi_device *dev, uint32_t val)
>   	 * Done by polling the DMAC enable flag; this flag is automatically
>   	 * cleared when the transfer has finished.
>   	 */
> -	while (readl(devpriv->mmio + S626_P_MC1) & S626_MC1_A2OUT)
> -		;
> +	ret = comedi_timeout(dev, NULL, NULL, s626_send_dac_eoc, S626_P_MC1);
> +	if (ret)
> +		comedi_error(dev, "DMA transfer timeout.");
>
>   	/* START THE OUTPUT STREAM TO THE TARGET DAC -------------------- */
>
> @@ -425,8 +477,9 @@ static void s626_send_dac(struct comedi_device *dev, uint32_t val)
>   	 * finished transferring the DAC's data DWORD from the output FIFO
>   	 * to the output buffer register.
>   	 */
> -	while (!(readl(devpriv->mmio + S626_P_SSR) & S626_SSR_AF2_OUT))
> -		;
> +	ret = comedi_timeout(dev, NULL, NULL, s626_send_dac_eoc, S626_P_SSR);
> +	if (ret)
> +		comedi_error(dev, "TSL timeout waiting for slot 1 to execute.");
>
>   	/*
>   	 * Set up to trap execution at slot 0 when the TSL sequencer cycles
> @@ -466,8 +519,10 @@ static void s626_send_dac(struct comedi_device *dev, uint32_t val)
>   		 * from 0xFF to 0x00, which slot 0 causes to happen by shifting
>   		 * out/in on SD2 the 0x00 that is always referenced by slot 5.
>   		 */
> -		while (readl(devpriv->mmio + S626_P_FB_BUFFER2) & 0xff000000)
> -			;
> +		ret = comedi_timeout(dev, NULL, NULL, s626_send_dac_eoc,
> +							S626_P_FB_BUFFER2_MSB_00);
> +		if (ret)
> +			comedi_error(dev, "TSL timeout waiting for slot 0 to execute.");
>   	}
>   	/*
>   	 * Either (1) we were too late setting the slot 0 trap; the TSL
> @@ -486,8 +541,10 @@ static void s626_send_dac(struct comedi_device *dev, uint32_t val)
>   	 * the next DAC write.  This is detected when FB_BUFFER2 MSB changes
>   	 * from 0x00 to 0xFF.
>   	 */
> -	while (!(readl(devpriv->mmio + S626_P_FB_BUFFER2) & 0xff000000))
> -		;
> +	ret = comedi_timeout(dev, NULL, NULL, s626_send_dac_eoc,
> +						S626_P_FB_BUFFER2_MSB_FF);
> +	if (ret)
> +		comedi_error(dev, "TSL timeout waiting for slot 0 to execute.");
>   }
>
>   /*
>


-- 
-=( Ian Abbott @ MEV Ltd.    E-mail: <abbotti@mev.co.uk>        )=-
-=( Tel: +44 (0)161 477 1898   FAX: +44 (0)161 718 3587         )=-
