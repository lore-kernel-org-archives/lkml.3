Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752989AbaHUQ76 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 12:59:58 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:54443 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752899AbaHUQ7z convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 12:59:55 -0400
From: "Murphy, Dan" <dmurphy@ti.com>
To: "Menon, Nishanth" <nm@ti.com>, Dmitry Torokhov <dtor@mail.ru>,
        "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
CC: "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH V2 2/2] Input: misc: introduce palmas-pwrbutton
Thread-Topic: [PATCH V2 2/2] Input: misc: introduce palmas-pwrbutton
Thread-Index: AQHPvVmPSBoHiwpjW0OMgiSDUUUlVQ==
Date: Thu, 21 Aug 2014 16:59:21 +0000
Message-ID: <00FC9A978A94B7418C33AFAE8A35ED49DF0662@DFLE09.ent.ti.com>
References: <1408392810-16011-1-git-send-email-nm@ti.com>
 <1408636935-29515-1-git-send-email-nm@ti.com>
 <1408636935-29515-3-git-send-email-nm@ti.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.170.170.90]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/21/2014 11:04 AM, Menon, Nishanth wrote:
> Many palmas family of PMICs have support for interrupt based power
> button. This allows the device to notify the processor of external
> push button events over the shared palmas interrupt. However, this
> event is generated only during a "press" operation. Software is
> supposed to poll(sigh!) for detecting a release event.
> 
> The PMIC also supports ability to power off independent of the
> software decisions when the button is pressed for a long duration if
> the PMIC is appropriately configured on the platform.
> 
> Even though the function is similar to twl4030_pwrbutton, it is
> substantially different in operation to belong to a new driver of it's
> own.
> 
> Based on original work done by Girish S Ghongdemath <girishsg@ti.com>
> 
> Signed-off-by: Nishanth Menon <nm@ti.com>
> ---
> Changes in v2:
>  - review comments incorporated
>  - debounce programming for TWL variants that actually support it.
> V1: https://patchwork.kernel.org/patch/4739041/
> 
>  drivers/input/misc/Kconfig            |   10 +
>  drivers/input/misc/Makefile           |    1 +
>  drivers/input/misc/palmas-pwrbutton.c |  356 +++++++++++++++++++++++++++++++++
>  3 files changed, 367 insertions(+)
>  create mode 100644 drivers/input/misc/palmas-pwrbutton.c
> 
> diff --git a/drivers/input/misc/Kconfig b/drivers/input/misc/Kconfig
> index 2ff4425..0224dcf 100644
> --- a/drivers/input/misc/Kconfig
> +++ b/drivers/input/misc/Kconfig
> @@ -451,6 +451,16 @@ config HP_SDC_RTC
>  	  Say Y here if you want to support the built-in real time clock
>  	  of the HP SDC controller.
>  
> +config INPUT_PALMAS_PWRBUTTON
> +	tristate "Palmas Power button Driver"
> +	depends on MFD_PALMAS
> +	help
> +	  Say Y here if you want to enable power key reporting via the
> +	  Palmas family of PMICs.
> +
> +	  To compile this driver as a module, choose M here. The module will
> +	  be called palmas_pwrbutton.
> +
>  config INPUT_PCF50633_PMU
>  	tristate "PCF50633 PMU events"
>  	depends on MFD_PCF50633
> diff --git a/drivers/input/misc/Makefile b/drivers/input/misc/Makefile
> index 4955ad3..e3d5efb 100644
> --- a/drivers/input/misc/Makefile
> +++ b/drivers/input/misc/Makefile
> @@ -40,6 +40,7 @@ obj-$(CONFIG_INPUT_MAX8997_HAPTIC)	+= max8997_haptic.o
>  obj-$(CONFIG_INPUT_MC13783_PWRBUTTON)	+= mc13783-pwrbutton.o
>  obj-$(CONFIG_INPUT_MMA8450)		+= mma8450.o
>  obj-$(CONFIG_INPUT_MPU3050)		+= mpu3050.o
> +obj-$(CONFIG_INPUT_PALMAS_PWRBUTTON)	+= palmas-pwrbutton.o
>  obj-$(CONFIG_INPUT_PCAP)		+= pcap_keys.o
>  obj-$(CONFIG_INPUT_PCF50633_PMU)	+= pcf50633-input.o
>  obj-$(CONFIG_INPUT_PCF8574)		+= pcf8574_keypad.o
> diff --git a/drivers/input/misc/palmas-pwrbutton.c b/drivers/input/misc/palmas-pwrbutton.c
> new file mode 100644
> index 0000000..fb8bfc5
> --- /dev/null
> +++ b/drivers/input/misc/palmas-pwrbutton.c
> @@ -0,0 +1,356 @@
> +/*
> + * Texas Instruments' Palmas Power Button Input Driver
> + *
> + * Copyright (C) 2012-2014 Texas Instruments Incorporated - http://www.ti.com/
> + *	Girish S Ghongdemath
> + *	Nishanth Menon
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + *
> + * This program is distributed "as is" WITHOUT ANY WARRANTY of any
> + * kind, whether express or implied; without even the implied warranty
> + * of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + */
> +#include <linux/init.h>
> +#include <linux/input.h>
> +#include <linux/interrupt.h>
> +#include <linux/kernel.h>
> +#include <linux/mfd/palmas.h>
> +#include <linux/module.h>
> +#include <linux/of.h>
> +#include <linux/platform_device.h>
> +#include <linux/reboot.h>

