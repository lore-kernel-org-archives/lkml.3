Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758877Ab3BTIgN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 03:36:13 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:56631 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758761Ab3BTIgH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 03:36:07 -0500
From: "Kim, Milo" <Milo.Kim@ti.com>
To: Bryan Wu <cooloney@gmail.com>
CC: "linux-leds@vger.kernel.org" <linux-leds@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Jeong, Daniel" <Daniel.Jeong@ti.com>
Subject: [PATCH 1/3] leds: move LED trigger drivers into new subdirectory
Thread-Topic: [PATCH 1/3] leds: move LED trigger drivers into new
 subdirectory
Thread-Index: Ac4PRU+FwguO6PS/RFuCVzNMyCwQbA==
Date: Wed, 20 Feb 2013 08:36:01 +0000
Message-ID: <A874F61F95741C4A9BA573A70FE3998F7927366E@DQHE02.ent.ti.com>
Accept-Language: ko-KR, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.16.34.32]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For better driver management, new subdirectory, 'trigger' is created.
All LED trigger drivers are moved into this directory.

Internal header, 'leds.h' is included in each LED trigger drivers.
Fix the location of header file, "leds.h" -> "../leds.h" in driver files.
One exception is here, 'ledtrig-timer.c'.
There is no need to include 'leds.h'. so '#include "leds.h"' line was removed.

Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
---
 drivers/leds/Kconfig                      |  101 +-----------
 drivers/leds/Makefile                     |   10 +-
 drivers/leds/ledtrig-backlight.c          |  166 -------------------
 drivers/leds/ledtrig-cpu.c                |  142 ----------------
 drivers/leds/ledtrig-default-on.c         |   45 -----
 drivers/leds/ledtrig-gpio.c               |  253 -----------------------------
 drivers/leds/ledtrig-heartbeat.c          |  161 ------------------
 drivers/leds/ledtrig-ide-disk.c           |   47 ------
 drivers/leds/ledtrig-oneshot.c            |  204 -----------------------
 drivers/leds/ledtrig-timer.c              |  131 ---------------
 drivers/leds/ledtrig-transient.c          |  237 ---------------------------
 drivers/leds/trigger/Kconfig              |  103 ++++++++++++
 drivers/leds/trigger/Makefile             |    9 +
 drivers/leds/trigger/ledtrig-backlight.c  |  166 +++++++++++++++++++
 drivers/leds/trigger/ledtrig-cpu.c        |  142 ++++++++++++++++
 drivers/leds/trigger/ledtrig-default-on.c |   45 +++++
 drivers/leds/trigger/ledtrig-gpio.c       |  253 +++++++++++++++++++++++++++++
 drivers/leds/trigger/ledtrig-heartbeat.c  |  161 ++++++++++++++++++
 drivers/leds/trigger/ledtrig-ide-disk.c   |   47 ++++++
 drivers/leds/trigger/ledtrig-oneshot.c    |  204 +++++++++++++++++++++++
 drivers/leds/trigger/ledtrig-timer.c      |  130 +++++++++++++++
 drivers/leds/trigger/ledtrig-transient.c  |  237 +++++++++++++++++++++++++++
 22 files changed, 1499 insertions(+), 1495 deletions(-)
 delete mode 100644 drivers/leds/ledtrig-backlight.c
 delete mode 100644 drivers/leds/ledtrig-cpu.c
 delete mode 100644 drivers/leds/ledtrig-default-on.c
 delete mode 100644 drivers/leds/ledtrig-gpio.c
 delete mode 100644 drivers/leds/ledtrig-heartbeat.c
 delete mode 100644 drivers/leds/ledtrig-ide-disk.c
 delete mode 100644 drivers/leds/ledtrig-oneshot.c
 delete mode 100644 drivers/leds/ledtrig-timer.c
 delete mode 100644 drivers/leds/ledtrig-transient.c
 create mode 100644 drivers/leds/trigger/Kconfig
 create mode 100644 drivers/leds/trigger/Makefile
 create mode 100644 drivers/leds/trigger/ledtrig-backlight.c
 create mode 100644 drivers/leds/trigger/ledtrig-cpu.c
 create mode 100644 drivers/leds/trigger/ledtrig-default-on.c
 create mode 100644 drivers/leds/trigger/ledtrig-gpio.c
 create mode 100644 drivers/leds/trigger/ledtrig-heartbeat.c
 create mode 100644 drivers/leds/trigger/ledtrig-ide-disk.c
 create mode 100644 drivers/leds/trigger/ledtrig-oneshot.c
 create mode 100644 drivers/leds/trigger/ledtrig-timer.c
 create mode 100644 drivers/leds/trigger/ledtrig-transient.c

diff --git a/drivers/leds/Kconfig b/drivers/leds/Kconfig
index 78b354f..0b0598d 100644
--- a/drivers/leds/Kconfig
+++ b/drivers/leds/Kconfig
@@ -469,106 +469,7 @@ config LEDS_BLINKM
 	  This option enables support for the BlinkM RGB LED connected
 	  through I2C. Say Y to enable support for the BlinkM LED.
 
-config LEDS_TRIGGERS
-	bool "LED Trigger support"
-	depends on LEDS_CLASS
-	help
-	  This option enables trigger support for the leds class.
-	  These triggers allow kernel events to drive the LEDs and can
-	  be configured via sysfs. If unsure, say Y.
-
 comment "LED Triggers"
-
-config LEDS_TRIGGER_TIMER
-	tristate "LED Timer Trigger"
-	depends on LEDS_TRIGGERS
-	help
-	  This allows LEDs to be controlled by a programmable timer
-	  via sysfs. Some LED hardware can be programmed to start
-	  blinking the LED without any further software interaction.
-	  For more details read Documentation/leds/leds-class.txt.
-
-	  If unsure, say Y.
-
-config LEDS_TRIGGER_ONESHOT
-	tristate "LED One-shot Trigger"
-	depends on LEDS_TRIGGERS
-	help
-	  This allows LEDs to blink in one-shot pulses with parameters
-	  controlled via sysfs.  It's useful to notify the user on
-	  sporadic events, when there are no clear begin and end trap points,
-	  or on dense events, where this blinks the LED at constant rate if
-	  rearmed continuously.
-
-	  It also shows how to use the led_blink_set_oneshot() function.
-
-	  If unsure, say Y.
-
-config LEDS_TRIGGER_IDE_DISK
-	bool "LED IDE Disk Trigger"
-	depends on IDE_GD_ATA
-	depends on LEDS_TRIGGERS
-	help
-	  This allows LEDs to be controlled by IDE disk activity.
-	  If unsure, say Y.
-
-config LEDS_TRIGGER_HEARTBEAT
-	tristate "LED Heartbeat Trigger"
-	depends on LEDS_TRIGGERS
-	help
-	  This allows LEDs to be controlled by a CPU load average.
-	  The flash frequency is a hyperbolic function of the 1-minute
-	  load average.
-	  If unsure, say Y.
-
-config LEDS_TRIGGER_BACKLIGHT
-	tristate "LED backlight Trigger"
-	depends on LEDS_TRIGGERS
-	help
-	  This allows LEDs to be controlled as a backlight device: they
-	  turn off and on when the display is blanked and unblanked.
-
-	  If unsure, say N.
-
-config LEDS_TRIGGER_CPU
-	bool "LED CPU Trigger"
-	depends on LEDS_TRIGGERS
-	help
-	  This allows LEDs to be controlled by active CPUs. This shows
-	  the active CPUs across an array of LEDs so you can see which
-	  CPUs are active on the system at any given moment.
-
-	  If unsure, say N.
-
-config LEDS_TRIGGER_GPIO
-	tristate "LED GPIO Trigger"
-	depends on LEDS_TRIGGERS
-	depends on GPIOLIB
-	help
-	  This allows LEDs to be controlled by gpio events. It's good
-	  when using gpios as switches and triggering the needed LEDs
-	  from there. One use case is n810's keypad LEDs that could
-	  be triggered by this trigger when user slides up to show
-	  keypad.
-
-	  If unsure, say N.
-
-config LEDS_TRIGGER_DEFAULT_ON
-	tristate "LED Default ON Trigger"
-	depends on LEDS_TRIGGERS
-	help
-	  This allows LEDs to be initialised in the ON state.
-	  If unsure, say Y.
-
-comment "iptables trigger is under Netfilter config (LED target)"
-	depends on LEDS_TRIGGERS
-
-config LEDS_TRIGGER_TRANSIENT
-	tristate "LED Transient Trigger"
-	depends on LEDS_TRIGGERS
-	help
-	  This allows one time activation of a transient state on
-	  GPIO/PWM based hardware.
-	  If unsure, say Y.
+source "drivers/leds/trigger/Kconfig"
 
 endif # NEW_LEDS
diff --git a/drivers/leds/Makefile b/drivers/leds/Makefile
index 215e7e3..f77936d 100644
--- a/drivers/leds/Makefile
+++ b/drivers/leds/Makefile
@@ -57,12 +57,4 @@ obj-$(CONFIG_LEDS_BLINKM)		+= leds-blinkm.o
 obj-$(CONFIG_LEDS_DAC124S085)		+= leds-dac124s085.o
 
 # LED Triggers
