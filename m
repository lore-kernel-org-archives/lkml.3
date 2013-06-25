Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752226Ab3FYJMe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 05:12:34 -0400
Received: from mail-ie0-f176.google.com ([209.85.223.176]:64888 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751461Ab3FYJMa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 05:12:30 -0400
MIME-Version: 1.0
In-Reply-To: <51C8A069.5010807@ti.com>
References: <1372071051-3167-1-git-send-email-amit.daniel@samsung.com>
	<1372071051-3167-26-git-send-email-amit.daniel@samsung.com>
	<51C8A069.5010807@ti.com>
Date: Tue, 25 Jun 2013 14:42:29 +0530
X-Google-Sender-Auth: sGOnT19PiAZO_foC4by9nSS8XXE
Message-ID: <CADGdYn6urNBzw55xkoXFYjwvvdg-Tqvh+Db=E8gDKY04ewGavA@mail.gmail.com>
Subject: Re: [PATCH V7 25/30] thermal: exynos: Add hardware mode thermal
 calibration support
From: amit daniel kachhap <amit.daniel@samsung.com>
To: Eduardo Valentin <eduardo.valentin@ti.com>
Cc: linux-pm@vger.kernel.org, Zhang Rui <rui.zhang@intel.com>,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kukjin Kim <kgene.kim@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
On Tue, Jun 25, 2013 at 1:09 AM, Eduardo Valentin
<eduardo.valentin@ti.com> wrote:
> On 24-06-2013 06:50, Amit Daniel Kachhap wrote:
>> This patch adds support for h/w mode calibration in the TMU controller.
>> Soc's like 5440 support this features. The h/w bits needed for calibration
>> setting are same as that of enum calibration_type.
>>
>> Acked-by: Jonghwa Lee <jonghwa3.lee@samsung.com>
>> Acked-by: Kukjin Kim <kgene.kim@samsung.com>
>> Signed-off-by: Amit Daniel Kachhap <amit.daniel@samsung.com>
>> ---
>>  drivers/thermal/samsung/exynos_tmu.c      |   15 +++++++++++++++
>>  drivers/thermal/samsung/exynos_tmu.h      |    6 ++++++
>>  drivers/thermal/samsung/exynos_tmu_data.c |    2 ++
>>  drivers/thermal/samsung/exynos_tmu_data.h |    2 ++
>>  4 files changed, 25 insertions(+), 0 deletions(-)
>>
>> diff --git a/drivers/thermal/samsung/exynos_tmu.c b/drivers/thermal/samsung/exynos_tmu.c
>> index 3fac0f9..34b999b 100644
>> --- a/drivers/thermal/samsung/exynos_tmu.c
>> +++ b/drivers/thermal/samsung/exynos_tmu.c
>> @@ -73,6 +73,9 @@ static int temp_to_code(struct exynos_tmu_data *data, u8 temp)
>>       struct exynos_tmu_platform_data *pdata = data->pdata;
>>       int temp_code;
>>
>> +     if (pdata->cal_mode == HW_MODE)
>> +             return temp;
>> +
>>       if (data->soc == SOC_ARCH_EXYNOS4210)
>>               /* temp should range between 25 and 125 */
>>               if (temp < 25 || temp > 125) {
>> @@ -107,6 +110,9 @@ static int code_to_temp(struct exynos_tmu_data *data, u8 temp_code)
>>       struct exynos_tmu_platform_data *pdata = data->pdata;
>>       int temp;
>>
>> +     if (pdata->cal_mode == HW_MODE)
>> +             return temp_code;
>> +
>>       if (data->soc == SOC_ARCH_EXYNOS4210)
>>               /* temp_code should range between 75 and 175 */
>>               if (temp_code < 75 || temp_code > 175) {
>> @@ -155,6 +161,9 @@ static int exynos_tmu_initialize(struct platform_device *pdev)
>>       if (TMU_SUPPORTS(pdata, TRIM_RELOAD))
>>               __raw_writel(1, data->base + reg->triminfo_ctrl);
>>
>> +     if (pdata->cal_mode == HW_MODE)
>> +             goto skip_calib_data;
>> +
>>       /* Save trimming info in order to perform calibration */
>>       if (data->soc == SOC_ARCH_EXYNOS5440) {
>>               /*
>> @@ -190,6 +199,7 @@ static int exynos_tmu_initialize(struct platform_device *pdev)
>>                       (pdata->efuse_value >> reg->triminfo_85_shift) &
>>                       EXYNOS_TMU_TEMP_MASK;
>>
>> +skip_calib_data:
>>       if (pdata->max_trigger_level > MAX_THRESHOLD_LEVS) {
>>               dev_err(&pdev->dev, "Invalid max trigger level\n");
>>               goto out;
>> @@ -320,6 +330,11 @@ static void exynos_tmu_control(struct platform_device *pdev, bool on)
>>               con |= (pdata->noise_cancel_mode << reg->therm_trip_mode_shift);
>>       }
>>
>> +     if (pdata->cal_mode == HW_MODE) {
>> +             con &= ~(reg->calib_mode_mask << reg->calib_mode_shift);
>> +             con |= pdata->cal_type << reg->calib_mode_shift;
>
> Same comment as in patch v6 still applies. The above statement is a bit
> worrying because you have not defined what values cal_type can assume.
>
> Here is how the type of cal_type is defined:
> enum calibration_type {
>         TYPE_ONE_POINT_TRIMMING,
>         TYPE_TWO_POINT_TRIMMING,
>         TYPE_NONE,
> };
>
> ...
>
>         enum calibration_type cal_type;
>
> If you got specific bit values for each corresponding type above, I
> would suggest defining them explicitly, before doing bitwise operations.
> This is to reduce bug introduction in the future.
>
>> +     }
>> +
Agreed it is error prone, will change to use properly.

Thanks,
Amit Daniel
>>       if (on) {
>>               con |= (1 << reg->core_en_shift);
>>               interrupt_en =
>> diff --git a/drivers/thermal/samsung/exynos_tmu.h b/drivers/thermal/samsung/exynos_tmu.h
>> index 25c48d4..60d863c 100644
>> --- a/drivers/thermal/samsung/exynos_tmu.h
>> +++ b/drivers/thermal/samsung/exynos_tmu.h
>> @@ -90,6 +90,10 @@ enum soc_type {
>>   * @buf_slope_sel_shift: shift bits of amplifier gain value in tmu_ctrl
>>       register.
>>   * @buf_slope_sel_mask: mask bits of amplifier gain value in tmu_ctrl register.
>> + * @calib_mode_shift: shift bits of calibration mode value in tmu_ctrl
>> +     register.
>> + * @calib_mode_mask: mask bits of calibration mode value in tmu_ctrl
>> +     register.
>>   * @therm_trip_tq_en_shift: shift bits of thermal trip enable by TQ pin in
>>       tmu_ctrl register.
>>   * @core_en_shift: shift bits of TMU core enable bit in tmu_ctrl register.
>> @@ -151,6 +155,8 @@ struct exynos_tmu_registers {
>>       u32     therm_trip_en_shift;
>>       u32     buf_slope_sel_shift;
>>       u32     buf_slope_sel_mask;
>> +     u32     calib_mode_shift;
>> +     u32     calib_mode_mask;
>>       u32     therm_trip_tq_en_shift;
>>       u32     core_en_shift;
>>
>> diff --git a/drivers/thermal/samsung/exynos_tmu_data.c b/drivers/thermal/samsung/exynos_tmu_data.c
>> index 5952915..9002499 100644
>> --- a/drivers/thermal/samsung/exynos_tmu_data.c
>> +++ b/drivers/thermal/samsung/exynos_tmu_data.c
>> @@ -189,6 +189,8 @@ static const struct exynos_tmu_registers exynos5440_tmu_registers = {
>>       .therm_trip_en_shift = EXYNOS_TMU_THERM_TRIP_EN_SHIFT,
>>       .buf_slope_sel_shift = EXYNOS_TMU_BUF_SLOPE_SEL_SHIFT,
>>       .buf_slope_sel_mask = EXYNOS_TMU_BUF_SLOPE_SEL_MASK,
>> +     .calib_mode_shift = EXYNOS_TMU_CALIB_MODE_SHIFT,
>> +     .calib_mode_mask = EXYNOS_TMU_CALIB_MODE_MASK,
>>       .core_en_shift = EXYNOS_TMU_CORE_EN_SHIFT,
>>       .tmu_status = EXYNOS5440_TMU_S0_7_STATUS,
>>       .tmu_cur_temp = EXYNOS5440_TMU_S0_7_TEMP,
>> diff --git a/drivers/thermal/samsung/exynos_tmu_data.h b/drivers/thermal/samsung/exynos_tmu_data.h
>> index 43ce5fb..dc7feb5 100644
>> --- a/drivers/thermal/samsung/exynos_tmu_data.h
>> +++ b/drivers/thermal/samsung/exynos_tmu_data.h
>> @@ -75,6 +75,8 @@
>>  #define EXYNOS_TMU_TRIP_MODE_SHIFT   13
>>  #define EXYNOS_TMU_TRIP_MODE_MASK    0x7
>>  #define EXYNOS_TMU_THERM_TRIP_EN_SHIFT       12
>> +#define EXYNOS_TMU_CALIB_MODE_SHIFT  4
>> +#define EXYNOS_TMU_CALIB_MODE_MASK   0x3
>>
>>  #define EXYNOS_TMU_INTEN_RISE0_SHIFT 0
>>  #define EXYNOS_TMU_INTEN_RISE1_SHIFT 4
>>
>
>
> --
> You have got to be excited about what you are doing. (L. Lamport)
>
> Eduardo Valentin
>
