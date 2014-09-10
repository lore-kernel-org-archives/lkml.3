Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753653AbaIJVOB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 17:14:01 -0400
Received: from mail-pa0-f45.google.com ([209.85.220.45]:56179 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751971AbaIJVN6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 17:13:58 -0400
Date: Wed, 10 Sep 2014 14:13:53 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Nishanth Menon <nm@ti.com>
Cc: "Murphy, Dan" <dmurphy@ti.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH V2 2/2] Input: misc: introduce palmas-pwrbutton
Message-ID: <20140910211353.GE38736@core.coreip.homeip.net>
References: <1408392810-16011-1-git-send-email-nm@ti.com>
 <1408636935-29515-1-git-send-email-nm@ti.com>
 <1408636935-29515-3-git-send-email-nm@ti.com>
 <00FC9A978A94B7418C33AFAE8A35ED49DF0662@DFLE09.ent.ti.com>
 <53F62A2B.6010208@ti.com>
 <00FC9A978A94B7418C33AFAE8A35ED49DF07A2@DFLE09.ent.ti.com>
 <20140821173715.GA23419@kahuna>
 <20140821180300.GA5854@core.coreip.homeip.net>
 <53F64217.5020303@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53F64217.5020303@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Nishanth,

On Thu, Aug 21, 2014 at 02:01:43PM -0500, Nishanth Menon wrote:
> On 08/21/2014 01:03 PM, Dmitry Torokhov wrote:
> 
> I believe I have taken care of other concerns on v2, but..Arrgh.. I
> did not reply to this comment..
> > BTW, I do not think you need to use of_node_get/put here, it's not going anywhere.
> It has been mentioned as a good practice to ensure we use get_put in
> to ensure reference count is appropriately maintained. So, I have'nt
> changed that in v3.

You only need to maintain reference count if you pass the handle on.
Otherwise you'd have to do get/put every time you dereference something.

Anyway, I did a few changes to the driver (no need to store current
state, do not fre einput device after unregister, etc.), could you
please tell me if the version below still works for you?

Thanks.

-- 
Dmitry

Input: introduce palmas-pwrbutton

From: Nishanth Menon <nm@ti.com>

Many palmas family of PMICs have support for interrupt based power button.
This allows the device to notify the processor of external push button
events over the shared palmas interrupt. However, this event is generated
only during a "press" operation. Software is supposed to poll(sigh!) for
detecting a release event.

The PMIC also supports ability to power off independent of the software
decisions when the button is pressed for a long duration if the PMIC is
appropriately configured on the platform.

Even though the function is similar to twl4030_pwrbutton, it is
substantially different in operation to belong to a new driver of it's own.

Based on original work done by Girish S Ghongdemath <girishsg@ti.com>

Signed-off-by: Nishanth Menon <nm@ti.com>
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
---
 .../bindings/input/ti,palmas-pwrbutton.txt         |   36 ++
 drivers/input/misc/Kconfig                         |   10 +
 drivers/input/misc/Makefile                        |    1 
 drivers/input/misc/palmas-pwrbutton.c              |  330 ++++++++++++++++++++
 4 files changed, 377 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/input/ti,palmas-pwrbutton.txt
 create mode 100644 drivers/input/misc/palmas-pwrbutton.c

diff --git a/Documentation/devicetree/bindings/input/ti,palmas-pwrbutton.txt b/Documentation/devicetree/bindings/input/ti,palmas-pwrbutton.txt
new file mode 100644
index 0000000..a3dde8c
--- /dev/null
+++ b/Documentation/devicetree/bindings/input/ti,palmas-pwrbutton.txt
@@ -0,0 +1,36 @@
+Texas Instruments Palmas family power button module
+
+This module is part of the Palmas family of PMICs. For more details
+about the whole chip see:
+Documentation/devicetree/bindings/mfd/palmas.txt.
+
+This module provides a simple power button event via an Interrupt.
+
+Required properties:
+- compatible: should be one of the following
+   - "ti,palmas-pwrbutton": For Palmas compatible power on button
+- interrupt-parent: Parent interrupt device, must be handle of palmas node.
+- interrupts: Interrupt number of power button submodule on device.
+
+Optional Properties:
+
+- ti,palmas-long-press-seconds: Duration in seconds which the power
+  button should be kept pressed for Palmas to power off automatically.
+  NOTE: This depends on OTP support and POWERHOLD signal configuration
+  on platform. Valid values are 6, 8, 10 and 12.
+- ti,palmas-pwron-debounce-milli-seconds: Duration in milliseconds
+  which the power button should be kept pressed for Palmas to register
+  a press for debouncing purposes. NOTE: This depends on specific
+  Palmas variation capability. Valid values are 15, 100, 500 and 1000.
+
+Example:
+
+&palmas {
+	palmas_pwr_button: pwrbutton {
+		compatible = "ti,palmas-pwrbutton";
+		interrupt-parent = <&tps659038>;
+		interrupts = <1 IRQ_TYPE_EDGE_FALLING>;
+		ti,palmas-long-press-seconds = <12>;
+		ti,palmas-pwron-debounce-milli-seconds = <15>;
+	};
+};
diff --git a/drivers/input/misc/Kconfig b/drivers/input/misc/Kconfig
index 51891f6..36382e5 100644
--- a/drivers/input/misc/Kconfig
+++ b/drivers/input/misc/Kconfig
@@ -451,6 +451,16 @@ config HP_SDC_RTC
 	  Say Y here if you want to support the built-in real time clock
 	  of the HP SDC controller.
 
