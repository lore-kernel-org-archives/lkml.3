Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752320AbaKYHH1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 02:07:27 -0500
Received: from mail-pd0-f179.google.com ([209.85.192.179]:63259 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751876AbaKYHHZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 02:07:25 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: Philipp Zabel <p.zabel@pengutronix.de>,
        "Thierry Reding" <thierry.reding@gmail.com>
From: Mike Turquette <mturquette@linaro.org>
In-Reply-To: <1415007078-7947-1-git-send-email-p.zabel@pengutronix.de>
Cc: =?utf-8?q?Janusz_U=C5=BCycki?= <j.uzycki@elproma.com.pl>,
        "Rob Herring" <robh+dt@kernel.org>, "Pawel Moll" <pawel.moll@arm.com>,
        "Mark Rutland" <mark.rutland@arm.com>,
        "Ian Campbell" <ijc+devicetree@hellion.org.uk>,
        "Kumar Gala" <galak@codeaurora.org>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-pwm@vger.kernel.org,
        "Philipp Zabel" <p.zabel@pengutronix.de>
References: <1415007078-7947-1-git-send-email-p.zabel@pengutronix.de>
Message-ID: <20141125070720.12298.46343@quantum>
User-Agent: alot/0.3.5
Subject: Re: [PATCH v2] clk: Add PWM clock driver
Date: Mon, 24 Nov 2014 23:07:20 -0800
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Philipp Zabel (2014-11-03 01:31:18)
> Some board designers, when running out of clock output pads, decide to
> (mis)use PWM output pads to provide a clock to external components.
> This driver supports this practice by providing an adapter between the
> PWM and clock bindings in the device tree. As the PWM bindings specify
> the period in the device tree, this is a fixed clock.
> 
> Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
> ---
> I'm resending this because last time the linux-pwm list was not in Cc:
> So far I have not received any comments on the patch itself. I have used
> it on a BoundaryDevices Nitrogen6X board to produce a master clock for
> the OV5640 MIPI CSI-2 camera module.
> 
> Changes since v1:
>  - none (rebased onto v3.18-rc3)

Hi Philipp,

Thanks for testing this. Is the Nitrogen6X board merged upstream? I'm OK
with the patch but prefer to merge things when a consumer is ready to
use it. I guess you are missing a patch to add the pwm-clock bits to the
Nitrogen6X dts?

Regards,
Mike

> ---
>  .../devicetree/bindings/clock/pwm-clock.txt        |  23 +++++
>  drivers/clk/Kconfig                                |   7 ++
>  drivers/clk/Makefile                               |   1 +
>  drivers/clk/clk-pwm.c                              | 110 +++++++++++++++++++++
>  4 files changed, 141 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/clock/pwm-clock.txt
>  create mode 100644 drivers/clk/clk-pwm.c
> 
> diff --git a/Documentation/devicetree/bindings/clock/pwm-clock.txt b/Documentation/devicetree/bindings/clock/pwm-clock.txt
> new file mode 100644
> index 0000000..d127d17
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/clock/pwm-clock.txt
> @@ -0,0 +1,23 @@
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
> +
> +Example:
> +       clock {
> +               compatible = "pwm-clock";
> +               #clock-cells = <0>;
> +               clock-output-names = "mipi_mclk";
> +               pwms = <&pwm2 0 40>; /* 1 / 40 ns = 25 MHz */
> +       };
> diff --git a/drivers/clk/Kconfig b/drivers/clk/Kconfig
> index 455fd17..36a6918a 100644
> --- a/drivers/clk/Kconfig
> +++ b/drivers/clk/Kconfig
> @@ -129,6 +129,13 @@ config COMMON_CLK_PALMAS
>           This driver supports TI Palmas devices 32KHz output KG and KG_AUDIO
>           using common clock framework.
>  
> +config COMMON_CLK_PWM
> +       bool "Clock driver for PWMs used as clock outputs"
> +       depends on PWM
> +       ---help---
> +         Adapter driver so that any PWM output can be (mis)used as clock signal
> +         at 50% duty cycle.
> +
>  config COMMON_CLK_PXA
>         def_bool COMMON_CLK && ARCH_PXA
>         ---help---
> diff --git a/drivers/clk/Makefile b/drivers/clk/Makefile
> index d5fba5b..6a0c5cf 100644
> --- a/drivers/clk/Makefile
> +++ b/drivers/clk/Makefile
> @@ -40,6 +40,7 @@ obj-$(CONFIG_ARCH_U300)                       += clk-u300.o
>  obj-$(CONFIG_ARCH_VT8500)              += clk-vt8500.o
>  obj-$(CONFIG_COMMON_CLK_WM831X)                += clk-wm831x.o
>  obj-$(CONFIG_COMMON_CLK_XGENE)         += clk-xgene.o
> +obj-$(CONFIG_COMMON_CLK_PWM)           += clk-pwm.o
>  obj-$(CONFIG_COMMON_CLK_AT91)          += at91/
>  obj-$(CONFIG_ARCH_BCM_MOBILE)          += bcm/
>  obj-$(CONFIG_ARCH_BERLIN)              += berlin/
> diff --git a/drivers/clk/clk-pwm.c b/drivers/clk/clk-pwm.c
> new file mode 100644
> index 0000000..8f747b3
> --- /dev/null
> +++ b/drivers/clk/clk-pwm.c
> @@ -0,0 +1,110 @@
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
> +       struct clk_hw hw;
> +       struct pwm_device *pwm;
> +};
> +
> +#define to_clk_pwm(_hw) container_of(_hw, struct clk_pwm, hw)
> +
> +static int clk_pwm_enable(struct clk_hw *hw)
> +{
> +       struct clk_pwm *clk_pwm = to_clk_pwm(hw);
> +
> +       return pwm_enable(clk_pwm->pwm);
> +}
> +
> +static void clk_pwm_disable(struct clk_hw *hw)
> +{
> +       struct clk_pwm *clk_pwm = to_clk_pwm(hw);
> +
> +       pwm_disable(clk_pwm->pwm);
> +}
> +
> +static unsigned long clk_pwm_recalc_rate(struct clk_hw *hw,
> +                                        unsigned long parent_rate)
> +{
> +       struct clk_pwm *clk_pwm = to_clk_pwm(hw);
> +       unsigned int period_ns = pwm_get_period(clk_pwm->pwm);
> +
> +       return period_ns ? (1000000000 / period_ns) : 0;
> +}
> +
> +const struct clk_ops clk_pwm_ops = {
> +       .enable = clk_pwm_enable,
> +       .disable = clk_pwm_disable,
> +       .recalc_rate = clk_pwm_recalc_rate,
> +};
> +
> +int clk_pwm_probe(struct platform_device *pdev)
> +{
> +       struct clk_init_data init;
> +       struct clk_pwm *clk_pwm;
> +       struct pwm_device *pwm;
> +       struct clk *clk;
> +       int ret;
> +
> +       clk_pwm = devm_kzalloc(&pdev->dev, sizeof(*clk_pwm), GFP_KERNEL);
> +       if (!clk_pwm)
> +               return -ENOMEM;
> +
> +       pwm = devm_pwm_get(&pdev->dev, NULL);
> +       if (IS_ERR(pwm))
> +               return PTR_ERR(pwm);
> +
> +       ret = pwm_config(pwm, (pwm->period + 1) >> 1, pwm->period);
> +       if (ret < 0)
> +               return ret;
> +
> +       init.name = "pwm-clock";
> +       init.ops = &clk_pwm_ops;
> +       init.flags = CLK_IS_ROOT;
> +       init.num_parents = 0;
> +
> +       clk_pwm->pwm = pwm;
> +       clk_pwm->hw.init = &init;
> +       clk = devm_clk_register(&pdev->dev, &clk_pwm->hw);
> +       if (IS_ERR(clk))
> +               return PTR_ERR(clk);
> +
> +       return of_clk_add_provider(pdev->dev.of_node,
> +                                  of_clk_src_simple_get, clk);
> +}
> +
> +int clk_pwm_remove(struct platform_device *pdev)
> +{
> +       of_clk_del_provider(pdev->dev.of_node);
> +
> +       return 0;
> +}
> +
> +static const struct of_device_id clk_pwm_dt_ids[] = {
> +       { .compatible = "pwm-clock" },
> +       { }
> +};
> +MODULE_DEVICE_TABLE(of, clk_pwm_dt_ids);
> +
> +static struct platform_driver clk_pwm_driver = {
> +       .probe = clk_pwm_probe,
> +       .driver = {
> +               .name = "pwm-clock",
> +               .owner = THIS_MODULE,
> +               .of_match_table = of_match_ptr(clk_pwm_dt_ids),
> +       },
> +};
> +
> +module_platform_driver(clk_pwm_driver);
> -- 
> 2.1.1
> 
