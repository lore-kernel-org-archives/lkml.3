Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932440AbaEGJsS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 05:48:18 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:40006 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754715AbaEGJsQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 05:48:16 -0400
X-AuditID: cbfec7f5-b7fae6d000004d6d-ad-536a015d30b4
Message-id: <1399456105.15392.3.camel@AMDC1943>
Subject: Re: [PATCH v2 1/3] regulator: s2mps11: Fix accidental enable of buck6
 ramp delay
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Mark Brown <broonie@kernel.org>
Cc: Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org,
        Sachin Kamat <sachin.kamat@linaro.org>, Axel Lin <axel.lin@ingics.com>,
        Sangbeom Kim <sbkim73@samsung.com>
Date: Wed, 07 May 2014 11:48:25 +0200
In-reply-to: <1399358258-21536-1-git-send-email-k.kozlowski@samsung.com>
References: <1399358258-21536-1-git-send-email-k.kozlowski@samsung.com>
Content-type: text/plain; charset=UTF-8
X-Mailer: Evolution 3.10.4-0ubuntu1
MIME-version: 1.0
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrLLMWRmVeSWpSXmKPExsVy+t/xa7qxjFnBBifbZS2OzPnKbDH14RM2
	i29XOpgsLu+aw2Zx8k8vo8XFFV+YHNg8ds66y+7R9rPMY9OqTjaPO9f2sHn0bVnF6PF5k1wA
	WxSXTUpqTmZZapG+XQJXRseWbWwFj/krJs84w97AeJWni5GTQ0LARGJ60z5GCFtM4sK99Wxd
	jFwcQgJLGSUmPD/NCuF8ZpTYP3UbUxcjBwevgL7E8heKIA3CAtESK46dA2tmEzCW2Lx8CRuI
	LSKgLHH1+14WkF5mga2MEuuWt7GCJFgEVCVWtS9jBrE5BTwk3qzZBhYXEnCXWHr+PjuIzSyg
	LjFp3iJmiIuUJebtP8YEYvMKCEr8mHyPBaJGXmLzmrfMExgFZiFpmYWkbBaSsgWMzKsYRVNL
	kwuKk9JzjfSKE3OLS/PS9ZLzczcxQoL86w7GpcesDjEKcDAq8fAukMkIFmJNLCuuzD3EKMHB
	rCTCa/k3M1iINyWxsiq1KD++qDQntfgQIxMHp1QD43SVcMbZSnsO2vjn8THKKC04Om37vJcs
	zo2sz1eqfV61f4V4jNMP8SO3TMx+7Zv+fdGLZUJL9mS8OqFxoM3OgOt1nrOKbSGzjIolw6Wf
	a9hZV7c2mlcUKVS9qM4W37ZM/ar+ywslmzgE5rO/qyv5/05Ob/VfiY1H407dv/KHvcnfrV3v
	1WTVeCWW4oxEQy3mouJEAKnHSS9QAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I forgot to CC the stable.

Mark, if the patches are OK and if you'll apply them, could you add a CC
stable to the commit msg?

Best regards,
Krzysztof


On wto, 2014-05-06 at 08:37 +0200, Krzysztof Kozlowski wrote:
> S2MPS11 supports enabling/disabling ramp delay only for buck[2346].
> Other bucks have ramp delay enabled always.
> 
> However the bit shift for enabling buck6 ramp delay in register is equal
> to 0. When ramp delay was set for the bucks unsupporting enable/disable
> (buck[15789] and buck10), the ramp delay for buck6 was also enabled.
> 
> Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> Fixes: b96244fad953 ("regulator: s2mps11: Don't check enable_shift before setting enable ramp rate")
> ---
> 
> Changes since v2:
>  * Apply Axel Lin's suggestion (don't change the meaning
>    of enable_shift variable).
> 
> ---
>  drivers/regulator/s2mps11.c | 15 ++++++++++-----
>  1 file changed, 10 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/regulator/s2mps11.c b/drivers/regulator/s2mps11.c
> index e713c162fbd4..aaca37e1424f 100644
> --- a/drivers/regulator/s2mps11.c
> +++ b/drivers/regulator/s2mps11.c
> @@ -202,11 +202,16 @@ static int s2mps11_set_ramp_delay(struct regulator_dev *rdev, int ramp_delay)
>  	if (!ramp_enable)
>  		goto ramp_disable;
>  
> -	ret = regmap_update_bits(rdev->regmap, S2MPS11_REG_RAMP,
> -				 1 << enable_shift, 1 << enable_shift);
> -	if (ret) {
> -		dev_err(&rdev->dev, "failed to enable ramp rate\n");
> -		return ret;
> +	/* Ramp delay can be enabled/disabled only for buck[2346] */
> +	if ((rdev_get_id(rdev) >= S2MPS11_BUCK2 &&
> +			rdev_get_id(rdev) <= S2MPS11_BUCK4) ||
> +			rdev_get_id(rdev) == S2MPS11_BUCK6)  {
> +		ret = regmap_update_bits(rdev->regmap, S2MPS11_REG_RAMP,
> +					 1 << enable_shift, 1 << enable_shift);
> +		if (ret) {
> +			dev_err(&rdev->dev, "failed to enable ramp rate\n");
> +			return ret;
> +		}
>  	}
>  
>  	ramp_val = get_ramp_delay(ramp_delay);

