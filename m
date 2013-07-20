Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753925Ab3GTKwn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Jul 2013 06:52:43 -0400
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:45117 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753688Ab3GTKwm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Jul 2013 06:52:42 -0400
Message-ID: <51EA6BF7.5090101@kernel.org>
Date: Sat, 20 Jul 2013 11:52:39 +0100
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: Zubair Lutfullah <zubair.lutfullah@gmail.com>
CC: jic23@cam.ac.uk, gregkh@linuxfoundation.org, linux-iio@vger.kernel.org,
        linux-kernel@vger.kernel.org, koen@dominion.thruhere.net
Subject: Re: [PATCH 02/15] iio: ti_am335x_adc: Fix wrong samples received
 on 1st read
References: <1374186086-5015-1-git-send-email-zubair.lutfullah@gmail.com> <1374186086-5015-3-git-send-email-zubair.lutfullah@gmail.com>
In-Reply-To: <1374186086-5015-3-git-send-email-zubair.lutfullah@gmail.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/18/2013 11:21 PM, Zubair Lutfullah wrote:
> From: "Patil, Rachna" <rachna@ti.com>
> 
> Previously we tried to read data form ADC even before ADC sequencer
> finished sampling. This led to wrong samples.
> We now wait on ADC status register idle bit to be set.
> 
> Signed-off-by: Patil, Rachna <rachna@ti.com>
> Signed-off-by: Zubair Lutfullah <zubair.lutfullah@gmail.com>

Hi,

I have no problem with this patch, but as it is a fix it should have been part
of a separate series from the new stuff.

Fixes go into mainline normally within the current cycle whereas the other stuff
will wait for the next merge window.

If you are rerolling the series, at the very least I would like this and any
other fixes at the beginning and clearly marked as such.

Thanks,

Jonathan
> ---
>  drivers/iio/adc/ti_am335x_adc.c      |   30 ++++++++++++++++++++++--------
>  include/linux/mfd/ti_am335x_tscadc.h |   16 ++++++++++++++++
>  2 files changed, 38 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/iio/adc/ti_am335x_adc.c b/drivers/iio/adc/ti_am335x_adc.c
> index 4427e8e..f73fee1 100644
> --- a/drivers/iio/adc/ti_am335x_adc.c
> +++ b/drivers/iio/adc/ti_am335x_adc.c
> @@ -60,7 +60,6 @@ static void tiadc_step_config(struct tiadc_device *adc_dev)
>  {
>  	unsigned int stepconfig;
>  	int i, steps;
> -	u32 step_en;
>  
>  	/*
>  	 * There are 16 configurable steps and 8 analog input
> @@ -86,8 +85,7 @@ static void tiadc_step_config(struct tiadc_device *adc_dev)
>  		adc_dev->channel_step[i] = steps;
>  		steps++;
>  	}
> -	step_en = get_adc_step_mask(adc_dev);
> -	am335x_tsc_se_set(adc_dev->mfd_tscadc, step_en);
> +
>  }
>  
>  static const char * const chan_name_ain[] = {
> @@ -142,10 +140,22 @@ static int tiadc_read_raw(struct iio_dev *indio_dev,
>  		int *val, int *val2, long mask)
>  {
>  	struct tiadc_device *adc_dev = iio_priv(indio_dev);
> -	int i;
> -	unsigned int fifo1count, read;
> +	int i, map_val;
> +	unsigned int fifo1count, read, stepid;
>  	u32 step = UINT_MAX;
>  	bool found = false;
> +	u32 step_en;
> +	unsigned long timeout = jiffies + usecs_to_jiffies
> +				(IDLE_TIMEOUT * adc_dev->channels);
> +	step_en = get_adc_step_mask(adc_dev);
> +	am335x_tsc_se_set(adc_dev->mfd_tscadc, step_en);
> +
> +	/* Wait for ADC sequencer to complete sampling */
> +	while (tiadc_readl(adc_dev, REG_ADCFSM) & SEQ_STATUS) {
> +		if (time_after(jiffies, timeout))
> +			return -EAGAIN;
> +		}
> +	map_val = chan->channel + TOTAL_CHANNELS;
>  
>  	/*
>  	 * When the sub-system is first enabled,
> @@ -170,12 +180,16 @@ static int tiadc_read_raw(struct iio_dev *indio_dev,
>  	fifo1count = tiadc_readl(adc_dev, REG_FIFO1CNT);
>  	for (i = 0; i < fifo1count; i++) {
>  		read = tiadc_readl(adc_dev, REG_FIFO1);
> -		if (read >> 16 == step) {
> -			*val = read & 0xfff;
> +		stepid = read & FIFOREAD_CHNLID_MASK;
> +		stepid = stepid >> 0x10;
> +
> +		if (stepid == map_val) {
> +			read = read & FIFOREAD_DATA_MASK;
>  			found = true;
> +			*val = read;
>  		}
>  	}
> -	am335x_tsc_se_update(adc_dev->mfd_tscadc);
> +
>  	if (found == false)
>  		return -EBUSY;
>  	return IIO_VAL_INT;
> diff --git a/include/linux/mfd/ti_am335x_tscadc.h b/include/linux/mfd/ti_am335x_tscadc.h
> index 8d73fe2..db1791b 100644
> --- a/include/linux/mfd/ti_am335x_tscadc.h
> +++ b/include/linux/mfd/ti_am335x_tscadc.h
> @@ -113,11 +113,27 @@
>  #define CNTRLREG_8WIRE		CNTRLREG_AFE_CTRL(3)
>  #define CNTRLREG_TSCENB		BIT(7)
>  
> +/* FIFO READ Register */
> +#define FIFOREAD_DATA_MASK (0xfff << 0)
> +#define FIFOREAD_CHNLID_MASK (0xf << 16)
> +
> +/* Sequencer Status */
> +#define SEQ_STATUS BIT(5)
> +
>  #define ADC_CLK			3000000
>  #define	MAX_CLK_DIV		7
>  #define TOTAL_STEPS		16
>  #define TOTAL_CHANNELS		8
>  
> +/*
> +* ADC runs at 3MHz, and it takes
> +* 15 cycles to latch one data output.
> +* Hence the idle time for ADC to
> +* process one sample data would be
> +* around 5 micro seconds.
> +*/
> +#define IDLE_TIMEOUT 5 /* microsec */
> +
>  #define TSCADC_CELLS		2
>  
>  struct ti_tscadc_dev {
> 
