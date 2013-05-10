Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757658Ab3EJCF1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 22:05:27 -0400
Received: from mail-ie0-f172.google.com ([209.85.223.172]:60768 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754977Ab3EJCFZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 22:05:25 -0400
MIME-Version: 1.0
In-Reply-To: <518BA706.2050202@ti.com>
References: <1367931671-3906-1-git-send-email-amit.daniel@samsung.com>
	<1367931671-3906-6-git-send-email-amit.daniel@samsung.com>
	<518BA706.2050202@ti.com>
Date: Fri, 10 May 2013 07:35:24 +0530
X-Google-Sender-Auth: ShzO6a2ZBs1Hc1l33Lrqf1w8EtQ
Message-ID: <CADGdYn5iL28wBB3QLtRvSf+=Rz2Kg5KHbQArqc-fqitKj=MH_A@mail.gmail.com>
Subject: Re: [PATCH V3 05/21] thermal: exynos: Bifurcate exynos tmu driver and
 configuration data
From: amit daniel kachhap <amit.daniel@samsung.com>
To: Eduardo Valentin <eduardo.valentin@ti.com>
Cc: linux-pm@vger.kernel.org, Zhang Rui <rui.zhang@intel.com>,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kukjin Kim <kgene.kim@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Eduardo,

On Thu, May 9, 2013 at 7:09 PM, Eduardo Valentin
<eduardo.valentin@ti.com> wrote:
> Hey Amit,
>
> On 07-05-2013 09:00, Amit Daniel Kachhap wrote:
>> This code splits the exynos tmu driver code into SOC specific data parts.
>> This will simplify adding new SOC specific data to the same TMU controller.
>
> I like the idea of spliting the code from data. The driver goes into a
> self contained direction. Thanks for doing this.Couple of minor comments
> follows.
>
>>
>> Acked-by: Kukjin Kim <kgene.kim@samsung.com>
>> Signed-off-by: Amit Daniel Kachhap <amit.daniel@samsung.com>
>> ---
>>  drivers/thermal/samsung/Kconfig                 |   13 ++++-
>>  drivers/thermal/samsung/Makefile                |    1 +
>>  drivers/thermal/samsung/exynos_thermal_common.h |    3 +-
>>  drivers/thermal/samsung/exynos_tmu.c            |   67 +------------------
>>  drivers/thermal/samsung/exynos_tmu_data.c       |   78 +++++++++++++++++++++++
>>  drivers/thermal/samsung/exynos_tmu_data.h       |   41 ++++++++++++
>>  6 files changed, 137 insertions(+), 66 deletions(-)
>>  create mode 100644 drivers/thermal/samsung/exynos_tmu_data.c
>>  create mode 100644 drivers/thermal/samsung/exynos_tmu_data.h
>>
>> diff --git a/drivers/thermal/samsung/Kconfig b/drivers/thermal/samsung/Kconfig
>> index 7857e20..f23f533 100644
>> --- a/drivers/thermal/samsung/Kconfig
>> +++ b/drivers/thermal/samsung/Kconfig
>> @@ -5,7 +5,8 @@ config EXYNOS_THERMAL
>>         If you say yes here you get support for the exynos thermal driver
>>         for exynos4 and exynos5 soc. This driver initialises the TMU, reports
>>         temperature and handles cooling action if defined. This driver uses
>> -       core thermal API's.
>> +       core thermal API's and TMU configuration data from the supported
>> +       soc's.
>>
>>  config EXYNOS_THERMAL_CORE
>>       bool "Core thermal framework support for EXYNOS SOC's"
>> @@ -15,3 +16,13 @@ config EXYNOS_THERMAL_CORE
>>         (Thermal Management Unit) common registration/unregistration
>>         functions to the core thermal layer and also to use the generic
>>         cpu cooling API's.
>> +
>> +config EXYNOS_THERMAL_DATA
>> +     bool "Temperature sensor congiguration data for EXYNOS series SOC"
>> +     depends on (CPU_EXYNOS4210 || SOC_EXYNOS4212 || SOC_EXYNOS4412 || SOC_EXYNOS5250)
>> +     depends on EXYNOS_THERMAL
>> +     help
>> +       If you say yes here you can enable TMU (Thermal Management Unit) on
>> +       SAMSUNG EXYNOS 4210, 4412, 4414 and 5250 series of SoC. This option
>> +       enables/prepares the configuration, trip and cooling data for the TMU
>> +       driver.
>
> What is your strategy here? Looks like you want to provide all required
> data (for all supported SoCs) based on 1 config entry
> (EXYNOS_THERMAL_DATA). What do you think of having one per SoC supported?

Yesterday you gave a comment that introduce something like
ARCH_HAS_TMU so now each SOC if needed will enable this from the
platform Kconfig. In this scenario I will remove EXYNOS_THERMAL_DATA
as it is not required. Also having new Kconfig or each data file for
each SOC seems too much to me :) although they are logically correct.
In many cases different soc's share the same data(here 5250, 4412,
4212). For this re-structuring I feel a single file for data looks
fine.

