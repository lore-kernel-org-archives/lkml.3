Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751456AbaDZEgs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2014 00:36:48 -0400
Received: from mail-we0-f177.google.com ([74.125.82.177]:44857 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750718AbaDZEgq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2014 00:36:46 -0400
MIME-Version: 1.0
In-Reply-To: <535AE46F.5080000@gmail.com>
References: <1396425058-4012-1-git-send-email-pankaj.dubey@samsung.com>
 <1398429166-5539-1-git-send-email-pankaj.dubey@samsung.com>
 <1398429166-5539-11-git-send-email-pankaj.dubey@samsung.com> <535AE46F.5080000@gmail.com>
From: Pankaj Dubey <pankaj.dubey@samsung.com>
Date: Sat, 26 Apr 2014 13:36:24 +0900
X-Google-Sender-Auth: w1ATHw9qhNI-TUnpVCwC6-C-nJE
Message-ID: <CAGcde9HCphRSr0eN=Wc+aLKpPTaEKfn5JQVsuZ73uBH_5Qx4DA@mail.gmail.com>
Subject: Re: [PATCH v2 10/10] ARM: EXYNOS: Add device tree based
 initialization support for PMU.
To: Tomasz Figa <tomasz.figa@gmail.com>
Cc: linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        linux-kernel@vger.kernel.org,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Kukjin Kim <kgene.kim@samsung.com>, linux@arm.linux.org.uk,
        Tomasz Figa <t.figa@samsung.com>, chow.kim@samsung.com,
        Young-Gun Jang <yg1004.jang@samsung.com>, vikas.sajjan@samsung.com,
        s.nawrocki@samsung.com, b.zolnierkie@samsung.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

HI Tomasz,

Thanks for review.

On Sat, Apr 26, 2014 at 7:40 AM, Tomasz Figa <tomasz.figa@gmail.com> wrote:
> Hi,
>
>
> On 25.04.2014 14:32, Pankaj Dubey wrote:
>>
>> This patch adds device tree based initialization for PMU and modifies
>> PMU initialization implementation in following way:
>>
>> 1: Let's initialize PMU based on device tree compatibility string.
>> 2: Obtain PMU regmap handle using "syscon_early_regmap_lookup_by_phandle"
>> so that we can reduce dependency over machine header files.
>> 3: Separate each SoC's PMU initialization function and bind this
>> initialization
>> function with PMU compatibility string.
>> 4 : It also removes uses of soc_is_exynosXXXX() thus making PMU
>> implementation
>> independent of "plat/cpu.h".
>>
>> Signed-off-by: Pankaj Dubey <pankaj.dubey@samsung.com>
>> Signed-off-by: Young-Gun Jang <yg1004.jang@samsung.com>
>> ---
>>   arch/arm/mach-exynos/pmu.c |  182
>> +++++++++++++++++++++++++++++++++-----------
>>   1 file changed, 138 insertions(+), 44 deletions(-)
>>
>> diff --git a/arch/arm/mach-exynos/pmu.c b/arch/arm/mach-exynos/pmu.c
>> index 67116a5..abcf753 100644
>> --- a/arch/arm/mach-exynos/pmu.c
>> +++ b/arch/arm/mach-exynos/pmu.c
>> @@ -9,17 +9,31 @@
>>    * published by the Free Software Foundation.
>>    */
>>
>> -#include <linux/io.h>
>>   #include <linux/kernel.h>
>>   #include <linux/regmap.h>
>> -
>> -#include <plat/cpu.h>
>> +#include <linux/of.h>
>> +#include <linux/platform_device.h>
>> +#include <linux/slab.h>
>> +#include <linux/mfd/syscon.h>
>>
>>   #include "common.h"
>>   #include "regs-pmu.h"
>>
>> +enum exynos_pmu_id {
>> +       PMU_EXYNOS4210,
>> +       PMU_EXYNOS4X12,
>> +       PMU_EXYNOS4412,
>> +       PMU_EXYNOS5250,
>> +};
>> +
>> +struct exynos_pmu_data {
>> +       enum exynos_pmu_id      pmu_id;
>> +       struct regmap           *pmu_regmap;
>
>
> Again, since this uses the PMU node directly and doesn't seem to access any
> registers shared with other drivers (or at least not at the time most the
> functions from this file are called) I don't think there is any reason why
> not to use of_iomap() and access the registers directly.
>

Regarding using PMU base address as regmap handle or base address I
have replied to your comments in this thread [1], so let's decide
which way is the best. So I will update accordingly.

[1]: https://lkml.org/lkml/2014/4/25/751

> What about adding more fields to this struct? For example .pmu_config,
> .pmu_config_extra (for model-specific settings, like for Exynos4412, see my
> comment below) and (*pmu_init)? Of course the regmap (or base address) would
> have to be moved outside, as it isn't const data.
>
> Then for each PMU variant there would be a static const struct will all
> those fields already filled in and entries in OF match table would already
> point to appropriate structure.
>

Thanks for suggestion. I will take care in next version.

>
>> +};
>> +
>> +struct exynos_pmu_data         *pmu_data;
>>   static const struct exynos_pmu_conf *exynos_pmu_config;
>> -static struct regmap *pmu_regmap;
>> +typedef void (*exynos_pmu_init_t)(void);
>>
>>   static const struct exynos_pmu_conf exynos4210_pmu_config[] = {
>>         /* { .reg = address, .val = { AFTR, LPA, SLEEP } */
>> @@ -348,28 +362,31 @@ static void exynos5_init_pmu(void)
>>          * Enable both SC_FEEDBACK and SC_COUNTER
>>          */
>>         for (i = 0 ; i < ARRAY_SIZE(exynos5_list_both_cnt_feed) ; i++) {
>> -               regmap_read(pmu_regmap, exynos5_list_both_cnt_feed[i],
>> &tmp);
>> +               regmap_read(pmu_data->pmu_regmap,
>> +                               exynos5_list_both_cnt_feed[i], &tmp);
>>                 tmp |= (EXYNOS5_USE_SC_FEEDBACK |
>>                         EXYNOS5_USE_SC_COUNTER);
>> -               regmap_write(pmu_regmap, exynos5_list_both_cnt_feed[i],
>> tmp);
>> +               regmap_write(pmu_data->pmu_regmap,
>> +                               exynos5_list_both_cnt_feed[i], tmp);
>>         }
>>
>>         /*
>>          * SKIP_DEACTIVATE_ACEACP_IN_PWDN_BITFIELD Enable
>>          */
>> -       regmap_read(pmu_regmap, EXYNOS5_ARM_COMMON_OPTION, &tmp);
>> +       regmap_read(pmu_data->pmu_regmap, EXYNOS5_ARM_COMMON_OPTION,
>> &tmp);
>>         tmp |= EXYNOS5_SKIP_DEACTIVATE_ACEACP_IN_PWDN;
>> -       regmap_write(pmu_regmap, EXYNOS5_ARM_COMMON_OPTION, tmp);
>> +       regmap_write(pmu_data->pmu_regmap, EXYNOS5_ARM_COMMON_OPTION,
>> tmp);
>>
>>         /*
>>          * Disable WFI/WFE on XXX_OPTION
>>          */
>>         for (i = 0 ; i < ARRAY_SIZE(exynos5_list_diable_wfi_wfe) ; i++) {
>> -               tmp = regmap_read(pmu_regmap,
>> exynos5_list_diable_wfi_wfe[i],
>> -                               &tmp);
>> +               tmp = regmap_read(pmu_data->pmu_regmap,
>> +                               exynos5_list_diable_wfi_wfe[i], &tmp);
>>                 tmp &= ~(EXYNOS5_OPTION_USE_STANDBYWFE |
>>                          EXYNOS5_OPTION_USE_STANDBYWFI);
>> -               regmap_write(pmu_regmap, exynos5_list_diable_wfi_wfe[i],
>> tmp);
>> +               regmap_write(pmu_data->pmu_regmap,
>> +                               exynos5_list_diable_wfi_wfe[i], tmp);
>>         }
>>   }
>>
>> @@ -377,52 +394,129 @@ void exynos_sys_powerdown_conf(enum sys_powerdown
>> mode)
>>   {
>>         unsigned int i;
>>
>> -       if (soc_is_exynos5250())
>> +       if (pmu_data->pmu_id == PMU_EXYNOS5250)
>>                 exynos5_init_pmu();
>
>
> Next field could be added to exynos_pmu_data struct, called
> (*powerdown_conf) and then the code above replaced with:
>
>         if (pmu_data->powerdown_conf)
>                 pmu_data->powerdown_conf(mode);
>
>
>>
>>         for (i = 0; (exynos_pmu_config[i].offset != PMU_TABLE_END) ; i++)
>> -               regmap_write(pmu_regmap, exynos_pmu_config[i].offset,
>> +               regmap_write(pmu_data->pmu_regmap,
>> exynos_pmu_config[i].offset,
>>                                 exynos_pmu_config[i].val[mode]);
>>
>> -       if (soc_is_exynos4412()) {
>> +       if (pmu_data->pmu_id == PMU_EXYNOS4412) {
>>                 for (i = 0; exynos4412_pmu_config[i].offset !=
>> PMU_TABLE_END; i++)
>> -                       regmap_write(pmu_regmap,
>> exynos4412_pmu_config[i].offset,
>> +                       regmap_write(pmu_data->pmu_regmap,
>> +                                       exynos4412_pmu_config[i].offset,
>>
>> exynos4412_pmu_config[i].val[mode]);
>>         }
>
>
> As I mentioned above, the pmu_data struct could have a field called
> pmu_config_extra that would be non-NULL for Exynos4412 and then the code
> above could be replaced with:
>
>         if (pmu_data->pmu_config_extra) {
>                 // iterate over pmu_config_extra
>                 // ...
>         }
>
> This way you could completely remove the pmu_id field and checks for
> particular SoCs from the code.
>
>
>>   }
>>
>> -static int __init exynos_pmu_init(void)
>> +static void exynos4210_pmu_init(void)
>>   {
>> -       unsigned int value;
>> -
>>         exynos_pmu_config = exynos4210_pmu_config;
>> -       pmu_regmap = get_exynos_pmuregmap();
>> -
>> -       if (soc_is_exynos4210()) {
>> -               exynos_pmu_config = exynos4210_pmu_config;
>> -               pr_info("EXYNOS4210 PMU Initialize\n");
>> -       } else if (soc_is_exynos4212() || soc_is_exynos4412()) {
>> -               exynos_pmu_config = exynos4x12_pmu_config;
>> -               pr_info("EXYNOS4x12 PMU Initialize\n");
>> -       } else if (soc_is_exynos5250()) {
>> -               /*
>> -                * When SYS_WDTRESET is set, watchdog timer reset request
>> -                * is ignored by power management unit.
>> -                */
>> -               regmap_read(pmu_regmap, EXYNOS5_AUTO_WDTRESET_DISABLE,
>> &value);
>> -               value &= ~EXYNOS5_SYS_WDTRESET;
>> -               regmap_write(pmu_regmap, EXYNOS5_AUTO_WDTRESET_DISABLE,
>> value);
>> -
>> -               regmap_read(pmu_regmap, EXYNOS5_MASK_WDTRESET_REQUEST,
>> &value);
>> -               value &= ~EXYNOS5_SYS_WDTRESET;
>> -               regmap_write(pmu_regmap, EXYNOS5_MASK_WDTRESET_REQUEST,
>> value);
>> -
>> -               exynos_pmu_config = exynos5250_pmu_config;
>> -               pr_info("EXYNOS5250 PMU Initialize\n");
>> -       } else {
>> -               pr_info("EXYNOS: PMU not supported\n");
>> +       pmu_data->pmu_id = PMU_EXYNOS4210;
>> +
>> +       pr_info("EXYNOS4210 PMU Initialize\n");
>> +}
>> +
>> +static void exynos4x12_pmu_init(void)
>> +{
>> +       exynos_pmu_config = exynos4x12_pmu_config;
>> +       pmu_data->pmu_id = PMU_EXYNOS4X12;
>> +
>> +       pr_info("EXYNOS4x12 PMU Initialize\n");
>> +}
>> +
>> +static void exynos4412_pmu_init(void)
>> +{
>> +       exynos_pmu_config = exynos4x12_pmu_config;
>> +       pmu_data->pmu_id = PMU_EXYNOS4412;
>> +
>> +       pr_info("EXYNOS4412 PMU Initialize\n");
>> +}
>> +
>> +static void exynos5250_pmu_init(void)
>> +{
>> +       unsigned int tmp;
>> +
>> +       /*
>> +        * When SYS_WDTRESET is set, watchdog timer reset request
>> +        * is ignored by power management unit.
>> +        */
>> +       regmap_read(pmu_data->pmu_regmap, EXYNOS5_AUTO_WDTRESET_DISABLE,
>> &tmp);
>> +       tmp &= ~EXYNOS5_SYS_WDTRESET;
>> +       regmap_write(pmu_data->pmu_regmap, EXYNOS5_AUTO_WDTRESET_DISABLE,
>> tmp);
>> +
>> +       regmap_read(pmu_data->pmu_regmap, EXYNOS5_MASK_WDTRESET_REQUEST,
>> &tmp);
>> +       tmp &= ~EXYNOS5_SYS_WDTRESET;
>> +       regmap_write(pmu_data->pmu_regmap, EXYNOS5_MASK_WDTRESET_REQUEST,
>> tmp);
>> +
>> +       exynos_pmu_config = exynos5250_pmu_config;
>> +       pmu_data->pmu_id = PMU_EXYNOS5250;
>> +
>> +       pr_info("EXYNOS5250 PMU Initialize\n");
>> +}
>
>
> This part is very nice. Finally there is no huge if with else if clause for
> every SoC. Thanks.
>
>
>> +
>> +/*
>> + * PMU platform driver and devicetree bindings.
>> + */
>> +static struct of_device_id exynos_pmu_of_device_ids[] = {
>> +       {
>> +               .compatible = "samsung,exynos4210-pmu",
>> +               .data = (void *)exynos4210_pmu_init
>> +       },
>> +       {
>> +               .compatible = "samsung,exynos4212-pmu",
>> +               .data = (void *)exynos4x12_pmu_init
>> +       },
>> +       {
>> +               .compatible = "samsung,exynos4412-pmu",
>> +               .data = (void *)exynos4412_pmu_init
>> +       },
>> +       {
>> +               .compatible = "samsung,exynos5250-pmu",
>> +               .data = (void *)exynos5250_pmu_init
>> +       },
>> +       {},
>> +};
>> +
>> +static int exynos_pmu_probe(struct device_node *np)
>> +{
>> +       const struct of_device_id *match;
>> +       exynos_pmu_init_t exynos_pmu_init;
>> +
>> +       pmu_data = kzalloc(sizeof(struct exynos_pmu_data), GFP_KERNEL);
>> +       if (!pmu_data) {
>> +               pr_err("exynos_pmu driver probe failed\n");
>> +               return -ENOMEM;
>>         }
>>
>> +       match = of_match_node(exynos_pmu_of_device_ids, np);
>> +       if (!match) {
>> +               pr_err("fail to get matching of_match struct\n");
>> +               return -EINVAL;
>> +       }
>> +
>> +       exynos_pmu_init = match->data;
>> +
>> +       pmu_data->pmu_regmap = syscon_early_regmap_lookup_by_phandle(np,
>> +                       "samsung,syscon-phandle");
>> +       if (IS_ERR(pmu_data->pmu_regmap)) {
>> +               pr_err("failed to find exynos_pmu_regmap\n");
>> +               return PTR_ERR(pmu_data->pmu_regmap);
>> +       }
>> +
>> +       exynos_pmu_init();
>> +
>>         return 0;
>> +};
>> +
>> +static int __init exynos_pmu_of_init(void)
>> +{
>> +       int ret = 0;
>> +       struct device_node *np;
>> +
>> +       for_each_matching_node_and_match(np, exynos_pmu_of_device_ids,
>> NULL)
>> +               ret = exynos_pmu_probe(np);
>
>
> I wouldn't expect more than one PMU in the system, so probably a simple
>
>         for_each_matching_node_and_match(np, exynos_pmu_of_device_ids...
>                 return exynos_pmu_probe(np);
>
>         return -ENODEV;
>
> would be enough here.
>

OK. Will change this.

Thanks,
Pankaj Dubey

> Best regards,
> Tomasz
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-samsung-soc"
> in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
