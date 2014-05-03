Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751902AbaECKPd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2014 06:15:33 -0400
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:51170 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750960AbaECKPc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2014 06:15:32 -0400
Message-ID: <5364C220.5010007@kernel.org>
Date: Sat, 03 May 2014 11:17:04 +0100
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Hartmut Knaack <knaack.h@gmx.de>, Dan Carpenter <dan.carpenter@oracle.com>
CC: Lars-Peter Clausen <lars@metafoo.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Aida Mynzhasova <ai.c.c0der@gmail.com>,
        Masanari Iida <standby24x7@gmail.com>, linux-iio@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [patch v2] [patch] staging: iio: ad799x: remove some unneeded
 IS_ERR() checks
References: <20140430210529.GA6008@mwanda> <536170B9.8030708@gmx.de>
In-Reply-To: <536170B9.8030708@gmx.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 30/04/14 22:52, Hartmut Knaack wrote:
> Dan Carpenter schrieb:
>> My static checker is upset that we check IS_ERR(t->reg) when we know it
>> is not an ERR_PTR.
>>
>> Checking for IS_ERR() twice is often a sign of confusion and buggy code.
>> In this case, if the call to "ret = regulator_enable(st->vref);" fails,
>> then we call "regulator_disable(st->vref);" and that's a mistake because
>> "st->vref" is not enabled.
>>
>> I fixed these problems and Hartmut Knaack pointed out a couple unneeded
>> IS_ERR() checks in ad799x_remove() so I have removed those as well.
>>
>> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> Acked-by: Hartmut Knaack <knaack.h@gmx.de>
Thanks to both of you for this.

Applied to the togreg branch of iio.git as the cleanup that caused
this was most likely part of a series that is only in staging-next at
the moment.

Jonathan

>> ---
>> v2: remove the unneeded checks in ad799x_remove() as well.  Updated the
>>      commit message to say that it's actually a small bug fix.
>>
>> diff --git a/drivers/iio/adc/ad799x.c b/drivers/iio/adc/ad799x.c
>> index 16a8b14..39b4cb4 100644
>> --- a/drivers/iio/adc/ad799x.c
>> +++ b/drivers/iio/adc/ad799x.c
>> @@ -717,7 +717,7 @@ static int ad799x_probe(struct i2c_client *client,
>>   	ret = iio_triggered_buffer_setup(indio_dev, NULL,
>>   		&ad799x_trigger_handler, NULL);
>>   	if (ret)
>> -		goto error_disable_reg;
>> +		goto error_disable_vref;
>>
>>   	if (client->irq > 0) {
>>   		ret = devm_request_threaded_irq(&client->dev,
>> @@ -739,11 +739,10 @@ static int ad799x_probe(struct i2c_client *client,
>>
>>   error_cleanup_ring:
>>   	iio_triggered_buffer_cleanup(indio_dev);
>> +error_disable_vref:
>> +	regulator_disable(st->vref);
>>   error_disable_reg:
>> -	if (!IS_ERR(st->vref))
>> -		regulator_disable(st->vref);
>> -	if (!IS_ERR(st->reg))
>> -		regulator_disable(st->reg);
>> +	regulator_disable(st->reg);
>>
>>   	return ret;
>>   }
>> @@ -756,10 +755,8 @@ static int ad799x_remove(struct i2c_client *client)
>>   	iio_device_unregister(indio_dev);
>>
>>   	iio_triggered_buffer_cleanup(indio_dev);
>> -	if (!IS_ERR(st->vref))
>> -		regulator_disable(st->vref);
>> -	if (!IS_ERR(st->reg))
>> -		regulator_disable(st->reg);
>> +	regulator_disable(st->vref);
>> +	regulator_disable(st->reg);
>>   	kfree(st->rx_buf);
>>
>>   	return 0;
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-iio" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>

