Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932189Ab3INQBc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Sep 2013 12:01:32 -0400
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:42746 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756601Ab3INQBb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Sep 2013 12:01:31 -0400
Message-ID: <52349679.3010103@kernel.org>
Date: Sat, 14 Sep 2013 18:01:45 +0100
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130806 Thunderbird/17.0.8
MIME-Version: 1.0
To: Lee Jones <lee.jones@linaro.org>
CC: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arnd@arndb.de, linus.walleij@linaro.org, denis.ciocca@st.com,
        linux-iio@vger.kernel.org
Subject: Re: [PATCH 22/38] iio: sensors-core: st: Clean-up error handling
 in st_sensors_read_info_raw()
References: <1378817379-8238-1-git-send-email-lee.jones@linaro.org> <1378817379-8238-23-git-send-email-lee.jones@linaro.org>
In-Reply-To: <1378817379-8238-23-git-send-email-lee.jones@linaro.org>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/10/13 13:49, Lee Jones wrote:
> Saving a few lines of code.
> 
> Signed-off-by: Lee Jones <lee.jones@linaro.org>
Applied to the togreg branch of iio.git.

To my mind the key thing here is that the error paths were previous
inconsistent in that all but the last one went via a separate cleanup path
whereas the last one went straight through.

Now they are consistent and that is more important than saving a few lines of code.

Thanks,
> ---
>  drivers/iio/common/st_sensors/st_sensors_core.c | 11 ++++-------
>  1 file changed, 4 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/iio/common/st_sensors/st_sensors_core.c b/drivers/iio/common/st_sensors/st_sensors_core.c
> index 148f0e5..25d4c7e 100644
> --- a/drivers/iio/common/st_sensors/st_sensors_core.c
> +++ b/drivers/iio/common/st_sensors/st_sensors_core.c
> @@ -359,28 +359,25 @@ int st_sensors_read_info_raw(struct iio_dev *indio_dev,
>  	mutex_lock(&indio_dev->mlock);
>  	if (indio_dev->currentmode == INDIO_BUFFER_TRIGGERED) {
>  		err = -EBUSY;
> -		goto read_error;
> +		goto out;
>  	} else {
>  		err = st_sensors_set_enable(indio_dev, true);
>  		if (err < 0)
> -			goto read_error;
> +			goto out;
>  
>  		msleep((sdata->sensor->bootime * 1000) / sdata->odr);
>  		err = st_sensors_read_axis_data(indio_dev, ch, val);
>  		if (err < 0)
> -			goto read_error;
> +			goto out;
>  
>  		*val = *val >> ch->scan_type.shift;
>  
>  		err = st_sensors_set_enable(indio_dev, false);
>  	}
> +out:
>  	mutex_unlock(&indio_dev->mlock);
>  
>  	return err;
> -
> -read_error:
> -	mutex_unlock(&indio_dev->mlock);
> -	return err;
>  }
>  EXPORT_SYMBOL(st_sensors_read_info_raw);
>  
> 
