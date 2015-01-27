Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932513AbbA0U7h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 15:59:37 -0500
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:37048 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754875AbbA0U7f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 15:59:35 -0500
Message-ID: <54C7FC31.2000306@kernel.org>
Date: Tue, 27 Jan 2015 20:59:29 +0000
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.4.0
MIME-Version: 1.0
To: Stefan Agner <stefan@agner.ch>
CC: shawn.guo@linaro.org, B38611@freescale.com, maitysanchayan@gmail.com,
        linux-iio@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Fugang Duan <B38611@freescale.com>
Subject: Re: [PATCH 1/3] iio: adc: vf610: use ADC clock within specification
References: <1421769723-28677-1-git-send-email-stefan@agner.ch> <1421769723-28677-2-git-send-email-stefan@agner.ch>
In-Reply-To: <1421769723-28677-2-git-send-email-stefan@agner.ch>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20/01/15 16:02, Stefan Agner wrote:
> Depending on conversion mode used, the ADC clock (ADCK) needs
> to be below a maximum frequency. According to Vybrid's data
> sheet this is 20MHz for the low power conversion mode.
> 
> The ADC clock is depending on input clock, which is the bus
> clock by default. Vybrid SoC are typically clocked at at 400MHz
> or 500MHz, which leads to 66MHz or 83MHz bus clock respectively.
> Hence, a divider of 8 is required to stay below the specified
> maximum clock of 20MHz.
I hate to point out the obvious, by 83/8 > 20.  Missing something?
> 
> Due to the different bus clock speeds, the resulting sampling
> frequency is not static. Hence use the ADC clock and calculate
> the actual available sampling frequency dynamically.
> 
> This fixes bogous values observed on some 500MHz clocked Vybrid
> SoC. The resulting value usually showed Bit 9 being stuck at 1,
> or 0, which lead to a value of +/-512.
> 
> Signed-off-by: Stefan Agner <stefan@agner.ch>
In principle this looks fine to me. I would however like an
Ack from Fugang as the original author of the driver).

Given timing I probably wouldn't send this upstream until after
the merge window now (as it's stable material this won't really
matter).

