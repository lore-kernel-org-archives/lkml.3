Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932537AbaLAUp3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 15:45:29 -0500
Received: from hqemgate14.nvidia.com ([216.228.121.143]:15813 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932248AbaLAUp0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 15:45:26 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Mon, 01 Dec 2014 12:43:20 -0800
Message-ID: <547CD380.3030707@nvidia.com>
Date: Mon, 1 Dec 2014 12:45:52 -0800
From: navneet kumar <navneetk@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
MIME-Version: 1.0
To: Eduardo Valentin <edubezval@gmail.com>
CC: <rui.zhang@intel.com>, <linux-pm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3] thermal: of: notify sensor driver on trip updates
References: <1417050989-25405-1-git-send-email-navneetk@nvidia.com> <1417050989-25405-3-git-send-email-navneetk@nvidia.com> <20141127143236.GD3342@developer>
In-Reply-To: <20141127143236.GD3342@developer>
X-Originating-IP: [172.17.185.249]
X-ClientProxiedBy: HQMAIL108.nvidia.com (172.18.146.13) To
 HQMAIL104.nvidia.com (172.18.146.11)
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Eduardo,

On 11/27/2014 06:32 AM, Eduardo Valentin wrote:
> * PGP Signed by an unknown key
> 
> Hello Navneet,
> 
> On Wed, Nov 26, 2014 at 05:16:29PM -0800, Navneet Kumar wrote:
>> From: navneet kumar <navneetk@nvidia.com>
>>
>> some thermal sensor hardwares include logic which
>> can raise interrupts at certain programmed temperature
>> thresholds.
>>
>> Drivers for such sensors should be able to learn the
>> appropriate threshold temperatures for interrupts by querying
>> the thermal framework.
>>
>> This change provides a mechanism to allow a sensor driver to
>> update it's thresholds when userspace changes a trip point
>> temperature.
>>
>> While this behavior may not make sense in thermal zones
>> with more than one sensor, no such examples exist in
>> the kernel.
>>
>> Signed-off-by: navneet kumar <navneetk@nvidia.com>
>> ---
>>  drivers/thermal/of-thermal.c | 7 +++++++
>>  include/linux/thermal.h      | 1 +
>>  2 files changed, 8 insertions(+)
>>
>> diff --git a/drivers/thermal/of-thermal.c b/drivers/thermal/of-thermal.c
>> index 3d47a0cf3825..3568e4a586dc 100644
>> --- a/drivers/thermal/of-thermal.c
>> +++ b/drivers/thermal/of-thermal.c
>> @@ -258,6 +258,9 @@ static int of_thermal_set_trip_temp(struct thermal_zone_device *tz, int trip,
>>  	/* thermal framework should take care of data->mask & (1 << trip) */
>>  	data->trips[trip].temperature = temp;
>>  
>> +	if (data->sops.trip_update)
>> +		data->sops.trip_update(data->sensor_data, trip);
>> +
>>  	return 0;
>>  }
>>  
>> @@ -285,6 +288,9 @@ static int of_thermal_set_trip_hyst(struct thermal_zone_device *tz, int trip,
>>  	/* thermal framework should take care of data->mask & (1 << trip) */
>>  	data->trips[trip].hysteresis = hyst;
>>  
>> +	if (data->sops.trip_update)
>> +		data->sops.trip_update(data->sensor_data, trip);
>> +
>>  	return 0;
>>  }
>>  
>> @@ -500,6 +506,7 @@ void thermal_zone_of_sensor_unregister(struct device *dev,
>>  
>>  	tz->sops.get_temp = NULL;
>>  	tz->sops.get_trend = NULL;
>> +	tz->sops.trip_update = NULL;
>>  	tz->sensor_data = NULL;
>>  	mutex_unlock(&tzd->lock);
>>  }
>> diff --git a/include/linux/thermal.h b/include/linux/thermal.h
>> index 58341c56a01f..b93e65815175 100644
>> --- a/include/linux/thermal.h
>> +++ b/include/linux/thermal.h
>> @@ -292,6 +292,7 @@ struct thermal_genl_event {
>>  struct thermal_of_sensor_ops {
>>  	int (*get_temp)(void *, long *);
>>  	int (*get_trend)(void *, long *);
>> +	int (*trip_update)(void *, int);
> 
> First thing I ask you is to update your work on top of my -linus branch,
> as I already mentioned. Reasoning is that part of the changes you are
> sending is already there.
will do.
> 
> As for this new callback, I am fine with it as long as it is also
> available for drivers that do not use of-thermal. Once again, of-thermal
> is not a competitor of thermal core. It will never be. It is not a new
> thermal API. 
I agree that this callback is not a part of the thermal_core functionality.
However, when a driver registers directly with the thermal_core (doesn't use
of-thermal), it 'owns' the set_trip_XX callbacks in the first place; which is
the sole purpose of using the 'trip_update' callback in of-thermal.

Adding an additional 'update' to the thermal_core ops would be a no-op. right?
> 
> That said, it does not make sense to have functionality in of-thermal that
> do not belong to thermal core. Exceptions are, of course, for helping
> doing the same operations we already have in thermal core.
> 
> All the best,
> 
> Eduardo Valentin
> 
>>  };
>>  
>>  /* Function declarations */
>> -- 
>> 1.8.1.5
>>
> 
> * Unknown Key
> * 0x7DA4E256
> 
