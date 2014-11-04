Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751909AbaKDVSR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 16:18:17 -0500
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:40518 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751324AbaKDVSP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 16:18:15 -0500
Message-ID: <54594232.2060709@linux.vnet.ibm.com>
Date: Wed, 05 Nov 2014 02:46:34 +0530
From: Neelesh Gupta <neelegup@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Guenter Roeck <linux@roeck-us.net>, jdelvare@suse.de
CC: benh@au1.ibm.com, linux-kernel@vger.kernel.org, michaele@au1.ibm.com,
        lm-sensors@lm-sensors.org
Subject: Re: [PATCH] hwmon: (ibmpowernv) Use platform 'id_table' to probe
 the device
References: <20141104072927.4307.67881.stgit@localhost.localdomain> <5458E294.40509@roeck-us.net>
In-Reply-To: <5458E294.40509@roeck-us.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14110421-0033-0000-0000-0000006EF812
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 11/04/2014 07:58 PM, Guenter Roeck wrote:
> On 11/03/2014 11:30 PM, Neelesh Gupta wrote:
>> The current driver probe() function assumes the sensor device to be
>> alwary present and gets executed every time if the driver is loaded,
>> but the appropriate hardware could not be present.
>>
>> So, move the platform device creation as part of platform init code
>> and use the 'id_table' to check if the device present or not.
>>
>> Signed-off-by: Neelesh Gupta <neelegup@linux.vnet.ibm.com>
>> ---
>>   arch/powerpc/platforms/powernv/opal-sensor.c |   20 ++++++++
>>   drivers/hwmon/ibmpowernv.c                   |   67 
>> +++++++-------------------
>>   2 files changed, 39 insertions(+), 48 deletions(-)
>>
>> diff --git a/arch/powerpc/platforms/powernv/opal-sensor.c 
>> b/arch/powerpc/platforms/powernv/opal-sensor.c
>> index 10271ad..215c418 100644
>> --- a/arch/powerpc/platforms/powernv/opal-sensor.c
>> +++ b/arch/powerpc/platforms/powernv/opal-sensor.c
>> @@ -20,7 +20,9 @@
>>
>>   #include <linux/delay.h>
>>   #include <linux/mutex.h>
>> +#include <linux/of_platform.h>
>>   #include <asm/opal.h>
>> +#include <asm/machdep.h>
>>
>>   static DEFINE_MUTEX(opal_sensor_mutex);
>>
>> @@ -64,3 +66,21 @@ out:
>>       return ret;
>>   }
>>   EXPORT_SYMBOL_GPL(opal_get_sensor_data);
>> +
>> +static __init int opal_sensor_init(void)
>> +{
>> +    struct platform_device *pdev;
>> +    struct device_node *sensor;
>> +
>> +    sensor = of_find_node_by_path("/ibm,opal/sensors");
>> +    if (sensor) {
>> +        pdev = of_platform_device_create(sensor, "opal-sensor", NULL);
>> +        of_node_put(sensor);
>> +    } else {
>> +        pr_info("Opal node 'sensors' not found\n");
>
> Hi Neelesh,
>
> this is either an error and should be reported with pr_err, or it is
> a valid condition and should be reported with pr_debug or not at all.
>
> Which one is it ?

Should be logged using pr_err(), will fix and send the next version.

Thanks,
Neelesh

>
> Also, can you put this code into a 'normal' error handler instead of 
> using if/else ?
>
>     if (!sensor) {
>         pr_err("Opal node 'sensors' not found\n");
>         return -ENODEV;
>     }
>     pdev = of_platform_device_create(sensor, "opal-sensor", NULL);
>     ...
>
> This would make the code flow easier to understand.
>
> Thanks,
> Guenter
>
>> +        return -ENODEV;
>> +    }
>> +
>> +    return PTR_ERR_OR_ZERO(pdev);
>> +}
>> +machine_subsys_initcall(powernv, opal_sensor_init);
>> diff --git a/drivers/hwmon/ibmpowernv.c b/drivers/hwmon/ibmpowernv.c
>> index 6a30eee..c7577b8 100644
>> --- a/drivers/hwmon/ibmpowernv.c
>> +++ b/drivers/hwmon/ibmpowernv.c
>> @@ -74,9 +74,6 @@ struct platform_data {
>>       u32 sensors_count; /* Total count of sensors from each group */
>>   };
>>
>> -/* Platform device representing all the ibmpowernv sensors */
>> -static struct platform_device *pdevice;
>> -
>>   static ssize_t show_sensor(struct device *dev, struct 
>> device_attribute *devattr,
>>                  char *buf)
>>   {
>> @@ -99,7 +96,7 @@ static ssize_t show_sensor(struct device *dev, 
>> struct device_attribute *devattr,
>>       return sprintf(buf, "%u\n", x);
>>   }
>>
>> -static int __init get_sensor_index_attr(const char *name, u32 *index,
>> +static int get_sensor_index_attr(const char *name, u32 *index,
>>                       char *attr)
>>   {
>>       char *hash_pos = strchr(name, '#');
>> @@ -136,7 +133,7 @@ static int __init get_sensor_index_attr(const 
>> char *name, u32 *index,
>>    * which need to be mapped as fan2_input, temp1_max respectively 
>> before
>>    * populating them inside hwmon device class.
>>    */
>> -static int __init create_hwmon_attr_name(struct device *dev, enum 
>> sensors type,
>> +static int create_hwmon_attr_name(struct device *dev, enum sensors 
>> type,
>>                        const char *node_name,
>>                        char *hwmon_attr_name)
>>   {
>> @@ -172,7 +169,7 @@ static int __init create_hwmon_attr_name(struct 
>> device *dev, enum sensors type,
>>       return 0;
>>   }
>>
>> -static int __init populate_attr_groups(struct platform_device *pdev)
>> +static int populate_attr_groups(struct platform_device *pdev)
>>   {
>>       struct platform_data *pdata = platform_get_drvdata(pdev);
>>       const struct attribute_group **pgroups = pdata->attr_groups;
>> @@ -180,11 +177,6 @@ static int __init populate_attr_groups(struct 
>> platform_device *pdev)
>>       enum sensors type;
>>
>>       opal = of_find_node_by_path("/ibm,opal/sensors");
>> -    if (!opal) {
>> -        dev_dbg(&pdev->dev, "Opal node 'sensors' not found\n");
>> -        return -ENODEV;
>> -    }
>> -
>>       for_each_child_of_node(opal, np) {
>>           if (np->name == NULL)
>>               continue;
>> @@ -221,7 +213,7 @@ static int __init populate_attr_groups(struct 
>> platform_device *pdev)
>>    * to the name required by the higher 'hwmon' driver like 
>> fan1_input, temp1_max
>>    * etc..
>>    */
>> -static int __init create_device_attrs(struct platform_device *pdev)
>> +static int create_device_attrs(struct platform_device *pdev)
>>   {
>>       struct platform_data *pdata = platform_get_drvdata(pdev);
>>       const struct attribute_group **pgroups = pdata->attr_groups;
>> @@ -280,7 +272,7 @@ exit_put_node:
>>       return err;
>>   }
>>
>> -static int __init ibmpowernv_probe(struct platform_device *pdev)
>> +static int ibmpowernv_probe(struct platform_device *pdev)
>>   {
>>       struct platform_data *pdata;
>>       struct device *hwmon_dev;
>> @@ -309,52 +301,31 @@ static int __init ibmpowernv_probe(struct 
>> platform_device *pdev)
>>       return PTR_ERR_OR_ZERO(hwmon_dev);
>>   }
>>
>> +static const struct platform_device_id opal_sensor_driver_ids[] = {
>> +    {
>> +        .name = "opal-sensor",
>> +    },
>> +    { }
>> +};
>> +MODULE_DEVICE_TABLE(platform, opal_sensor_driver_ids);
>> +
>>   static struct platform_driver ibmpowernv_driver = {
>> -    .driver = {
>> -        .owner = THIS_MODULE,
>> -        .name = DRVNAME,
>> +    .probe        = ibmpowernv_probe,
>> +    .id_table    = opal_sensor_driver_ids,
>> +    .driver        = {
>> +        .owner    = THIS_MODULE,
>> +        .name    = DRVNAME,
>>       },
>>   };
>>
>>   static int __init ibmpowernv_init(void)
>>   {
>> -    int err;
>> -
>> -    pdevice = platform_device_alloc(DRVNAME, 0);
>> -    if (!pdevice) {
>> -        pr_err("Device allocation failed\n");
>> -        err = -ENOMEM;
>> -        goto exit;
>> -    }
>> -
>> -    err = platform_device_add(pdevice);
>> -    if (err) {
>> -        pr_err("Device addition failed (%d)\n", err);
>> -        goto exit_device_put;
>> -    }
>> -
>> -    err = platform_driver_probe(&ibmpowernv_driver, ibmpowernv_probe);
>> -    if (err) {
>> -        if (err != -ENODEV)
>> -            pr_err("Platform driver probe failed (%d)\n", err);
>> -
>> -        goto exit_device_del;
>> -    }
>> -
>> -    return 0;
>> -
>> -exit_device_del:
>> -    platform_device_del(pdevice);
>> -exit_device_put:
>> -    platform_device_put(pdevice);
>> -exit:
>> -    return err;
>> +    return platform_driver_register(&ibmpowernv_driver);
>>   }
>>
>>   static void __exit ibmpowernv_exit(void)
>>   {
>>       platform_driver_unregister(&ibmpowernv_driver);
>> -    platform_device_unregister(pdevice);
>>   }
>>
>>   MODULE_AUTHOR("Neelesh Gupta <neelegup@linux.vnet.ibm.com>");
>>
>>
>

