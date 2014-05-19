Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752739AbaESFy2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 01:54:28 -0400
Received: from mail-yk0-f182.google.com ([209.85.160.182]:63275 "EHLO
	mail-yk0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752675AbaESFyY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 01:54:24 -0400
MIME-Version: 1.0
In-Reply-To: <1399288539-1793-8-git-send-email-b.zolnierkie@samsung.com>
References: <1399288539-1793-1-git-send-email-b.zolnierkie@samsung.com>
	<1399288539-1793-8-git-send-email-b.zolnierkie@samsung.com>
Date: Mon, 19 May 2014 11:24:24 +0530
Message-ID: <CADGdYn77KQ2xMm+NjTQWC5s35pbw=PukSJhKVmM+EFmgTK6=yg@mail.gmail.com>
Subject: Re: [PATCH 07/10] thermal: exynos: simplify temp_to_code() and code_to_temp()
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
> * Remove dead temp check from temp_to_code() (this function users
>   in exynos_tmu_initialize() always pass correct temperatures and
>   exynos_tmu_set_emulation() returns early for EXYNOS4210 because
>   TMU_SUPPORT_EMULATION flag is not set on this SoC).
>
> * Move temp_code check from code_to_temp() to exynos_tmu_read()
>   (code_to_temp() only user).
>
> There should be no functional changes caused by this patch.
>
> Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>

Changes looks fine.
Reviewed-by: Amit Daniel Kachhap<amit.daniel@samsung.com>

> ---
>  drivers/thermal/samsung/exynos_tmu.c | 38
> +++++++++++-------------------------
>  1 file changed, 11 insertions(+), 27 deletions(-)
>
> diff --git a/drivers/thermal/samsung/exynos_tmu.c
> b/drivers/thermal/samsung/exynos_tmu.c
> index a415829..20379eb 100644
> --- a/drivers/thermal/samsung/exynos_tmu.c
> +++ b/drivers/thermal/samsung/exynos_tmu.c
> @@ -71,19 +71,7 @@ struct exynos_tmu_data {
>   */
>  static int temp_to_code(struct exynos_tmu_data *data, u8 temp)
>  {
> -	struct exynos_tmu_platform_data *pdata = data->pdata;
> -	int temp_code;
> -
> -	if (data->soc == SOC_ARCH_EXYNOS4210)
> -		/* temp should range between 25 and 125 */
> -		if (temp < 25 || temp > 125) {
> -			temp_code = -EINVAL;
> -			goto out;
> -		}
> -
> -	temp_code = temp + data->temp_error - pdata->first_point_trim;
> -out:
> -	return temp_code;
> +	return temp + data->temp_error - data->pdata->first_point_trim;
>  }
>
>  /*
> @@ -92,19 +80,7 @@ out:
>   */
>  static int code_to_temp(struct exynos_tmu_data *data, u8 temp_code)
>  {
> -	struct exynos_tmu_platform_data *pdata = data->pdata;
> -	int temp;
> -
> -	if (data->soc == SOC_ARCH_EXYNOS4210)
> -		/* temp_code should range between 75 and 175 */
> -		if (temp_code < 75 || temp_code > 175) {
> -			temp = -ENODATA;
> -			goto out;
> -		}
> -
> -	temp = temp_code - data->temp_error + pdata->first_point_trim;
> -out:
> -	return temp;
> +	return temp_code - data->temp_error + data->pdata->first_point_trim;
>  }
>
>  static int exynos_tmu_initialize(struct platform_device *pdev)
> @@ -297,8 +273,16 @@ static int exynos_tmu_read(struct exynos_tmu_data
> *data)
>  	clk_enable(data->clk);
>
>  	temp_code = readb(data->base + reg->tmu_cur_temp);
> -	temp = code_to_temp(data, temp_code);
>
> +	if (data->soc == SOC_ARCH_EXYNOS4210)
> +		/* temp_code should range between 75 and 175 */
> +		if (temp_code < 75 || temp_code > 175) {
> +			temp = -ENODATA;
> +			goto out;
> +		}
> +
> +	temp = code_to_temp(data, temp_code);
> +out:
>  	clk_disable(data->clk);
>  	mutex_unlock(&data->lock);
>
> --
> 1.8.2.3
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-samsung-soc"
> in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