Jonathan
> ---
>  drivers/iio/adc/vf610_adc.c | 91 ++++++++++++++++++++++++++++++---------------
>  1 file changed, 61 insertions(+), 30 deletions(-)
> 
> diff --git a/drivers/iio/adc/vf610_adc.c b/drivers/iio/adc/vf610_adc.c
> index 8ec353c..e63b8e7 100644
> --- a/drivers/iio/adc/vf610_adc.c
> +++ b/drivers/iio/adc/vf610_adc.c
> @@ -141,9 +141,13 @@ struct vf610_adc {
>  	struct regulator *vref;
>  	struct vf610_adc_feature adc_feature;
>  
> +	u32 sample_freq_avail[5];
> +
>  	struct completion completion;
>  };
>  
> +static const u32 vf610_hw_avgs[] = { 1, 4, 8, 16, 32 };
> +
>  #define VF610_ADC_CHAN(_idx, _chan_type) {			\
>  	.type = (_chan_type),					\
>  	.indexed = 1,						\
> @@ -180,35 +184,47 @@ static const struct iio_chan_spec vf610_adc_iio_channels[] = {
>  	/* sentinel */
>  };
>  
> -/*
> - * ADC sample frequency, unit is ADCK cycles.
> - * ADC clk source is ipg clock, which is the same as bus clock.
> - *
> - * ADC conversion time = SFCAdder + AverageNum x (BCT + LSTAdder)
> - * SFCAdder: fixed to 6 ADCK cycles
> - * AverageNum: 1, 4, 8, 16, 32 samples for hardware average.
> - * BCT (Base Conversion Time): fixed to 25 ADCK cycles for 12 bit mode
> - * LSTAdder(Long Sample Time): fixed to 3 ADCK cycles
> - *
> - * By default, enable 12 bit resolution mode, clock source
> - * set to ipg clock, So get below frequency group:
> - */
> -static const u32 vf610_sample_freq_avail[5] =
> -{1941176, 559332, 286957, 145374, 73171};
> +static inline void vf610_adc_calculate_rates(struct vf610_adc *info)
> +{
> +	unsigned long adck_rate, ipg_rate = clk_get_rate(info->clk);
> +	int i;
> +
> +	/*
> +	 * Calculate ADC sample frequencies
> +	 * Sample time unit is ADCK cycles. ADCK clk source is ipg clock,
> +	 * which is the same as bus clock.
> +	 *
> +	 * ADC conversion time = SFCAdder + AverageNum x (BCT + LSTAdder)
> +	 * SFCAdder: fixed to 6 ADCK cycles
> +	 * AverageNum: 1, 4, 8, 16, 32 samples for hardware average.
> +	 * BCT (Base Conversion Time): fixed to 25 ADCK cycles for 12 bit mode
> +	 * LSTAdder(Long Sample Time): fixed to 3 ADCK cycles
> +	 */
> +	adck_rate = ipg_rate / info->adc_feature.clk_div;
> +	for (i = 0; i < ARRAY_SIZE(vf610_hw_avgs); i++)
> +		info->sample_freq_avail[i] =
> +			adck_rate / (6 + vf610_hw_avgs[i] * (25 + 3));
> +}
>  
>  static inline void vf610_adc_cfg_init(struct vf610_adc *info)
>  {
> +	struct vf610_adc_feature *adc_feature = &info->adc_feature;
> +
>  	/* set default Configuration for ADC controller */
> -	info->adc_feature.clk_sel = VF610_ADCIOC_BUSCLK_SET;
> -	info->adc_feature.vol_ref = VF610_ADCIOC_VR_VREF_SET;
> +	adc_feature->clk_sel = VF610_ADCIOC_BUSCLK_SET;
> +	adc_feature->vol_ref = VF610_ADCIOC_VR_VREF_SET;
> +
> +	adc_feature->calibration = true;
> +	adc_feature->ovwren = true;
> +
> +	adc_feature->res_mode = 12;
> +	adc_feature->sample_rate = 1;
> +	adc_feature->lpm = true;
>  
> -	info->adc_feature.calibration = true;
> -	info->adc_feature.ovwren = true;
> +	/* Use a save ADCK which is below 20MHz on all devices */
> +	adc_feature->clk_div = 8;
>  
> -	info->adc_feature.clk_div = 1;
> -	info->adc_feature.res_mode = 12;
> -	info->adc_feature.sample_rate = 1;
> -	info->adc_feature.lpm = true;
> +	vf610_adc_calculate_rates(info);
>  }
>  
>  static void vf610_adc_cfg_post_set(struct vf610_adc *info)
> @@ -290,12 +306,10 @@ static void vf610_adc_cfg_set(struct vf610_adc *info)
>  
>  	cfg_data = readl(info->regs + VF610_REG_ADC_CFG);
>  
> -	/* low power configuration */
>  	cfg_data &= ~VF610_ADC_ADLPC_EN;
>  	if (adc_feature->lpm)
>  		cfg_data |= VF610_ADC_ADLPC_EN;
>  
> -	/* disable high speed */
>  	cfg_data &= ~VF610_ADC_ADHSC_EN;
>  
>  	writel(cfg_data, info->regs + VF610_REG_ADC_CFG);
> @@ -435,10 +449,27 @@ static irqreturn_t vf610_adc_isr(int irq, void *dev_id)
>  	return IRQ_HANDLED;
>  }
>  
> -static IIO_CONST_ATTR_SAMP_FREQ_AVAIL("1941176, 559332, 286957, 145374, 73171");
> +static ssize_t vf610_show_samp_freq_avail(struct device *dev,
> +				struct device_attribute *attr, char *buf)
> +{
> +	struct vf610_adc *info = iio_priv(dev_to_iio_dev(dev));
> +	size_t len = 0;
> +	int i;
> +
> +	for (i = 0; i < ARRAY_SIZE(info->sample_freq_avail); i++)
> +		len += scnprintf(buf + len, PAGE_SIZE - len,
> +			"%u ", info->sample_freq_avail[i]);
> +
> +	/* replace trailing space by newline */
> +	buf[len - 1] = '\n';
> +
> +	return len;
> +}
> +
> +static IIO_DEV_ATTR_SAMP_FREQ_AVAIL(vf610_show_samp_freq_avail);
>  
>  static struct attribute *vf610_attributes[] = {
> -	&iio_const_attr_sampling_frequency_available.dev_attr.attr,
> +	&iio_dev_attr_sampling_frequency_available.dev_attr.attr,
>  	NULL
>  };
>  
> @@ -502,7 +533,7 @@ static int vf610_read_raw(struct iio_dev *indio_dev,
>  		return IIO_VAL_FRACTIONAL_LOG2;
>  
>  	case IIO_CHAN_INFO_SAMP_FREQ:
> -		*val = vf610_sample_freq_avail[info->adc_feature.sample_rate];
> +		*val = info->sample_freq_avail[info->adc_feature.sample_rate];
>  		*val2 = 0;
>  		return IIO_VAL_INT;
>  
> @@ -525,9 +556,9 @@ static int vf610_write_raw(struct iio_dev *indio_dev,
>  	switch (mask) {
>  		case IIO_CHAN_INFO_SAMP_FREQ:
>  			for (i = 0;
> -				i < ARRAY_SIZE(vf610_sample_freq_avail);
> +				i < ARRAY_SIZE(info->sample_freq_avail);
>  				i++)
> -				if (val == vf610_sample_freq_avail[i]) {
> +				if (val == info->sample_freq_avail[i]) {
>  					info->adc_feature.sample_rate = i;
>  					vf610_adc_sample_set(info);
>  					return 0;
> 

