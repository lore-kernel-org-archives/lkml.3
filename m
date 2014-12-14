Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753295AbaLNOGQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2014 09:06:16 -0500
Received: from a.ns.miles-group.at ([95.130.255.143]:65275 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750789AbaLNOGO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2014 09:06:14 -0500
Message-ID: <548D9951.1070003@nod.at>
Date: Sun, 14 Dec 2014 15:06:09 +0100
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: Hartmut Knaack <knaack.h@gmx.de>, jic23@kernel.org
CC: harald@ccbib.org, lars@metafoo.de, pmeerw@pmeerw.net,
        sanjeev_sharma@mentor.com, linux-iio@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] iio: dht11: Add locking
References: <1417563176-31972-1-git-send-email-richard@nod.at> <1417563176-31972-2-git-send-email-richard@nod.at> <548D8317.2070405@gmx.de>
In-Reply-To: <548D8317.2070405@gmx.de>
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 14.12.2014 um 13:31 schrieb Hartmut Knaack:
> Richard Weinberger schrieb am 03.12.2014 um 00:32:
>> Make sure that the read function is not interrupted...
> There is already a mutex iio_dev->info_exist_lock used to serialize
> iio_channel_read(), which in turn accesses _read_raw(). See [1].
> 
> [1]http://lxr.free-electrons.com/ident?i=iio_channel_read

This is only for the in-kernel API and not for sysfs access.
I.e. if you access via sysfs it is not protected.

Thanks,
//richard

>> Signed-off-by: Richard Weinberger <richard@nod.at>
>> ---
>>  drivers/iio/humidity/dht11.c | 5 +++++
>>  1 file changed, 5 insertions(+)
>>
>> diff --git a/drivers/iio/humidity/dht11.c b/drivers/iio/humidity/dht11.c
>> index d8771f5..168ebc4 100644
>> --- a/drivers/iio/humidity/dht11.c
>> +++ b/drivers/iio/humidity/dht11.c
>> @@ -29,6 +29,7 @@
>>  #include <linux/wait.h>
>>  #include <linux/bitops.h>
>>  #include <linux/completion.h>
>> +#include <linux/mutex.h>
>>  #include <linux/delay.h>
>>  #include <linux/gpio.h>
>>  #include <linux/of_gpio.h>
>> @@ -57,6 +58,7 @@ struct dht11 {
>>  	int				irq;
>>  
>>  	struct completion		completion;
>> +	struct mutex			lock;
>>  
>>  	s64				timestamp;
>>  	int				temperature;
>> @@ -145,6 +147,7 @@ static int dht11_read_raw(struct iio_dev *iio_dev,
>>  	struct dht11 *dht11 = iio_priv(iio_dev);
>>  	int ret;
>>  
>> +	mutex_lock(&dht11->lock);
>>  	if (dht11->timestamp + DHT11_DATA_VALID_TIME < iio_get_time_ns()) {
>>  		reinit_completion(&dht11->completion);
>>  
>> @@ -185,6 +188,7 @@ static int dht11_read_raw(struct iio_dev *iio_dev,
>>  		ret = -EINVAL;
>>  err:
>>  	dht11->num_edges = -1;
>> +	mutex_unlock(&dht11->lock);
>>  	return ret;
>>  }
>>  
>> @@ -268,6 +272,7 @@ static int dht11_probe(struct platform_device *pdev)
>>  	platform_set_drvdata(pdev, iio);
>>  
>>  	init_completion(&dht11->completion);
>> +	mutex_init(&dht11->lock);
>>  	iio->name = pdev->name;
>>  	iio->dev.parent = &pdev->dev;
>>  	iio->info = &dht11_iio_info;
>>
> 
