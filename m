Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753166AbaJPU0m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 16:26:42 -0400
Received: from mail-la0-f53.google.com ([209.85.215.53]:56981 "EHLO
	mail-la0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752528AbaJPU0j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 16:26:39 -0400
From: Marek Belisko <marek@goldelico.com>
To: arnd@arndb.de, gregkh@linuxfoundation.org
Cc: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        grant.likely@linaro.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, Marek Belisko <marek@goldelico.com>,
        NeilBrown <neilb@suse.de>, "H. Nikolaus Schaller" <hns@goldelico.com>
Subject: [PATCH 1/2] misc: Add Wi2Wi w2sc0004 gps driver
Date: Thu, 16 Oct 2014 22:26:22 +0200
Message-Id: <1413491183-15018-1-git-send-email-marek@goldelico.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a driver for the Wi2Wi GPS modules connected through an UART.
The tricky part is that the module is turned on or off by an impulse
on the control line - but it is only possible to get the real state by monitoring
the UART RX input. Since the kernel can't know in which status the module
is brought e.g. by a boot loader or after suspend, we need some logic to handle
this.

The driver allows two different methods to enable (and power up) GPS:
a) through rfkill
b) as a GPIO

The GPIO enable can be plumbed to other drivers that expect to be able to control
a GPIO. On the GTA04 board this is the DTR-gpio of the connected UART so that
opening the UART device enables the receiver and closing it shuts the receiver down.

Original implementation by Neil Brown, fixes + DT bindings by H. Nikolaus Schaller

Signed-off-by: NeilBrown <neilb@suse.de>
Signed-off-by: H. Nikolaus Schaller <hns@goldelico.com>
Signed-off-by: Marek Belisko <marek@goldelico.com>
---
 drivers/misc/Kconfig     |  10 +
 drivers/misc/Makefile    |   1 +
 drivers/misc/w2sg0004.c  | 512 +++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/w2sg0004.h |  23 +++
 4 files changed, 546 insertions(+)
 create mode 100644 drivers/misc/w2sg0004.c
 create mode 100644 include/linux/w2sg0004.h

diff --git a/drivers/misc/Kconfig b/drivers/misc/Kconfig
index bbeb451..03af633 100644
--- a/drivers/misc/Kconfig
+++ b/drivers/misc/Kconfig
@@ -515,6 +515,16 @@ config VEXPRESS_SYSCFG
 	  bus. System Configuration interface is one of the possible means
 	  of generating transactions on this bus.
 
+config W2SG0004
+	tristate "W2SG0004 on/off control"
+	depends on GPIOLIB
+	help
+	  Enable on/off control of W2SG0004 GPS using a virtual GPIO.
+	  The virtual GPIO can be connected to a DTR line of a serial
+	  interface to allow powering up if the /dev/tty$n is opened.
+	  It also provides a rfkill gps node to control the LNA power.
+	  NOTE: can't currently be compiled as module, so please choose Y.
+
 source "drivers/misc/c2port/Kconfig"
 source "drivers/misc/eeprom/Kconfig"
 source "drivers/misc/cb710/Kconfig"
diff --git a/drivers/misc/Makefile b/drivers/misc/Makefile
index 7d5c4cd..2f83270 100644
--- a/drivers/misc/Makefile
+++ b/drivers/misc/Makefile
@@ -56,3 +56,4 @@ obj-$(CONFIG_GENWQE)		+= genwqe/
 obj-$(CONFIG_ECHO)		+= echo/
 obj-$(CONFIG_VEXPRESS_SYSCFG)	+= vexpress-syscfg.o
 obj-$(CONFIG_CXL_BASE)		+= cxl/