+config INPUT_PALMAS_PWRBUTTON
+	tristate "Palmas Power button Driver"
+	depends on MFD_PALMAS
+	help
+	  Say Y here if you want to enable power key reporting via the
+	  Palmas family of PMICs.
+
+	  To compile this driver as a module, choose M here. The module will
+	  be called palmas_pwrbutton.
+
 config INPUT_PCF50633_PMU
 	tristate "PCF50633 PMU events"
 	depends on MFD_PCF50633
diff --git a/drivers/input/misc/Makefile b/drivers/input/misc/Makefile
index e0cee17..e8b84d2 100644
--- a/drivers/input/misc/Makefile
+++ b/drivers/input/misc/Makefile
@@ -42,6 +42,7 @@ obj-$(CONFIG_INPUT_MAX8997_HAPTIC)	+= max8997_haptic.o
 obj-$(CONFIG_INPUT_MC13783_PWRBUTTON)	+= mc13783-pwrbutton.o
 obj-$(CONFIG_INPUT_MMA8450)		+= mma8450.o
 obj-$(CONFIG_INPUT_MPU3050)		+= mpu3050.o
+obj-$(CONFIG_INPUT_PALMAS_PWRBUTTON)	+= palmas-pwrbutton.o
 obj-$(CONFIG_INPUT_PCAP)		+= pcap_keys.o
 obj-$(CONFIG_INPUT_PCF50633_PMU)	+= pcf50633-input.o
 obj-$(CONFIG_INPUT_PCF8574)		+= pcf8574_keypad.o
