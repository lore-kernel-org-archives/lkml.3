Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965749Ab3FUMqI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 08:46:08 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:52751 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933901Ab3FUMqE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 08:46:04 -0400
MIME-Version: 1.0
In-Reply-To: <51C23E78.1010202@ti.com>
References: <1371451599-31035-1-git-send-email-amit.daniel@samsung.com>
	<1371451599-31035-19-git-send-email-amit.daniel@samsung.com>
	<51C23E78.1010202@ti.com>
Date: Fri, 21 Jun 2013 18:16:03 +0530
X-Google-Sender-Auth: _vtKIIgROsGqQzn2-iPKEGYzARA
Message-ID: <CADGdYn7=UcOFN=SFbik_7E=_EG-htdv7bKZADeUk6WidStmKrw@mail.gmail.com>
Subject: Re: [PATCH V6 18/30] thermal: exynos: Add support to handle many
 instances of TMU
From: amit daniel kachhap <amit.daniel@samsung.com>
To: Eduardo Valentin <eduardo.valentin@ti.com>
Cc: linux-pm@vger.kernel.org, Zhang Rui <rui.zhang@intel.com>,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kukjin Kim <kgene.kim@samsung.com>, jonghwa3.lee@samsung.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Eduardo,

On Thu, Jun 20, 2013 at 4:57 AM, Eduardo Valentin
<eduardo.valentin@ti.com> wrote:
> On 17-06-2013 02:46, Amit Daniel Kachhap wrote:
>> This patch adds support to handle multiple instances of the TMU controllers.
>> This is done by removing the static structure to register with the core thermal
>> and creating it dynamically for each instance of the TMU controller. The
>> interrupt is made shared type to handle shared interrupts. Also
>> the identifier of the TMU controller is extracted from device tree alias.
>>
>> Acked-by: Kukjin Kim <kgene.kim@samsung.com>
>> Acked-by: Jonghwa Lee <jonghwa3.lee@samsung.com>
>> Signed-off-by: Amit Daniel Kachhap <amit.daniel@samsung.com>
>> ---
>>  drivers/thermal/samsung/exynos_thermal_common.h |    1 +
>>  drivers/thermal/samsung/exynos_tmu.c            |  147 ++++++++++++++++-------
>>  drivers/thermal/samsung/exynos_tmu.h            |   13 ++
>>  drivers/thermal/samsung/exynos_tmu_data.c       |  145 ++++++++++++----------
>>  drivers/thermal/samsung/exynos_tmu_data.h       |    4 +-
>>  5 files changed, 197 insertions(+), 113 deletions(-)
>>
>> diff --git a/drivers/thermal/samsung/exynos_thermal_common.h b/drivers/thermal/samsung/exynos_thermal_common.h
>> index dd0077e..0c189d6 100644
>> --- a/drivers/thermal/samsung/exynos_thermal_common.h
>> +++ b/drivers/thermal/samsung/exynos_thermal_common.h
>> @@ -84,6 +84,7 @@ struct thermal_sensor_conf {
>>       struct thermal_cooling_conf cooling_data;
>>       void *driver_data;
>>       void *pzone_data;
>> +     struct device *dev;
>>  };
>>
>>  /*Functions used exynos based thermal sensor driver*/
>> diff --git a/drivers/thermal/samsung/exynos_tmu.c b/drivers/thermal/samsung/exynos_tmu.c
>> index 4356118..1880c4e 100644
>> --- a/drivers/thermal/samsung/exynos_tmu.c
>> +++ b/drivers/thermal/samsung/exynos_tmu.c
>> @@ -26,15 +26,32 @@
>>  #include <linux/interrupt.h>
>>  #include <linux/module.h>
>>  #include <linux/of.h>
>> +#include <linux/of_address.h>
>> +#include <linux/of_irq.h>
>>  #include <linux/platform_device.h>
>>
>>  #include "exynos_thermal_common.h"
>>  #include "exynos_tmu.h"
>>  #include "exynos_tmu_data.h"
>>
>> +/**
>> + * struct exynos_tmu_data : A structure to hold the private data of the TMU
>> +     driver
>> + * @id: identifier of the one instance of the TMU controller.
>> + * @pdata: pointer to the tmu platform/configuration data
>> + * @base: base address of the single instance of the TMU controller.
>> + * @irq: irq number of the TMU controller.
>> + * @soc: id of the SOC type.
>> + * @irq_work: pointer to the irq work structure.
>> + * @lock: lock to implement synchronization.
>> + * @clk: pointer to the clock structure.
>> + * @temp_error1: fused value of the first point trim.
>> + * @temp_error2: fused value of the second point trim.
>> + * @reg_conf: pointer to structure to register with core thermal.
>> + */
>>  struct exynos_tmu_data {
>> +     int id;
>>       struct exynos_tmu_platform_data *pdata;
>> -     struct resource *mem;
>>       void __iomem *base;
>>       int irq;
>>       enum soc_type soc;
>> @@ -42,6 +59,7 @@ struct exynos_tmu_data {
>>       struct mutex lock;
>>       struct clk *clk;
>>       u8 temp_error1, temp_error2;
>> +     struct thermal_sensor_conf *reg_conf;
>>  };
>>
>>  /*
>> @@ -345,12 +363,6 @@ static int exynos_tmu_set_emulation(void *drv_data,      unsigned long temp)
>>       { return -EINVAL; }
>>  #endif/*CONFIG_THERMAL_EMULATION*/
>>
>> -static struct thermal_sensor_conf exynos_sensor_conf = {
>> -     .name                   = "exynos-therm",
>> -     .read_temperature       = (int (*)(void *))exynos_tmu_read,
>> -     .write_emul_temp        = exynos_tmu_set_emulation,
>> -};
>> -
>>  static void exynos_tmu_work(struct work_struct *work)
>>  {
>>       struct exynos_tmu_data *data = container_of(work,
>> @@ -359,7 +371,7 @@ static void exynos_tmu_work(struct work_struct *work)
>>       const struct exynos_tmu_registers *reg = pdata->registers;
>>       unsigned int val_irq;
>>
>> -     exynos_report_trigger(&exynos_sensor_conf);
>> +     exynos_report_trigger(data->reg_conf);
>>       mutex_lock(&data->lock);
>>       clk_enable(data->clk);
>>
>> @@ -404,33 +416,73 @@ MODULE_DEVICE_TABLE(of, exynos_tmu_match);
>>  #endif
>>
>>  static inline struct  exynos_tmu_platform_data *exynos_get_driver_data(
>> -                     struct platform_device *pdev)
>> +                     struct platform_device *pdev, int id)
>>  {
>> +     struct  exynos_tmu_init_data *data_table;
>> +     struct exynos_tmu_platform_data *tmu_data;
>>  #ifdef CONFIG_OF
>>       if (pdev->dev.of_node) {
>>               const struct of_device_id *match;
>>               match = of_match_node(exynos_tmu_match, pdev->dev.of_node);
>>               if (!match)
>>                       return NULL;
>> -             return (struct exynos_tmu_platform_data *) match->data;
>> +             data_table = (struct exynos_tmu_init_data *) match->data;
>> +             if (!data_table || id >= data_table->tmu_count)
>> +                     return NULL;
>> +             tmu_data = data_table->tmu_data;
>> +             return (struct exynos_tmu_platform_data *) (tmu_data + id);
>>       }
>>  #endif
>>       return NULL;
>>  }
>>
>> -static int exynos_tmu_probe(struct platform_device *pdev)
>> +static int exynos_map_dt_data(struct platform_device *pdev)
>>  {
>> -     struct exynos_tmu_data *data;
>> -     struct exynos_tmu_platform_data *pdata = pdev->dev.platform_data;
>> -     int ret, i;
>> +     struct exynos_tmu_data *data = platform_get_drvdata(pdev);
>> +     struct exynos_tmu_platform_data *pdata;
>> +     struct resource res;
>>
>> -     if (!pdata)
>> -             pdata = exynos_get_driver_data(pdev);
>> +     if (!data)
>> +             return -ENODEV;
>> +
>> +     data->id = of_alias_get_id(pdev->dev.of_node, "tmuctrl");
>> +     if (data->id < 0)
>> +             data->id = 0;
>>
>> +     data->irq = irq_of_parse_and_map(pdev->dev.of_node, 0);
>> +     if (data->irq <= 0) {
>> +             dev_err(&pdev->dev, "failed to get IRQ\n");
>> +             return -ENODEV;
>> +     }
>> +
>> +     if (of_address_to_resource(pdev->dev.of_node, 0, &res)) {
>> +             dev_err(&pdev->dev, "failed to get Resource 0\n");
>> +             return -ENODEV;
>> +     }
>> +
>> +     data->base = devm_ioremap(&pdev->dev, res.start, resource_size(&res));
>> +     if (!data->base) {
>> +             dev_err(&pdev->dev, "Failed to ioremap memory\n");
>> +             return -EADDRNOTAVAIL;
>> +     }
>> +
>> +     pdata = exynos_get_driver_data(pdev, data->id);
>>       if (!pdata) {
>>               dev_err(&pdev->dev, "No platform init data supplied.\n");
>>               return -ENODEV;
>>       }
>> +     data->pdata = pdata;
>> +
>> +     return 0;
>> +}
>> +
>> +static int exynos_tmu_probe(struct platform_device *pdev)
>> +{
>> +     struct exynos_tmu_data *data;
>> +     struct exynos_tmu_platform_data *pdata;
>> +     struct thermal_sensor_conf *sensor_conf;
>> +     int ret, i;
>> +
>>       data = devm_kzalloc(&pdev->dev, sizeof(struct exynos_tmu_data),
>>                                       GFP_KERNEL);
>>       if (!data) {
>> @@ -438,21 +490,18 @@ static int exynos_tmu_probe(struct platform_device *pdev)
>>               return -ENOMEM;
>>       }
>>
>> -     data->irq = platform_get_irq(pdev, 0);
>> -     if (data->irq < 0) {
>> -             dev_err(&pdev->dev, "Failed to get platform irq\n");
>> -             return data->irq;
>> -     }
>> +     platform_set_drvdata(pdev, data);
>> +     mutex_init(&data->lock);
>>
>> -     INIT_WORK(&data->irq_work, exynos_tmu_work);
>> +     ret = exynos_map_dt_data(pdev);
>> +     if (ret)
>> +             return ret;
>>
>> -     data->mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>> -     data->base = devm_ioremap_resource(&pdev->dev, data->mem);
>> -     if (IS_ERR(data->base))
>> -             return PTR_ERR(data->base);
>> +     pdata = data->pdata;
>>
>> +     INIT_WORK(&data->irq_work, exynos_tmu_work);
>>       ret = devm_request_irq(&pdev->dev, data->irq, exynos_tmu_irq,
>> -             IRQF_TRIGGER_RISING, "exynos-tmu", data);
>> +             IRQF_TRIGGER_RISING | IRQF_SHARED, dev_name(&pdev->dev), data);
>
> Lets think about this poing:  You request the IRQ before data->reg_conf
> is allocated (below). Does it mean, from this point you can get called
> to the IRQ handler even if reg_conf is not set? What happens then? I see
> your irqhandler/worker use it.

Good catch. Will put a check in the IRQ handler.

Thanks,
Amit Daniel
>
>>       if (ret) {
>>               dev_err(&pdev->dev, "Failed to request irq: %d\n", data->irq);
>>               return ret;
>> @@ -477,10 +526,6 @@ static int exynos_tmu_probe(struct platform_device *pdev)
>>               goto err_clk;
>>       }
>>
>> -     data->pdata = pdata;
>> -     platform_set_drvdata(pdev, data);
>> -     mutex_init(&data->lock);
>> -
>>       ret = exynos_tmu_initialize(pdev);
>>       if (ret) {
>>               dev_err(&pdev->dev, "Failed to initialize TMU\n");
>> @@ -489,31 +534,43 @@ static int exynos_tmu_probe(struct platform_device *pdev)
>>
>>       exynos_tmu_control(pdev, true);
>>
>> -     /* Register the sensor with thermal management interface */
>> -     (&exynos_sensor_conf)->driver_data = data;
>> -     exynos_sensor_conf.trip_data.trip_count = pdata->trigger_enable[0] +
>> +     /* Allocate a structure to register with the exynos core thermal */
>> +     sensor_conf = devm_kzalloc(&pdev->dev,
>> +                             sizeof(struct thermal_sensor_conf), GFP_KERNEL);
>> +     if (!sensor_conf) {
>> +             dev_err(&pdev->dev, "Failed to allocate registration struct\n");
>> +             ret = -ENOMEM;
>> +             goto err_clk;
>> +     }
>> +     data->reg_conf = sensor_conf;
>> +     sprintf(sensor_conf->name, "therm_zone%d", data->id);
>> +     sensor_conf->read_temperature = (int (*)(void *))exynos_tmu_read;
>> +     sensor_conf->write_emul_temp =
>> +             (int (*)(void *, unsigned long))exynos_tmu_set_emulation;
>> +     sensor_conf->driver_data = data;
>> +     sensor_conf->trip_data.trip_count = pdata->trigger_enable[0] +
>>                       pdata->trigger_enable[1] + pdata->trigger_enable[2]+
>>                       pdata->trigger_enable[3];
>>
>> -     for (i = 0; i < exynos_sensor_conf.trip_data.trip_count; i++) {
>> -             exynos_sensor_conf.trip_data.trip_val[i] =
>> +     for (i = 0; i < sensor_conf->trip_data.trip_count; i++) {
>> +             sensor_conf->trip_data.trip_val[i] =
>>                       pdata->threshold + pdata->trigger_levels[i];
>> -             exynos_sensor_conf.trip_data.trip_type[i] =
>> +             sensor_conf->trip_data.trip_type[i] =
>>                                       pdata->trigger_type[i];
>>       }
>>
>> -     exynos_sensor_conf.trip_data.trigger_falling = pdata->threshold_falling;
>> +     sensor_conf->trip_data.trigger_falling = pdata->threshold_falling;
>>
>> -     exynos_sensor_conf.cooling_data.freq_clip_count =
>> -                                             pdata->freq_tab_count;
>> +     sensor_conf->cooling_data.freq_clip_count = pdata->freq_tab_count;
>>       for (i = 0; i < pdata->freq_tab_count; i++) {
>> -             exynos_sensor_conf.cooling_data.freq_data[i].freq_clip_max =
>> +             sensor_conf->cooling_data.freq_data[i].freq_clip_max =
>>                                       pdata->freq_tab[i].freq_clip_max;
>> -             exynos_sensor_conf.cooling_data.freq_data[i].temp_level =
>> +             sensor_conf->cooling_data.freq_data[i].temp_level =
>>                                       pdata->freq_tab[i].temp_level;
>>       }
>> -
>> -     ret = exynos_register_thermal(&exynos_sensor_conf);
>> +     sensor_conf->dev = &pdev->dev;
>> +     /* Register the sensor with thermal management interface */
>> +     ret = exynos_register_thermal(sensor_conf);
>>       if (ret) {
>>               dev_err(&pdev->dev, "Failed to register thermal interface\n");
>>               goto err_clk;
>> @@ -531,7 +588,7 @@ static int exynos_tmu_remove(struct platform_device *pdev)
>>
>>       exynos_tmu_control(pdev, false);
>>
>> -     exynos_unregister_thermal(&exynos_sensor_conf);
>> +     exynos_unregister_thermal(data->reg_conf);
>>
>>       clk_unprepare(data->clk);
>>
>> diff --git a/drivers/thermal/samsung/exynos_tmu.h b/drivers/thermal/samsung/exynos_tmu.h
>> index 619a34c..b614407 100644
>> --- a/drivers/thermal/samsung/exynos_tmu.h
>> +++ b/drivers/thermal/samsung/exynos_tmu.h
>> @@ -248,4 +248,17 @@ struct exynos_tmu_platform_data {
>>       unsigned int freq_tab_count;
>>       const struct exynos_tmu_registers *registers;
>>  };
>> +
>> +/**
>> + * struct exynos_tmu_init_data
>> + * @tmu_count: number of TMU instances.
>> + * @tmu_data: platform data of all TMU instances.
>> + * This structure is required to store data for multi-instance exynos tmu
>> + * driver.
>> + */
>> +struct exynos_tmu_init_data {
>> +     int tmu_count;
>> +     struct exynos_tmu_platform_data tmu_data[];
>> +};
>> +
>>  #endif /* _EXYNOS_TMU_H */
>> diff --git a/drivers/thermal/samsung/exynos_tmu_data.c b/drivers/thermal/samsung/exynos_tmu_data.c
>> index 7fcf183..06ecfb0 100644
>> --- a/drivers/thermal/samsung/exynos_tmu_data.c
>> +++ b/drivers/thermal/samsung/exynos_tmu_data.c
>> @@ -48,38 +48,44 @@ static const struct exynos_tmu_registers exynos4210_tmu_registers = {
>>       .tmu_intstat = EXYNOS_TMU_REG_INTSTAT,
>>       .tmu_intclear = EXYNOS_TMU_REG_INTCLEAR,
>>  };
>> -struct exynos_tmu_platform_data const exynos4210_default_tmu_data = {
>> -     .threshold = 80,
>> -     .trigger_levels[0] = 5,
>> -     .trigger_levels[1] = 20,
>> -     .trigger_levels[2] = 30,
>> -     .trigger_enable[0] = 1,
>> -     .trigger_enable[1] = 1,
>> -     .trigger_enable[2] = 1,
>> -     .trigger_enable[3] = 0,
>> -     .trigger_type[0] = THROTTLE_ACTIVE,
>> -     .trigger_type[1] = THROTTLE_ACTIVE,
>> -     .trigger_type[2] = SW_TRIP,
>> -     .max_trigger_level = 4,
>> -     .gain = 15,
>> -     .reference_voltage = 7,
>> -     .cal_type = TYPE_ONE_POINT_TRIMMING,
>> -     .min_efuse_value = 40,
>> -     .max_efuse_value = 100,
>> -     .first_point_trim = 25,
>> -     .second_point_trim = 85,
>> -     .default_temp_offset = 50,
>> -     .freq_tab[0] = {
>> -             .freq_clip_max = 800 * 1000,
>> -             .temp_level = 85,
>> -     },
>> -     .freq_tab[1] = {
>> -             .freq_clip_max = 200 * 1000,
>> -             .temp_level = 100,
>> +
>> +struct exynos_tmu_init_data const exynos4210_default_tmu_data = {
>> +     .tmu_data = {
>> +             {
>> +             .threshold = 80,
>> +             .trigger_levels[0] = 5,
>> +             .trigger_levels[1] = 20,
>> +             .trigger_levels[2] = 30,
>> +             .trigger_enable[0] = 1,
>> +             .trigger_enable[1] = 1,
>> +             .trigger_enable[2] = 1,
>> +             .trigger_enable[3] = 0,
>> +             .trigger_type[0] = THROTTLE_ACTIVE,
>> +             .trigger_type[1] = THROTTLE_ACTIVE,
>> +             .trigger_type[2] = SW_TRIP,
>> +             .max_trigger_level = 4,
>> +             .gain = 15,
>> +             .reference_voltage = 7,
>> +             .cal_type = TYPE_ONE_POINT_TRIMMING,
>> +             .min_efuse_value = 40,
>> +             .max_efuse_value = 100,
>> +             .first_point_trim = 25,
>> +             .second_point_trim = 85,
>> +             .default_temp_offset = 50,
>> +             .freq_tab[0] = {
>> +                     .freq_clip_max = 800 * 1000,
>> +                     .temp_level = 85,
>> +                     },
>> +             .freq_tab[1] = {
>> +                     .freq_clip_max = 200 * 1000,
>> +                     .temp_level = 100,
>> +             },
>> +             .freq_tab_count = 2,
>> +             .type = SOC_ARCH_EXYNOS4210,
>> +             .registers = &exynos4210_tmu_registers,
>> +             },
>>       },
>> -     .freq_tab_count = 2,
>> -     .type = SOC_ARCH_EXYNOS4210,
>> -     .registers = &exynos4210_tmu_registers,
>> +     .tmu_count = 1,
>>  };
>>  #endif
>>
>> @@ -120,41 +126,48 @@ static const struct exynos_tmu_registers exynos5250_tmu_registers = {
>>       .emul_time_shift = EXYNOS_EMUL_TIME_SHIFT,
>>       .emul_time_mask = EXYNOS_EMUL_TIME_MASK,
>>  };
>> -struct exynos_tmu_platform_data const exynos5250_default_tmu_data = {
>> -     .threshold_falling = 10,
>> -     .trigger_levels[0] = 85,
>> -     .trigger_levels[1] = 103,
>> -     .trigger_levels[2] = 110,
>> -     .trigger_levels[3] = 120,
>> -     .trigger_enable[0] = 1,
>> -     .trigger_enable[1] = 1,
>> -     .trigger_enable[2] = 1,
>> -     .trigger_enable[3] = 0,
>> -     .trigger_type[0] = THROTTLE_ACTIVE,
>> -     .trigger_type[1] = THROTTLE_ACTIVE,
>> -     .trigger_type[2] = SW_TRIP,
>> -     .trigger_type[3] = HW_TRIP,
>> -     .max_trigger_level = 4,
>> -     .gain = 8,
>> -     .reference_voltage = 16,
>> -     .noise_cancel_mode = 4,
>> -     .cal_type = TYPE_ONE_POINT_TRIMMING,
>> -     .efuse_value = 55,
>> -     .min_efuse_value = 40,
>> -     .max_efuse_value = 100,
>> -     .first_point_trim = 25,
>> -     .second_point_trim = 85,
>> -     .default_temp_offset = 50,
>> -     .freq_tab[0] = {
>> -             .freq_clip_max = 800 * 1000,
>> -             .temp_level = 85,
>> -     },
>> -     .freq_tab[1] = {
>> -             .freq_clip_max = 200 * 1000,
>> -             .temp_level = 103,
>> -     },
>> -     .freq_tab_count = 2,
>> -     .type = SOC_ARCH_EXYNOS,
>> +
>> +#define EXYNOS5250_TMU_DATA \
>> +     .threshold_falling = 10, \
>> +     .trigger_levels[0] = 85, \
>> +     .trigger_levels[1] = 103, \
>> +     .trigger_levels[2] = 110, \
>> +     .trigger_levels[3] = 120, \
>> +     .trigger_enable[0] = 1, \
>> +     .trigger_enable[1] = 1, \
>> +     .trigger_enable[2] = 1, \
>> +     .trigger_enable[3] = 0, \
>> +     .trigger_type[0] = THROTTLE_ACTIVE, \
>> +     .trigger_type[1] = THROTTLE_ACTIVE, \
>> +     .trigger_type[2] = SW_TRIP, \
>> +     .trigger_type[3] = HW_TRIP, \
>> +     .max_trigger_level = 4, \
>> +     .gain = 8, \
>> +     .reference_voltage = 16, \
>> +     .noise_cancel_mode = 4, \
>> +     .cal_type = TYPE_ONE_POINT_TRIMMING, \
>> +     .efuse_value = 55, \
>> +     .min_efuse_value = 40, \
>> +     .max_efuse_value = 100, \
>> +     .first_point_trim = 25, \
>> +     .second_point_trim = 85, \
>> +     .default_temp_offset = 50, \
>> +     .freq_tab[0] = { \
>> +             .freq_clip_max = 800 * 1000, \
>> +             .temp_level = 85, \
>> +     }, \
>> +     .freq_tab[1] = { \
>> +             .freq_clip_max = 200 * 1000, \
>> +             .temp_level = 103, \
>> +     }, \
>> +     .freq_tab_count = 2, \
>> +     .type = SOC_ARCH_EXYNOS, \
>>       .registers = &exynos5250_tmu_registers,
>> +
>> +struct exynos_tmu_init_data const exynos5250_default_tmu_data = {
>> +     .tmu_data = {
>> +             { EXYNOS5250_TMU_DATA },
>> +     },
>> +     .tmu_count = 1,
>>  };
>>  #endif
>> diff --git a/drivers/thermal/samsung/exynos_tmu_data.h b/drivers/thermal/samsung/exynos_tmu_data.h
>> index 4acf070..139dbbb 100644
>> --- a/drivers/thermal/samsung/exynos_tmu_data.h
>> +++ b/drivers/thermal/samsung/exynos_tmu_data.h
>> @@ -94,14 +94,14 @@
>>  #define EXYNOS_MAX_TRIGGER_PER_REG   4
>>
>>  #if defined(CONFIG_CPU_EXYNOS4210)
>> -extern struct exynos_tmu_platform_data const exynos4210_default_tmu_data;
>> +extern struct exynos_tmu_init_data const exynos4210_default_tmu_data;
>>  #define EXYNOS4210_TMU_DRV_DATA (&exynos4210_default_tmu_data)
>>  #else
>>  #define EXYNOS4210_TMU_DRV_DATA (NULL)
>>  #endif
>>
>>  #if (defined(CONFIG_SOC_EXYNOS5250) || defined(CONFIG_SOC_EXYNOS4412))
>> -extern struct exynos_tmu_platform_data const exynos5250_default_tmu_data;
>> +extern struct exynos_tmu_init_data const exynos5250_default_tmu_data;
>>  #define EXYNOS5250_TMU_DRV_DATA (&exynos5250_default_tmu_data)
>>  #else
>>  #define EXYNOS5250_TMU_DRV_DATA (NULL)
>>
>
>
> --
> You have got to be excited about what you are doing. (L. Lamport)
>
> Eduardo Valentin
>
