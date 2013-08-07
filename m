Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932144Ab3HGGgl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 02:36:41 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:38784 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757121Ab3HGGgj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 02:36:39 -0400
MIME-Version: 1.0
In-Reply-To: <1375353367-20346-1-git-send-email-ch.naveen@samsung.com>
References: <1375336979-14747-1-git-send-email-ch.naveen@samsung.com>
	<1375353367-20346-1-git-send-email-ch.naveen@samsung.com>
Date: Wed, 7 Aug 2013 12:06:38 +0530
X-Google-Sender-Auth: jEcWAEk0NnbUEVVqi5AasSLgTlo
Message-ID: <CADGdYn5ZFE8QLy2XHn+NNxK3bb+wNZzv3JLQ6+baBhQUQVat9Q@mail.gmail.com>
Subject: Re: [PATCH v2] thermal: exynos: Handle the misplaced TRIMINFO register
From: amit daniel kachhap <amit.daniel@samsung.com>
To: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
Cc: linux-pm@vger.kernel.org, rui.zhang@intel.com, eduardo.valentin@ti.com,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        kgene.kim@samsung.com, naveenkrishna.ch@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Naveen,

On Thu, Aug 1, 2013 at 4:06 PM, Naveen Krishna Chatradhi
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
> Reviewed-by: Doug Anderson <dianders@chromium.org>
> ---
> Changes since v1:
> Rebased on http://git.kernel.org/pub/scm/linux/kernel/git/evalenti/linux-soc-thermal.git
Is it rebased against next branch?
>
>  .../devicetree/bindings/thermal/exynos-thermal.txt |   48 ++++++++++++++++++++
>  drivers/thermal/exynos_thermal.c                   |   26 ++++++++++-
In the new directory structure this file is renamed as
drivers/thermal/samsung/exynos_tmu.c.

Thanks,
Amit Daniel
>  2 files changed, 72 insertions(+), 2 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/thermal/exynos-thermal.txt
>
> diff --git a/Documentation/devicetree/bindings/thermal/exynos-thermal.txt b/Documentation/devicetree/bindings/thermal/exynos-thermal.txt
> new file mode 100644
> index 0000000..1db279e
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/thermal/exynos-thermal.txt
> @@ -0,0 +1,48 @@
> +* Exynos Thermal
> +
> +Required properties:
> +- compatible: should be one of the following.
> +    * "samsung,exynos4210-tmu" - for controllers compatible with exynos4210 tmu.
> +    * "samsung,exynos5250-tmu" - for controllers compatible with exynos5250 tmu.
> +    * "samsung,exynos5420-tmu" - for controllers compatible with exynos5420 tmu.
> +
> +- reg: physical base address of the controller and length of
> +  memory mapped region.
> +
> +    ** NOTE FOR EXYNOS5420 **
> +    TRIMINFO register is being misplaced for TMU channels 2, 3 and 4
> +
> +    TERMINFO for TMU channel 2 is present in address space of TMU channel 3
> +    TERMINFO for TMU channel 3 is present in address space of TMU channel 4
> +    TERMINFO for TMU channel 4 is present in address space of TMU channel 2
> +
> +    * In such cases the reg property contains the misplaced register address and
> +      range as the second parameter.
> +
> +- interrupts : interrupt number to the cpu.
> +- clocks : Clock number as per common clock framework for the cpu.
> +- clock-names : clock name to be used in the driver
> +
> +Example:
> +
> +       /* tmu for CPU0 */
> +       tmu@10060000 {
> +               compatible = "samsung,exynos5420-tmu";
> +               reg = <0x10060000 0x100>;
> +               interrupts = <0 65 0>;
> +               clocks = <&clock 318>;
> +               clock-names = "tmu_apbif";
> +       };
> +
> +Example: In case of Exynos5420 TMU channel 3
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
> diff --git a/drivers/thermal/exynos_thermal.c b/drivers/thermal/exynos_thermal.c
> index d20ce9e..1ad9005 100644
> --- a/drivers/thermal/exynos_thermal.c
> +++ b/drivers/thermal/exynos_thermal.c
> @@ -38,6 +38,7 @@
>  #include <linux/cpufreq.h>
>  #include <linux/cpu_cooling.h>
>  #include <linux/of.h>
> +#include <linux/of_address.h>
>
>  /* Exynos generic registers */
>  #define EXYNOS_TMU_REG_TRIMINFO                0x0
> @@ -120,7 +121,7 @@
>  struct exynos_tmu_data {
>         struct exynos_tmu_platform_data *pdata;
>         struct resource *mem;
> -       void __iomem *base;
> +       void __iomem *base, *triminfo_base;
>         int irq;
>         enum soc_type soc;
>         struct work_struct irq_work;
> @@ -593,8 +594,14 @@ static int exynos_tmu_initialize(struct platform_device *pdev)
>                 __raw_writel(EXYNOS_TRIMINFO_RELOAD,
>                                 data->base + EXYNOS_TMU_TRIMINFO_CON);
>         }
> +
>         /* Save trimming info in order to perform calibration */
> -       trim_info = readl(data->base + EXYNOS_TMU_REG_TRIMINFO);
> +       if (data->triminfo_base)
> +               /* On exynos5420 TRIMINFO is misplaced for some channels */
> +               trim_info = readl(data->triminfo_base);
> +       else
> +               trim_info = readl(data->base + EXYNOS_TMU_REG_TRIMINFO);
> +
>         data->temp_error1 = trim_info & EXYNOS_TMU_TRIM_TEMP_MASK;
>         data->temp_error2 = ((trim_info >> 8) & EXYNOS_TMU_TRIM_TEMP_MASK);
>
> @@ -941,6 +948,15 @@ static int exynos_tmu_probe(struct platform_device *pdev)
>                 return ret;
>         }
>
> +       /* For Exynos5420 The misplaced TERMINFO register address will be
> +        * passed from device tree node.
> +        *
> +        * We cannot use devm_request_and_ioremap, as the base address
> +        * over laps with the address space of the other TMU channel.
> +        * Check Documentation for details
> +        */
> +       data->triminfo_base = of_iomap(pdev->dev.of_node, 1);
> +
>         data->clk = devm_clk_get(&pdev->dev, "tmu_apbif");
>         if (IS_ERR(data->clk)) {
>                 dev_err(&pdev->dev, "Failed to get clock\n");
> @@ -1001,6 +1017,9 @@ static int exynos_tmu_probe(struct platform_device *pdev)
>
>         return 0;
>  err_clk:
> +       if (data->triminfo_base)
> +               iounmap(data->triminfo_base);
> +
>         platform_set_drvdata(pdev, NULL);
>         clk_unprepare(data->clk);
>         return ret;
> @@ -1014,6 +1033,9 @@ static int exynos_tmu_remove(struct platform_device *pdev)
>
>         exynos_unregister_thermal();
>
> +       if (data->triminfo_base)
> +               iounmap(data->triminfo_base);
> +
>         clk_unprepare(data->clk);
>
>         platform_set_drvdata(pdev, NULL);
> --
> 1.7.9.5
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
