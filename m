Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752055AbaBGJdo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 04:33:44 -0500
Received: from mail-pb0-f53.google.com ([209.85.160.53]:33362 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751771AbaBGJdj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 04:33:39 -0500
MIME-Version: 1.0
In-Reply-To: <1388642820.3739.80.camel@rzhang1-mobl4>
References: <1383828154-428-1-git-send-email-ch.naveen@samsung.com> <1388642820.3739.80.camel@rzhang1-mobl4>
From: Naveen Krishna Ch <naveenkrishna.ch@gmail.com>
Date: Fri, 7 Feb 2014 15:03:18 +0530
Message-ID: <CAHfPSqCftzo8ud=K9Lv4Y_q9+wW+23ZPnbTxXpwsBWOXHXLucg@mail.gmail.com>
Subject: Re: [PATCH] thermal: exynos: handle gate clock for misplaced TRIMINFO register
To: Zhang Rui <rui.zhang@intel.com>
Cc: Naveen Krishna Chatradhi <ch.naveen@samsung.com>, linux-pm@vger.kernel.org,
        eduardo.valentin@ti.com,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        linux-kernel@vger.kernel.org, amit.daniel@samsung.com,
        Kukjin Kim <kgene.kim@samsung.com>, devicetree@vger.kernel.org,
        b.zolnierkie@samsung.com, cpgs@samsung.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello All,

On 2 January 2014 11:37, Zhang Rui <rui.zhang@intel.com> wrote:
> On Thu, 2013-11-07 at 18:12 +0530, Naveen Krishna Chatradhi wrote:
>> On Exynos5420 the TMU(4) for GPU has a seperate clock enable bit from
>> the other TMU channels(0 ~ 3). Hence, accessing TRIMINFO for base_second
>> should be acompanied by enabling the respective clock.
>>
>> This patch which allow for a "clk_sec" clock to be specified in the
>> device-tree which will be ungated when accessing the TRIMINFO register.
>>
>> Signed-off-by: Andrew Bresticker <abrestic@chromium.org>
>> Signed-off-by: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
>
> Eduardo,
>
> what do you think of this patch?
>
> thanks,
> rui
>> ---
>>  drivers/thermal/samsung/exynos_tmu.c |   24 +++++++++++++++++++++++-
>>  1 file changed, 23 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/thermal/samsung/exynos_tmu.c b/drivers/thermal/samsung/exynos_tmu.c
>> index b54825a..33edd1a 100644
>> --- a/drivers/thermal/samsung/exynos_tmu.c
>> +++ b/drivers/thermal/samsung/exynos_tmu.c
>> @@ -47,6 +47,7 @@
>>   * @irq_work: pointer to the irq work structure.
>>   * @lock: lock to implement synchronization.
>>   * @clk: pointer to the clock structure.
>> + * @clk_sec: pointer to the clock structure for accessing the base_second.
>>   * @temp_error1: fused value of the first point trim.
>>   * @temp_error2: fused value of the second point trim.
>>   * @regulator: pointer to the TMU regulator structure.
>> @@ -61,7 +62,7 @@ struct exynos_tmu_data {
>>       enum soc_type soc;
>>       struct work_struct irq_work;
>>       struct mutex lock;
>> -     struct clk *clk;
>> +     struct clk *clk, *clk_sec;
>>       u8 temp_error1, temp_error2;
>>       struct regulator *regulator;
>>       struct thermal_sensor_conf *reg_conf;
>> @@ -152,6 +153,8 @@ static int exynos_tmu_initialize(struct platform_device *pdev)
>>
>>       mutex_lock(&data->lock);
>>       clk_enable(data->clk);
>> +     if (!IS_ERR(data->clk_sec))
>> +             clk_enable(data->clk_sec);
>>
>>       if (TMU_SUPPORTS(pdata, READY_STATUS)) {
>>               status = readb(data->base + reg->tmu_status);
>> @@ -306,6 +309,8 @@ skip_calib_data:
>>  out:
>>       clk_disable(data->clk);
>>       mutex_unlock(&data->lock);
>> +     if (!IS_ERR(data->clk_sec))
>> +             clk_disable(data->clk_sec);
>>
>>       return ret;
>>  }
>> @@ -457,12 +462,16 @@ static void exynos_tmu_work(struct work_struct *work)
>>       const struct exynos_tmu_registers *reg = pdata->registers;
>>       unsigned int val_irq, val_type;
>>
>> +     if (!IS_ERR(data->clk_sec))
>> +             clk_enable(data->clk_sec);
>>       /* Find which sensor generated this interrupt */
>>       if (reg->tmu_irqstatus) {
>>               val_type = readl(data->base_second + reg->tmu_irqstatus);
>>               if (!((val_type >> data->id) & 0x1))
>>                       goto out;
>>       }
>> +     if (!IS_ERR(data->clk_sec))
>> +             clk_disable(data->clk_sec);
>>
>>       exynos_report_trigger(data->reg_conf);
>>       mutex_lock(&data->lock);
>> @@ -641,6 +650,15 @@ static int exynos_tmu_probe(struct platform_device *pdev)
>>       if (ret)
>>               return ret;
>>
>> +     data->clk_sec = devm_clk_get(&pdev->dev, "tmu_apbif_sec");
>> +     if (!IS_ERR(data->clk_sec)) {
>> +             ret = clk_prepare(data->clk_sec);
>> +             if (ret) {
>> +                     dev_err(&pdev->dev, "Failed to get clock\n");
>> +                     return  PTR_ERR(data->clk_sec);
>> +             }
>> +     }
>> +
>>       if (pdata->type == SOC_ARCH_EXYNOS4210 ||
>>           pdata->type == SOC_ARCH_EXYNOS4412 ||
>>           pdata->type == SOC_ARCH_EXYNOS5250 ||
>> @@ -713,6 +731,8 @@ static int exynos_tmu_probe(struct platform_device *pdev)
>>       return 0;
>>  err_clk:
>>       clk_unprepare(data->clk);
>> +     if (!IS_ERR(data->clk_sec))
>> +             clk_unprepare(data->clk_sec);
>>       return ret;
>>  }
>>
>> @@ -725,6 +745,8 @@ static int exynos_tmu_remove(struct platform_device *pdev)
>>       exynos_unregister_thermal(data->reg_conf);
>>
>>       clk_unprepare(data->clk);
>> +     if (!IS_ERR(data->clk_sec))
>> +             clk_unprepare(data->clk_sec);
>>
>>       if (!IS_ERR(data->regulator))
>>               regulator_disable(data->regulator);
>
>
Ping.



-- 
Shine bright,
(: Nav :)