I don't see any reboot calls made do we need this?

> +#include <linux/slab.h>
> +
> +#define PALMAS_LPK_TIME_MASK		0x0c
> +#define PALMAS_PWRON_DEBOUNCE_MASK	0x03
> +#define PALMAS_PWR_KEY_PRESS		0x01
> +#define PALMAS_PWR_KEY_Q_TIME_MS	20
> +
> +/**
> + * struct palmas_pwron - Palmas power on data
> + * @palmas:		pointer to palmas device
> + * @input_dev:		pointer to input device
> + * @irq:		irq that we are hooked on to
> + * @input_work:		work for detecting release of key
> + * @current_state:	key current state
> + * @key_recheck_ms:	duration for recheck of key (in milli-seconds)
> + */
> +struct palmas_pwron {
> +	struct palmas *palmas;
> +	struct input_dev *input_dev;
> +	int irq;
> +	struct delayed_work input_work;
> +	int current_state;
> +	u32 key_recheck_ms;
> +};
> +
> +/**
> + * struct palmas_pwron_config - configuration of palmas power on
> + * @long_press_time_val:	value for long press h/w shutdown event
> + * @pwron_debounce_val:		value for debounce of power button
> + */
> +struct palmas_pwron_config {
> +	u8 long_press_time_val;
> +	u8 pwron_debounce_val;
> +};
> +
> +/**
> + * palmas_get_pwr_state() - read button state
> + * @pwron: pointer to pwron struct
> + *
> + * Return: 0 for no press, PALMAS_PWR_KEY_PRESS for keypress
> + * and on error, appropriate error value.
> + */
> +static int palmas_get_pwr_state(struct palmas_pwron *pwron)
> +{
> +	struct input_dev *input_dev = pwron->input_dev;
> +	struct device *dev = input_dev->dev.parent;
> +	unsigned int reg = 0;
> +	int ret;
> +
> +	ret = palmas_read(pwron->palmas, PALMAS_INTERRUPT_BASE,
> +			  PALMAS_INT1_LINE_STATE, &reg);
> +	if (ret) {
> +		dev_err(dev, "%s:Cannot read palmas PWRON status(%d)\n",
> +			__func__, ret);
> +		return ret;
> +	}
> +
> +	/* PWRON line state is BIT(1) of the register */
> +	return reg & BIT(1) ? 0 : PALMAS_PWR_KEY_PRESS;
> +}
> +
> +/**
> + * palmas_power_button_work() - Detects the button release event
> + * @work:	work item to detect button release
> + */
> +static void palmas_power_button_work(struct work_struct *work)
> +{
> +	struct palmas_pwron *pwron = container_of((struct delayed_work *)work,
> +						  struct palmas_pwron,
> +						  input_work);
> +	struct input_dev *input_dev = pwron->input_dev;
> +	int next_state;
> +
> +	next_state = palmas_get_pwr_state(pwron);
> +	if (next_state < 0)
> +		return;
> +
> +	/*
> +	 * If the state did not change then schedule a work item to check the
> +	 * status of the power button line
> +	 */
> +	if (next_state == pwron->current_state) {
> +		schedule_delayed_work(&pwron->input_work,
> +				      msecs_to_jiffies(pwron->key_recheck_ms));
> +		return;
> +	}
> +
> +	pwron->current_state = next_state;
> +	input_report_key(input_dev, KEY_POWER, pwron->current_state);
> +	input_sync(input_dev);
> +}
> +
> +/**
> + * pwron_irq() - button press isr
> + * @irq:		irq
> + * @palmas_pwron:	pwron struct
> + *
> + * Return: IRQ_HANDLED
> + */
> +static irqreturn_t pwron_irq(int irq, void *palmas_pwron)
> +{
> +	struct palmas_pwron *pwron = palmas_pwron;
> +	struct input_dev *input_dev = pwron->input_dev;
> +
> +	pwron->current_state = PALMAS_PWR_KEY_PRESS;
> +
> +	input_report_key(input_dev, KEY_POWER, pwron->current_state);
> +	pm_wakeup_event(input_dev->dev.parent, 0);
> +	input_sync(input_dev);
> +
> +	mod_delayed_work(system_wq, &pwron->input_work,
> +			 msecs_to_jiffies(pwron->key_recheck_ms));
> +
> +	return IRQ_HANDLED;
> +}
> +
> +/**
> + * palmas_pwron_params_ofinit() - device tree parameter parser
> + * @dev:	palmas button device
> + * @config:	configuration params that this fills up
> + */
> +static void palmas_pwron_params_ofinit(struct device *dev,
> +				       struct palmas_pwron_config *config)

