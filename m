Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750984AbaKYPuz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 10:50:55 -0500
Received: from mail-ig0-f172.google.com ([209.85.213.172]:39296 "EHLO
	mail-ig0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750792AbaKYPuy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 10:50:54 -0500
Date: Tue, 25 Nov 2014 15:50:45 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Chanwoo Choi <cw00.choi@samsung.com>
Cc: broonie@kernel.org, mturquette@linaro.org, a.zummo@towertech.it,
        lgirdwood@gmail.com, sbkim73@samsung.com, sameo@linux.intel.com,
        geunsik.lim@samsung.com, inki.dae@samsung.com,
        kyungmin.park@samsung.com, k.kozlowski@samsung.com,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Subject: Re: [PATCHv2 1/5] mfd: sec-core: Add support for S2MPS13 device
Message-ID: <20141125155045.GK4241@x1>
References: <1416301183-10478-1-git-send-email-cw00.choi@samsung.com>
 <1416301183-10478-2-git-send-email-cw00.choi@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1416301183-10478-2-git-send-email-cw00.choi@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 Nov 2014, Chanwoo Choi wrote:

> This patch adds the support for Samsung S2MPS13 PMIC device to the sec-core MFD
> driver. The S2MPS13 is very similar with existing S2MPS14 and includes PMIC/
> RTC/CLOCK devices.
> 
> Cc: Lee Jones <lee.jones@linaro.org>
> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
> Acked-by: Sangbeom Kim <sbkim73@samsung.com>
> Acked-by: Lee Jones <lee.jones@linaro.org>
> ---
>  drivers/mfd/sec-core.c           | 16 ++++++++++++++++
>  drivers/mfd/sec-irq.c            | 23 +++++++++++++++++------
>  include/linux/mfd/samsung/core.h |  1 +
>  3 files changed, 34 insertions(+), 6 deletions(-)

Applied, thanks.

> diff --git a/drivers/mfd/sec-core.c b/drivers/mfd/sec-core.c
> index 5993608..868f03d 100644
> --- a/drivers/mfd/sec-core.c
> +++ b/drivers/mfd/sec-core.c
> @@ -73,6 +73,15 @@ static const struct mfd_cell s2mps11_devs[] = {
>  	}
>  };
>  
> +static const struct mfd_cell s2mps13_devs[] = {
> +	{ .name = "s2mps13-pmic", },
> +	{ .name = "s2mps13-rtc", },
> +	{
> +		.name = "s2mps13-clk",
> +		.of_compatible = "samsung,s2mps13-clk",
> +	},
> +};
> +
>  static const struct mfd_cell s2mps14_devs[] = {
>  	{
>  		.name = "s2mps14-pmic",
> @@ -107,6 +116,9 @@ static const struct of_device_id sec_dt_match[] = {
>  		.compatible = "samsung,s2mps11-pmic",
>  		.data = (void *)S2MPS11X,
>  	}, {
> +		.compatible = "samsung,s2mps13-pmic",
> +		.data = (void *)S2MPS13X,
> +	}, {
>  		.compatible = "samsung,s2mps14-pmic",
>  		.data = (void *)S2MPS14X,
>  	}, {
> @@ -377,6 +389,10 @@ static int sec_pmic_probe(struct i2c_client *i2c,
>  		sec_devs = s2mps11_devs;
>  		num_sec_devs = ARRAY_SIZE(s2mps11_devs);
>  		break;
> +	case S2MPS13X:
> +		sec_devs = s2mps13_devs;
> +		num_sec_devs = ARRAY_SIZE(s2mps13_devs);
> +		break;
>  	case S2MPS14X:
>  		sec_devs = s2mps14_devs;
>  		num_sec_devs = ARRAY_SIZE(s2mps14_devs);
> diff --git a/drivers/mfd/sec-irq.c b/drivers/mfd/sec-irq.c
> index f9a5786..ba86a91 100644
> --- a/drivers/mfd/sec-irq.c
> +++ b/drivers/mfd/sec-irq.c
> @@ -389,14 +389,22 @@ static const struct regmap_irq_chip s2mps11_irq_chip = {
>  	.ack_base = S2MPS11_REG_INT1,
>  };
>  
> +#define S2MPS1X_IRQ_CHIP_COMMON_DATA		\
> +	.irqs = s2mps14_irqs,			\
> +	.num_irqs = ARRAY_SIZE(s2mps14_irqs),	\
> +	.num_regs = 3,				\
> +	.status_base = S2MPS14_REG_INT1,	\
> +	.mask_base = S2MPS14_REG_INT1M,		\
> +	.ack_base = S2MPS14_REG_INT1		\
> +
> +static const struct regmap_irq_chip s2mps13_irq_chip = {
> +	.name = "s2mps13",
> +	S2MPS1X_IRQ_CHIP_COMMON_DATA,
> +};
> +
>  static const struct regmap_irq_chip s2mps14_irq_chip = {
>  	.name = "s2mps14",
> -	.irqs = s2mps14_irqs,
> -	.num_irqs = ARRAY_SIZE(s2mps14_irqs),
> -	.num_regs = 3,
> -	.status_base = S2MPS14_REG_INT1,
> -	.mask_base = S2MPS14_REG_INT1M,
> -	.ack_base = S2MPS14_REG_INT1,
> +	S2MPS1X_IRQ_CHIP_COMMON_DATA,
>  };
>  
>  static const struct regmap_irq_chip s2mpu02_irq_chip = {
> @@ -452,6 +460,9 @@ int sec_irq_init(struct sec_pmic_dev *sec_pmic)
>  	case S2MPS11X:
>  		sec_irq_chip = &s2mps11_irq_chip;
>  		break;
> +	case S2MPS13X:
> +		sec_irq_chip = &s2mps13_irq_chip;
> +		break;
>  	case S2MPS14X:
>  		sec_irq_chip = &s2mps14_irq_chip;
>  		break;
> diff --git a/include/linux/mfd/samsung/core.h b/include/linux/mfd/samsung/core.h
> index 1825eda..0c0343e 100644
> --- a/include/linux/mfd/samsung/core.h
> +++ b/include/linux/mfd/samsung/core.h
> @@ -41,6 +41,7 @@ enum sec_device_type {
>  	S5M8767X,
>  	S2MPA01,
>  	S2MPS11X,
> +	S2MPS13X,
>  	S2MPS14X,
>  	S2MPU02,
>  };

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