+obj-${CONFIG_W2SG0004}		+= w2sg0004.o
diff --git a/drivers/misc/w2sg0004.c b/drivers/misc/w2sg0004.c
new file mode 100644
index 0000000..8f0afcf
--- /dev/null
+++ b/drivers/misc/w2sg0004.c
@@ -0,0 +1,512 @@
+/*
+ * w2sg0004.c
+ * Virtual GPIO of controlling the w2sg0004 GPS receiver.
+ *
+ * Copyright (C) 2011 Neil Brown <neil@brown.name>
+ *
+ * This receiver has an ON/OFF pin which must be toggled to
+ * turn the device 'on' or 'off'.  A high->low->high toggle
+ * will switch the device on if it is off, and off if it is on.
+ * It is not possible to directly detect the state of the device.
+ * However when it is on it will send characters on a UART line
+ * regularly.
+ * On the OMAP3, the UART line can also be programmed as a GPIO
+ * on which we can receive interrupts.
+ * So when we want the device to be 'off' we can reprogram
+ * the line, toggle the ON/OFF pin and hope that it is off.
+ * However if an interrupt arrives we know that it is really on
+ * and can toggle again.
+ *
+ * To enable receiving on/off requests we create a gpio_chip
+ * with a single 'output' GPIO.  When it is low, the
+ * GPS is turned off.  When it is high, it is turned on.
+ * This can be configured as the DTR GPIO on the UART which
+ * connects the GPS.  Then whenever the tty is open, the GPS
+ * will be switched on, and whenever it is closed, the GPS will
+ * be switched off.
+ *
+ * In addition we register as a rfkill client so that we can
+ * control the LNA power.
+ *
+ */
+
+#include <linux/module.h>
+#include <linux/interrupt.h>
+#include <linux/sched.h>
+#include <linux/irq.h>
+#include <linux/slab.h>
+#include <linux/err.h>
+#include <linux/delay.h>
+#include <linux/of.h>
+#include <linux/of_irq.h>
+#include <linux/gpio.h>
+#include <linux/of_gpio.h>
+#include <linux/platform_device.h>
+#include <linux/w2sg0004.h>
+#include <linux/workqueue.h>
+#include <linux/rfkill.h>
+#include <linux/pinctrl/consumer.h>
+
+/*
+ * There seems to restrictions on how quickly we can toggle the
+ * on/off line.  data sheets says "two rtc ticks", whatever that means.
+ * If we do it too soon it doesn't work.
+ * So we have a state machine which uses the common work queue to ensure
+ * clean transitions.
+ * When a change is requested we record that request and only act on it
+ * once the previous change has completed.
+ * A change involves a 10ms low pulse, and a 990ms raised level, so only
+ * one change per second.
+ */
+
+enum w2sg_state {
+	W2SG_IDLE,	/* is not changing state */
+	W2SG_PULSE,	/* activate on/off impulse */
+	W2SG_NOPULSE	/* desctivate on/off impulse */
+};
+
+struct gpio_w2sg {
+	struct		rfkill *rf_kill;
+	struct		regulator *lna_regulator;
+	int		lna_blocked;	/* rfkill block gps active */
+	int		lna_is_off;	/* LNA is currently off */
+	int		is_on;		/* current state (0/1) */
+	unsigned long	last_toggle;
+	unsigned long	backoff;	/* time to wait since last_toggle */
+	int		on_off_gpio;
+	int		rx_irq;
+
+	struct pinctrl *p;
+	struct pinctrl_state *default_state;	/* should be UART mode */
+	struct pinctrl_state *monitor_state;	/* monitor RX as GPIO */
+	enum w2sg_state	state;
+	int		requested;	/* requested state (0/1) */
+	int		suspended;
+	int		rx_redirected;
+	spinlock_t	lock;
+#ifdef CONFIG_GPIOLIB
+	struct gpio_chip gpio;
+	const char	*gpio_name[1];
+#endif
+	struct delayed_work work;
+};
+
+static int gpio_w2sg_set_lna_power(struct gpio_w2sg *gw2sg)
+{
+	int ret = 0;
+	int off = gw2sg->suspended || !gw2sg->requested || gw2sg->lna_blocked;
+
+	pr_debug("gpio_w2sg_set_lna_power: %s\n", off ? "off" : "on");
+
+	if (off != gw2sg->lna_is_off) {
+		gw2sg->lna_is_off = off;
+		if (!IS_ERR_OR_NULL(gw2sg->lna_regulator)) {
+			if (off)
+				regulator_disable(gw2sg->lna_regulator);
+			else
+				ret = regulator_enable(gw2sg->lna_regulator);
+		}
+	}
+
+	return ret;
+}
+
+static void toggle_work(struct work_struct *work)
+{
+	struct gpio_w2sg *gw2sg = container_of(work, struct gpio_w2sg,
+						work.work);
+
+	gpio_w2sg_set_lna_power(gw2sg);	/* update LNA power state */
+
+	switch (gw2sg->state) {
+	case W2SG_NOPULSE:
+		gw2sg->state = W2SG_IDLE;
+		pr_debug("GPS idle\n");
+		break;
+
+	case W2SG_IDLE:
+		spin_lock_irq(&gw2sg->lock);
+		if (gw2sg->requested == gw2sg->is_on) {
+			if (!gw2sg->is_on && !gw2sg->rx_redirected) {
+				/* not yet redirected in off state */
+				gw2sg->rx_redirected = 1;
+				pinctrl_select_state(gw2sg->p,
+							gw2sg->monitor_state);
+				enable_irq(gw2sg->rx_irq);
+			}
+			spin_unlock_irq(&gw2sg->lock);
+			return;
+		}
+		spin_unlock_irq(&gw2sg->lock);
+		gpio_set_value_cansleep(gw2sg->on_off_gpio, 0);
+		gw2sg->state = W2SG_PULSE;
+
+		pr_debug("GPS pulse\n");
+
+		schedule_delayed_work(&gw2sg->work,
+				      msecs_to_jiffies(10));
+		break;
+
+	case W2SG_PULSE:
+		gpio_set_value_cansleep(gw2sg->on_off_gpio, 1);
+		gw2sg->last_toggle = jiffies;
+		gw2sg->state = W2SG_NOPULSE;
+
+		pr_debug("GPS nopulse\n");
+
+		gw2sg->is_on = !gw2sg->is_on;
+		schedule_delayed_work(&gw2sg->work,
+				      msecs_to_jiffies(10));
+		break;
+	}
+}
+
+static irqreturn_t gpio_w2sg_isr(int irq, void *dev_id)
+{
+	struct gpio_w2sg *gw2sg = dev_id;
+	unsigned long flags;
+
+	/* we have received a RX signal while GPS should be off */
+	pr_debug("!");
+
+	if (!gw2sg->requested && !gw2sg->is_on &&
+	    (gw2sg->state == W2SG_IDLE) &&
+	    time_after(jiffies,
+		       gw2sg->last_toggle + gw2sg->backoff)) {
+		/* Should be off by now, time to toggle again */
+		gw2sg->is_on = 1;
+		gw2sg->backoff *= 2;
+		spin_lock_irqsave(&gw2sg->lock, flags);
+		if (!gw2sg->suspended)
+			schedule_delayed_work(&gw2sg->work, 0);
+		spin_unlock_irqrestore(&gw2sg->lock, flags);
+	}
+
+	return IRQ_HANDLED;
+}
+
+static void gpio_w2sg_set_power(struct gpio_w2sg *gw2sg, int val)
+{
+	unsigned long flags;
+
+	pr_debug("GPS SET to %d\n", val);
+
+	spin_lock_irqsave(&gw2sg->lock, flags);
+
+	if (val && !gw2sg->requested) {
+		if (gw2sg->rx_redirected) {
+			gw2sg->rx_redirected = 0;
+			disable_irq(gw2sg->rx_irq);
+			pinctrl_select_state(gw2sg->p, gw2sg->default_state);
+		}
+		gw2sg->requested = 1;
+	} else if (!val && gw2sg->requested) {
+		gw2sg->backoff = HZ;
+		gw2sg->requested = 0;
+	} else
+		goto unlock;
+
+	if (!gw2sg->suspended)
+		schedule_delayed_work(&gw2sg->work, 0);
+unlock:
+	spin_unlock_irqrestore(&gw2sg->lock, flags);
+}
+
+static int gpio_w2sg_get_value(struct gpio_chip *gc, unsigned offset)
+{
+	struct gpio_w2sg *gw2sg = container_of(gc, struct gpio_w2sg, gpio);
+
+	return gw2sg->is_on;
+}
+
+static void gpio_w2sg_set_value(struct gpio_chip *gc, unsigned offset, int val)
+{
+	struct gpio_w2sg *gw2sg = container_of(gc, struct gpio_w2sg, gpio);
+
+	gpio_w2sg_set_power(gw2sg, val);
+}
+
+static int gpio_w2sg_direction_output(struct gpio_chip *gc,
+					unsigned offset, int val)
+{
+	gpio_w2sg_set_value(gc, offset, val);
+
+	return 0;
+}
+
+static int gpio_w2sg_rfkill_set_block(void *data, bool blocked)
+{
+	struct gpio_w2sg *gw2sg = data;
+
+	pr_debug("%s: blocked: %d\n", __func__, blocked);
+
+	gw2sg->lna_blocked = blocked;
+
+	return gpio_w2sg_set_lna_power(gw2sg);
+}
+
+static struct rfkill_ops gpio_w2sg0004_rfkill_ops = {
+	.set_block = gpio_w2sg_rfkill_set_block,
+};
+
+static int gpio_w2sg_probe(struct platform_device *pdev)
+{
+	struct gpio_w2sg_data *pdata = dev_get_platdata(&pdev->dev);
+	struct gpio_w2sg *gw2sg;
+	struct rfkill *rf_kill;
+	int err;
+
+	pr_debug("gpio_w2sg_probe()\n");
+
+#ifdef CONFIG_OF
+	if (pdev->dev.of_node) {
+		struct device *dev = &pdev->dev;
+		enum of_gpio_flags flags;
+
+		pdata = devm_kzalloc(dev, sizeof(*pdata), GFP_KERNEL);
+		if (!pdata)
+			return -ENOMEM;
+
+		pdata->on_off_gpio = of_get_named_gpio_flags(dev->of_node,
+						"on-off-gpio", 0, &flags);
+
+		pdata->rx_irq = irq_of_parse_and_map(dev->of_node, 0);
+		if (!pdata->rx_irq) {
+			dev_err(dev, "no IRQ found\n");
+			return -ENODEV;
+		}
+
+		if (pdata->on_off_gpio == -EPROBE_DEFER)
+			return -EPROBE_DEFER;
+
+		pdata->lna_regulator = devm_regulator_get_optional(dev, "lna");
+
+		pr_debug("lna_regulator = %p\n", pdata->lna_regulator);
+
+		if (IS_ERR(pdata->lna_regulator))
+			return PTR_ERR(pdata->lna_regulator);
+
+		pdata->gpio_base = -1;
+		pdev->dev.platform_data = pdata;
+	}
+#endif
+
+	gw2sg = devm_kzalloc(&pdev->dev, sizeof(*gw2sg), GFP_KERNEL);
+	if (gw2sg == NULL)
+		return -ENOMEM;
+
+	gw2sg->lna_regulator = pdata->lna_regulator;
+	gw2sg->lna_blocked = true;
+	gw2sg->lna_is_off = true;
+
+	gw2sg->on_off_gpio = pdata->on_off_gpio;
+
+	gw2sg->is_on = false;
+	gw2sg->requested = true;
+	gw2sg->state = W2SG_IDLE;
+	gw2sg->last_toggle = jiffies;
+	gw2sg->backoff = HZ;
+
+	/* label of controlling GPIO */
+	gw2sg->gpio_name[0] = "gpio-w2sg0004-enable";
+	gw2sg->gpio.label = "w2sg0004";
+	gw2sg->gpio.names = gw2sg->gpio_name;
+	gw2sg->gpio.ngpio = 1;
+	gw2sg->gpio.base = pdata->gpio_base;
+	gw2sg->gpio.owner = THIS_MODULE;
+	gw2sg->gpio.direction_output = gpio_w2sg_direction_output;
+	gw2sg->gpio.get = gpio_w2sg_get_value;
+	gw2sg->gpio.set = gpio_w2sg_set_value;
+	gw2sg->gpio.can_sleep = 0;
+	gw2sg->rx_irq = pdata->rx_irq;
+
+#ifdef CONFIG_OF_GPIO
+	gw2sg->gpio.of_node = pdev->dev.of_node;
+#endif
+
+#ifdef CONFIG_OF
+	if (pdev->dev.of_node) {
+		gw2sg->p = devm_pinctrl_get(&pdev->dev);
+		if (IS_ERR(gw2sg->p)) {
+			err = PTR_ERR(gw2sg->p);
+			dev_err(&pdev->dev, "Cannot get pinctrl: %d\n", err);
+			goto out;
+		}
+
+		gw2sg->default_state = pinctrl_lookup_state(gw2sg->p,
+							PINCTRL_STATE_DEFAULT);
+		if (IS_ERR(gw2sg->default_state)) {
+			err = PTR_ERR(gw2sg->default_state);
+			dev_err(&pdev->dev, "Cannot look up pinctrl state %s: %d\n",
+				PINCTRL_STATE_DEFAULT, err);
+			goto out;
+		}
+
+		gw2sg->monitor_state = pinctrl_lookup_state(gw2sg->p,
+								"monitor");
+		if (IS_ERR(gw2sg->monitor_state)) {
+			err = PTR_ERR(gw2sg->monitor_state);
+			dev_err(&pdev->dev,
+				"Cannot look up pinctrl state %s: %d\n",
+				"monitor", err);
+			goto out;
+		}
+		/* choose UART state as default */
+		err = pinctrl_select_state(gw2sg->p, gw2sg->default_state);
+		if (err < 0)
+			goto out;
+	}
+#endif
+
+	INIT_DELAYED_WORK(&gw2sg->work, toggle_work);
+	spin_lock_init(&gw2sg->lock);
+
+	err = devm_gpio_request(&pdev->dev, gw2sg->on_off_gpio,
+				"w2sg0004-on-off");
+	if (err < 0)
+		goto out;
+
+	gpio_direction_output(gw2sg->on_off_gpio, false);
+
+	err = devm_request_threaded_irq(&pdev->dev, gw2sg->rx_irq, NULL,
+				   gpio_w2sg_isr,
+				   IRQF_TRIGGER_FALLING | IRQF_ONESHOT,
+				   "w2sg0004-rx",
+				   gw2sg);
+	if (err < 0) {
+		dev_err(&pdev->dev, "Unable to claim irq %d; error %d\n",
+			gw2sg->rx_irq, err);
+		goto out;
+	}
+
+	disable_irq(gw2sg->rx_irq);
+
+	err = gpiochip_add(&gw2sg->gpio);
+	if (err)
+		goto out;
+
+	rf_kill = rfkill_alloc("GPS", &pdev->dev, RFKILL_TYPE_GPS,
+				&gpio_w2sg0004_rfkill_ops, gw2sg);
+	if (rf_kill == NULL) {
+		err = -ENOMEM;
+		goto err_rfkill;
+	}
+
+	err = rfkill_register(rf_kill);
+	if (err) {
+		dev_err(&pdev->dev, "Cannot register rfkill device\n");
+		goto err_rfkill;
+	}
+
+	gw2sg->rf_kill = rf_kill;
+
+	platform_set_drvdata(pdev, gw2sg);
+
+	pr_debug("w2sg0004 probed\n");
+
+	return 0;
+
+err_rfkill:
+	rfkill_destroy(rf_kill);
+	gpiochip_remove(&gw2sg->gpio);
+out:
+	return err;
+}
+
+static int gpio_w2sg_remove(struct platform_device *pdev)
+{
+	struct gpio_w2sg *gw2sg = platform_get_drvdata(pdev);
+
+	cancel_delayed_work_sync(&gw2sg->work);
+	gpiochip_remove(&gw2sg->gpio);
+
+	return 0;
+}
+
+static int gpio_w2sg_suspend(struct device *dev)
+{
+	/* Ignore the GPIO and just turn device off.
+	 * we cannot really wait for a separate thread to
+	 * do things, so we disable that and do it all
+	 * here
+	 */
+	struct gpio_w2sg *gw2sg = dev_get_drvdata(dev);
+
+	spin_lock_irq(&gw2sg->lock);
+	gw2sg->suspended = 1;
+	spin_unlock_irq(&gw2sg->lock);
+
+	cancel_delayed_work_sync(&gw2sg->work);
+
+	gpio_w2sg_set_lna_power(gw2sg);	/* shut down if needed */
+
+	if (gw2sg->state == W2SG_PULSE) {
+		usleep_range(10000, 15000);
+		gpio_set_value_cansleep(gw2sg->on_off_gpio, 1);
+		gw2sg->last_toggle = jiffies;
+		gw2sg->is_on = !gw2sg->is_on;
+		gw2sg->state = W2SG_NOPULSE;
+	}
+
+	if (gw2sg->state == W2SG_NOPULSE) {
+		usleep_range(10000, 15000);
+		gw2sg->state = W2SG_IDLE;
+	}
+
+	if (gw2sg->is_on) {
+		pr_info("GPS off for suspend %d %d %d\n",
+			gw2sg->requested, gw2sg->is_on, gw2sg->lna_is_off);
+
+		gpio_set_value_cansleep(gw2sg->on_off_gpio, 0);
+		usleep_range(10000, 15000);
+		gpio_set_value_cansleep(gw2sg->on_off_gpio, 1);
+		gw2sg->is_on = 0;
+	}
+
+	return 0;
+}
+
+static int gpio_w2sg_resume(struct device *dev)
+{
+	struct gpio_w2sg *gw2sg = dev_get_drvdata(dev);
+
+	spin_lock_irq(&gw2sg->lock);
+	gw2sg->suspended = 0;
+	spin_unlock_irq(&gw2sg->lock);
+
+	pr_info("GPS resuming %d %d %d\n",
+		gw2sg->requested, gw2sg->is_on, gw2sg->lna_is_off);
+
+	schedule_delayed_work(&gw2sg->work, 0);	/* enables LNA if needed */
+
+	return 0;
+}
+
+#if defined(CONFIG_OF)
+static const struct of_device_id w2sg0004_of_match[] = {
+	{ .compatible = "wi2wi,w2sg0004" },
+	{},
+};
+MODULE_DEVICE_TABLE(of, w2sg0004_of_match);
+#endif
+
+SIMPLE_DEV_PM_OPS(w2sg_pm_ops, gpio_w2sg_suspend, gpio_w2sg_resume);
+
+static struct platform_driver gpio_w2sg_driver = {
+	.probe		= gpio_w2sg_probe,
+	.remove		= gpio_w2sg_remove,
+	.driver = {
+		.name	= "w2sg0004",
+		.owner	= THIS_MODULE,
+		.pm	= &w2sg_pm_ops,
+		.of_match_table = of_match_ptr(w2sg0004_of_match)
+	},
+};
+
+module_platform_driver(gpio_w2sg_driver);
+
+MODULE_ALIAS("w2sg0004");
+
+MODULE_AUTHOR("NeilBrown <neilb@suse.de>");
+MODULE_DESCRIPTION("w2sg0004 GPS virtual GPIO driver");
+MODULE_LICENSE("GPL v2");
diff --git a/include/linux/w2sg0004.h b/include/linux/w2sg0004.h
new file mode 100644
index 0000000..f20e90c
--- /dev/null
+++ b/include/linux/w2sg0004.h
@@ -0,0 +1,23 @@
+/*
+ * Virtual gpio to allow ON/OFF control of w2sg0004 GPS receiver.
+ *
+ * Copyright (C) 2011 Neil Brown <neil@brown.name>
+ *
+ */
+
+
+#ifndef __LINUX_W2SG0004_H
+#define __LINUX_W2SG0004_H
+
+#include <linux/regulator/consumer.h>
+
+struct gpio_w2sg_data {
+	int	gpio_base;	/* (not used by DT) - defines the gpio.base */
+	struct regulator *lna_regulator;	/* enable LNA power */
+	int	on_off_gpio;	/* connected to the on-off input of the GPS module */
+	int	rx_irq;		/* the rx irq - we track to check for module activity */
+	unsigned short	on_state;  /* Mux state when GPS is on */
+	unsigned short	off_state; /* Mux state when GPS is off */
+};
+
+#endif /* __LINUX_W2SG0004_H */
-- 
1.9.1

