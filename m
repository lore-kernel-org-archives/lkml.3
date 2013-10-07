Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756262Ab3JGRwi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 13:52:38 -0400
Received: from mms2.broadcom.com ([216.31.210.18]:2297 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756121Ab3JGRwd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 13:52:33 -0400
X-Server-Uuid: 4500596E-606A-40F9-852D-14843D8201B2
Message-ID: <5252F4D5.3060400@broadcom.com>
Date: Mon, 7 Oct 2013 10:52:21 -0700
From: "Wendy Ng" <wendy.ng@broadcom.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101
 Thunderbird/24.0
MIME-Version: 1.0
To: "Eduardo Valentin" <eduardo.valentin@ti.com>
cc: "Mark Rutland" <Mark.Rutland@arm.com>,
        "Rob Herring" <rob.herring@calxeda.com>,
        "Stephen Warren" <swarren@wwwdotorg.org>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        "Christian Daudt" <bcm@fixthebug.org>,
        "Markus Mayer" <mmayer@broadcom.com>
Subject: Re: [PATCH 1/3] thermal: bcm281xx: Add thermal driver
References: <1379958698-7554-1-git-send-email-wendy.ng@broadcom.com>
 <1379958698-7554-2-git-send-email-wendy.ng@broadcom.com>
 <52408648.7040301@ti.com> <5240C42A.3030705@broadcom.com>
 <5240D2CC.1070403@ti.com> <524F3E6D.1010308@broadcom.com>
 <5252CA97.6060601@ti.com> <5252DD6B.6020707@ti.com>
In-Reply-To: <5252DD6B.6020707@ti.com>
X-WSS-ID: 7E4C2B5F1R098245403-01-01
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 10/7/2013 9:12 AM, Eduardo Valentin wrote:
> On 07-10-2013 10:52, Eduardo Valentin wrote:
>> On 04-10-2013 18:17, Wendy Ng wrote:
>>> Hello Eduardo,
>>>
>> Hello Wendy,
>>
>>> I have rebased my work on the top of yours and tried out the new way of
>>> registering the thermal zone.    The new method is certainly making
>>> things easier for me to create a new thermal zone device driver.  But I
>>> have some questions and I hope to hear back from you before I upload my
>>> new patch set that is based on your changes.
>> Great that you gave it a shot. Thanks for that.
>>
>>> 1. I found that the hwmon sysfs interface is no longer created when I
>>> call thermal_zone_of_sensor_register() to register my thermal sensor.  I
>>> believe it is because you purposely hard-coded 'no_hwmon' to true.
>>> Would it be possible to let the users to control this option as part of
>>> the sensor register function?
>> Hmmm.. I also thought of allowing the thermal to hwmon interface
>> configurable. But the interface gets created in different path from the
>> sensor registration, which makes things a bit harder. The zones are
>> probed while parsing the DT file. While the sensors get linked,
>> thermal_zone_of_sensor_register(), typically when sensors are probed.
>>
>> Do you have a real use case for using the thermal to hwmon interface?
>> Durgadoss (original author) and Rui were considering deprecating and
>> finally removing it. If yes, it is time to rise your voice here.
>>
>>> 2. The of_thermal_get_temp() output parameter 'temp' is an unsigned
>>> value in order to conforms with the thermal framework 'get_temp'
>>> function prototype.  But the new sensor interface 'get_temp' callback
>>> function (defined in __thermal_zone struct) expects 'temp' to be
>>> signed.  So technically, a negative value can be returned from the
>>> underlying sensor function.  Should some checks be added to
>>> of_thermal_get_temp() to ensure that a negative value (i.e. a very large
>>> unsigned value) won't be passed back to the thermal framework?  Or
>>> should the 'get_temp' function prototype in __thermal_zone struct be
>>> changed with 'unsigned' temperature value and it will be the
>>> responsibility of the underlying function to do the check?
>>>
>> I could for sure, add a warning inside of_thermal_get_temp(). But in
>> general, I believe the thermal framework has to cover for signed
>> temperature values, even if typical usage is on positive temperature
>> range. Mainly for correct temperature representation.
>>
>>
>>> 3. Your documentation (thermal.txt) seems to suggest that the
>>> 'cooling-attachments' are one of the required properties for
>>> 'thermal-zones' node in the device tree binding files.  However, I don't
>> Hmm... That was not the intention.
>>
>>> have any cooling device ready in my current patch series yet and
>>> therefore I tried to leave out the 'cooling-attachments' node from the
>>> 'thermal-zones' node.  It seems to be working just find and I can
>>> register the sensor and read out the temperature once the target
>>> platform has been booted up.  Is this your expectation that people can
>>> leave the 'cooling-attachments' node out?    I want to make sure I can
>>> still submit a new patch set for this series with just the functionality
>>> of reading out the temperature from the thermal sensor.
>> So, let me try to clarify a couple of things. First thing is that the
>> cooling-attachments has been renamed to cooling-maps, just a new naming
>> convention.  Also, there are thermal zones that do not have
>> cooling-maps, they just describe thermal shutdown by software, thermal
>> zones with only CRITICAL trip points, for instance. For this reason,
>> thermal zones must be probed properly without cooling-maps. I need to
>> double check the documentation in this case, I believe.
> Just to clarify a bit, this does not mean we should allow having thermal
> zones only for monitoring. If you are generating a thermal zone, it
> means you want to cover thermal limits. The example I gave was a thermal
> zone that does not have cooling-maps, but it does have a thermal
> constraint, a trip point which is CRITICAL, meaning, the silicon state
> is not reliable anymore.
Hi Eduardo,

Thanks for your clarification.    Yes, there are thermal limits that I 
need to specify through the trip points.  The issue I am facing is that 
I don't have the cooling device that needs to be associated with the 
trip point in this patch series yet.  I was hoping to get the thermal 
sensor driver code into the mainline first.  The addition for the 
cooling device and the "cooling-maps" node will be added in another 
patch series.

Since this patch series is now gated by your work, I am wondering if you 
are targeting to get your patch series 
(http://lkml.org/lkml/2013/9/15/122) into 3.13?  I would like to get an 
idea of the timeline such that I can plan out my work as well.

Thanks!
>>> Thanks,
>>> -Wendy
>>>
>>> On 9/23/2013 4:46 PM, Eduardo Valentin wrote:
>>>> On 23-09-2013 18:43, Wendy Ng wrote:
>>>>> On 9/23/2013 11:19 AM, Eduardo Valentin wrote:
>>>>>> On 23-09-2013 13:51, Wendy Ng wrote:
>>>>>>> This adds the support for reading out temperature from Broadcom
>>>>>>> bcm281xx
>>>>>>> SoCs.
>>>>>>>
>>>>>>> Signed-off-by: Wendy Ng <wendy.ng@broadcom.com>
>>>>>>> Reviewed-by: Markus Mayer <mmayer@broadcom.com>
>>>>>>> Reviewed-by: Christian Daudt <csd@broadcom.com>
>>>>>>> ---
>>>>>>>     .../bindings/thermal/bcm-kona-thermal.txt          |   18 +++
>>>>>>>     drivers/thermal/Kconfig                            |   10 ++
>>>>>>>     drivers/thermal/Makefile                           |    1 +
>>>>>>>     drivers/thermal/bcm_thermal.c                      |  170
>>>>>>> ++++++++++++++++++++
>>>>>>>     4 files changed, 199 insertions(+)
>>>>>>>     create mode 100644
>>>>>>> Documentation/devicetree/bindings/thermal/bcm-kona-thermal.txt
>>>>>>>     create mode 100644 drivers/thermal/bcm_thermal.c
>>>>>>>
>>>>>>> diff --git
>>>>>>> a/Documentation/devicetree/bindings/thermal/bcm-kona-thermal.txt
>>>>>>> b/Documentation/devicetree/bindings/thermal/bcm-kona-thermal.txt
>>>>>>> new file mode 100644
>>>>>>> index 0000000..acca99e
>>>>>>> --- /dev/null
>>>>>>> +++ b/Documentation/devicetree/bindings/thermal/bcm-kona-thermal.txt
>>>>>>> @@ -0,0 +1,18 @@
>>>>>>> +* Broadcom Kona Thermal Management Unit
>>>>>>> +
>>>>>>> +This version is for the BCM281xx family of SoCs.
>>>>>>> +
>>>>>>> +Required properties:
>>>>>>> +- compatible : "brcm,bcm11351-thermal", "brcm,kona-thermal"
>>>>>>> +- reg : Address range of the thermal register
>>>>>>> +- thermal-name: this entry must be specified and it will be passed
>>>>>>> into
>>>>>>> +thermal_zone_device_register().  This name will also be reported
>>>>>>> under Hwmon
>>>>>>> +sysfs 'name' attribute.
>>>>>>> +
>>>>>>> +Example:
>>>>>>> +    thermal@34008000 {
>>>>>>> +        compatible = "brcm,bcm11351-thermal", "brcm,kona-thermal";
>>>>>>> +        reg = <0x34008000 0x0024>;
>>>>>>> +        thermal-name = "bcm_kona_therm";
>>>>>>> +        status = "disabled";
>>>>>>> +    };
>>>>>>> diff --git a/drivers/thermal/Kconfig b/drivers/thermal/Kconfig
>>>>>>> index dbfc390..7f823f0 100644
>>>>>>> --- a/drivers/thermal/Kconfig
>>>>>>> +++ b/drivers/thermal/Kconfig
>>>>>>> @@ -134,6 +134,16 @@ config KIRKWOOD_THERMAL
>>>>>>>           Support for the Kirkwood thermal sensor driver into the Linux
>>>>>>> thermal
>>>>>>>           framework. Only kirkwood 88F6282 and 88F6283 have this
>>>>>>> sensor.
>>>>>>>     +config BCM_THERMAL
>>>>>>> +    tristate "Temperature sensor on Broadcom BCM281xx family of SoCs"
>>>>>>> +    depends on ARCH_BCM
>>>>>>> +    default y
>>>>>>> +    help
>>>>>>> +      If you say yes here you get support for TMU (Thermal Management
>>>>>>> +      Unit) on Broadcom BCM281xx family of SoCs. This provides
>>>>>>> thermal
>>>>>>> +      monitoring of CPU clusters, graphics, and SoC glue, but does
>>>>>>> not
>>>>>>> +      include monitoring of charger temperature.
>>>>>>> +
>>>>>>>     config DOVE_THERMAL
>>>>>>>         tristate "Temperature sensor on Marvell Dove SoCs"
>>>>>>>         depends on ARCH_DOVE
>>>>>>> diff --git a/drivers/thermal/Makefile b/drivers/thermal/Makefile
>>>>>>> index 584b363..3ea8c1c 100644
>>>>>>> --- a/drivers/thermal/Makefile
>>>>>>> +++ b/drivers/thermal/Makefile
>>>>>>> @@ -21,6 +21,7 @@ obj-$(CONFIG_SPEAR_THERMAL)    += spear_thermal.o
>>>>>>>     obj-$(CONFIG_RCAR_THERMAL)    += rcar_thermal.o
>>>>>>>     obj-$(CONFIG_KIRKWOOD_THERMAL)  += kirkwood_thermal.o
>>>>>>>     obj-y                += samsung/
>>>>>>> +obj-$(CONFIG_BCM_THERMAL)       += bcm_thermal.o
>>>>>>>     obj-$(CONFIG_DOVE_THERMAL)      += dove_thermal.o
>>>>>>>     obj-$(CONFIG_DB8500_THERMAL)    += db8500_thermal.o
>>>>>>>     obj-$(CONFIG_ARMADA_THERMAL)    += armada_thermal.o
>>>>>>> diff --git a/drivers/thermal/bcm_thermal.c
>>>>>>> b/drivers/thermal/bcm_thermal.c
>>>>>>> new file mode 100644
>>>>>>> index 0000000..131d3c4
>>>>>>> --- /dev/null
>>>>>>> +++ b/drivers/thermal/bcm_thermal.c
>>>>>>> @@ -0,0 +1,170 @@
>>>>>>> +/*
>>>>>>> + * Copyright 2013 Broadcom Corporation.
>>>>>>> + *
>>>>>>> + * This program is free software; you can redistribute it and/or
>>>>>>> modify
>>>>>>> + * it under the terms of the GNU General Public License, version 2,
>>>>>>> + * as published by the Free Software Foundation (the "GPL").
>>>>>>> + *
>>>>>>> + * This program is distributed in the hope that it will be useful,
>>>>>>> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
>>>>>>> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>>>>>>> + * GNU General Public License for more details.
>>>>>>> + *
>>>>>>> + * A copy of the GPL is available at
>>>>>>> http://www.broadcom.com/licenses/GPLv2.php,
>>>>>>> + * or by writing to the Free Software Foundation, Inc.,
>>>>>>> + * 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.
>>>>>>> + */
>>>>>>> +
>>>>>>> +/**
>>>>>>> +*  Broadcom Thermal Management Unit - bcm_tmu
>>>>>>> +*/
>>>>>>> +#include <linux/module.h>
>>>>>>> +#include <linux/err.h>
>>>>>>> +#include <linux/kernel.h>
>>>>>>> +#include <linux/platform_device.h>
>>>>>>> +#include <linux/io.h>
>>>>>>> +#include <linux/thermal.h>
>>>>>>> +#include <linux/of.h>
>>>>>>> +
>>>>>>> +/* From TMON Register Database */
>>>>>>> +#define TMON_TEMP_VAL_OFFSET            0x0000001c
>>>>>>> +#define TMON_TEMP_VAL_TEMP_VAL_SHIFT        0
>>>>>>> +#define TMON_TEMP_VAL_TEMP_VAL_MASK        0x000003ff
>>>>>>> +
>>>>>>> +/* Broadcom Thermal Zone Device Structure */
>>>>>>> +struct bcm_thermal_zone_priv {
>>>>>>> +    char name[THERMAL_NAME_LENGTH];
>>>>>>> +    void __iomem *base;
>>>>>>> +};
>>>>>>> +
>>>>>>> +/* Temperature conversion function for TMON block */
>>>>>>> +static long raw_to_mcelsius(u32 raw)
>>>>>>> +{
>>>>>>> +    /*
>>>>>>> +     * According to Broadcom internal Analog Module Specification
>>>>>>> +     * the formula for converting TMON block output to temperature in
>>>>>>> +     * degree Celsius is:
>>>>>>> +     *    T = 428 - (0.561 * raw)
>>>>>>> +     * Note: the valid operating range for the TMON block is -40C to
>>>>>>> 125C
>>>>>>> +     */
>>>>>>> +    return 428000 - (561 * (long)raw);
>>>>>>> +}
>>>>>>> +
>>>>>>> +/* Get temperature callback function for thermal zone */
>>>>>>> +static int bcm_get_temp(struct thermal_zone_device *thermal,
>>>>>>> +            unsigned long *temp)
>>>>>>> +{
>>>>>>> +    u32 raw;
>>>>>>> +    long mcelsius;
>>>>>>> +    struct bcm_thermal_zone_priv *priv = thermal->devdata;
>>>>>>> +
>>>>>>> +    if (!priv) {
>>>>>>> +        pr_err("%s: thermal zone number %d devdata not
>>>>>>> initialized.\n",
>>>>>>> +            __func__, thermal->id);
>>>>>>> +        return -EINVAL;
>>>>>>> +    }
>>>>>>> +
>>>>>>> +    raw = (readl(priv->base + TMON_TEMP_VAL_OFFSET)
>>>>>>> +        & TMON_TEMP_VAL_TEMP_VAL_MASK) >>
>>>>>>> TMON_TEMP_VAL_TEMP_VAL_SHIFT;
>>>>>>> +
>>>>>>> +    pr_debug("%s: thermal zone number %d raw temp 0x%x\n", __func__,
>>>>>>> +        thermal->id, raw);
>>>>>>> +
>>>>>>> +    mcelsius = raw_to_mcelsius(raw);
>>>>>>> +
>>>>>>> +    /*
>>>>>>> +     * Since 'mcelsius' might be negative, we need to limit it to
>>>>>>> smallest
>>>>>>> +     * unsigned value before returning it to thermal framework.
>>>>>>> +     */
>>>>>>> +    if (mcelsius < 0)
>>>>>>> +        *temp = 0;
>>>>>>> +    else
>>>>>>> +        *temp = mcelsius;
>>>>>>> +
>>>>>>> +    pr_debug("%s: thermal zone number %d final temp %d\n", __func__,
>>>>>>> +        thermal->id, (int) *temp);
>>>>>>> +
>>>>>>> +    return 0;
>>>>>>> +}
>>>>>>> +
>>>>>>> +/* Operation callback functions for thermal zone */
>>>>>>> +static struct thermal_zone_device_ops bcm_dev_ops = {
>>>>>>> +    .get_temp = bcm_get_temp,
>>>>>>> +};
>>>>>>> +
>>>>>>> +static const struct of_device_id bcm_tmu_match_table[] = {
>>>>>>> +    { .compatible = "brcm,kona-thermal" },
>>>>>>> +    {},
>>>>>>> +};
>>>>>>> +MODULE_DEVICE_TABLE(of, bcm_tmu_match_table);
>>>>>>> +
>>>>>>> +static int bcm_tmu_probe(struct platform_device *pdev)
>>>>>>> +{
>>>>>>> +    struct thermal_zone_device *thermal = NULL;
>>>>>>> +    struct bcm_thermal_zone_priv *priv;
>>>>>>> +    struct resource *res;
>>>>>>> +    const char *str;
>>>>>>> +
>>>>>>> +    priv = devm_kzalloc(&pdev->dev, sizeof(*priv), GFP_KERNEL);
>>>>>>> +    if (!priv) {
>>>>>>> +        dev_err(&pdev->dev, "Failed to malloc priv.\n");
>>>>>>> +        return -ENOMEM;
>>>>>>> +    }
>>>>>>> +
>>>>>>> +    /* Obtain the tmu name from device tree file */
>>>>>>> +    if (of_property_read_string(pdev->dev.of_node, "thermal-name",
>>>>>> Hello Wendy,
>>>>>>
>>>>>> I would prefer we wait until the work for thermal data [1] gets
>>>>>> accepted
>>>>>> before accepting this driver, specially because you are adding device
>>>>>> specific DT entry to help in your registration with the thermal
>>>>>> framework. With the mentioned work you wont need it at all.
>>>>>>
>>>>>> All best,
>>>>>>
>>>>>> [1] - http://lkml.org/lkml/2013/9/15/122
>>>>> Hello Eduardo,
>>>>>
>>>>> Since your changes are quite extensive, would you recommend me to get
>>>>> your 16 patches into my local workspace and try to integrate the code
>>>>> from my patches on the top of your patches at this time?  Or should I
>>>>> wait until your patches get accepted.
>>>> Hello again Wendy,
>>>>
>>>> The only part I am concerned is the device tree entry you are creating
>>>> for your device/driver. That could be obsolete in near future with the
>>>> work I am doing currently.
>>>>
>>>> The work is, as you mentioned, quite extensive, but should make things
>>>> easier for device driver writer. If you want, of course, it would be
>>>> great if you could rebase your work on top of mine and try it out on
>>>> your side and let me know the outcome.
>>>>
>>>> Comments on the proposed binding and documentation is also welcome. Let
>>>> me know if there is something that it is not clear.
>>>>
>>>>> Thanks,
>>>>> -Wendy
>>>>>>> +            &str) == 0) {
>>>>>>> +        strlcpy(priv->name, str, sizeof(priv->name));
>>>>>>> +    } else {
>>>>>>> +        dev_err(&pdev->dev, "Failed to get thermal-name from DT.\n");
>>>>>>> +        return -EINVAL;
>>>>>>> +    }
>>>>>>> +
>>>>>>> +    res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>>>>>>> +    priv->base = devm_ioremap_resource(&pdev->dev, res);
>>>>>>> +    if (IS_ERR(priv->base))
>>>>>>> +        return PTR_ERR(priv->base);
>>>>>>> +
>>>>>>> +    thermal = thermal_zone_device_register(priv->name, 0, 0, priv,
>>>>>>> +                        &bcm_dev_ops, NULL, 0, 0);
>>>>>>> +    if (IS_ERR(thermal)) {
>>>>>>> +        dev_err(&pdev->dev,
>>>>>>> +            "Failed to register Broadcom thermal zone device.\n");
>>>>>>> +        return PTR_ERR(thermal);
>>>>>>> +    }
>>>>>>> +
>>>>>>> +    platform_set_drvdata(pdev, thermal);
>>>>>>> +
>>>>>>> +    dev_info(&pdev->dev, "Broadcom Thermal Monitor Initialized.\n");
>>>>>>> +
>>>>>>> +    return 0;
>>>>>>> +}
>>>>>>> +
>>>>>>> +static int bcm_tmu_remove(struct platform_device *pdev)
>>>>>>> +{
>>>>>>> +    struct thermal_zone_device *broadcom_thermal =
>>>>>>> +        platform_get_drvdata(pdev);
>>>>>>> +
>>>>>>> +    thermal_zone_device_unregister(broadcom_thermal);
>>>>>>> +
>>>>>>> +    dev_info(&pdev->dev, "Broadcom Thermal Monitor
>>>>>>> Uninitialized.\n");
>>>>>>> +
>>>>>>> +    return 0;
>>>>>>> +}
>>>>>>> +
>>>>>>> +static struct platform_driver bcm_tmu_driver = {
>>>>>>> +    .driver = {
>>>>>>> +        .name = "bcm-thermal",
>>>>>>> +        .owner = THIS_MODULE,
>>>>>>> +        .of_match_table = bcm_tmu_match_table,
>>>>>>> +    },
>>>>>>> +    .probe = bcm_tmu_probe,
>>>>>>> +    .remove = bcm_tmu_remove,
>>>>>>> +};
>>>>>>> +
>>>>>>> +module_platform_driver(bcm_tmu_driver);
>>>>>>> +
>>>>>>> +MODULE_DESCRIPTION("Broadcom Thermal Driver");
>>>>>>> +MODULE_AUTHOR("Broadcom");
>>>>>>> +MODULE_LICENSE("GPL v2");
>>>>>>> +MODULE_ALIAS("platform:bcm-thermal");
>>>>>>>
>>
>

-- 
Best regards,
-Wendy