Thanks,
Amit Daniel
>
>> diff --git a/drivers/thermal/samsung/Makefile b/drivers/thermal/samsung/Makefile
>> index 22528d6..c0446e8 100644
>> --- a/drivers/thermal/samsung/Makefile
>> +++ b/drivers/thermal/samsung/Makefile
>> @@ -4,3 +4,4 @@
>>  obj-$(CONFIG_EXYNOS_THERMAL)                 += exynos_thermal.o
>>  exynos_thermal-y                             := exynos_tmu.o
>>  exynos_thermal-$(CONFIG_EXYNOS_THERMAL_CORE) += exynos_thermal_common.o
>> +exynos_thermal-$(CONFIG_EXYNOS_THERMAL_DATA) += exynos_tmu_data.o
>> diff --git a/drivers/thermal/samsung/exynos_thermal_common.h b/drivers/thermal/samsung/exynos_thermal_common.h
>> index 1c3f8b7..3b85858 100644
>> --- a/drivers/thermal/samsung/exynos_thermal_common.h
>> +++ b/drivers/thermal/samsung/exynos_thermal_common.h
>> @@ -62,7 +62,7 @@ struct freq_clip_table {
>>  struct       thermal_trip_point_conf {
>>       int trip_val[MAX_TRIP_COUNT];
>>       int trip_count;
>> -     u8 trigger_falling;
>> +     unsigned char trigger_falling;
>>  };
>
> Why do you need this change to bifurcate data / code? (Sounds like you
> probably want to send this in a separate patch, as it seams to be a
> separated issue).
>
>>
>>  struct       thermal_cooling_conf {
>> @@ -93,6 +93,5 @@ exynos_register_thermal(struct thermal_sensor_conf *sensor_conf) { return 0; }
>>
>>  static inline void
>>  exynos_report_trigger(void) { return; }
>> -
>
> I dont think this is realted to this patch.
>
>>  #endif /* CONFIG_EXYNOS_COMMON */
>>  #endif /* _LINUX_EXYNOS_THERMAL_COMMON_H */
>> diff --git a/drivers/thermal/samsung/exynos_tmu.c b/drivers/thermal/samsung/exynos_tmu.c
>> index a02f2c9..05b5068 100644
>> --- a/drivers/thermal/samsung/exynos_tmu.c
>> +++ b/drivers/thermal/samsung/exynos_tmu.c
>> @@ -34,6 +34,7 @@
>>  #include <linux/workqueue.h>
>>  #include "exynos_thermal_common.h"
>>  #include "exynos_tmu.h"
>> +#include "exynos_tmu_data.h"
>>
>>  /* Exynos generic registers */
>>  #define EXYNOS_TMU_REG_TRIMINFO              0x0
>> @@ -385,66 +386,6 @@ static struct thermal_sensor_conf exynos_sensor_conf = {
>>       .write_emul_temp        = exynos_tmu_set_emulation,
>>  };
>>
>> -#if defined(CONFIG_CPU_EXYNOS4210)
>> -static struct exynos_tmu_platform_data const exynos4210_default_tmu_data = {
>> -     .threshold = 80,
>> -     .trigger_levels[0] = 5,
>> -     .trigger_levels[1] = 20,
>> -     .trigger_levels[2] = 30,
>> -     .trigger_level0_en = 1,
>> -     .trigger_level1_en = 1,
>> -     .trigger_level2_en = 1,
>> -     .trigger_level3_en = 0,
>> -     .gain = 15,
>> -     .reference_voltage = 7,
>> -     .cal_type = TYPE_ONE_POINT_TRIMMING,
>> -     .freq_tab[0] = {
>> -             .freq_clip_max = 800 * 1000,
>> -             .temp_level = 85,
>> -     },
>> -     .freq_tab[1] = {
>> -             .freq_clip_max = 200 * 1000,
>> -             .temp_level = 100,
>> -     },
>> -     .freq_tab_count = 2,
>> -     .type = SOC_ARCH_EXYNOS4210,
>> -};
>> -#define EXYNOS4210_TMU_DRV_DATA (&exynos4210_default_tmu_data)
>> -#else
>> -#define EXYNOS4210_TMU_DRV_DATA (NULL)
>> -#endif
>> -
>> -#if defined(CONFIG_SOC_EXYNOS5250) || defined(CONFIG_SOC_EXYNOS4412)
>> -static struct exynos_tmu_platform_data const exynos_default_tmu_data = {
>> -     .threshold_falling = 10,
>> -     .trigger_levels[0] = 85,
>> -     .trigger_levels[1] = 103,
>> -     .trigger_levels[2] = 110,
>> -     .trigger_level0_en = 1,
>> -     .trigger_level1_en = 1,
>> -     .trigger_level2_en = 1,
>> -     .trigger_level3_en = 0,
>> -     .gain = 8,
>> -     .reference_voltage = 16,
>> -     .noise_cancel_mode = 4,
>> -     .cal_type = TYPE_ONE_POINT_TRIMMING,
>> -     .efuse_value = 55,
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
>> -};
>> -#define EXYNOS_TMU_DRV_DATA (&exynos_default_tmu_data)
>> -#else
>> -#define EXYNOS_TMU_DRV_DATA (NULL)
>> -#endif
>> -
>>  #ifdef CONFIG_OF
>>  static const struct of_device_id exynos_tmu_match[] = {
>>       {
>> @@ -453,11 +394,11 @@ static const struct of_device_id exynos_tmu_match[] = {
>>       },
>>       {
>>               .compatible = "samsung,exynos4412-tmu",
>> -             .data = (void *)EXYNOS_TMU_DRV_DATA,
>> +             .data = (void *)EXYNOS5250_TMU_DRV_DATA,
>>       },
>>       {
>>               .compatible = "samsung,exynos5250-tmu",
>> -             .data = (void *)EXYNOS_TMU_DRV_DATA,
>> +             .data = (void *)EXYNOS5250_TMU_DRV_DATA,
>>       },
>>       {},
>>  };
>> @@ -471,7 +412,7 @@ static struct platform_device_id exynos_tmu_driver_ids[] = {
>>       },
>>       {
>>               .name           = "exynos5250-tmu",
>> -             .driver_data    = (kernel_ulong_t)EXYNOS_TMU_DRV_DATA,
>> +             .driver_data    = (kernel_ulong_t)EXYNOS5250_TMU_DRV_DATA,
>>       },
>>       { },
>>  };
>> diff --git a/drivers/thermal/samsung/exynos_tmu_data.c b/drivers/thermal/samsung/exynos_tmu_data.c
>> new file mode 100644
>> index 0000000..13a60ca
>> --- /dev/null
>> +++ b/drivers/thermal/samsung/exynos_tmu_data.c
>> @@ -0,0 +1,78 @@
>> +/*
>> + * exynos_tmu_data.c - Samsung EXYNOS tmu data file
>> + *
>> + *  Copyright (C) 2013 Samsung Electronics
>> + *  Amit Daniel Kachhap <amit.daniel@samsung.com>
>> + *
>> + * This program is free software; you can redistribute it and/or modify
>> + * it under the terms of the GNU General Public License as published by
>> + * the Free Software Foundation; either version 2 of the License, or
>> + * (at your option) any later version.
>> + *
>> + * This program is distributed in the hope that it will be useful,
>> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
>> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>> + * GNU General Public License for more details.
>> + *
>> + * You should have received a copy of the GNU General Public License
>> + * along with this program; if not, write to the Free Software
>> + * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
>> + *
>> + */
>> +
>> +#include "exynos_thermal_common.h"
>> +#include "exynos_tmu.h"
>> +
>> +#if defined(CONFIG_CPU_EXYNOS4210)
>> +struct exynos_tmu_platform_data const exynos4210_default_tmu_data = {
>> +     .threshold = 80,
>> +     .trigger_levels[0] = 5,
>> +     .trigger_levels[1] = 20,
>> +     .trigger_levels[2] = 30,
>> +     .trigger_level0_en = 1,
>> +     .trigger_level1_en = 1,
>> +     .trigger_level2_en = 1,
>> +     .trigger_level3_en = 0,
>> +     .gain = 15,
>> +     .reference_voltage = 7,
>> +     .cal_type = TYPE_ONE_POINT_TRIMMING,
>> +     .freq_tab[0] = {
>> +             .freq_clip_max = 800 * 1000,
>> +             .temp_level = 85,
>> +     },
>> +     .freq_tab[1] = {
>> +             .freq_clip_max = 200 * 1000,
>> +             .temp_level = 100,
>> +     },
>> +     .freq_tab_count = 2,
>> +     .type = SOC_ARCH_EXYNOS4210,
>> +};
>> +#endif
>> +
>> +#if defined(CONFIG_SOC_EXYNOS5250) || defined(CONFIG_SOC_EXYNOS4412)
>> +struct exynos_tmu_platform_data const exynos5250_default_tmu_data = {
>> +     .threshold_falling = 10,
>> +     .trigger_levels[0] = 85,
>> +     .trigger_levels[1] = 103,
>> +     .trigger_levels[2] = 110,
>> +     .trigger_level0_en = 1,
>> +     .trigger_level1_en = 1,
>> +     .trigger_level2_en = 1,
>> +     .trigger_level3_en = 0,
>> +     .gain = 8,
>> +     .reference_voltage = 16,
>> +     .noise_cancel_mode = 4,
>> +     .cal_type = TYPE_ONE_POINT_TRIMMING,
>> +     .efuse_value = 55,
>> +     .freq_tab[0] = {
>> +             .freq_clip_max = 800 * 1000,
>> +             .temp_level = 85,
>> +     },
>> +     .freq_tab[1] = {
>> +             .freq_clip_max = 200 * 1000,
>> +             .temp_level = 103,
>> +     },
>> +     .freq_tab_count = 2,
>> +     .type = SOC_ARCH_EXYNOS,
>> +};
>> +#endif
>
> If you define config entries per SoC data, you could have a file per SoC
> data and remove the #ifdefery by solving the config in the Makefile.
> What do you think?
>
>> diff --git a/drivers/thermal/samsung/exynos_tmu_data.h b/drivers/thermal/samsung/exynos_tmu_data.h
>> new file mode 100644
>> index 0000000..5b69711
>> --- /dev/null
>> +++ b/drivers/thermal/samsung/exynos_tmu_data.h
>> @@ -0,0 +1,41 @@
>> +/*
>> + * exynos_tmu_data.h - Samsung EXYNOS tmu data header file
>> + *
>> + *  Copyright (C) 2013 Samsung Electronics
>> + *  Amit Daniel Kachhap <amit.daniel@samsung.com>
>> + *
>> + * This program is free software; you can redistribute it and/or modify
>> + * it under the terms of the GNU General Public License as published by
>> + * the Free Software Foundation; either version 2 of the License, or
>> + * (at your option) any later version.
>> + *
>> + * This program is distributed in the hope that it will be useful,
>> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
>> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>> + * GNU General Public License for more details.
>> + *
>> + * You should have received a copy of the GNU General Public License
>> + * along with this program; if not, write to the Free Software
>> + * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
>> + *
>> + */
>> +
>> +#ifndef _LINUX_EXYNOS_TMU_DATA_H
>> +#define _LINUX_EXYNOS_TMU_DATA_H
>> +
> how about _EXYNOS_TMU_DATA_H ?
>
>
>
>> +#if defined(CONFIG_CPU_EXYNOS4210) && defined(CONFIG_EXYNOS_THERMAL_DATA)
>> +extern struct exynos_tmu_platform_data const exynos4210_default_tmu_data;
>> +#define EXYNOS4210_TMU_DRV_DATA (&exynos4210_default_tmu_data)
>> +#else
>> +#define EXYNOS4210_TMU_DRV_DATA (NULL)
>> +#endif
>> +
>> +#if (defined(CONFIG_SOC_EXYNOS5250) || defined(CONFIG_SOC_EXYNOS4412)) && \
>> +defined(CONFIG_EXYNOS_THERMAL_DATA)
>> +extern struct exynos_tmu_platform_data const exynos5250_default_tmu_data;
>> +#define EXYNOS5250_TMU_DRV_DATA (&exynos5250_default_tmu_data)
>> +#else
>> +#define EXYNOS5250_TMU_DRV_DATA (NULL)
>> +#endif
>> +
>> +#endif /*_LINUX_EXYNOS_TMU_DATA_H*/
>>
>
>
