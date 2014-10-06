Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752289AbaJFVcS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 17:32:18 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:51608 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751098AbaJFVcP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 17:32:15 -0400
Date: Mon, 6 Oct 2014 14:32:10 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Frans Klaver <frans.klaver@xsens.com>
Cc: Sebastian Reichel <sre@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/2] power: reset: add LTC2952 poweroff support
Message-ID: <20141006213210.GA11926@roeck-us.net>
References: <1412584836-27677-1-git-send-email-frans.klaver@xsens.com>
 <1412584836-27677-2-git-send-email-frans.klaver@xsens.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1412584836-27677-2-git-send-email-frans.klaver@xsens.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 06, 2014 at 10:40:35AM +0200, Frans Klaver wrote:
> From: René Moll <linux@r-moll.nl>
> 
> The LTC2952 allows control over system power using a push button. It also
> supports powering down the board from a controller on the board.
> 
> If the power button is pushed, the ltc2952 starts a 400ms window to
> properly shut down the software. This window can be stretched by
> toggling a watchdog line. This driver always uses this watchdog line.
> The power button input is optional. This allows the system to use a
> custom shutdown sequence on the push button.
> 
> On software shutdown the driver sets the kill signal, starting the same
> sequence as if the push button was used.
> 
> Signed-off-by: Ren? Moll <linux@r-moll.nl>
> Signed-off-by: Tjerk Hofmeijer <tjerk.hofmeijer@xsens.com>
> Signed-off-by: Frans Klaver <frans.klaver@xsens.com>
> ---
>  drivers/power/reset/Kconfig            |  10 +
>  drivers/power/reset/Makefile           |   1 +
>  drivers/power/reset/ltc2952-poweroff.c | 381 +++++++++++++++++++++++++++++++++
>  3 files changed, 392 insertions(+)
>  create mode 100644 drivers/power/reset/ltc2952-poweroff.c
> 
> diff --git a/drivers/power/reset/Kconfig b/drivers/power/reset/Kconfig
> index ca41523..a0f68da 100644
> --- a/drivers/power/reset/Kconfig
> +++ b/drivers/power/reset/Kconfig
> @@ -45,6 +45,16 @@ config POWER_RESET_HISI
>  	help
>  	  Reboot support for Hisilicon boards.
>  
> +config POWER_RESET_LTC2952
> +	bool "LTC2952 PowerPath power-off driver"
> +	depends on OF_GPIO && POWER_RESET
> +	help
> +	  This driver supports an external powerdown trigger and board
> +	  power down via the LTC2952.
> +
> +	  If your board uses an LTC2952, say  Y and create a binding
> +	  in the device tree.
> +
>  config POWER_RESET_MSM
>  	bool "Qualcomm MSM power-off driver"
>  	depends on POWER_RESET && ARCH_QCOM
> diff --git a/drivers/power/reset/Makefile b/drivers/power/reset/Makefile
> index a42e70e..3cbb7c3 100644
> --- a/drivers/power/reset/Makefile
> +++ b/drivers/power/reset/Makefile
> @@ -3,6 +3,7 @@ obj-$(CONFIG_POWER_RESET_AXXIA) += axxia-reset.o
>  obj-$(CONFIG_POWER_RESET_BRCMSTB) += brcmstb-reboot.o
>  obj-$(CONFIG_POWER_RESET_GPIO) += gpio-poweroff.o
>  obj-$(CONFIG_POWER_RESET_HISI) += hisi-reboot.o
> +obj-$(CONFIG_POWER_RESET_LTC2952) += ltc2952-poweroff.o
>  obj-$(CONFIG_POWER_RESET_MSM) += msm-poweroff.o
>  obj-$(CONFIG_POWER_RESET_QNAP) += qnap-poweroff.o
>  obj-$(CONFIG_POWER_RESET_RESTART) += restart-poweroff.o
> diff --git a/drivers/power/reset/ltc2952-poweroff.c b/drivers/power/reset/ltc2952-poweroff.c
> new file mode 100644
> index 0000000..2cf146a
> --- /dev/null
> +++ b/drivers/power/reset/ltc2952-poweroff.c
> @@ -0,0 +1,381 @@
> +/*
> + * LTC2952 PowerPath TM driver
> + *
> + * Copyright (C) 2014, Xsens Technologies BV <info@xsens.com>
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License
> + * as published by the Free Software Foundation; either version 2
> + * of the License, or (at your option) any later version.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * ----------------------------------------
> + * - Description
> + * ----------------------------------------
> + *
> + * This driver is to be used with an external LTC2952 PowerPath Controller.
> + * Its function is to determine when a external shut down is triggered
> + * and react by properly shutting down the system.
> + *
> + * This driver expects a device tree with a ltc2952 entry for pin mapping.
> + *
> + * ----------------------------------------
> + * - GPIO
> + * ----------------------------------------
> + *
> + * The following GPIOs are used:
> + * - trigger (input, optional)
> + *     A level change indicates the shut-down trigger. If it's state reverts
> + *     within the time-out defined by trigger_delay, the shut down is not
> + *     executed. If no pin is assigned to this input the driver will start
> + *     the watchdog immediately and only a power off event will kill the ltc2952
> + *
> + * - watchdog (output)
> + *     Once a shut down is triggered, the driver will toggle this signal,
> + *     with an internal (wde_interval) to stall the hardware shut down.
> + *
> + * - kill (output)
> + *     The last action during shut down is triggering this signalling, such
> + *     that the PowerPath Control will power down the hardware.
> + *

poweroff might be a better name.

> + * ----------------------------------------
> + * - Interrupts
> + * ----------------------------------------
> + *
> + * The driver requires a non-shared, edge-triggered interrupt on the trigger
> + * GPIO.
> + *
> + */
> +
> +#include <linux/kernel.h>
> +#include <linux/init.h>
> +#include <linux/interrupt.h>
> +#include <linux/device.h>
> +#include <linux/platform_device.h>
> +#include <linux/ktime.h>
> +#include <linux/slab.h>
> +#include <linux/kmod.h>
> +#include <linux/module.h>
> +#include <linux/gpio/consumer.h>
> +#include <linux/reboot.h>
> +
> +struct ltc2952_poweroff_data {
> +	struct hrtimer timer_trigger;
> +	struct hrtimer timer_wde;
> +
> +	ktime_t trigger_delay;
> +	ktime_t wde_interval;
> +
> +	struct device *dev;
> +
> +	unsigned int virq;
> +
> +	struct gpio_desc *gpio_trigger;
> +	struct gpio_desc *gpio_watchdog;
> +	struct gpio_desc *gpio_kill;
> +};
> +
> +static bool ltc2952_poweroff_panic;
> +static struct ltc2952_poweroff_data *ltc2952_data;
> +
> +/**
> + * ltc2952_poweroff_timer_wde - Timer callback
> + * Toggles the watchdog reset signal each wde_interval
> + *
> + * @timer: corresponding timer
> + *
> + * Returns HRTIMER_RESTART for an infinite loop which will only stop when the
> + * machine actually shuts down
> + */
> +static enum hrtimer_restart ltc2952_poweroff_timer_wde(struct hrtimer *timer)
> +{
> +	ktime_t now;
> +	int state;
> +	unsigned long overruns;
> +
> +	if (ltc2952_poweroff_panic)
> +		return HRTIMER_NORESTART;
> +
> +	state = gpiod_get_value(ltc2952_data->gpio_watchdog);
> +	gpiod_set_value(ltc2952_data->gpio_watchdog, !state);
> +
> +	now = hrtimer_cb_get_time(timer);
> +	overruns = hrtimer_forward(timer, now, ltc2952_data->wde_interval);
> +
> +	return HRTIMER_RESTART;
> +}
> +
> +static void ltc2952_poweroff_start_wde(void)
> +{
> +	int ret;
> +
> +	ret = hrtimer_start(&ltc2952_data->timer_wde,
> +			    ltc2952_data->wde_interval, HRTIMER_MODE_REL);
> +
> +	if (ret) {
> +		dev_err(ltc2952_data->dev,
> +			"unable to start the watchdog timer\n");
> +		/*
> +		 * The device will not toggle the watchdog reset,
> +		 * thus shut down is only safe if the PowerPath controller
> +		 * has a long enough time-off before triggering a hardware
> +		 * power-off.
> +		 *
> +		 * Only sending a warning as the system will power-off anyway
> +		 */
> +	}
> +}
> +
> +static enum hrtimer_restart ltc2952_poweroff_timer_trigger(struct hrtimer *t)
> +{
> +	ltc2952_poweroff_start_wde();
> +
> +	dev_info(ltc2952_data->dev, "executing shutdown\n");
> +
> +	orderly_poweroff(true);
> +
> +	return HRTIMER_NORESTART;
> +}
> +
> +/**
> + * ltc2952_poweroff_handler - Interrupt handler
> + * Triggered each time the trigger signal changes state and (de)activates a
> + * time-out (timer_trigger). Once the time-out is actually reached the shut
> + * down is executed.
> + *
> + * @irq: IRQ number
> + * @dev_id: pointer to the main data structure
> + */
> +static irqreturn_t ltc2952_poweroff_handler(int irq, void *dev_id)
> +{
> +	struct ltc2952_poweroff_data *data = dev_id;
> +
> +	if (ltc2952_poweroff_panic || hrtimer_active(&data->timer_wde))
> +		/* we're either panicking, or already shutting down */
> +		goto irq_ok;
> +
> +	if (hrtimer_active(&data->timer_trigger)) {
> +		hrtimer_cancel(&data->timer_trigger);
> +		goto irq_ok;
> +	}
> +
> +	if (hrtimer_start(&data->timer_trigger, data->trigger_delay,
> +			  HRTIMER_MODE_REL))
> +		dev_err(data->dev, "unable to start the wait timer\n");
> +
> +irq_ok:
> +	return IRQ_HANDLED;
> +}
> +
> +static void ltc2952_poweroff_kill(void)
> +{
> +	gpiod_set_value(ltc2952_data->gpio_kill, 1);
> +}
> +
> +static int ltc2952_poweroff_suspend(struct platform_device *pdev,
> +				    pm_message_t state)
> +{
> +	return -ENOSYS;
> +}
> +
> +static int ltc2952_poweroff_resume(struct platform_device *pdev)
> +{
> +	return -ENOSYS;
> +}
> +
What is the value of those functions if they don't do anything but return an
error ?

