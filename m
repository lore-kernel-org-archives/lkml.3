Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751418AbbAEFq4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 00:46:56 -0500
Received: from mga03.intel.com ([134.134.136.65]:42714 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751098AbbAEFqy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 00:46:54 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,697,1413270000"; 
   d="scan'208";a="656787191"
Message-ID: <54AA253F.2030207@intel.com>
Date: Mon, 05 Jan 2015 13:46:39 +0800
From: Aaron Lu <aaron.lu@intel.com>
MIME-Version: 1.0
To: Jingoo Han <jg1.han@samsung.com>
CC: "'Lee Jones'" <lee.jones@linaro.org>, "'Zhang Rui'" <rui.zhang@intel.com>,
        "'Rafael J. Wysocki'" <rjw@rjwysocki.net>, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org
Subject: Re: [PATCH 1/3] video / backlight: add two APIs for drivers to use
References: <1419997818-19528-1-git-send-email-aaron.lu@intel.com> <1419997818-19528-2-git-send-email-aaron.lu@intel.com> <000b01d026f1$408e3620$c1aaa260$%han@samsung.com>
In-Reply-To: <000b01d026f1$408e3620$c1aaa260$%han@samsung.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/03/2015 09:04 AM, Jingoo Han wrote:
> On Wednesday, December 31, 2014 12:50 PM, Aaron Lu wrote:
>>
>> It is useful to get the backlight device's pointer and use it to set
>> backlight in some cases(the following patch will make use of it) so add
>> the two APIs and export them.
>>
>> Signed-off-by: Aaron Lu <aaron.lu@intel.com>
> 
> Acked-by: Jingoo Han <jg1.han@samsung.com>

Thanks for the review!

Regards,
Aaron

> 
> Best regards,
> Jingoo Han
> 
>> ---
>>  drivers/video/backlight/backlight.c | 44 ++++++++++++++++++++++++-------------
>>  include/linux/backlight.h           |  2 ++
>>  2 files changed, 31 insertions(+), 15 deletions(-)
>>
>> diff --git a/drivers/video/backlight/backlight.c b/drivers/video/backlight/backlight.c
>> index bddc8b17a4d8..bea749329236 100644
>> --- a/drivers/video/backlight/backlight.c
>> +++ b/drivers/video/backlight/backlight.c
>> @@ -164,28 +164,19 @@ static ssize_t brightness_show(struct device *dev,
>>  	return sprintf(buf, "%d\n", bd->props.brightness);
>>  }
>>
>> -static ssize_t brightness_store(struct device *dev,
>> -		struct device_attribute *attr, const char *buf, size_t count)
>> +int backlight_device_set_brightness(struct backlight_device *bd, int brightness)
>>  {
>> -	int rc;
>> -	struct backlight_device *bd = to_backlight_device(dev);
>> -	unsigned long brightness;
>> -
>> -	rc = kstrtoul(buf, 0, &brightness);
>> -	if (rc)
>> -		return rc;
>> -
>> -	rc = -ENXIO;
>> +	int rc = -ENXIO;
>>
>>  	mutex_lock(&bd->ops_lock);
>>  	if (bd->ops) {
>>  		if (brightness > bd->props.max_brightness)
>>  			rc = -EINVAL;
>>  		else {
>> -			pr_debug("set brightness to %lu\n", brightness);
>> +			pr_debug("set brightness to %u\n", brightness);
>>  			bd->props.brightness = brightness;
>>  			backlight_update_status(bd);
>> -			rc = count;
>> +			rc = 0;
>>  		}
>>  	}
>>  	mutex_unlock(&bd->ops_lock);
>> @@ -194,6 +185,23 @@ static ssize_t brightness_store(struct device *dev,
>>
>>  	return rc;
>>  }
>> +EXPORT_SYMBOL(backlight_device_set_brightness);
>> +
>> +static ssize_t brightness_store(struct device *dev,
>> +		struct device_attribute *attr, const char *buf, size_t count)
>> +{
>> +	int rc;
>> +	struct backlight_device *bd = to_backlight_device(dev);
>> +	unsigned long brightness;
>> +
>> +	rc = kstrtoul(buf, 0, &brightness);
>> +	if (rc)
>> +		return rc;
>> +
>> +	rc = backlight_device_set_brightness(bd, brightness);
>> +
>> +	return rc ? rc : count;
>> +}
>>  static DEVICE_ATTR_RW(brightness);
>>
>>  static ssize_t type_show(struct device *dev, struct device_attribute *attr,
>> @@ -380,7 +388,7 @@ struct backlight_device *backlight_device_register(const char *name,
>>  }
>>  EXPORT_SYMBOL(backlight_device_register);
>>
>> -bool backlight_device_registered(enum backlight_type type)
>> +struct backlight_device *backlight_device_get_by_type(enum backlight_type type)
>>  {
>>  	bool found = false;
>>  	struct backlight_device *bd;
>> @@ -394,7 +402,13 @@ bool backlight_device_registered(enum backlight_type type)
>>  	}
>>  	mutex_unlock(&backlight_dev_list_mutex);
>>
>> -	return found;
>> +	return found ? bd : NULL;
>> +}
>> +EXPORT_SYMBOL(backlight_device_get_by_type);
>> +
>> +bool backlight_device_registered(enum backlight_type type)
>> +{
>> +	return backlight_device_get_by_type(type) ? true : false;
>>  }
>>  EXPORT_SYMBOL(backlight_device_registered);
>>
>> diff --git a/include/linux/backlight.h b/include/linux/backlight.h
>> index adb14a8616df..c59a020df3f8 100644
>> --- a/include/linux/backlight.h
>> +++ b/include/linux/backlight.h
>> @@ -140,6 +140,8 @@ extern void backlight_force_update(struct backlight_device *bd,
>>  extern bool backlight_device_registered(enum backlight_type type);
>>  extern int backlight_register_notifier(struct notifier_block *nb);
>>  extern int backlight_unregister_notifier(struct notifier_block *nb);
>> +extern struct backlight_device *backlight_device_get_by_type(enum backlight_type type);
>> +extern int backlight_device_set_brightness(struct backlight_device *bd, int brightness);
>>
>>  #define to_backlight_device(obj) container_of(obj, struct backlight_device, dev)
>>
>> --
>> 2.1.0
> 

