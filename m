Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752566Ab3IUMHI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Sep 2013 08:07:08 -0400
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:57479 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752123Ab3IUMHG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Sep 2013 08:07:06 -0400
Message-ID: <523D9A0D.50306@kernel.org>
Date: Sat, 21 Sep 2013 14:07:25 +0100
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130806 Thunderbird/17.0.8
MIME-Version: 1.0
To: Lee Jones <lee.jones@linaro.org>
CC: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        jic23@cam.ac.uk, arnd@arndb.de, linus.walleij@linaro.org,
        denis.ciocca@st.com, linux-iio@vger.kernel.org
Subject: Re: [PATCH 11/20] iio: sensors-core: st: Support sensors which don't
 have a Data Ready pin
References: <1379347346-823-1-git-send-email-lee.jones@linaro.org> <1379347346-823-12-git-send-email-lee.jones@linaro.org> <523D9649.4080409@kernel.org>
In-Reply-To: <523D9649.4080409@kernel.org>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/21/13 13:51, Jonathan Cameron wrote:
> On 09/16/13 17:02, Lee Jones wrote:
>> Not all ST's sensors support data ready, so let's make the declaration
>> of one conditional.
>>
>> Signed-off-by: Lee Jones <lee.jones@linaro.org>
> Applied to the togreg branch of iio.git
> 
> Thanks Lee
Having done some extra build tests, noticed that
for st_snesors_set_drdy_int_pin should be static.

Fixed up and push out to the togreg branch of iio.git

>> ---
>>  drivers/iio/common/st_sensors/st_sensors_core.c | 33 ++++++++++++++++---------
>>  drivers/iio/pressure/st_pressure_core.c         |  3 ++-
>>  2 files changed, 24 insertions(+), 12 deletions(-)
>>
>> diff --git a/drivers/iio/common/st_sensors/st_sensors_core.c b/drivers/iio/common/st_sensors/st_sensors_core.c
>> index 793136a..2672630 100644
>> --- a/drivers/iio/common/st_sensors/st_sensors_core.c
>> +++ b/drivers/iio/common/st_sensors/st_sensors_core.c
>> @@ -198,21 +198,17 @@ int st_sensors_set_axis_enable(struct iio_dev *indio_dev, u8 axis_enable)
>>  }
>>  EXPORT_SYMBOL(st_sensors_set_axis_enable);
>>  
>> -int st_sensors_init_sensor(struct iio_dev *indio_dev,
>> -					struct st_sensors_platform_data *pdata)
>> +int st_sensors_set_drdy_int_pin(struct iio_dev *indio_dev,
>> +				struct st_sensors_platform_data *pdata)
>>  {
>> -	int err;
>>  	struct st_sensor_data *sdata = iio_priv(indio_dev);
>>  
>> -	mutex_init(&sdata->tb.buf_lock);
>> -
>>  	switch (pdata->drdy_int_pin) {
>>  	case 1:
>>  		if (sdata->sensor->drdy_irq.mask_int1 == 0) {
>>  			dev_err(&indio_dev->dev,
>>  					"DRDY on INT1 not available.\n");
>> -			err = -EINVAL;
>> -			goto init_error;
>> +			return -EINVAL;
>>  		}
>>  		sdata->drdy_int_pin = 1;
>>  		break;
>> @@ -220,17 +216,29 @@ int st_sensors_init_sensor(struct iio_dev *indio_dev,
>>  		if (sdata->sensor->drdy_irq.mask_int2 == 0) {
>>  			dev_err(&indio_dev->dev,
>>  					"DRDY on INT2 not available.\n");
>> -			err = -EINVAL;
>> -			goto init_error;
>> +			return -EINVAL;
>>  		}
>>  		sdata->drdy_int_pin = 2;
>>  		break;
>>  	default:
>>  		dev_err(&indio_dev->dev, "DRDY on pdata not valid.\n");
>> -		err = -EINVAL;
>> -		goto init_error;
>> +		return -EINVAL;
>>  	}
>>  
>> +	return 0;
>> +}
>> +
>> +int st_sensors_init_sensor(struct iio_dev *indio_dev,
>> +					struct st_sensors_platform_data *pdata)
>> +{
>> +	struct st_sensor_data *sdata = iio_priv(indio_dev);
>> +	int err = 0;
>> +
>> +	mutex_init(&sdata->tb.buf_lock);
>> +
>> +	if (pdata)
>> +		err = st_sensors_set_drdy_int_pin(indio_dev, pdata);
>> +
>>  	err = st_sensors_set_enable(indio_dev, false);
>>  	if (err < 0)
>>  		goto init_error;
>> @@ -266,6 +274,9 @@ int st_sensors_set_dataready_irq(struct iio_dev *indio_dev, bool enable)
>>  	u8 drdy_mask;
>>  	struct st_sensor_data *sdata = iio_priv(indio_dev);
>>  
>> +	if (!sdata->sensor->drdy_irq.addr)
>> +		return 0;
>> +
>>  	/* Enable/Disable the interrupt generator 1. */
>>  	if (sdata->sensor->drdy_irq.ig1.en_addr > 0) {
>>  		err = st_sensors_write_data_with_mask(indio_dev,
>> diff --git a/drivers/iio/pressure/st_pressure_core.c b/drivers/iio/pressure/st_pressure_core.c
>> index 93bff9b..3abada2 100644
>> --- a/drivers/iio/pressure/st_pressure_core.c
>> +++ b/drivers/iio/pressure/st_pressure_core.c
>> @@ -254,7 +254,8 @@ int st_press_common_probe(struct iio_dev *indio_dev,
>>  
>>  	pdata->odr = pdata->sensor->odr.odr_avl[0].hz;
>>  
>> -	if (!plat_data)
>> +	/* Some devices don't support a data ready pin. */
>> +	if (!plat_data && pdata->sensor->drdy_irq.addr)
>>  		plat_data =
>>  			(struct st_sensors_platform_data *)&default_press_pdata;
>>  
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-iio" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
