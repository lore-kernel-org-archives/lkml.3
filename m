Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752879AbaESF4Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 01:56:25 -0400
Received: from mail-yk0-f182.google.com ([209.85.160.182]:48793 "EHLO
	mail-yk0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750852AbaESF4U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 01:56:20 -0400
MIME-Version: 1.0
In-Reply-To: <1399288539-1793-9-git-send-email-b.zolnierkie@samsung.com>
References: <1399288539-1793-1-git-send-email-b.zolnierkie@samsung.com>
	<1399288539-1793-9-git-send-email-b.zolnierkie@samsung.com>
Date: Mon, 19 May 2014 11:26:20 +0530
Message-ID: <CADGdYn74P6zVhOoA5tTuN5_PCjUd6y13H=P2Ffii3Rqpx-fjcg@mail.gmail.com>
Subject: Re: [PATCH 08/10] thermal: exynos: cache non_hw_trigger_levels in pdata
From: Amit Kachhap <amit.kachhap@gmail.com>
To: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Cc: Eduardo Valentin <eduardo.valentin@ti.com>,
        Zhang Rui <rui.zhang@intel.com>, Tomasz Figa <t.figa@samsung.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-samsung-soc@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/5/14, Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com> wrote:
> Cache number of non-hardware trigger levels in a new pdata field
> (non_hw_trigger_levels) and convert code in exynos_tmu_initialize()
> accordingly.
Changes looks fine,
Reviewed-by: Amit Daniel Kachhap<amit.daniel@samsung.com>
>
> There should be no functional changes caused by this patch.
>
> Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
> ---
>  drivers/thermal/samsung/exynos_tmu.c      | 16 +++-------------
>  drivers/thermal/samsung/exynos_tmu.h      |  2 ++
>  drivers/thermal/samsung/exynos_tmu_data.c |  3 +++
>  3 files changed, 8 insertions(+), 13 deletions(-)
>
> diff --git a/drivers/thermal/samsung/exynos_tmu.c
> b/drivers/thermal/samsung/exynos_tmu.c
> index 20379eb..a8d9524 100644
> --- a/drivers/thermal/samsung/exynos_tmu.c
> +++ b/drivers/thermal/samsung/exynos_tmu.c
> @@ -90,7 +90,7 @@ static int exynos_tmu_initialize(struct platform_device
> *pdev)
>  	const struct exynos_tmu_registers *reg = pdata->registers;
>  	unsigned int status, trim_info = 0, con;
>  	unsigned int rising_threshold = 0, falling_threshold = 0;
> -	int ret = 0, threshold_code, i, trigger_levs = 0;
> +	int ret = 0, threshold_code, i;
>
>  	mutex_lock(&data->lock);
>  	clk_enable(data->clk);
> @@ -134,29 +134,19 @@ static int exynos_tmu_initialize(struct
> platform_device *pdev)
>  	    data->temp_error > pdata->max_efuse_value)
>  		data->temp_error = pdata->efuse_value & EXYNOS_TMU_TEMP_MASK;
>
> -	for (i = 0; i < pdata->max_trigger_level; i++) {
> -		if (!pdata->trigger_levels[i])
> -			continue;
> -
> -		/* Count trigger levels except the HW trip*/
> -		if (!(pdata->trigger_type[i] == HW_TRIP))
> -			trigger_levs++;
> -	}
> -
>  	if (data->soc == SOC_ARCH_EXYNOS4210) {
>  		/* Write temperature code for threshold */
>  		threshold_code = temp_to_code(data, pdata->threshold);
>  		writeb(threshold_code,
>  			data->base + reg->threshold_temp);
> -		for (i = 0; i < trigger_levs; i++)
> +		for (i = 0; i < pdata->non_hw_trigger_levels; i++)
>  			writeb(pdata->trigger_levels[i], data->base +
>  			reg->threshold_th0 + i * sizeof(reg->threshold_th0));
>
>  		writel(reg->inten_rise_mask, data->base + reg->tmu_intclear);
>  	} else {
>  		/* Write temperature code for rising and falling threshold */
> -		for (i = 0;
> -		i < trigger_levs && i < EXYNOS_MAX_TRIGGER_PER_REG; i++) {
> +		for (i = 0; i < pdata->non_hw_trigger_levels; i++) {
>  			threshold_code = temp_to_code(data,
>  						pdata->trigger_levels[i]);
>  			rising_threshold |= threshold_code << 8 * i;
> diff --git a/drivers/thermal/samsung/exynos_tmu.h
> b/drivers/thermal/samsung/exynos_tmu.h
> index 186e39e..4845171 100644
> --- a/drivers/thermal/samsung/exynos_tmu.h
> +++ b/drivers/thermal/samsung/exynos_tmu.h
> @@ -183,6 +183,7 @@ struct exynos_tmu_registers {
>   *	1 = enable trigger_level[] interrupt,
>   *	0 = disable trigger_level[] interrupt
>   * @max_trigger_level: max trigger level supported by the TMU
> + * @non_hw_trigger_levels: number of defined non-hardware trigger levels
>   * @gain: gain of amplifier in the positive-TC generator block
>   *	0 <= gain <= 15
>   * @reference_voltage: reference voltage of amplifier
> @@ -213,6 +214,7 @@ struct exynos_tmu_platform_data {
>  	enum trigger_type trigger_type[MAX_TRIP_COUNT];
>  	bool trigger_enable[MAX_TRIP_COUNT];
>  	u8 max_trigger_level;
> +	u8 non_hw_trigger_levels;
>  	u8 gain;
>  	u8 reference_voltage;
>  	u8 noise_cancel_mode;
> diff --git a/drivers/thermal/samsung/exynos_tmu_data.c
> b/drivers/thermal/samsung/exynos_tmu_data.c
> index c32d186..ef7f186 100644
> --- a/drivers/thermal/samsung/exynos_tmu_data.c
> +++ b/drivers/thermal/samsung/exynos_tmu_data.c
> @@ -62,6 +62,7 @@ struct exynos_tmu_init_data const
> exynos4210_default_tmu_data = {
>  		.trigger_type[1] = THROTTLE_ACTIVE,
>  		.trigger_type[2] = SW_TRIP,
>  		.max_trigger_level = 4,
> +		.non_hw_trigger_levels = 3,
>  		.gain = 15,
>  		.reference_voltage = 7,
>  		.min_efuse_value = 40,
> @@ -135,6 +136,7 @@ static const struct exynos_tmu_registers
> exynos4412_tmu_registers = {
>  	.trigger_type[2] = SW_TRIP, \
>  	.trigger_type[3] = HW_TRIP, \
>  	.max_trigger_level = 4, \
> +	.non_hw_trigger_levels = 3, \
>  	.gain = 8, \
>  	.reference_voltage = 16, \
>  	.noise_cancel_mode = 4, \
> @@ -225,6 +227,7 @@ static const struct exynos_tmu_registers
> exynos5440_tmu_registers = {
>  	.trigger_type[0] = SW_TRIP, \
>  	.trigger_type[4] = HW_TRIP, \
>  	.max_trigger_level = 5, \
> +	.non_hw_trigger_levels = 1, \
>  	.gain = 5, \
>  	.reference_voltage = 16, \
>  	.noise_cancel_mode = 4, \
> --
> 1.8.2.3
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
