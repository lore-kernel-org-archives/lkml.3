Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752957Ab3EMBgs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 May 2013 21:36:48 -0400
Received: from mail-ie0-f176.google.com ([209.85.223.176]:39552 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752052Ab3EMBgq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 May 2013 21:36:46 -0400
MIME-Version: 1.0
In-Reply-To: <518D1509.5070801@ti.com>
References: <1367931671-3906-1-git-send-email-amit.daniel@samsung.com>
	<1367931671-3906-11-git-send-email-amit.daniel@samsung.com>
	<518BB3D7.3010205@ti.com>
	<CADGdYn7Hm6EXvgK_ih_T8eE1oxzeiHimpZJ2LvQvCvC=ycmddg@mail.gmail.com>
	<518D1509.5070801@ti.com>
Date: Mon, 13 May 2013 07:06:46 +0530
X-Google-Sender-Auth: gD-LzhrwtjPNYwgUEEgwGXAHfwA
Message-ID: <CADGdYn44+Mip-hi0x-=E-NENt8vcy=UbBJUPe3AEV1--LV2YhA@mail.gmail.com>
Subject: Re: [PATCH V3 10/21] thermal: exynos: Fix to clear only the generated interrupts
From: amit daniel kachhap <amit.daniel@samsung.com>
To: Eduardo Valentin <eduardo.valentin@ti.com>
Cc: linux-pm@vger.kernel.org, Zhang Rui <rui.zhang@intel.com>,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kukjin Kim <kgene.kim@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 10, 2013 at 9:10 PM, Eduardo Valentin
<eduardo.valentin@ti.com> wrote:
> On 09-05-2013 22:22, amit daniel kachhap wrote:
>> Hi,
>>
>> On Thu, May 9, 2013 at 8:03 PM, Eduardo Valentin
>> <eduardo.valentin@ti.com> wrote:
>>> On 07-05-2013 09:01, Amit Daniel Kachhap wrote:
>>>> This patch uses the TMU status register to know the generated interrupts
>>>> and only clear them in the interrupt handler.
>>>>
>>>> Acked-by: Kukjin Kim <kgene.kim@samsung.com>
>>>> Signed-off-by: Amit Daniel Kachhap <amit.daniel@samsung.com>
>>>> ---
>>>>  drivers/thermal/samsung/exynos_tmu.c      |   10 ++++------
>>>>  drivers/thermal/samsung/exynos_tmu_data.c |    2 ++
>>>>  2 files changed, 6 insertions(+), 6 deletions(-)
>>>>
>>>> diff --git a/drivers/thermal/samsung/exynos_tmu.c b/drivers/thermal/samsung/exynos_tmu.c
>>>> index 97b87aa..082d5a2 100644
>>>> --- a/drivers/thermal/samsung/exynos_tmu.c
>>>> +++ b/drivers/thermal/samsung/exynos_tmu.c
>>>> @@ -325,17 +325,15 @@ static void exynos_tmu_work(struct work_struct *work)
>>>>                       struct exynos_tmu_data, irq_work);
>>>>       struct exynos_tmu_platform_data *pdata = data->pdata;
>>>>       struct exynos_tmu_registers *reg = pdata->registers;
>>>> +     unsigned int val_irq;
>>>>
>>>>       exynos_report_trigger();
>>>>       mutex_lock(&data->lock);
>>>>       clk_enable(data->clk);
>>>>
>>>> -     if (data->soc == SOC_ARCH_EXYNOS)
>>>> -             writel((reg->inten_rise_mask << reg->inten_rise_shift) |
>>>> -                     (reg->inten_fall_mask << reg->inten_fall_shift),
>>>> -                             data->base + reg->tmu_intclear);
>>>> -     else
>>>> -             writel(reg->inten_rise_mask, data->base + reg->tmu_intclear);
>>>> +     val_irq = readl(data->base + reg->tmu_intstat);
>>>> +     /* clear the interrupts */
>>>> +     writel(val_irq, data->base + reg->tmu_intclear);
>>>>
>>>
>>> hmmm.. Don t you need to act accordingly depending on what is in your
>>> int status?
>>
>> Earlier also it is done like this way. Basically core thermal layer
>> checks temp for each trip so even if I check for which threshold
>> interrupt is raised it is of no use. Anyway this is a TODO for me.
>>
>
> Please add  a /* TODO: */ entry then.
ok,

Thanks,
Amit Daniel
>
>> Thanks,
>> Amit Daniel
>>>
>>>>       clk_disable(data->clk);
>>>>       mutex_unlock(&data->lock);
>>>> diff --git a/drivers/thermal/samsung/exynos_tmu_data.c b/drivers/thermal/samsung/exynos_tmu_data.c
>>>> index 3a1ded1..7322597 100644
>>>> --- a/drivers/thermal/samsung/exynos_tmu_data.c
>>>> +++ b/drivers/thermal/samsung/exynos_tmu_data.c
>>>> @@ -45,6 +45,7 @@ static struct exynos_tmu_registers exynos4210_tmu_registers = {
>>>>       .inten_rise1_shift = EXYNOS_TMU_INTEN_RISE1_SHIFT,
>>>>       .inten_rise2_shift = EXYNOS_TMU_INTEN_RISE2_SHIFT,
>>>>       .inten_rise3_shift = EXYNOS_TMU_INTEN_RISE3_SHIFT,
>>>> +     .tmu_intstat = EXYNOS_TMU_REG_INTSTAT,
>>>>       .tmu_intclear = EXYNOS_TMU_REG_INTCLEAR,
>>>>  };
>>>>  struct exynos_tmu_platform_data const exynos4210_default_tmu_data = {
>>>> @@ -111,6 +112,7 @@ static struct exynos_tmu_registers exynos5250_tmu_registers = {
>>>>       .inten_rise2_shift = EXYNOS_TMU_INTEN_RISE2_SHIFT,
>>>>       .inten_rise3_shift = EXYNOS_TMU_INTEN_RISE3_SHIFT,
>>>>       .inten_fall0_shift = EXYNOS_TMU_INTEN_FALL0_SHIFT,
>>>> +     .tmu_intstat = EXYNOS_TMU_REG_INTSTAT,
>>>>       .tmu_intclear = EXYNOS_TMU_REG_INTCLEAR,
>>>>       .emul_con = EXYNOS_EMUL_CON,
>>>>       .emul_temp_shift = EXYNOS_EMUL_DATA_SHIFT,
>>>>
>>>
>>>
>>
>>
>
>