diff --git a/drivers/input/misc/palmas-pwrbutton.c b/drivers/input/misc/palmas-pwrbutton.c
new file mode 100644
index 0000000..3f90211
--- /dev/null
+++ b/drivers/input/misc/palmas-pwrbutton.c
@@ -0,0 +1,330 @@
+/*
+ * Texas Instruments' Palmas Power Button Input Driver
+ *
+ * Copyright (C) 2012-2014 Texas Instruments Incorporated - http://www.ti.com/
+ *	Girish S Ghongdemath
+ *	Nishanth Menon
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed "as is" WITHOUT ANY WARRANTY of any
+ * kind, whether express or implied; without even the implied warranty
+ * of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include <linux/init.h>
+#include <linux/input.h>
+#include <linux/interrupt.h>
+#include <linux/kernel.h>
+#include <linux/mfd/palmas.h>
+#include <linux/module.h>
+#include <linux/of.h>
+#include <linux/platform_device.h>
+#include <linux/slab.h>
+
+#define PALMAS_LPK_TIME_MASK		0x0c
+#define PALMAS_PWRON_DEBOUNCE_MASK	0x03
+#define PALMAS_PWR_KEY_Q_TIME_MS	20
+
+/**
+ * struct palmas_pwron - Palmas power on data
+ * @palmas:		pointer to palmas device
+ * @input_dev:		pointer to input device
+ * @input_work:		work for detecting release of key
+ * @irq:		irq that we are hooked on to
+ */
+struct palmas_pwron {
+	struct palmas *palmas;
+	struct input_dev *input_dev;
+	struct delayed_work input_work;
+	int irq;
+};
+
+/**
+ * struct palmas_pwron_config - configuration of palmas power on
+ * @long_press_time_val:	value for long press h/w shutdown event
+ * @pwron_debounce_val:		value for debounce of power button
+ */
+struct palmas_pwron_config {
+	u8 long_press_time_val;
+	u8 pwron_debounce_val;
+};
+
+/**
+ * palmas_power_button_work() - Detects the button release event
+ * @work:	work item to detect button release
+ */
+static void palmas_power_button_work(struct work_struct *work)
+{
+	struct palmas_pwron *pwron = container_of(work,
+						  struct palmas_pwron,
+						  input_work.work);
+	struct input_dev *input_dev = pwron->input_dev;
+	unsigned int reg;
+	int error;
+
+	error = palmas_read(pwron->palmas, PALMAS_INTERRUPT_BASE,
+			    PALMAS_INT1_LINE_STATE, &reg);
+	if (error) {
+		dev_err(input_dev->dev.parent,
+			"Cannot read palmas PWRON status: %d\n", error);
+	} else if (reg & BIT(1)) {
+		/* The button is released, report event. */
+		input_report_key(input_dev, KEY_POWER, 0);
+		input_sync(input_dev);
+	} else {
+		/* The button is still depressed, keep checking. */
+		schedule_delayed_work(&pwron->input_work,
+				msecs_to_jiffies(PALMAS_PWR_KEY_Q_TIME_MS));
+	}
+}
+
+/**
+ * pwron_irq() - button press isr
+ * @irq:		irq
+ * @palmas_pwron:	pwron struct
+ *
+ * Return: IRQ_HANDLED
+ */
+static irqreturn_t pwron_irq(int irq, void *palmas_pwron)
+{
+	struct palmas_pwron *pwron = palmas_pwron;
+	struct input_dev *input_dev = pwron->input_dev;
+
+	input_report_key(input_dev, KEY_POWER, 1);
+	pm_wakeup_event(input_dev->dev.parent, 0);
+	input_sync(input_dev);
+
+	mod_delayed_work(system_wq, &pwron->input_work,
+			 msecs_to_jiffies(PALMAS_PWR_KEY_Q_TIME_MS));
+
+	return IRQ_HANDLED;
+}
+
+/**
+ * palmas_pwron_params_ofinit() - device tree parameter parser
+ * @dev:	palmas button device
+ * @config:	configuration params that this fills up
+ */
+static void palmas_pwron_params_ofinit(struct device *dev,
+				       struct palmas_pwron_config *config)
+{
+	struct device_node *np;
+	u32 val;
+	int i, error;
+	u8 lpk_times[] = { 6, 8, 10, 12 };
+	int pwr_on_deb_ms[] = { 15, 100, 500, 1000 };
+
+	memset(config, 0, sizeof(*config));
+
+	/* Default config parameters */
+	config->long_press_time_val = ARRAY_SIZE(lpk_times) - 1;
+
+	np = dev->of_node;
+	if (!np)
+		return;
+
+	error = of_property_read_u32(np, "ti,palmas-long-press-seconds", &val);
+	if (!error) {
+		for (i = 0; i < ARRAY_SIZE(lpk_times); i++) {
+			if (val <= lpk_times[i]) {
+				config->long_press_time_val = i;
+				break;
+			}
+		}
+	}
+
+	error = of_property_read_u32(np,
+				     "ti,palmas-pwron-debounce-milli-seconds",
+				     &val);
+	if (!error) {
+		for (i = 0; i < ARRAY_SIZE(pwr_on_deb_ms); i++) {
+			if (val <= pwr_on_deb_ms[i]) {
+				config->pwron_debounce_val = i;
+				break;
+			}
+		}
+	}
+
+	dev_info(dev, "h/w controlled shutdown duration=%d seconds\n",
+		 lpk_times[config->long_press_time_val]);
+}
+
+/**
+ * palmas_pwron_probe() - probe
+ * @pdev:	platform device for the button
+ *
+ * Return: 0 for successful probe else appropriate error
+ */
+static int palmas_pwron_probe(struct platform_device *pdev)
+{
+	struct palmas *palmas = dev_get_drvdata(pdev->dev.parent);
+	struct device *dev = &pdev->dev;
+	struct input_dev *input_dev;
+	struct palmas_pwron *pwron;
+	struct palmas_pwron_config config;
+	int val;
+	int error;
+
+	palmas_pwron_params_ofinit(dev, &config);
+
+	pwron = kzalloc(sizeof(*pwron), GFP_KERNEL);
+	if (!pwron)
+		return -ENOMEM;
+
+	input_dev = input_allocate_device();
+	if (!input_dev) {
+		dev_err(dev, "Can't allocate power button\n");
+		error = -ENOMEM;
+		goto err_free_mem;
+	}
+
+	input_dev->name = "palmas_pwron";
+	input_dev->phys = "palmas_pwron/input0";
+	input_dev->dev.parent = dev;
+
+	input_set_capability(input_dev, EV_KEY, KEY_POWER);
+
+	/*
+	 * Setup default hardware shutdown option (long key press)
+	 * and debounce.
+	 */
+	val = config.long_press_time_val << __ffs(PALMAS_LPK_TIME_MASK);
+	val |= config.pwron_debounce_val << __ffs(PALMAS_PWRON_DEBOUNCE_MASK);
+	error = palmas_update_bits(palmas, PALMAS_PMU_CONTROL_BASE,
+				   PALMAS_LONG_PRESS_KEY,
+				   PALMAS_LPK_TIME_MASK |
+					PALMAS_PWRON_DEBOUNCE_MASK,
+				   val);
+	if (error) {
+		dev_err(dev, "LONG_PRESS_KEY_UPDATE failed: %d\n", error);
+		goto err_free_input;
+	}
+
+	pwron->palmas = palmas;
+	pwron->input_dev = input_dev;
+
+	INIT_DELAYED_WORK(&pwron->input_work, palmas_power_button_work);
+
+	pwron->irq = platform_get_irq(pdev, 0);
+	error = request_threaded_irq(pwron->irq, NULL, pwron_irq,
+				     IRQF_TRIGGER_HIGH | IRQF_TRIGGER_LOW,
+				     dev_name(dev), pwron);
+	if (error) {
+		dev_err(dev, "Can't get IRQ for pwron: %d\n", error);
+		goto err_free_input;
+	}
+
+	error = input_register_device(input_dev);
+	if (error) {
+		dev_err(dev, "Can't register power button: %d\n", error);
+		goto err_free_irq;
+	}
+
+	platform_set_drvdata(pdev, pwron);
+	device_init_wakeup(dev, true);
+
+	return 0;
+
+err_free_irq:
+	cancel_delayed_work_sync(&pwron->input_work);
+	free_irq(pwron->irq, pwron);
+err_free_input:
+	input_free_device(input_dev);
+err_free_mem:
+	kfree(pwron);
+	return error;
+}
+
+/**
+ * palmas_pwron_remove() - Cleanup on removal
+ * @pdev:	platform device for the button
+ *
+ * Return: 0
+ */
+static int palmas_pwron_remove(struct platform_device *pdev)
+{
+	struct palmas_pwron *pwron = platform_get_drvdata(pdev);
+
+	free_irq(pwron->irq, pwron);
+	cancel_delayed_work_sync(&pwron->input_work);
+
+	input_unregister_device(pwron->input_dev);
+	kfree(pwron);
+
+	return 0;
+}
+
+#ifdef CONFIG_PM_SLEEP
+/**
+ * palmas_pwron_suspend() - suspend handler
+ * @dev:	power button device
+ *
+ * Cancel all pending work items for the power button, setup irq for wakeup
+ *
+ * Return: 0
+ */
+static int palmas_pwron_suspend(struct device *dev)
+{
+	struct platform_device *pdev = to_platform_device(dev);
+	struct palmas_pwron *pwron = platform_get_drvdata(pdev);
+
+	cancel_delayed_work_sync(&pwron->input_work);
+
+	if (device_may_wakeup(dev))
+		enable_irq_wake(pwron->irq);
+
+	return 0;
+}
+
+/**
+ * palmas_pwron_resume() - resume handler
+ * @dev:	power button device
+ *
+ * Just disable the wakeup capability of irq here.
+ *
+ * Return: 0
+ */
+static int palmas_pwron_resume(struct device *dev)
+{
+	struct platform_device *pdev = to_platform_device(dev);
+	struct palmas_pwron *pwron = platform_get_drvdata(pdev);
+
+	if (device_may_wakeup(dev))
+		disable_irq_wake(pwron->irq);
+
+	return 0;
+}
+#endif
+
+static SIMPLE_DEV_PM_OPS(palmas_pwron_pm,
+			 palmas_pwron_suspend, palmas_pwron_resume);
+
+#ifdef CONFIG_OF
+static struct of_device_id of_palmas_pwr_match[] = {
+	{ .compatible = "ti,palmas-pwrbutton" },
+	{ },
+};
+
+MODULE_DEVICE_TABLE(of, of_palmas_pwr_match);
+#endif
+
+static struct platform_driver palmas_pwron_driver = {
+	.probe	= palmas_pwron_probe,
+	.remove	= palmas_pwron_remove,
+	.driver	= {
+		.name	= "palmas_pwrbutton",
+		.owner	= THIS_MODULE,
+		.of_match_table = of_match_ptr(of_palmas_pwr_match),
+		.pm	= &palmas_pwron_pm,
+	},
+};
+module_platform_driver(palmas_pwron_driver);
+
+MODULE_ALIAS("platform:palmas-pwrbutton");
+MODULE_DESCRIPTION("Palmas Power Button");
+MODULE_LICENSE("GPL V2");
+MODULE_AUTHOR("Texas Instruments Inc.");
