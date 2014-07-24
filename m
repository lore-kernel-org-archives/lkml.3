Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933951AbaGXAS7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 20:18:59 -0400
Received: from mail-pa0-f50.google.com ([209.85.220.50]:33185 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933856AbaGXAS5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 20:18:57 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        "Tomasz Figa" <t.figa@samsung.com>,
        "Kukjin Kim" <kgene.kim@samsung.com>,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
From: Mike Turquette <mturquette@linaro.org>
In-Reply-To: <1405694193-29643-1-git-send-email-k.kozlowski@samsung.com>
Cc: "Kyungmin Park" <kyungmin.park@samsung.com>,
        "Marek Szyprowski" <m.szyprowski@samsung.com>,
        "Bartlomiej Zolnierkiewicz" <b.zolnierkie@samsung.com>,
        "Krzysztof Kozlowski" <k.kozlowski@samsung.com>
References: <1405694193-29643-1-git-send-email-k.kozlowski@samsung.com>
Message-ID: <20140724001853.6419.551@quantum>
User-Agent: alot/0.3.5
Subject: Re: [PATCH v2 1/2] clk: samsung: exynos4: Enable ARMCLK down feature
Date: Wed, 23 Jul 2014 17:18:53 -0700
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Krzysztof Kozlowski (2014-07-18 07:36:32)
> Enable ARMCLK down feature on all Exynos4 SoCs. The frequency of
> ARMCLK will be reduced upon entering idle mode (WFI or WFE).
> 
> The feature behaves like very fast cpufreq ondemand governor. In idle
> mode this reduces energy consumption on full frequency chosen by
> cpufreq governor by approximately:
>  - Trats2:  6.5% (153 mA -> 143 mA)
>  - Trats:  33.0% (180 mA -> 120 mA)
>  - Gear1:  27.0% (180 mA -> 130 mA)

Nice power savings! Just a quick question on this feature: the clock
frequency is changed in hardware as a result of WFI/WFE? And this only
happens when all CPUs in a cluster (e.g. all 4 CPUs in Exynos 4412) are
in WFI/WFE state?

Thanks,
Mike

> 
> The patch uses simillar settings as Exynos5250 (clk-exynos5250.c),
> except it disables clock up feature and on Exynos4412 ARMCLK down is
> enabled for all 4 cores.
> 
> Tested on Trats board (Exynos4210), Trats2 board (Exynos4412) and
> Samsung Gear 1 (Exynos4212).
> 
> Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> 
> ---
> 
> Changes since v1:
> 1. Add PWR_CTRL registers to the list of saved clk registers on
>    Exynos4x12. Suggested by Tomasz Figa.
> 2. Disable the clock up feature. (sug. Tomasz Figa)
> 3. Use macros for setting clock down ratio. (sug. Tomasz Figa)
> 4. Use num_possible_cpus() for exception on Exynos4x12. (sug. Tomasz
>    Figa)
> 5. Enable the clock down feature also on Exynos4210 Trats board.
> ---
>  drivers/clk/samsung/clk-exynos4.c | 46 +++++++++++++++++++++++++++++++++++++++
>  1 file changed, 46 insertions(+)
> 
> diff --git a/drivers/clk/samsung/clk-exynos4.c b/drivers/clk/samsung/clk-exynos4.c
> index 7f4a473a7ad7..86c7709dc6d6 100644
> --- a/drivers/clk/samsung/clk-exynos4.c
> +++ b/drivers/clk/samsung/clk-exynos4.c
> @@ -114,11 +114,27 @@
>  #define DIV_CPU1               0x14504
>  #define GATE_SCLK_CPU          0x14800
>  #define GATE_IP_CPU            0x14900
> +#define PWR_CTRL1              0x15020
> +#define E4X12_PWR_CTRL2                0x15024
>  #define E4X12_DIV_ISP0         0x18300
>  #define E4X12_DIV_ISP1         0x18304
>  #define E4X12_GATE_ISP0                0x18800
>  #define E4X12_GATE_ISP1                0x18804
>  
> +/* Below definitions are used for PWR_CTRL settings */
> +#define PWR_CTRL1_CORE2_DOWN_RATIO(x)          (((x) & 0x7) << 28)
> +#define PWR_CTRL1_CORE1_DOWN_RATIO(x)          (((x) & 0x7) << 16)
> +#define PWR_CTRL1_DIV2_DOWN_EN                 (1 << 9)
> +#define PWR_CTRL1_DIV1_DOWN_EN                 (1 << 8)
> +#define PWR_CTRL1_USE_CORE3_WFE                        (1 << 7)
> +#define PWR_CTRL1_USE_CORE2_WFE                        (1 << 6)
> +#define PWR_CTRL1_USE_CORE1_WFE                        (1 << 5)
> +#define PWR_CTRL1_USE_CORE0_WFE                        (1 << 4)
> +#define PWR_CTRL1_USE_CORE3_WFI                        (1 << 3)
> +#define PWR_CTRL1_USE_CORE2_WFI                        (1 << 2)
> +#define PWR_CTRL1_USE_CORE1_WFI                        (1 << 1)
> +#define PWR_CTRL1_USE_CORE0_WFI                        (1 << 0)
> +
>  /* the exynos4 soc type */
>  enum exynos4_soc {
>         EXYNOS4210,
> @@ -155,6 +171,7 @@ static unsigned long exynos4210_clk_save[] __initdata = {
>         E4210_GATE_IP_LCD1,
>         E4210_GATE_IP_PERIR,
>         E4210_MPLL_CON0,
> +       PWR_CTRL1,
>  };
>  
>  static unsigned long exynos4x12_clk_save[] __initdata = {
> @@ -164,6 +181,8 @@ static unsigned long exynos4x12_clk_save[] __initdata = {
>         E4X12_DIV_ISP,
>         E4X12_DIV_CAM1,
>         E4X12_MPLL_CON0,
> +       PWR_CTRL1,
> +       E4X12_PWR_CTRL2,
>  };
>  
>  static unsigned long exynos4_clk_pll_regs[] __initdata = {
> @@ -1164,6 +1183,32 @@ static struct samsung_pll_clock exynos4x12_plls[nr_plls] __initdata = {
>                         VPLL_LOCK, VPLL_CON0, NULL),
>  };
>  
> +static void __init exynos4_core_down_clock(enum exynos4_soc soc)
> +{
> +       unsigned int tmp;
> +
> +       /*
> +        * Enable arm clock down (in idle) and set arm divider
> +        * ratios in WFI/WFE state.
> +        */
> +       tmp = (PWR_CTRL1_CORE2_DOWN_RATIO(7) | PWR_CTRL1_CORE1_DOWN_RATIO(7) |
> +               PWR_CTRL1_DIV2_DOWN_EN | PWR_CTRL1_DIV1_DOWN_EN |
> +               PWR_CTRL1_USE_CORE1_WFE | PWR_CTRL1_USE_CORE0_WFE |
> +               PWR_CTRL1_USE_CORE1_WFI | PWR_CTRL1_USE_CORE0_WFI);
> +       /* On Exynos4412 enable it also on core 2 and 3 */
> +       if (num_possible_cpus() == 4)
> +               tmp |= PWR_CTRL1_USE_CORE3_WFE | PWR_CTRL1_USE_CORE2_WFE |
> +                      PWR_CTRL1_USE_CORE3_WFI | PWR_CTRL1_USE_CORE2_WFI;
> +       __raw_writel(tmp, reg_base + PWR_CTRL1);
> +
> +       /*
> +        * Disable the clock up feature on Exynos4x12, in case it was
> +        * enabled by bootloader.
> +        */
> +       if (exynos4_soc == EXYNOS4X12)
> +               __raw_writel(0x0, reg_base + E4X12_PWR_CTRL2);
> +}
> +
>  /* register exynos4 clocks */
>  static void __init exynos4_clk_init(struct device_node *np,
>                                     enum exynos4_soc soc)
> @@ -1250,6 +1295,7 @@ static void __init exynos4_clk_init(struct device_node *np,
>         samsung_clk_register_alias(ctx, exynos4_aliases,
>                         ARRAY_SIZE(exynos4_aliases));
>  
> +       exynos4_core_down_clock(soc);
>         exynos4_clk_sleep_init();
>  
>         pr_info("%s clocks: sclk_apll = %ld, sclk_mpll = %ld\n"
> -- 
> 1.9.1
> 
