Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759628Ab3BHDeM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 22:34:12 -0500
Received: from mail-ie0-f182.google.com ([209.85.223.182]:35316 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755300Ab3BHDeL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 22:34:11 -0500
MIME-Version: 1.0
In-Reply-To: <1360292662.2242.0.camel@rzhang1-mobl4>
References: <1359343700-30190-1-git-send-email-amit.daniel@samsung.com>
	<1359343700-30190-2-git-send-email-amit.daniel@samsung.com>
	<1359944066.2250.43.camel@rzhang1-mobl4>
	<1360292662.2242.0.camel@rzhang1-mobl4>
Date: Thu, 7 Feb 2013 19:34:10 -0800
Message-ID: <CADGdYn5QW-hvw-CiqroOBRDin5ZK=Yq4wYi-g225xYuW_94a1g@mail.gmail.com>
Subject: Re: [PATCH V2 2/2] thermal: exynos: Use the framework for temperature
 emulation support
From: amit kachhap <amit.kachhap@gmail.com>
To: Zhang Rui <rui.zhang@intel.com>
Cc: linux-pm@vger.kernel.org, jonghwa3.lee@samsung.com,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        durgadoss.r@intel.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 7, 2013 at 7:04 PM, Zhang Rui <rui.zhang@intel.com> wrote:
> On Mon, 2013-02-04 at 10:14 +0800, Zhang Rui wrote:
>> On Sun, 2013-01-27 at 19:28 -0800, Amit Daniel Kachhap wrote:
>> > This removes the driver specific sysfs support of the temperature
>> > emulation and uses the newly added core thermal framework for thermal
>> > emulation. A platform specific handler is added to support this.
>> >
>> > Signed-off-by: Amit Daniel Kachhap <amit.daniel@samsung.com>
>> > Acked-by: Kukjin Kim <kgene.kim@samsung.com>
>> > ---
>> > Changes in V2:
>> > * Added config option CONFIG_THERMAL_EMULATION instead of
>> >  CONFIG_EXYNOS_THERMAL_EMUL
>> >
>> > This patchset is based on thermal maintainer next tree.
>> > git://git.kernel.org/pub/scm/linux/kernel/git/rzhang/linux.git next
>> >
>> >  Documentation/thermal/exynos_thermal_emulation |    8 +-
>> >  drivers/thermal/Kconfig                        |    9 --
>> >  drivers/thermal/exynos_thermal.c               |  158 ++++++++++--------------
>> >  3 files changed, 67 insertions(+), 108 deletions(-)
>> >
>> > diff --git a/Documentation/thermal/exynos_thermal_emulation b/Documentation/thermal/exynos_thermal_emulation
>> > index b73bbfb..36a3e79 100644
>> > --- a/Documentation/thermal/exynos_thermal_emulation
>> > +++ b/Documentation/thermal/exynos_thermal_emulation
>> > @@ -13,11 +13,11 @@ Thermal emulation mode supports software debug for TMU's operation. User can set
>> >  manually with software code and TMU will read current temperature from user value not from
>> >  sensor's value.
>> >
>> > -Enabling CONFIG_EXYNOS_THERMAL_EMUL option will make this support in available.
>> > -When it's enabled, sysfs node will be created under
>> > -/sys/bus/platform/devices/'exynos device name'/ with name of 'emulation'.
>> > +Enabling CONFIG_THERMAL_EMULATION option will make this support available.
>> > +When it's enabled, sysfs node will be created as
>> > +/sys/devices/virtual/thermal/thermal_zone'zone id'/emul_temp.
>> >
>> > -The sysfs node, 'emulation', will contain value 0 for the initial state. When you input any
>> > +The sysfs node, 'emul_node', will contain value 0 for the initial state. When you input any
>> >  temperature you want to update to sysfs node, it automatically enable emulation mode and
>> >  current temperature will be changed into it.
>> >  (Exynos also supports user changable delay time which would be used to delay of
>> > diff --git a/drivers/thermal/Kconfig b/drivers/thermal/Kconfig
>> > index e4cf7fb..2a79510 100644
>> > --- a/drivers/thermal/Kconfig
>> > +++ b/drivers/thermal/Kconfig
>> > @@ -109,15 +109,6 @@ config EXYNOS_THERMAL
>> >       If you say yes here you get support for TMU (Thermal Management
>> >       Unit) on SAMSUNG EXYNOS series of SoC.
>> >
>> > -config EXYNOS_THERMAL_EMUL
>> > -   bool "EXYNOS TMU emulation mode support"
>> > -   depends on EXYNOS_THERMAL
>> > -   help
>> > -     Exynos 4412 and 4414 and 5 series has emulation mode on TMU.
>> > -     Enable this option will be make sysfs node in exynos thermal platform
>> > -     device directory to support emulation mode. With emulation mode sysfs
>> > -     node, you can manually input temperature to TMU for simulation purpose.
>> > -
>> >  config DB8500_THERMAL
>> >     bool "DB8500 thermal management"
>> >     depends on ARCH_U8500
>> > diff --git a/drivers/thermal/exynos_thermal.c b/drivers/thermal/exynos_thermal.c
>> > index 327102a..afe9c2a 100644
>> > --- a/drivers/thermal/exynos_thermal.c
>> > +++ b/drivers/thermal/exynos_thermal.c
>> > @@ -99,13 +99,13 @@
>> >  #define IDLE_INTERVAL 10000
>> >  #define MCELSIUS   1000
>> >
>> > -#ifdef CONFIG_EXYNOS_THERMAL_EMUL
>> > +#ifdef CONFIG_THERMAL_EMULATION
>> >  #define EXYNOS_EMUL_TIME   0x57F0
>> >  #define EXYNOS_EMUL_TIME_SHIFT     16
>> >  #define EXYNOS_EMUL_DATA_SHIFT     8
>> >  #define EXYNOS_EMUL_DATA_MASK      0xFF
>> >  #define EXYNOS_EMUL_ENABLE 0x1
>> > -#endif /* CONFIG_EXYNOS_THERMAL_EMUL */
>> > +#endif /* CONFIG_THERMAL_EMULATION */
>> >
>> >  /* CPU Zone information */
>> >  #define PANIC_ZONE      4
>> > @@ -143,6 +143,7 @@ struct  thermal_cooling_conf {
>> >  struct thermal_sensor_conf {
>> >     char name[SENSOR_NAME_LEN];
>> >     int (*read_temperature)(void *data);
>> > +   int (*write_emul_temp)(void *data, unsigned long temp);
>> >     struct thermal_trip_point_conf trip_data;
>> >     struct thermal_cooling_conf cooling_data;
>> >     void *private_data;
>> > @@ -366,6 +367,23 @@ static int exynos_get_temp(struct thermal_zone_device *thermal,
>> >     return 0;
>> >  }
>> >
>> > +/* Get temperature callback functions for thermal zone */
>> > +static int exynos_set_emul_temp(struct thermal_zone_device *thermal,
>> > +                                           unsigned long temp)
>> > +{
>> > +   void *data;
>> > +   int ret = -EINVAL;
>> > +
>> > +   if (!th_zone->sensor_conf) {
>> > +           pr_info("Temperature sensor not initialised\n");
>> > +           return -EINVAL;
>> > +   }
>> > +   data = th_zone->sensor_conf->private_data;
>> > +   if (th_zone->sensor_conf->write_emul_temp)
>> > +           ret = th_zone->sensor_conf->write_emul_temp(data, temp);
>> > +   return ret;
>> > +}
>> > +
>>
>> >  /* Get the temperature trend */
>> >  static int exynos_get_trend(struct thermal_zone_device *thermal,
>> >                     int trip, enum thermal_trend *trend)
>> > @@ -382,6 +400,7 @@ static struct thermal_zone_device_ops const exynos_dev_ops = {
>> >     .bind = exynos_bind,
>> >     .unbind = exynos_unbind,
>> >     .get_temp = exynos_get_temp,
>> > +   .set_emul_temp = exynos_set_emul_temp,
>> >     .get_trend = exynos_get_trend,
>> >     .get_mode = exynos_get_mode,
>> >     .set_mode = exynos_set_mode,
>> > @@ -700,6 +719,44 @@ static int exynos_tmu_read(struct exynos_tmu_data *data)
>> >     return temp;
>> >  }
>> >
>> > +#ifdef CONFIG_THERMAL_EMULATION
>> > +static int exynos_tmu_set_emulation(struct exynos_tmu_data *data,
>> > +                                   unsigned long temp)
>> > +{
>> > +   unsigned int reg;
>> > +   int ret = -EINVAL;
>> > +
>> > +   if (data->soc == SOC_ARCH_EXYNOS4210)
>> > +           goto out;
>> > +
>> > +   if (temp && temp < MCELSIUS)
>> > +           goto out;
>> > +
>> > +   mutex_lock(&data->lock);
>> > +   clk_enable(data->clk);
>> > +
>> > +   reg = readl(data->base + EXYNOS_EMUL_CON);
>> > +
>> > +   if (temp) {
>> > +           temp /= MCELSIUS;
>> > +
>> > +           reg = (EXYNOS_EMUL_TIME << EXYNOS_EMUL_TIME_SHIFT) |
>> > +                   (temp_to_code(data, temp)
>> > +                    << EXYNOS_EMUL_DATA_SHIFT) | EXYNOS_EMUL_ENABLE;
>> > +   } else {
>> > +           reg &= ~EXYNOS_EMUL_ENABLE;
>> > +   }
>> > +
>> > +   writel(reg, data->base + EXYNOS_EMUL_CON);
>> > +
>> > +   clk_disable(data->clk);
>> > +   mutex_unlock(&data->lock);
>> > +   return 0;
>> > +out:
>> > +   return ret;
>> > +}
>> > +#endif/*CONFIG_THERMAL_EMULATION*/
>> > +
>> >  static void exynos_tmu_work(struct work_struct *work)
>> >  {
>> >     struct exynos_tmu_data *data = container_of(work,
>> > @@ -839,93 +896,6 @@ static inline struct  exynos_tmu_platform_data *exynos_get_driver_data(
>> >                     platform_get_device_id(pdev)->driver_data;
>> >  }
>> >
>> > -#ifdef CONFIG_EXYNOS_THERMAL_EMUL
>> > -static ssize_t exynos_tmu_emulation_show(struct device *dev,
>> > -                                    struct device_attribute *attr,
>> > -                                    char *buf)
>> > -{
>> > -   struct platform_device *pdev = container_of(dev,
>> > -                                   struct platform_device, dev);
>> > -   struct exynos_tmu_data *data = platform_get_drvdata(pdev);
>> > -   unsigned int reg;
>> > -   u8 temp_code;
>> > -   int temp = 0;
>> > -
>> > -   if (data->soc == SOC_ARCH_EXYNOS4210)
>> > -           goto out;
>> > -
>> > -   mutex_lock(&data->lock);
>> > -   clk_enable(data->clk);
>> > -   reg = readl(data->base + EXYNOS_EMUL_CON);
>> > -   clk_disable(data->clk);
>> > -   mutex_unlock(&data->lock);
>> > -
>> > -   if (reg & EXYNOS_EMUL_ENABLE) {
>> > -           reg >>= EXYNOS_EMUL_DATA_SHIFT;
>> > -           temp_code = reg & EXYNOS_EMUL_DATA_MASK;
>> > -           temp = code_to_temp(data, temp_code);
>> > -   }
>> > -out:
>> > -   return sprintf(buf, "%d\n", temp * MCELSIUS);
>> > -}
>> > -
>> > -static ssize_t exynos_tmu_emulation_store(struct device *dev,
>> > -                                   struct device_attribute *attr,
>> > -                                   const char *buf, size_t count)
>> > -{
>> > -   struct platform_device *pdev = container_of(dev,
>> > -                                   struct platform_device, dev);
>> > -   struct exynos_tmu_data *data = platform_get_drvdata(pdev);
>> > -   unsigned int reg;
>> > -   int temp;
>> > -
>> > -   if (data->soc == SOC_ARCH_EXYNOS4210)
>> > -           goto out;
>> > -
>> > -   if (!sscanf(buf, "%d\n", &temp) || temp < 0)
>> > -           return -EINVAL;
>> > -
>> > -   mutex_lock(&data->lock);
>> > -   clk_enable(data->clk);
>> > -
>> > -   reg = readl(data->base + EXYNOS_EMUL_CON);
>> > -
>> > -   if (temp) {
>> > -           /* Both CELSIUS and MCELSIUS type are available for input */
>> > -           if (temp > MCELSIUS)
>> > -                   temp /= MCELSIUS;
>> > -
>> > -           reg = (EXYNOS_EMUL_TIME << EXYNOS_EMUL_TIME_SHIFT) |
>> > -                   (temp_to_code(data, (temp / MCELSIUS))
>> > -                    << EXYNOS_EMUL_DATA_SHIFT) | EXYNOS_EMUL_ENABLE;
>> > -   } else {
>> > -           reg &= ~EXYNOS_EMUL_ENABLE;
>> > -   }
>> > -
>> > -   writel(reg, data->base + EXYNOS_EMUL_CON);
>> > -
>> > -   clk_disable(data->clk);
>> > -   mutex_unlock(&data->lock);
>> > -
>> > -out:
>> > -   return count;
>> > -}
>> > -
>> > -static DEVICE_ATTR(emulation, 0644, exynos_tmu_emulation_show,
>> > -                                   exynos_tmu_emulation_store);
>> > -static int create_emulation_sysfs(struct device *dev)
>> > -{
>> > -   return device_create_file(dev, &dev_attr_emulation);
>> > -}
>> > -static void remove_emulation_sysfs(struct device *dev)
>> > -{
>> > -   device_remove_file(dev, &dev_attr_emulation);
>> > -}
>> > -#else
>> > -static inline int create_emulation_sysfs(struct device *dev) { return 0; }
>> > -static inline void remove_emulation_sysfs(struct device *dev) {}
>> > -#endif
>> > -
>> >  static int __devinit exynos_tmu_probe(struct platform_device *pdev)
>> >  {
>> >     struct exynos_tmu_data *data;
>> > @@ -1002,6 +972,10 @@ static int __devinit exynos_tmu_probe(struct platform_device *pdev)
>> >
>> >     /* Register the sensor with thermal management interface */
>> >     (&exynos_sensor_conf)->private_data = data;
>> > +#ifdef CONFIG_THERMAL_EMULATION
>> > +   (&exynos_sensor_conf)->write_emul_temp =
>> > +           (int (*)(void *, unsigned long))exynos_tmu_set_emulation;
>> > +#endif
>>
>> this is a little complicate.
>> to enable emulation, you just need
>>
>> #ifdef CONFIG_THERMAL_EMUL
>> static int exynos_set_emul_temp(struct thermal_zone_device *thermal,
>>                                               unsigned long temp)
>> {
>>       remove exynos_tmu_set_emulation and copy its code here.
>> }
>> #else
>> static int exynos_set_emul_temp() { return -EINVAL; }
>> #endif
>>
>> and
>> + .set_emul_temp = exynos_set_emul_temp,
>>
>> or do I miss something?
>>
> maybe you missed this email.
> IMO, the code above should be much cleaner.

ohh sorry I missed the later part. Will implement these comments.

Thanks,
Amit D
>
> thanks,
> rui
>> thanks,
>> rui
>> >     exynos_sensor_conf.trip_data.trip_count = pdata->trigger_level0_en +
>> >                     pdata->trigger_level1_en + pdata->trigger_level2_en +
>> >                     pdata->trigger_level3_en;
>> > @@ -1025,10 +999,6 @@ static int __devinit exynos_tmu_probe(struct platform_device *pdev)
>> >             goto err_clk;
>> >     }
>> >
>> > -   ret = create_emulation_sysfs(&pdev->dev);
>> > -   if (ret)
>> > -           dev_err(&pdev->dev, "Failed to create emulation mode sysfs node\n");
>> > -
>> >     return 0;
>> >  err_clk:
>> >     platform_set_drvdata(pdev, NULL);
>> > @@ -1040,8 +1010,6 @@ static int __devexit exynos_tmu_remove(struct platform_device *pdev)
>> >  {
>> >     struct exynos_tmu_data *data = platform_get_drvdata(pdev);
>> >
>> > -   remove_emulation_sysfs(&pdev->dev);
>> > -
>> >     exynos_tmu_control(pdev, false);
>> >
>> >     exynos_unregister_thermal();
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-samsung-soc" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
