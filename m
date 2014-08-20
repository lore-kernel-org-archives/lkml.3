Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752076AbaHTEvZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 00:51:25 -0400
Received: from mail-yk0-f175.google.com ([209.85.160.175]:54990 "EHLO
	mail-yk0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751280AbaHTEvX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 00:51:23 -0400
MIME-Version: 1.0
In-Reply-To: <1408492364-8012-1-git-send-email-cw00.choi@samsung.com>
References: <1408450078-6296-1-git-send-email-cw00.choi@samsung.com>
	<1408492364-8012-1-git-send-email-cw00.choi@samsung.com>
Date: Wed, 20 Aug 2014 10:21:21 +0530
X-Google-Sender-Auth: XngTv_CANrBNZj8OGI5gHw8OVvg
Message-ID: <CADGdYn45A2aYY97rmC2WkxnWfFitvdNNrYK-2Nt=VDrY6HyH_w@mail.gmail.com>
Subject: Re: [PATCHv3] thermal: exynos: Add support for TRIM_RELOAD feature at Exynos3250
From: amit daniel kachhap <amit.daniel@samsung.com>
To: Chanwoo Choi <cw00.choi@samsung.com>
Cc: Zhang Rui <rui.zhang@intel.com>,
        "Valentin, Eduardo" <eduardo.valentin@ti.com>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>,
        Lukasz Majewski <l.majewski@samsung.com>,
        naveen krishna <ch.naveen@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        devicetree@vger.kernel.org, LAK <linux-arm-kernel@lists.infradead.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Eduardo Valentin <edubezval@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 20, 2014 at 5:22 AM, Chanwoo Choi <cw00.choi@samsung.com> wrote:
> This patch add support for TRIM_RELOAD feature at Exynos3250. The TMU of
> Exynos3250 has two TRIMINFO_CON register.
>
> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
> Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
> Cc: Zhang Rui <rui.zhang@intel.com>
> Cc: Eduardo Valentin <edubezval@gmail.com>
> Cc: Amit Daniel Kachhap <amit.daniel@samsung.com>
The changes looks fine,
Reviewed-by: Amit Daniel Kachhap <amit.daniel@samsung.com>

Thanks,
Amit
> ---
> Changes from v2:
> - Fix build break because of missing 'or' operation.
> Changes from v1:
> - Add missing 'TMU_SUPPORT_TRIM_RELOAD' feature
>
>  drivers/thermal/samsung/exynos_tmu.c      |  7 +++++--
>  drivers/thermal/samsung/exynos_tmu.h      |  5 +++--
>  drivers/thermal/samsung/exynos_tmu_data.c | 11 +++++++++--
>  drivers/thermal/samsung/exynos_tmu_data.h |  7 +++++--
>  4 files changed, 22 insertions(+), 8 deletions(-)
>
> diff --git a/drivers/thermal/samsung/exynos_tmu.c b/drivers/thermal/samsung/exynos_tmu.c
> index acbff14..ed01606 100644
> --- a/drivers/thermal/samsung/exynos_tmu.c
> +++ b/drivers/thermal/samsung/exynos_tmu.c
> @@ -164,8 +164,11 @@ static int exynos_tmu_initialize(struct platform_device *pdev)
>                 }
>         }
>
> -       if (TMU_SUPPORTS(pdata, TRIM_RELOAD))
> -               __raw_writel(1, data->base + reg->triminfo_ctrl);
> +       if (TMU_SUPPORTS(pdata, TRIM_RELOAD)) {
> +               for (i = 0; i < pdata->triminfo_reload_count; i++)
> +                       __raw_writel(pdata->triminfo_reload[i],
> +                                       data->base + reg->triminfo_ctrl[i]);
> +       }
>
>         if (pdata->cal_mode == HW_MODE)
>                 goto skip_calib_data;
> diff --git a/drivers/thermal/samsung/exynos_tmu.h b/drivers/thermal/samsung/exynos_tmu.h
> index 1b4a644..72cb54e 100644
> --- a/drivers/thermal/samsung/exynos_tmu.h
> +++ b/drivers/thermal/samsung/exynos_tmu.h
> @@ -151,8 +151,7 @@ struct exynos_tmu_registers {
>         u32     triminfo_25_shift;
>         u32     triminfo_85_shift;
>
> -       u32     triminfo_ctrl;
> -       u32     triminfo_ctrl1;
> +       u32     triminfo_ctrl[2];
>         u32     triminfo_reload_shift;
>
>         u32     tmu_ctrl;
> @@ -295,6 +294,8 @@ struct exynos_tmu_platform_data {
>         u8 second_point_trim;
>         u8 default_temp_offset;
>         u8 test_mux;
> +       u8 triminfo_reload[2];
> +       u8 triminfo_reload_count;
>
>         enum calibration_type cal_type;
>         enum calibration_mode cal_mode;
> diff --git a/drivers/thermal/samsung/exynos_tmu_data.c b/drivers/thermal/samsung/exynos_tmu_data.c
> index aa8e0de..8cd609c 100644
> --- a/drivers/thermal/samsung/exynos_tmu_data.c
> +++ b/drivers/thermal/samsung/exynos_tmu_data.c
> @@ -95,6 +95,8 @@ static const struct exynos_tmu_registers exynos3250_tmu_registers = {
>         .triminfo_data = EXYNOS_TMU_REG_TRIMINFO,
>         .triminfo_25_shift = EXYNOS_TRIMINFO_25_SHIFT,
>         .triminfo_85_shift = EXYNOS_TRIMINFO_85_SHIFT,
> +       .triminfo_ctrl[0] = EXYNOS_TMU_TRIMINFO_CON1,
> +       .triminfo_ctrl[1] = EXYNOS_TMU_TRIMINFO_CON2,
>         .tmu_ctrl = EXYNOS_TMU_REG_CONTROL,
>         .test_mux_addr_shift = EXYNOS4412_MUX_ADDR_SHIFT,
>         .buf_vref_sel_shift = EXYNOS_TMU_REF_VOLTAGE_SHIFT,
> @@ -160,8 +162,11 @@ static const struct exynos_tmu_registers exynos3250_tmu_registers = {
>                 .temp_level = 95, \
>         }, \
>         .freq_tab_count = 2, \
> +       .triminfo_reload[0] = 0x1, \
> +       .triminfo_reload[1] = 0x11, \
> +       .triminfo_reload_count = 2, \
>         .registers = &exynos3250_tmu_registers, \
> -       .features = (TMU_SUPPORT_EMULATION | \
> +       .features = (TMU_SUPPORT_EMULATION | TMU_SUPPORT_TRIM_RELOAD | \
>                         TMU_SUPPORT_FALLING_TRIP | TMU_SUPPORT_READY_STATUS | \
>                         TMU_SUPPORT_EMUL_TIME)
>  #endif
> @@ -184,7 +189,7 @@ static const struct exynos_tmu_registers exynos4412_tmu_registers = {
>         .triminfo_data = EXYNOS_TMU_REG_TRIMINFO,
>         .triminfo_25_shift = EXYNOS_TRIMINFO_25_SHIFT,
>         .triminfo_85_shift = EXYNOS_TRIMINFO_85_SHIFT,
> -       .triminfo_ctrl = EXYNOS_TMU_TRIMINFO_CON,
> +       .triminfo_ctrl[0] = EXYNOS_TMU_TRIMINFO_CON2,
>         .triminfo_reload_shift = EXYNOS_TRIMINFO_RELOAD_SHIFT,
>         .tmu_ctrl = EXYNOS_TMU_REG_CONTROL,
>         .test_mux_addr_shift = EXYNOS4412_MUX_ADDR_SHIFT,
> @@ -252,6 +257,8 @@ static const struct exynos_tmu_registers exynos4412_tmu_registers = {
>                 .temp_level = 95, \
>         }, \
>         .freq_tab_count = 2, \
> +       .triminfo_reload[0] = 0x1, \
> +       .triminfo_reload_count = 1, \
>         .registers = &exynos4412_tmu_registers, \
>         .features = (TMU_SUPPORT_EMULATION | TMU_SUPPORT_TRIM_RELOAD | \
>                         TMU_SUPPORT_FALLING_TRIP | TMU_SUPPORT_READY_STATUS | \
> diff --git a/drivers/thermal/samsung/exynos_tmu_data.h b/drivers/thermal/samsung/exynos_tmu_data.h
> index f0979e5..e0536c3 100644
> --- a/drivers/thermal/samsung/exynos_tmu_data.h
> +++ b/drivers/thermal/samsung/exynos_tmu_data.h
> @@ -57,8 +57,11 @@
>  #define EXYNOS4210_TMU_TRIG_LEVEL_MASK 0x1111
>  #define EXYNOS4210_TMU_INTCLEAR_VAL    0x1111
>
> -/* Exynos5250 and Exynos4412 specific registers */
> -#define EXYNOS_TMU_TRIMINFO_CON        0x14
> +/* Exynos3250 specific registers */
> +#define EXYNOS_TMU_TRIMINFO_CON1       0x10
> +
> +/* Exynos5250, Exynos4412 and Exynos3250 specific registers */
> +#define EXYNOS_TMU_TRIMINFO_CON2       0x14
>  #define EXYNOS_THD_TEMP_RISE           0x50
>  #define EXYNOS_THD_TEMP_FALL           0x54
>  #define EXYNOS_EMUL_CON                0x80
> --
> 1.8.0
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
