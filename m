Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752675AbbADKmO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2015 05:42:14 -0500
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:48025 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751753AbbADKmN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2015 05:42:13 -0500
Message-ID: <54A91903.3020800@kernel.org>
Date: Sun, 04 Jan 2015 10:42:11 +0000
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Hartmut Knaack <knaack.h@gmx.de>, Daniel Baluta <daniel.baluta@intel.com>
CC: lars@metafoo.de, pmeerw@pmeerw.net, linux-iio@vger.kernel.org,
        linux-kernel@vger.kernel.org, srinivas.pandruvada@linux.intel.com
Subject: Re: [PATCH 02/10] iio: imu: kmx61: Don't ignore kmx61_set_power_state
 errors
References: <1419340953-23161-1-git-send-email-daniel.baluta@intel.com> <1419340953-23161-3-git-send-email-daniel.baluta@intel.com> <54A54F91.3000403@gmx.de>
In-Reply-To: <54A54F91.3000403@gmx.de>
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/01/15 13:45, Hartmut Knaack wrote:
> Daniel Baluta schrieb am 23.12.2014 um 14:22:
>> ..except while in an error handler, where there is nothing
>> to be done anyway.
>>
>> Signed-off-by: Daniel Baluta <daniel.baluta@intel.com>
> Reviewed-by: Hartmut Knaack <knaack.h@gmx.de>
Applied
>> ---
>>  drivers/iio/imu/kmx61.c | 11 +++++++++--
>>  1 file changed, 9 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/iio/imu/kmx61.c b/drivers/iio/imu/kmx61.c
>> index fe0cee7..e9cbd91 100644
>> --- a/drivers/iio/imu/kmx61.c
>> +++ b/drivers/iio/imu/kmx61.c
>> @@ -830,7 +830,12 @@ static int kmx61_read_raw(struct iio_dev *indio_dev,
>>  		}
>>  		mutex_lock(&data->lock);
>>  
>> -		kmx61_set_power_state(data, true, chan->address);
>> +		ret = kmx61_set_power_state(data, true, chan->address);
>> +		if (ret) {
>> +			mutex_unlock(&data->lock);
>> +			return ret;
>> +		}
>> +
>>  		ret = kmx61_read_measurement(data, base_reg, chan->scan_index);
>>  		if (ret < 0) {
>>  			kmx61_set_power_state(data, false, chan->address);
>> @@ -839,9 +844,11 @@ static int kmx61_read_raw(struct iio_dev *indio_dev,
>>  		}
>>  		*val = sign_extend32(ret >> chan->scan_type.shift,
>>  				     chan->scan_type.realbits - 1);
>> -		kmx61_set_power_state(data, false, chan->address);
>> +		ret = kmx61_set_power_state(data, false, chan->address);
>>  
>>  		mutex_unlock(&data->lock);
>> +		if (ret)
>> +			return ret;
>>  		return IIO_VAL_INT;
>>  	case IIO_CHAN_INFO_SCALE:
>>  		switch (chan->type) {
>>
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-iio" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

