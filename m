Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755254AbaE3IX0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 04:23:26 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:39003 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752202AbaE3IXX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 04:23:23 -0400
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfec7f5-b7f626d000004b39-83-53883ff814b2
Content-transfer-encoding: 8BIT
Message-id: <1401438205.9323.4.camel@AMDC1943>
Subject: Re: [PATCHv2 2/3] regulator: s2mps11: Add support S2MPU02 regulator
 device
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Chanwoo Choi <cw00.choi@samsung.com>
Cc: sbkim73@samsung.com, sameo@linux.intel.com, lee.jones@linaro.org,
        broonie@kernel.org, lgirdwood@gmail.com, linux-kernel@vger.kernel.org,
        myungjoo.ham@samsung.com, kyungmin.park@samsung.com,
        jonghwa3.lee@samsung.com
Date: Fri, 30 May 2014 10:23:25 +0200
In-reply-to: <1401409510-28238-3-git-send-email-cw00.choi@samsung.com>
References: <1401409510-28238-1-git-send-email-cw00.choi@samsung.com>
 <1401409510-28238-3-git-send-email-cw00.choi@samsung.com>
X-Mailer: Evolution 3.10.4-0ubuntu1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrALMWRmVeSWpSXmKPExsVy+t/xa7o/7DuCDT7OULCY+vAJm8X1L89Z
	LTrPPmG2ONv0ht3i/tejjBbfrnQwWVzeNYfN4nbjCjaL092sFhdXfGFy4PLYOesuu8emVZ1s
	Hneu7WHzmHcy0KNvyypGj8+b5ALYorhsUlJzMstSi/TtErgyVv97xFpwWqni7P5m1gbGW9Jd
	jJwcEgImEov3/mWCsMUkLtxbz9bFyMUhJLCUUeLko252kASvgKDEj8n3WLoYOTiYBeQljlzK
	BgkzC6hLTJq3iBmi/jOjxPWpjYwQ9XoSK6c8B7OFBUIlmt//BlvAJmAssXn5EjYQW0RAQ2Lm
	3yuMIM3MAvcYJVa+ncIMkmARUJV482YNC4jNKeAmcWHJBRaIDY2MEot7n7NDnKosMW//MaYJ
	jAKzkBw4C+HAWUgOXMDIvIpRNLU0uaA4KT3XSK84Mbe4NC9dLzk/dxMjJBa+7mBceszqEKMA
	B6MSD2+GS3uwEGtiWXFl7iFGCQ5mJRHerAdAId6UxMqq1KL8+KLSnNTiQ4xMHJxSDYxBMV/m
	p2/5YDvvPMPv6I2152La9qdrMTEFrTy+z3WZ7HynWq5+V0/u+Vy/UtcnKqSX7ZaKzOu6XPVr
	9tw2zpXtE2VcfULmaZYeYjd+sFP0l0hRTrr8LREdv96M0q4znvwzl/+rWnDARNC8h+1myobm
	32xxQsWsDR4122buD34Qk3LwwsdKFiWW4oxEQy3mouJEABaFA29jAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On pią, 2014-05-30 at 09:25 +0900, Chanwoo Choi wrote:
> This patch add S2MPU02 regulator device to existing S2MPS11 device driver
> because of little difference between S2MPS1x and S2MPU02. The S2MPU02
> regulator device includes LDO[1-28] and BUCK[1-7].
> 
> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
> [Add missing linear_min_sel of S2MPU02 LDO regulators by Jonghwa Lee]
> Signed-off-by: Jonghwa Lee <jonghwa3.lee@samsung.com>
> ---
>  drivers/mfd/sec-core.c              |  26 +++
>  drivers/regulator/s2mps11.c         | 319 +++++++++++++++++++++++++++++++++---
>  include/linux/mfd/samsung/s2mpu02.h | 200 ++++++++++++++++++++++
>  3 files changed, 525 insertions(+), 20 deletions(-)
>  create mode 100644 include/linux/mfd/samsung/s2mpu02.h
> 

(...)

