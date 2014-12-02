Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754556AbaLBKwf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 05:52:35 -0500
Received: from a.ns.miles-group.at ([95.130.255.143]:65275 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752939AbaLBKwW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 05:52:22 -0500
Message-ID: <547D99DE.6030309@nod.at>
Date: Tue, 02 Dec 2014 11:52:14 +0100
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: Harald Geyer <harald@ccbib.org>
CC: jic23@kernel.org, knaack.h@gmx.de, lars@metafoo.de, pmeerw@pmeerw.net,
        sanjeev_sharma@mentor.com, linux-iio@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] iio: dht11: Add locking
References: <1417465651-16036-1-git-send-email-richard@nod.at> <E1XvkMu-000137-KP@stardust.g4.wien.funkfeuer.at>
In-Reply-To: <E1XvkMu-000137-KP@stardust.g4.wien.funkfeuer.at>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Harald,

Am 02.12.2014 um 11:07 schrieb Harald Geyer:
> Hi Richard,
> 
> thanks for the patch. Comments inline.
> 
> Richard Weinberger writes:
>> Protect the read function from concurrent reads.
>>
>> Signed-off-by: Richard Weinberger <richard@nod.at>
>> ---
>>  drivers/iio/humidity/dht11.c | 19 ++++++++++++++-----
>>  1 file changed, 14 insertions(+), 5 deletions(-)
>>
>> diff --git a/drivers/iio/humidity/dht11.c b/drivers/iio/humidity/dht11.c
>> index 623c145..7636e66 100644
>> --- a/drivers/iio/humidity/dht11.c
>> +++ b/drivers/iio/humidity/dht11.c
> 
> #include <linux/mutex.h>
> 
>> @@ -57,6 +57,7 @@ struct dht11 {
>>  	int				irq;
>>  
>>  	struct completion		completion;
>> +	struct mutex			lock;
>>  
>>  	s64				timestamp;
>>  	int				temperature;
>> @@ -146,16 +147,17 @@ static int dht11_read_raw(struct iio_dev *iio_dev,
>>  	int ret;
>>  
>>  	if (dht11->timestamp + DHT11_DATA_VALID_TIME < iio_get_time_ns()) {
>> +		mutex_lock(&dht11->lock);
> 
> Move the locking out of the if statement.

Care to explain why?

But I found another issue in my patch.
The "dht11->num_edges = -1;" before "return ret" needs to go into the locked area.
Will send an updated version soon.

> BTW, it seems that there is already locking around read_raw() in the
> in-kernel consumer interface but not in the sysfs interface. Is there
> any reason for this difference?

Dunno. :-)

Thanks,
//richard