Maybe we should change this to return an int so that if the DT is not populated
then the LPK and debounce is not set but we continue anyway.

Is there support for platform data itself?

> +{
> +	struct device_node *np;
> +	u32 val;
> +	int i;
> +	u8 lpk_times[] = { 6, 8, 10, 12 };
> +	int pwr_on_deb_ms[] = { 15, 100, 500, 1000 };
> +
> +	/* Legacy boot? */
> +	if (!of_have_populated_dt())
> +		return;
> +
> +	np = of_node_get(dev->of_node);
> +	/* Mixed boot? */

Can we expand a little on Mixed boot vs legacy boot?

> +	if (!np)
> +		return;
> +
> +	val = 0;

Is this necessary?

> +	of_property_read_u32(np, "ti,palmas-long-press-seconds", &val);

Probably should check the return to make sure the value exists and that is is
within an expected range.  Since this is an optional parameter it may not be
populated.  And below it sets a preliminary value to the max as the default.

Maybe the default setting should be set at the beginning of this function so
that if there is no dt data then at least the values will be defaulted.

> +	config->long_press_time_val = ARRAY_SIZE(lpk_times) - 1;
> +	for (i = 0; i < ARRAY_SIZE(lpk_times); i++) {
> +		if (val <= lpk_times[i]) {
> +			config->long_press_time_val = i;
> +			break;
> +		}
> +	}
> +
> +	val = 0;

Don't think we need this either if we check the return on the call
below.

> +	of_property_read_u32(np, "ti,palmas-pwron-debounce-milli-seconds",
> +			     &val);


Probably should check the return to make sure the value exists and that is is
within an expected range.

> +	config->pwron_debounce_val = 0;

Should this not have been 0 anyway?

> +	for (i = 0; i < ARRAY_SIZE(pwr_on_deb_ms); i++) {
> +		if (val <= pwr_on_deb_ms[i]) {
> +			config->pwron_debounce_val = i;
> +			break;
> +		}
> +	}
> +
> +	dev_info(dev, "h/w controlled shutdown duration=%d seconds\n",
> +		 lpk_times[config->long_press_time_val]);
> +
> +	of_node_put(np);
> +}
> +
> +/**
> + * palmas_pwron_probe() - probe
> + * @pdev:	platform device for the button
> + *
> + * Return: 0 for successful probe else appropriate error
> + */
> +static int palmas_pwron_probe(struct platform_device *pdev)
> +{
> +	struct palmas *palmas = dev_get_drvdata(pdev->dev.parent);
> +	struct device *dev = &pdev->dev;
> +	struct input_dev *input_dev;
> +	struct palmas_pwron *pwron;
> +	int irq, ret, val;
> +	struct palmas_pwron_config config = { 0 };
> +
> +	palmas_pwron_params_ofinit(dev, &config);
> +
> +	pwron = devm_kzalloc(dev, sizeof(*pwron), GFP_KERNEL);
> +	if (!pwron)
> +		return -ENOMEM;
> +
> +	input_dev = devm_input_allocate_device(dev);
> +	if (!input_dev) {
> +		dev_err(dev, "Can't allocate power button\n");
> +		return -ENOMEM;
> +	}
> +
> +	/*
> +	 * Setup default hardware shutdown option (long key press)
> +	 * and debounce.
> +	 */
> +	val = config.long_press_time_val << __ffs(PALMAS_LPK_TIME_MASK);
> +	val |= config.pwron_debounce_val << __ffs(PALMAS_PWRON_DEBOUNCE_MASK);
> +	ret = palmas_update_bits(palmas, PALMAS_PMU_CONTROL_BASE,
> +				 PALMAS_LONG_PRESS_KEY,
> +				 PALMAS_LPK_TIME_MASK |
> +				 PALMAS_PWRON_DEBOUNCE_MASK, val);
> +	if (ret < 0) {
> +		dev_err(dev, "LONG_PRESS_KEY_UPDATE failed!\n");
> +		return ret;
> +	}
> +
> +	input_dev->evbit[0] = BIT_MASK(EV_KEY);
> +	input_dev->keybit[BIT_WORD(KEY_POWER)] = BIT_MASK(KEY_POWER);
> +	input_dev->name = "palmas_pwron";
> +	input_dev->phys = "palmas_pwron/input0";
> +	input_dev->dev.parent = dev;
> +
> +	pwron->palmas = palmas;
> +	pwron->input_dev = input_dev;
> +
> +	INIT_DELAYED_WORK(&pwron->input_work, palmas_power_button_work);
> +
> +	irq = platform_get_irq(pdev, 0);
> +	ret = request_threaded_irq(irq, NULL, pwron_irq,
> +				   IRQF_TRIGGER_HIGH |
> +				   IRQF_TRIGGER_LOW, dev_name(dev), pwron);
> +	if (ret < 0) {
> +		dev_err(dev, "Can't get IRQ for pwron: %d\n", ret);
> +		return ret;
> +	}
> +
> +	device_init_wakeup(dev, true);
> +
> +	ret = input_register_device(input_dev);
> +	if (ret) {
> +		free_irq(irq, pwron);
> +		cancel_delayed_work_sync(&pwron->input_work);
> +		dev_dbg(dev, "Can't register power button: %d\n", ret);
> +		return ret;
> +	}
> +	pwron->irq = irq;
> +
> +	pwron->key_recheck_ms = PALMAS_PWR_KEY_Q_TIME_MS;
> +
> +	platform_set_drvdata(pdev, pwron);
> +
> +	return 0;
> +}
> +
> +/**
> + * palmas_pwron_remove() - Cleanup on removal
> + * @pdev:	platform device for the button
> + *
> + * Return: 0
> + */
> +static int palmas_pwron_remove(struct platform_device *pdev)
> +{
> +	struct palmas_pwron *pwron = platform_get_drvdata(pdev);
> +
> +	free_irq(pwron->irq, pwron);
> +	cancel_delayed_work_sync(&pwron->input_work);
> +	input_unregister_device(pwron->input_dev);
> +
> +	return 0;
> +}
> +
> +/**
> + * palmas_pwron_suspend() - suspend handler
> + * @dev:	power button device
> + *
> + * Cancel all pending work items for the power button, setup irq for wakeup
> + *
> + * Return: 0
> + */
> +static int palmas_pwron_suspend(struct device *dev)
> +{
> +	struct platform_device *pdev = to_platform_device(dev);
> +	struct palmas_pwron *pwron = platform_get_drvdata(pdev);
> +
> +	cancel_delayed_work_sync(&pwron->input_work);
> +
> +	if (device_may_wakeup(dev))
> +		enable_irq_wake(pwron->irq);
> +
> +	return 0;
> +}
> +
> +/**
> + * palmas_pwron_resume() - resume handler
> + * @dev:	power button device
> + *
> + * Just disable the wakeup capability of irq here.
> + *
> + * Return: 0
> + */
> +static int palmas_pwron_resume(struct device *dev)
> +{
> +	struct platform_device *pdev = to_platform_device(dev);
> +	struct palmas_pwron *pwron = platform_get_drvdata(pdev);
> +
> +	if (device_may_wakeup(dev))
> +		disable_irq_wake(pwron->irq);
> +
> +	return 0;
> +}
> +
> +static SIMPLE_DEV_PM_OPS(palmas_pwron_pm,
> +			 palmas_pwron_suspend, palmas_pwron_resume);
> +
> +#ifdef CONFIG_OF
> +static struct of_device_id of_palmas_pwr_match[] = {
> +	{.compatible = "ti,palmas-pwrbutton"},
> +	{},
> +};
> +
> +MODULE_DEVICE_TABLE(of, of_palmas_pwr_match);
> +#endif
> +
> +static struct platform_driver palmas_pwron_driver = {
> +	.probe = palmas_pwron_probe,
> +	.remove = palmas_pwron_remove,
> +	.driver = {
> +		   .name = "palmas_pwrbutton",
> +		   .owner = THIS_MODULE,
> +		   .of_match_table = of_match_ptr(of_palmas_pwr_match),
> +		   .pm = &palmas_pwron_pm,
> +	},
> +};
> +module_platform_driver(palmas_pwron_driver);
> +
> +MODULE_ALIAS("platform:palmas-pwrbutton");
> +MODULE_DESCRIPTION("Palmas Power Button");
> +MODULE_LICENSE("GPL V2");
> +MODULE_AUTHOR("Texas Instruments Inc.");
> 


-- 
------------------
Dan Murphy
