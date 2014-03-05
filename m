Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752991AbaCEGqM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 01:46:12 -0500
Received: from mail-pb0-f50.google.com ([209.85.160.50]:36537 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751772AbaCEGqJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 01:46:09 -0500
Date: Tue, 4 Mar 2014 22:46:01 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Gabriel FERNANDEZ <gabriel.fernandez@st.com>
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Rob Landley <rob@landley.net>,
        Russell King <linux@arm.linux.org.uk>,
        Grant Likely <grant.likely@linaro.org>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-input@vger.kernel.org,
        kernel@stlinux.com, Lee Jones <lee.jones@linaro.org>,
        Giuseppe Condorelli <giuseppe.condorelli@st.com>
Subject: Re: [PATCH 1/5] drivers: input: keyboard: st-keyscan: add keyscan
 driver
Message-ID: <20140305064601.GB1834@core.coreip.homeip.net>
References: <1393990772-9567-1-git-send-email-gabriel.fernandez@st.com>
 <1393990772-9567-2-git-send-email-gabriel.fernandez@st.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1393990772-9567-2-git-send-email-gabriel.fernandez@st.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Gabriel,

On Wed, Mar 05, 2014 at 04:39:28AM +0100, Gabriel FERNANDEZ wrote:
> This patch adds ST Keyscan driver to use the keypad hw a subset
> of ST boards provide. Specific board setup will be put in the
> given dt.
> 
> Signed-off-by: Giuseppe Condorelli <giuseppe.condorelli@st.com>
> Signed-off-by: Gabriel Fernandez <gabriel.fernandez@st.com>
> ---
>  .../devicetree/bindings/input/st-keypad.txt        |  50 ++++
>  drivers/input/keyboard/Kconfig                     |  12 +
>  drivers/input/keyboard/Makefile                    |   1 +
>  drivers/input/keyboard/st-keyscan.c                | 323 +++++++++++++++++++++
>  4 files changed, 386 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/input/st-keypad.txt
>  create mode 100644 drivers/input/keyboard/st-keyscan.c
> 
> diff --git a/Documentation/devicetree/bindings/input/st-keypad.txt b/Documentation/devicetree/bindings/input/st-keypad.txt
> new file mode 100644
> index 0000000..63eb07a
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/input/st-keypad.txt
> @@ -0,0 +1,50 @@
> +* ST Keypad controller device tree bindings
> +
> +The ST keypad controller device tree binding is based on the
> +matrix-keymap.
> +
> +Required properties:
> +
> +- compatible: "st,keypad"
> +
> +- reg: Register base address of st-keypad controler.
> +
> +- interrupts: Interrupt numberof st-keypad controler.
> +
> +- clocks: Must contain one entry, for the module clock.
> +  See ../clocks/clock-bindings.txt for details.
> +
> +- pinctrl-0: Should specify pin control groups used for this controller.
> +
> +- pinctrl-names: Should contain only one value - "default".
> +
> +- linux,keymap: The keymap for keys as described in the binding document
> +  devicetree/bindings/input/matrix-keymap.txt.
> +
> +- keypad,num-rows: Number of row lines connected to the keypad controller.
> +
> +- keypad,num-columns: Number of column lines connected to the keypad
> +  controller.
> +
> +- st,debounce_us: Debouncing interval time in microseconds
> +
> +
> +Example:
> +
> +keyscan: keyscan@fe4b0000 {
> +	compatible = "st,keypad";
> +	reg = <0xfe4b0000 0x2000>;
> +	interrupts = <GIC_SPI 212 IRQ_TYPE_NONE>;
> +	clocks	= <&CLK_SYSIN>;
> +	pinctrl-names = "default";
> +	pinctrl-0 = <&pinctrl_keyscan>;
> +
> +	keypad,num-rows = <4>;
> +	keypad,num-columns = <4>;
> +	st,debounce_us = <5000>;
> +	linux,keymap = < /* in0	in1	in2	in3 */
> +		KEY_F13 KEY_F9  KEY_F5 KEY_F1		/* out0 */
> +		KEY_F14 KEY_F10 KEY_F6 KEY_F2		/* out1 */
> +		KEY_F15 KEY_F11 KEY_F7 KEY_F3		/* out2 */
> +		KEY_F16 KEY_F12 KEY_F8 KEY_F4 >;	/* out3 */
> +};
> diff --git a/drivers/input/keyboard/Kconfig b/drivers/input/keyboard/Kconfig
> index a673c9f..9e29125 100644
> --- a/drivers/input/keyboard/Kconfig
> +++ b/drivers/input/keyboard/Kconfig
> @@ -512,6 +512,18 @@ config KEYBOARD_STOWAWAY
>  	  To compile this driver as a module, choose M here: the
>  	  module will be called stowaway.
>  
> +config KEYBOARD_ST_KEYSCAN
> +	tristate "STMicroelectronics keyscan support"
> +	depends on ARCH_STI
> +	select INPUT_EVDEV
> +	select INPUT_MATRIXKMAP
> +	help
> +	  Say Y here if you want to use a keypad attached to the keyscan block
> +	  on some STMicroelectronics SoC devices.
> +
> +	  To compile this driver as a module, choose M here: the
> +	  module will be called stm-keyscan.
> +
>  config KEYBOARD_SUNKBD
>  	tristate "Sun Type 4 and Type 5 keyboard"
>  	select SERIO
> diff --git a/drivers/input/keyboard/Makefile b/drivers/input/keyboard/Makefile
> index a699b61..5fd020a 100644
> --- a/drivers/input/keyboard/Makefile
> +++ b/drivers/input/keyboard/Makefile
> @@ -50,6 +50,7 @@ obj-$(CONFIG_KEYBOARD_SH_KEYSC)		+= sh_keysc.o
>  obj-$(CONFIG_KEYBOARD_SPEAR)		+= spear-keyboard.o
>  obj-$(CONFIG_KEYBOARD_STMPE)		+= stmpe-keypad.o
>  obj-$(CONFIG_KEYBOARD_STOWAWAY)		+= stowaway.o
> +obj-$(CONFIG_KEYBOARD_ST_KEYSCAN)	+= st-keyscan.o
>  obj-$(CONFIG_KEYBOARD_SUNKBD)		+= sunkbd.o
>  obj-$(CONFIG_KEYBOARD_TC3589X)		+= tc3589x-keypad.o
>  obj-$(CONFIG_KEYBOARD_TEGRA)		+= tegra-kbc.o
> diff --git a/drivers/input/keyboard/st-keyscan.c b/drivers/input/keyboard/st-keyscan.c
> new file mode 100644
> index 0000000..606cc19
> --- /dev/null
> +++ b/drivers/input/keyboard/st-keyscan.c
> @@ -0,0 +1,323 @@
> +/*
> + * STMicroelectronics Key Scanning driver
> + *
> + * Copyright (c) 2014 STMicroelectonics Ltd.
> + * Author: Stuart Menefy <stuart.menefy@st.com>
> + *
> + * Based on sh_keysc.c, copyright 2008 Magnus Damm
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +
> +#include <linux/module.h>
> +#include <linux/interrupt.h>
> +#include <linux/platform_device.h>
> +#include <linux/clk.h>
> +#include <linux/io.h>
> +#include <linux/input/matrix_keypad.h>
> +
> +#define ST_KEYSCAN_MAXKEYS 16
> +
> +#define KEYSCAN_CONFIG_OFF		0x000
> +#define KEYSCAN_CONFIG_ENABLE		1
> +#define KEYSCAN_DEBOUNCE_TIME_OFF	0x004
> +#define KEYSCAN_MATRIX_STATE_OFF	0x008
> +#define KEYSCAN_MATRIX_DIM_OFF		0x00c
> +#define KEYSCAN_MATRIX_DIM_X_SHIFT	0
> +#define KEYSCAN_MATRIX_DIM_Y_SHIFT	2
> +
> +struct keypad_platform_data {
> +	const struct matrix_keymap_data *keymap_data;
> +	unsigned int num_out_pads;
> +	unsigned int num_in_pads;
> +	unsigned int debounce_us;
> +};
> +
> +struct keyscan_priv {
> +	void __iomem *base;
> +	int irq;
> +	struct clk *clk;
> +	struct input_dev *input_dev;
> +	struct keypad_platform_data *config;
> +	unsigned int last_state;
> +	u32 keycodes[ST_KEYSCAN_MAXKEYS];
> +};
> +
> +static irqreturn_t keyscan_isr(int irq, void *dev_id)
> +{
> +	struct platform_device *pdev = dev_id;
> +	struct keyscan_priv *priv = platform_get_drvdata(pdev);
> +	int state;
> +	int change;
> +
> +	state = readl(priv->base + KEYSCAN_MATRIX_STATE_OFF) & 0xffff;
> +	change = priv->last_state ^ state;
> +
> +	while (change) {
> +		int scancode = __ffs(change);
> +		int down = state & (1 << scancode);
> +
> +		input_report_key(priv->input_dev, priv->keycodes[scancode],
> +				 down);
> +		change ^= 1 << scancode;
> +	};
> +
> +	input_sync(priv->input_dev);
> +
> +	priv->last_state = state;
> +
> +	return IRQ_HANDLED;
> +}
> +
> +static void keyscan_start(struct keyscan_priv *priv)
> +{
> +	clk_enable(priv->clk);
> +
> +	writel(priv->config->debounce_us * (clk_get_rate(priv->clk) / 1000000),
> +	       priv->base + KEYSCAN_DEBOUNCE_TIME_OFF);
> +
> +	writel(((priv->config->num_in_pads - 1) << KEYSCAN_MATRIX_DIM_X_SHIFT) |
> +	       ((priv->config->num_out_pads - 1) << KEYSCAN_MATRIX_DIM_Y_SHIFT),
> +	       priv->base + KEYSCAN_MATRIX_DIM_OFF);
> +
> +	writel(KEYSCAN_CONFIG_ENABLE, priv->base + KEYSCAN_CONFIG_OFF);
> +}
> +
> +static void keyscan_stop(struct keyscan_priv *priv)
> +{
> +	writel(0, priv->base + KEYSCAN_CONFIG_OFF);
> +
> +	clk_disable(priv->clk);
> +}
> +
> +static int keypad_matrix_key_parse_dt(struct keyscan_priv *st_kp)
> +{
> +	struct device *dev = st_kp->input_dev->dev.parent;
> +	struct device_node *np = dev->of_node;
> +	struct keypad_platform_data *pdata;
> +	int error;
> +
> +	pdata = devm_kzalloc(dev, sizeof(*pdata), GFP_KERNEL);
> +	if (!pdata) {
> +		dev_err(dev, "failed to allocate driver pdata\n");
> +		return -ENOMEM;
> +	}
> +
> +	error = matrix_keypad_parse_of_params(dev, &pdata->num_out_pads,
> +			&pdata->num_in_pads);
> +	if (error) {
> +		dev_err(dev, "failed to parse keypad params\n");
> +		return error;
> +	}
> +
> +	of_property_read_u32(np, "st,debounce_us", &pdata->debounce_us);
> +
> +	st_kp->config = pdata;
> +
> +	dev_info(dev, "rows=%d col=%d debounce=%d\n",
> +			pdata->num_out_pads,
> +			pdata->num_in_pads,
> +			pdata->debounce_us);
> +
> +	error = of_property_read_u32_array(np, "linux,keymap",
> +					st_kp->keycodes, ST_KEYSCAN_MAXKEYS);
> +	if (error) {
> +		dev_err(dev, "failed to parse keymap\n");
> +		return error;
> +	}

Please use standard format for matrix keymap so that you can use
matrix_keypad_build_keymap().

> +
> +	return 0;
> +}
> +
> +static int __init keyscan_probe(struct platform_device *pdev)
> +{
> +	struct keypad_platform_data *pdata =
> +		dev_get_platdata(&pdev->dev);

const struct ...

> +	struct keyscan_priv *st_kp;
> +	struct input_dev *input_dev;
> +	struct device *dev = &pdev->dev;
> +	struct resource *res;
> +	int len;
> +	int error;
> +	int i;
> +
> +	if (!pdata && !pdev->dev.of_node) {
> +		dev_err(&pdev->dev, "no keymap defined\n");
> +		return -EINVAL;
> +	}
> +
> +	st_kp = devm_kzalloc(dev, sizeof(*st_kp), GFP_KERNEL);
> +	if (!st_kp) {
> +		dev_err(dev, "failed to allocate driver data\n");
> +		return -ENOMEM;
> +	}
> +	st_kp->config = pdata;
> +
> +	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	if (!res) {
> +		dev_err(dev, "no I/O memory specified\n");
> +		return -ENXIO;
> +	}
> +
> +	len = resource_size(res);
> +	if (!devm_request_mem_region(dev, res->start, len, pdev->name)) {
> +		dev_err(dev, "failed to reserve I/O memory\n");
> +		return -EBUSY;
> +	}
> +
> +	st_kp->base = devm_ioremap_nocache(dev, res->start, len);
> +	if (st_kp->base == NULL) {
> +		dev_err(dev, "failed to remap I/O memory\n");
> +		return -ENXIO;
> +	}
> +
> +	st_kp->irq = platform_get_irq(pdev, 0);
> +	if (st_kp->irq < 0) {
> +		dev_err(dev, "no IRQ specified\n");
> +		return -ENXIO;
> +	}
> +
> +	error = devm_request_irq(dev, st_kp->irq, keyscan_isr, 0,
> +				 pdev->name, pdev);
> +	if (error) {
> +		dev_err(dev, "failed to request IRQ\n");
> +		return error;
> +	}
> +
> +	input_dev = devm_input_allocate_device(&pdev->dev);
> +	if (!input_dev) {
> +		dev_err(&pdev->dev, "failed to allocate the input device\n");
> +		return -ENOMEM;
> +	}
> +
> +	st_kp->clk = devm_clk_get(dev, NULL);
> +	if (IS_ERR(st_kp->clk)) {
> +		dev_err(dev, "cannot get clock");
> +		return PTR_ERR(st_kp->clk);
> +	}
> +
> +	input_dev = input_allocate_device();
> +	if (!input_dev) {
> +		dev_err(dev, "failed to allocate input device\n");
> +		return -ENOMEM;
> +	}

You already allocated it once a few lines above.

> +	st_kp->input_dev = input_dev;
> +
> +	input_dev->name = pdev->name;
> +	input_dev->phys = "keyscan-keys/input0";
> +	input_dev->dev.parent = dev;
> +
> +	input_dev->id.bustype = BUS_HOST;
> +	input_dev->id.vendor = 0x0001;
> +	input_dev->id.product = 0x0001;
> +	input_dev->id.version = 0x0100;
> +
> +	if (!pdata) {
> +		error = keypad_matrix_key_parse_dt(st_kp);
> +		if (error)
> +			return error;
> +		pdata = st_kp->config;
> +	}
> +
> +	input_dev->keycode = st_kp->keycodes;
> +	input_dev->keycodesize = sizeof(st_kp->keycodes[0]);
> +	input_dev->keycodemax = ARRAY_SIZE(st_kp->keycodes);
> +
> +	for (i = 0; i < ST_KEYSCAN_MAXKEYS; i++)
> +		input_set_capability(input_dev, EV_KEY, st_kp->keycodes[i]);
> +	__clear_bit(KEY_RESERVED, input_dev->keybit);
> +
> +	error = input_register_device(input_dev);
> +	if (error) {
> +		dev_err(dev, "failed to register input device\n");
> +		input_free_device(input_dev);
> +		platform_set_drvdata(pdev, NULL);
> +		return error;
> +	}
> +
> +	platform_set_drvdata(pdev, st_kp);
> +
> +	keyscan_start(st_kp);
> +
> +	device_set_wakeup_capable(&pdev->dev, 1);
> +
> +	return 0;
> +}
> +
> +static int __exit keyscan_remove(struct platform_device *pdev)

Why is this marked as __exit? I can unbind device from driver without
unloading module (via sysfs).

> +{
> +	struct keyscan_priv *priv = platform_get_drvdata(pdev);
> +
> +	keyscan_stop(priv);

Call to keyscan_stop() shoudl go into keyscan_close() implementation.

> +
> +	input_unregister_device(priv->input_dev);

Not needed since you are trying to use devres-managed input device.

> +	platform_set_drvdata(pdev, NULL);

Not needed. In fact, if you move keyscan_stop() into keyscan_close() you
should be able to get rid of keyscan_remove().

> +
> +	return 0;
> +}
> +
> +static int keyscan_suspend(struct device *dev)
> +{
> +	struct platform_device *pdev = to_platform_device(dev);
> +	struct keyscan_priv *priv = platform_get_drvdata(pdev);
> +
> +	if (device_may_wakeup(dev))
> +		enable_irq_wake(priv->irq);
> +	else
> +		keyscan_stop(priv);
> +
> +	return 0;
> +}
> +
> +static int keyscan_resume(struct device *dev)
> +{
> +	struct platform_device *pdev = to_platform_device(dev);
> +	struct keyscan_priv *priv = platform_get_drvdata(pdev);
> +
> +	if (device_may_wakeup(dev))
> +		disable_irq_wake(priv->irq);
> +	else
> +		keyscan_start(priv);
> +
> +	return 0;
> +}

Guard suspend/resume with CONFIG_PM_SLEEP?

> +
> +static const struct dev_pm_ops keyscan_dev_pm_ops = {
> +	.suspend = keyscan_suspend,
> +	.resume = keyscan_resume,
> +};

Make it SIMPLE_DEV_PM_OPS().

> +
> +static const struct of_device_id keyscan_of_match[] = {
> +	{ .compatible = "st,keypad" },
> +	{ },
> +};
> +MODULE_DEVICE_TABLE(of, keyscan_of_match);
> +
> +__refdata struct platform_driver keyscan_device_driver = {

What is this refdata business?

> +	.probe		= keyscan_probe,
> +	.remove		= __exit_p(keyscan_remove),
> +	.driver		= {
> +		.name	= "st-keyscan",
> +		.pm	= &keyscan_dev_pm_ops,
> +		.of_match_table = of_match_ptr(keyscan_of_match),
> +	}
> +};
> +
> +static int __init keyscan_init(void)
> +{
> +	return platform_driver_register(&keyscan_device_driver);
> +}
> +
> +static void __exit keyscan_exit(void)
> +{
> +	platform_driver_unregister(&keyscan_device_driver);
> +}
> +
> +module_init(keyscan_init);
> +module_exit(keyscan_exit);

I think we have module_platform_drriver() for this.

> +
> +MODULE_AUTHOR("Stuart Menefy <stuart.menefy@st.com>");
> +MODULE_DESCRIPTION("STMicroelectronics keyscan device driver");
> +MODULE_LICENSE("GPL");
> -- 
> 1.9.0
> 

Thanks.

-- 
Dmitry
