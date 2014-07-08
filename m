Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753219AbaGHIYR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 04:24:17 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:20951 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751834AbaGHIYO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 04:24:14 -0400
Date: Tue, 8 Jul 2014 11:23:51 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Josef Gajdusek <atx@atalax.net>
Cc: linux-iio@vger.kernel.org, devel@driverdev.osuosl.org,
        gregkh@linuxfoundation.org, pmeerw@pmeerw.net,
        linux-kernel@vger.kernel.org, jic23@kernel.org
Subject: Re: [PATCH v2 2/5] staging:iio:hmc5843: Split hmc5843.c to multiple
 files
Message-ID: <20140708082351.GE25880@mwanda>
References: <20140707203326.GB10383@dashie>
 <20140707203636.GD10383@dashie>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140707203636.GD10383@dashie>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When you compare the old and new versions of hmc5843_read_raw() then it
appears there is a bug fix or something which hasn't been documentented
in the changelog.

> -static int hmc5843_read_raw(struct iio_dev *indio_dev,
> -			    struct iio_chan_spec const *chan,
> -			    int *val, int *val2, long mask)
> -{
> -	struct hmc5843_data *data = iio_priv(indio_dev);
> -	int rval;
> -	int ret;
> -
> -	switch (mask) {
> -	case IIO_CHAN_INFO_RAW:
> -		return hmc5843_read_measurement(data, chan->scan_index, val);
> -	case IIO_CHAN_INFO_SCALE:
> -		ret = regmap_read(data->regmap, HMC5843_CONFIG_REG_B, &rval);
> -		if (ret < 0)
> -			return ret;
> -		*val = 0;
> -		*val2 = data->variant->regval_to_nanoscale[rval >> HMC5843_RANGE_GAIN_OFFSET];
> -		return IIO_VAL_INT_PLUS_NANO;
> -	case IIO_CHAN_INFO_SAMP_FREQ:
> -		ret = regmap_read(data->regmap, HMC5843_CONFIG_REG_A, &rval);
> -		if (ret < 0)
> -			return ret;
> -		rval &= HMC5843_RATE_MASK;
                ^^^^^^^^^^^^^^^^^^^^^^^^^
HMC5843_RATE_MASK is 0x1c.

> -		*val = data->variant->regval_to_samp_freq[rval][0];
> -		*val2 = data->variant->regval_to_samp_freq[rval][1];
> -		return IIO_VAL_INT_PLUS_MICRO;
> -	}
> -	return -EINVAL;
> -}

> +static int hmc5843_read_raw(struct iio_dev *indio_dev,
> +			    struct iio_chan_spec const *chan,
> +			    int *val, int *val2, long mask)
> +{
> +	struct hmc5843_data *data = iio_priv(indio_dev);
> +	int rval;
> +	int ret;
> +
> +	switch (mask) {
> +	case IIO_CHAN_INFO_RAW:
> +		return hmc5843_read_measurement(data, chan->scan_index, val);
> +	case IIO_CHAN_INFO_SCALE:
> +		ret = regmap_read(data->regmap, HMC5843_CONFIG_REG_B, &rval);
> +		if (ret < 0)
> +			return ret;
> +		rval >>= HMC5843_RANGE_GAIN_OFFSET;
> +		*val = 0;
> +		*val2 = data->variant->regval_to_nanoscale[rval];
> +		return IIO_VAL_INT_PLUS_NANO;
> +	case IIO_CHAN_INFO_SAMP_FREQ:
> +		ret = regmap_read(data->regmap, HMC5843_CONFIG_REG_A, &rval);
> +		if (ret < 0)
> +			return ret;
> +		rval >>= HMC5843_RATE_OFFSET;
                ^^^^^^^^^^^^^^^^^^^^^^^^^^^^
HMC5843_RATE_OFFSET is 0x02.

> +		*val = data->variant->regval_to_samp_freq[rval][0];
> +		*val2 = data->variant->regval_to_samp_freq[rval][1];
> +		return IIO_VAL_INT_PLUS_MICRO;
> +	}
> +	return -EINVAL;
> +}

Ideally this patch would be a straight move and no code changes.

regards,
dan carpenter
