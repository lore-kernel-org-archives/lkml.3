Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757996AbaLIQt2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 11:49:28 -0500
Received: from v032797.home.net.pl ([89.161.177.31]:64494 "HELO
	v032797.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757651AbaLIQtY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 11:49:24 -0500
Message-ID: <54872810.7000700@elproma.com.pl>
Date: Tue, 09 Dec 2014 17:49:20 +0100
From: =?ISO-8859-2?Q?Janusz_U=BFycki?= <j.uzycki@elproma.com.pl>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Philipp Zabel <p.zabel@pengutronix.de>,
        Mike Turquette <mturquette@linaro.org>,
        Thierry Reding <thierry.reding@gmail.com>
CC: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-pwm@vger.kernel.org
Subject: Re: [PATCH v3] clk: Add PWM clock driver
References: <1418138392-17081-1-git-send-email-p.zabel@pengutronix.de>
In-Reply-To: <1418138392-17081-1-git-send-email-p.zabel@pengutronix.de>
Content-Type: text/plain; charset=iso-8859-2; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


W dniu 2014-12-09 o 16:19, Philipp Zabel pisze:
> Some board designers, when running out of clock output pads, decide to
> (mis)use PWM output pads to provide a clock to external components.
> This driver supports this practice by providing an adapter between the
> PWM and clock bindings in the device tree. As the PWM bindings specify
> the period in the device tree, this is a fixed clock.
>
> Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
> ---
> Changes since v2:
>   - Added clock-frequency support to work around pwm duty cycle being
>     rounded to nanoseconds.
>   - Implemented clock-output-names support as advertised in the binding
>     documentation.
> ---
>   .../devicetree/bindings/clock/pwm-clock.txt        |  26 +++++
>   drivers/clk/Kconfig                                |   7 ++
>   drivers/clk/Makefile                               |   1 +
>   drivers/clk/clk-pwm.c                              | 129 +++++++++++++++++++++
>   4 files changed, 163 insertions(+)
>   create mode 100644 Documentation/devicetree/bindings/clock/pwm-clock.txt
>   create mode 100644 drivers/clk/clk-pwm.c
>
> diff --git a/Documentation/devicetree/bindings/clock/pwm-clock.txt b/Documentation/devicetree/bindings/clock/pwm-clock.txt
> new file mode 100644
> index 0000000..751fff5
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/clock/pwm-clock.txt
> @@ -0,0 +1,26 @@
> +Binding for an external clock signal driven by a PWM pin.
> +
> +This binding uses the common clock binding[1] and the common PWM binding[2].
> +
> +[1] Documentation/devicetree/bindings/clock/clock-bindings.txt
> +[2] Documentation/devicetree/bindings/pwm/pwm.txt
> +
> +Required properties:
> +- compatible : shall be "pwm-clock".
> +- #clock-cells : from common clock binding; shall be set to 0.
> +- pwms : from common PWM binding; this determines the clock frequency
> +  via the PWM period given in the pwm-specifier.
> +
> +Optional properties:
> +- clock-output-names : From common clock binding.
> +- clock-frequency : Exact output frequency, in case the pwm period
> +  is not exact but was rounded to nanoseconds.
> +
> +Example:
> +	clock {
> +		compatible = "pwm-clock";
> +		#clock-cells = <0>;
> +		clock-frequency = <25000000>;
> +		clock-output-names = "mipi_mclk";
> +		pwms = <&pwm2 0 40>; /* 1 / 40 ns = 25 MHz */
> +	};
> diff --git a/drivers/clk/Kconfig b/drivers/clk/Kconfig
> index 455fd17..36a6918a 100644
> --- a/drivers/clk/Kconfig
> +++ b/drivers/clk/Kconfig
> @@ -129,6 +129,13 @@ config COMMON_CLK_PALMAS
>   	  This driver supports TI Palmas devices 32KHz output KG and KG_AUDIO
>   	  using common clock framework.
>   
> +config COMMON_CLK_PWM
> +	bool "Clock driver for PWMs used as clock outputs"
> +	depends on PWM
> +	---help---
> +	  Adapter driver so that any PWM output can be (mis)used as clock signal
> +	  at 50% duty cycle.
> +
>   config COMMON_CLK_PXA
>   	def_bool COMMON_CLK && ARCH_PXA
>   	---help---
> diff --git a/drivers/clk/Makefile b/drivers/clk/Makefile
> index d5fba5b..6a0c5cf 100644
> --- a/drivers/clk/Makefile
> +++ b/drivers/clk/Makefile
> @@ -40,6 +40,7 @@ obj-$(CONFIG_ARCH_U300)			+= clk-u300.o
>   obj-$(CONFIG_ARCH_VT8500)		+= clk-vt8500.o
>   obj-$(CONFIG_COMMON_CLK_WM831X)		+= clk-wm831x.o
>   obj-$(CONFIG_COMMON_CLK_XGENE)		+= clk-xgene.o
> +obj-$(CONFIG_COMMON_CLK_PWM)		+= clk-pwm.o
>   obj-$(CONFIG_COMMON_CLK_AT91)		+= at91/
>   obj-$(CONFIG_ARCH_BCM_MOBILE)		+= bcm/
>   obj-$(CONFIG_ARCH_BERLIN)		+= berlin/
> diff --git a/drivers/clk/clk-pwm.c b/drivers/clk/clk-pwm.c
> new file mode 100644
> index 0000000..2783abd
> --- /dev/null
> +++ b/drivers/clk/clk-pwm.c
> @@ -0,0 +1,129 @@
> +/*
> + * Copyright (C) 2014 Philipp Zabel, Pengutronix
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + *
> + * PWM (mis)used as clock output
> + */
> +#include <linux/clk-provider.h>
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/of.h>
> +#include <linux/platform_device.h>
> +#include <linux/pwm.h>
> +
> +struct clk_pwm {
> +	struct clk_hw hw;
> +	struct pwm_device *pwm;
> +	u32 fixed_rate;
> +};
> +
> +#define to_clk_pwm(_hw) container_of(_hw, struct clk_pwm, hw)
> +
> +static int clk_pwm_enable(struct clk_hw *hw)
> +{
> +	struct clk_pwm *clk_pwm = to_clk_pwm(hw);
> +
> +	return pwm_enable(clk_pwm->pwm);
> +}
> +
> +static void clk_pwm_disable(struct clk_hw *hw)
> +{
> +	struct clk_pwm *clk_pwm = to_clk_pwm(hw);
> +
> +	pwm_disable(clk_pwm->pwm);
> +}
> +
> +static unsigned long clk_pwm_recalc_rate(struct clk_hw *hw,
> +					 unsigned long parent_rate)
> +{
> +	struct clk_pwm *clk_pwm = to_clk_pwm(hw);
> +
> +	return clk_pwm->fixed_rate;
> +}
> +
> +const struct clk_ops clk_pwm_ops = {
> +	.enable = clk_pwm_enable,
> +	.disable = clk_pwm_disable,
> +	.recalc_rate = clk_pwm_recalc_rate,
> +};
> +
> +int clk_pwm_probe(struct platform_device *pdev)
> +{
> +	struct device_node *node = pdev->dev.of_node;
> +	struct clk_init_data init;
> +	struct clk_pwm *clk_pwm;
> +	struct pwm_device *pwm;
> +	const char *clk_name;
> +	struct clk *clk;
> +	int ret;
> +
> +	clk_pwm = devm_kzalloc(&pdev->dev, sizeof(*clk_pwm), GFP_KERNEL);
> +	if (!clk_pwm)
> +		return -ENOMEM;
> +
> +	pwm = devm_pwm_get(&pdev->dev, NULL);

NULL or clk_name ?

> +	if (IS_ERR(pwm))
> +		return PTR_ERR(pwm);
> +
> +	if (!pwm || !pwm->period) {
> +		dev_err(&pdev->dev, "invalid pwm period\n");
> +		return -EINVAL;
> +	}
> +
> +	if (of_property_read_u32(node, "clock-frequency", &clk_pwm->fixed_rate))
> +		clk_pwm->fixed_rate = 1000000000 / pwm->period;

You can use NSEC_PER_SEC instead of the hardcoded value.

> +
> +	if (pwm->period != 1000000000 / clk_pwm->fixed_rate &&
> +	    pwm->period != DIV_ROUND_UP(1000000000, clk_pwm->fixed_rate)) {
> +		dev_err(&pdev->dev,
> +			"clock-frequency does not match pwm period\n");
> +		return -EINVAL;
> +	}

This can't prevent against buggy pwm driver (bad frequency)
because there is not function to read the period back, ie.
.pwm_config callback does not modify duty_ns and period_ns to real 
values indeed.
There is the way to set directly
         pwm->period = NSEC_PER_SEC / clk_pwm>fixed_rate;
instead of third argument (period_ns) of pwms. Although the argument is 
required
(#pwm-cells >= 2 and *_xlate_* functions) it could be set to 0 in pwms.
Such calculation should be right for most PWMs if they are clocked not 
faster
than eg. 40MHz. Above div-round issue can appear but it also appears due 
to ns resolution.
I can't point if this is the best solution for the future.

> +
> +	ret = pwm_config(pwm, (pwm->period + 1) >> 1, pwm->period);
> +	if (ret < 0)
> +		return ret;
> +
> +	clk_name = node->name;
> +	of_property_read_string(node, "clock-output-names", &clk_name);
> +
> +	init.name = clk_name;
> +	init.ops = &clk_pwm_ops;
> +	init.flags = CLK_IS_ROOT;

and what about CLK_IS_BASIC?

> +	init.num_parents = 0;

Is it proof against suspend/resume race of pwm driver vs pwm-clock's 
customer?
Otherwise chain of clocks can be broken.

> +
> +	clk_pwm->pwm = pwm;
> +	clk_pwm->hw.init = &init;
> +	clk = devm_clk_register(&pdev->dev, &clk_pwm->hw);
> +	if (IS_ERR(clk))
> +		return PTR_ERR(clk);
> +
> +	return of_clk_add_provider(node, of_clk_src_simple_get, clk);
> +}
> +
> +int clk_pwm_remove(struct platform_device *pdev)
> +{
> +	of_clk_del_provider(pdev->dev.of_node);
> +
> +	return 0;
> +}
> +
> +static const struct of_device_id clk_pwm_dt_ids[] = {
> +	{ .compatible = "pwm-clock" },
> +	{ }
> +};
> +MODULE_DEVICE_TABLE(of, clk_pwm_dt_ids);
> +
> +static struct platform_driver clk_pwm_driver = {
> +	.probe = clk_pwm_probe,

missing
                 .remove = clk_pwm_remove,

> +	.driver = {
> +		.name = "pwm-clock",
> +		.owner = THIS_MODULE,

.owner could be removed (not a problem now)

> +		.of_match_table = of_match_ptr(clk_pwm_dt_ids),
> +	},

Why doesn't mcp251x trigger probe of pwm-clock driver?
The fixed-clock uses CLK_OF_DECLARE which defines .data
of of_device_id instead of .probe. Unfortunately I'm not so much 
familiar with DT.
Any idea?

thanks,
Janusz

> +};
> +
> +module_platform_driver(clk_pwm_driver);

