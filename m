Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752812AbaCALsQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Mar 2014 06:48:16 -0500
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:52438 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750869AbaCALsO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Mar 2014 06:48:14 -0500
Message-ID: <5311C92C.20901@kernel.org>
Date: Sat, 01 Mar 2014 11:49:00 +0000
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Sebastian Reichel <sre@debian.org>, Sebastian Reichel <sre@ring0.de>,
        Marek Belisko <marek@goldelico.com>
CC: Lee Jones <lee.jones@linaro.org>, Samuel Ortiz <sameo@linux.intel.com>,
        Lars-Peter Clausen <lars@metafoo.de>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, linux-iio@vger.kernel.org
Subject: Re: [RFCv4 5/7] mfd: twl4030-madc: Use twl_i2c_read/write_u16 for
 16 bit registers
References: <1393374270-20079-1-git-send-email-sre@debian.org> <1393444990-28140-1-git-send-email-sre@debian.org> <1393444990-28140-6-git-send-email-sre@debian.org>
In-Reply-To: <1393444990-28140-6-git-send-email-sre@debian.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26/02/14 20:03, Sebastian Reichel wrote:
> Simplify reading and writing of 16 bit TWL registers in the
> driver by using twl_i2c_read_u16 and twl_i2c_write_u16.
>
> Signed-off-by: Sebastian Reichel <sre@debian.org>
> Acked-by: Lee Jones <lee.jones@linaro.org>
Nice
Acked-by: Jonathan Cameron <jic23@kernel.org>
> ---
>   drivers/mfd/twl4030-madc.c | 39 ++++++++-------------------------------
>   1 file changed, 8 insertions(+), 31 deletions(-)
>
> diff --git a/drivers/mfd/twl4030-madc.c b/drivers/mfd/twl4030-madc.c
> index c90013e..d918670 100644
> --- a/drivers/mfd/twl4030-madc.c
> +++ b/drivers/mfd/twl4030-madc.c
> @@ -206,25 +206,19 @@ const struct twl4030_madc_conversion_method twl4030_conversion_methods[] = {
>    */
>   static int twl4030_madc_channel_raw_read(struct twl4030_madc_data *madc, u8 reg)
>   {
> -	u8 msb, lsb;
> +	u16 val;
>   	int ret;
>   	/*
>   	 * For each ADC channel, we have MSB and LSB register pair. MSB address
>   	 * is always LSB address+1. reg parameter is the address of LSB register
>   	 */
> -	ret = twl_i2c_read_u8(TWL4030_MODULE_MADC, &msb, reg + 1);
> +	ret = twl_i2c_read_u16(TWL4030_MODULE_MADC, &val, reg);
>   	if (ret) {
> -		dev_err(madc->dev, "unable to read MSB register 0x%X\n",
> -			reg + 1);
> -		return ret;
> -	}
> -	ret = twl_i2c_read_u8(TWL4030_MODULE_MADC, &lsb, reg);
> -	if (ret) {
> -		dev_err(madc->dev, "unable to read LSB register 0x%X\n", reg);
> +		dev_err(madc->dev, "unable to read register 0x%X\n", reg);
>   		return ret;
>   	}
>
> -	return (int)(((msb << 8) | lsb) >> 6);
> +	return (int)(val >> 6);
>   }
>
>   /*
> @@ -573,7 +567,6 @@ static int twl4030_madc_wait_conversion_ready(struct twl4030_madc_data *madc,
>   int twl4030_madc_conversion(struct twl4030_madc_request *req)
>   {
>   	const struct twl4030_madc_conversion_method *method;
> -	u8 ch_msb, ch_lsb;
>   	int ret;
>
>   	if (!req || !twl4030_madc)
> @@ -589,37 +582,21 @@ int twl4030_madc_conversion(struct twl4030_madc_request *req)
>   		ret = -EBUSY;
>   		goto out;
>   	}
> -	ch_msb = (req->channels >> 8) & 0xff;
> -	ch_lsb = req->channels & 0xff;
>   	method = &twl4030_conversion_methods[req->method];
>   	/* Select channels to be converted */
> -	ret = twl_i2c_write_u8(TWL4030_MODULE_MADC, ch_msb, method->sel + 1);
> +	ret = twl_i2c_write_u16(TWL4030_MODULE_MADC, req->channels, method->sel);
>   	if (ret) {
>   		dev_err(twl4030_madc->dev,
> -			"unable to write sel register 0x%X\n", method->sel + 1);
> -		goto out;
> -	}
> -	ret = twl_i2c_write_u8(TWL4030_MODULE_MADC, ch_lsb, method->sel);
> -	if (ret) {
> -		dev_err(twl4030_madc->dev,
> -			"unable to write sel register 0x%X\n", method->sel + 1);
> +			"unable to write sel register 0x%X\n", method->sel);
>   		goto out;
>   	}
>   	/* Select averaging for all channels if do_avg is set */
>   	if (req->do_avg) {
> -		ret = twl_i2c_write_u8(TWL4030_MODULE_MADC,
> -				       ch_msb, method->avg + 1);
> +		ret = twl_i2c_write_u16(TWL4030_MODULE_MADC, req->channels,
> +				       method->avg);
>   		if (ret) {
>   			dev_err(twl4030_madc->dev,
>   				"unable to write avg register 0x%X\n",
> -				method->avg + 1);
> -			goto out;
> -		}
> -		ret = twl_i2c_write_u8(TWL4030_MODULE_MADC,
> -				       ch_lsb, method->avg);
> -		if (ret) {
> -			dev_err(twl4030_madc->dev,
> -				"unable to write avg reg 0x%X\n",
>   				method->avg);
>   			goto out;
>   		}
>