> diff --git a/drivers/regulator/s2mps11.c b/drivers/regulator/s2mps11.c
> index 02e2fb2..f7e5dab3d 100644
> --- a/drivers/regulator/s2mps11.c
> +++ b/drivers/regulator/s2mps11.c
> @@ -31,6 +31,7 @@
>  #include <linux/mfd/samsung/core.h>
>  #include <linux/mfd/samsung/s2mps11.h>
>  #include <linux/mfd/samsung/s2mps14.h>
> +#include <linux/mfd/samsung/s2mpu02.h>
>  
>  struct s2mps11_info {
>  	unsigned int rdev_num;
> @@ -40,11 +41,15 @@ struct s2mps11_info {
>  	int ramp_delay16;
>  	int ramp_delay7810;
>  	int ramp_delay9;
> +
> +	enum sec_device_type dev_type;
> +
>  	/*
> -	 * One bit for each S2MPS14 regulator whether the suspend mode
> +	 * One bit for each S2MPS14/S2MPU02 regulator whether the suspend mode
>  	 * was enabled.
>  	 */
> -	unsigned int s2mps14_suspend_state:30;
> +	unsigned long long s2mps14_suspend_state:35;
> +
>  	/* Array of size rdev_num with GPIO-s for external sleep control */
>  	int *ext_control_gpio;
>  };
> @@ -415,12 +420,24 @@ static int s2mps14_regulator_enable(struct regulator_dev *rdev)
>  	struct s2mps11_info *s2mps11 = rdev_get_drvdata(rdev);
>  	unsigned int val;
>  
> -	if (s2mps11->s2mps14_suspend_state & (1 << rdev_get_id(rdev)))
> -		val = S2MPS14_ENABLE_SUSPEND;
> -	else if (gpio_is_valid(s2mps11->ext_control_gpio[rdev_get_id(rdev)]))
> -		val = S2MPS14_ENABLE_EXT_CONTROL;
> -	else
> -		val = rdev->desc->enable_mask;
> +	switch (s2mps11->dev_type) {
> +	case S2MPS14X:
> +		if (s2mps11->s2mps14_suspend_state & (1 << rdev_get_id(rdev)))
> +			val = S2MPS14_ENABLE_SUSPEND;
> +		else if (gpio_is_valid(s2mps11->ext_control_gpio[rdev_get_id(rdev)]))
> +			val = S2MPS14_ENABLE_EXT_CONTROL;
> +		else
> +			val = rdev->desc->enable_mask;
> +		break;
> +	case S2MPU02:
> +		if (s2mps11->s2mps14_suspend_state & (1 << rdev_get_id(rdev)))
> +			val = S2MPU02_ENABLE_SUSPEND;
> +		else
> +			val = rdev->desc->enable_mask;
> +		break;
> +	default:
> +		return -EINVAL;
> +	};
>  
>  	return regmap_update_bits(rdev->regmap, rdev->desc->enable_reg,
>  			rdev->desc->enable_mask, val);
> @@ -431,16 +448,42 @@ static int s2mps14_regulator_set_suspend_disable(struct regulator_dev *rdev)
>  	int ret;
>  	unsigned int val;
>  	struct s2mps11_info *s2mps11 = rdev_get_drvdata(rdev);
> +	int rdev_id = rdev_get_id(rdev);
>  
> -	/* LDO3 should be always on and does not support suspend mode */
> -	if (rdev_get_id(rdev) == S2MPS14_LDO3)
> -		return 0;
> +	/* Below LDO should be always on or does not support suspend mode. */
> +	switch (s2mps11->dev_type) {
> +	case S2MPS14X:
> +		switch (rdev_id) {
> +		case S2MPS14_LDO3:
> +			return 0;
> +		};
> +	case S2MPU02:
> +		switch (rdev_id) {
> +		case S2MPU02_LDO13:
> +		case S2MPU02_LDO14:
> +		case S2MPU02_LDO15:
> +		case S2MPU02_LDO16:
> +		case S2MPU02_LDO17:
> +		case S2MPU02_BUCK7:
> +			return 0;
> +		};
> +	default:
> +		return -EINVAL;
> +	};
>  
>  	ret = regmap_read(rdev->regmap, rdev->desc->enable_reg, &val);
>  	if (ret < 0)
>  		return ret;
>  
> -	s2mps11->s2mps14_suspend_state |= (1 << rdev_get_id(rdev));
> +	switch (s2mps11->dev_type) {
> +	case S2MPS14X:
> +	case S2MPU02:
> +		s2mps11->s2mps14_suspend_state |= (1 << rdev_get_id(rdev));
> +		break;
> +	default:
> +		return -EINVAL;
> +	};
> +

I think this change is not needed. You are actually returning EINVAL on
wrong devices in switch above so:
	s2mps11->s2mps14_suspend_state |= (1 << rdev_get_id(rdev));
would be safe and sufficient.

Anyway:
Reviewed-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>

Best regards,
Krzysztof

