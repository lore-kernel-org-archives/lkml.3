Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423237Ab3FUPRd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 11:17:33 -0400
Received: from mail-ie0-f178.google.com ([209.85.223.178]:57999 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423118Ab3FUPRb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 11:17:31 -0400
MIME-Version: 1.0
In-Reply-To: <51C263BB.6020700@ti.com>
References: <1371451599-31035-1-git-send-email-amit.daniel@samsung.com>
	<1371451599-31035-24-git-send-email-amit.daniel@samsung.com>
	<51C263BB.6020700@ti.com>
Date: Fri, 21 Jun 2013 20:47:30 +0530
X-Google-Sender-Auth: V84EYLMxqFmjlYesxEtYD4aPF-Q
Message-ID: <CADGdYn70ganiAKv7c_P4aHPVOYGt3MwNNgE+UOGHifTLK_YrnA@mail.gmail.com>
Subject: Re: [PATCH V6 23/30] thermal: exynos: Add driver support for
 exynos5440 TMU sensor
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

On Thu, Jun 20, 2013 at 7:36 AM, Eduardo Valentin
<eduardo.valentin@ti.com> wrote:
> On 17-06-2013 02:46, Amit Daniel Kachhap wrote:
>> This patch modifies TMU controller to add changes needed to work with
>> exynos5440 platform. This sensor registers 3 instance of the tmu controller
>> with the thermal zone and hence reports 3 temperature output. This controller
>> supports upto five trip points. For critical threshold the driver uses the
>> core driver thermal framework for shutdown.
>>
>> Acked-by: Jonghwa Lee <jonghwa3.lee@samsung.com>
>> Acked-by: Kukjin Kim <kgene.kim@samsung.com>
>> Signed-off-by: Jungseok Lee <jays.lee@samsung.com>
>> Signed-off-by: Amit Daniel Kachhap <amit.daniel@samsung.com>
>> ---
>>  .../devicetree/bindings/thermal/exynos-thermal.txt |   24 ++++++++-
>>  drivers/thermal/samsung/exynos_thermal_common.h    |    2 +-
>>  drivers/thermal/samsung/exynos_tmu.c               |   54 +++++++++++++++++---
>>  drivers/thermal/samsung/exynos_tmu.h               |    6 ++
>>  drivers/thermal/samsung/exynos_tmu_data.h          |   36 +++++++++++++
>>  5 files changed, 112 insertions(+), 10 deletions(-)
>>
>> diff --git a/Documentation/devicetree/bindings/thermal/exynos-thermal.txt b/Documentation/devicetree/bindings/thermal/exynos-thermal.txt
>> index 0ea33f7..e6386ea 100644
>> --- a/Documentation/devicetree/bindings/thermal/exynos-thermal.txt
>> +++ b/Documentation/devicetree/bindings/thermal/exynos-thermal.txt
>> @@ -6,6 +6,7 @@
>>              "samsung,exynos4412-tmu"
>>              "samsung,exynos4210-tmu"
>>              "samsung,exynos5250-tmu"
>> +            "samsung,exynos5440-tmu"
>>  - interrupt-parent : The phandle for the interrupt controller
>>  - reg : Address range of the thermal registers. For soc's which has multiple
>>       instances of TMU and some registers are shared across all TMU's like
>> @@ -16,7 +17,7 @@
>>  - clocks : The main clock for TMU device
>>  - clock-names : Thermal system clock name
>>
>> -Example:
>> +Example 1):
>>
>>       tmu@100C0000 {
>>               compatible = "samsung,exynos4412-tmu";
>> @@ -27,3 +28,24 @@ Example:
>>               clock-names = "tmu_apbif";
>>               status = "disabled";
>>       };
>> +
>> +Example 2):
>> +
>> +     tmuctrl_0: tmuctrl@160118 {
>> +             compatible = "samsung,exynos5440-tmu";
>> +             reg = <0x160118 0x230>, <0x160368 0x10>;
>> +             interrupts = <0 58 0>;
>> +             clocks = <&clock 21>;
>> +             clock-names = "tmu_apbif";
>> +     };
>> +
>> +Note: For multi-instance tmu each instance should have an alias correctly
>> +numbered in "aliases" node.
>> +
>> +Example:
>> +
>> +aliases {
>> +     tmuctrl0 = &tmuctrl_0;
>> +     tmuctrl1 = &tmuctrl_1;
>> +     tmuctrl2 = &tmuctrl_2;
>> +};
>> diff --git a/drivers/thermal/samsung/exynos_thermal_common.h b/drivers/thermal/samsung/exynos_thermal_common.h
>> index 0c189d6..7d7c29a 100644
>> --- a/drivers/thermal/samsung/exynos_thermal_common.h
>> +++ b/drivers/thermal/samsung/exynos_thermal_common.h
>> @@ -27,7 +27,7 @@
>>  #define SENSOR_NAME_LEN      16
>>  #define MAX_TRIP_COUNT       8
>>  #define MAX_COOLING_DEVICE 4
>> -#define MAX_THRESHOLD_LEVS 4
>> +#define MAX_THRESHOLD_LEVS 5
>>
>>  #define ACTIVE_INTERVAL 500
>>  #define IDLE_INTERVAL 10000
>> diff --git a/drivers/thermal/samsung/exynos_tmu.c b/drivers/thermal/samsung/exynos_tmu.c
>> index 150a869..db4035d 100644
>> --- a/drivers/thermal/samsung/exynos_tmu.c
>> +++ b/drivers/thermal/samsung/exynos_tmu.c
>> @@ -156,7 +156,26 @@ static int exynos_tmu_initialize(struct platform_device *pdev)
>>               __raw_writel(1, data->base + reg->triminfo_ctrl);
>>
>>       /* Save trimming info in order to perform calibration */
>> -     trim_info = readl(data->base + reg->triminfo_data);
>> +     if (data->soc == SOC_ARCH_EXYNOS5440) {
>
> should this become some bit at your pdata->features? TMU_SUPPORTS(pdata,
> TRIMINFO) for instance?
Initially I also thought of getting rid of SOC checks completely  but
they have been retained in some rare cases.
Here this a limitation in the h/w and very specific to exynos5440. So
not sure if this can be added as a feature.
>
>> +             /*
>> +              * For exynos5440 soc triminfo value is swapped between TMU0 and
>> +              * TMU2, so the below logic is needed.
>> +              */
>> +             switch (data->id) {
>> +             case 0:
>> +                     trim_info = readl(data->base +
>> +                     EXYNOS5440_EFUSE_SWAP_OFFSET + reg->triminfo_data);
>> +                     break;
>> +             case 1:
>> +                     trim_info = readl(data->base + reg->triminfo_data);
>> +                     break;
>> +             case 2:
>> +                     trim_info = readl(data->base -
>> +                     EXYNOS5440_EFUSE_SWAP_OFFSET + reg->triminfo_data);
>> +             }
>> +     } else {
>> +             trim_info = readl(data->base + reg->triminfo_data);
>> +     }
>>       data->temp_error1 = trim_info & EXYNOS_TMU_TEMP_MASK;
>>       data->temp_error2 = ((trim_info >> reg->triminfo_85_shift) &
>>                               EXYNOS_TMU_TEMP_MASK);
>> @@ -201,7 +220,8 @@ static int exynos_tmu_initialize(struct platform_device *pdev)
>>                       reg->threshold_th0 + i * sizeof(reg->threshold_th0));
>>
>>               writel(reg->inten_rise_mask, data->base + reg->tmu_intclear);
>> -     } else if (data->soc == SOC_ARCH_EXYNOS) {
>> +     } else if (data->soc == SOC_ARCH_EXYNOS ||
>> +                     data->soc == SOC_ARCH_EXYNOS5440) {
>>               /* Write temperature code for rising and falling threshold */
>>               for (i = 0;
>>               i < trigger_levs && i < EXYNOS_MAX_TRIGGER_PER_REG; i++) {
>> @@ -241,14 +261,24 @@ static int exynos_tmu_initialize(struct platform_device *pdev)
>>                               ret = threshold_code;
>>                               goto out;
>>                       }
>> -                     rising_threshold |= threshold_code << 8 * i;
>> -                     writel(rising_threshold,
>> -                             data->base + reg->threshold_th0);
>> +                     if (data->soc == SOC_ARCH_EXYNOS) {
>> +                             rising_threshold |= threshold_code << 8 * i;
>> +                             writel(rising_threshold,
>> +                                     data->base + reg->threshold_th0);
>> +                     } else if (data->soc == SOC_ARCH_EXYNOS5440) {
>
> Can these ifs be translated to some TMU_SUPPORTS()?
>
> Just wondering if it is possible to get rid of data->soc flags and use
> only features or represent the shifts as fields inside your pdata.
Here soc check can be removed. Will repost with this change.
>
>> +                             rising_threshold =
>> +                             threshold_code << reg->threshold_th3_l0_shift;
>> +                             writel(rising_threshold,
>> +                                     data->base + reg->threshold_th2);
>> +                     }
>>                       con = readl(data->base + reg->tmu_ctrl);
>>                       con |= (1 << reg->therm_trip_en_shift);
>>                       writel(con, data->base + reg->tmu_ctrl);
>>               }
>>       }
>> +     /*Clear the PMIN in the common TMU register*/
>> +     if (reg->tmu_pmin && !data->id)
>> +             writel(0, data->base_common + reg->tmu_pmin);
>
> What happens to other TMU instances when one of them performs this
> operation? does it need to serialized?
This is one time setting for all the instances and currently I have
done it for first TMU with aliad ID as 0. This register belongs to the
common set.
>
>>  out:
>>       clk_disable(data->clk);
>>       mutex_unlock(&data->lock);
>> @@ -377,7 +407,14 @@ static void exynos_tmu_work(struct work_struct *work)
>>                       struct exynos_tmu_data, irq_work);
>>       struct exynos_tmu_platform_data *pdata = data->pdata;
>>       const struct exynos_tmu_registers *reg = pdata->registers;
>> -     unsigned int val_irq;
>> +     unsigned int val_irq, val_type;
>> +
>> +     /* Find which sensor generated this interrupt */
>> +     if (reg->tmu_irqstatus) {
>> +             val_type = readl(data->base_common + reg->tmu_irqstatus);
>> +             if (!((val_type >> data->id) & 0x1))
>> +                     goto out;
>> +     }
>>
>>       exynos_report_trigger(data->reg_conf);
>>       mutex_lock(&data->lock);
>> @@ -390,7 +427,7 @@ static void exynos_tmu_work(struct work_struct *work)
>>
>>       clk_disable(data->clk);
>>       mutex_unlock(&data->lock);
>> -
>> +out:
>>       enable_irq(data->irq);
>>  }
>>
>> @@ -544,7 +581,8 @@ static int exynos_tmu_probe(struct platform_device *pdev)
>>               return ret;
>>
>>       if (pdata->type == SOC_ARCH_EXYNOS ||
>> -                             pdata->type == SOC_ARCH_EXYNOS4210)
>> +             pdata->type == SOC_ARCH_EXYNOS4210 ||
>> +                             pdata->type == SOC_ARCH_EXYNOS5440)
>>               data->soc = pdata->type;
>>       else {
>>               ret = -EINVAL;
>> diff --git a/drivers/thermal/samsung/exynos_tmu.h b/drivers/thermal/samsung/exynos_tmu.h
>> index 6f55673..73aaed7 100644
>> --- a/drivers/thermal/samsung/exynos_tmu.h
>> +++ b/drivers/thermal/samsung/exynos_tmu.h
>> @@ -38,6 +38,7 @@ enum calibration_mode {
>>  enum soc_type {
>>       SOC_ARCH_EXYNOS4210 = 1,
>>       SOC_ARCH_EXYNOS,
>> +     SOC_ARCH_EXYNOS5440,
>>  };
>>
>>  /**
>> @@ -129,6 +130,8 @@ enum soc_type {
>>   * @emul_temp_shift: shift bits of emulation temperature.
>>   * @emul_time_shift: shift bits of emulation time.
>>   * @emul_time_mask: mask bits of emulation time.
>> + * @tmu_irqstatus: register to find which TMU generated interrupts.
>> + * @tmu_pmin: register to get/set the Pmin value.
>>   */
>>  struct exynos_tmu_registers {
>>       u32     triminfo_data;
>> @@ -196,6 +199,9 @@ struct exynos_tmu_registers {
>>       u32     emul_temp_shift;
>>       u32     emul_time_shift;
>>       u32     emul_time_mask;
>> +
>> +     u32     tmu_irqstatus;
>> +     u32     tmu_pmin;
>>  };
>>
>>  /**
>> diff --git a/drivers/thermal/samsung/exynos_tmu_data.h b/drivers/thermal/samsung/exynos_tmu_data.h
>> index 139dbbb..ad263e9 100644
>> --- a/drivers/thermal/samsung/exynos_tmu_data.h
>> +++ b/drivers/thermal/samsung/exynos_tmu_data.h
>> @@ -93,6 +93,42 @@
>>
>>  #define EXYNOS_MAX_TRIGGER_PER_REG   4
>>
>> +/*exynos5440 specific registers*/
>> +#define EXYNOS5440_TMU_S0_7_TRIM             0x000
>> +#define EXYNOS5440_TMU_S0_7_CTRL             0x020
>> +#define EXYNOS5440_TMU_S0_7_DEBUG            0x040
>> +#define EXYNOS5440_TMU_S0_7_STATUS           0x060
>> +#define EXYNOS5440_TMU_S0_7_TEMP             0x0f0
>> +#define EXYNOS5440_TMU_S0_7_TH0                      0x110
>> +#define EXYNOS5440_TMU_S0_7_TH1                      0x130
>> +#define EXYNOS5440_TMU_S0_7_TH2                      0x150
>> +#define EXYNOS5440_TMU_S0_7_EVTEN            0x1F0
>> +#define EXYNOS5440_TMU_S0_7_IRQEN            0x210
>> +#define EXYNOS5440_TMU_S0_7_IRQ                      0x230
>> +/* exynos5440 common registers */
>> +#define EXYNOS5440_TMU_IRQ_STATUS            0x000
>> +#define EXYNOS5440_TMU_PMIN                  0x004
>> +#define EXYNOS5440_TMU_TEMP                  0x008
>> +
>> +#define EXYNOS5440_TMU_RISE_INT_MASK         0xf
>> +#define EXYNOS5440_TMU_RISE_INT_SHIFT                0
>> +#define EXYNOS5440_TMU_FALL_INT_MASK         0xf
>> +#define EXYNOS5440_TMU_FALL_INT_SHIFT                4
>> +#define EXYNOS5440_TMU_INTEN_RISE0_SHIFT     0
>> +#define EXYNOS5440_TMU_INTEN_RISE1_SHIFT     1
>> +#define EXYNOS5440_TMU_INTEN_RISE2_SHIFT     2
>> +#define EXYNOS5440_TMU_INTEN_RISE3_SHIFT     3
>> +#define EXYNOS5440_TMU_INTEN_FALL0_SHIFT     4
>> +#define EXYNOS5440_TMU_INTEN_FALL1_SHIFT     5
>> +#define EXYNOS5440_TMU_INTEN_FALL2_SHIFT     6
>> +#define EXYNOS5440_TMU_INTEN_FALL3_SHIFT     7
>> +#define EXYNOS5440_TMU_TH_RISE0_SHIFT                0
>> +#define EXYNOS5440_TMU_TH_RISE1_SHIFT                8
>> +#define EXYNOS5440_TMU_TH_RISE2_SHIFT                16
>> +#define EXYNOS5440_TMU_TH_RISE3_SHIFT                24
>> +#define EXYNOS5440_TMU_TH_RISE4_SHIFT                24
>> +#define EXYNOS5440_EFUSE_SWAP_OFFSET         8
>> +
>>  #if defined(CONFIG_CPU_EXYNOS4210)
>>  extern struct exynos_tmu_init_data const exynos4210_default_tmu_data;
>>  #define EXYNOS4210_TMU_DRV_DATA (&exynos4210_default_tmu_data)
>>
>
>
> --
> You have got to be excited about what you are doing. (L. Lamport)
>
> Eduardo Valentin
>
