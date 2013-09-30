Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755265Ab3I3L71 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 07:59:27 -0400
Received: from mail-ie0-f181.google.com ([209.85.223.181]:38780 "EHLO
	mail-ie0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754787Ab3I3L7W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 07:59:22 -0400
MIME-Version: 1.0
In-Reply-To: <1380010102-25817-4-git-send-email-l.majewski@samsung.com>
References: <1380010102-25817-1-git-send-email-l.majewski@samsung.com>
	<1380010102-25817-4-git-send-email-l.majewski@samsung.com>
Date: Mon, 30 Sep 2013 17:29:21 +0530
X-Google-Sender-Auth: 0MKzwR-zI8Eleax2QtNPve3cpRo
Message-ID: <CADGdYn6a1jSR17v0N6kVFZFsn71FUbXJHjeSya-xy_wX9GtYpg@mail.gmail.com>
Subject: Re: [PATCH 3/6] thermal: exynos: Provide initial setting for TMU's
 test MUX address at Exynos4412
From: amit daniel kachhap <amit.daniel@samsung.com>
To: Lukasz Majewski <l.majewski@samsung.com>
Cc: Zhang Rui <rui.zhang@intel.com>,
        Eduardo Valentin <eduardo.valentin@ti.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Jonghwa Lee <jonghwa3.lee@samsung.com>,
        Lukasz Majewski <l.majewski@majess.pl>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>,
        Myungjoo Ham <myungjoo.ham@samsung.com>, devicetree@vger.kernel.org,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Sep 24, 2013 at 1:38 PM, Lukasz Majewski <l.majewski@samsung.com> wrote:
> The commit d0a0ce3e77c795258d47f9163e92d5031d0c5221 ("thermal: exynos: Add
> missing definations and code cleanup") has removed setting of test MUX address
> value at TMU configuration setting.
>
> This field is not present on Exynos4210 and Exynos5 SoCs. However on Exynos4412
> SoC it is required to set this field after reset because without it TMU shows
> maximal available temperature, which causes immediate platform shutdown.
Right In 5250 this field is not defined so didn't catch this. The
changes looks fine but I have a minor comment that if this field is
defined in 4412 in detail then you can add a field entry in
exynos_tmu_registers with proper name and populate this field. The
good thing is that in 5250 also this field is reserved and the default
value is 0x6 so same TMU_DATA can be used for 5250 and 4412. The main
idea of this suggestion is to reduce the soc checks in the driver.

Thanks,
Amit Daniel
>
> Signed-off-by: Lukasz Majewski <l.majewski@samsung.com>
> Reviewed-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
> Reviewed-by: Tomasz Figa <t.figa@samsung.com>
> ---
>  drivers/thermal/samsung/exynos_tmu.c      |    3 +++
>  drivers/thermal/samsung/exynos_tmu_data.h |    4 ++++
>  2 files changed, 7 insertions(+)
>
> diff --git a/drivers/thermal/samsung/exynos_tmu.c b/drivers/thermal/samsung/exynos_tmu.c
> index a858cc4..21b89e4 100644
> --- a/drivers/thermal/samsung/exynos_tmu.c
> +++ b/drivers/thermal/samsung/exynos_tmu.c
> @@ -317,6 +317,9 @@ static void exynos_tmu_control(struct platform_device *pdev, bool on)
>
>         con = readl(data->base + reg->tmu_ctrl);
>
> +       if (pdata->type == SOC_ARCH_EXYNOS4412)
> +               con |= (EXYNOS4412_MUX_ADDR_VALUE << EXYNOS4412_MUX_ADDR_SHIFT);
> +
>         if (pdata->reference_voltage) {
>                 con &= ~(reg->buf_vref_sel_mask << reg->buf_vref_sel_shift);
>                 con |= pdata->reference_voltage << reg->buf_vref_sel_shift;
> diff --git a/drivers/thermal/samsung/exynos_tmu_data.h b/drivers/thermal/samsung/exynos_tmu_data.h
> index b130b1e..a1ea19d 100644
> --- a/drivers/thermal/samsung/exynos_tmu_data.h
> +++ b/drivers/thermal/samsung/exynos_tmu_data.h
> @@ -95,6 +95,10 @@
>
>  #define EXYNOS_MAX_TRIGGER_PER_REG     4
>
> +/* Exynos4412 specific */
> +#define EXYNOS4412_MUX_ADDR_VALUE          6
> +#define EXYNOS4412_MUX_ADDR_SHIFT          20
> +
>  /*exynos5440 specific registers*/
>  #define EXYNOS5440_TMU_S0_7_TRIM               0x000
>  #define EXYNOS5440_TMU_S0_7_CTRL               0x020
> --
> 1.7.10.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

On Tue, Sep 24, 2013 at 1:38 PM, Lukasz Majewski <l.majewski@samsung.com> wrote:
> The commit d0a0ce3e77c795258d47f9163e92d5031d0c5221 ("thermal: exynos: Add
> missing definations and code cleanup") has removed setting of test MUX address
> value at TMU configuration setting.
>
> This field is not present on Exynos4210 and Exynos5 SoCs. However on Exynos4412
> SoC it is required to set this field after reset because without it TMU shows
> maximal available temperature, which causes immediate platform shutdown.
>
> Signed-off-by: Lukasz Majewski <l.majewski@samsung.com>
> Reviewed-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
> Reviewed-by: Tomasz Figa <t.figa@samsung.com>
> ---
>  drivers/thermal/samsung/exynos_tmu.c      |    3 +++
>  drivers/thermal/samsung/exynos_tmu_data.h |    4 ++++
>  2 files changed, 7 insertions(+)
>
> diff --git a/drivers/thermal/samsung/exynos_tmu.c b/drivers/thermal/samsung/exynos_tmu.c
> index a858cc4..21b89e4 100644
> --- a/drivers/thermal/samsung/exynos_tmu.c
> +++ b/drivers/thermal/samsung/exynos_tmu.c
> @@ -317,6 +317,9 @@ static void exynos_tmu_control(struct platform_device *pdev, bool on)
>
>         con = readl(data->base + reg->tmu_ctrl);
>
> +       if (pdata->type == SOC_ARCH_EXYNOS4412)
> +               con |= (EXYNOS4412_MUX_ADDR_VALUE << EXYNOS4412_MUX_ADDR_SHIFT);
> +
>         if (pdata->reference_voltage) {
>                 con &= ~(reg->buf_vref_sel_mask << reg->buf_vref_sel_shift);
>                 con |= pdata->reference_voltage << reg->buf_vref_sel_shift;
> diff --git a/drivers/thermal/samsung/exynos_tmu_data.h b/drivers/thermal/samsung/exynos_tmu_data.h
> index b130b1e..a1ea19d 100644
> --- a/drivers/thermal/samsung/exynos_tmu_data.h
> +++ b/drivers/thermal/samsung/exynos_tmu_data.h
> @@ -95,6 +95,10 @@
>
>  #define EXYNOS_MAX_TRIGGER_PER_REG     4
>
> +/* Exynos4412 specific */
> +#define EXYNOS4412_MUX_ADDR_VALUE          6
> +#define EXYNOS4412_MUX_ADDR_SHIFT          20
> +
>  /*exynos5440 specific registers*/
>  #define EXYNOS5440_TMU_S0_7_TRIM               0x000
>  #define EXYNOS5440_TMU_S0_7_CTRL               0x020
> --
> 1.7.10.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
