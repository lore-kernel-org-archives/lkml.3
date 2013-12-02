Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752585Ab3LBIDd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 03:03:33 -0500
Received: from nasmtp02.atmel.com ([204.2.163.16]:28804 "EHLO
	SJOEDG01.corp.atmel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751049Ab3LBIDb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 03:03:31 -0500
Message-ID: <529C3E69.1080902@atmel.com>
Date: Mon, 2 Dec 2013 16:01:45 +0800
From: Bo Shen <voice.shen@atmel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@gmail.com>
CC: <linux-pwm@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <nicolas.ferre@atmel.com>, <linux-kernel@vger.kernel.org>,
        <alexandre.belloni@free-electrons.com>, <galak@codeaurora.org>,
        <plagnioj@jcrosoft.com>, <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v8 1/2] PWM: atmel-pwm: add PWM controller driver
References: <1384766002-2852-1-git-send-email-voice.shen@atmel.com>
In-Reply-To: <1384766002-2852-1-git-send-email-voice.shen@atmel.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.168.5.13]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thierry,

On 11/18/2013 05:13 PM, Bo Shen wrote:
> Add Atmel PWM controller driver based on PWM framework.
>
> This is the basic function implementation of Atmel PWM controller.
> It can work with PWM based led and backlight.
>
> Signed-off-by: Bo Shen <voice.shen@atmel.com>
>
> Acked-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
> Acked-by: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
> ---
> Changes in v8:
>    - replace pr_err by dev_err
>
> Changes in v7:
>    - fix issue for none device tree issues.
>
> Changes in v6:
>    - using relaxed version for writel and readl
>    - add none device tree support
>    - change some define from lower case to upper case
>    - split device tree binding document as a separate patch
>
> Changes in v5:
>    - call clk_disable directly, if so, it won't cause more than one channel
>      enabled, the clock can not be disabled.
>
> Changes in v4:
>    - check the return value of clk_prepare()
>    - change channel register size as constant
>
> Changes in v3:
>    - change compatible string from "atmel,sama5-pwm" to "atmel,sama5d3-pwm"
>    - Add PWM led example in binding documentation
>    - Using micro replace hard code
>
> Changes in v2:
>    - Address the comments from Thierry Reding
>
>   drivers/pwm/Kconfig     |    9 ++
>   drivers/pwm/Makefile    |    1 +
>   drivers/pwm/pwm-atmel.c |  380 +++++++++++++++++++++++++++++++++++++++++++++++
>   3 files changed, 390 insertions(+)
>   create mode 100644 drivers/pwm/pwm-atmel.c

Any new comments on this patch series?

Best Regards,
Bo Shen

