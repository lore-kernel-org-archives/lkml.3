Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754139AbaLAT3J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 14:29:09 -0500
Received: from hqemgate15.nvidia.com ([216.228.121.64]:1710 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752854AbaLAT3H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 14:29:07 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Mon, 01 Dec 2014 11:27:19 -0800
Message-ID: <547CC19B.1060708@nvidia.com>
Date: Mon, 1 Dec 2014 11:29:31 -0800
From: navneet kumar <navneetk@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
MIME-Version: 1.0
To: Eduardo Valentin <edubezval@gmail.com>
CC: <rui.zhang@intel.com>, <linux-pm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/3] thermal: of: consolidate sensor callbacks as ops
References: <1417050989-25405-1-git-send-email-navneetk@nvidia.com> <1417050989-25405-2-git-send-email-navneetk@nvidia.com> <20141127142823.GC3342@developer>
In-Reply-To: <20141127142823.GC3342@developer>
X-Originating-IP: [172.17.185.249]
X-ClientProxiedBy: HQMAIL104.nvidia.com (172.18.146.11) To
 HQMAIL104.nvidia.com (172.18.146.11)
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Eduardo,

On 11/27/2014 06:28 AM, Eduardo Valentin wrote:
> * PGP Signed by an unknown key
> 
> 
> Hello Navneet,
> 
> On Wed, Nov 26, 2014 at 05:16:28PM -0800, Navneet Kumar wrote:
>> From: navneet kumar <navneetk@nvidia.com>
>>
>> Consolidate all the sensor callbacks (get_temp/get_trend)
>> into a 'thermal_of_sensor_ops' struct.
>>
>> As a part of this, introduce a 'thermal_zone_of_sensor_register2'
>> sensor API that accepts sensor_ops instead of the two callbacks
>> as separate arguments to the register function.
> 
> This is usually not a good thing to do. Specially about the suffix
> '.*2', sounds really broken :-(. Best thing to do is to update the API
> with the improvement, and update all the users of that old API. 
> 
> This is one of the key Linux design decision. Please, have a look at:
> Documentation/stable_api_nonsense.txt
> 
> To understand why doing such thing is a bad thing to do.
> 
Thanks for correcting me. I was thinking on the lines of staging this patch as-
1. release a *register2
2. fixup rest of the drivers ( as a separate patch) to use *register2
3. rename all the references of register2 as register and eventually terminate
the use of the old signature'd API.

Either ways, i see your patch now, and will do the needful rebase too!

thanks again.
>>
>> Modify the older version of register function to call register2.
>>
>> Adjust all the references to get_temp/get_trend callbacks.
>>
>> Signed-off-by: navneet kumar <navneetk@nvidia.com>
>> ---
>>  drivers/thermal/of-thermal.c | 78 ++++++++++++++++++++++++++++----------------
>>  include/linux/thermal.h      | 14 ++++++++
>>  2 files changed, 64 insertions(+), 28 deletions(-)
>>
>> diff --git a/drivers/thermal/of-thermal.c b/drivers/thermal/of-thermal.c
>> index cf9ee3e82fee..3d47a0cf3825 100644
>> --- a/drivers/thermal/of-thermal.c
>> +++ b/drivers/thermal/of-thermal.c
>> @@ -96,8 +96,7 @@ struct __thermal_zone {
>>  
>>  	/* sensor interface */
>>  	void *sensor_data;
>> -	int (*get_temp)(void *, long *);
>> -	int (*get_trend)(void *, long *);
>> +	struct thermal_of_sensor_ops sops;
> 
> Have you seen this patch:
> https://git.kernel.org/cgit/linux/kernel/git/evalenti/linux-soc-thermal.git/commit/?h=linus&id=2251aef64a38db60f4ae7a4a83f9203c6791f196
> 
> ?
> 
> Please rebase your changes on top of my -linus branch:
> git://git.kernel.org/pub/scm/linux/kernel/git/evalenti/linux-soc-thermal.git linus
> 
> 
> BR,
> 
> Eduardo Valentin
>>  };
>>  
>>  /***   DT thermal zone device callbacks   ***/
>> @@ -107,10 +106,10 @@ static int of_thermal_get_temp(struct thermal_zone_device *tz,
>>  {
>>  	struct __thermal_zone *data = tz->devdata;
>>  
>> -	if (!data->get_temp)
>> +	if (!data->sops.get_temp)
>>  		return -EINVAL;
>>  
>> -	return data->get_temp(data->sensor_data, temp);
>> +	return data->sops.get_temp(data->sensor_data, temp);
>>  }
>>  
>>  static int of_thermal_get_trend(struct thermal_zone_device *tz, int trip,
>> @@ -120,10 +119,10 @@ static int of_thermal_get_trend(struct thermal_zone_device *tz, int trip,
>>  	long dev_trend;
>>  	int r;
>>  
>> -	if (!data->get_trend)
>> +	if (!data->sops.get_trend)
>>  		return -EINVAL;
>>  
>> -	r = data->get_trend(data->sensor_data, &dev_trend);
>> +	r = data->sops.get_trend(data->sensor_data, &dev_trend);
>>  	if (r)
>>  		return r;
>>  
>> @@ -324,8 +323,7 @@ static struct thermal_zone_device_ops of_thermal_ops = {
>>  static struct thermal_zone_device *
>>  thermal_zone_of_add_sensor(struct device_node *zone,
>>  			   struct device_node *sensor, void *data,
>> -			   int (*get_temp)(void *, long *),
>> -			   int (*get_trend)(void *, long *))
>> +			   struct thermal_of_sensor_ops *sops)
>>  {
>>  	struct thermal_zone_device *tzd;
>>  	struct __thermal_zone *tz;
>> @@ -337,8 +335,9 @@ thermal_zone_of_add_sensor(struct device_node *zone,
>>  	tz = tzd->devdata;
>>  
>>  	mutex_lock(&tzd->lock);
>> -	tz->get_temp = get_temp;
>> -	tz->get_trend = get_trend;
>> +	if (sops)
>> +		memcpy(&(tz->sops), sops, sizeof(*sops));
>> +
>>  	tz->sensor_data = data;
>>  
>>  	tzd->ops->get_temp = of_thermal_get_temp;
>> @@ -349,15 +348,15 @@ thermal_zone_of_add_sensor(struct device_node *zone,
>>  }
>>  
>>  /**
>> - * thermal_zone_of_sensor_register - registers a sensor to a DT thermal zone
>> + * thermal_zone_of_sensor_register2 - registers a sensor to a DT thermal zone
>>   * @dev: a valid struct device pointer of a sensor device. Must contain
>>   *       a valid .of_node, for the sensor node.
>>   * @sensor_id: a sensor identifier, in case the sensor IP has more
>>   *             than one sensors
>>   * @data: a private pointer (owned by the caller) that will be passed
>>   *        back, when a temperature reading is needed.
>> - * @get_temp: a pointer to a function that reads the sensor temperature.
>> - * @get_trend: a pointer to a function that reads the sensor temperature trend.
>> + * @sops: handle to the sensor ops (get_temp/get_trend etc.) provided by the
>> + *		sensor to OF.
>>   *
>>   * This function will search the list of thermal zones described in device
>>   * tree and look for the zone that refer to the sensor device pointed by
>> @@ -370,21 +369,13 @@ thermal_zone_of_add_sensor(struct device_node *zone,
>>   * The thermal zone temperature trend is provided by the @get_trend function
>>   * pointer. When called, it will have the private pointer @data back.
>>   *
>> - * TODO:
>> - * 01 - This function must enqueue the new sensor instead of using
>> - * it as the only source of temperature values.
>> - *
>> - * 02 - There must be a way to match the sensor with all thermal zones
>> - * that refer to it.
>> - *
>>   * Return: On success returns a valid struct thermal_zone_device,
>>   * otherwise, it returns a corresponding ERR_PTR(). Caller must
>>   * check the return value with help of IS_ERR() helper.
>>   */
>>  struct thermal_zone_device *
>> -thermal_zone_of_sensor_register(struct device *dev, int sensor_id,
>> -				void *data, int (*get_temp)(void *, long *),
>> -				int (*get_trend)(void *, long *))
>> +thermal_zone_of_sensor_register2(struct device *dev, int sensor_id,
>> +				void *data, struct thermal_of_sensor_ops *sops)
>>  {
>>  	struct device_node *np, *child, *sensor_np;
>>  	struct thermal_zone_device *tzd = ERR_PTR(-ENODEV);
>> @@ -426,9 +417,8 @@ thermal_zone_of_sensor_register(struct device *dev, int sensor_id,
>>  
>>  		if (sensor_specs.np == sensor_np && id == sensor_id) {
>>  			tzd = thermal_zone_of_add_sensor(child, sensor_np,
>> -							 data,
>> -							 get_temp,
>> -							 get_trend);
>> +							  data,
>> +							  sops);
>>  			of_node_put(sensor_specs.np);
>>  			of_node_put(child);
>>  			goto exit;
>> @@ -441,6 +431,38 @@ exit:
>>  
>>  	return tzd;
>>  }
>> +EXPORT_SYMBOL_GPL(thermal_zone_of_sensor_register2);
>> +
>> +/**
>> + * thermal_zone_of_sensor_register - registers a sensor to a DT thermal zone
>> + * @dev: a valid struct device pointer of a sensor device. Must contain
>> + *       a valid .of_node, for the sensor node.
>> + * @sensor_id: a sensor identifier, in case the sensor IP has more
>> + *             than one sensors
>> + * @data: a private pointer (owned by the caller) that will be passed
>> + *        back, when a temperature reading is needed.
>> + * @get_temp: a pointer to a function that reads the sensor temperature.
>> + * @get_trend: a pointer to a function that reads the sensor temperature trend.
>> + *
>> + * This function calls thermal_zone_of_sensor_register2 after translating
>> + * the sensor callbacks into a single structi (sops).
>> + *
>> + * Return: Bubbles up the return status from thermal_zone_of_register2
>> + *
>> + */
>> +struct thermal_zone_device *
>> +thermal_zone_of_sensor_register(struct device *dev, int sensor_id,
>> +				void *data, int (*get_temp)(void *, long *),
>> +				int (*get_trend)(void *, long *))
>> +{
>> +	struct thermal_of_sensor_ops sops = {
>> +		.get_temp = get_temp,
>> +		.get_trend = get_trend,
>> +	};
>> +
>> +	return thermal_zone_of_sensor_register2(dev, sensor_id, data, &sops);
>> +
>> +}
>>  EXPORT_SYMBOL_GPL(thermal_zone_of_sensor_register);
>>  
>>  /**
>> @@ -476,8 +498,8 @@ void thermal_zone_of_sensor_unregister(struct device *dev,
>>  	tzd->ops->get_temp = NULL;
>>  	tzd->ops->get_trend = NULL;
>>  
>> -	tz->get_temp = NULL;
>> -	tz->get_trend = NULL;
>> +	tz->sops.get_temp = NULL;
>> +	tz->sops.get_trend = NULL;
>>  	tz->sensor_data = NULL;
>>  	mutex_unlock(&tzd->lock);
>>  }
>> diff --git a/include/linux/thermal.h b/include/linux/thermal.h
>> index ef90838b36a0..58341c56a01f 100644
>> --- a/include/linux/thermal.h
>> +++ b/include/linux/thermal.h
>> @@ -289,6 +289,11 @@ struct thermal_genl_event {
>>  	enum events event;
>>  };
>>  
>> +struct thermal_of_sensor_ops {
>> +	int (*get_temp)(void *, long *);
>> +	int (*get_trend)(void *, long *);
>> +};
>> +
>>  /* Function declarations */
>>  #ifdef CONFIG_THERMAL_OF
>>  struct thermal_zone_device *
>> @@ -297,6 +302,9 @@ thermal_zone_of_sensor_register(struct device *dev, int id,
>>  				int (*get_trend)(void *, long *));
>>  void thermal_zone_of_sensor_unregister(struct device *dev,
>>  				       struct thermal_zone_device *tz);
>> +struct thermal_zone_device *
>> +thermal_zone_of_sensor_register2(struct device *dev, int sensor_id,
>> +				void *data, struct thermal_of_sensor_ops *sops);
>>  #else
>>  static inline struct thermal_zone_device *
>>  thermal_zone_of_sensor_register(struct device *dev, int id,
>> @@ -312,6 +320,12 @@ void thermal_zone_of_sensor_unregister(struct device *dev,
>>  {
>>  }
>>  
>> +static inline struct thermal_zone_device *
>> +thermal_zone_of_sensor_register2(struct device *dev, int sensor_id,
>> +				void *data, struct thermal_of_sensor_ops *sops)
>> +{
>> +	return NULL;
>> +}
>>  #endif
>>  struct thermal_zone_device *thermal_zone_device_register(const char *, int, int,
>>  		void *, struct thermal_zone_device_ops *,
>> -- 
>> 1.8.1.5
>>
> 
> * Unknown Key
> * 0x7DA4E256
> 
