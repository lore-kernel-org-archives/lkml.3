Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752260AbaHLJvf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 05:51:35 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:5665 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751301AbaHLJvc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 05:51:32 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Tue, 12 Aug 2014 02:42:23 -0700
Message-ID: <53E9E3A0.70005@nvidia.com>
Date: Tue, 12 Aug 2014 12:51:28 +0300
From: Mikko Perttunen <mperttunen@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Eduardo Valentin <edubezval@gmail.com>
CC: "rui.zhang@intel.com" <rui.zhang@intel.com>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "thierry.reding@gmail.com" <thierry.reding@gmail.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v3 4/4] thermal: Add Tegra SOCTHERM thermal management
 driver
References: <1407320706-17440-1-git-send-email-mperttunen@nvidia.com> <1407320706-17440-5-git-send-email-mperttunen@nvidia.com> <20140811133221.GA6920@developer>
In-Reply-To: <20140811133221.GA6920@developer>
X-NVConfidentiality: public
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/08/14 16:32, Eduardo Valentin wrote:
> Hello Mikko,
>
> It follows more small comments.
>
> On Wed, Aug 6, 2014 at 6:25 AM, Mikko Perttunen <mperttunen@nvidia.com> wrote:
>> This adds support for the Tegra SOCTHERM thermal sensing and management
>> system found in the Tegra124 system-on-chip. This initial driver supports
>> temperature polling for four thermal zones.
>>
>> Signed-off-by: Mikko Perttunen <mperttunen@nvidia.com>
>> ---
>> v3:
>> - changed commit message
>> - changed bool to tristate
>> - added text to Kconfig entry
>> - added const to t124_sensor_config
>> - removed .name and .config fields
>> - use sign_extend32 for sign extension
>>
>>   drivers/thermal/Kconfig          |  10 +
>>   drivers/thermal/Makefile         |   1 +
>>   drivers/thermal/tegra_soctherm.c | 430 +++++++++++++++++++++++++++++++++++++++
>>   3 files changed, 441 insertions(+)
>>   create mode 100644 drivers/thermal/tegra_soctherm.c
>>
>> diff --git a/drivers/thermal/Kconfig b/drivers/thermal/Kconfig
>> index 693208e..fd9d049 100644
>> --- a/drivers/thermal/Kconfig
>> +++ b/drivers/thermal/Kconfig
>> @@ -175,6 +175,16 @@ config ARMADA_THERMAL
>>            Enable this option if you want to have support for thermal management
>>            controller present in Armada 370 and Armada XP SoC.
>>
>> +config TEGRA_SOCTHERM
>> +       tristate "Tegra SOCTHERM thermal management"
>> +       depends on ARCH_TEGRA
>> +       help
>> +         Enable this option for integrated thermal management support on NVIDIA
>> +         Tegra124 systems-on-chip. The driver supports four thermal zones
>> +         (CPU, GPU, MEM, PLLX). Cooling devices can be bound to the thermal
>> +         zones to manage temperatures. This option is also required for the
>> +         emergency thermal reset (thermtrip) feature to function.
>> +
>
> Way better now. Thanks for fixing.
>
>>   config DB8500_CPUFREQ_COOLING
>>          tristate "DB8500 cpufreq cooling"
>>          depends on ARCH_U8500
>> diff --git a/drivers/thermal/Makefile b/drivers/thermal/Makefile
>> index 31e232f..f0b94d5 100644
>> --- a/drivers/thermal/Makefile
>> +++ b/drivers/thermal/Makefile
>> @@ -33,3 +33,4 @@ obj-$(CONFIG_INTEL_SOC_DTS_THERMAL)   += intel_soc_dts_thermal.o
>>   obj-$(CONFIG_TI_SOC_THERMAL)   += ti-soc-thermal/
>>   obj-$(CONFIG_ACPI_INT3403_THERMAL)     += int3403_thermal.o
>>   obj-$(CONFIG_ST_THERMAL)       += st/
>> +obj-$(CONFIG_TEGRA_SOCTHERM)   += tegra_soctherm.o
>> diff --git a/drivers/thermal/tegra_soctherm.c b/drivers/thermal/tegra_soctherm.c
>> new file mode 100644
>> index 0000000..2e5cd88
>> --- /dev/null
>> +++ b/drivers/thermal/tegra_soctherm.c
>> @@ -0,0 +1,430 @@
>> +/*
>> + * drivers/thermal/tegra_soctherm.c
>> + *
>> + * Copyright (c) 2014, NVIDIA CORPORATION.  All rights reserved.
>> + *
>> + * Author:
>> + *     Mikko Perttunen <mperttunen@nvidia.com>
>> + *
>> + * This software is licensed under the terms of the GNU General Public
>> + * License version 2, as published by the Free Software Foundation, and
>> + * may be copied, distributed, and modified under those terms.
>> + *
>> + * This program is distributed in the hope that it will be useful,
>> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
>> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>> + * GNU General Public License for more details.
>> + *
>> + */
>> +
>> +#include <linux/clk.h>
>> +#include <linux/err.h>
>> +#include <linux/io.h>
>> +#include <linux/module.h>
>> +#include <linux/of.h>
>> +#include <linux/platform_device.h>
>> +#include <linux/reset.h>
>> +#include <linux/thermal.h>
>> +#include <linux/delay.h>
>> +#include <linux/interrupt.h>
>> +#include <linux/bitops.h>
>> +#include <soc/tegra/fuse.h>
>> +
>> +#define SENSOR_CONFIG0                         0
>> +#define                SENSOR_CONFIG0_STOP             BIT(0)
>> +#define                SENSOR_CONFIG0_TALL_SHIFT       8
>> +#define                SENSOR_CONFIG0_TCALC_OVER       BIT(4)
>> +#define                SENSOR_CONFIG0_OVER             BIT(3)
>> +#define                SENSOR_CONFIG0_CPTR_OVER        BIT(2)
>> +#define SENSOR_CONFIG1                         4
>> +#define                SENSOR_CONFIG1_TSAMPLE_SHIFT    0
>> +#define                SENSOR_CONFIG1_TIDDQ_EN_SHIFT   15
>> +#define                SENSOR_CONFIG1_TEN_COUNT_SHIFT  24
>> +#define                SENSOR_CONFIG1_TEMP_ENABLE      BIT(31)
>> +#define SENSOR_CONFIG2                         8
>> +#define                SENSOR_CONFIG2_THERMA_SHIFT     16
>> +#define                SENSOR_CONFIG2_THERMB_SHIFT     0
>> +
>> +#define SENSOR_PDIV                            0x1c0
>> +#define                SENSOR_PDIV_T124                0x8888
>> +#define SENSOR_HOTSPOT_OFF                     0x1c4
>> +#define                SENSOR_HOTSPOT_OFF_T124         0x00060600
>> +#define SENSOR_TEMP1                           0x1c8
>> +#define SENSOR_TEMP2                           0x1cc
>> +
>> +#define FUSE_TSENSOR8_CALIB                    0x180
>> +#define FUSE_SPARE_REALIGNMENT_REG_0           0x1fc
>> +
>> +#define NOMINAL_CALIB_FT_T124                  105
>> +#define NOMINAL_CALIB_CP_T124                  25
>> +
>> +struct tegra_tsensor_configuration {
>> +       u32 tall, tsample, tiddq_en, ten_count;
>> +       u32 pdiv, tsample_ate, pdiv_ate;
>> +};
>> +
>> +struct tegra_tsensor {
>> +       u32 base;
>> +       u32 calib_fuse_offset;
>> +       /* Correction values used to modify values read from calibration fuses */
>> +       s32 fuse_corr_alpha, fuse_corr_beta;
>> +};
>> +
>> +struct tegra_thermctl_zone {
>> +       void __iomem *temp_reg;
>> +       int temp_shift;
>> +};
>> +
>> +static const struct tegra_tsensor_configuration t124_tsensor_config = {
>> +       .tall = 16300,
>> +       .tsample = 120,
>> +       .tiddq_en = 1,
>> +       .ten_count = 1,
>> +       .pdiv = 8,
>> +       .tsample_ate = 481,
>> +       .pdiv_ate = 8
>> +};
>> +
>> +static struct tegra_tsensor t124_tsensors[] = {
>
> Shouldn't this one be const too?

Ah, missed this one. Thanks.

>
>> +       {
>> +               .base = 0xc0,
>> +               .calib_fuse_offset = 0x098,
>> +               .fuse_corr_alpha = 1135400,
>> +               .fuse_corr_beta = -6266900,
>> +       },
>> +       {
>> +               .base = 0xe0,
>> +               .calib_fuse_offset = 0x084,
>> +               .fuse_corr_alpha = 1122220,
>> +               .fuse_corr_beta = -5700700,
>> +       },
>> +       {
>> +               .base = 0x100,
>> +               .calib_fuse_offset = 0x088,
>> +               .fuse_corr_alpha = 1127000,
>> +               .fuse_corr_beta = -6768200,
>> +       },
>> +       {
>> +               .base = 0x120,
>> +               .calib_fuse_offset = 0x12c,
>> +               .fuse_corr_alpha = 1110900,
>> +               .fuse_corr_beta = -6232000,
>> +       },
>> +       {
>> +               .base = 0x140,
>> +               .calib_fuse_offset = 0x158,
>> +               .fuse_corr_alpha = 1122300,
>> +               .fuse_corr_beta = -5936400,
>> +       },
>> +       {
>> +               .base = 0x160,
>> +               .calib_fuse_offset = 0x15c,
>> +               .fuse_corr_alpha = 1145700,
>> +               .fuse_corr_beta = -7124600,
>> +       },
>> +       {
>> +               .base = 0x180,
>> +               .calib_fuse_offset = 0x154,
>> +               .fuse_corr_alpha = 1120100,
>> +               .fuse_corr_beta = -6000500,
>> +       },
>> +       {
>> +               .base = 0x1a0,
>> +               .calib_fuse_offset = 0x160,
>> +               .fuse_corr_alpha = 1106500,
>> +               .fuse_corr_beta = -6729300,
>> +       },
>> +};
>> +
>> +struct tegra_soctherm {
>> +       struct reset_control *reset;
>> +       struct clk *clock_tsensor;
>> +       struct clk *clock_soctherm;
>> +       void __iomem *regs;
>> +
>> +       struct thermal_zone_device *thermctl_tzs[4];
>
> the amount of thermal zones is const here. Is there any case in which
> the board would have a config that has more than 4 or less than 4 zones?

No. This number fixed in the IP block. SOCTHERM measures only 
SoC-internal sensors, so the number is be fixed per SoC generation. 
Future generations might change this number, but so can change many 
other things.

>
>> +};
>> +
>> +struct tsensor_shared_calibration {
>> +       u32 base_cp, base_ft;
>> +       u32 actual_temp_cp, actual_temp_ft;
>> +};
>> +
>> +static int calculate_shared_calibration(struct tsensor_shared_calibration *r)
>> +{
>> +       u32 val;
>> +       u32 shifted_cp, shifted_ft;
>> +       int err;
>> +
>> +       err = tegra_fuse_readl(FUSE_TSENSOR8_CALIB, &val);
>> +       if (err)
>> +               return err;
>> +       r->base_cp = val & 0x3ff;
>> +       r->base_ft = (val & (0x7ff << 10)) >> 10;
>
> Where these shifts and masks come from?

These aren't very well documented in anything I can find (typical for 
calibration data), but I suppose I can at least add some defines for the 
shifts and masks.