> diff --git a/drivers/pwm/Kconfig b/drivers/pwm/Kconfig
> index eece329..5043572 100644
> --- a/drivers/pwm/Kconfig
> +++ b/drivers/pwm/Kconfig
> @@ -41,6 +41,15 @@ config PWM_AB8500
>   	  To compile this driver as a module, choose M here: the module
>   	  will be called pwm-ab8500.
>
> +config PWM_ATMEL
> +	tristate "Atmel PWM support"
> +	depends on ARCH_AT91
> +	help
> +	  Generic PWM framework driver for Atmel SoC.
> +
> +	  To compile this driver as a module, choose M here: the module
> +	  will be called pwm-atmel.
> +
>   config PWM_ATMEL_TCB
>   	tristate "Atmel TC Block PWM support"
>   	depends on ATMEL_TCLIB && OF
> diff --git a/drivers/pwm/Makefile b/drivers/pwm/Makefile
> index 8b754e4..1b99cfb 100644
> --- a/drivers/pwm/Makefile
> +++ b/drivers/pwm/Makefile
> @@ -1,6 +1,7 @@
>   obj-$(CONFIG_PWM)		+= core.o
>   obj-$(CONFIG_PWM_SYSFS)		+= sysfs.o
>   obj-$(CONFIG_PWM_AB8500)	+= pwm-ab8500.o
> +obj-$(CONFIG_PWM_ATMEL)		+= pwm-atmel.o
>   obj-$(CONFIG_PWM_ATMEL_TCB)	+= pwm-atmel-tcb.o
>   obj-$(CONFIG_PWM_BFIN)		+= pwm-bfin.o
>   obj-$(CONFIG_PWM_EP93XX)	+= pwm-ep93xx.o
> diff --git a/drivers/pwm/pwm-atmel.c b/drivers/pwm/pwm-atmel.c
> new file mode 100644
> index 0000000..67cbac2
> --- /dev/null
> +++ b/drivers/pwm/pwm-atmel.c
> @@ -0,0 +1,380 @@
> +/*
> + * Driver for Atmel Pulse Width Modulation Controller
> + *
> + * Copyright (C) 2013 Atmel Corporation
> + *		 Bo Shen <voice.shen@atmel.com>
> + *
> + * Licensed under GPLv2.
> + */
> +
> +#include <linux/clk.h>
> +#include <linux/err.h>
> +#include <linux/io.h>
> +#include <linux/module.h>
> +#include <linux/of.h>
> +#include <linux/of_device.h>
> +#include <linux/platform_device.h>
> +#include <linux/pwm.h>
> +#include <linux/slab.h>
> +
> +/* The following is global registers for PWM controller */
> +#define PWM_ENA			0x04
> +#define PWM_DIS			0x08
> +#define PWM_SR			0x0C
> +/* Bit field in SR */
> +#define PWM_SR_ALL_CH_ON	0x0F
> +
> +/* The following register is PWM channel related registers */
> +#define PWM_CH_REG_OFFSET	0x200
> +#define PWM_CH_REG_SIZE		0x20
> +
> +#define PWM_CMR			0x0
> +/* Bit field in CMR */
> +#define PWM_CMR_CPOL		(1 << 9)
> +#define PWM_CMR_UPD_CDTY	(1 << 10)
> +
> +/* The following registers for PWM v1 */
> +#define PWMV1_CDTY		0x04
> +#define PWMV1_CPRD		0x08
> +#define PWMV1_CUPD		0x10
> +
> +/* The following registers for PWM v2 */
> +#define PWMV2_CDTY		0x04
> +#define PWMV2_CDTYUPD		0x08
> +#define PWMV2_CPRD		0x0C
> +#define PWMV2_CPRDUPD		0x10
> +
> +/* Max value for duty and period
> + *
> + * Although the duty and period register is 32 bit,
> + * however only the LSB 16 bits are significant.
> + */
> +#define PWM_MAX_DTY		0xFFFF
> +#define PWM_MAX_PRD		0xFFFF
> +#define PRD_MAX_PRES		10
> +
> +struct atmel_pwm_chip {
> +	struct pwm_chip chip;
> +	struct clk *clk;
> +	void __iomem *base;
> +
> +	void (*config)(struct pwm_chip *chip, struct pwm_device *pwm,
> +		       int dty, int prd);
> +};
> +
> +static inline struct atmel_pwm_chip *to_atmel_pwm_chip(struct pwm_chip *chip)
> +{
> +	return container_of(chip, struct atmel_pwm_chip, chip);
> +}
> +
> +static inline u32 atmel_pwm_readl(struct atmel_pwm_chip *chip,
> +				  unsigned long offset)
> +{
> +	return readl_relaxed(chip->base + offset);
> +}
> +
> +static inline void atmel_pwm_writel(struct atmel_pwm_chip *chip,
> +				    unsigned long offset, unsigned long val)
> +{
> +	writel_relaxed(val, chip->base + offset);
> +}
> +
> +static inline u32 atmel_pwm_ch_readl(struct atmel_pwm_chip *chip,
> +				     unsigned int ch, unsigned long offset)
> +{
> +	return readl_relaxed(chip->base + PWM_CH_REG_OFFSET +
> +			ch * PWM_CH_REG_SIZE + offset);
> +}
> +
> +static inline void atmel_pwm_ch_writel(struct atmel_pwm_chip *chip,
> +				       unsigned int ch, unsigned long offset,
> +				       unsigned long val)
> +{
> +	writel_relaxed(val, chip->base + PWM_CH_REG_OFFSET +
> +			ch * PWM_CH_REG_SIZE + offset);
> +}
> +
> +static int atmel_pwm_config(struct pwm_chip *chip, struct pwm_device *pwm,
> +		int duty_ns, int period_ns)
> +{
> +	struct atmel_pwm_chip *atmel_pwm = to_atmel_pwm_chip(chip);
> +	unsigned long clk_rate, prd, dty;
> +	unsigned long long div;
> +	int ret, pres = 0;
> +
> +	clk_rate = clk_get_rate(atmel_pwm->clk);
> +	div = clk_rate;
> +
> +	/* Calculate the period cycles */
> +	while (div > PWM_MAX_PRD) {
> +		div = clk_rate / (1 << pres);
> +		div = div * period_ns;
> +		/* 1/Hz = 100000000 ns */
> +		do_div(div, 1000000000);
> +
> +		if (pres++ > PRD_MAX_PRES) {
> +			dev_err(chip->dev, "pres exceed the maximum value\n");
> +			return -EINVAL;
> +		}
> +	}
> +
> +	/* Calculate the duty cycles */
> +	prd = div;
> +	div *= duty_ns;
> +	do_div(div, period_ns);
> +	dty = div;
> +
> +	ret = clk_enable(atmel_pwm->clk);
> +	if (ret) {
> +		dev_err(chip->dev, "failed to enable pwm clock\n");
> +		return ret;
> +	}
> +
> +	atmel_pwm_ch_writel(atmel_pwm, pwm->hwpwm, PWM_CMR, pres);
> +	atmel_pwm->config(chip, pwm, dty, prd);
> +
> +	clk_disable(atmel_pwm->clk);
> +
> +	return 0;
> +}
> +
> +static void atmel_pwm_config_v1(struct pwm_chip *chip, struct pwm_device *pwm,
> +				int dty, int prd)
> +{
> +	struct atmel_pwm_chip *atmel_pwm = to_atmel_pwm_chip(chip);
> +	unsigned int val;
> +
> +	/*
> +	 * If the PWM channel is disabled, write value to duty and period
> +	 * registers directly.
> +	 * If the PWM channel is enabled, using the update register, it needs
> +	 * to set bit 10 of CMR to 0
> +	 */
> +	if (test_bit(PWMF_ENABLED, &pwm->flags)) {
> +		atmel_pwm_ch_writel(atmel_pwm, pwm->hwpwm, PWMV1_CUPD, dty);
> +
> +		val = atmel_pwm_ch_readl(atmel_pwm, pwm->hwpwm, PWM_CMR);
> +		val &= ~PWM_CMR_UPD_CDTY;
> +		atmel_pwm_ch_writel(atmel_pwm, pwm->hwpwm, PWM_CMR, val);
> +	} else {
> +		atmel_pwm_ch_writel(atmel_pwm, pwm->hwpwm, PWMV1_CDTY, dty);
> +		atmel_pwm_ch_writel(atmel_pwm, pwm->hwpwm, PWMV1_CPRD, prd);
> +	}
> +}
> +
> +static void atmel_pwm_config_v2(struct pwm_chip *chip, struct pwm_device *pwm,
> +				int dty, int prd)
> +{
> +	struct atmel_pwm_chip *atmel_pwm = to_atmel_pwm_chip(chip);
> +
> +	/*
> +	 * If the PWM channel is disabled, write value to duty and period
> +	 * registers directly.
> +	 * If the PWM channel is enabled, using the duty update register to
> +	 * update the value.
> +	 */
> +	if (test_bit(PWMF_ENABLED, &pwm->flags)) {
> +		atmel_pwm_ch_writel(atmel_pwm, pwm->hwpwm, PWMV2_CDTYUPD, dty);
> +	} else {
> +		atmel_pwm_ch_writel(atmel_pwm, pwm->hwpwm, PWMV2_CDTY, dty);
> +		atmel_pwm_ch_writel(atmel_pwm, pwm->hwpwm, PWMV2_CPRD, prd);
> +	}
> +}
> +
> +static int atmel_pwm_set_polarity(struct pwm_chip *chip, struct pwm_device *pwm,
> +		enum pwm_polarity polarity)
> +{
> +	struct atmel_pwm_chip *atmel_pwm = to_atmel_pwm_chip(chip);
> +	u32 val = 0;
> +	int ret;
> +
> +	if (polarity == PWM_POLARITY_NORMAL)
> +		val &= ~PWM_CMR_CPOL;
> +	else
> +		val |= PWM_CMR_CPOL;
> +
> +	ret = clk_enable(atmel_pwm->clk);
> +	if (ret) {
> +		dev_err(chip->dev, "failed to enable pwm clock\n");
> +		return ret;
> +	}
> +
> +	atmel_pwm_ch_writel(atmel_pwm, pwm->hwpwm, PWM_CMR, val);
> +
> +	clk_disable(atmel_pwm->clk);
> +
> +	return 0;
> +}
> +
> +static int atmel_pwm_enable(struct pwm_chip *chip, struct pwm_device *pwm)
> +{
> +	struct atmel_pwm_chip *atmel_pwm = to_atmel_pwm_chip(chip);
> +	int ret;
> +
> +	ret = clk_enable(atmel_pwm->clk);
> +	if (ret) {
> +		dev_err(chip->dev, "failed to enable pwm clock\n");
> +		return ret;
> +	}
> +
> +	atmel_pwm_writel(atmel_pwm, PWM_ENA, 1 << pwm->hwpwm);
> +
> +	return 0;
> +}
> +
> +static void atmel_pwm_disable(struct pwm_chip *chip, struct pwm_device *pwm)
> +{
> +	struct atmel_pwm_chip *atmel_pwm = to_atmel_pwm_chip(chip);
> +
> +	atmel_pwm_writel(atmel_pwm, PWM_DIS, 1 << pwm->hwpwm);
> +
> +	clk_disable(atmel_pwm->clk);
> +}
> +
> +static const struct pwm_ops atmel_pwm_ops = {
> +	.config = atmel_pwm_config,
> +	.set_polarity = atmel_pwm_set_polarity,
> +	.enable = atmel_pwm_enable,
> +	.disable = atmel_pwm_disable,
> +	.owner = THIS_MODULE,
> +};
> +
> +struct atmel_pwm_data {
> +	void (*config)(struct pwm_chip *chip, struct pwm_device *pwm,
> +		       int dty, int prd);
> +};
> +
> +static const struct atmel_pwm_data atmel_pwm_data_v1 = {
> +	.config = atmel_pwm_config_v1,
> +};
> +
> +static const struct atmel_pwm_data atmel_pwm_data_v2 = {
> +	.config = atmel_pwm_config_v2,
> +};
> +
> +static const struct platform_device_id atmel_pwm_devtypes[] = {
> +	{
> +		.name = "at91sam9rl-pwm",
> +		.driver_data = (kernel_ulong_t)&atmel_pwm_data_v1,
> +	}, {
> +		.name = "sama5d3-pwm",
> +		.driver_data = (kernel_ulong_t)&atmel_pwm_data_v2,
> +	}, {
> +		/* sentinel */
> +	},
> +};
> +MODULE_DEVICE_TABLE(platform, atmel_pwm_devtypes);
> +
> +#ifdef CONFIG_OF
> +static const struct of_device_id atmel_pwm_dt_ids[] = {
> +	{
> +		.compatible = "atmel,at91sam9rl-pwm",
> +		.data = &atmel_pwm_data_v1,
> +	}, {
> +		.compatible = "atmel,sama5d3-pwm",
> +		.data = &atmel_pwm_data_v2,
> +	}, {
> +		/* sentinel */
> +	},
> +};
> +MODULE_DEVICE_TABLE(of, atmel_pwm_dt_ids);
> +#endif
> +
> +static inline const struct atmel_pwm_data * __init
> +	atmel_pwm_get_driver_data(struct platform_device *pdev)
> +{
> +	if (pdev->dev.of_node) {
> +		const struct of_device_id *match;
> +		match = of_match_device(atmel_pwm_dt_ids, &pdev->dev);
> +		if (match == NULL)
> +			return NULL;
> +		return match->data;
> +	}
> +
> +	return (struct atmel_pwm_data *)
> +		platform_get_device_id(pdev)->driver_data;
> +}
> +
> +static int atmel_pwm_probe(struct platform_device *pdev)
> +{
> +	const struct atmel_pwm_data *data;
> +	struct atmel_pwm_chip *atmel_pwm;
> +	struct resource *res;
> +	int ret;
> +
> +	atmel_pwm = devm_kzalloc(&pdev->dev, sizeof(*atmel_pwm), GFP_KERNEL);
> +	if (!atmel_pwm)
> +		return -ENOMEM;
> +
> +	data = atmel_pwm_get_driver_data(pdev);
> +	if (!data)
> +		return -ENODEV;
> +
> +	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	if (!res)
> +		return -ENODEV;
> +
> +	atmel_pwm->base = devm_ioremap_resource(&pdev->dev, res);
> +	if (IS_ERR(atmel_pwm->base))
> +		return PTR_ERR(atmel_pwm->base);
> +
> +	atmel_pwm->clk = devm_clk_get(&pdev->dev, NULL);
> +	if (IS_ERR(atmel_pwm->clk))
> +		return PTR_ERR(atmel_pwm->clk);
> +
> +	ret = clk_prepare(atmel_pwm->clk);
> +	if (ret) {
> +		dev_err(&pdev->dev, "failed to prepare pwm clock\n");
> +		return ret;
> +	}
> +
> +	atmel_pwm->chip.dev = &pdev->dev;
> +	atmel_pwm->chip.ops = &atmel_pwm_ops;
> +	if (pdev->dev.of_node) {
> +		atmel_pwm->chip.of_xlate = of_pwm_xlate_with_flags;
> +		atmel_pwm->chip.of_pwm_n_cells = 3;
> +		atmel_pwm->chip.base = -1;
> +	} else {
> +		atmel_pwm->chip.base = pdev->id;
> +	}
> +	atmel_pwm->chip.npwm = 4;
> +
> +	atmel_pwm->config = data->config;
> +
> +	ret = pwmchip_add(&atmel_pwm->chip);
> +	if (ret < 0) {
> +		dev_err(&pdev->dev, "failed to add pwm chip %d\n", ret);
> +		goto unprepare_clk;
> +	}
> +
> +	platform_set_drvdata(pdev, atmel_pwm);
> +
> +unprepare_clk:
> +	clk_unprepare(atmel_pwm->clk);
> +	return ret;
> +}
> +
> +static int atmel_pwm_remove(struct platform_device *pdev)
> +{
> +	struct atmel_pwm_chip *atmel_pwm = platform_get_drvdata(pdev);
> +
> +	clk_unprepare(atmel_pwm->clk);
> +
> +	return pwmchip_remove(&atmel_pwm->chip);
> +}
> +
> +static struct platform_driver atmel_pwm_driver = {
> +	.driver = {
> +		.name = "atmel-pwm",
> +		.of_match_table = of_match_ptr(atmel_pwm_dt_ids),
> +	},
> +	.id_table = atmel_pwm_devtypes,
> +	.probe = atmel_pwm_probe,
> +	.remove = atmel_pwm_remove,
> +};
> +module_platform_driver(atmel_pwm_driver);
> +
> +MODULE_ALIAS("platform:atmel-pwm");
> +MODULE_AUTHOR("Bo Shen <voice.shen@atmel.com>");
> +MODULE_DESCRIPTION("Atmel PWM driver");
> +MODULE_LICENSE("GPL v2");
>

