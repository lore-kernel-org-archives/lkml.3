Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757486AbaD3GFx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 02:05:53 -0400
Received: from mail-oa0-f48.google.com ([209.85.219.48]:32886 "EHLO
	mail-oa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750833AbaD3GFu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 02:05:50 -0400
MIME-Version: 1.0
In-Reply-To: <1398835057-3860-12-git-send-email-pankaj.dubey@samsung.com>
References: <1398835057-3860-1-git-send-email-pankaj.dubey@samsung.com>
	<1398835057-3860-12-git-send-email-pankaj.dubey@samsung.com>
Date: Wed, 30 Apr 2014 11:35:49 +0530
Message-ID: <CAGm_ybjPGDe7ARPs7vfe+LJ2pmxD-HU6cNa9ePaWobDFeOP46Q@mail.gmail.com>
Subject: Re: [PATCH v3 11/12] ARM: EXYNOS: Add platform driver support for
 Exynos PMU.
From: Vikas Sajjan <sajjan.linux@gmail.com>
To: Pankaj Dubey <pankaj.dubey@samsung.com>
Cc: linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        linux-kernel@vger.kernel.org,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Kukjin Kim <kgene.kim@samsung.com>, linux@arm.linux.org.uk,
        Tomasz Figa <t.figa@samsung.com>, chow.kim@samsung.com,
        Young-Gun Jang <yg1004.jang@samsung.com>,
        Vikas Sajjan <vikas.sajjan@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pankaj,

On Wed, Apr 30, 2014 at 10:47 AM, Pankaj Dubey <pankaj.dubey@samsung.com> wrote:
> This patch modifies Exynos Power Management Unit (PMU) initialization
> implementation in following way:
>
> - Added platform_device support by registering static platform device.
> - Added platform struct exynos_pmu_data to hold platform specific data.
> - For each SoC's PMU support now we can add platform data and statically
>   bind PMU configuration and SoC specific initialization function.
> - Probe function will scan DT and based on matching PMU compatibility
>   string initialize pmu_context which will be platform_data for driver.
> - Obtain PMU regmap handle using "syscon_regmap_lookup_by_phandle" so
>   that we can reduce dependency over machine header files.
> - Separate each SoC's PMU initialization function and make it as part of
>   platform data.
> - It also removes uses of soc_is_exynosXXXX() thus making PMU implementation
>   independent of "plat/cpu.h".
>
> Signed-off-by: Pankaj Dubey <pankaj.dubey@samsung.com>
> Signed-off-by: Young-Gun Jang <yg1004.jang@samsung.com>
> ---
>  arch/arm/mach-exynos/pmu.c |  280 +++++++++++++++++++++++++++++++++++---------
>  1 file changed, 224 insertions(+), 56 deletions(-)
>
> diff --git a/arch/arm/mach-exynos/pmu.c b/arch/arm/mach-exynos/pmu.c
> index 67116a5..030df96 100644
> --- a/arch/arm/mach-exynos/pmu.c
> +++ b/arch/arm/mach-exynos/pmu.c
> @@ -1,5 +1,5 @@
>  /*
> - * Copyright (c) 2011-2012 Samsung Electronics Co., Ltd.
> + * Copyright (c) 2011-2014 Samsung Electronics Co., Ltd.
>   *             http://www.samsung.com/
>   *
>   * EXYNOS - CPU PMU(Power Management Unit) support
> @@ -9,20 +9,33 @@
>   * published by the Free Software Foundation.
>   */
>
> -#include <linux/io.h>
> -#include <linux/kernel.h>
> +#include <linux/module.h>
>  #include <linux/regmap.h>
> -
> -#include <plat/cpu.h>
> +#include <linux/of.h>
> +#include <linux/platform_device.h>
> +#include <linux/slab.h>
> +#include <linux/mfd/syscon.h>
>
>  #include "common.h"
>  #include "regs-pmu.h"
>
> -static const struct exynos_pmu_conf *exynos_pmu_config;
> -static struct regmap *pmu_regmap;
> +struct exynos_pmu_data {
> +       const struct exynos_pmu_conf *pmu_config;
> +       const struct exynos_pmu_conf *pmu_config_extra;
> +       void (*pmu_init)(void);
> +       void (*powerdown_conf)(enum sys_powerdown);
> +};
> +
> +struct exynos_pmu_context {
> +       struct device *dev;
> +       struct exynos_pmu_data *pmu_data;
> +       struct regmap   *pmu_regmap;
> +};
> +
> +static struct exynos_pmu_context       *pmu_context;
>
>  static const struct exynos_pmu_conf exynos4210_pmu_config[] = {
> -       /* { .reg = address, .val = { AFTR, LPA, SLEEP } */
> +       /* { .offset = address, .val = { AFTR, LPA, SLEEP } */
>         { S5P_ARM_CORE0_LOWPWR,                 { 0x0, 0x0, 0x2 } },
>         { S5P_DIS_IRQ_CORE0,                    { 0x0, 0x0, 0x0 } },
>         { S5P_DIS_IRQ_CENTRAL0,                 { 0x0, 0x0, 0x0 } },
> @@ -216,7 +229,7 @@ static const struct exynos_pmu_conf exynos4412_pmu_config[] = {
>  };
>
>  static const struct exynos_pmu_conf exynos5250_pmu_config[] = {
> -       /* { .reg = address, .val = { AFTR, LPA, SLEEP } */
> +       /* { .offset = address, .val = { AFTR, LPA, SLEEP } */
>         { EXYNOS5_ARM_CORE0_SYS_PWR_REG,                { 0x0, 0x0, 0x2} },
>         { EXYNOS5_DIS_IRQ_ARM_CORE0_LOCAL_SYS_PWR_REG,  { 0x0, 0x0, 0x0} },
>         { EXYNOS5_DIS_IRQ_ARM_CORE0_CENTRAL_SYS_PWR_REG,        { 0x0, 0x0, 0x0} },
> @@ -339,7 +352,7 @@ static unsigned int const exynos5_list_diable_wfi_wfe[] = {
>         EXYNOS5_ISP_ARM_OPTION,
>  };
>
> -static void exynos5_init_pmu(void)
> +void exynos5_powerdown_conf(enum sys_powerdown mode)
>  {
>         unsigned int i;
>         unsigned int tmp;
> @@ -348,81 +361,236 @@ static void exynos5_init_pmu(void)
>          * Enable both SC_FEEDBACK and SC_COUNTER
>          */
>         for (i = 0 ; i < ARRAY_SIZE(exynos5_list_both_cnt_feed) ; i++) {
> -               regmap_read(pmu_regmap, exynos5_list_both_cnt_feed[i], &tmp);
> +               regmap_read(pmu_context->pmu_regmap,
> +                               exynos5_list_both_cnt_feed[i], &tmp);
>                 tmp |= (EXYNOS5_USE_SC_FEEDBACK |
>                         EXYNOS5_USE_SC_COUNTER);
> -               regmap_write(pmu_regmap, exynos5_list_both_cnt_feed[i], tmp);
> +               regmap_write(pmu_context->pmu_regmap,
> +                               exynos5_list_both_cnt_feed[i], tmp);
>         }
>
>         /*
>          * SKIP_DEACTIVATE_ACEACP_IN_PWDN_BITFIELD Enable
>          */
> -       regmap_read(pmu_regmap, EXYNOS5_ARM_COMMON_OPTION, &tmp);
> +       regmap_read(pmu_context->pmu_regmap, EXYNOS5_ARM_COMMON_OPTION, &tmp);
>         tmp |= EXYNOS5_SKIP_DEACTIVATE_ACEACP_IN_PWDN;
> -       regmap_write(pmu_regmap, EXYNOS5_ARM_COMMON_OPTION, tmp);
> +       regmap_write(pmu_context->pmu_regmap, EXYNOS5_ARM_COMMON_OPTION, tmp);
>
>         /*
>          * Disable WFI/WFE on XXX_OPTION
>          */
>         for (i = 0 ; i < ARRAY_SIZE(exynos5_list_diable_wfi_wfe) ; i++) {
> -               tmp = regmap_read(pmu_regmap, exynos5_list_diable_wfi_wfe[i],
> -                               &tmp);
> +               tmp = regmap_read(pmu_context->pmu_regmap,
> +                               exynos5_list_diable_wfi_wfe[i], &tmp);
>                 tmp &= ~(EXYNOS5_OPTION_USE_STANDBYWFE |
>                          EXYNOS5_OPTION_USE_STANDBYWFI);
> -               regmap_write(pmu_regmap, exynos5_list_diable_wfi_wfe[i], tmp);
> +               regmap_write(pmu_context->pmu_regmap,
> +                               exynos5_list_diable_wfi_wfe[i], tmp);
>         }
>  }
>
>  void exynos_sys_powerdown_conf(enum sys_powerdown mode)
>  {
>         unsigned int i;
> +       struct exynos_pmu_data *pmu_data = pmu_context->pmu_data;
>
> -       if (soc_is_exynos5250())
> -               exynos5_init_pmu();
> +       if (pmu_data->powerdown_conf)
> +               pmu_data->powerdown_conf(mode);
>
> -       for (i = 0; (exynos_pmu_config[i].offset != PMU_TABLE_END) ; i++)
> -               regmap_write(pmu_regmap, exynos_pmu_config[i].offset,
> -                               exynos_pmu_config[i].val[mode]);
> +       if (pmu_data->pmu_config) {
> +               for (i = 0; (pmu_data->pmu_config[i].offset != PMU_TABLE_END) ; i++)
> +                       regmap_write(pmu_context->pmu_regmap,
> +                                       pmu_data->pmu_config[i].offset,
> +                                       pmu_data->pmu_config[i].val[mode]);
> +       }
>
> -       if (soc_is_exynos4412()) {
> -               for (i = 0; exynos4412_pmu_config[i].offset != PMU_TABLE_END; i++)
> -                       regmap_write(pmu_regmap, exynos4412_pmu_config[i].offset,
> -                                       exynos4412_pmu_config[i].val[mode]);
> +       if (pmu_data->pmu_config_extra) {
> +               for (i = 0; pmu_data->pmu_config_extra[i].offset != PMU_TABLE_END; i++)
> +                       regmap_write(pmu_context->pmu_regmap,
> +                                       pmu_data->pmu_config_extra[i].offset,
> +                                       pmu_data->pmu_config_extra[i].val[mode]);
>         }
>  }
>
> -static int __init exynos_pmu_init(void)
> +static void exynos5250_pmu_init(void)
> +{
> +       unsigned int tmp;
> +       struct regmap *pmu_regmap = pmu_context->pmu_regmap;
> +       /*
> +        * When SYS_WDTRESET is set, watchdog timer reset request
> +        * is ignored by power management unit.
> +        */
> +       regmap_read(pmu_regmap, EXYNOS5_AUTO_WDTRESET_DISABLE, &tmp);
> +       tmp &= ~EXYNOS5_SYS_WDTRESET;
> +       regmap_write(pmu_regmap, EXYNOS5_AUTO_WDTRESET_DISABLE, tmp);
> +
> +       regmap_read(pmu_regmap, EXYNOS5_MASK_WDTRESET_REQUEST, &tmp);
> +       tmp &= ~EXYNOS5_SYS_WDTRESET;
> +       regmap_write(pmu_regmap, EXYNOS5_MASK_WDTRESET_REQUEST, tmp);
> +}
> +
> +static struct exynos_pmu_data exynos4210_pmu_data = {
> +       .pmu_config     = exynos4210_pmu_config,
> +};
> +
> +static struct exynos_pmu_data exynos4x12_pmu_data = {
> +       .pmu_config     = exynos4x12_pmu_config,
> +};
> +
> +static struct exynos_pmu_data exynos4412_pmu_data = {
> +       .pmu_config             = exynos4x12_pmu_config,
> +       .pmu_config_extra       = exynos4412_pmu_config,
> +};
> +
> +static struct exynos_pmu_data exynos5250_pmu_data = {
> +       .pmu_config     = exynos5250_pmu_config,
> +       .pmu_init       = exynos5250_pmu_init,
> +       .powerdown_conf = exynos5_powerdown_conf,
> +};
> +
> +/*
> + * PMU platform driver and devicetree bindings.
> + */
> +static struct of_device_id exynos_pmu_of_device_ids[] = {
> +       {
> +               .compatible = "samsung,exynos4210-pmu",
> +               .data = (void *)&exynos4210_pmu_data,
> +       },
> +       {
> +               .compatible = "samsung,exynos4212-pmu",
> +               .data = (void *)&exynos4x12_pmu_data,
> +       },
> +       {
> +               .compatible = "samsung,exynos4412-pmu",
> +               .data = (void *)&exynos4412_pmu_data,
> +       },
> +       {
> +               .compatible = "samsung,exynos5250-pmu",
> +               .data = (void *)&exynos5250_pmu_data,
> +       },
> +       {},
> +};
> +
> +static int exynos_pmu_data_init(struct device_node *np)
>  {
> -       unsigned int value;
> -
> -       exynos_pmu_config = exynos4210_pmu_config;
> -       pmu_regmap = get_exynos_pmuregmap();
> -
> -       if (soc_is_exynos4210()) {
> -               exynos_pmu_config = exynos4210_pmu_config;
> -               pr_info("EXYNOS4210 PMU Initialize\n");
> -       } else if (soc_is_exynos4212() || soc_is_exynos4412()) {
> -               exynos_pmu_config = exynos4x12_pmu_config;
> -               pr_info("EXYNOS4x12 PMU Initialize\n");
> -       } else if (soc_is_exynos5250()) {
> -               /*
> -                * When SYS_WDTRESET is set, watchdog timer reset request
> -                * is ignored by power management unit.
> -                */
> -               regmap_read(pmu_regmap, EXYNOS5_AUTO_WDTRESET_DISABLE, &value);
> -               value &= ~EXYNOS5_SYS_WDTRESET;
> -               regmap_write(pmu_regmap, EXYNOS5_AUTO_WDTRESET_DISABLE, value);
> -
> -               regmap_read(pmu_regmap, EXYNOS5_MASK_WDTRESET_REQUEST, &value);
> -               value &= ~EXYNOS5_SYS_WDTRESET;
> -               regmap_write(pmu_regmap, EXYNOS5_MASK_WDTRESET_REQUEST, value);
> -
> -               exynos_pmu_config = exynos5250_pmu_config;
> -               pr_info("EXYNOS5250 PMU Initialize\n");
> -       } else {
> -               pr_info("EXYNOS: PMU not supported\n");
> +       const struct of_device_id *match;
> +
> +       match = of_match_node(exynos_pmu_of_device_ids, np);
> +       if (!match) {
> +               pr_err("fail to get matching of_match struct\n");
> +               return -EINVAL;
> +       }
> +
> +       pmu_context->pmu_data = (struct exynos_pmu_data *) match->data;
> +       pmu_context->pmu_regmap = syscon_regmap_lookup_by_phandle(np,
> +                       "samsung,syscon-phandle");
> +
> +       if (IS_ERR(pmu_context->pmu_regmap)) {
> +               pr_err("failed to find exynos_pmu_regmap\n");
> +               return PTR_ERR(pmu_context->pmu_regmap);
>         }
>
> +       if (pmu_context->pmu_data->pmu_init)
> +               pmu_context->pmu_data->pmu_init();
> +
> +       return 0;
> +};
> +
> +static int exynos_pmu_probe(struct platform_device *pdev)
> +{
> +       int ret;
> +       struct device_node *np;
> +       struct device *dev = &pdev->dev;
> +
> +       pmu_context = devm_kzalloc(&pdev->dev,
> +                       sizeof(struct exynos_pmu_context),
> +                       GFP_KERNEL);
> +       if (pmu_context == NULL) {
> +               dev_err(dev, "Cannot allocate memory.\n");
> +               return -ENOMEM;
> +       }
> +
> +       for_each_matching_node_and_match(np, exynos_pmu_of_device_ids, NULL) {
> +               ret = exynos_pmu_data_init(np);
> +               if (ret < 0)
> +                       return ret;
> +               break;
> +       }

Ca we optmize further as below, there by avoiding one more call to
exynos_pmu_data_init()

=============================================================
  const struct of_device_id *match;
      for_each_matching_node_and_match(np, exynos_pmu_of_device_ids, &match) {

      pmu_context->pmu_data = (struct exynos_pmu_data *) match->data;
       pmu_context->pmu_regmap = syscon_regmap_lookup_by_phandle(np,
                       "samsung,syscon-phandle");

       if (IS_ERR(pmu_context->pmu_regmap)) {
              pr_err("failed to find exynos_pmu_regmap\n");
               return PTR_ERR(pmu_context->pmu_regmap);
        }

       if (pmu_context->pmu_data->pmu_init)
               pmu_context->pmu_data->pmu_init();

        break;
    }
============================================================

> +
> +       pmu_context->dev = dev;
> +
> +       platform_set_drvdata(pdev, pmu_context);
> +
> +       pr_info("Exynos PMU Driver probe done!!!\n");
> +       return 0;
> +}
> +
> +static int exynos_pmu_suspend(struct device *dev)
> +{
> +       /* ToDo: */
>         return 0;
>  }
> -arch_initcall(exynos_pmu_init);
> +
> +static int exynos_pmu_resume(struct device *dev)
> +{
> +       /* ToDo: */
> +       return 0;
> +}
> +
> +static const struct dev_pm_ops exynos_pmu_pm = {
> +       .suspend = exynos_pmu_suspend,
> +       .resume = exynos_pmu_resume,
> +};
> +
> +static int exynos_pmu_remove(struct platform_device *pdev)
> +{
> +       /* nothing to do here */
> +       return 0;
> +}
> +
> +static struct platform_device *exynos_pmu_pdev;
> +
> +static struct platform_driver exynos_pmu_driver = {
> +       .driver  = {
> +               .name   = "exynos-pmu",
> +               .owner  = THIS_MODULE,
> +               .pm     = &exynos_pmu_pm,
> +       },
> +       .probe = exynos_pmu_probe,
> +       .remove = exynos_pmu_remove,
> +};
> +
> +static int __init exynos_pmu_of_init(void)
> +{
> +       int ret;
> +
> +       ret = platform_driver_register(&exynos_pmu_driver);
> +       if (ret < 0)
> +               goto out;
> +
> +       exynos_pmu_pdev = platform_device_register_simple("exynos-pmu", -1,
> +                       NULL, 0);
> +
> +       if (IS_ERR(exynos_pmu_pdev)) {
> +               ret = PTR_ERR(exynos_pmu_pdev);
> +               goto out1;
> +       }
> +
> +       return 0;
> +out1:
> +       platform_driver_unregister(&exynos_pmu_driver);
> +out:
> +       return ret;
> +}
> +arch_initcall(exynos_pmu_of_init);
> +
> +static void __exit exynos_pmu_exit(void)
> +{
> +       platform_device_unregister(exynos_pmu_pdev);
> +       platform_driver_unregister(&exynos_pmu_driver);
> +}
> +module_exit(exynos_pmu_exit);
> +
> +MODULE_AUTHOR("Pankaj Dubey <pankaj.dubey@samsung.com");
> +MODULE_LICENSE("GPL v2");
> +MODULE_DESCRIPTION("EXYNOS Power Management Unit Driver");
> --
> 1.7.10.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-samsung-soc" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