>
>> +
>> +       err = tegra_fuse_readl(FUSE_SPARE_REALIGNMENT_REG_0, &val);
>> +       if (err)
>> +               return err;
>> +       shifted_cp = sign_extend32(val, 5);
>> +       val = ((val & (0x1f << 21)) >> 21);
>
> ditto.

Same.

>
>> +       shifted_ft = sign_extend32(val, 4);
>> +
>> +       r->actual_temp_cp = 2 * NOMINAL_CALIB_CP_T124 + shifted_cp;
>> +       r->actual_temp_ft = 2 * NOMINAL_CALIB_FT_T124 + shifted_ft;
>> +
>> +       return 0;
>> +}
>> +
>> +static int calculate_tsensor_calibration(
>> +       struct tegra_tsensor *sensor,
>> +       struct tsensor_shared_calibration shared,
>> +       u32 *calib
>> +)
>> +{
>> +       u32 val;
>> +       s32 actual_tsensor_ft, actual_tsensor_cp;
>> +       s32 delta_sens, delta_temp;
>> +       s32 mult, div;
>> +       s16 therma, thermb;
>> +       int err;
>> +
>> +       err = tegra_fuse_readl(sensor->calib_fuse_offset, &val);
>> +       if (err)
>> +               return err;
>> +
>> +       actual_tsensor_cp = (shared.base_cp * 64) + sign_extend32(val, 12);
>> +       val = (val & (0x1fff << 13)) >> 13;
>
> ditto.

Same.

>
>> +       actual_tsensor_ft = (shared.base_ft * 32) + sign_extend32(val, 12);
>> +
>> +       delta_sens = actual_tsensor_ft - actual_tsensor_cp;
>> +       delta_temp = shared.actual_temp_ft - shared.actual_temp_cp;
>> +
>> +       mult = t124_tsensor_config.pdiv * t124_tsensor_config.tsample_ate;
>> +       div = t124_tsensor_config.tsample * t124_tsensor_config.pdiv_ate;
>> +
>> +       therma = div_s64((s64) delta_temp * (1LL << 13) * mult,
>
> ditto.

Same.

>
>> +               (s64) delta_sens * div);
>> +       thermb = div_s64(((s64) actual_tsensor_ft * shared.actual_temp_cp) -
>> +               ((s64) actual_tsensor_cp * shared.actual_temp_ft),
>> +               (s64) delta_sens);
>> +
>> +       therma = div_s64((s64) therma * sensor->fuse_corr_alpha,
>> +               (s64) 1000000LL);
>> +       thermb = div_s64((s64) thermb * sensor->fuse_corr_alpha +
>> +               sensor->fuse_corr_beta,
>> +               (s64) 1000000LL);
>> +
>> +       *calib = ((u16)(therma) << SENSOR_CONFIG2_THERMA_SHIFT) |
>> +               ((u16)thermb << SENSOR_CONFIG2_THERMB_SHIFT);
>> +
>> +       return 0;
>> +}
>> +
>> +static int enable_tsensor(struct tegra_soctherm *tegra,
>> +                         struct tegra_tsensor *sensor,
>> +                         struct tsensor_shared_calibration shared)
>> +{
>> +       void * __iomem base = tegra->regs + sensor->base;
>> +       unsigned int val;
>> +       u32 calib;
>> +       int err;
>> +
>> +       err = calculate_tsensor_calibration(sensor, shared, &calib);
>> +       if (err)
>> +               return err;
>> +
>> +       val = 0;
>> +       val |= t124_tsensor_config.tall << SENSOR_CONFIG0_TALL_SHIFT;
>> +       writel(val, base + SENSOR_CONFIG0);
>> +
>> +       val = 0;
>> +       val |= (t124_tsensor_config.tsample - 1) <<
>> +               SENSOR_CONFIG1_TSAMPLE_SHIFT;
>> +       val |= t124_tsensor_config.tiddq_en << SENSOR_CONFIG1_TIDDQ_EN_SHIFT;
>> +       val |= t124_tsensor_config.ten_count << SENSOR_CONFIG1_TEN_COUNT_SHIFT;
>> +       val |= SENSOR_CONFIG1_TEMP_ENABLE;
>> +       writel(val, base + SENSOR_CONFIG1);
>> +
>> +       writel(calib, base + SENSOR_CONFIG2);
>> +
>> +       return 0;
>> +}
>> +
>> +static inline long translate_temp(u32 val)
>> +{
>
> It would be kind to have a comment explaining the transformation.

I will add one. This function converts a 16-bit value (I guess it should 
take a u16) in what's called "soctherm temperature readback format" to 
millicelsius.

>
>> +       long t;
>> +
>> +       t = ((val & 0xff00) >> 8) * 1000;
>> +       if (val & 0x80)
>> +               t += 500;
>> +       if (val & 0x01)
>> +               t *= -1;
>> +
>> +       return t;
>> +}
>> +
>> +static int tegra_thermctl_get_temp(void *data, long *out_temp)
>> +{
>> +       struct tegra_thermctl_zone *zone = data;
>> +       u32 val;
>> +
>> +       val = (readl(zone->temp_reg) >> zone->temp_shift) & 0xffff;
>> +       *out_temp = translate_temp(val);
>
> Why the temp_shift is not part of the 'translate_temp' ?

temp_reg contains two separate readings in the temperature readback 
format, so I first shift to get the correct one, then convert it to 
millicelsius.

>
>> +
>> +       return 0;
>> +}
>> +
>> +static struct of_device_id tegra_soctherm_of_match[] = {
>> +       { .compatible = "nvidia,tegra124-soctherm" },
>> +       { },
>> +};
>> +MODULE_DEVICE_TABLE(of, tegra_soctherm_of_match);
>> +
>> +static int thermctl_temp_offsets[] = {
>> +       SENSOR_TEMP1, SENSOR_TEMP2, SENSOR_TEMP1, SENSOR_TEMP2
>> +};
>> +
>> +static int thermctl_temp_shifts[] = {
>> +       16, 16, 0, 0
>> +};
>
> I still missing why the two above cannot be part of
> tegra_tsensor_configuration or tegra_tsensor. Would you mind
> enlightining me?

You can think of the tsensors as a hardware-level implementation detail. 
There is no one-to-one mapping between the 4 thermctl zones and the 
tsensors (clearly, as there are 8 tsensors). These registers 
(SENSOR_TEMP1 and SENSOR_TEMP2) are related to the thermctl zones and 
not tsensors, so it wouldn't make sense to have them described in the 
tsensor data.

>...
> --
> Eduardo Bezerra Valentin
>

Thanks for reviewing!

Mikko
