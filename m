Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754283Ab3EJC2t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 22:28:49 -0400
Received: from mail-ie0-f179.google.com ([209.85.223.179]:60301 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752882Ab3EJC2r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 22:28:47 -0400
MIME-Version: 1.0
In-Reply-To: <518BB63E.4050006@ti.com>
References: <1367931671-3906-1-git-send-email-amit.daniel@samsung.com>
	<1367931671-3906-21-git-send-email-amit.daniel@samsung.com>
	<518BB63E.4050006@ti.com>
Date: Fri, 10 May 2013 07:58:47 +0530
X-Google-Sender-Auth: zMOuCdGHv5BIQpkeGWdDvN9pDyI
Message-ID: <CADGdYn7GJKi2BDi4RqMeoEEpb2OXqz8mO8ji=YhAdm6nKr6D2A@mail.gmail.com>
Subject: Re: [PATCH V3 20/21] thermal: exynos: Support for TMU regulator
 defined at device tree
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

On Thu, May 9, 2013 at 8:14 PM, Eduardo Valentin
<eduardo.valentin@ti.com> wrote:
> On 07-05-2013 09:01, Amit Daniel Kachhap wrote:
>> TMU probe function now checks for a device tree defined regulator.
>> For compatibility reasons it is allowed to probe driver even without
>> this regulator defined.
>>
>> Signed-off-by: Lukasz Majewski <l.majewski@samsung.com>
>> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
>> Signed-off-by: Amit Daniel Kachhap <amit.daniel@samsung.com>
>> ---
>>  .../devicetree/bindings/thermal/exynos-thermal.txt |    4 ++++
>>  drivers/thermal/samsung/exynos_tmu.c               |   19 +++++++++++++++++++
>>  2 files changed, 23 insertions(+), 0 deletions(-)
>>
>> diff --git a/Documentation/devicetree/bindings/thermal/exynos-thermal.txt b/Documentation/devicetree/bindings/thermal/exynos-thermal.txt
>> index 970eeba..ff62f7a 100644
>> --- a/Documentation/devicetree/bindings/thermal/exynos-thermal.txt
>> +++ b/Documentation/devicetree/bindings/thermal/exynos-thermal.txt
>> @@ -14,6 +14,9 @@
>>  - interrupts : Should contain interrupt for thermal system
>>  - clocks : The main clock for TMU device
>>  - clock-names : Thermal system clock name
>> +- vtmu-supply: This entry is optional and provides the regulator node supplying
>> +             voltage to TMU. If needed this entry can be placed inside
>> +             board/platform specific dts file.
>>
>>  Example 1):
>>
>> @@ -25,6 +28,7 @@ Example 1):
>>               clocks = <&clock 383>;
>>               clock-names = "tmu_apbif";
>>               status = "disabled";
>> +             vtmu-supply = <&tmu_regulator_node>;
>>       };
>>
>>  Example 2):
>> diff --git a/drivers/thermal/samsung/exynos_tmu.c b/drivers/thermal/samsung/exynos_tmu.c
>> index 72446c9..b7c609a 100644
>> --- a/drivers/thermal/samsung/exynos_tmu.c
>> +++ b/drivers/thermal/samsung/exynos_tmu.c
>> @@ -32,6 +32,7 @@
>>  #include <linux/of_address.h>
>>  #include <linux/of_irq.h>
>>  #include <linux/platform_device.h>
>> +#include <linux/regulator/consumer.h>
>>  #include <linux/slab.h>
>>  #include <linux/workqueue.h>
>>  #include "exynos_thermal_common.h"
>> @@ -52,6 +53,7 @@
>>   * @clk: pointer to the clock structure.
>>   * @temp_error1: fused value of the first point trim.
>>   * @temp_error2: fused value of the second point trim.
>> + * @regulator: pointer to the TMU regulator structure.
>>   * @reg_conf: pointer to structure to register with core thermal.
>>   */
>>  struct exynos_tmu_data {
>> @@ -65,6 +67,7 @@ struct exynos_tmu_data {
>>       struct mutex lock;
>>       struct clk *clk;
>>       u8 temp_error1, temp_error2;
>> +     struct regulator *regulator;
>>       struct thermal_sensor_conf *reg_conf;
>>  };
>>
>> @@ -501,10 +504,23 @@ static int exynos_map_dt_data(struct platform_device *pdev)
>>       struct exynos_tmu_data *data = platform_get_drvdata(pdev);
>>       struct exynos_tmu_platform_data *pdata = data->pdata;
>>       struct resource res;
>> +     int ret;
>>
>>       if (!data)
>>               return -ENODEV;
>>
>> +     /* Try enabling the regulator if found */
>> +     data->regulator = devm_regulator_get(&pdev->dev, "vtmu");
>> +     if (!IS_ERR(data->regulator)) {
>> +             ret = regulator_enable(data->regulator);
>> +             if (ret) {
>> +                     dev_err(&pdev->dev, "failed to enable vtmu\n");
>> +                     return ret;
>> +             }
>> +     } else {
>> +             dev_info(&pdev->dev, "Regulator node (vtmu) not found\n");
>
> Now that you have a bitfield for your features, shouldnt this become a
> check? If the SoC requires the regulator, then it has to return a valid
> regulator (regulator_get). Meaning, if your SoC version requires this
> feature and the regulator_get returns an error, you must treat as an
> error an not continue gracefuly.

Earlier I also thought of using bit feature for this but then the
regulator source usually depends upon the board design so each soc may
have several boards. So regulator information is not part of SOC data.
Since this information is there is in DT only so I left this part for
the DT to handle.

Thanks,
Amit Daniel
>
>> +     }
>> +
>>       data->id = of_alias_get_id(pdev->dev.of_node, "tmuctrl");
>>       if (data->id < 0)
>>               data->id = 0;
>> @@ -669,6 +685,9 @@ static int exynos_tmu_remove(struct platform_device *pdev)
>>
>>       clk_unprepare(data->clk);
>>
>> +     if (!IS_ERR(data->regulator))
>> +             regulator_disable(data->regulator);
>> +
>>       platform_set_drvdata(pdev, NULL);
>>
>>       return 0;
>>
>
>
