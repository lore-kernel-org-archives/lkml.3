Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932200Ab3INQHM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Sep 2013 12:07:12 -0400
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:42817 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756674Ab3INQHK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Sep 2013 12:07:10 -0400
Message-ID: <523497CC.2040407@kernel.org>
Date: Sat, 14 Sep 2013 18:07:24 +0100
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130806 Thunderbird/17.0.8
MIME-Version: 1.0
To: Lee Jones <lee.jones@linaro.org>
CC: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arnd@arndb.de, linus.walleij@linaro.org, denis.ciocca@st.com,
        linux-iio@vger.kernel.org
Subject: Re: [PATCH 18/38] iio: sensors-core: st: Allow full-scale to be an
 optional feature
References: <1378817379-8238-1-git-send-email-lee.jones@linaro.org> <1378817379-8238-19-git-send-email-lee.jones@linaro.org> <523492BB.5070004@kernel.org>
In-Reply-To: <523492BB.5070004@kernel.org>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/14/13 17:45, Jonathan Cameron wrote:
> On 09/10/13 13:49, Lee Jones wrote:
>> Some chips either don't support it or fail to provide adequate documentation,
>> so sometimes it's impossible to enable the feature even if it is supported.
>>
>> Signed-off-by: Lee Jones <lee.jones@linaro.org>
> Applied to the togreg branch of iio.git
> 
Note that Denis Acked this in v1 and it hasn't changed substantially that I can see.
Hence you should have added that ack to this reposting.  I nearly missed it.
> Thanks
>> ---
>>  drivers/iio/common/st_sensors/st_sensors_core.c | 11 +++++++----
>>  drivers/iio/pressure/st_pressure_core.c         |  6 ++++--
>>  2 files changed, 11 insertions(+), 6 deletions(-)
>>
>> diff --git a/drivers/iio/common/st_sensors/st_sensors_core.c b/drivers/iio/common/st_sensors/st_sensors_core.c
>> index 965ee22..eb261a5 100644
>> --- a/drivers/iio/common/st_sensors/st_sensors_core.c
>> +++ b/drivers/iio/common/st_sensors/st_sensors_core.c
>> @@ -235,10 +235,13 @@ int st_sensors_init_sensor(struct iio_dev *indio_dev,
>>  	if (err < 0)
>>  		goto init_error;
>>  
>> -	err = st_sensors_set_fullscale(indio_dev,
>> -						sdata->current_fullscale->num);
>> -	if (err < 0)
>> -		goto init_error;
>> +	if (sdata->current_fullscale) {
>> +		err = st_sensors_set_fullscale(indio_dev,
>> +					       sdata->current_fullscale->num);
>> +		if (err < 0)
>> +			goto init_error;
>> +	} else
>> +		dev_info(&indio_dev->dev, "Full-scale not possible\n");
>>  
>>  	err = st_sensors_set_odr(indio_dev, sdata->odr);
>>  	if (err < 0)
>> diff --git a/drivers/iio/pressure/st_pressure_core.c b/drivers/iio/pressure/st_pressure_core.c
>> index ceebd3c..16cfbc5 100644
>> --- a/drivers/iio/pressure/st_pressure_core.c
>> +++ b/drivers/iio/pressure/st_pressure_core.c
>> @@ -226,8 +226,10 @@ int st_press_common_probe(struct iio_dev *indio_dev,
>>  	indio_dev->channels = pdata->sensor->ch;
>>  	indio_dev->num_channels = ARRAY_SIZE(st_press_channels);
>>  
>> -	pdata->current_fullscale = (struct st_sensor_fullscale_avl *)
>> -						&pdata->sensor->fs.fs_avl[0];
>> +	if (pdata->sensor->fs.addr != 0)
>> +		pdata->current_fullscale = (struct st_sensor_fullscale_avl *)
>> +			&pdata->sensor->fs.fs_avl[0];
>> +
>>  	pdata->odr = pdata->sensor->odr.odr_avl[0].hz;
>>  
>>  	if (!plat_data)
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-iio" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