> +static void ltc2952_poweroff_default(struct ltc2952_poweroff_data *data)
> +{
> +	data->wde_interval = ktime_set(0, 300L*1E6L);
> +	data->trigger_delay = ktime_set(2, 500L*1E6L);
> +
> +	hrtimer_init(&data->timer_trigger, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
> +	data->timer_trigger.function = &ltc2952_poweroff_timer_trigger;
> +
> +	hrtimer_init(&data->timer_wde, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
> +	data->timer_wde.function = &ltc2952_poweroff_timer_wde;
> +}
> +
> +static int ltc2952_poweroff_init(struct platform_device *pdev)
> +{
> +	int ret;
> +
> +	ltc2952_poweroff_default(ltc2952_data);
> +
> +	ltc2952_data->gpio_watchdog = gpiod_get(&pdev->dev, "watchdog");

Any reason for not using devm_gpiod_get() for those functions ?

> +	if (IS_ERR(ltc2952_data->gpio_watchdog)) {
> +		ret = PTR_ERR(ltc2952_data->gpio_watchdog);
> +		dev_err(&pdev->dev, "unable to claim watchdog-gpio\n");
> +		goto err;

Unnecessary goto. Just return the ERR_PTR directly.

> +	}
> +
> +	ret = gpiod_direction_output(ltc2952_data->gpio_watchdog, 0);
> +	if (ret) {
> +		dev_err(&pdev->dev, "unable to use watchdog-gpio as output\n");
> +		goto err_watchdog;
> +	}
> +
> +	ltc2952_data->gpio_kill = gpiod_get(&pdev->dev, "kill");
> +	if (IS_ERR(ltc2952_data->gpio_kill)) {
> +		ret = PTR_ERR(ltc2952_data->gpio_kill);
> +		dev_err(&pdev->dev, "unable to claim kill-gpio\n");
> +		goto err_watchdog;
> +	}
> +
> +	ret = gpiod_direction_output(ltc2952_data->gpio_kill, 0);
> +	if (ret) {
> +		dev_err(&pdev->dev, "unable to use kill-gpio as output\n");
> +		goto err_kill;
> +	}
> +
> +	ltc2952_data->gpio_trigger = gpiod_get(&pdev->dev, "trigger");
> +	if (IS_ERR(ltc2952_data->gpio_trigger)) {
> +		ret = PTR_ERR(ltc2952_data->gpio_trigger);
> +
> +		if (ret != -ENOENT) {
> +			dev_err(&pdev->dev, "unable to claim trigger-gpio\n");
> +			goto err_kill;
> +		}
> +
> +		dev_info(&pdev->dev, "No trigger input defined\n");
> +		ltc2952_data->gpio_trigger = NULL;
> +		ltc2952_poweroff_start_wde();

Can you explain this in more detail ? It is not entirely clear (at least not
to me) why you start the timer in this case.

> +		return 0;
> +	}
> +
> +	ltc2952_data->virq = gpiod_to_irq(ltc2952_data->gpio_trigger);
> +	if (ltc2952_data->virq < 0) {
> +		dev_err(&pdev->dev, "cannot map GPIO as interrupt");
> +		goto err_trigger;
> +	}
> +
> +	ret = request_irq(ltc2952_data->virq,
> +			  ltc2952_poweroff_handler,
> +			  (IRQF_TRIGGER_FALLING | IRQF_TRIGGER_RISING),
> +			  "ltc2952-poweroff",
> +			  ltc2952_data);

Why not devm_request_irq ?

Overall, seems to me that using devm_ functions would simplify error cleanup
and removal code significantly.

> +	if (ret) {
> +		dev_err(&pdev->dev, "cannot configure an interrupt handler\n");
> +		goto err_trigger;

Wouldn't those cases be logically identical to the "have no trigger" case ?
Maybe not, but poweroff would presumably still work, and it is not entirely
clear to me why you would refuse to power off the system if triggered by the
"poweroff" command just because you failed to install an interrupt handler
for the trigger button.

> +	}
> +	return 0;
> +
> +err_trigger:
> +	gpiod_put(ltc2952_data->gpio_trigger);
> +err_kill:
> +	gpiod_put(ltc2952_data->gpio_kill);
> +err_watchdog:
> +	gpiod_put(ltc2952_data->gpio_watchdog);
> +err:
> +	return ret;
> +}
> +
> +static int ltc2952_poweroff_probe(struct platform_device *pdev)
> +{
> +	int ret;
> +
> +	if (pm_power_off) {
> +		dev_err(&pdev->dev, "pm_power_off already registered");
> +		return -EBUSY;
> +	}
> +
> +	ltc2952_data = kzalloc(sizeof(*ltc2952_data), GFP_KERNEL);

Why not devm_kzalloc ?

> +	if (!ltc2952_data)
> +		return -ENOMEM;
> +
> +	ltc2952_data->dev = &pdev->dev;
> +
> +	ret = ltc2952_poweroff_init(pdev);
> +	if (ret)
> +		goto err;
> +
> +	pm_power_off = &ltc2952_poweroff_kill;

That '&' is unnecessary.

> +
> +	dev_info(&pdev->dev, "probe successful\n");
> +
> +	return 0;
> +
> +err:
> +	kfree(ltc2952_data);
> +	return ret;
> +}
> +
> +static int ltc2952_poweroff_remove(struct platform_device *pdev)
> +{
> +	pm_power_off = NULL;
> +
> +	if (ltc2952_data) {
> +		if (ltc2952_data->gpio_trigger != NULL)
> +			free_irq(ltc2952_data->virq, ltc2952_data);
> +
> +		if (hrtimer_active(&ltc2952_data->timer_wde))
> +			hrtimer_cancel(&ltc2952_data->timer_wde);
> +
> +		gpiod_put(ltc2952_data->gpio_watchdog);
> +		gpiod_put(ltc2952_data->gpio_kill);
> +		gpiod_put(ltc2952_data->gpio_trigger);
> +
> +		kfree(ltc2952_data);
> +	}
> +
> +	return 0;
> +}
> +
> +static const struct of_device_id of_ltc2952_poweroff_match[] = {
> +	{ .compatible = "lltc,ltc2952"},
> +	{},
> +};
> +MODULE_DEVICE_TABLE(of, of_ltc2952_poweroff_match);
> +
> +static struct platform_driver ltc2952_poweroff_driver = {
> +	.probe = ltc2952_poweroff_probe,
> +	.remove = ltc2952_poweroff_remove,
> +	.driver = {
> +		.name = "ltc2952-poweroff",
> +		.owner = THIS_MODULE,
> +		.of_match_table = of_ltc2952_poweroff_match,
> +	},
> +	.suspend = ltc2952_poweroff_suspend,
> +	.resume = ltc2952_poweroff_resume,

I think you are supposed to put the suspend and resume calls into the driver
structure. The platform code names the callbacks here 'legacy'.

> +};
> +
> +static int ltc2952_poweroff_notify_panic(struct notifier_block *nb,
> +					 unsigned long code,
> +					 void *unused)
> +{
> +	ltc2952_poweroff_panic = true;
> +	return NOTIFY_DONE;
> +}
> +
> +static struct notifier_block ltc2952_poweroff_panic_nb = {
> +	.notifier_call = ltc2952_poweroff_notify_panic,
> +};
> +
> +static int __init ltc2952_poweroff_platform_init(void)
> +{
> +	ltc2952_poweroff_panic = false;
> +
> +	atomic_notifier_chain_register(&panic_notifier_list,
> +		&ltc2952_poweroff_panic_nb);
> +
> +	return platform_driver_register(&ltc2952_poweroff_driver);
> +}
> +
> +static void __exit ltc2952_poweroff_platform_exit(void)
> +{
> +	atomic_notifier_chain_unregister(&panic_notifier_list,
> +		&ltc2952_poweroff_panic_nb);
> +
> +	platform_driver_unregister(&ltc2952_poweroff_driver);
> +}
> +
> +module_init(ltc2952_poweroff_platform_init);
> +module_exit(ltc2952_poweroff_platform_exit);
> +
> +MODULE_AUTHOR("Ren? Moll <linux@r-moll.nl>");
> +MODULE_AUTHOR("Frans KLaver <frans.klaver@xsens.com>");
> +MODULE_AUTHOR("Tjerk Hofmeijer <tjerk.hofmeijer@xsens.com>");
> +MODULE_DESCRIPTION("LTC PowerPath power-off driver");
> +MODULE_LICENSE("GPL v2");
> -- 
> 2.1.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
> 
