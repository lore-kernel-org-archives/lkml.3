Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752850Ab3H1GDm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 02:03:42 -0400
Received: from mail-lb0-f181.google.com ([209.85.217.181]:56298 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752390Ab3H1GDk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 02:03:40 -0400
MIME-Version: 1.0
In-Reply-To: <1377668719-8602-4-git-send-email-ch.naveen@samsung.com>
References: <1375336979-14747-1-git-send-email-ch.naveen@samsung.com>
	<1377668719-8602-1-git-send-email-ch.naveen@samsung.com>
	<1377668719-8602-4-git-send-email-ch.naveen@samsung.com>
Date: Wed, 28 Aug 2013 11:33:38 +0530
X-Google-Sender-Auth: CcDcr1lZas8WDKUDENq0GRUKiyg
Message-ID: <CADGdYn5fykqperPUJtGbh-E9sECFP4J8xSyjB3YA4_KzO3ZwNA@mail.gmail.com>
Subject: Re: [PATCH 3/3] thermal: exynos: Handle the misplaced TRIMINFO register
From: amit daniel kachhap <amit.daniel@samsung.com>
To: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
Cc: "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Zhang Rui <rui.zhang@intel.com>,
        "Valentin, Eduardo" <eduardo.valentin@ti.com>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Naveen Krishna <naveenkrishna.ch@gmail.com>,
        devicetree@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Naveen

On Wed, Aug 28, 2013 at 11:15 AM, Naveen Krishna Chatradhi
<ch.naveen@samsung.com> wrote:
> This patch adds code to handle the misplaced TRIMINFO register
> incase of Exynos5420.
>
> On Exynos5420 we have a TRIMINFO register being misplaced for
> TMU channels 2, 3 and 4
>
> TRIMINFO at 0x1006c000 contains data for TMU channel 3
> TRIMINFO at 0x100a0000 contains data for TMU channel 4
> TRIMINFO at 0x10068000 contains data for TMU channel 2
>
> The misplaced register address is passed through devicetree and
> map it seperately during probe.
> Also, adds the documentation under devicetree/bindings/thermal/
>
> Signed-off-by: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
> ---
>  .../devicetree/bindings/thermal/exynos-thermal.txt |   21 +++++++++++++
>  drivers/thermal/samsung/exynos_tmu.c               |   32 +++++++++++++++++---
>  2 files changed, 49 insertions(+), 4 deletions(-)
>
> diff --git a/Documentation/devicetree/bindings/thermal/exynos-thermal.txt b/Documentation/devicetree/bindings/thermal/exynos-thermal.txt
> index 284f530..e818473 100644
> --- a/Documentation/devicetree/bindings/thermal/exynos-thermal.txt
> +++ b/Documentation/devicetree/bindings/thermal/exynos-thermal.txt
> @@ -7,12 +7,21 @@
>                "samsung,exynos4210-tmu"
>                "samsung,exynos5250-tmu"
>                "samsung,exynos5440-tmu"
> +              "samsung,exynos5420-tmu"
>  - interrupt-parent : The phandle for the interrupt controller
>  - reg : Address range of the thermal registers. For soc's which has multiple
>         instances of TMU and some registers are shared across all TMU's like
>         interrupt related then 2 set of register has to supplied. First set
>         belongs to each instance of TMU and second set belongs to common TMU
>         registers.
> +
> + ** NOTE FOR EXYNOS5420 **
> +    TRIMINFO register is being misplaced for TMU channels 2, 3 and 4
> +
> +    TERMINFO for TMU channel 2 is present in address space of TMU channel 3
> +    TERMINFO for TMU channel 3 is present in address space of TMU channel 4
> +    TERMINFO for TMU channel 4 is present in address space of TMU channel 2
> +
>  - interrupts : Should contain interrupt for thermal system
>  - clocks : The main clock for TMU device
>  - clock-names : Thermal system clock name
> @@ -43,6 +52,18 @@ Example 2):
>                 clock-names = "tmu_apbif";
>         };
>
> +Example 3): In case of Exynos5420 TMU channel 3
> +
> +       /* tmu for CPU3 */
> +       tmu@1006c000 {
> +               compatible = "samsung,exynos5420-tmu";
> +               /* 2nd reg is for the misplaced TRIMINFO register */
> +               reg = <0x1006c000 0x100>, <0x100a0000 0x4>;
> +               interrupts = <0 185 0>;
> +               clocks = <&clock 318>;
> +               clock-names = "tmu_apbif";
> +       };
> +
>  Note: For multi-instance tmu each instance should have an alias correctly
>  numbered in "aliases" node.
>
> diff --git a/drivers/thermal/samsung/exynos_tmu.c b/drivers/thermal/samsung/exynos_tmu.c
> index bfdfbd6..f95844e 100644
> --- a/drivers/thermal/samsung/exynos_tmu.c
> +++ b/drivers/thermal/samsung/exynos_tmu.c
> @@ -42,6 +42,7 @@
>   * @pdata: pointer to the tmu platform/configuration data
>   * @base: base address of the single instance of the TMU controller.
>   * @base_common: base address of the common registers of the TMU controller.
> + * @triminfo_base: misplaced register base for TRIMINFO on Exynos5420 only

