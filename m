Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754821Ab3BAGVE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 01:21:04 -0500
Received: from mail-la0-f44.google.com ([209.85.215.44]:33268 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751243Ab3BAGVB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 01:21:01 -0500
MIME-Version: 1.0
In-Reply-To: <20130130183730.GA26528@roeck-us.net>
References: <1359541288-6657-1-git-send-email-hongbo.zhang@linaro.org>
	<1359541288-6657-3-git-send-email-hongbo.zhang@linaro.org>
	<20130130183730.GA26528@roeck-us.net>
Date: Fri, 1 Feb 2013 14:20:58 +0800
Message-ID: <CAJLyvQxGhM22zLw_acvwH4yweP=6+kd-tNcX9y0JVBuAWxJEnw@mail.gmail.com>
Subject: Re: [PATCH 2/2] hwmon: add ST-Ericsson ABX500 hwmon driver
From: Hongbo Zhang <hongbo.zhang@linaro.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: khali@linux-fr.org, lm-sensors@lm-sensors.org, sameo@linux.intel.com,
        linux-kernel@vger.kernel.org, STEricsson_nomadik_linux@list.st.com,
        linaro-dev@lists.linaro.org, patches@linaro.org,
        linus.walleij@linaro.org, lee.jones@linaro.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Guenter,
Thank you so much for all the comments, will re-send a v2 iteration soon.

On 31 January 2013 02:37, Guenter Roeck <linux@roeck-us.net> wrote:
> On Wed, Jan 30, 2013 at 06:21:28PM +0800, Hongbo Zhang wrote:
>> Each of ST-Ericsson X500 chip set series consists of both ABX500 and DBX500
>> chips. This is ABX500 hwmon driver, where the abx500.c is a common layer for
>> all ABX500s, and the ab8500.c is specific for AB8500 chip. Under this designed
>> structure, other chip specific files can be added simply using the same common
>> layer abx500.c.
>>
>> Signed-off-by: Hongbo Zhang <hongbo.zhang@linaro.org>
>> ---
>>  drivers/hwmon/Kconfig  |  13 +
>>  drivers/hwmon/Makefile |   1 +
>>  drivers/hwmon/ab8500.c | 160 ++++++++++++
>>  drivers/hwmon/abx500.c | 681 +++++++++++++++++++++++++++++++++++++++++++++++++
>>  drivers/hwmon/abx500.h |  88 +++++++
>>  5 files changed, 943 insertions(+)
>>  create mode 100644 drivers/hwmon/ab8500.c
>>  create mode 100644 drivers/hwmon/abx500.c
>>  create mode 100644 drivers/hwmon/abx500.h
>>
> Hi,
>
> we'll also need Documentation/hwmon/ab8500 to describe the driver, and possibly
> Documentation/hwmon/ab85xx to describe the common elements.
>
Sure, will add them.

>> diff --git a/drivers/hwmon/Kconfig b/drivers/hwmon/Kconfig
>> index 32f238f..0a6fd21 100644
>> --- a/drivers/hwmon/Kconfig
>> +++ b/drivers/hwmon/Kconfig
>> @@ -39,6 +39,19 @@ config HWMON_DEBUG_CHIP
>>
>>  comment "Native drivers"
>>
>> +config SENSORS_AB8500
>> +     tristate "AB8500 thermal monitoring"
>> +     depends on AB8500_GPADC
>> +     default n
>> +     help
>> +       If you say yes here you get support for the thermal sensor part
>> +       of the AB8500 chip. The driver includes thermal management for
>> +       AB8500 die and two GPADC channels. The GPADC channel are preferably
>> +       used to access sensors outside the AB8500 chip.
>> +
>> +       This driver can also be built as a module.  If so, the module
>> +       will be called abx500-temp.
>> +
>>  config SENSORS_ABITUGURU
>>       tristate "Abit uGuru (rev 1 & 2)"
>>       depends on X86 && DMI
>> diff --git a/drivers/hwmon/Makefile b/drivers/hwmon/Makefile
>> index 5da2874..06dfe85 100644
>> --- a/drivers/hwmon/Makefile
>> +++ b/drivers/hwmon/Makefile
>> @@ -19,6 +19,7 @@ obj-$(CONFIG_SENSORS_W83795)        += w83795.o
>>  obj-$(CONFIG_SENSORS_W83781D)        += w83781d.o
>>  obj-$(CONFIG_SENSORS_W83791D)        += w83791d.o
>>
>> +obj-$(CONFIG_SENSORS_AB8500) += abx500.o ab8500.o
>>  obj-$(CONFIG_SENSORS_ABITUGURU)      += abituguru.o
>>  obj-$(CONFIG_SENSORS_ABITUGURU3)+= abituguru3.o
>>  obj-$(CONFIG_SENSORS_AD7314) += ad7314.o
>> diff --git a/drivers/hwmon/ab8500.c b/drivers/hwmon/ab8500.c
>> new file mode 100644
>> index 0000000..426872c
>> --- /dev/null
>> +++ b/drivers/hwmon/ab8500.c
>> @@ -0,0 +1,160 @@
>> +/*
>> + * Copyright (C) ST-Ericsson SA 2010
>> + * Author: Martin Persson <martin.persson@stericsson.com> for
>> + * ST-Ericsson.
>> + * License Terms: GNU General Public License v2
>> + *
>> + * If/when the AB8500 thermal warning temperature is reached (threshold cannot
>> + * be changed by SW), an interrupt is set and the driver notifies user space
>> + * via a sysfs event. If a shut down is not triggered by user space within a
>> + * certain time frame, pm_power off is called.
>> + *
>> + * If/when AB8500 thermal shutdown temperature is reached a hardware shutdown
>> + * of the AB8500 will occur.
>> + */
>> +
>> +#include <linux/err.h>
>> +#include <linux/hwmon.h>
>> +#include <linux/hwmon-sysfs.h>
>> +#include <linux/mfd/abx500/ab8500-bm.h>
>> +#include <linux/mfd/abx500/ab8500-gpadc.h>
>> +#include <linux/platform_device.h>
>> +#include <linux/slab.h>
>> +#include <linux/sysfs.h>
>> +#include "abx500.h"
>> +
>> +#define DEFAULT_POWER_OFF_DELAY 10000
>> +
>> +/* The driver monitors GPADC - ADC_AUX1, ADC_AUX2, BTEMP_BALL and BAT_CTRL */
>> +#define NUM_MONITORED_SENSORS 4
>> +
>> +static int ab8500_read_sensor(struct abx500_temp *data, u8 sensor)
>> +{
>> +     int val;
>> +     /*
>> +      * Special treatment for the BAT_CTRL node, since this temperature
>> +      * measurement is more complex than just an ADC readout
>> +      */
>> +     if (sensor == BAT_CTRL)
>> +             val = ab8500_btemp_get_batctrl_temp(data->ab8500_btemp);
>> +     else
>> +             val = ab8500_gpadc_convert(data->ab8500_gpadc, sensor);
>> +
>> +     return val;
>> +}
>> +
>> +static void ab8500_thermal_power_off(struct work_struct *work)
>> +{
>> +     struct abx500_temp *data = container_of(work, struct abx500_temp,
>> +                                             power_off_work.work);
>> +
>> +     dev_warn(&data->pdev->dev,
>> +             "Power off due to AB8500 thermal warning.\n");
>> +     pm_power_off();
>> +}
>> +
>> +static ssize_t ab8500_show_name(struct device *dev,
>> +                             struct device_attribute *devattr,
>> +                             char *buf)
>> +{
>> +     return sprintf(buf, "ab8500\n");
>> +}
>> +
>> +static ssize_t ab8500_show_label(struct device *dev,
>> +                             struct device_attribute *devattr,
>> +                             char *buf)
>> +{
>> +     char *name;
>> +     struct sensor_device_attribute *attr = to_sensor_dev_attr(devattr);
>> +     int index = attr->index;
>> +
>> +     switch (index) {
>> +     case 1:
>> +             name = "ext_rtc_xtal";
>> +             break;
>> +     case 2:
>> +             name = "ext_db8500";
>> +             break;
>> +     case 3:
>> +             name = "bat_temp";
>> +             break;
>> +     case 4:
>> +             name = "bat_ctrl";
>> +             break;
>> +     case 5:
>> +             name = "ab8500";
>> +             break;
>> +     default:
>> +             return -EINVAL;
>> +     }
>> +     return sprintf(buf, "%s\n", name);
>> +}
>> +
>> +static int ab8500_is_visible(struct attribute *attr, int n)
>> +{
>> +     if (!strcmp(attr->name, "temp5_input") ||
>> +         !strcmp(attr->name, "temp5_min") ||
>> +         !strcmp(attr->name, "temp5_max") ||
>> +         !strcmp(attr->name, "temp5_max_hyst") ||
>> +         !strcmp(attr->name, "temp5_min_alarm") ||
>> +         !strcmp(attr->name, "temp5_max_alarm") ||
>> +         !strcmp(attr->name, "temp5_max_hyst_alarm"))
>> +             return 0;
>> +
> If all temp5 attributes are not supported for this chip, a single strncmp
> for "temp5" might do. But you still show temp5_name, which is odd.
>
> Really, for thermal management, you should look into using
> the thermal subsystem.
>
temp5_crit_alarm is also showed, and temp5_crit can be added later.
I know thermal management, for this temp5 hardware, only an interrupt
is raised when threshold reached, we cannot even read the temperature
if it, this is really a rough hardware design. If we want to use
thermal management, a read_temp() interface is needed at least, we
cannot offer it, so it is not suitable to use thermal management
framework.

>> +     return attr->mode;
>> +}
>> +
>> +static int ab8500_temp_irq_handler(int irq, struct abx500_temp *data)
>> +{
>> +     unsigned long delay_in_jiffies;
>> +
>> +     mutex_lock(&data->lock);
>> +     data->crit_alarm[4] = 1;
>> +     mutex_unlock(&data->lock);
>> +
> This locking is unnecessary.
>
hmm...currently nobody else operates this data.

>> +     sysfs_notify(&data->pdev->dev.kobj, NULL, "temp5_crit_alarm");
>> +     dev_info(&data->pdev->dev, "AB8500 warning, power off in %lu s\n",
>> +             data->power_off_delay);
>> +     delay_in_jiffies = msecs_to_jiffies(data->power_off_delay);
>> +     schedule_delayed_work(&data->power_off_work, delay_in_jiffies);
>> +     return 0;
>> +}
>> +
>> +int abx500_hwmon_init(struct abx500_temp *data)
>
> With that function naming, you'll have to make sure for later drivers that only
> _one_ driver can be configured at any given time. Otherwise build options such
> as "allconfig" or "allmodconfig" will fail. Just something to keep in mind.
>
Yes, only one driver can be configured.
(physically ab8500 is part of u8500 SOC, when u8500 is configured,
only ab8500 must be configured)

>> +{
>> +     data->ab8500_gpadc = ab8500_gpadc_get("ab8500-gpadc.0");
>
>         Wonder if/how that is going to work in the real world. Can you always
>         guarantee that the gpadc driver name and instance is "ab8500-gpadc.0" ?
>
This really seems not so good. but the gpadc is designed like this,
have to do so just as all the other gpadc users.

>> +     if (IS_ERR(data->ab8500_gpadc))
>> +             return PTR_ERR(data->ab8500_gpadc);
>> +
>> +     data->ab8500_btemp = ab8500_btemp_get();
>> +     if (IS_ERR(data->ab8500_btemp))
>> +             return PTR_ERR(data->ab8500_btemp);
>> +
>> +     INIT_DELAYED_WORK(&data->power_off_work, ab8500_thermal_power_off);
>> +
>> +     /*
>> +      * Reference hardware:
>> +      * GPADC - ADC_AUX1, connected to NTC R2148
>> +      * GPADC - ADC_AUX2, connected to NTC R2150
>> +      * Hence temp#_min/max/max_hyst refer to millivolts, not millidegrees
>> +      * This is not the case for BAT_CTRL where millidegrees is used
>> +      *
>
> So you report milli-volt in tempX attributes ? That is unacceptable.
> The ABI expects milli-degrees C. If you can not report a temperature,
> don't do it.
>
Will make these voltage items invisible.

>> +      * Reading AB8500 temperature is not supportted. BUT an AB8500 IRQ
>
>                 /tt/t/
>                 /BUT/But/
>
Good.

>> +      * will be launched if die crit temp limit is reached.
>> +      */
>> +     data->gpadc_addr[0] = ADC_AUX1;
>> +     data->gpadc_addr[1] = ADC_AUX2;
>> +     data->gpadc_addr[2] = BTEMP_BALL;
>> +     data->gpadc_addr[3] = BAT_CTRL;
>> +     data->gpadc_addr[4] = DIE_TEMP;
>> +     data->power_off_delay = DEFAULT_POWER_OFF_DELAY;
>> +     data->monitored_sensors = NUM_MONITORED_SENSORS;
>> +
>> +     data->ops.read_sensor = ab8500_read_sensor;
>> +     data->ops.irq_handler = ab8500_temp_irq_handler;
>> +     data->ops.show_name  = ab8500_show_name;
>> +     data->ops.show_label = ab8500_show_label;
>> +     data->ops.is_visible = ab8500_is_visible;
>> +
>> +     return 0;
>> +}
>> diff --git a/drivers/hwmon/abx500.c b/drivers/hwmon/abx500.c
>> new file mode 100644
>> index 0000000..94cffd4
>> --- /dev/null
>> +++ b/drivers/hwmon/abx500.c
>> @@ -0,0 +1,681 @@
>> +/*
>> + * Copyright (C) ST-Ericsson SA 2010
>> + * Author: Martin Persson <martin.persson@stericsson.com> for
>> + * ST-Ericsson.
>> + * License Terms: GNU General Public License v2
>> + *
>> + * ABX500 does not provide auto ADC, so to monitor the required temperatures,
>> + * a periodic work is used. It is more important to not wake up the CPU than
>> + * to perform this job, hence the use of a deferred delay.
>> + *
>> + * A deferred delay for thermal monitor is considered safe because:
>> + * If the chip gets too hot during a sleep state it's most likely due to
>> + * external factors, such as the surrounding temperature. I.e. no SW decisions
>> + * will make any difference.
>> + *
>> + * If/when the ABX500 thermal warning temperature is reached (threshold cannot
>> + * be changed by SW), an interrupt is set and the driver notifies user space
>> + * via a sysfs event.
>> + *
>
> The above comments suggest that the thermal subsystem might be a more
> appropriate place for this driver. Please check and let me know.
>
The last paragraph is talking about temp5 too.
As said it is not suitable to use thermal management I think. What's
more, this is a common layer, may serve other following SOC series in
future.

>> + * If/when ABX500 thermal shutdown temperature is reached a hardware shutdown
>> + * of the ABX500 will occur.
>> + */
>> +
>> +#include <linux/err.h>
>> +#include <linux/hwmon.h>
>> +#include <linux/hwmon-sysfs.h>
>> +#include <linux/interrupt.h>
>> +#include <linux/jiffies.h>
>> +#include <linux/module.h>
>> +#include <linux/mutex.h>
>> +#include <linux/of.h>
>> +#include <linux/platform_device.h>
>> +#include <linux/pm.h>
>> +#include <linux/slab.h>
>> +#include <linux/sysfs.h>
>> +#include <linux/workqueue.h>
>> +#include "abx500.h"
>> +
>> +#define DEFAULT_MONITOR_DELAY 1000
>> +
>> +/*
>> + * Thresholds are considered inactive if set to 0. To avoid confusion for user
>> + * space applications, the temp monitor delay is set with the default value if
>> + * all thresholds are 0.
>> + */
>> +static bool find_active_thresholds(struct abx500_temp *data)
>> +{
>> +     int i;
>> +     for (i = 0; i < data->monitored_sensors; i++)
>> +             if (data->max[i] != 0 || data->max_hyst[i] != 0
>> +                 || data->min[i] != 0)
>> +                     return true;
>> +
>> +     dev_dbg(&data->pdev->dev, "No active thresholds.\n");
>> +     cancel_delayed_work_sync(&data->work);
>> +     data->work_active = false;
>> +     data->gpadc_monitor_delay = DEFAULT_MONITOR_DELAY;
>> +     return false;
>
> Conceptually, this is an interesting function. Not only does it look for active
> thresholds, it actually cancels active work if there are none.
>
> Yet, on the other side it doesn't _activate_ any work if there are active
> thresholds.
>
> To be more consistent, it seems to me it would make sense if this
> function would also call schedule_work if there is work to be done.
> After all, the callers will do it anyway.
>
Will rework this function, and rename it too.

>> +}
>> +
>> +static inline void schedule_monitor(struct abx500_temp *data)
>> +{
>> +     unsigned long delay_in_jiffies;
>> +     delay_in_jiffies = msecs_to_jiffies(data->gpadc_monitor_delay);
>> +     data->work_active = true;
>> +     schedule_delayed_work(&data->work, delay_in_jiffies);
>> +}
>> +
>> +static inline void gpadc_monitor_exit(struct abx500_temp *data)
>> +{
>> +     cancel_delayed_work_sync(&data->work);
>> +     data->work_active = false;
>
> That assignment seems to be quite unnecessary, as the data structure is
> about to be freed anyway.
>
Yes, and this helper function isn't so necessary.

>> +}
>> +
>> +static void gpadc_monitor(struct work_struct *work)
>> +{
>> +     unsigned long delay_in_jiffies;
>> +     int val, i, ret;
>> +     char alarm_node[30];
>> +     bool updated_min_alarm = false;
>> +     bool updated_max_alarm = false;
>> +     bool updated_max_hyst_alarm = false;
>> +     struct abx500_temp *data = container_of(work, struct abx500_temp,
>> +                                             work.work);
>> +
>> +     for (i = 0; i < data->monitored_sensors; i++) {
>> +             /* Thresholds are considered inactive if set to 0 */
>> +             if (data->max[i] == 0 && data->max_hyst[i] == 0
>> +                 && data->min[i] == 0)
>> +                     continue;
>> +
>> +             val = data->ops.read_sensor(data, data->gpadc_addr[i]);
>> +             if (val < 0) {
>> +                     dev_err(&data->pdev->dev, "GPADC read failed\n");
>> +                     continue;
>> +             }
>> +
>> +             mutex_lock(&data->lock);
>> +             if (data->min[i] != 0) {
>> +                     if (val < data->min[i]) {
>> +                             if (data->min_alarm[i] == 0) {
>> +                                     data->min_alarm[i] = 1;
>> +                                     updated_min_alarm = true;
>> +                             }
>> +                     } else {
>> +                             if (data->min_alarm[i] == 1) {
>> +                                     data->min_alarm[i] = 0;
>> +                                     updated_min_alarm = true;
>> +                             }
>> +                     }
>> +
>> +             }
>> +             if (data->max[i] != 0) {
>> +                     if (val > data->max[i]) {
>> +                             if (data->max_alarm[i] == 0) {
>> +                                     data->max_alarm[i] = 1;
>> +                                     updated_max_alarm = true;
>> +                             }
>> +                     } else {
>> +                             if (data->max_alarm[i] == 1) {
>> +                                     data->max_alarm[i] = 0;
>> +                                     updated_max_alarm = true;
>> +                             }
>> +                     }
>> +
>> +             }
>> +             if (data->max_hyst[i] != 0) {
>> +                     if (val > data->max_hyst[i]) {
>> +                             if (data->max_hyst_alarm[i] == 0) {
>> +                                     data->max_hyst_alarm[i] = 1;
>> +                                     updated_max_hyst_alarm = true;
>> +                             }
>> +                     } else {
>> +                             if (data->max_hyst_alarm[i] == 1) {
>> +                                     data->max_hyst_alarm[i] = 0;
>> +                                     updated_max_hyst_alarm = true;
>> +                             }
>> +                     }
>> +             }
>> +             mutex_unlock(&data->lock);
>> +
>> +             /* hwmon attr index starts at 1, thus "i+1" below */
>> +             if (updated_min_alarm) {
>> +                     ret = sprintf(alarm_node, "temp%d_min_alarm", (i + 1));
>
>         Unnecessary ( ).
>
>> +                     sysfs_notify(&data->pdev->dev.kobj, NULL, alarm_node);
>> +             }
>> +             if (updated_max_alarm) {
>> +                     ret = sprintf(alarm_node, "temp%d_max_alarm", (i + 1));
>
>         Unnecessary ( )
>
>> +                     sysfs_notify(&data->pdev->dev.kobj, NULL, alarm_node);
>> +             }
>> +             if (updated_max_hyst_alarm) {
>> +                     ret = sprintf(alarm_node, "temp%d_max_hyst_alarm",
>> +                                    (i + 1));
>
>         Unnecessary ( )
>
Yes of above three.

>> +                     sysfs_notify(&data->pdev->dev.kobj, NULL, alarm_node);
>> +             }
>
> You never reset any of the booleans in the loop. That means that after the first
> notification all subsequent attributes will get notified, even if nothing
> happened with those. For example, after notifying temp1_max_alarm,
> temp[2-5]_max_alarm will be notified as well. Is that on purpose ?
>
This should be fixed, thanks.

>
>> +     }
>> +
>> +     delay_in_jiffies = msecs_to_jiffies(data->gpadc_monitor_delay);
>> +     data->work_active = true;
>> +     schedule_delayed_work(&data->work, delay_in_jiffies);
>> +}
>> +
>> +static ssize_t set_temp_monitor_delay(struct device *dev,
>> +                                   struct device_attribute *devattr,
>> +                                   const char *buf, size_t count)
>> +{
>> +     int res;
>> +     unsigned long delay_in_s;
>> +     struct abx500_temp *data = dev_get_drvdata(dev);
>> +
>> +     res = kstrtoul(buf, 10, &delay_in_s);
>> +     if (res < 0)
>> +             return res;
>> +
>> +     mutex_lock(&data->lock);
>> +     data->gpadc_monitor_delay = delay_in_s * 1000;
>> +
> No concern about overflows ?
>
>> +     if (find_active_thresholds(data))
>> +             schedule_monitor(data);
>> +
>> +     mutex_unlock(&data->lock);
>> +
>> +     return count;
>> +}
>> +
>> +static ssize_t set_temp_power_off_delay(struct device *dev,
>> +                                     struct device_attribute *devattr,
>> +                                     const char *buf, size_t count)
>> +{
>> +     int res;
>> +     unsigned long delay_in_s;
>> +     struct abx500_temp *data = dev_get_drvdata(dev);
>> +
>> +     res = kstrtoul(buf, 10, &delay_in_s);
>> +     if (res < 0)
>> +             return res;
>> +
>> +     mutex_lock(&data->lock);
>> +     data->power_off_delay = delay_in_s * 1000;
>
> No concern about overflows ?
>
Will fix of above two potential overflows.

>> +     mutex_unlock(&data->lock);
>> +
>> +     return count;
>> +}
>> +
>> +static ssize_t show_temp_monitor_delay(struct device *dev,
>> +                                    struct device_attribute *devattr,
>> +                                    char *buf)
>> +{
>> +     struct abx500_temp *data = dev_get_drvdata(dev);
>> +     /* return time in s, not ms */
>> +     return sprintf(buf, "%lu\n", (data->gpadc_monitor_delay) / 1000);
>> +}
>> +
>> +static ssize_t show_temp_power_off_delay(struct device *dev,
>> +                                      struct device_attribute *devattr,
>> +                                      char *buf)
>> +{
>> +     struct abx500_temp *data = dev_get_drvdata(dev);
>> +     /* return time in s, not ms */
>> +     return sprintf(buf, "%lu\n", (data->power_off_delay) / 1000);
>> +}
>> +
>> +/*
>> + * HWMON sysfs interfaces
>> + * For all the below set and show functions, the hwmon attr index starts at 1,
>> + * thus "attr->index-1" is used.
>
> Even though the attribute _names_ start with 1 for most attributes, that doesn't
> mean the index parameter to SENSOR_DEVICE_ATTR has to start with 1. Subtracting
> 1 from attr->index each time it is used is simply a waste of computing resources.
>
> Just start the index from 0.
>
Get it, thanks.

>> + */
>> +static ssize_t show_name(struct device *dev, struct device_attribute *devattr,
>> +                      char *buf)
>> +{
>> +     struct abx500_temp *data = dev_get_drvdata(dev);
>> +     /* Show chip name */
>> +     return data->ops.show_name(dev, devattr, buf);
>> +}
>> +
>> +static ssize_t show_label(struct device *dev,
>> +                       struct device_attribute *devattr, char *buf)
>> +{
>> +     struct abx500_temp *data = dev_get_drvdata(dev);
>> +     /* Show each sensor label */
>> +     return data->ops.show_label(dev, devattr, buf);
>> +}
>> +
>> +static ssize_t show_input(struct device *dev,
>> +                       struct device_attribute *devattr, char *buf)
>> +{
>> +     int val;
>> +     struct abx500_temp *data = dev_get_drvdata(dev);
>> +     struct sensor_device_attribute *attr = to_sensor_dev_attr(devattr);
>> +     u8 gpadc_addr = data->gpadc_addr[attr->index - 1];
>> +
>> +     val = data->ops.read_sensor(data, gpadc_addr);
>> +     if (val < 0)
>> +             dev_err(&data->pdev->dev, "GPADC read failed\n");
>> +
>> +     return sprintf(buf, "%d\n", val);
>> +}
>> +
>> +/*
>> + * Set functions (RW nodes)
>> + * For all the set functions, threshold is considered inactive if set to 0
>> + */
>> +static ssize_t set_min(struct device *dev, struct device_attribute *devattr,
>> +                    const char *buf, size_t count)
>> +{
>> +     unsigned long val;
>> +     struct abx500_temp *data = dev_get_drvdata(dev);
>> +     struct sensor_device_attribute *attr = to_sensor_dev_attr(devattr);
>> +     int res = kstrtoul(buf, 10, &val);
>> +     if (res < 0)
>> +             return res;
>> +
>> +     mutex_lock(&data->lock);
>> +
>> +     if (val == 0)
>> +             data->min_alarm[attr->index - 1] = 0;
>> +
>> +     data->min[attr->index - 1] = val;
>> +
>> +     if (val == 0)
>> +             (void) find_active_thresholds(data);
>> +     else
>> +             schedule_monitor(data);
>> +
>> +     mutex_unlock(&data->lock);
>> +
>> +     return count;
>> +}
>> +
>> +static ssize_t set_max(struct device *dev, struct device_attribute *devattr,
>> +                    const char *buf, size_t count)
>> +{
>> +     unsigned long val;
>> +     struct abx500_temp *data = dev_get_drvdata(dev);
>> +     struct sensor_device_attribute *attr = to_sensor_dev_attr(devattr);
>> +     int res = kstrtoul(buf, 10, &val);
>> +     if (res < 0)
>> +             return res;
>> +
>> +     mutex_lock(&data->lock);
>> +
>> +     if (val == 0)
>> +             data->max_alarm[attr->index - 1] = 0;
>> +
>> +     data->max[attr->index - 1] = val;
>> +
>> +     if (val == 0)
>> +             (void) find_active_thresholds(data);
>> +     else
>> +             schedule_monitor(data);
>> +
>> +     mutex_unlock(&data->lock);
>> +
>> +     return count;
>> +}
>> +
>> +static ssize_t set_max_hyst(struct device *dev,
>> +                         struct device_attribute *devattr,
>> +                         const char *buf, size_t count)
>> +{
>> +     unsigned long val;
>> +     struct abx500_temp *data = dev_get_drvdata(dev);
>> +     struct sensor_device_attribute *attr = to_sensor_dev_attr(devattr);
>> +     int res = kstrtoul(buf, 10, &val);
>> +     if (res < 0)
>> +             return res;
>> +
>> +     mutex_lock(&data->lock);
>> +
>> +     if (val == 0)
>> +             data->max_hyst_alarm[attr->index - 1] = 0;
>> +
>> +     data->max_hyst[attr->index - 1] = val;
>> +
>> +     if (val == 0)
>> +             (void) find_active_thresholds(data);
>> +     else
>> +             schedule_monitor(data);
>> +
>> +     mutex_unlock(&data->lock);
>> +
>> +     return count;
>> +}
>> +
>> +/* Show functions (RO nodes) */
>> +static ssize_t show_min(struct device *dev,
>> +                     struct device_attribute *devattr, char *buf)
>> +{
>> +     struct abx500_temp *data = dev_get_drvdata(dev);
>> +     struct sensor_device_attribute *attr = to_sensor_dev_attr(devattr);
>> +
>> +     return sprintf(buf, "%ld\n", data->min[attr->index - 1]);
>> +}
>> +
>> +static ssize_t show_max(struct device *dev,
>> +                     struct device_attribute *devattr, char *buf)
>> +{
>> +     struct abx500_temp *data = dev_get_drvdata(dev);
>> +     struct sensor_device_attribute *attr = to_sensor_dev_attr(devattr);
>> +
>> +     return sprintf(buf, "%ld\n", data->max[attr->index - 1]);
>> +}
>> +
>> +static ssize_t show_max_hyst(struct device *dev,
>> +                          struct device_attribute *devattr, char *buf)
>> +{
>> +     struct abx500_temp *data = dev_get_drvdata(dev);
>> +     struct sensor_device_attribute *attr = to_sensor_dev_attr(devattr);
>> +
>> +     return sprintf(buf, "%ld\n", data->max_hyst[attr->index - 1]);
>> +}
>> +
>> +static ssize_t show_min_alarm(struct device *dev,
>> +                           struct device_attribute *devattr, char *buf)
>> +{
>> +     struct abx500_temp *data = dev_get_drvdata(dev);
>> +     struct sensor_device_attribute *attr = to_sensor_dev_attr(devattr);
>> +
>> +     return sprintf(buf, "%ld\n", data->min_alarm[attr->index - 1]);
>> +}
>> +
>> +static ssize_t show_max_alarm(struct device *dev,
>> +                           struct device_attribute *devattr, char *buf)
>> +{
>> +     struct abx500_temp *data = dev_get_drvdata(dev);
>> +     struct sensor_device_attribute *attr = to_sensor_dev_attr(devattr);
>> +
>> +     return sprintf(buf, "%ld\n", data->max_alarm[attr->index - 1]);
>> +}
>> +
>> +static ssize_t show_max_hyst_alarm(struct device *dev,
>> +                                struct device_attribute *devattr, char *buf)
>> +{
>> +     struct abx500_temp *data = dev_get_drvdata(dev);
>> +     struct sensor_device_attribute *attr = to_sensor_dev_attr(devattr);
>> +
>> +     return sprintf(buf, "%ld\n", data->max_hyst_alarm[attr->index - 1]);
>> +}
>
> The hysteresis is intended to be the temperature at which the associated alarm
> is turned off (in this case tempX_max_alarm). An alarm related to that hysteresis
> does not make sense.
>
> This leads to the question what tempX_max_hyst reflects in the first place.
> Is it really a hysteresis or something else ? Looking into the code, I don't see
> it used as hysteresis but as additional limit. If so, you should use an
> attribute name to reflect this. tempX_crit might be an option, or
> tempX_emergency.
>
> [ On a side note, you _could_ implement hysteresis attributes, since all
> comparisons are done in software anyway, but those should reflect hysteresis
> and not just be hidden additional sensors ]
>
Understand.
Will remove temp*_hyst_alarm, and will update set_max_hyst() to make
sure temp*_max_hyst is less than the temp*_max (right ?), and also
update gpadc_monitor() to make this hyst mechanism works.

>> +
>> +static ssize_t show_crit_alarm(struct device *dev,
>> +                            struct device_attribute *devattr, char *buf)
>> +{
>> +     struct abx500_temp *data = dev_get_drvdata(dev);
>> +     struct sensor_device_attribute *attr = to_sensor_dev_attr(devattr);
>> +
>> +     return sprintf(buf, "%ld\n", data->crit_alarm[attr->index - 1]);
>> +}
>> +
>> +static mode_t abx500_attrs_visible(struct kobject *kobj,
>> +                                struct attribute *a, int n)
>> +{
>> +     struct device *dev = container_of(kobj, struct device, kobj);
>> +     struct abx500_temp *data = dev_get_drvdata(dev);
>> +
>> +     return data->ops.is_visible(a, n);
>> +}
>> +
>> +static SENSOR_DEVICE_ATTR(temp_monitor_delay, S_IRUGO | S_IWUSR,
>> +                       show_temp_monitor_delay, set_temp_monitor_delay, 0);
>> +static SENSOR_DEVICE_ATTR(temp_power_off_delay, S_IRUGO | S_IWUSR,
>> +                       show_temp_power_off_delay,
>> +                       set_temp_power_off_delay, 0);
>> +
>> +/* Chip name, required by hwmon*/
>
> space after hwmon
>
Yes.

>> +static SENSOR_DEVICE_ATTR(name, S_IRUGO, show_name, NULL, 0);
>> +
> If you don't use the index, you can use DEVICE_ATTR() instead of
> SENSOR_DEVICE_ATTR().
>
>> +/* GPADC - SENSOR1 */
>> +static SENSOR_DEVICE_ATTR(temp1_label, S_IRUGO, show_label, NULL, 1);
>> +static SENSOR_DEVICE_ATTR(temp1_input, S_IRUGO, show_input, NULL, 1);
>> +static SENSOR_DEVICE_ATTR(temp1_min, S_IWUSR | S_IRUGO, show_min, set_min, 1);
>> +static SENSOR_DEVICE_ATTR(temp1_max, S_IWUSR | S_IRUGO, show_max, set_max, 1);
>> +static SENSOR_DEVICE_ATTR(temp1_max_hyst, S_IWUSR | S_IRUGO,
>> +                       show_max_hyst, set_max_hyst, 1);
>> +static SENSOR_DEVICE_ATTR(temp1_min_alarm, S_IRUGO, show_min_alarm, NULL, 1);
>> +static SENSOR_DEVICE_ATTR(temp1_max_alarm, S_IRUGO, show_max_alarm, NULL, 1);
>> +static SENSOR_DEVICE_ATTR(temp1_max_hyst_alarm, S_IRUGO,
>> +                       show_max_hyst_alarm, NULL, 1);
>> +
>> +/* GPADC - SENSOR2 */
>> +static SENSOR_DEVICE_ATTR(temp2_label, S_IRUGO, show_label, NULL, 2);
>> +static SENSOR_DEVICE_ATTR(temp2_input, S_IRUGO, show_input, NULL, 2);
>> +static SENSOR_DEVICE_ATTR(temp2_min, S_IWUSR | S_IRUGO, show_min, set_min, 2);
>> +static SENSOR_DEVICE_ATTR(temp2_max, S_IWUSR | S_IRUGO, show_max, set_max, 2);
>> +static SENSOR_DEVICE_ATTR(temp2_max_hyst, S_IWUSR | S_IRUGO,
>> +                       show_max_hyst, set_max_hyst, 2);
>> +static SENSOR_DEVICE_ATTR(temp2_min_alarm, S_IRUGO, show_min_alarm, NULL, 2);
>> +static SENSOR_DEVICE_ATTR(temp2_max_alarm, S_IRUGO, show_max_alarm, NULL, 2);
>> +static SENSOR_DEVICE_ATTR(temp2_max_hyst_alarm, S_IRUGO,
>> +                       show_max_hyst_alarm, NULL, 2);
>> +
>> +/* GPADC - SENSOR3 */
>> +static SENSOR_DEVICE_ATTR(temp3_label, S_IRUGO, show_label, NULL, 3);
>> +static SENSOR_DEVICE_ATTR(temp3_input, S_IRUGO, show_input, NULL, 3);
>> +static SENSOR_DEVICE_ATTR(temp3_min, S_IWUSR | S_IRUGO, show_min, set_min, 3);
>> +static SENSOR_DEVICE_ATTR(temp3_max, S_IWUSR | S_IRUGO, show_max, set_max, 3);
>> +static SENSOR_DEVICE_ATTR(temp3_max_hyst, S_IWUSR | S_IRUGO,
>> +                       show_max_hyst, set_max_hyst, 3);
>> +static SENSOR_DEVICE_ATTR(temp3_min_alarm, S_IRUGO, show_min_alarm, NULL, 3);
>> +static SENSOR_DEVICE_ATTR(temp3_max_alarm, S_IRUGO, show_max_alarm, NULL, 3);
>> +static SENSOR_DEVICE_ATTR(temp3_max_hyst_alarm, S_IRUGO,
>> +                       show_max_hyst_alarm, NULL, 3);
>> +
>> +/* GPADC - SENSOR4 */
>> +static SENSOR_DEVICE_ATTR(temp4_label, S_IRUGO, show_label, NULL, 4);
>> +static SENSOR_DEVICE_ATTR(temp4_input, S_IRUGO, show_input, NULL, 4);
>> +static SENSOR_DEVICE_ATTR(temp4_min, S_IWUSR | S_IRUGO, show_min, set_min, 4);
>> +static SENSOR_DEVICE_ATTR(temp4_max, S_IWUSR | S_IRUGO, show_max, set_max, 4);
>> +static SENSOR_DEVICE_ATTR(temp4_max_hyst, S_IWUSR | S_IRUGO,
>> +                       show_max_hyst, set_max_hyst, 4);
>> +static SENSOR_DEVICE_ATTR(temp4_min_alarm, S_IRUGO, show_min_alarm, NULL, 4);
>> +static SENSOR_DEVICE_ATTR(temp4_max_alarm, S_IRUGO, show_max_alarm, NULL, 4);
>> +static SENSOR_DEVICE_ATTR(temp4_max_hyst_alarm, S_IRUGO,
>> +                       show_max_hyst_alarm, NULL, 4);
>> +
>> +/* GPADC - SENSOR5 */
>> +static SENSOR_DEVICE_ATTR(temp5_label, S_IRUGO, show_label, NULL, 5);
>> +static SENSOR_DEVICE_ATTR(temp5_input, S_IRUGO, show_input, NULL, 5);
>> +static SENSOR_DEVICE_ATTR(temp5_min, S_IWUSR | S_IRUGO, show_min, set_min, 5);
>> +static SENSOR_DEVICE_ATTR(temp5_max, S_IWUSR | S_IRUGO, show_max, set_max, 5);
>> +static SENSOR_DEVICE_ATTR(temp5_max_hyst, S_IWUSR | S_IRUGO,
>> +                       show_max_hyst, set_max_hyst, 5);
>> +static SENSOR_DEVICE_ATTR(temp5_min_alarm, S_IRUGO, show_min_alarm, NULL, 5);
>> +static SENSOR_DEVICE_ATTR(temp5_max_alarm, S_IRUGO, show_max_alarm, NULL, 5);
>> +static SENSOR_DEVICE_ATTR(temp5_max_hyst_alarm, S_IRUGO,
>> +                       show_max_hyst_alarm, NULL, 5);
>> +static SENSOR_DEVICE_ATTR(temp5_crit_alarm, S_IRUGO,
>> +                       show_crit_alarm, NULL, 5);
>> +
> crit_alarm would be expected to be set if temp5_crit is exceeded ... which you
> don't have in the first place.
>
Yes, it is set in ab8500_temp_irq_handler(): data->crit_alarm[4] = 1;

> Besides, it looks like temp5_crit_alarm is always visible even if all other
> temp5 attributes are hidden. This makes no sense - you would report an alarm on
> a non-existing sensor. The alarm should be tied to an existing sensor, and to an
> existing sensor attribute.
>
I am showing temp5_label and temp5_crit_alarm, will add temp5_crit, is this OK?

>> +struct attribute *abx500_temp_attributes[] = {
>> +     &sensor_dev_attr_name.dev_attr.attr,
>> +     &sensor_dev_attr_temp_monitor_delay.dev_attr.attr,
>> +     &sensor_dev_attr_temp_power_off_delay.dev_attr.attr,
>
> We don't accept non-standard attributes unless you provide a really good reason
> why those are needed. For the above, it seems to me that making those values
> configurable might actually be risky, especially since you don't even check the
> value range.
>
> Do those parameters really have to be configurable at runtime ?
> Why don't you use constants ? If that is not feasible, how about module
> parameters or platform data / devicetree based initialization ?
>
It is really  unnecessary to config them at runtime, will use constants.

>
>> +     /* GPADC SENSOR1 */
>> +     &sensor_dev_attr_temp1_label.dev_attr.attr,
>> +     &sensor_dev_attr_temp1_input.dev_attr.attr,
>> +     &sensor_dev_attr_temp1_min.dev_attr.attr,
>> +     &sensor_dev_attr_temp1_max.dev_attr.attr,
>> +     &sensor_dev_attr_temp1_max_hyst.dev_attr.attr,
>> +     &sensor_dev_attr_temp1_min_alarm.dev_attr.attr,
>> +     &sensor_dev_attr_temp1_max_alarm.dev_attr.attr,
>> +     &sensor_dev_attr_temp1_max_hyst_alarm.dev_attr.attr,
>> +     /* GPADC SENSOR2 */
>> +     &sensor_dev_attr_temp2_label.dev_attr.attr,
>> +     &sensor_dev_attr_temp2_input.dev_attr.attr,
>> +     &sensor_dev_attr_temp2_min.dev_attr.attr,
>> +     &sensor_dev_attr_temp2_max.dev_attr.attr,
>> +     &sensor_dev_attr_temp2_max_hyst.dev_attr.attr,
>> +     &sensor_dev_attr_temp2_min_alarm.dev_attr.attr,
>> +     &sensor_dev_attr_temp2_max_alarm.dev_attr.attr,
>> +     &sensor_dev_attr_temp2_max_hyst_alarm.dev_attr.attr,
>> +     /* GPADC SENSOR3 */
>> +     &sensor_dev_attr_temp3_label.dev_attr.attr,
>> +     &sensor_dev_attr_temp3_input.dev_attr.attr,
>> +     &sensor_dev_attr_temp3_min.dev_attr.attr,
>> +     &sensor_dev_attr_temp3_max.dev_attr.attr,
>> +     &sensor_dev_attr_temp3_max_hyst.dev_attr.attr,
>> +     &sensor_dev_attr_temp3_min_alarm.dev_attr.attr,
>> +     &sensor_dev_attr_temp3_max_alarm.dev_attr.attr,
>> +     &sensor_dev_attr_temp3_max_hyst_alarm.dev_attr.attr,
>> +     /* GPADC SENSOR4 */
>> +     &sensor_dev_attr_temp4_label.dev_attr.attr,
>> +     &sensor_dev_attr_temp4_input.dev_attr.attr,
>> +     &sensor_dev_attr_temp4_min.dev_attr.attr,
>> +     &sensor_dev_attr_temp4_max.dev_attr.attr,
>> +     &sensor_dev_attr_temp4_max_hyst.dev_attr.attr,
>> +     &sensor_dev_attr_temp4_min_alarm.dev_attr.attr,
>> +     &sensor_dev_attr_temp4_max_alarm.dev_attr.attr,
>> +     &sensor_dev_attr_temp4_max_hyst_alarm.dev_attr.attr,
>> +     /* GPADC SENSOR5*/
>
>         space after SENSOR5
>
Yes.

>> +     &sensor_dev_attr_temp5_label.dev_attr.attr,
>> +     &sensor_dev_attr_temp5_input.dev_attr.attr,
>> +     &sensor_dev_attr_temp5_min.dev_attr.attr,
>> +     &sensor_dev_attr_temp5_max.dev_attr.attr,
>> +     &sensor_dev_attr_temp5_max_hyst.dev_attr.attr,
>> +     &sensor_dev_attr_temp5_min_alarm.dev_attr.attr,
>> +     &sensor_dev_attr_temp5_max_alarm.dev_attr.attr,
>> +     &sensor_dev_attr_temp5_max_hyst_alarm.dev_attr.attr,
>> +     &sensor_dev_attr_temp5_crit_alarm.dev_attr.attr,
>> +     NULL
>> +};
>> +
>> +static const struct attribute_group abx500_temp_group = {
>> +     .attrs = abx500_temp_attributes,
>> +     .is_visible = abx500_attrs_visible,
>> +};
>> +
>> +static irqreturn_t abx500_temp_irq_handler(int irq, void *irq_data)
>> +{
>> +     struct platform_device *pdev = irq_data;
>> +     struct abx500_temp *data = platform_get_drvdata(pdev);
>> +
>> +     data->ops.irq_handler(irq, data);
>> +     return IRQ_HANDLED;
>> +}
>> +
>> +static int setup_irqs(struct platform_device *pdev)
>> +{
>> +     int ret;
>> +     int irq = platform_get_irq_byname(pdev, "ABX500_TEMP_WARM");
>> +
>> +     if (irq < 0) {
>> +             dev_err(&pdev->dev, "Get irq by name failed\n");
>> +             return irq;
>> +     }
>> +
>> +     ret = devm_request_threaded_irq(&pdev->dev, irq, NULL,
>> +             abx500_temp_irq_handler, IRQF_NO_SUSPEND, "abx500-temp", pdev);
>> +     if (ret < 0)
>> +             dev_err(&pdev->dev, "Request threaded irq failed (%d)\n", ret);
>> +
>> +     return ret;
>> +}
>> +
>> +static int abx500_temp_probe(struct platform_device *pdev)
>> +{
>> +     struct abx500_temp *data;
>> +     int err;
>> +
>> +     data = devm_kzalloc(&pdev->dev, sizeof(*data), GFP_KERNEL);
>> +     if (!data)
>> +             return -ENOMEM;
>> +
>> +     data->pdev = pdev;
>> +     mutex_init(&data->lock);
>> +
>> +     /* Chip specific initialization */
>> +     err = abx500_hwmon_init(data);
>> +     if (err < 0 || !data->ops.read_sensor || !data->ops.irq_handler
>> +         || !data->ops.show_name || !data->ops.show_label
>> +         || !data->ops.is_visible) {
>> +             dev_err(&pdev->dev, "ABx500 hwmon init failed");
>
>         If err == 0 but any of the ops is not set, you'll return 0
>         (no error).
>
Good catch, thanks.

>> +             return err;
>> +     }
>> +
>> +     data->hwmon_dev = hwmon_device_register(&pdev->dev);
>> +     if (IS_ERR(data->hwmon_dev)) {
>> +             err = PTR_ERR(data->hwmon_dev);
>> +             dev_err(&pdev->dev, "Class registration failed (%d)\n", err);
>> +             return err;
>> +     }
>
> This has to be the last call after everything else is set up. The ABI expects
> all attributes to exist when this call is made.
>
OK, learned.

>> +
>> +     INIT_DEFERRABLE_WORK(&data->work, gpadc_monitor);
>> +     data->gpadc_monitor_delay =  DEFAULT_MONITOR_DELAY;
>> +
>> +     platform_set_drvdata(pdev, data);
>> +
>> +     err = sysfs_create_group(&pdev->dev.kobj, &abx500_temp_group);
>> +     if (err < 0) {
>> +             dev_err(&pdev->dev, "Create sysfs group failed (%d)\n", err);
>> +             goto exit_platform_data;
>> +     }
>> +
>> +     err = setup_irqs(pdev);
>> +     if (err < 0) {
>> +             dev_err(&pdev->dev, "irq setup failed (%d)\n", err);
>> +             goto exit_sysfs_group;
>> +     }
>> +     return 0;
>> +
>> +exit_sysfs_group:
>> +     sysfs_remove_group(&pdev->dev.kobj, &abx500_temp_group);
>> +exit_platform_data:
>> +     platform_set_drvdata(pdev, NULL);
>
>         Unnecessary.
>
Sure.

>> +     hwmon_device_unregister(data->hwmon_dev);
>> +     return err;
>> +}
>> +
>> +static int abx500_temp_remove(struct platform_device *pdev)
>> +{
>> +     struct abx500_temp *data = platform_get_drvdata(pdev);
>> +
>> +     gpadc_monitor_exit(data);
>
> Question here is if someone can access attribute files between those two calls.
> If so, the monitor might be restarted. Might be an interesting test - add a
> sleep here for,say, 10 seconds, then try to set a limit during that time.
> If it crashes, you'll know that you have a race condition.
>
Good review! will fix it, thanks.

>> +     sysfs_remove_group(&pdev->dev.kobj, &abx500_temp_group);
>> +     platform_set_drvdata(pdev, NULL);
>
>         Unnecessary.
>
Sure.

>> +     hwmon_device_unregister(data->hwmon_dev);
>
> Has to come first, prior to removing the attributes.
>
OK.

>> +     return 0;
>> +}
>> +
>> +static int abx500_temp_suspend(struct platform_device *pdev,
>> +                            pm_message_t state)
>> +{
>> +     struct abx500_temp *data = platform_get_drvdata(pdev);
>> +
>> +     if (data->work_active)
>> +             cancel_delayed_work_sync(&data->work);
>> +     return 0;
>> +}
>> +
>> +static int abx500_temp_resume(struct platform_device *pdev)
>> +{
>> +     struct abx500_temp *data = platform_get_drvdata(pdev);
>> +
>> +     if (data->work_active)
>> +             schedule_monitor(data);
>
> Is the suspend/remove code guaranteed to be synchronized,
> or should the above be mutex protected ?
>
OK, will consider this.

>> +     return 0;
>> +}
>> +
>> +#ifdef CONFIG_OF
>> +static const struct of_device_id abx500_temp_match[] = {
>> +     { .compatible = "stericsson,abx500-temp" },
>> +     {},
>> +};
>> +#endif
>> +
>> +static struct platform_driver abx500_temp_driver = {
>> +     .driver = {
>> +             .owner = THIS_MODULE,
>> +             .name = "abx500-temp",
>> +             .of_match_table = of_match_ptr(abx500_temp_match),
>> +     },
>> +     .suspend = abx500_temp_suspend,
>> +     .resume = abx500_temp_resume,
>> +     .probe = abx500_temp_probe,
>> +     .remove = abx500_temp_remove,
>> +};
>> +
>> +module_platform_driver(abx500_temp_driver);
>> +
>> +MODULE_AUTHOR("Martin Persson <martin.persson@stericsson.com>");
>> +MODULE_DESCRIPTION("ABX500 temperature driver");
>> +MODULE_LICENSE("GPL");
>> diff --git a/drivers/hwmon/abx500.h b/drivers/hwmon/abx500.h
>> new file mode 100644
>> index 0000000..660a38e
>> --- /dev/null
>> +++ b/drivers/hwmon/abx500.h
>> @@ -0,0 +1,88 @@
>> +/*
>> + * Copyright (C) ST-Ericsson SA 2010
>> + * License terms: GNU General Public License v2
>> + * Author: Martin Persson <martin.persson@stericsson.com>
>> + */
>> +
>> +#ifndef _ABX500_H
>> +#define _ABX500_H
>> +
>> +#define NUM_SENSORS 5
>> +
>> +struct ab8500_gpadc;
>> +struct ab8500_btemp;
>> +struct abx500_temp;
>> +
>> +/*
>> + * struct abx500_temp_ops - abx500 chip specific ops
>> + * @read_sensor: reads gpadc output
>> + * @irq_handler: irq handler
>> + * @show_name: hwmon device name
>> + * @show_label: hwmon attribute label
>> + * @is_visible: is attribute visible
>> + */
>> +struct abx500_temp_ops {
>> +     int (*read_sensor)(struct abx500_temp *, u8);
>> +     int (*irq_handler)(int, struct abx500_temp *);
>> +     ssize_t (*show_name)(struct device *,
>> +                     struct device_attribute *, char *);
>> +     ssize_t (*show_label) (struct device *,
>> +                     struct device_attribute *, char *);
>> +     int (*is_visible)(struct attribute *, int);
>> +};
>> +
>> +/*
>> + * struct abx500_temp - representation of temp mon device
>> + * @pdev: platform device
>> + * @hwmon_dev: hwmon device
>> + * @ab8500_gpadc: gpadc interface for ab8500
>> + * @btemp: battery temperature interface for ab8500
>> + * @gpadc_addr: gpadc channel address
>> + * @temp: sensor temperature input value
>> + * @min: sensor temperature min value
>> + * @max: sensor temperature max value
>> + * @max_hyst: sensor temperature hysteresis value for max limit
>> + * @crit: sensor temperature critical value
>> + * @min_alarm: sensor temperature min alarm
>> + * @max_alarm: sensor temperature max alarm
>> + * @max_hyst_alarm: sensor temperature hysteresis alarm
>> + * @crit_alarm: sensor temperature critical value alarm
>> + * @work: delayed work scheduled to monitor temperature periodically
>> + * @work_active: True if work is active
>> + * @power_off_work: delayed work scheduled to power off the system
>> + *           when critical temperature is reached
>> + * @lock: mutex
>> + * @gpadc_monitor_delay: delay between temperature readings in ms
>> + * @power_off_delay: delay before power off in ms
>> + * @monitored_sensors: number of monitored sensors
>> + */
>> +struct abx500_temp {
>> +     struct platform_device *pdev;
>> +     struct device *hwmon_dev;
>> +     struct ab8500_gpadc *ab8500_gpadc;
>> +     struct ab8500_btemp *ab8500_btemp;
>> +     struct abx500_temp_ops ops;
>> +     u8 gpadc_addr[NUM_SENSORS];
>> +     unsigned long temp[NUM_SENSORS];
>> +     unsigned long min[NUM_SENSORS];
>> +     unsigned long max[NUM_SENSORS];
>> +     unsigned long max_hyst[NUM_SENSORS];
>> +     unsigned long crit[NUM_SENSORS];
>> +     unsigned long min_alarm[NUM_SENSORS];
>> +     unsigned long max_alarm[NUM_SENSORS];
>> +     unsigned long max_hyst_alarm[NUM_SENSORS];
>> +     unsigned long crit_alarm[NUM_SENSORS];
>
> Why are the alarms unsigned long and not bool ?
>
Yes bool is proper.

>> +     struct delayed_work work;
>> +     bool work_active;
>> +     struct delayed_work power_off_work;
>> +     struct mutex lock;
>> +     /* Delay (ms) between temperature readings */
>> +     unsigned long gpadc_monitor_delay;
>> +     /* Delay (ms) before power off */
>> +     unsigned long power_off_delay;
>> +     int monitored_sensors;
>> +};
>> +
>> +int __init abx500_hwmon_init(struct abx500_temp *data);
>> +
>> +#endif /* _ABX500_H */
>> --
>> 1.8.0
>>
>>