-obj-$(CONFIG_LEDS_TRIGGER_TIMER)	+= ledtrig-timer.o
-obj-$(CONFIG_LEDS_TRIGGER_ONESHOT)	+= ledtrig-oneshot.o
-obj-$(CONFIG_LEDS_TRIGGER_IDE_DISK)	+= ledtrig-ide-disk.o
-obj-$(CONFIG_LEDS_TRIGGER_HEARTBEAT)	+= ledtrig-heartbeat.o
-obj-$(CONFIG_LEDS_TRIGGER_BACKLIGHT)	+= ledtrig-backlight.o
-obj-$(CONFIG_LEDS_TRIGGER_GPIO)		+= ledtrig-gpio.o
-obj-$(CONFIG_LEDS_TRIGGER_CPU)		+= ledtrig-cpu.o
-obj-$(CONFIG_LEDS_TRIGGER_DEFAULT_ON)	+= ledtrig-default-on.o
-obj-$(CONFIG_LEDS_TRIGGER_TRANSIENT)	+= ledtrig-transient.o
+obj-$(CONFIG_LEDS_TRIGGERS)		+= trigger/
diff --git a/drivers/leds/ledtrig-backlight.c b/drivers/leds/ledtrig-backlight.c
deleted file mode 100644
index 027a2b1..0000000
--- a/drivers/leds/ledtrig-backlight.c
+++ /dev/null
@@ -1,166 +0,0 @@
-/*
- * Backlight emulation LED trigger
- *
- * Copyright 2008 (C) Rodolfo Giometti <giometti@linux.it>
- * Copyright 2008 (C) Eurotech S.p.A. <info@eurotech.it>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- *
- */
-
-#include <linux/module.h>
-#include <linux/kernel.h>
-#include <linux/slab.h>
-#include <linux/init.h>
-#include <linux/fb.h>
-#include <linux/leds.h>
-#include "leds.h"
-
-#define BLANK		1
-#define UNBLANK		0
-
-struct bl_trig_notifier {
-	struct led_classdev *led;
-	int brightness;
-	int old_status;
-	struct notifier_block notifier;
-	unsigned invert;
-};
-
-static int fb_notifier_callback(struct notifier_block *p,
-				unsigned long event, void *data)
-{
-	struct bl_trig_notifier *n = container_of(p,
-					struct bl_trig_notifier, notifier);
-	struct led_classdev *led = n->led;
-	struct fb_event *fb_event = data;
-	int *blank = fb_event->data;
-	int new_status = *blank ? BLANK : UNBLANK;
-
-	switch (event) {
-	case FB_EVENT_BLANK:
-		if (new_status == n->old_status)
-			break;
-
-		if ((n->old_status == UNBLANK) ^ n->invert) {
-			n->brightness = led->brightness;
-			__led_set_brightness(led, LED_OFF);
-		} else {
-			__led_set_brightness(led, n->brightness);
-		}
-
-		n->old_status = new_status;
-
-		break;
-	}
-
-	return 0;
-}
-
-static ssize_t bl_trig_invert_show(struct device *dev,
-		struct device_attribute *attr, char *buf)
-{
-	struct led_classdev *led = dev_get_drvdata(dev);
-	struct bl_trig_notifier *n = led->trigger_data;
-
-	return sprintf(buf, "%u\n", n->invert);
-}
-
-static ssize_t bl_trig_invert_store(struct device *dev,
-		struct device_attribute *attr, const char *buf, size_t num)
-{
-	struct led_classdev *led = dev_get_drvdata(dev);
-	struct bl_trig_notifier *n = led->trigger_data;
-	unsigned long invert;
-	int ret;
-
-	ret = kstrtoul(buf, 10, &invert);
-	if (ret < 0)
-		return ret;
-
-	if (invert > 1)
-		return -EINVAL;
-
-	n->invert = invert;
-
-	/* After inverting, we need to update the LED. */
-	if ((n->old_status == BLANK) ^ n->invert)
-		__led_set_brightness(led, LED_OFF);
-	else
-		__led_set_brightness(led, n->brightness);
-
-	return num;
-}
-static DEVICE_ATTR(inverted, 0644, bl_trig_invert_show, bl_trig_invert_store);
-
-static void bl_trig_activate(struct led_classdev *led)
-{
-	int ret;
-
-	struct bl_trig_notifier *n;
-
-	n = kzalloc(sizeof(struct bl_trig_notifier), GFP_KERNEL);
-	led->trigger_data = n;
-	if (!n) {
-		dev_err(led->dev, "unable to allocate backlight trigger\n");
-		return;
-	}
-
-	ret = device_create_file(led->dev, &dev_attr_inverted);
-	if (ret)
-		goto err_invert;
-
-	n->led = led;
-	n->brightness = led->brightness;
-	n->old_status = UNBLANK;
-	n->notifier.notifier_call = fb_notifier_callback;
-
-	ret = fb_register_client(&n->notifier);
-	if (ret)
-		dev_err(led->dev, "unable to register backlight trigger\n");
-	led->activated = true;
-
-	return;
-
-err_invert:
-	led->trigger_data = NULL;
-	kfree(n);
-}
-
-static void bl_trig_deactivate(struct led_classdev *led)
-{
-	struct bl_trig_notifier *n =
-		(struct bl_trig_notifier *) led->trigger_data;
-
-	if (led->activated) {
-		device_remove_file(led->dev, &dev_attr_inverted);
-		fb_unregister_client(&n->notifier);
-		kfree(n);
-		led->activated = false;
-	}
-}
-
-static struct led_trigger bl_led_trigger = {
-	.name		= "backlight",
-	.activate	= bl_trig_activate,
-	.deactivate	= bl_trig_deactivate
-};
-
-static int __init bl_trig_init(void)
-{
-	return led_trigger_register(&bl_led_trigger);
-}
-
-static void __exit bl_trig_exit(void)
-{
-	led_trigger_unregister(&bl_led_trigger);
-}
-
-module_init(bl_trig_init);
-module_exit(bl_trig_exit);
-
-MODULE_AUTHOR("Rodolfo Giometti <giometti@linux.it>");
-MODULE_DESCRIPTION("Backlight emulation LED trigger");
-MODULE_LICENSE("GPL v2");
diff --git a/drivers/leds/ledtrig-cpu.c b/drivers/leds/ledtrig-cpu.c
deleted file mode 100644
index 4239b39..0000000
--- a/drivers/leds/ledtrig-cpu.c
+++ /dev/null
@@ -1,142 +0,0 @@
-/*
- * ledtrig-cpu.c - LED trigger based on CPU activity
- *
- * This LED trigger will be registered for each possible CPU and named as
- * cpu0, cpu1, cpu2, cpu3, etc.
- *
- * It can be bound to any LED just like other triggers using either a
- * board file or via sysfs interface.
- *
- * An API named ledtrig_cpu is exported for any user, who want to add CPU
- * activity indication in their code
- *
- * Copyright 2011 Linus Walleij <linus.walleij@linaro.org>
- * Copyright 2011 - 2012 Bryan Wu <bryan.wu@canonical.com>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- *
- */
-
-#include <linux/module.h>
-#include <linux/kernel.h>
-#include <linux/init.h>
-#include <linux/slab.h>
-#include <linux/percpu.h>
-#include <linux/syscore_ops.h>
-#include <linux/rwsem.h>
-#include "leds.h"
-
-#define MAX_NAME_LEN	8
-
-struct led_trigger_cpu {
-	char name[MAX_NAME_LEN];
-	struct led_trigger *_trig;
-};
-
-static DEFINE_PER_CPU(struct led_trigger_cpu, cpu_trig);
-
-/**
- * ledtrig_cpu - emit a CPU event as a trigger
- * @evt: CPU event to be emitted
- *
- * Emit a CPU event on a CPU core, which will trigger a
- * binded LED to turn on or turn off.
- */
-void ledtrig_cpu(enum cpu_led_event ledevt)
-{
-	struct led_trigger_cpu *trig = &__get_cpu_var(cpu_trig);
-
-	/* Locate the correct CPU LED */
-	switch (ledevt) {
-	case CPU_LED_IDLE_END:
-	case CPU_LED_START:
-		/* Will turn the LED on, max brightness */
-		led_trigger_event(trig->_trig, LED_FULL);
-		break;
-
-	case CPU_LED_IDLE_START:
-	case CPU_LED_STOP:
-	case CPU_LED_HALTED:
-		/* Will turn the LED off */
-		led_trigger_event(trig->_trig, LED_OFF);
-		break;
-
-	default:
-		/* Will leave the LED as it is */
-		break;
-	}
-}
-EXPORT_SYMBOL(ledtrig_cpu);
-
-static int ledtrig_cpu_syscore_suspend(void)
-{
-	ledtrig_cpu(CPU_LED_STOP);
-	return 0;
-}
-
-static void ledtrig_cpu_syscore_resume(void)
-{
-	ledtrig_cpu(CPU_LED_START);
-}
-
-static void ledtrig_cpu_syscore_shutdown(void)
-{
-	ledtrig_cpu(CPU_LED_HALTED);
-}
-
-static struct syscore_ops ledtrig_cpu_syscore_ops = {
-	.shutdown	= ledtrig_cpu_syscore_shutdown,
-	.suspend	= ledtrig_cpu_syscore_suspend,
-	.resume		= ledtrig_cpu_syscore_resume,
-};
-
-static int __init ledtrig_cpu_init(void)
-{
-	int cpu;
-
-	/* Supports up to 9999 cpu cores */
-	BUILD_BUG_ON(CONFIG_NR_CPUS > 9999);
-
-	/*
-	 * Registering CPU led trigger for each CPU core here
-	 * ignores CPU hotplug, but after this CPU hotplug works
-	 * fine with this trigger.
-	 */
-	for_each_possible_cpu(cpu) {
-		struct led_trigger_cpu *trig = &per_cpu(cpu_trig, cpu);
-
-		snprintf(trig->name, MAX_NAME_LEN, "cpu%d", cpu);
-
-		led_trigger_register_simple(trig->name, &trig->_trig);
-	}
-
-	register_syscore_ops(&ledtrig_cpu_syscore_ops);
-
-	pr_info("ledtrig-cpu: registered to indicate activity on CPUs\n");
-
-	return 0;
-}
-module_init(ledtrig_cpu_init);
-
-static void __exit ledtrig_cpu_exit(void)
-{
-	int cpu;
-
-	for_each_possible_cpu(cpu) {
-		struct led_trigger_cpu *trig = &per_cpu(cpu_trig, cpu);
-
-		led_trigger_unregister_simple(trig->_trig);
-		trig->_trig = NULL;
-		memset(trig->name, 0, MAX_NAME_LEN);
-	}
-
-	unregister_syscore_ops(&ledtrig_cpu_syscore_ops);
-}
-module_exit(ledtrig_cpu_exit);
-
-MODULE_AUTHOR("Linus Walleij <linus.walleij@linaro.org>");
-MODULE_AUTHOR("Bryan Wu <bryan.wu@canonical.com>");
-MODULE_DESCRIPTION("CPU LED trigger");
-MODULE_LICENSE("GPL");
diff --git a/drivers/leds/ledtrig-default-on.c b/drivers/leds/ledtrig-default-on.c
deleted file mode 100644
index eac1f1b..0000000
--- a/drivers/leds/ledtrig-default-on.c
+++ /dev/null
@@ -1,45 +0,0 @@
-/*
- * LED Kernel Default ON Trigger
- *
- * Copyright 2008 Nick Forbes <nick.forbes@incepta.com>
- *
- * Based on Richard Purdie's ledtrig-timer.c.
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- *
- */
-
-#include <linux/module.h>
-#include <linux/kernel.h>
-#include <linux/init.h>
-#include <linux/leds.h>
-#include "leds.h"
-
-static void defon_trig_activate(struct led_classdev *led_cdev)
-{
-	__led_set_brightness(led_cdev, led_cdev->max_brightness);
-}
-
-static struct led_trigger defon_led_trigger = {
-	.name     = "default-on",
-	.activate = defon_trig_activate,
-};
-
-static int __init defon_trig_init(void)
-{
-	return led_trigger_register(&defon_led_trigger);
-}
-
-static void __exit defon_trig_exit(void)
-{
-	led_trigger_unregister(&defon_led_trigger);
-}
-
-module_init(defon_trig_init);
-module_exit(defon_trig_exit);
-
-MODULE_AUTHOR("Nick Forbes <nick.forbes@incepta.com>");
-MODULE_DESCRIPTION("Default-ON LED trigger");
-MODULE_LICENSE("GPL");
diff --git a/drivers/leds/ledtrig-gpio.c b/drivers/leds/ledtrig-gpio.c
deleted file mode 100644
index 72e3ebf..0000000
--- a/drivers/leds/ledtrig-gpio.c
+++ /dev/null
@@ -1,253 +0,0 @@
-/*
- * ledtrig-gio.c - LED Trigger Based on GPIO events
- *
- * Copyright 2009 Felipe Balbi <me@felipebalbi.com>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- *
- */
-
-#include <linux/module.h>
-#include <linux/kernel.h>
-#include <linux/init.h>
-#include <linux/gpio.h>
-#include <linux/interrupt.h>
-#include <linux/workqueue.h>
-#include <linux/leds.h>
-#include <linux/slab.h>
-#include "leds.h"
-
-struct gpio_trig_data {
-	struct led_classdev *led;
-	struct work_struct work;
-
-	unsigned desired_brightness;	/* desired brightness when led is on */
-	unsigned inverted;		/* true when gpio is inverted */
-	unsigned gpio;			/* gpio that triggers the leds */
-};
-
-static irqreturn_t gpio_trig_irq(int irq, void *_led)
-{
-	struct led_classdev *led = _led;
-	struct gpio_trig_data *gpio_data = led->trigger_data;
-
-	/* just schedule_work since gpio_get_value can sleep */
-	schedule_work(&gpio_data->work);
-
-	return IRQ_HANDLED;
-};
-
-static void gpio_trig_work(struct work_struct *work)
-{
-	struct gpio_trig_data *gpio_data = container_of(work,
-			struct gpio_trig_data, work);
-	int tmp;
-
-	if (!gpio_data->gpio)
-		return;
-
-	tmp = gpio_get_value(gpio_data->gpio);
-	if (gpio_data->inverted)
-		tmp = !tmp;
-
-	if (tmp) {
-		if (gpio_data->desired_brightness)
-			__led_set_brightness(gpio_data->led,
-					   gpio_data->desired_brightness);
-		else
-			__led_set_brightness(gpio_data->led, LED_FULL);
-	} else {
-		__led_set_brightness(gpio_data->led, LED_OFF);
-	}
-}
-
-static ssize_t gpio_trig_brightness_show(struct device *dev,
-		struct device_attribute *attr, char *buf)
-{
-	struct led_classdev *led = dev_get_drvdata(dev);
-	struct gpio_trig_data *gpio_data = led->trigger_data;
-
-	return sprintf(buf, "%u\n", gpio_data->desired_brightness);
-}
-
-static ssize_t gpio_trig_brightness_store(struct device *dev,
-		struct device_attribute *attr, const char *buf, size_t n)
-{
-	struct led_classdev *led = dev_get_drvdata(dev);
-	struct gpio_trig_data *gpio_data = led->trigger_data;
-	unsigned desired_brightness;
-	int ret;
-
-	ret = sscanf(buf, "%u", &desired_brightness);
-	if (ret < 1 || desired_brightness > 255) {
-		dev_err(dev, "invalid value\n");
-		return -EINVAL;
-	}
-
-	gpio_data->desired_brightness = desired_brightness;
-
-	return n;
-}
-static DEVICE_ATTR(desired_brightness, 0644, gpio_trig_brightness_show,
-		gpio_trig_brightness_store);
-
-static ssize_t gpio_trig_inverted_show(struct device *dev,
-		struct device_attribute *attr, char *buf)
-{
-	struct led_classdev *led = dev_get_drvdata(dev);
-	struct gpio_trig_data *gpio_data = led->trigger_data;
-
-	return sprintf(buf, "%u\n", gpio_data->inverted);
-}
-
-static ssize_t gpio_trig_inverted_store(struct device *dev,
-		struct device_attribute *attr, const char *buf, size_t n)
-{
-	struct led_classdev *led = dev_get_drvdata(dev);
-	struct gpio_trig_data *gpio_data = led->trigger_data;
-	unsigned long inverted;
-	int ret;
-
-	ret = kstrtoul(buf, 10, &inverted);
-	if (ret < 0)
-		return ret;
-
-	if (inverted > 1)
-		return -EINVAL;
-
-	gpio_data->inverted = inverted;
-
-	/* After inverting, we need to update the LED. */
-	schedule_work(&gpio_data->work);
-
-	return n;
-}
-static DEVICE_ATTR(inverted, 0644, gpio_trig_inverted_show,
-		gpio_trig_inverted_store);
-
-static ssize_t gpio_trig_gpio_show(struct device *dev,
-		struct device_attribute *attr, char *buf)
-{
-	struct led_classdev *led = dev_get_drvdata(dev);
-	struct gpio_trig_data *gpio_data = led->trigger_data;
-
-	return sprintf(buf, "%u\n", gpio_data->gpio);
-}
-
-static ssize_t gpio_trig_gpio_store(struct device *dev,
-		struct device_attribute *attr, const char *buf, size_t n)
-{
-	struct led_classdev *led = dev_get_drvdata(dev);
-	struct gpio_trig_data *gpio_data = led->trigger_data;
-	unsigned gpio;
-	int ret;
-
-	ret = sscanf(buf, "%u", &gpio);
-	if (ret < 1) {
-		dev_err(dev, "couldn't read gpio number\n");
-		flush_work(&gpio_data->work);
-		return -EINVAL;
-	}
-
-	if (gpio_data->gpio == gpio)
-		return n;
-
-	if (!gpio) {
-		if (gpio_data->gpio != 0)
-			free_irq(gpio_to_irq(gpio_data->gpio), led);
-		gpio_data->gpio = 0;
-		return n;
-	}
-
-	ret = request_irq(gpio_to_irq(gpio), gpio_trig_irq,
-			IRQF_SHARED | IRQF_TRIGGER_RISING
-			| IRQF_TRIGGER_FALLING, "ledtrig-gpio", led);
-	if (ret) {
-		dev_err(dev, "request_irq failed with error %d\n", ret);
-	} else {
-		if (gpio_data->gpio != 0)
-			free_irq(gpio_to_irq(gpio_data->gpio), led);
-		gpio_data->gpio = gpio;
-	}
-
-	return ret ? ret : n;
-}
-static DEVICE_ATTR(gpio, 0644, gpio_trig_gpio_show, gpio_trig_gpio_store);
-
-static void gpio_trig_activate(struct led_classdev *led)
-{
-	struct gpio_trig_data *gpio_data;
-	int ret;
-
-	gpio_data = kzalloc(sizeof(*gpio_data), GFP_KERNEL);
-	if (!gpio_data)
-		return;
-
-	ret = device_create_file(led->dev, &dev_attr_gpio);
-	if (ret)
-		goto err_gpio;
-
-	ret = device_create_file(led->dev, &dev_attr_inverted);
-	if (ret)
-		goto err_inverted;
-
-	ret = device_create_file(led->dev, &dev_attr_desired_brightness);
-	if (ret)
-		goto err_brightness;
-
-	gpio_data->led = led;
-	led->trigger_data = gpio_data;
-	INIT_WORK(&gpio_data->work, gpio_trig_work);
-	led->activated = true;
-
-	return;
-
-err_brightness:
-	device_remove_file(led->dev, &dev_attr_inverted);
-
-err_inverted:
-	device_remove_file(led->dev, &dev_attr_gpio);
-
-err_gpio:
-	kfree(gpio_data);
-}
-
-static void gpio_trig_deactivate(struct led_classdev *led)
-{
-	struct gpio_trig_data *gpio_data = led->trigger_data;
-
-	if (led->activated) {
-		device_remove_file(led->dev, &dev_attr_gpio);
-		device_remove_file(led->dev, &dev_attr_inverted);
-		device_remove_file(led->dev, &dev_attr_desired_brightness);
-		flush_work(&gpio_data->work);
-		if (gpio_data->gpio != 0)
-			free_irq(gpio_to_irq(gpio_data->gpio), led);
-		kfree(gpio_data);
-		led->activated = false;
-	}
-}
-
-static struct led_trigger gpio_led_trigger = {
-	.name		= "gpio",
-	.activate	= gpio_trig_activate,
-	.deactivate	= gpio_trig_deactivate,
-};
-
-static int __init gpio_trig_init(void)
-{
-	return led_trigger_register(&gpio_led_trigger);
-}
-module_init(gpio_trig_init);
-
-static void __exit gpio_trig_exit(void)
-{
-	led_trigger_unregister(&gpio_led_trigger);
-}
-module_exit(gpio_trig_exit);
-
-MODULE_AUTHOR("Felipe Balbi <me@felipebalbi.com>");
-MODULE_DESCRIPTION("GPIO LED trigger");
-MODULE_LICENSE("GPL");
diff --git a/drivers/leds/ledtrig-heartbeat.c b/drivers/leds/ledtrig-heartbeat.c
deleted file mode 100644
index 1edc746..0000000
--- a/drivers/leds/ledtrig-heartbeat.c
+++ /dev/null
@@ -1,161 +0,0 @@
-/*
- * LED Heartbeat Trigger
- *
- * Copyright (C) 2006 Atsushi Nemoto <anemo@mba.ocn.ne.jp>
- *
- * Based on Richard Purdie's ledtrig-timer.c and some arch's
- * CONFIG_HEARTBEAT code.
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- *
- */
-#include <linux/module.h>
-#include <linux/kernel.h>
-#include <linux/init.h>
-#include <linux/slab.h>
-#include <linux/timer.h>
-#include <linux/sched.h>
-#include <linux/leds.h>
-#include <linux/reboot.h>
-#include "leds.h"
-
-static int panic_heartbeats;
-
-struct heartbeat_trig_data {
-	unsigned int phase;
-	unsigned int period;
-	struct timer_list timer;
-};
-
-static void led_heartbeat_function(unsigned long data)
-{
-	struct led_classdev *led_cdev = (struct led_classdev *) data;
-	struct heartbeat_trig_data *heartbeat_data = led_cdev->trigger_data;
-	unsigned long brightness = LED_OFF;
-	unsigned long delay = 0;
-
-	if (unlikely(panic_heartbeats)) {
-		led_set_brightness(led_cdev, LED_OFF);
-		return;
-	}
-
-	/* acts like an actual heart beat -- ie thump-thump-pause... */
-	switch (heartbeat_data->phase) {
-	case 0:
-		/*
-		 * The hyperbolic function below modifies the
-		 * heartbeat period length in dependency of the
-		 * current (1min) load. It goes through the points
-		 * f(0)=1260, f(1)=860, f(5)=510, f(inf)->300.
-		 */
-		heartbeat_data->period = 300 +
-			(6720 << FSHIFT) / (5 * avenrun[0] + (7 << FSHIFT));
-		heartbeat_data->period =
-			msecs_to_jiffies(heartbeat_data->period);
-		delay = msecs_to_jiffies(70);
-		heartbeat_data->phase++;
-		brightness = led_cdev->max_brightness;
-		break;
-	case 1:
-		delay = heartbeat_data->period / 4 - msecs_to_jiffies(70);
-		heartbeat_data->phase++;
-		break;
-	case 2:
-		delay = msecs_to_jiffies(70);
-		heartbeat_data->phase++;
-		brightness = led_cdev->max_brightness;
-		break;
-	default:
-		delay = heartbeat_data->period - heartbeat_data->period / 4 -
-			msecs_to_jiffies(70);
-		heartbeat_data->phase = 0;
-		break;
-	}
-
-	__led_set_brightness(led_cdev, brightness);
-	mod_timer(&heartbeat_data->timer, jiffies + delay);
-}
-
-static void heartbeat_trig_activate(struct led_classdev *led_cdev)
-{
-	struct heartbeat_trig_data *heartbeat_data;
-
-	heartbeat_data = kzalloc(sizeof(*heartbeat_data), GFP_KERNEL);
-	if (!heartbeat_data)
-		return;
-
-	led_cdev->trigger_data = heartbeat_data;
-	setup_timer(&heartbeat_data->timer,
-		    led_heartbeat_function, (unsigned long) led_cdev);
-	heartbeat_data->phase = 0;
-	led_heartbeat_function(heartbeat_data->timer.data);
-	led_cdev->activated = true;
-}
-
-static void heartbeat_trig_deactivate(struct led_classdev *led_cdev)
-{
-	struct heartbeat_trig_data *heartbeat_data = led_cdev->trigger_data;
-
-	if (led_cdev->activated) {
-		del_timer_sync(&heartbeat_data->timer);
-		kfree(heartbeat_data);
-		led_cdev->activated = false;
-	}
-}
-
-static struct led_trigger heartbeat_led_trigger = {
-	.name     = "heartbeat",
-	.activate = heartbeat_trig_activate,
-	.deactivate = heartbeat_trig_deactivate,
-};
-
-static int heartbeat_reboot_notifier(struct notifier_block *nb,
-				     unsigned long code, void *unused)
-{
-	led_trigger_unregister(&heartbeat_led_trigger);
-	return NOTIFY_DONE;
-}
-
-static int heartbeat_panic_notifier(struct notifier_block *nb,
-				     unsigned long code, void *unused)
-{
-	panic_heartbeats = 1;
-	return NOTIFY_DONE;
-}
-
-static struct notifier_block heartbeat_reboot_nb = {
-	.notifier_call = heartbeat_reboot_notifier,
-};
-
-static struct notifier_block heartbeat_panic_nb = {
-	.notifier_call = heartbeat_panic_notifier,
-};
-
-static int __init heartbeat_trig_init(void)
-{
-	int rc = led_trigger_register(&heartbeat_led_trigger);
-
-	if (!rc) {
-		atomic_notifier_chain_register(&panic_notifier_list,
-					       &heartbeat_panic_nb);
-		register_reboot_notifier(&heartbeat_reboot_nb);
-	}
-	return rc;
-}
-
-static void __exit heartbeat_trig_exit(void)
-{
-	unregister_reboot_notifier(&heartbeat_reboot_nb);
-	atomic_notifier_chain_unregister(&panic_notifier_list,
-					 &heartbeat_panic_nb);
-	led_trigger_unregister(&heartbeat_led_trigger);
-}
-
-module_init(heartbeat_trig_init);
-module_exit(heartbeat_trig_exit);
-
-MODULE_AUTHOR("Atsushi Nemoto <anemo@mba.ocn.ne.jp>");
-MODULE_DESCRIPTION("Heartbeat LED trigger");
-MODULE_LICENSE("GPL");
diff --git a/drivers/leds/ledtrig-ide-disk.c b/drivers/leds/ledtrig-ide-disk.c
deleted file mode 100644
index 2cd7c0c..0000000
--- a/drivers/leds/ledtrig-ide-disk.c
+++ /dev/null
@@ -1,47 +0,0 @@
-/*
- * LED IDE-Disk Activity Trigger
- *
- * Copyright 2006 Openedhand Ltd.
- *
- * Author: Richard Purdie <rpurdie@openedhand.com>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- *
- */
-
-#include <linux/module.h>
-#include <linux/kernel.h>
-#include <linux/init.h>
-#include <linux/leds.h>
-
-#define BLINK_DELAY 30
-
-DEFINE_LED_TRIGGER(ledtrig_ide);
-static unsigned long ide_blink_delay = BLINK_DELAY;
-
-void ledtrig_ide_activity(void)
-{
-	led_trigger_blink_oneshot(ledtrig_ide,
-				  &ide_blink_delay, &ide_blink_delay, 0);
-}
-EXPORT_SYMBOL(ledtrig_ide_activity);
-
-static int __init ledtrig_ide_init(void)
-{
-	led_trigger_register_simple("ide-disk", &ledtrig_ide);
-	return 0;
-}
-
-static void __exit ledtrig_ide_exit(void)
-{
-	led_trigger_unregister_simple(ledtrig_ide);
-}
-
-module_init(ledtrig_ide_init);
-module_exit(ledtrig_ide_exit);
-
-MODULE_AUTHOR("Richard Purdie <rpurdie@openedhand.com>");
-MODULE_DESCRIPTION("LED IDE Disk Activity Trigger");
-MODULE_LICENSE("GPL");
diff --git a/drivers/leds/ledtrig-oneshot.c b/drivers/leds/ledtrig-oneshot.c
deleted file mode 100644
index 2c029aa..0000000
--- a/drivers/leds/ledtrig-oneshot.c
+++ /dev/null
@@ -1,204 +0,0 @@
-/*
- * One-shot LED Trigger
- *
- * Copyright 2012, Fabio Baltieri <fabio.baltieri@gmail.com>
- *
- * Based on ledtrig-timer.c by Richard Purdie <rpurdie@openedhand.com>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- *
- */
-
-#include <linux/module.h>
-#include <linux/kernel.h>
-#include <linux/init.h>
-#include <linux/device.h>
-#include <linux/ctype.h>
-#include <linux/slab.h>
-#include <linux/leds.h>
-#include "leds.h"
-
-#define DEFAULT_DELAY 100
-
-struct oneshot_trig_data {
-	unsigned int invert;
-};
-
-static ssize_t led_shot(struct device *dev,
-		struct device_attribute *attr, const char *buf, size_t size)
-{
-	struct led_classdev *led_cdev = dev_get_drvdata(dev);
-	struct oneshot_trig_data *oneshot_data = led_cdev->trigger_data;
-
-	led_blink_set_oneshot(led_cdev,
-			&led_cdev->blink_delay_on, &led_cdev->blink_delay_off,
-			oneshot_data->invert);
-
-	/* content is ignored */
-	return size;
-}
-static ssize_t led_invert_show(struct device *dev,
-		struct device_attribute *attr, char *buf)
-{
-	struct led_classdev *led_cdev = dev_get_drvdata(dev);
-	struct oneshot_trig_data *oneshot_data = led_cdev->trigger_data;
-
-	return sprintf(buf, "%u\n", oneshot_data->invert);
-}
-
-static ssize_t led_invert_store(struct device *dev,
-		struct device_attribute *attr, const char *buf, size_t size)
-{
-	struct led_classdev *led_cdev = dev_get_drvdata(dev);
-	struct oneshot_trig_data *oneshot_data = led_cdev->trigger_data;
-	unsigned long state;
-	int ret;
-
-	ret = kstrtoul(buf, 0, &state);
-	if (ret)
-		return ret;
-
-	oneshot_data->invert = !!state;
-
-	if (oneshot_data->invert)
-		__led_set_brightness(led_cdev, LED_FULL);
-	else
-		__led_set_brightness(led_cdev, LED_OFF);
-
-	return size;
-}
-
-static ssize_t led_delay_on_show(struct device *dev,
-		struct device_attribute *attr, char *buf)
-{
-	struct led_classdev *led_cdev = dev_get_drvdata(dev);
-
-	return sprintf(buf, "%lu\n", led_cdev->blink_delay_on);
-}
-
-static ssize_t led_delay_on_store(struct device *dev,
-		struct device_attribute *attr, const char *buf, size_t size)
-{
-	struct led_classdev *led_cdev = dev_get_drvdata(dev);
-	unsigned long state;
-	int ret;
-
-	ret = kstrtoul(buf, 0, &state);
-	if (ret)
-		return ret;
-
-	led_cdev->blink_delay_on = state;
-
-	return size;
-}
-static ssize_t led_delay_off_show(struct device *dev,
-		struct device_attribute *attr, char *buf)
-{
-	struct led_classdev *led_cdev = dev_get_drvdata(dev);
-
-	return sprintf(buf, "%lu\n", led_cdev->blink_delay_off);
-}
-
-static ssize_t led_delay_off_store(struct device *dev,
-		struct device_attribute *attr, const char *buf, size_t size)
-{
-	struct led_classdev *led_cdev = dev_get_drvdata(dev);
-	unsigned long state;
-	int ret;
-
-	ret = kstrtoul(buf, 0, &state);
-	if (ret)
-		return ret;
-
-	led_cdev->blink_delay_off = state;
-
-	return size;
-}
-
-static DEVICE_ATTR(delay_on, 0644, led_delay_on_show, led_delay_on_store);
-static DEVICE_ATTR(delay_off, 0644, led_delay_off_show, led_delay_off_store);
-static DEVICE_ATTR(invert, 0644, led_invert_show, led_invert_store);
-static DEVICE_ATTR(shot, 0200, NULL, led_shot);
-
-static void oneshot_trig_activate(struct led_classdev *led_cdev)
-{
-	struct oneshot_trig_data *oneshot_data;
-	int rc;
-
-	oneshot_data = kzalloc(sizeof(*oneshot_data), GFP_KERNEL);
-	if (!oneshot_data)
-		return;
-
-	led_cdev->trigger_data = oneshot_data;
-
-	rc = device_create_file(led_cdev->dev, &dev_attr_delay_on);
-	if (rc)
-		goto err_out_trig_data;
-	rc = device_create_file(led_cdev->dev, &dev_attr_delay_off);
-	if (rc)
-		goto err_out_delayon;
-	rc = device_create_file(led_cdev->dev, &dev_attr_invert);
-	if (rc)
-		goto err_out_delayoff;
-	rc = device_create_file(led_cdev->dev, &dev_attr_shot);
-	if (rc)
-		goto err_out_invert;
-
-	led_cdev->blink_delay_on = DEFAULT_DELAY;
-	led_cdev->blink_delay_off = DEFAULT_DELAY;
-
-	led_cdev->activated = true;
-
-	return;
-
-err_out_invert:
-	device_remove_file(led_cdev->dev, &dev_attr_invert);
-err_out_delayoff:
-	device_remove_file(led_cdev->dev, &dev_attr_delay_off);
-err_out_delayon:
-	device_remove_file(led_cdev->dev, &dev_attr_delay_on);
-err_out_trig_data:
-	kfree(led_cdev->trigger_data);
-}
-
-static void oneshot_trig_deactivate(struct led_classdev *led_cdev)
-{
-	struct oneshot_trig_data *oneshot_data = led_cdev->trigger_data;
-
-	if (led_cdev->activated) {
-		device_remove_file(led_cdev->dev, &dev_attr_delay_on);
-		device_remove_file(led_cdev->dev, &dev_attr_delay_off);
-		device_remove_file(led_cdev->dev, &dev_attr_invert);
-		device_remove_file(led_cdev->dev, &dev_attr_shot);
-		kfree(oneshot_data);
-		led_cdev->activated = false;
-	}
-
-	/* Stop blinking */
-	led_set_brightness(led_cdev, LED_OFF);
-}
-
-static struct led_trigger oneshot_led_trigger = {
-	.name     = "oneshot",
-	.activate = oneshot_trig_activate,
-	.deactivate = oneshot_trig_deactivate,
-};
-
-static int __init oneshot_trig_init(void)
-{
-	return led_trigger_register(&oneshot_led_trigger);
-}
-
-static void __exit oneshot_trig_exit(void)
-{
-	led_trigger_unregister(&oneshot_led_trigger);
-}
-
-module_init(oneshot_trig_init);
-module_exit(oneshot_trig_exit);
-
-MODULE_AUTHOR("Fabio Baltieri <fabio.baltieri@gmail.com>");
-MODULE_DESCRIPTION("One-shot LED trigger");
-MODULE_LICENSE("GPL");
diff --git a/drivers/leds/ledtrig-timer.c b/drivers/leds/ledtrig-timer.c
deleted file mode 100644
index f774d05..0000000
--- a/drivers/leds/ledtrig-timer.c
+++ /dev/null
@@ -1,131 +0,0 @@
-/*
- * LED Kernel Timer Trigger
- *
- * Copyright 2005-2006 Openedhand Ltd.
- *
- * Author: Richard Purdie <rpurdie@openedhand.com>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- *
- */
-
-#include <linux/module.h>
-#include <linux/kernel.h>
-#include <linux/init.h>
-#include <linux/device.h>
-#include <linux/ctype.h>
-#include <linux/leds.h>
-#include "leds.h"
-
-static ssize_t led_delay_on_show(struct device *dev,
-		struct device_attribute *attr, char *buf)
-{
-	struct led_classdev *led_cdev = dev_get_drvdata(dev);
-
-	return sprintf(buf, "%lu\n", led_cdev->blink_delay_on);
-}
-
-static ssize_t led_delay_on_store(struct device *dev,
-		struct device_attribute *attr, const char *buf, size_t size)
-{
-	struct led_classdev *led_cdev = dev_get_drvdata(dev);
-	unsigned long state;
-	ssize_t ret = -EINVAL;
-
-	ret = kstrtoul(buf, 10, &state);
-	if (ret)
-		return ret;
-
-	led_blink_set(led_cdev, &state, &led_cdev->blink_delay_off);
-	led_cdev->blink_delay_on = state;
-
-	return size;
-}
-
-static ssize_t led_delay_off_show(struct device *dev,
-		struct device_attribute *attr, char *buf)
-{
-	struct led_classdev *led_cdev = dev_get_drvdata(dev);
-
-	return sprintf(buf, "%lu\n", led_cdev->blink_delay_off);
-}
-
-static ssize_t led_delay_off_store(struct device *dev,
-		struct device_attribute *attr, const char *buf, size_t size)
-{
-	struct led_classdev *led_cdev = dev_get_drvdata(dev);
-	unsigned long state;
-	ssize_t ret = -EINVAL;
-
-	ret = kstrtoul(buf, 10, &state);
-	if (ret)
-		return ret;
-
-	led_blink_set(led_cdev, &led_cdev->blink_delay_on, &state);
-	led_cdev->blink_delay_off = state;
-
-	return size;
-}
-
-static DEVICE_ATTR(delay_on, 0644, led_delay_on_show, led_delay_on_store);
-static DEVICE_ATTR(delay_off, 0644, led_delay_off_show, led_delay_off_store);
-
-static void timer_trig_activate(struct led_classdev *led_cdev)
-{
-	int rc;
-
-	led_cdev->trigger_data = NULL;
-
-	rc = device_create_file(led_cdev->dev, &dev_attr_delay_on);
-	if (rc)
-		return;
-	rc = device_create_file(led_cdev->dev, &dev_attr_delay_off);
-	if (rc)
-		goto err_out_delayon;
-
-	led_blink_set(led_cdev, &led_cdev->blink_delay_on,
-		      &led_cdev->blink_delay_off);
-	led_cdev->activated = true;
-
-	return;
-
-err_out_delayon:
-	device_remove_file(led_cdev->dev, &dev_attr_delay_on);
-}
-
-static void timer_trig_deactivate(struct led_classdev *led_cdev)
-{
-	if (led_cdev->activated) {
-		device_remove_file(led_cdev->dev, &dev_attr_delay_on);
-		device_remove_file(led_cdev->dev, &dev_attr_delay_off);
-		led_cdev->activated = false;
-	}
-
-	/* Stop blinking */
-	led_set_brightness(led_cdev, LED_OFF);
-}
-
-static struct led_trigger timer_led_trigger = {
-	.name     = "timer",
-	.activate = timer_trig_activate,
-	.deactivate = timer_trig_deactivate,
-};
-
-static int __init timer_trig_init(void)
-{
-	return led_trigger_register(&timer_led_trigger);
-}
-
-static void __exit timer_trig_exit(void)
-{
-	led_trigger_unregister(&timer_led_trigger);
-}
-
-module_init(timer_trig_init);
-module_exit(timer_trig_exit);
-
-MODULE_AUTHOR("Richard Purdie <rpurdie@openedhand.com>");
-MODULE_DESCRIPTION("Timer LED trigger");
-MODULE_LICENSE("GPL");
diff --git a/drivers/leds/ledtrig-transient.c b/drivers/leds/ledtrig-transient.c
deleted file mode 100644
index 398f104..0000000
--- a/drivers/leds/ledtrig-transient.c
+++ /dev/null
@@ -1,237 +0,0 @@
-/*
- * LED Kernel Transient Trigger
- *
- * Copyright (C) 2012 Shuah Khan <shuahkhan@gmail.com>
- *
- * Based on Richard Purdie's ledtrig-timer.c and Atsushi Nemoto's
- * ledtrig-heartbeat.c
- * Design and use-case input from Jonas Bonn <jonas@southpole.se> and
- * Neil Brown <neilb@suse.de>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- *
- */
-/*
- * Transient trigger allows one shot timer activation. Please refer to
- * Documentation/leds/ledtrig-transient.txt for details
-*/
-
-#include <linux/module.h>
-#include <linux/kernel.h>
-#include <linux/init.h>
-#include <linux/device.h>
-#include <linux/slab.h>
-#include <linux/timer.h>
-#include <linux/leds.h>
-#include "leds.h"
-
-struct transient_trig_data {
-	int activate;
-	int state;
-	int restore_state;
-	unsigned long duration;
-	struct timer_list timer;
-};
-
-static void transient_timer_function(unsigned long data)
-{
-	struct led_classdev *led_cdev = (struct led_classdev *) data;
-	struct transient_trig_data *transient_data = led_cdev->trigger_data;
-
-	transient_data->activate = 0;
-	__led_set_brightness(led_cdev, transient_data->restore_state);
-}
-
-static ssize_t transient_activate_show(struct device *dev,
-		struct device_attribute *attr, char *buf)
-{
-	struct led_classdev *led_cdev = dev_get_drvdata(dev);
-	struct transient_trig_data *transient_data = led_cdev->trigger_data;
-
-	return sprintf(buf, "%d\n", transient_data->activate);
-}
-
-static ssize_t transient_activate_store(struct device *dev,
-		struct device_attribute *attr, const char *buf, size_t size)
-{
-	struct led_classdev *led_cdev = dev_get_drvdata(dev);
-	struct transient_trig_data *transient_data = led_cdev->trigger_data;
-	unsigned long state;
-	ssize_t ret;
-
-	ret = kstrtoul(buf, 10, &state);
-	if (ret)
-		return ret;
-
-	if (state != 1 && state != 0)
-		return -EINVAL;
-
-	/* cancel the running timer */
-	if (state == 0 && transient_data->activate == 1) {
-		del_timer(&transient_data->timer);
-		transient_data->activate = state;
-		__led_set_brightness(led_cdev, transient_data->restore_state);
-		return size;
-	}
-
-	/* start timer if there is no active timer */
-	if (state == 1 && transient_data->activate == 0 &&
-	    transient_data->duration != 0) {
-		transient_data->activate = state;
-		__led_set_brightness(led_cdev, transient_data->state);
-		transient_data->restore_state =
-		    (transient_data->state == LED_FULL) ? LED_OFF : LED_FULL;
-		mod_timer(&transient_data->timer,
-			  jiffies + transient_data->duration);
-	}
-
-	/* state == 0 && transient_data->activate == 0
-		timer is not active - just return */
-	/* state == 1 && transient_data->activate == 1
-		timer is already active - just return */
-
-	return size;
-}
-
-static ssize_t transient_duration_show(struct device *dev,
-		struct device_attribute *attr, char *buf)
-{
-	struct led_classdev *led_cdev = dev_get_drvdata(dev);
-	struct transient_trig_data *transient_data = led_cdev->trigger_data;
-
-	return sprintf(buf, "%lu\n", transient_data->duration);
-}
-
-static ssize_t transient_duration_store(struct device *dev,
-		struct device_attribute *attr, const char *buf, size_t size)
-{
-	struct led_classdev *led_cdev = dev_get_drvdata(dev);
-	struct transient_trig_data *transient_data = led_cdev->trigger_data;
-	unsigned long state;
-	ssize_t ret;
-
-	ret = kstrtoul(buf, 10, &state);
-	if (ret)
-		return ret;
-
-	transient_data->duration = state;
-	return size;
-}
-
-static ssize_t transient_state_show(struct device *dev,
-		struct device_attribute *attr, char *buf)
-{
-	struct led_classdev *led_cdev = dev_get_drvdata(dev);
-	struct transient_trig_data *transient_data = led_cdev->trigger_data;
-	int state;
-
-	state = (transient_data->state == LED_FULL) ? 1 : 0;
-	return sprintf(buf, "%d\n", state);
-}
-
-static ssize_t transient_state_store(struct device *dev,
-		struct device_attribute *attr, const char *buf, size_t size)
-{
-	struct led_classdev *led_cdev = dev_get_drvdata(dev);
-	struct transient_trig_data *transient_data = led_cdev->trigger_data;
-	unsigned long state;
-	ssize_t ret;
-
-	ret = kstrtoul(buf, 10, &state);
-	if (ret)
-		return ret;
-
-	if (state != 1 && state != 0)
-		return -EINVAL;
-
-	transient_data->state = (state == 1) ? LED_FULL : LED_OFF;
-	return size;
-}
-
-static DEVICE_ATTR(activate, 0644, transient_activate_show,
-		   transient_activate_store);
-static DEVICE_ATTR(duration, 0644, transient_duration_show,
-		   transient_duration_store);
-static DEVICE_ATTR(state, 0644, transient_state_show, transient_state_store);
-
-static void transient_trig_activate(struct led_classdev *led_cdev)
-{
-	int rc;
-	struct transient_trig_data *tdata;
-
-	tdata = kzalloc(sizeof(struct transient_trig_data), GFP_KERNEL);
-	if (!tdata) {
-		dev_err(led_cdev->dev,
-			"unable to allocate transient trigger\n");
-		return;
-	}
-	led_cdev->trigger_data = tdata;
-
-	rc = device_create_file(led_cdev->dev, &dev_attr_activate);
-	if (rc)
-		goto err_out;
-
-	rc = device_create_file(led_cdev->dev, &dev_attr_duration);
-	if (rc)
-		goto err_out_duration;
-
-	rc = device_create_file(led_cdev->dev, &dev_attr_state);
-	if (rc)
-		goto err_out_state;
-
-	setup_timer(&tdata->timer, transient_timer_function,
-		    (unsigned long) led_cdev);
-	led_cdev->activated = true;
-
-	return;
-
-err_out_state:
-	device_remove_file(led_cdev->dev, &dev_attr_duration);
-err_out_duration:
-	device_remove_file(led_cdev->dev, &dev_attr_activate);
-err_out:
-	dev_err(led_cdev->dev, "unable to register transient trigger\n");
-	led_cdev->trigger_data = NULL;
-	kfree(tdata);
-}
-
-static void transient_trig_deactivate(struct led_classdev *led_cdev)
-{
-	struct transient_trig_data *transient_data = led_cdev->trigger_data;
-
-	if (led_cdev->activated) {
-		del_timer_sync(&transient_data->timer);
-		__led_set_brightness(led_cdev, transient_data->restore_state);
-		device_remove_file(led_cdev->dev, &dev_attr_activate);
-		device_remove_file(led_cdev->dev, &dev_attr_duration);
-		device_remove_file(led_cdev->dev, &dev_attr_state);
-		led_cdev->trigger_data = NULL;
-		led_cdev->activated = false;
-		kfree(transient_data);
-	}
-}
-
-static struct led_trigger transient_trigger = {
-	.name     = "transient",
-	.activate = transient_trig_activate,
-	.deactivate = transient_trig_deactivate,
-};
-
-static int __init transient_trig_init(void)
-{
-	return led_trigger_register(&transient_trigger);
-}
-
-static void __exit transient_trig_exit(void)
-{
-	led_trigger_unregister(&transient_trigger);
-}
-
-module_init(transient_trig_init);
-module_exit(transient_trig_exit);
-
-MODULE_AUTHOR("Shuah Khan <shuahkhan@gmail.com>");
-MODULE_DESCRIPTION("Transient LED trigger");
-MODULE_LICENSE("GPL");
diff --git a/drivers/leds/trigger/Kconfig b/drivers/leds/trigger/Kconfig
new file mode 100644
index 0000000..eaa286d
--- /dev/null
+++ b/drivers/leds/trigger/Kconfig
@@ -0,0 +1,103 @@
+menuconfig LEDS_TRIGGERS
+	bool "LED Trigger support"
+	depends on LEDS_CLASS
+	help
+	  This option enables trigger support for the leds class.
+	  These triggers allow kernel events to drive the LEDs and can
+	  be configured via sysfs. If unsure, say Y.
+
+if LEDS_TRIGGERS
+
+config LEDS_TRIGGER_TIMER
+	tristate "LED Timer Trigger"
+	depends on LEDS_TRIGGERS
+	help
+	  This allows LEDs to be controlled by a programmable timer
+	  via sysfs. Some LED hardware can be programmed to start
+	  blinking the LED without any further software interaction.
+	  For more details read Documentation/leds/leds-class.txt.
+
+	  If unsure, say Y.
+
+config LEDS_TRIGGER_ONESHOT
+	tristate "LED One-shot Trigger"
+	depends on LEDS_TRIGGERS
+	help
+	  This allows LEDs to blink in one-shot pulses with parameters
+	  controlled via sysfs.  It's useful to notify the user on
+	  sporadic events, when there are no clear begin and end trap points,
+	  or on dense events, where this blinks the LED at constant rate if
+	  rearmed continuously.
+
+	  It also shows how to use the led_blink_set_oneshot() function.
+
+	  If unsure, say Y.
+
+config LEDS_TRIGGER_IDE_DISK
+	bool "LED IDE Disk Trigger"
+	depends on IDE_GD_ATA
+	depends on LEDS_TRIGGERS
+	help
+	  This allows LEDs to be controlled by IDE disk activity.
+	  If unsure, say Y.
+
+config LEDS_TRIGGER_HEARTBEAT
+	tristate "LED Heartbeat Trigger"
+	depends on LEDS_TRIGGERS
+	help
+	  This allows LEDs to be controlled by a CPU load average.
+	  The flash frequency is a hyperbolic function of the 1-minute
+	  load average.
+	  If unsure, say Y.
+
+config LEDS_TRIGGER_BACKLIGHT
+	tristate "LED backlight Trigger"
+	depends on LEDS_TRIGGERS
+	help
+	  This allows LEDs to be controlled as a backlight device: they
+	  turn off and on when the display is blanked and unblanked.
+
+	  If unsure, say N.
+
+config LEDS_TRIGGER_CPU
+	bool "LED CPU Trigger"
+	depends on LEDS_TRIGGERS
+	help
+	  This allows LEDs to be controlled by active CPUs. This shows
+	  the active CPUs across an array of LEDs so you can see which
+	  CPUs are active on the system at any given moment.
+
+	  If unsure, say N.
+
+config LEDS_TRIGGER_GPIO
+	tristate "LED GPIO Trigger"
+	depends on LEDS_TRIGGERS
+	depends on GPIOLIB
+	help
+	  This allows LEDs to be controlled by gpio events. It's good
+	  when using gpios as switches and triggering the needed LEDs
+	  from there. One use case is n810's keypad LEDs that could
+	  be triggered by this trigger when user slides up to show
+	  keypad.
+
+	  If unsure, say N.
+
+config LEDS_TRIGGER_DEFAULT_ON
+	tristate "LED Default ON Trigger"
+	depends on LEDS_TRIGGERS
+	help
+	  This allows LEDs to be initialised in the ON state.
+	  If unsure, say Y.
+
+comment "iptables trigger is under Netfilter config (LED target)"
+	depends on LEDS_TRIGGERS
+
+config LEDS_TRIGGER_TRANSIENT
+	tristate "LED Transient Trigger"
+	depends on LEDS_TRIGGERS
+	help
+	  This allows one time activation of a transient state on
+	  GPIO/PWM based hardware.
+	  If unsure, say Y.
+
+endif # LEDS_TRIGGERS
diff --git a/drivers/leds/trigger/Makefile b/drivers/leds/trigger/Makefile
new file mode 100644
index 0000000..554e46e
--- /dev/null
+++ b/drivers/leds/trigger/Makefile
@@ -0,0 +1,9 @@
+obj-$(CONFIG_LEDS_TRIGGER_TIMER)	+= ledtrig-timer.o
+obj-$(CONFIG_LEDS_TRIGGER_ONESHOT)	+= ledtrig-oneshot.o
+obj-$(CONFIG_LEDS_TRIGGER_IDE_DISK)	+= ledtrig-ide-disk.o
+obj-$(CONFIG_LEDS_TRIGGER_HEARTBEAT)	+= ledtrig-heartbeat.o
+obj-$(CONFIG_LEDS_TRIGGER_BACKLIGHT)	+= ledtrig-backlight.o
+obj-$(CONFIG_LEDS_TRIGGER_GPIO)		+= ledtrig-gpio.o
+obj-$(CONFIG_LEDS_TRIGGER_CPU)		+= ledtrig-cpu.o
+obj-$(CONFIG_LEDS_TRIGGER_DEFAULT_ON)	+= ledtrig-default-on.o
+obj-$(CONFIG_LEDS_TRIGGER_TRANSIENT)	+= ledtrig-transient.o
diff --git a/drivers/leds/trigger/ledtrig-backlight.c b/drivers/leds/trigger/ledtrig-backlight.c
new file mode 100644
index 0000000..3c9c88a
--- /dev/null
+++ b/drivers/leds/trigger/ledtrig-backlight.c
@@ -0,0 +1,166 @@
+/*
+ * Backlight emulation LED trigger
+ *
+ * Copyright 2008 (C) Rodolfo Giometti <giometti@linux.it>
+ * Copyright 2008 (C) Eurotech S.p.A. <info@eurotech.it>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ */
+
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/slab.h>
+#include <linux/init.h>
+#include <linux/fb.h>
+#include <linux/leds.h>
+#include "../leds.h"
+
+#define BLANK		1
+#define UNBLANK		0
+
+struct bl_trig_notifier {
+	struct led_classdev *led;
+	int brightness;
+	int old_status;
+	struct notifier_block notifier;
+	unsigned invert;
+};
+
+static int fb_notifier_callback(struct notifier_block *p,
+				unsigned long event, void *data)
+{
+	struct bl_trig_notifier *n = container_of(p,
+					struct bl_trig_notifier, notifier);
+	struct led_classdev *led = n->led;
+	struct fb_event *fb_event = data;
+	int *blank = fb_event->data;
+	int new_status = *blank ? BLANK : UNBLANK;
+
+	switch (event) {
+	case FB_EVENT_BLANK:
+		if (new_status == n->old_status)
+			break;
+
+		if ((n->old_status == UNBLANK) ^ n->invert) {
+			n->brightness = led->brightness;
+			__led_set_brightness(led, LED_OFF);
+		} else {
+			__led_set_brightness(led, n->brightness);
+		}
+
+		n->old_status = new_status;
+
+		break;
+	}
+
+	return 0;
+}
+
+static ssize_t bl_trig_invert_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct led_classdev *led = dev_get_drvdata(dev);
+	struct bl_trig_notifier *n = led->trigger_data;
+
+	return sprintf(buf, "%u\n", n->invert);
+}
+
+static ssize_t bl_trig_invert_store(struct device *dev,
+		struct device_attribute *attr, const char *buf, size_t num)
+{
+	struct led_classdev *led = dev_get_drvdata(dev);
+	struct bl_trig_notifier *n = led->trigger_data;
+	unsigned long invert;
+	int ret;
+
+	ret = kstrtoul(buf, 10, &invert);
+	if (ret < 0)
+		return ret;
+
+	if (invert > 1)
+		return -EINVAL;
+
+	n->invert = invert;
+
+	/* After inverting, we need to update the LED. */
+	if ((n->old_status == BLANK) ^ n->invert)
+		__led_set_brightness(led, LED_OFF);
+	else
+		__led_set_brightness(led, n->brightness);
+
+	return num;
+}
+static DEVICE_ATTR(inverted, 0644, bl_trig_invert_show, bl_trig_invert_store);
+
+static void bl_trig_activate(struct led_classdev *led)
+{
+	int ret;
+
+	struct bl_trig_notifier *n;
+
+	n = kzalloc(sizeof(struct bl_trig_notifier), GFP_KERNEL);
+	led->trigger_data = n;
+	if (!n) {
+		dev_err(led->dev, "unable to allocate backlight trigger\n");
+		return;
+	}
+
+	ret = device_create_file(led->dev, &dev_attr_inverted);
+	if (ret)
+		goto err_invert;
+
+	n->led = led;
+	n->brightness = led->brightness;
+	n->old_status = UNBLANK;
+	n->notifier.notifier_call = fb_notifier_callback;
+
+	ret = fb_register_client(&n->notifier);
+	if (ret)
+		dev_err(led->dev, "unable to register backlight trigger\n");
+	led->activated = true;
+
+	return;
+
+err_invert:
+	led->trigger_data = NULL;
+	kfree(n);
+}
+
+static void bl_trig_deactivate(struct led_classdev *led)
+{
+	struct bl_trig_notifier *n =
+		(struct bl_trig_notifier *) led->trigger_data;
+
+	if (led->activated) {
+		device_remove_file(led->dev, &dev_attr_inverted);
+		fb_unregister_client(&n->notifier);
+		kfree(n);
+		led->activated = false;
+	}
+}
+
+static struct led_trigger bl_led_trigger = {
+	.name		= "backlight",
+	.activate	= bl_trig_activate,
+	.deactivate	= bl_trig_deactivate
+};
+
+static int __init bl_trig_init(void)
+{
+	return led_trigger_register(&bl_led_trigger);
+}
+
+static void __exit bl_trig_exit(void)
+{
+	led_trigger_unregister(&bl_led_trigger);
+}
+
+module_init(bl_trig_init);
+module_exit(bl_trig_exit);
+
+MODULE_AUTHOR("Rodolfo Giometti <giometti@linux.it>");
+MODULE_DESCRIPTION("Backlight emulation LED trigger");
+MODULE_LICENSE("GPL v2");
diff --git a/drivers/leds/trigger/ledtrig-cpu.c b/drivers/leds/trigger/ledtrig-cpu.c
new file mode 100644
index 0000000..118335e
--- /dev/null
+++ b/drivers/leds/trigger/ledtrig-cpu.c
@@ -0,0 +1,142 @@
+/*
+ * ledtrig-cpu.c - LED trigger based on CPU activity
+ *
+ * This LED trigger will be registered for each possible CPU and named as
+ * cpu0, cpu1, cpu2, cpu3, etc.
+ *
+ * It can be bound to any LED just like other triggers using either a
+ * board file or via sysfs interface.
+ *
+ * An API named ledtrig_cpu is exported for any user, who want to add CPU
+ * activity indication in their code
+ *
+ * Copyright 2011 Linus Walleij <linus.walleij@linaro.org>
+ * Copyright 2011 - 2012 Bryan Wu <bryan.wu@canonical.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ */
+
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/slab.h>
+#include <linux/percpu.h>
+#include <linux/syscore_ops.h>
+#include <linux/rwsem.h>
+#include "../leds.h"
+
+#define MAX_NAME_LEN	8
+
+struct led_trigger_cpu {
+	char name[MAX_NAME_LEN];
+	struct led_trigger *_trig;
+};
+
+static DEFINE_PER_CPU(struct led_trigger_cpu, cpu_trig);
+
+/**
+ * ledtrig_cpu - emit a CPU event as a trigger
+ * @evt: CPU event to be emitted
+ *
+ * Emit a CPU event on a CPU core, which will trigger a
+ * binded LED to turn on or turn off.
+ */
+void ledtrig_cpu(enum cpu_led_event ledevt)
+{
+	struct led_trigger_cpu *trig = &__get_cpu_var(cpu_trig);
+
+	/* Locate the correct CPU LED */
+	switch (ledevt) {
+	case CPU_LED_IDLE_END:
+	case CPU_LED_START:
+		/* Will turn the LED on, max brightness */
+		led_trigger_event(trig->_trig, LED_FULL);
+		break;
+
+	case CPU_LED_IDLE_START:
+	case CPU_LED_STOP:
+	case CPU_LED_HALTED:
+		/* Will turn the LED off */
+		led_trigger_event(trig->_trig, LED_OFF);
+		break;
+
+	default:
+		/* Will leave the LED as it is */
+		break;
+	}
+}
+EXPORT_SYMBOL(ledtrig_cpu);
+
+static int ledtrig_cpu_syscore_suspend(void)
+{
+	ledtrig_cpu(CPU_LED_STOP);
+	return 0;
+}
+
+static void ledtrig_cpu_syscore_resume(void)
+{
+	ledtrig_cpu(CPU_LED_START);
+}
+
+static void ledtrig_cpu_syscore_shutdown(void)
+{
+	ledtrig_cpu(CPU_LED_HALTED);
+}
+
+static struct syscore_ops ledtrig_cpu_syscore_ops = {
+	.shutdown	= ledtrig_cpu_syscore_shutdown,
+	.suspend	= ledtrig_cpu_syscore_suspend,
+	.resume		= ledtrig_cpu_syscore_resume,
+};
+
+static int __init ledtrig_cpu_init(void)
+{
+	int cpu;
+
+	/* Supports up to 9999 cpu cores */
+	BUILD_BUG_ON(CONFIG_NR_CPUS > 9999);
+
+	/*
+	 * Registering CPU led trigger for each CPU core here
+	 * ignores CPU hotplug, but after this CPU hotplug works
+	 * fine with this trigger.
+	 */
+	for_each_possible_cpu(cpu) {
+		struct led_trigger_cpu *trig = &per_cpu(cpu_trig, cpu);
+
+		snprintf(trig->name, MAX_NAME_LEN, "cpu%d", cpu);
+
+		led_trigger_register_simple(trig->name, &trig->_trig);
+	}
+
+	register_syscore_ops(&ledtrig_cpu_syscore_ops);
+
+	pr_info("ledtrig-cpu: registered to indicate activity on CPUs\n");
+
+	return 0;
+}
+module_init(ledtrig_cpu_init);
+
+static void __exit ledtrig_cpu_exit(void)
+{
+	int cpu;
+
+	for_each_possible_cpu(cpu) {
+		struct led_trigger_cpu *trig = &per_cpu(cpu_trig, cpu);
+
+		led_trigger_unregister_simple(trig->_trig);
+		trig->_trig = NULL;
+		memset(trig->name, 0, MAX_NAME_LEN);
+	}
+
+	unregister_syscore_ops(&ledtrig_cpu_syscore_ops);
+}
+module_exit(ledtrig_cpu_exit);
+
+MODULE_AUTHOR("Linus Walleij <linus.walleij@linaro.org>");
+MODULE_AUTHOR("Bryan Wu <bryan.wu@canonical.com>");
+MODULE_DESCRIPTION("CPU LED trigger");
+MODULE_LICENSE("GPL");
diff --git a/drivers/leds/trigger/ledtrig-default-on.c b/drivers/leds/trigger/ledtrig-default-on.c
new file mode 100644
index 0000000..81a91be
--- /dev/null
+++ b/drivers/leds/trigger/ledtrig-default-on.c
@@ -0,0 +1,45 @@
+/*
+ * LED Kernel Default ON Trigger
+ *
+ * Copyright 2008 Nick Forbes <nick.forbes@incepta.com>
+ *
+ * Based on Richard Purdie's ledtrig-timer.c.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ */
+
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/leds.h>
+#include "../leds.h"
+
+static void defon_trig_activate(struct led_classdev *led_cdev)
+{
+	__led_set_brightness(led_cdev, led_cdev->max_brightness);
+}
+
+static struct led_trigger defon_led_trigger = {
+	.name     = "default-on",
+	.activate = defon_trig_activate,
+};
+
+static int __init defon_trig_init(void)
+{
+	return led_trigger_register(&defon_led_trigger);
+}
+
+static void __exit defon_trig_exit(void)
+{
+	led_trigger_unregister(&defon_led_trigger);
+}
+
+module_init(defon_trig_init);
+module_exit(defon_trig_exit);
+
+MODULE_AUTHOR("Nick Forbes <nick.forbes@incepta.com>");
+MODULE_DESCRIPTION("Default-ON LED trigger");
+MODULE_LICENSE("GPL");
diff --git a/drivers/leds/trigger/ledtrig-gpio.c b/drivers/leds/trigger/ledtrig-gpio.c
new file mode 100644
index 0000000..35812e3
--- /dev/null
+++ b/drivers/leds/trigger/ledtrig-gpio.c
@@ -0,0 +1,253 @@
+/*
+ * ledtrig-gio.c - LED Trigger Based on GPIO events
+ *
+ * Copyright 2009 Felipe Balbi <me@felipebalbi.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ */
+
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/gpio.h>
+#include <linux/interrupt.h>
+#include <linux/workqueue.h>
+#include <linux/leds.h>
+#include <linux/slab.h>
+#include "../leds.h"
+
+struct gpio_trig_data {
+	struct led_classdev *led;
+	struct work_struct work;
+
+	unsigned desired_brightness;	/* desired brightness when led is on */
+	unsigned inverted;		/* true when gpio is inverted */
+	unsigned gpio;			/* gpio that triggers the leds */
+};
+
+static irqreturn_t gpio_trig_irq(int irq, void *_led)
+{
+	struct led_classdev *led = _led;
+	struct gpio_trig_data *gpio_data = led->trigger_data;
+
+	/* just schedule_work since gpio_get_value can sleep */
+	schedule_work(&gpio_data->work);
+
+	return IRQ_HANDLED;
+};
+
+static void gpio_trig_work(struct work_struct *work)
+{
+	struct gpio_trig_data *gpio_data = container_of(work,
+			struct gpio_trig_data, work);
+	int tmp;
+
+	if (!gpio_data->gpio)
+		return;
+
+	tmp = gpio_get_value(gpio_data->gpio);
+	if (gpio_data->inverted)
+		tmp = !tmp;
+
+	if (tmp) {
+		if (gpio_data->desired_brightness)
+			__led_set_brightness(gpio_data->led,
+					   gpio_data->desired_brightness);
+		else
+			__led_set_brightness(gpio_data->led, LED_FULL);
+	} else {
+		__led_set_brightness(gpio_data->led, LED_OFF);
+	}
+}
+
+static ssize_t gpio_trig_brightness_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct led_classdev *led = dev_get_drvdata(dev);
+	struct gpio_trig_data *gpio_data = led->trigger_data;
+
+	return sprintf(buf, "%u\n", gpio_data->desired_brightness);
+}
+
+static ssize_t gpio_trig_brightness_store(struct device *dev,
+		struct device_attribute *attr, const char *buf, size_t n)
+{
+	struct led_classdev *led = dev_get_drvdata(dev);
+	struct gpio_trig_data *gpio_data = led->trigger_data;
+	unsigned desired_brightness;
+	int ret;
+
+	ret = sscanf(buf, "%u", &desired_brightness);
+	if (ret < 1 || desired_brightness > 255) {
+		dev_err(dev, "invalid value\n");
+		return -EINVAL;
+	}
+
+	gpio_data->desired_brightness = desired_brightness;
+
+	return n;
+}
+static DEVICE_ATTR(desired_brightness, 0644, gpio_trig_brightness_show,
+		gpio_trig_brightness_store);
+
+static ssize_t gpio_trig_inverted_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct led_classdev *led = dev_get_drvdata(dev);
+	struct gpio_trig_data *gpio_data = led->trigger_data;
+
+	return sprintf(buf, "%u\n", gpio_data->inverted);
+}
+
+static ssize_t gpio_trig_inverted_store(struct device *dev,
+		struct device_attribute *attr, const char *buf, size_t n)
+{
+	struct led_classdev *led = dev_get_drvdata(dev);
+	struct gpio_trig_data *gpio_data = led->trigger_data;
+	unsigned long inverted;
+	int ret;
+
+	ret = kstrtoul(buf, 10, &inverted);
+	if (ret < 0)
+		return ret;
+
+	if (inverted > 1)
+		return -EINVAL;
+
+	gpio_data->inverted = inverted;
+
+	/* After inverting, we need to update the LED. */
+	schedule_work(&gpio_data->work);
+
+	return n;
+}
+static DEVICE_ATTR(inverted, 0644, gpio_trig_inverted_show,
+		gpio_trig_inverted_store);
+
+static ssize_t gpio_trig_gpio_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct led_classdev *led = dev_get_drvdata(dev);
+	struct gpio_trig_data *gpio_data = led->trigger_data;
+
+	return sprintf(buf, "%u\n", gpio_data->gpio);
+}
+
+static ssize_t gpio_trig_gpio_store(struct device *dev,
+		struct device_attribute *attr, const char *buf, size_t n)
+{
+	struct led_classdev *led = dev_get_drvdata(dev);
+	struct gpio_trig_data *gpio_data = led->trigger_data;
+	unsigned gpio;
+	int ret;
+
+	ret = sscanf(buf, "%u", &gpio);
+	if (ret < 1) {
+		dev_err(dev, "couldn't read gpio number\n");
+		flush_work(&gpio_data->work);
+		return -EINVAL;
+	}
+
+	if (gpio_data->gpio == gpio)
+		return n;
+
+	if (!gpio) {
+		if (gpio_data->gpio != 0)
+			free_irq(gpio_to_irq(gpio_data->gpio), led);
+		gpio_data->gpio = 0;
+		return n;
+	}
+
+	ret = request_irq(gpio_to_irq(gpio), gpio_trig_irq,
+			IRQF_SHARED | IRQF_TRIGGER_RISING
+			| IRQF_TRIGGER_FALLING, "ledtrig-gpio", led);
+	if (ret) {
+		dev_err(dev, "request_irq failed with error %d\n", ret);
+	} else {
+		if (gpio_data->gpio != 0)
+			free_irq(gpio_to_irq(gpio_data->gpio), led);
+		gpio_data->gpio = gpio;
+	}
+
+	return ret ? ret : n;
+}
+static DEVICE_ATTR(gpio, 0644, gpio_trig_gpio_show, gpio_trig_gpio_store);
+
+static void gpio_trig_activate(struct led_classdev *led)
+{
+	struct gpio_trig_data *gpio_data;
+	int ret;
+
+	gpio_data = kzalloc(sizeof(*gpio_data), GFP_KERNEL);
+	if (!gpio_data)
+		return;
+
+	ret = device_create_file(led->dev, &dev_attr_gpio);
+	if (ret)
+		goto err_gpio;
+
+	ret = device_create_file(led->dev, &dev_attr_inverted);
+	if (ret)
+		goto err_inverted;
+
+	ret = device_create_file(led->dev, &dev_attr_desired_brightness);
+	if (ret)
+		goto err_brightness;
+
+	gpio_data->led = led;
+	led->trigger_data = gpio_data;
+	INIT_WORK(&gpio_data->work, gpio_trig_work);
+	led->activated = true;
+
+	return;
+
+err_brightness:
+	device_remove_file(led->dev, &dev_attr_inverted);
+
+err_inverted:
+	device_remove_file(led->dev, &dev_attr_gpio);
+
+err_gpio:
+	kfree(gpio_data);
+}
+
+static void gpio_trig_deactivate(struct led_classdev *led)
+{
+	struct gpio_trig_data *gpio_data = led->trigger_data;
+
+	if (led->activated) {
+		device_remove_file(led->dev, &dev_attr_gpio);
+		device_remove_file(led->dev, &dev_attr_inverted);
+		device_remove_file(led->dev, &dev_attr_desired_brightness);
+		flush_work(&gpio_data->work);
+		if (gpio_data->gpio != 0)
+			free_irq(gpio_to_irq(gpio_data->gpio), led);
+		kfree(gpio_data);
+		led->activated = false;
+	}
+}
+
+static struct led_trigger gpio_led_trigger = {
+	.name		= "gpio",
+	.activate	= gpio_trig_activate,
+	.deactivate	= gpio_trig_deactivate,
+};
+
+static int __init gpio_trig_init(void)
+{
+	return led_trigger_register(&gpio_led_trigger);
+}
+module_init(gpio_trig_init);
+
+static void __exit gpio_trig_exit(void)
+{
+	led_trigger_unregister(&gpio_led_trigger);
+}
+module_exit(gpio_trig_exit);
+
+MODULE_AUTHOR("Felipe Balbi <me@felipebalbi.com>");
+MODULE_DESCRIPTION("GPIO LED trigger");
+MODULE_LICENSE("GPL");
diff --git a/drivers/leds/trigger/ledtrig-heartbeat.c b/drivers/leds/trigger/ledtrig-heartbeat.c
new file mode 100644
index 0000000..5c8464a
--- /dev/null
+++ b/drivers/leds/trigger/ledtrig-heartbeat.c
@@ -0,0 +1,161 @@
+/*
+ * LED Heartbeat Trigger
+ *
+ * Copyright (C) 2006 Atsushi Nemoto <anemo@mba.ocn.ne.jp>
+ *
+ * Based on Richard Purdie's ledtrig-timer.c and some arch's
+ * CONFIG_HEARTBEAT code.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ */
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/slab.h>
+#include <linux/timer.h>
+#include <linux/sched.h>
+#include <linux/leds.h>
+#include <linux/reboot.h>
+#include "../leds.h"
+
+static int panic_heartbeats;
+
+struct heartbeat_trig_data {
+	unsigned int phase;
+	unsigned int period;
+	struct timer_list timer;
+};
+
+static void led_heartbeat_function(unsigned long data)
+{
+	struct led_classdev *led_cdev = (struct led_classdev *) data;
+	struct heartbeat_trig_data *heartbeat_data = led_cdev->trigger_data;
+	unsigned long brightness = LED_OFF;
+	unsigned long delay = 0;
+
+	if (unlikely(panic_heartbeats)) {
+		led_set_brightness(led_cdev, LED_OFF);
+		return;
+	}
+
+	/* acts like an actual heart beat -- ie thump-thump-pause... */
+	switch (heartbeat_data->phase) {
+	case 0:
+		/*
+		 * The hyperbolic function below modifies the
+		 * heartbeat period length in dependency of the
+		 * current (1min) load. It goes through the points
+		 * f(0)=1260, f(1)=860, f(5)=510, f(inf)->300.
+		 */
+		heartbeat_data->period = 300 +
+			(6720 << FSHIFT) / (5 * avenrun[0] + (7 << FSHIFT));
+		heartbeat_data->period =
+			msecs_to_jiffies(heartbeat_data->period);
+		delay = msecs_to_jiffies(70);
+		heartbeat_data->phase++;
+		brightness = led_cdev->max_brightness;
+		break;
+	case 1:
+		delay = heartbeat_data->period / 4 - msecs_to_jiffies(70);
+		heartbeat_data->phase++;
+		break;
+	case 2:
+		delay = msecs_to_jiffies(70);
+		heartbeat_data->phase++;
+		brightness = led_cdev->max_brightness;
+		break;
+	default:
+		delay = heartbeat_data->period - heartbeat_data->period / 4 -
+			msecs_to_jiffies(70);
+		heartbeat_data->phase = 0;
+		break;
+	}
+
+	__led_set_brightness(led_cdev, brightness);
+	mod_timer(&heartbeat_data->timer, jiffies + delay);
+}
+
+static void heartbeat_trig_activate(struct led_classdev *led_cdev)
+{
+	struct heartbeat_trig_data *heartbeat_data;
+
+	heartbeat_data = kzalloc(sizeof(*heartbeat_data), GFP_KERNEL);
+	if (!heartbeat_data)
+		return;
+
+	led_cdev->trigger_data = heartbeat_data;
+	setup_timer(&heartbeat_data->timer,
+		    led_heartbeat_function, (unsigned long) led_cdev);
+	heartbeat_data->phase = 0;
+	led_heartbeat_function(heartbeat_data->timer.data);
+	led_cdev->activated = true;
+}
+
+static void heartbeat_trig_deactivate(struct led_classdev *led_cdev)
+{
+	struct heartbeat_trig_data *heartbeat_data = led_cdev->trigger_data;
+
+	if (led_cdev->activated) {
+		del_timer_sync(&heartbeat_data->timer);
+		kfree(heartbeat_data);
+		led_cdev->activated = false;
+	}
+}
+
+static struct led_trigger heartbeat_led_trigger = {
+	.name     = "heartbeat",
+	.activate = heartbeat_trig_activate,
+	.deactivate = heartbeat_trig_deactivate,
+};
+
+static int heartbeat_reboot_notifier(struct notifier_block *nb,
+				     unsigned long code, void *unused)
+{
+	led_trigger_unregister(&heartbeat_led_trigger);
+	return NOTIFY_DONE;
+}
+
+static int heartbeat_panic_notifier(struct notifier_block *nb,
+				     unsigned long code, void *unused)
+{
+	panic_heartbeats = 1;
+	return NOTIFY_DONE;
+}
+
+static struct notifier_block heartbeat_reboot_nb = {
+	.notifier_call = heartbeat_reboot_notifier,
+};
+
+static struct notifier_block heartbeat_panic_nb = {
+	.notifier_call = heartbeat_panic_notifier,
+};
+
+static int __init heartbeat_trig_init(void)
+{
+	int rc = led_trigger_register(&heartbeat_led_trigger);
+
+	if (!rc) {
+		atomic_notifier_chain_register(&panic_notifier_list,
+					       &heartbeat_panic_nb);
+		register_reboot_notifier(&heartbeat_reboot_nb);
+	}
+	return rc;
+}
+
+static void __exit heartbeat_trig_exit(void)
+{
+	unregister_reboot_notifier(&heartbeat_reboot_nb);
+	atomic_notifier_chain_unregister(&panic_notifier_list,
+					 &heartbeat_panic_nb);
+	led_trigger_unregister(&heartbeat_led_trigger);
+}
+
+module_init(heartbeat_trig_init);
+module_exit(heartbeat_trig_exit);
+
+MODULE_AUTHOR("Atsushi Nemoto <anemo@mba.ocn.ne.jp>");
+MODULE_DESCRIPTION("Heartbeat LED trigger");
+MODULE_LICENSE("GPL");
diff --git a/drivers/leds/trigger/ledtrig-ide-disk.c b/drivers/leds/trigger/ledtrig-ide-disk.c
new file mode 100644
index 0000000..2cd7c0c
--- /dev/null
+++ b/drivers/leds/trigger/ledtrig-ide-disk.c
@@ -0,0 +1,47 @@
+/*
+ * LED IDE-Disk Activity Trigger
+ *
+ * Copyright 2006 Openedhand Ltd.
+ *
+ * Author: Richard Purdie <rpurdie@openedhand.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ */
+
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/leds.h>
+
+#define BLINK_DELAY 30
+
+DEFINE_LED_TRIGGER(ledtrig_ide);
+static unsigned long ide_blink_delay = BLINK_DELAY;
+
+void ledtrig_ide_activity(void)
+{
+	led_trigger_blink_oneshot(ledtrig_ide,
+				  &ide_blink_delay, &ide_blink_delay, 0);
+}
+EXPORT_SYMBOL(ledtrig_ide_activity);
+
+static int __init ledtrig_ide_init(void)
+{
+	led_trigger_register_simple("ide-disk", &ledtrig_ide);
+	return 0;
+}
+
+static void __exit ledtrig_ide_exit(void)
+{
+	led_trigger_unregister_simple(ledtrig_ide);
+}
+
+module_init(ledtrig_ide_init);
+module_exit(ledtrig_ide_exit);
+
+MODULE_AUTHOR("Richard Purdie <rpurdie@openedhand.com>");
+MODULE_DESCRIPTION("LED IDE Disk Activity Trigger");
+MODULE_LICENSE("GPL");
diff --git a/drivers/leds/trigger/ledtrig-oneshot.c b/drivers/leds/trigger/ledtrig-oneshot.c
new file mode 100644
index 0000000..cb4c746
--- /dev/null
+++ b/drivers/leds/trigger/ledtrig-oneshot.c
@@ -0,0 +1,204 @@
+/*
+ * One-shot LED Trigger
+ *
+ * Copyright 2012, Fabio Baltieri <fabio.baltieri@gmail.com>
+ *
+ * Based on ledtrig-timer.c by Richard Purdie <rpurdie@openedhand.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ */
+
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/device.h>
+#include <linux/ctype.h>
+#include <linux/slab.h>
+#include <linux/leds.h>
+#include "../leds.h"
+
+#define DEFAULT_DELAY 100
+
+struct oneshot_trig_data {
+	unsigned int invert;
+};
+
+static ssize_t led_shot(struct device *dev,
+		struct device_attribute *attr, const char *buf, size_t size)
+{
+	struct led_classdev *led_cdev = dev_get_drvdata(dev);
+	struct oneshot_trig_data *oneshot_data = led_cdev->trigger_data;
+
+	led_blink_set_oneshot(led_cdev,
+			&led_cdev->blink_delay_on, &led_cdev->blink_delay_off,
+			oneshot_data->invert);
+
+	/* content is ignored */
+	return size;
+}
+static ssize_t led_invert_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct led_classdev *led_cdev = dev_get_drvdata(dev);
+	struct oneshot_trig_data *oneshot_data = led_cdev->trigger_data;
+
+	return sprintf(buf, "%u\n", oneshot_data->invert);
+}
+
+static ssize_t led_invert_store(struct device *dev,
+		struct device_attribute *attr, const char *buf, size_t size)
+{
+	struct led_classdev *led_cdev = dev_get_drvdata(dev);
+	struct oneshot_trig_data *oneshot_data = led_cdev->trigger_data;
+	unsigned long state;
+	int ret;
+
+	ret = kstrtoul(buf, 0, &state);
+	if (ret)
+		return ret;
+
+	oneshot_data->invert = !!state;
+
+	if (oneshot_data->invert)
+		__led_set_brightness(led_cdev, LED_FULL);
+	else
+		__led_set_brightness(led_cdev, LED_OFF);
+
+	return size;
+}
+
+static ssize_t led_delay_on_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct led_classdev *led_cdev = dev_get_drvdata(dev);
+
+	return sprintf(buf, "%lu\n", led_cdev->blink_delay_on);
+}
+
+static ssize_t led_delay_on_store(struct device *dev,
+		struct device_attribute *attr, const char *buf, size_t size)
+{
+	struct led_classdev *led_cdev = dev_get_drvdata(dev);
+	unsigned long state;
+	int ret;
+
+	ret = kstrtoul(buf, 0, &state);
+	if (ret)
+		return ret;
+
+	led_cdev->blink_delay_on = state;
+
+	return size;
+}
+static ssize_t led_delay_off_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct led_classdev *led_cdev = dev_get_drvdata(dev);
+
+	return sprintf(buf, "%lu\n", led_cdev->blink_delay_off);
+}
+
+static ssize_t led_delay_off_store(struct device *dev,
+		struct device_attribute *attr, const char *buf, size_t size)
+{
+	struct led_classdev *led_cdev = dev_get_drvdata(dev);
+	unsigned long state;
+	int ret;
+
+	ret = kstrtoul(buf, 0, &state);
+	if (ret)
+		return ret;
+
+	led_cdev->blink_delay_off = state;
+
+	return size;
+}
+
+static DEVICE_ATTR(delay_on, 0644, led_delay_on_show, led_delay_on_store);
+static DEVICE_ATTR(delay_off, 0644, led_delay_off_show, led_delay_off_store);
+static DEVICE_ATTR(invert, 0644, led_invert_show, led_invert_store);
+static DEVICE_ATTR(shot, 0200, NULL, led_shot);
+
+static void oneshot_trig_activate(struct led_classdev *led_cdev)
+{
+	struct oneshot_trig_data *oneshot_data;
+	int rc;
+
+	oneshot_data = kzalloc(sizeof(*oneshot_data), GFP_KERNEL);
+	if (!oneshot_data)
+		return;
+
+	led_cdev->trigger_data = oneshot_data;
+
+	rc = device_create_file(led_cdev->dev, &dev_attr_delay_on);
+	if (rc)
+		goto err_out_trig_data;
+	rc = device_create_file(led_cdev->dev, &dev_attr_delay_off);
+	if (rc)
+		goto err_out_delayon;
+	rc = device_create_file(led_cdev->dev, &dev_attr_invert);
+	if (rc)
+		goto err_out_delayoff;
+	rc = device_create_file(led_cdev->dev, &dev_attr_shot);
+	if (rc)
+		goto err_out_invert;
+
+	led_cdev->blink_delay_on = DEFAULT_DELAY;
+	led_cdev->blink_delay_off = DEFAULT_DELAY;
+
+	led_cdev->activated = true;
+
+	return;
+
+err_out_invert:
+	device_remove_file(led_cdev->dev, &dev_attr_invert);
+err_out_delayoff:
+	device_remove_file(led_cdev->dev, &dev_attr_delay_off);
+err_out_delayon:
+	device_remove_file(led_cdev->dev, &dev_attr_delay_on);
+err_out_trig_data:
+	kfree(led_cdev->trigger_data);
+}
+
+static void oneshot_trig_deactivate(struct led_classdev *led_cdev)
+{
+	struct oneshot_trig_data *oneshot_data = led_cdev->trigger_data;
+
+	if (led_cdev->activated) {
+		device_remove_file(led_cdev->dev, &dev_attr_delay_on);
+		device_remove_file(led_cdev->dev, &dev_attr_delay_off);
+		device_remove_file(led_cdev->dev, &dev_attr_invert);
+		device_remove_file(led_cdev->dev, &dev_attr_shot);
+		kfree(oneshot_data);
+		led_cdev->activated = false;
+	}
+
+	/* Stop blinking */
+	led_set_brightness(led_cdev, LED_OFF);
+}
+
+static struct led_trigger oneshot_led_trigger = {
+	.name     = "oneshot",
+	.activate = oneshot_trig_activate,
+	.deactivate = oneshot_trig_deactivate,
+};
+
+static int __init oneshot_trig_init(void)
+{
+	return led_trigger_register(&oneshot_led_trigger);
+}
+
+static void __exit oneshot_trig_exit(void)
+{
+	led_trigger_unregister(&oneshot_led_trigger);
+}
+
+module_init(oneshot_trig_init);
+module_exit(oneshot_trig_exit);
+
+MODULE_AUTHOR("Fabio Baltieri <fabio.baltieri@gmail.com>");
+MODULE_DESCRIPTION("One-shot LED trigger");
+MODULE_LICENSE("GPL");
diff --git a/drivers/leds/trigger/ledtrig-timer.c b/drivers/leds/trigger/ledtrig-timer.c
new file mode 100644
index 0000000..8d09327
--- /dev/null
+++ b/drivers/leds/trigger/ledtrig-timer.c
@@ -0,0 +1,130 @@
+/*
+ * LED Kernel Timer Trigger
+ *
+ * Copyright 2005-2006 Openedhand Ltd.
+ *
+ * Author: Richard Purdie <rpurdie@openedhand.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ */
+
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/device.h>
+#include <linux/ctype.h>
+#include <linux/leds.h>
+
+static ssize_t led_delay_on_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct led_classdev *led_cdev = dev_get_drvdata(dev);
+
+	return sprintf(buf, "%lu\n", led_cdev->blink_delay_on);
+}
+
+static ssize_t led_delay_on_store(struct device *dev,
+		struct device_attribute *attr, const char *buf, size_t size)
+{
+	struct led_classdev *led_cdev = dev_get_drvdata(dev);
+	unsigned long state;
+	ssize_t ret = -EINVAL;
+
+	ret = kstrtoul(buf, 10, &state);
+	if (ret)
+		return ret;
+
+	led_blink_set(led_cdev, &state, &led_cdev->blink_delay_off);
+	led_cdev->blink_delay_on = state;
+
+	return size;
+}
+
+static ssize_t led_delay_off_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct led_classdev *led_cdev = dev_get_drvdata(dev);
+
+	return sprintf(buf, "%lu\n", led_cdev->blink_delay_off);
+}
+
+static ssize_t led_delay_off_store(struct device *dev,
+		struct device_attribute *attr, const char *buf, size_t size)
+{
+	struct led_classdev *led_cdev = dev_get_drvdata(dev);
+	unsigned long state;
+	ssize_t ret = -EINVAL;
+
+	ret = kstrtoul(buf, 10, &state);
+	if (ret)
+		return ret;
+
+	led_blink_set(led_cdev, &led_cdev->blink_delay_on, &state);
+	led_cdev->blink_delay_off = state;
+
+	return size;
+}
+
+static DEVICE_ATTR(delay_on, 0644, led_delay_on_show, led_delay_on_store);
+static DEVICE_ATTR(delay_off, 0644, led_delay_off_show, led_delay_off_store);
+
+static void timer_trig_activate(struct led_classdev *led_cdev)
+{
+	int rc;
+
+	led_cdev->trigger_data = NULL;
+
+	rc = device_create_file(led_cdev->dev, &dev_attr_delay_on);
+	if (rc)
+		return;
+	rc = device_create_file(led_cdev->dev, &dev_attr_delay_off);
+	if (rc)
+		goto err_out_delayon;
+
+	led_blink_set(led_cdev, &led_cdev->blink_delay_on,
+		      &led_cdev->blink_delay_off);
+	led_cdev->activated = true;
+
+	return;
+
+err_out_delayon:
+	device_remove_file(led_cdev->dev, &dev_attr_delay_on);
+}
+
+static void timer_trig_deactivate(struct led_classdev *led_cdev)
+{
+	if (led_cdev->activated) {
+		device_remove_file(led_cdev->dev, &dev_attr_delay_on);
+		device_remove_file(led_cdev->dev, &dev_attr_delay_off);
+		led_cdev->activated = false;
+	}
+
+	/* Stop blinking */
+	led_set_brightness(led_cdev, LED_OFF);
+}
+
+static struct led_trigger timer_led_trigger = {
+	.name     = "timer",
+	.activate = timer_trig_activate,
+	.deactivate = timer_trig_deactivate,
+};
+
+static int __init timer_trig_init(void)
+{
+	return led_trigger_register(&timer_led_trigger);
+}
+
+static void __exit timer_trig_exit(void)
+{
+	led_trigger_unregister(&timer_led_trigger);
+}
+
+module_init(timer_trig_init);
+module_exit(timer_trig_exit);
+
+MODULE_AUTHOR("Richard Purdie <rpurdie@openedhand.com>");
+MODULE_DESCRIPTION("Timer LED trigger");
+MODULE_LICENSE("GPL");
diff --git a/drivers/leds/trigger/ledtrig-transient.c b/drivers/leds/trigger/ledtrig-transient.c
new file mode 100644
index 0000000..e5abc00
--- /dev/null
+++ b/drivers/leds/trigger/ledtrig-transient.c
@@ -0,0 +1,237 @@
+/*
+ * LED Kernel Transient Trigger
+ *
+ * Copyright (C) 2012 Shuah Khan <shuahkhan@gmail.com>
+ *
+ * Based on Richard Purdie's ledtrig-timer.c and Atsushi Nemoto's
+ * ledtrig-heartbeat.c
+ * Design and use-case input from Jonas Bonn <jonas@southpole.se> and
+ * Neil Brown <neilb@suse.de>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ */
+/*
+ * Transient trigger allows one shot timer activation. Please refer to
+ * Documentation/leds/ledtrig-transient.txt for details
+*/
+
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/device.h>
+#include <linux/slab.h>
+#include <linux/timer.h>
+#include <linux/leds.h>
+#include "../leds.h"
+
+struct transient_trig_data {
+	int activate;
+	int state;
+	int restore_state;
+	unsigned long duration;
+	struct timer_list timer;
+};
+
+static void transient_timer_function(unsigned long data)
+{
+	struct led_classdev *led_cdev = (struct led_classdev *) data;
+	struct transient_trig_data *transient_data = led_cdev->trigger_data;
+
+	transient_data->activate = 0;
+	__led_set_brightness(led_cdev, transient_data->restore_state);
+}
+
+static ssize_t transient_activate_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct led_classdev *led_cdev = dev_get_drvdata(dev);
+	struct transient_trig_data *transient_data = led_cdev->trigger_data;
+
+	return sprintf(buf, "%d\n", transient_data->activate);
+}
+
+static ssize_t transient_activate_store(struct device *dev,
+		struct device_attribute *attr, const char *buf, size_t size)
+{
+	struct led_classdev *led_cdev = dev_get_drvdata(dev);
+	struct transient_trig_data *transient_data = led_cdev->trigger_data;
+	unsigned long state;
+	ssize_t ret;
+
+	ret = kstrtoul(buf, 10, &state);
+	if (ret)
+		return ret;
+
+	if (state != 1 && state != 0)
+		return -EINVAL;
+
+	/* cancel the running timer */
+	if (state == 0 && transient_data->activate == 1) {
+		del_timer(&transient_data->timer);
+		transient_data->activate = state;
+		__led_set_brightness(led_cdev, transient_data->restore_state);
+		return size;
+	}
+
+	/* start timer if there is no active timer */
+	if (state == 1 && transient_data->activate == 0 &&
+	    transient_data->duration != 0) {
+		transient_data->activate = state;
+		__led_set_brightness(led_cdev, transient_data->state);
+		transient_data->restore_state =
+		    (transient_data->state == LED_FULL) ? LED_OFF : LED_FULL;
+		mod_timer(&transient_data->timer,
+			  jiffies + transient_data->duration);
+	}
+
+	/* state == 0 && transient_data->activate == 0
+		timer is not active - just return */
+	/* state == 1 && transient_data->activate == 1
+		timer is already active - just return */
+
+	return size;
+}
+
+static ssize_t transient_duration_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct led_classdev *led_cdev = dev_get_drvdata(dev);
+	struct transient_trig_data *transient_data = led_cdev->trigger_data;
+
+	return sprintf(buf, "%lu\n", transient_data->duration);
+}
+
+static ssize_t transient_duration_store(struct device *dev,
+		struct device_attribute *attr, const char *buf, size_t size)
+{
+	struct led_classdev *led_cdev = dev_get_drvdata(dev);
+	struct transient_trig_data *transient_data = led_cdev->trigger_data;
+	unsigned long state;
+	ssize_t ret;
+
+	ret = kstrtoul(buf, 10, &state);
+	if (ret)
+		return ret;
+
+	transient_data->duration = state;
+	return size;
+}
+
+static ssize_t transient_state_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct led_classdev *led_cdev = dev_get_drvdata(dev);
+	struct transient_trig_data *transient_data = led_cdev->trigger_data;
+	int state;
+
+	state = (transient_data->state == LED_FULL) ? 1 : 0;
+	return sprintf(buf, "%d\n", state);
+}
+
+static ssize_t transient_state_store(struct device *dev,
+		struct device_attribute *attr, const char *buf, size_t size)
+{
+	struct led_classdev *led_cdev = dev_get_drvdata(dev);
+	struct transient_trig_data *transient_data = led_cdev->trigger_data;
+	unsigned long state;
+	ssize_t ret;
+
+	ret = kstrtoul(buf, 10, &state);
+	if (ret)
+		return ret;
+
+	if (state != 1 && state != 0)
+		return -EINVAL;
+
+	transient_data->state = (state == 1) ? LED_FULL : LED_OFF;
+	return size;
+}
+
+static DEVICE_ATTR(activate, 0644, transient_activate_show,
+		   transient_activate_store);
+static DEVICE_ATTR(duration, 0644, transient_duration_show,
+		   transient_duration_store);
+static DEVICE_ATTR(state, 0644, transient_state_show, transient_state_store);
+
+static void transient_trig_activate(struct led_classdev *led_cdev)
+{
+	int rc;
+	struct transient_trig_data *tdata;
+
+	tdata = kzalloc(sizeof(struct transient_trig_data), GFP_KERNEL);
+	if (!tdata) {
+		dev_err(led_cdev->dev,
+			"unable to allocate transient trigger\n");
+		return;
+	}
+	led_cdev->trigger_data = tdata;
+
+	rc = device_create_file(led_cdev->dev, &dev_attr_activate);
+	if (rc)
+		goto err_out;
+
+	rc = device_create_file(led_cdev->dev, &dev_attr_duration);
+	if (rc)
+		goto err_out_duration;
+
+	rc = device_create_file(led_cdev->dev, &dev_attr_state);
+	if (rc)
+		goto err_out_state;
+
+	setup_timer(&tdata->timer, transient_timer_function,
+		    (unsigned long) led_cdev);
+	led_cdev->activated = true;
+
+	return;
+
+err_out_state:
+	device_remove_file(led_cdev->dev, &dev_attr_duration);
+err_out_duration:
+	device_remove_file(led_cdev->dev, &dev_attr_activate);
+err_out:
+	dev_err(led_cdev->dev, "unable to register transient trigger\n");
+	led_cdev->trigger_data = NULL;
+	kfree(tdata);
+}
+
+static void transient_trig_deactivate(struct led_classdev *led_cdev)
+{
+	struct transient_trig_data *transient_data = led_cdev->trigger_data;
+
+	if (led_cdev->activated) {
+		del_timer_sync(&transient_data->timer);
+		__led_set_brightness(led_cdev, transient_data->restore_state);
+		device_remove_file(led_cdev->dev, &dev_attr_activate);
+		device_remove_file(led_cdev->dev, &dev_attr_duration);
+		device_remove_file(led_cdev->dev, &dev_attr_state);
+		led_cdev->trigger_data = NULL;
+		led_cdev->activated = false;
+		kfree(transient_data);
+	}
+}
+
+static struct led_trigger transient_trigger = {
+	.name     = "transient",
+	.activate = transient_trig_activate,
+	.deactivate = transient_trig_deactivate,
+};
+
+static int __init transient_trig_init(void)
+{
+	return led_trigger_register(&transient_trigger);
+}
+
+static void __exit transient_trig_exit(void)
+{
+	led_trigger_unregister(&transient_trigger);
+}
+
+module_init(transient_trig_init);
+module_exit(transient_trig_exit);
+
+MODULE_AUTHOR("Shuah Khan <shuahkhan@gmail.com>");
+MODULE_DESCRIPTION("Transient LED trigger");
+MODULE_LICENSE("GPL");
-- 
1.7.9.5


Best Regards,
Milo