Instead of creating this new field you can re-use base_common for
accessing the second set of register for misplaced triminfo address.
Also you can rename this variable as base_second.

>   * @irq: irq number of the TMU controller.
>   * @soc: id of the SOC type.
>   * @irq_work: pointer to the irq work structure.
> @@ -57,6 +58,7 @@ struct exynos_tmu_data {
>         struct exynos_tmu_platform_data *pdata;
>         void __iomem *base;
>         void __iomem *base_common;
> +       void __iomem *triminfo_base;            /* Needed only Exynos5420 */
>         int irq;
>         enum soc_type soc;
>         struct work_struct irq_work;
> @@ -186,7 +188,12 @@ static int exynos_tmu_initialize(struct platform_device *pdev)
>                         EXYNOS5440_EFUSE_SWAP_OFFSET + reg->triminfo_data);
>                 }
>         } else {
> -               trim_info = readl(data->base + reg->triminfo_data);
> +               /* On exynos5420 TRIMINFO is misplaced for some channels */
> +               if (data->triminfo_base)
> +                       trim_info = readl(data->triminfo_base +
> +                                               reg->triminfo_data);
> +               else
> +                       trim_info = readl(data->base + reg->triminfo_data);
>         }
>         data->temp_error1 = trim_info & EXYNOS_TMU_TEMP_MASK;
>         data->temp_error2 = ((trim_info >> reg->triminfo_85_shift) &
> @@ -586,8 +593,17 @@ static int exynos_map_dt_data(struct platform_device *pdev)
>          * Check if the TMU shares some registers and then try to map the
>          * memory of common registers.
>          */
> -       if (!TMU_SUPPORTS(pdata, SHARED_MEMORY))
> +       if (!TMU_SUPPORTS(pdata, SHARED_MEMORY)) {
> +               /* For Exynos5420 The misplaced TERMINFO register address will
> +                * be passed from device tree node.
> +                *
> +                * We cannot use devm_request_and_ioremap, as the base address
> +                * over laps with the address space of the other TMU channel.
> +                * Check Documentation for details
> +                */
> +               data->triminfo_base = of_iomap(pdev->dev.of_node, 1);
>                 return 0;
> +       }
In the below code, remove the request resource API for common_base and
use simple of_iomap API.

Thanks,
Amit Daniel
>
>         if (of_address_to_resource(pdev->dev.of_node, 1, &res)) {
>                 dev_err(&pdev->dev, "failed to get Resource 1\n");
> @@ -632,12 +648,13 @@ static int exynos_tmu_probe(struct platform_device *pdev)
>         data->clk = devm_clk_get(&pdev->dev, "tmu_apbif");
>         if (IS_ERR(data->clk)) {
>                 dev_err(&pdev->dev, "Failed to get clock\n");
> -               return  PTR_ERR(data->clk);
> +               ret = PTR_ERR(data->clk);
> +               goto err_triminfo_base;
>         }
>
>         ret = clk_prepare(data->clk);
>         if (ret)
> -               return ret;
> +               goto err_triminfo_base;
>
>         if (pdata->type == SOC_ARCH_EXYNOS ||
>                 pdata->type == SOC_ARCH_EXYNOS4210 ||
> @@ -707,9 +724,13 @@ static int exynos_tmu_probe(struct platform_device *pdev)
>         }
>
>         return 0;
> +
>  err_clk:
>         clk_unprepare(data->clk);
>         return ret;
> +err_triminfo_base:
> +       if (data->triminfo_base)
> +               iounmap(data->triminfo_base);
>  }
>
>  static int exynos_tmu_remove(struct platform_device *pdev)
> @@ -720,6 +741,9 @@ static int exynos_tmu_remove(struct platform_device *pdev)
>
>         exynos_unregister_thermal(data->reg_conf);
>
> +       if (data->triminfo_base)
> +               iounmap(data->triminfo_base);
> +
>         clk_unprepare(data->clk);
>
>         if (!IS_ERR(data->regulator))
> --
> 1.7.9.5
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
