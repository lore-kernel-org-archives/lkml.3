Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965870Ab3FUFG5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 01:06:57 -0400
Received: from mail-ie0-f169.google.com ([209.85.223.169]:45442 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965549Ab3FUFGz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 01:06:55 -0400
MIME-Version: 1.0
In-Reply-To: <51C209F9.4000008@ti.com>
References: <1371451599-31035-1-git-send-email-amit.daniel@samsung.com>
	<1371451599-31035-8-git-send-email-amit.daniel@samsung.com>
	<51C20810.5070601@ti.com>
	<51C209F9.4000008@ti.com>
Date: Fri, 21 Jun 2013 10:36:55 +0530
X-Google-Sender-Auth: AGF7OTILRm75blIHbFDSNwYQTDo
Message-ID: <CADGdYn40Bk9C9DG74LDToiQdSEcVK7aCkgWwXkdWRDg4_Cv6tQ@mail.gmail.com>
Subject: Re: [PATCH V6 07/30] thermal: exynos: Bifurcate exynos tmu driver and
 configuration data
From: amit daniel kachhap <amit.daniel@samsung.com>
To: Eduardo Valentin <eduardo.valentin@ti.com>
Cc: linux-pm@vger.kernel.org, Zhang Rui <rui.zhang@intel.com>,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kukjin Kim <kgene.kim@samsung.com>, jonghwa3.lee@samsung.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 20, 2013 at 1:13 AM, Eduardo Valentin
<eduardo.valentin@ti.com> wrote:
> On 19-06-2013 15:35, Eduardo Valentin wrote:
>> Rui,
>>
>> On 17-06-2013 02:46, Amit Daniel Kachhap wrote:
>>> This code splits the exynos tmu driver code into SOC specific data parts.
>>> This will simplify adding new SOC specific data to the same TMU controller.
>>>
>>> Acked-by: Kukjin Kim <kgene.kim@samsung.com>
>>> Acked-by: Jonghwa Lee <jonghwa3.lee@samsung.com>
>>> Signed-off-by: Amit Daniel Kachhap <amit.daniel@samsung.com>
>>
>> This patch looks good to me, you may want to add my:
>>
>> Acked-by: Eduardo Valentin <eduardo.valentin@ti.com>
>
> Yet another minor before adding my ack, sorry this one almost fell into
> the cracks (see below):
>
>>
>>> ---
>>>  drivers/thermal/samsung/Kconfig           |    3 +-
>>>  drivers/thermal/samsung/Makefile          |    1 +
>>>  drivers/thermal/samsung/exynos_tmu.c      |   67 ++-----------------------
>>>  drivers/thermal/samsung/exynos_tmu_data.c |   78 +++++++++++++++++++++++++++++
>>>  drivers/thermal/samsung/exynos_tmu_data.h |   40 +++++++++++++++
>>>  5 files changed, 125 insertions(+), 64 deletions(-)
>>>  create mode 100644 drivers/thermal/samsung/exynos_tmu_data.c
>>>  create mode 100644 drivers/thermal/samsung/exynos_tmu_data.h
>>>
>>> diff --git a/drivers/thermal/samsung/Kconfig b/drivers/thermal/samsung/Kconfig
>>> index f8100b1..b653f15 100644
>>> --- a/drivers/thermal/samsung/Kconfig
>>> +++ b/drivers/thermal/samsung/Kconfig
>>> @@ -5,7 +5,8 @@ config EXYNOS_THERMAL
>>>        If you say yes here you get support for the TMU (Thermal Management
>>>        Unit) driver for SAMSUNG EXYNOS series of soc. This driver initialises
>>>        the TMU, reports temperature and handles cooling action if defined.
>>> -      This driver uses the exynos core thermal API's.
>>> +      This driver uses the exynos core thermal API's and TMU configuration
>>> +      data from the supported soc's.
>>>
>>>  config EXYNOS_THERMAL_CORE
>>>      bool "Core thermal framework support for EXYNOS SOC's"
>>> diff --git a/drivers/thermal/samsung/Makefile b/drivers/thermal/samsung/Makefile
>>> index 22528d6..c09d830 100644
>>> --- a/drivers/thermal/samsung/Makefile
>>> +++ b/drivers/thermal/samsung/Makefile
>>> @@ -3,4 +3,5 @@
>>>  #
>>>  obj-$(CONFIG_EXYNOS_THERMAL)                        += exynos_thermal.o
>>>  exynos_thermal-y                            := exynos_tmu.o
>>> +exynos_thermal-y                            += exynos_tmu_data.o
>>>  exynos_thermal-$(CONFIG_EXYNOS_THERMAL_CORE)        += exynos_thermal_common.o
>>> diff --git a/drivers/thermal/samsung/exynos_tmu.c b/drivers/thermal/samsung/exynos_tmu.c
>>> index 6aa2fd2..5df04a1 100644
>>> --- a/drivers/thermal/samsung/exynos_tmu.c
>>> +++ b/drivers/thermal/samsung/exynos_tmu.c
>>> @@ -30,6 +30,7 @@
>>>
>>>  #include "exynos_thermal_common.h"
>>>  #include "exynos_tmu.h"
>>> +#include "exynos_tmu_data.h"
>>>
>>>  /* Exynos generic registers */
>>>  #define EXYNOS_TMU_REG_TRIMINFO             0x0
>>> @@ -381,66 +382,6 @@ static struct thermal_sensor_conf exynos_sensor_conf = {
>>>      .write_emul_temp        = exynos_tmu_set_emulation,
>>>  };
>>>
>>> -#if defined(CONFIG_CPU_EXYNOS4210)
>>> -static struct exynos_tmu_platform_data const exynos4210_default_tmu_data = {
>>> -    .threshold = 80,
>>> -    .trigger_levels[0] = 5,
>>> -    .trigger_levels[1] = 20,
>>> -    .trigger_levels[2] = 30,
>>> -    .trigger_level0_en = 1,
>>> -    .trigger_level1_en = 1,
>>> -    .trigger_level2_en = 1,
>>> -    .trigger_level3_en = 0,
>>> -    .gain = 15,
>>> -    .reference_voltage = 7,
>>> -    .cal_type = TYPE_ONE_POINT_TRIMMING,
>>> -    .freq_tab[0] = {
>>> -            .freq_clip_max = 800 * 1000,
>>> -            .temp_level = 85,
>>> -    },
>>> -    .freq_tab[1] = {
>>> -            .freq_clip_max = 200 * 1000,
>>> -            .temp_level = 100,
>>> -    },
>>> -    .freq_tab_count = 2,
>>> -    .type = SOC_ARCH_EXYNOS4210,
>>> -};
>>> -#define EXYNOS4210_TMU_DRV_DATA (&exynos4210_default_tmu_data)
>>> -#else
>>> -#define EXYNOS4210_TMU_DRV_DATA (NULL)
>>> -#endif
>>> -
>>> -#if defined(CONFIG_SOC_EXYNOS5250) || defined(CONFIG_SOC_EXYNOS4412)
>>> -static struct exynos_tmu_platform_data const exynos_default_tmu_data = {
>>> -    .threshold_falling = 10,
>>> -    .trigger_levels[0] = 85,
>>> -    .trigger_levels[1] = 103,
>>> -    .trigger_levels[2] = 110,
>>> -    .trigger_level0_en = 1,
>>> -    .trigger_level1_en = 1,
>>> -    .trigger_level2_en = 1,
>>> -    .trigger_level3_en = 0,
>>> -    .gain = 8,
>>> -    .reference_voltage = 16,
>>> -    .noise_cancel_mode = 4,
>>> -    .cal_type = TYPE_ONE_POINT_TRIMMING,
>>> -    .efuse_value = 55,
>>> -    .freq_tab[0] = {
>>> -            .freq_clip_max = 800 * 1000,
>>> -            .temp_level = 85,
>>> -    },
>>> -    .freq_tab[1] = {
>>> -            .freq_clip_max = 200 * 1000,
>>> -            .temp_level = 103,
>>> -    },
>>> -    .freq_tab_count = 2,
>>> -    .type = SOC_ARCH_EXYNOS,
>>> -};
>>> -#define EXYNOS_TMU_DRV_DATA (&exynos_default_tmu_data)
>>> -#else
>>> -#define EXYNOS_TMU_DRV_DATA (NULL)
>>> -#endif
>>> -
>>>  #ifdef CONFIG_OF
>>>  static const struct of_device_id exynos_tmu_match[] = {
>>>      {
>>> @@ -449,11 +390,11 @@ static const struct of_device_id exynos_tmu_match[] = {
>>>      },
>>>      {
>>>              .compatible = "samsung,exynos4412-tmu",
>>> -            .data = (void *)EXYNOS_TMU_DRV_DATA,
>>> +            .data = (void *)EXYNOS5250_TMU_DRV_DATA,
>>>      },
>>>      {
>>>              .compatible = "samsung,exynos5250-tmu",
>>> -            .data = (void *)EXYNOS_TMU_DRV_DATA,
>>> +            .data = (void *)EXYNOS5250_TMU_DRV_DATA,
>>>      },
>>>      {},
>>>  };
>>> @@ -467,7 +408,7 @@ static struct platform_device_id exynos_tmu_driver_ids[] = {
>>>      },
>>>      {
>>>              .name           = "exynos5250-tmu",
>>> -            .driver_data    = (kernel_ulong_t)EXYNOS_TMU_DRV_DATA,
>>> +            .driver_data    = (kernel_ulong_t)EXYNOS5250_TMU_DRV_DATA,
>>>      },
>>>      { },
>>>  };
>>> diff --git a/drivers/thermal/samsung/exynos_tmu_data.c b/drivers/thermal/samsung/exynos_tmu_data.c
>>> new file mode 100644
>>> index 0000000..13a60ca
>>> --- /dev/null
>>> +++ b/drivers/thermal/samsung/exynos_tmu_data.c
>>> @@ -0,0 +1,78 @@
>>> +/*
>>> + * exynos_tmu_data.c - Samsung EXYNOS tmu data file
>>> + *
>>> + *  Copyright (C) 2013 Samsung Electronics
>>> + *  Amit Daniel Kachhap <amit.daniel@samsung.com>
>>> + *
>>> + * This program is free software; you can redistribute it and/or modify
>>> + * it under the terms of the GNU General Public License as published by
>>> + * the Free Software Foundation; either version 2 of the License, or
>>> + * (at your option) any later version.
>>> + *
>>> + * This program is distributed in the hope that it will be useful,
>>> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
>>> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>>> + * GNU General Public License for more details.
>>> + *
>>> + * You should have received a copy of the GNU General Public License
>>> + * along with this program; if not, write to the Free Software
>>> + * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
>>> + *
>>> + */
>>> +
>>> +#include "exynos_thermal_common.h"
>
> You have to:
> +#include "exynos_tmu_data.h"
>
> Otherwise, you will get:
>   CC [M]  drivers/thermal/samsung/exynos_tmu.o
> drivers/thermal/samsung/exynos_tmu_data.c:27:39: warning: symbol
> 'exynos4210_default_tmu_data' was not declared. Should it be static?
> drivers/thermal/samsung/exynos_tmu_data.c:53:39: warning: symbol
> 'exynos5250_default_tmu_data' was not declared. Should it be static?
Ok.
>
>
>>> +#include "exynos_tmu.h"
>
>>> +
>>> +#if defined(CONFIG_CPU_EXYNOS4210)
>>> +struct exynos_tmu_platform_data const exynos4210_default_tmu_data = {
>>> +    .threshold = 80,
>>> +    .trigger_levels[0] = 5,
>>> +    .trigger_levels[1] = 20,
>>> +    .trigger_levels[2] = 30,
>>> +    .trigger_level0_en = 1,
>>> +    .trigger_level1_en = 1,
>>> +    .trigger_level2_en = 1,
>>> +    .trigger_level3_en = 0,
>>> +    .gain = 15,
>>> +    .reference_voltage = 7,
>>> +    .cal_type = TYPE_ONE_POINT_TRIMMING,
>>> +    .freq_tab[0] = {
>>> +            .freq_clip_max = 800 * 1000,
>>> +            .temp_level = 85,
>>> +    },
>>> +    .freq_tab[1] = {
>>> +            .freq_clip_max = 200 * 1000,
>>> +            .temp_level = 100,
>>> +    },
>>> +    .freq_tab_count = 2,
>>> +    .type = SOC_ARCH_EXYNOS4210,
>>> +};
>>> +#endif
>>> +
>>> +#if defined(CONFIG_SOC_EXYNOS5250) || defined(CONFIG_SOC_EXYNOS4412)
>>> +struct exynos_tmu_platform_data const exynos5250_default_tmu_data = {
>>> +    .threshold_falling = 10,
>>> +    .trigger_levels[0] = 85,
>>> +    .trigger_levels[1] = 103,
>>> +    .trigger_levels[2] = 110,
>>> +    .trigger_level0_en = 1,
>>> +    .trigger_level1_en = 1,
>>> +    .trigger_level2_en = 1,
>>> +    .trigger_level3_en = 0,
>>> +    .gain = 8,
>>> +    .reference_voltage = 16,
>>> +    .noise_cancel_mode = 4,
>>> +    .cal_type = TYPE_ONE_POINT_TRIMMING,
>>> +    .efuse_value = 55,
>>> +    .freq_tab[0] = {
>>> +            .freq_clip_max = 800 * 1000,
>>> +            .temp_level = 85,
>>> +    },
>>> +    .freq_tab[1] = {
>>> +            .freq_clip_max = 200 * 1000,
>>> +            .temp_level = 103,
>>> +    },
>>> +    .freq_tab_count = 2,
>>> +    .type = SOC_ARCH_EXYNOS,
>>> +};
>>> +#endif
>>> diff --git a/drivers/thermal/samsung/exynos_tmu_data.h b/drivers/thermal/samsung/exynos_tmu_data.h
>>> new file mode 100644
>>> index 0000000..b7835fe
>>> --- /dev/null
>>> +++ b/drivers/thermal/samsung/exynos_tmu_data.h
>>> @@ -0,0 +1,40 @@
>>> +/*
>>> + * exynos_tmu_data.h - Samsung EXYNOS tmu data header file
>>> + *
>>> + *  Copyright (C) 2013 Samsung Electronics
>>> + *  Amit Daniel Kachhap <amit.daniel@samsung.com>
>>> + *
>>> + * This program is free software; you can redistribute it and/or modify
>>> + * it under the terms of the GNU General Public License as published by
>>> + * the Free Software Foundation; either version 2 of the License, or
>>> + * (at your option) any later version.
>>> + *
>>> + * This program is distributed in the hope that it will be useful,
>>> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
>>> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>>> + * GNU General Public License for more details.
>>> + *
>>> + * You should have received a copy of the GNU General Public License
>>> + * along with this program; if not, write to the Free Software
>>> + * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
>>> + *
>>> + */
>>> +
>>> +#ifndef _EXYNOS_TMU_DATA_H
>>> +#define _EXYNOS_TMU_DATA_H
>>> +
>>> +#if defined(CONFIG_CPU_EXYNOS4210)
>>> +extern struct exynos_tmu_platform_data const exynos4210_default_tmu_data;
>>> +#define EXYNOS4210_TMU_DRV_DATA (&exynos4210_default_tmu_data)
>>> +#else
>>> +#define EXYNOS4210_TMU_DRV_DATA (NULL)
>>> +#endif
>>> +
>>> +#if (defined(CONFIG_SOC_EXYNOS5250) || defined(CONFIG_SOC_EXYNOS4412))
>>> +extern struct exynos_tmu_platform_data const exynos5250_default_tmu_data;
>>> +#define EXYNOS5250_TMU_DRV_DATA (&exynos5250_default_tmu_data)
>>> +#else
>>> +#define EXYNOS5250_TMU_DRV_DATA (NULL)
>>> +#endif
>>> +
>>> +#endif /*_EXYNOS_TMU_DATA_H*/
>>>
>>
>>
>
>
> --
> You have got to be excited about what you are doing. (L. Lamport)
>
> Eduardo Valentin
>
