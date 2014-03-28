Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752341AbaC1IgV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2014 04:36:21 -0400
Received: from mail-pb0-f49.google.com ([209.85.160.49]:61374 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751399AbaC1IgN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2014 04:36:13 -0400
Date: Fri, 28 Mar 2014 01:36:10 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        davinci-linux-open-source@linux.davincidsp.com,
        Sekhar Nori <nsekhar@ti.com>, linux-input@vger.kernel.org
Subject: Re: [PATCH 3/3] input: remove obsolete tnetv107x drivers
Message-ID: <20140328083610.GK22093@core.coreip.homeip.net>
References: <1395154561-1199121-1-git-send-email-arnd@arndb.de>
 <1395154561-1199121-4-git-send-email-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1395154561-1199121-4-git-send-email-arnd@arndb.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 18, 2014 at 03:56:01PM +0100, Arnd Bergmann wrote:
> The tnetv107x platform is getting removed, so the touchscreen
> and keypad drivers for this platform will no longer be needed
> either.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Acked-by: Sekhar Nori <nsekhar@ti.com>
> Acked-by: Kevin Hilman <khilman@linaro.org>
> Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> Cc: linux-input@vger.kernel.org

Applied, thank you.

> ---
>  drivers/input/keyboard/Kconfig            |  10 -
>  drivers/input/keyboard/Makefile           |   1 -
>  drivers/input/keyboard/tnetv107x-keypad.c | 329 -------------------------
>  drivers/input/touchscreen/Kconfig         |   9 -
>  drivers/input/touchscreen/Makefile        |   1 -
>  drivers/input/touchscreen/tnetv107x-ts.c  | 384 ------------------------------
>  6 files changed, 734 deletions(-)
>  delete mode 100644 drivers/input/keyboard/tnetv107x-keypad.c
>  delete mode 100644 drivers/input/touchscreen/tnetv107x-ts.c
> 
> diff --git a/drivers/input/keyboard/Kconfig b/drivers/input/keyboard/Kconfig
> index a673c9f..935dcaf 100644
> --- a/drivers/input/keyboard/Kconfig
> +++ b/drivers/input/keyboard/Kconfig
> @@ -595,16 +595,6 @@ config KEYBOARD_TC3589X
>  	  To compile this driver as a module, choose M here: the
>  	  module will be called tc3589x-keypad.
>  
> -config KEYBOARD_TNETV107X
> -	tristate "TI TNETV107X keypad support"
> -	depends on ARCH_DAVINCI_TNETV107X
> -	select INPUT_MATRIXKMAP
> -	help
> -	  Say Y here if you want to use the TNETV107X keypad.
> -
> -	  To compile this driver as a module, choose M here: the
> -	  module will be called tnetv107x-keypad.
> -
>  config KEYBOARD_TWL4030
>  	tristate "TI TWL4030/TWL5030/TPS659x0 keypad support"
>  	depends on TWL4030_CORE
> diff --git a/drivers/input/keyboard/Makefile b/drivers/input/keyboard/Makefile
> index a699b61..81014d9 100644
> --- a/drivers/input/keyboard/Makefile
> +++ b/drivers/input/keyboard/Makefile
> @@ -53,7 +53,6 @@ obj-$(CONFIG_KEYBOARD_STOWAWAY)		+= stowaway.o
>  obj-$(CONFIG_KEYBOARD_SUNKBD)		+= sunkbd.o
>  obj-$(CONFIG_KEYBOARD_TC3589X)		+= tc3589x-keypad.o
>  obj-$(CONFIG_KEYBOARD_TEGRA)		+= tegra-kbc.o
> -obj-$(CONFIG_KEYBOARD_TNETV107X)	+= tnetv107x-keypad.o
>  obj-$(CONFIG_KEYBOARD_TWL4030)		+= twl4030_keypad.o
>  obj-$(CONFIG_KEYBOARD_XTKBD)		+= xtkbd.o
>  obj-$(CONFIG_KEYBOARD_W90P910)		+= w90p910_keypad.o
> diff --git a/drivers/input/keyboard/tnetv107x-keypad.c b/drivers/input/keyboard/tnetv107x-keypad.c
> deleted file mode 100644
> index 086511c..0000000
> --- a/drivers/input/keyboard/tnetv107x-keypad.c
> +++ /dev/null
> @@ -1,329 +0,0 @@
> -/*
> - * Texas Instruments TNETV107X Keypad Driver
> - *
> - * Copyright (C) 2010 Texas Instruments
> - *
> - * This program is free software; you can redistribute it and/or
> - * modify it under the terms of the GNU General Public License as
> - * published by the Free Software Foundation version 2.
> - *
> - * This program is distributed "as is" WITHOUT ANY WARRANTY of any
> - * kind, whether express or implied; without even the implied warranty
> - * of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - */
> -
> -#include <linux/kernel.h>
> -#include <linux/err.h>
> -#include <linux/errno.h>
> -#include <linux/input.h>
> -#include <linux/platform_device.h>
> -#include <linux/interrupt.h>
> -#include <linux/slab.h>
> -#include <linux/delay.h>
> -#include <linux/io.h>
> -#include <linux/clk.h>
> -#include <linux/input/matrix_keypad.h>
> -#include <linux/module.h>
> -
> -#define BITS(x)			(BIT(x) - 1)
> -
> -#define KEYPAD_ROWS		9
> -#define KEYPAD_COLS		9
> -
> -#define DEBOUNCE_MIN		0x400ul
> -#define DEBOUNCE_MAX		0x3ffffffful
> -
> -struct keypad_regs {
> -	u32	rev;
> -	u32	mode;
> -	u32	mask;
> -	u32	pol;
> -	u32	dclock;
> -	u32	rclock;
> -	u32	stable_cnt;
> -	u32	in_en;
> -	u32	out;
> -	u32	out_en;
> -	u32	in;
> -	u32	lock;
> -	u32	pres[3];
> -};
> -
> -#define keypad_read(kp, reg)		__raw_readl(&(kp)->regs->reg)
> -#define keypad_write(kp, reg, val)	__raw_writel(val, &(kp)->regs->reg)
> -
> -struct keypad_data {
> -	struct input_dev		*input_dev;
> -	struct resource			*res;
> -	struct keypad_regs __iomem	*regs;
> -	struct clk			*clk;
> -	struct device			*dev;
> -	spinlock_t			lock;
> -	int				irq_press;
> -	int				irq_release;
> -	int				rows, cols, row_shift;
> -	int				debounce_ms, active_low;
> -	u32				prev_keys[3];
> -	unsigned short			keycodes[];
> -};
> -
> -static irqreturn_t keypad_irq(int irq, void *data)
> -{
> -	struct keypad_data *kp = data;
> -	int i, bit, val, row, col, code;
> -	unsigned long flags;
> -	u32 curr_keys[3];
> -	u32 change;
> -
> -	spin_lock_irqsave(&kp->lock, flags);
> -
> -	memset(curr_keys, 0, sizeof(curr_keys));
> -	if (irq == kp->irq_press)
> -		for (i = 0; i < 3; i++)
> -			curr_keys[i] = keypad_read(kp, pres[i]);
> -
> -	for (i = 0; i < 3; i++) {
> -		change = curr_keys[i] ^ kp->prev_keys[i];
> -
> -		while (change) {
> -			bit     = fls(change) - 1;
> -			change ^= BIT(bit);
> -			val     = curr_keys[i] & BIT(bit);
> -			bit    += i * 32;
> -			row     = bit / KEYPAD_COLS;
> -			col     = bit % KEYPAD_COLS;
> -
> -			code = MATRIX_SCAN_CODE(row, col, kp->row_shift);
> -			input_event(kp->input_dev, EV_MSC, MSC_SCAN, code);
> -			input_report_key(kp->input_dev, kp->keycodes[code],
> -					 val);
> -		}
> -	}
> -	input_sync(kp->input_dev);
> -	memcpy(kp->prev_keys, curr_keys, sizeof(curr_keys));
> -
> -	if (irq == kp->irq_press)
> -		keypad_write(kp, lock, 0); /* Allow hardware updates */
> -
> -	spin_unlock_irqrestore(&kp->lock, flags);
> -
> -	return IRQ_HANDLED;
> -}
> -
> -static int keypad_start(struct input_dev *dev)
> -{
> -	struct keypad_data *kp = input_get_drvdata(dev);
> -	unsigned long mask, debounce, clk_rate_khz;
> -	unsigned long flags;
> -
> -	clk_enable(kp->clk);
> -	clk_rate_khz = clk_get_rate(kp->clk) / 1000;
> -
> -	spin_lock_irqsave(&kp->lock, flags);
> -
> -	/* Initialize device registers */
> -	keypad_write(kp, mode, 0);
> -
> -	mask  = BITS(kp->rows) << KEYPAD_COLS;
> -	mask |= BITS(kp->cols);
> -	keypad_write(kp, mask, ~mask);
> -
> -	keypad_write(kp, pol, kp->active_low ? 0 : 0x3ffff);
> -	keypad_write(kp, stable_cnt, 3);
> -
> -	debounce = kp->debounce_ms * clk_rate_khz;
> -	debounce = clamp(debounce, DEBOUNCE_MIN, DEBOUNCE_MAX);
> -	keypad_write(kp, dclock, debounce);
> -	keypad_write(kp, rclock, 4 * debounce);
> -
> -	keypad_write(kp, in_en, 1);
> -
> -	spin_unlock_irqrestore(&kp->lock, flags);
> -
> -	return 0;
> -}
> -
> -static void keypad_stop(struct input_dev *dev)
> -{
> -	struct keypad_data *kp = input_get_drvdata(dev);
> -
> -	synchronize_irq(kp->irq_press);
> -	synchronize_irq(kp->irq_release);
> -	clk_disable(kp->clk);
> -}
> -
> -static int keypad_probe(struct platform_device *pdev)
> -{
> -	const struct matrix_keypad_platform_data *pdata;
> -	const struct matrix_keymap_data *keymap_data;
> -	struct device *dev = &pdev->dev;
> -	struct keypad_data *kp;
> -	int error = 0, sz, row_shift;
> -	u32 rev = 0;
> -
> -	pdata = dev_get_platdata(&pdev->dev);
> -	if (!pdata) {
> -		dev_err(dev, "cannot find device data\n");
> -		return -EINVAL;
> -	}
> -
> -	keymap_data = pdata->keymap_data;
> -	if (!keymap_data) {
> -		dev_err(dev, "cannot find keymap data\n");
> -		return -EINVAL;
> -	}
> -
> -	row_shift = get_count_order(pdata->num_col_gpios);
> -	sz  = offsetof(struct keypad_data, keycodes);
> -	sz += (pdata->num_row_gpios << row_shift) * sizeof(kp->keycodes[0]);
> -	kp = kzalloc(sz, GFP_KERNEL);
> -	if (!kp) {
> -		dev_err(dev, "cannot allocate device info\n");
> -		return -ENOMEM;
> -	}
> -
> -	kp->dev  = dev;
> -	kp->rows = pdata->num_row_gpios;
> -	kp->cols = pdata->num_col_gpios;
> -	kp->row_shift = row_shift;
> -	platform_set_drvdata(pdev, kp);
> -	spin_lock_init(&kp->lock);
> -
> -	kp->irq_press   = platform_get_irq_byname(pdev, "press");
> -	kp->irq_release = platform_get_irq_byname(pdev, "release");
> -	if (kp->irq_press < 0 || kp->irq_release < 0) {
> -		dev_err(dev, "cannot determine device interrupts\n");
> -		error = -ENODEV;
> -		goto error_res;
> -	}
> -
> -	kp->res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> -	if (!kp->res) {
> -		dev_err(dev, "cannot determine register area\n");
> -		error = -ENODEV;
> -		goto error_res;
> -	}
> -
> -	if (!request_mem_region(kp->res->start, resource_size(kp->res),
> -				pdev->name)) {
> -		dev_err(dev, "cannot claim register memory\n");
> -		kp->res = NULL;
> -		error = -EINVAL;
> -		goto error_res;
> -	}
> -
> -	kp->regs = ioremap(kp->res->start, resource_size(kp->res));
> -	if (!kp->regs) {
> -		dev_err(dev, "cannot map register memory\n");
> -		error = -ENOMEM;
> -		goto error_map;
> -	}
> -
> -	kp->clk = clk_get(dev, NULL);
> -	if (IS_ERR(kp->clk)) {
> -		dev_err(dev, "cannot claim device clock\n");
> -		error = PTR_ERR(kp->clk);
> -		goto error_clk;
> -	}
> -
> -	error = request_threaded_irq(kp->irq_press, NULL, keypad_irq,
> -				     IRQF_ONESHOT, dev_name(dev), kp);
> -	if (error < 0) {
> -		dev_err(kp->dev, "Could not allocate keypad press key irq\n");
> -		goto error_irq_press;
> -	}
> -
> -	error = request_threaded_irq(kp->irq_release, NULL, keypad_irq,
> -				     IRQF_ONESHOT, dev_name(dev), kp);
> -	if (error < 0) {
> -		dev_err(kp->dev, "Could not allocate keypad release key irq\n");
> -		goto error_irq_release;
> -	}
> -
> -	kp->input_dev = input_allocate_device();
> -	if (!kp->input_dev) {
> -		dev_err(dev, "cannot allocate input device\n");
> -		error = -ENOMEM;
> -		goto error_input;
> -	}
> -
> -	kp->input_dev->name	  = pdev->name;
> -	kp->input_dev->dev.parent = &pdev->dev;
> -	kp->input_dev->open	  = keypad_start;
> -	kp->input_dev->close	  = keypad_stop;
> -
> -	clk_enable(kp->clk);
> -	rev = keypad_read(kp, rev);
> -	kp->input_dev->id.bustype = BUS_HOST;
> -	kp->input_dev->id.product = ((rev >>  8) & 0x07);
> -	kp->input_dev->id.version = ((rev >> 16) & 0xfff);
> -	clk_disable(kp->clk);
> -
> -	error = matrix_keypad_build_keymap(keymap_data, NULL,
> -					   kp->rows, kp->cols,
> -					   kp->keycodes, kp->input_dev);
> -	if (error) {
> -		dev_err(dev, "Failed to build keymap\n");
> -		goto error_reg;
> -	}
> -
> -	if (!pdata->no_autorepeat)
> -		kp->input_dev->evbit[0] |= BIT_MASK(EV_REP);
> -	input_set_capability(kp->input_dev, EV_MSC, MSC_SCAN);
> -
> -	input_set_drvdata(kp->input_dev, kp);
> -
> -	error = input_register_device(kp->input_dev);
> -	if (error < 0) {
> -		dev_err(dev, "Could not register input device\n");
> -		goto error_reg;
> -	}
> -
> -	return 0;
> -
> -
> -error_reg:
> -	input_free_device(kp->input_dev);
> -error_input:
> -	free_irq(kp->irq_release, kp);
> -error_irq_release:
> -	free_irq(kp->irq_press, kp);
> -error_irq_press:
> -	clk_put(kp->clk);
> -error_clk:
> -	iounmap(kp->regs);
> -error_map:
> -	release_mem_region(kp->res->start, resource_size(kp->res));
> -error_res:
> -	kfree(kp);
> -	return error;
> -}
> -
> -static int keypad_remove(struct platform_device *pdev)
> -{
> -	struct keypad_data *kp = platform_get_drvdata(pdev);
> -
> -	free_irq(kp->irq_press, kp);
> -	free_irq(kp->irq_release, kp);
> -	input_unregister_device(kp->input_dev);
> -	clk_put(kp->clk);
> -	iounmap(kp->regs);
> -	release_mem_region(kp->res->start, resource_size(kp->res));
> -	kfree(kp);
> -
> -	return 0;
> -}
> -
> -static struct platform_driver keypad_driver = {
> -	.probe		= keypad_probe,
> -	.remove		= keypad_remove,
> -	.driver.name	= "tnetv107x-keypad",
> -	.driver.owner	= THIS_MODULE,
> -};
> -module_platform_driver(keypad_driver);
> -
> -MODULE_AUTHOR("Cyril Chemparathy");
> -MODULE_DESCRIPTION("TNETV107X Keypad Driver");
> -MODULE_ALIAS("platform:tnetv107x-keypad");
> -MODULE_LICENSE("GPL");
> diff --git a/drivers/input/touchscreen/Kconfig b/drivers/input/touchscreen/Kconfig
> index 07e9e82..68edc9d 100644
> --- a/drivers/input/touchscreen/Kconfig
> +++ b/drivers/input/touchscreen/Kconfig
> @@ -514,15 +514,6 @@ config TOUCHSCREEN_MIGOR
>  	  To compile this driver as a module, choose M here: the
>  	  module will be called migor_ts.
>  
> -config TOUCHSCREEN_TNETV107X
> -	tristate "TI TNETV107X touchscreen support"
> -	depends on ARCH_DAVINCI_TNETV107X
> -	help
> -	  Say Y here if you want to use the TNETV107X touchscreen.
> -
> -	  To compile this driver as a module, choose M here: the
> -	  module will be called tnetv107x-ts.
> -
>  config TOUCHSCREEN_TOUCHRIGHT
>  	tristate "Touchright serial touchscreen"
>  	select SERIO
> diff --git a/drivers/input/touchscreen/Makefile b/drivers/input/touchscreen/Makefile
> index 62801f2..4bc954b 100644
> --- a/drivers/input/touchscreen/Makefile
> +++ b/drivers/input/touchscreen/Makefile
> @@ -56,7 +56,6 @@ obj-$(CONFIG_TOUCHSCREEN_ST1232)	+= st1232.o
>  obj-$(CONFIG_TOUCHSCREEN_STMPE)		+= stmpe-ts.o
>  obj-$(CONFIG_TOUCHSCREEN_SUR40)		+= sur40.o
>  obj-$(CONFIG_TOUCHSCREEN_TI_AM335X_TSC)	+= ti_am335x_tsc.o
> -obj-$(CONFIG_TOUCHSCREEN_TNETV107X)	+= tnetv107x-ts.o
>  obj-$(CONFIG_TOUCHSCREEN_TOUCHIT213)	+= touchit213.o
>  obj-$(CONFIG_TOUCHSCREEN_TOUCHRIGHT)	+= touchright.o
>  obj-$(CONFIG_TOUCHSCREEN_TOUCHWIN)	+= touchwin.o
> diff --git a/drivers/input/touchscreen/tnetv107x-ts.c b/drivers/input/touchscreen/tnetv107x-ts.c
> deleted file mode 100644
> index c47827a..0000000
> --- a/drivers/input/touchscreen/tnetv107x-ts.c
> +++ /dev/null
> @@ -1,384 +0,0 @@
> -/*
> - * Texas Instruments TNETV107X Touchscreen Driver
> - *
> - * Copyright (C) 2010 Texas Instruments
> - *
> - * This program is free software; you can redistribute it and/or
> - * modify it under the terms of the GNU General Public License as
> - * published by the Free Software Foundation version 2.
> - *
> - * This program is distributed "as is" WITHOUT ANY WARRANTY of any
> - * kind, whether express or implied; without even the implied warranty
> - * of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - */
> -
> -#include <linux/module.h>
> -#include <linux/kernel.h>
> -#include <linux/err.h>
> -#include <linux/errno.h>
> -#include <linux/input.h>
> -#include <linux/platform_device.h>
> -#include <linux/interrupt.h>
> -#include <linux/slab.h>
> -#include <linux/delay.h>
> -#include <linux/ctype.h>
> -#include <linux/io.h>
> -#include <linux/clk.h>
> -
> -#include <mach/tnetv107x.h>
> -
> -#define TSC_PENUP_POLL		(HZ / 5)
> -#define IDLE_TIMEOUT		100 /* msec */
> -
> -/*
> - * The first and last samples of a touch interval are usually garbage and need
> - * to be filtered out with these devices.  The following definitions control
> - * the number of samples skipped.
> - */
> -#define TSC_HEAD_SKIP		1
> -#define TSC_TAIL_SKIP		1
> -#define TSC_SKIP		(TSC_HEAD_SKIP + TSC_TAIL_SKIP + 1)
> -#define TSC_SAMPLES		(TSC_SKIP + 1)
> -
> -/* Register Offsets */
> -struct tsc_regs {
> -	u32	rev;
> -	u32	tscm;
> -	u32	bwcm;
> -	u32	swc;
> -	u32	adcchnl;
> -	u32	adcdata;
> -	u32	chval[4];
> -};
> -
> -/* TSC Mode Configuration Register (tscm) bits */
> -#define WMODE		BIT(0)
> -#define TSKIND		BIT(1)
> -#define ZMEASURE_EN	BIT(2)
> -#define IDLE		BIT(3)
> -#define TSC_EN		BIT(4)
> -#define STOP		BIT(5)
> -#define ONE_SHOT	BIT(6)
> -#define SINGLE		BIT(7)
> -#define AVG		BIT(8)
> -#define AVGNUM(x)	(((x) & 0x03) <<  9)
> -#define PVSTC(x)	(((x) & 0x07) << 11)
> -#define PON		BIT(14)
> -#define PONBG		BIT(15)
> -#define AFERST		BIT(16)
> -
> -/* ADC DATA Capture Register bits */
> -#define DATA_VALID	BIT(16)
> -
> -/* Register Access Macros */
> -#define tsc_read(ts, reg)		__raw_readl(&(ts)->regs->reg)
> -#define tsc_write(ts, reg, val)		__raw_writel(val, &(ts)->regs->reg);
> -#define tsc_set_bits(ts, reg, val)	\
> -	tsc_write(ts, reg, tsc_read(ts, reg) | (val))
> -#define tsc_clr_bits(ts, reg, val)	\
> -	tsc_write(ts, reg, tsc_read(ts, reg) & ~(val))
> -
> -struct sample {
> -	int x, y, p;
> -};
> -
> -struct tsc_data {
> -	struct input_dev		*input_dev;
> -	struct resource			*res;
> -	struct tsc_regs __iomem		*regs;
> -	struct timer_list		timer;
> -	spinlock_t			lock;
> -	struct clk			*clk;
> -	struct device			*dev;
> -	int				sample_count;
> -	struct sample			samples[TSC_SAMPLES];
> -	int				tsc_irq;
> -};
> -
> -static int tsc_read_sample(struct tsc_data *ts, struct sample* sample)
> -{
> -	int	x, y, z1, z2, t, p = 0;
> -	u32	val;
> -
> -	val = tsc_read(ts, chval[0]);
> -	if (val & DATA_VALID)
> -		x = val & 0xffff;
> -	else
> -		return -EINVAL;
> -
> -	y  = tsc_read(ts, chval[1]) & 0xffff;
> -	z1 = tsc_read(ts, chval[2]) & 0xffff;
> -	z2 = tsc_read(ts, chval[3]) & 0xffff;
> -
> -	if (z1) {
> -		t = ((600 * x) * (z2 - z1));
> -		p = t / (u32) (z1 << 12);
> -		if (p < 0)
> -			p = 0;
> -	}
> -
> -	sample->x  = x;
> -	sample->y  = y;
> -	sample->p  = p;
> -
> -	return 0;
> -}
> -
> -static void tsc_poll(unsigned long data)
> -{
> -	struct tsc_data *ts = (struct tsc_data *)data;
> -	unsigned long flags;
> -	int i, val, x, y, p;
> -
> -	spin_lock_irqsave(&ts->lock, flags);
> -
> -	if (ts->sample_count >= TSC_SKIP) {
> -		input_report_abs(ts->input_dev, ABS_PRESSURE, 0);
> -		input_report_key(ts->input_dev, BTN_TOUCH, 0);
> -		input_sync(ts->input_dev);
> -	} else if (ts->sample_count > 0) {
> -		/*
> -		 * A touch event lasted less than our skip count.  Salvage and
> -		 * report anyway.
> -		 */
> -		for (i = 0, val = 0; i < ts->sample_count; i++)
> -			val += ts->samples[i].x;
> -		x = val / ts->sample_count;
> -
> -		for (i = 0, val = 0; i < ts->sample_count; i++)
> -			val += ts->samples[i].y;
> -		y = val / ts->sample_count;
> -
> -		for (i = 0, val = 0; i < ts->sample_count; i++)
> -			val += ts->samples[i].p;
> -		p = val / ts->sample_count;
> -
> -		input_report_abs(ts->input_dev, ABS_X, x);
> -		input_report_abs(ts->input_dev, ABS_Y, y);
> -		input_report_abs(ts->input_dev, ABS_PRESSURE, p);
> -		input_report_key(ts->input_dev, BTN_TOUCH, 1);
> -		input_sync(ts->input_dev);
> -	}
> -
> -	ts->sample_count = 0;
> -
> -	spin_unlock_irqrestore(&ts->lock, flags);
> -}
> -
> -static irqreturn_t tsc_irq(int irq, void *dev_id)
> -{
> -	struct tsc_data *ts = (struct tsc_data *)dev_id;
> -	struct sample *sample;
> -	int index;
> -
> -	spin_lock(&ts->lock);
> -
> -	index = ts->sample_count % TSC_SAMPLES;
> -	sample = &ts->samples[index];
> -	if (tsc_read_sample(ts, sample) < 0)
> -		goto out;
> -
> -	if (++ts->sample_count >= TSC_SKIP) {
> -		index = (ts->sample_count - TSC_TAIL_SKIP - 1) % TSC_SAMPLES;
> -		sample = &ts->samples[index];
> -
> -		input_report_abs(ts->input_dev, ABS_X, sample->x);
> -		input_report_abs(ts->input_dev, ABS_Y, sample->y);
> -		input_report_abs(ts->input_dev, ABS_PRESSURE, sample->p);
> -		if (ts->sample_count == TSC_SKIP)
> -			input_report_key(ts->input_dev, BTN_TOUCH, 1);
> -		input_sync(ts->input_dev);
> -	}
> -	mod_timer(&ts->timer, jiffies + TSC_PENUP_POLL);
> -out:
> -	spin_unlock(&ts->lock);
> -	return IRQ_HANDLED;
> -}
> -
> -static int tsc_start(struct input_dev *dev)
> -{
> -	struct tsc_data *ts = input_get_drvdata(dev);
> -	unsigned long timeout = jiffies + msecs_to_jiffies(IDLE_TIMEOUT);
> -	u32 val;
> -
> -	clk_enable(ts->clk);
> -
> -	/* Go to idle mode, before any initialization */
> -	while (time_after(timeout, jiffies)) {
> -		if (tsc_read(ts, tscm) & IDLE)
> -			break;
> -	}
> -
> -	if (time_before(timeout, jiffies)) {
> -		dev_warn(ts->dev, "timeout waiting for idle\n");
> -		clk_disable(ts->clk);
> -		return -EIO;
> -	}
> -
> -	/* Configure TSC Control register*/
> -	val = (PONBG | PON | PVSTC(4) | ONE_SHOT | ZMEASURE_EN);
> -	tsc_write(ts, tscm, val);
> -
> -	/* Bring TSC out of reset: Clear AFE reset bit */
> -	val &= ~(AFERST);
> -	tsc_write(ts, tscm, val);
> -
> -	/* Configure all pins for hardware control*/
> -	tsc_write(ts, bwcm, 0);
> -
> -	/* Finally enable the TSC */
> -	tsc_set_bits(ts, tscm, TSC_EN);
> -
> -	return 0;
> -}
> -
> -static void tsc_stop(struct input_dev *dev)
> -{
> -	struct tsc_data *ts = input_get_drvdata(dev);
> -
> -	tsc_clr_bits(ts, tscm, TSC_EN);
> -	synchronize_irq(ts->tsc_irq);
> -	del_timer_sync(&ts->timer);
> -	clk_disable(ts->clk);
> -}
> -
> -static int tsc_probe(struct platform_device *pdev)
> -{
> -	struct device *dev = &pdev->dev;
> -	struct tsc_data *ts;
> -	int error = 0;
> -	u32 rev = 0;
> -
> -	ts = kzalloc(sizeof(struct tsc_data), GFP_KERNEL);
> -	if (!ts) {
> -		dev_err(dev, "cannot allocate device info\n");
> -		return -ENOMEM;
> -	}
> -
> -	ts->dev = dev;
> -	spin_lock_init(&ts->lock);
> -	setup_timer(&ts->timer, tsc_poll, (unsigned long)ts);
> -	platform_set_drvdata(pdev, ts);
> -
> -	ts->tsc_irq = platform_get_irq(pdev, 0);
> -	if (ts->tsc_irq < 0) {
> -		dev_err(dev, "cannot determine device interrupt\n");
> -		error = -ENODEV;
> -		goto error_res;
> -	}
> -
> -	ts->res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> -	if (!ts->res) {
> -		dev_err(dev, "cannot determine register area\n");
> -		error = -ENODEV;
> -		goto error_res;
> -	}
> -
> -	if (!request_mem_region(ts->res->start, resource_size(ts->res),
> -				pdev->name)) {
> -		dev_err(dev, "cannot claim register memory\n");
> -		ts->res = NULL;
> -		error = -EINVAL;
> -		goto error_res;
> -	}
> -
> -	ts->regs = ioremap(ts->res->start, resource_size(ts->res));
> -	if (!ts->regs) {
> -		dev_err(dev, "cannot map register memory\n");
> -		error = -ENOMEM;
> -		goto error_map;
> -	}
> -
> -	ts->clk = clk_get(dev, NULL);
> -	if (IS_ERR(ts->clk)) {
> -		dev_err(dev, "cannot claim device clock\n");
> -		error = PTR_ERR(ts->clk);
> -		goto error_clk;
> -	}
> -
> -	error = request_threaded_irq(ts->tsc_irq, NULL, tsc_irq, IRQF_ONESHOT,
> -				     dev_name(dev), ts);
> -	if (error < 0) {
> -		dev_err(ts->dev, "Could not allocate ts irq\n");
> -		goto error_irq;
> -	}
> -
> -	ts->input_dev = input_allocate_device();
> -	if (!ts->input_dev) {
> -		dev_err(dev, "cannot allocate input device\n");
> -		error = -ENOMEM;
> -		goto error_input;
> -	}
> -	input_set_drvdata(ts->input_dev, ts);
> -
> -	ts->input_dev->name       = pdev->name;
> -	ts->input_dev->id.bustype = BUS_HOST;
> -	ts->input_dev->dev.parent = &pdev->dev;
> -	ts->input_dev->open	  = tsc_start;
> -	ts->input_dev->close	  = tsc_stop;
> -
> -	clk_enable(ts->clk);
> -	rev = tsc_read(ts, rev);
> -	ts->input_dev->id.product = ((rev >>  8) & 0x07);
> -	ts->input_dev->id.version = ((rev >> 16) & 0xfff);
> -	clk_disable(ts->clk);
> -
> -	__set_bit(EV_KEY,    ts->input_dev->evbit);
> -	__set_bit(EV_ABS,    ts->input_dev->evbit);
> -	__set_bit(BTN_TOUCH, ts->input_dev->keybit);
> -
> -	input_set_abs_params(ts->input_dev, ABS_X, 0, 0xffff, 5, 0);
> -	input_set_abs_params(ts->input_dev, ABS_Y, 0, 0xffff, 5, 0);
> -	input_set_abs_params(ts->input_dev, ABS_PRESSURE, 0, 4095, 128, 0);
> -
> -	error = input_register_device(ts->input_dev);
> -	if (error < 0) {
> -		dev_err(dev, "failed input device registration\n");
> -		goto error_reg;
> -	}
> -
> -	return 0;
> -
> -error_reg:
> -	input_free_device(ts->input_dev);
> -error_input:
> -	free_irq(ts->tsc_irq, ts);
> -error_irq:
> -	clk_put(ts->clk);
> -error_clk:
> -	iounmap(ts->regs);
> -error_map:
> -	release_mem_region(ts->res->start, resource_size(ts->res));
> -error_res:
> -	kfree(ts);
> -
> -	return error;
> -}
> -
> -static int tsc_remove(struct platform_device *pdev)
> -{
> -	struct tsc_data *ts = platform_get_drvdata(pdev);
> -
> -	input_unregister_device(ts->input_dev);
> -	free_irq(ts->tsc_irq, ts);
> -	clk_put(ts->clk);
> -	iounmap(ts->regs);
> -	release_mem_region(ts->res->start, resource_size(ts->res));
> -	kfree(ts);
> -
> -	return 0;
> -}
> -
> -static struct platform_driver tsc_driver = {
> -	.probe		= tsc_probe,
> -	.remove		= tsc_remove,
> -	.driver.name	= "tnetv107x-ts",
> -	.driver.owner	= THIS_MODULE,
> -};
> -module_platform_driver(tsc_driver);
> -
> -MODULE_AUTHOR("Cyril Chemparathy");
> -MODULE_DESCRIPTION("TNETV107X Touchscreen Driver");
> -MODULE_ALIAS("platform:tnetv107x-ts");
> -MODULE_LICENSE("GPL");
> -- 
> 1.8.3.2
> 

-- 
Dmitry
