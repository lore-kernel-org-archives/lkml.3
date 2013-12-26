Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753451Ab3LZQA6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Dec 2013 11:00:58 -0500
Received: from 173-195-60.141.tel-ott.com ([173.195.60.141]:60233 "EHLO kokopo"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753399Ab3LZQA4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Dec 2013 11:00:56 -0500
From: lgxue@hotmail.com
To: cooloney@gmail.com, rpurdie@rpsys.net, rob@landley.net, milo.kim@ti.com
Cc: Joe Xue <lgxue@hotmail.com>, linux-leds@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        geert@linux-m68k.org, pavel@ucw.cz
Subject: [PATCH] Add the LED burst trigger
Date: Thu, 26 Dec 2013 11:01:13 -0500
Message-Id: <1388073673-30242-1-git-send-email-lgxue@hotmail.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joe Xue <lgxue@hotmail.com>

As per Geert's suggestion, change the HZ to Hz

Allow LEDs blink in burst mode. Three parameters are exported to
sysfs: freq, delay_off and times.

	new file:   Documentation/leds/ledtrig-burst.txt
	modified:   drivers/leds/trigger/Kconfig
	modified:   drivers/leds/trigger/Makefile
	new file:   drivers/leds/trigger/ledtrig-burst.c

Signed-off-by: Joe Xue <lgxue@hotmail.com>
---
 Documentation/leds/ledtrig-burst.txt |  58 ++++++++
 drivers/leds/trigger/Kconfig         |  10 ++
 drivers/leds/trigger/Makefile        |   1 +
 drivers/leds/trigger/ledtrig-burst.c | 250 +++++++++++++++++++++++++++++++++++
 4 files changed, 319 insertions(+)
 create mode 100644 Documentation/leds/ledtrig-burst.txt
 create mode 100644 drivers/leds/trigger/ledtrig-burst.c

diff --git a/Documentation/leds/ledtrig-burst.txt b/Documentation/leds/ledtrig-burst.txt
new file mode 100644
index 0000000..a6864e8
--- /dev/null
+++ b/Documentation/leds/ledtrig-burst.txt
@@ -0,0 +1,58 @@
+LED Burst Trigger
+=================
+
+0. Introduction
+
+Sometimes, the system has only one no-color led to indicate different stats.
+The LED timer trigger can let LEDs to blink in different frequency, but most
+people maybe just can discriminate two states, slow and fast.
+
+In this case, Morse code maybe is a good choice :-), but who can bear it.
+
+Besides the Morse code, another way is using burst mode. People can easily tell
+how many times the LED blinks in one cycle.
+
+Burst trigger is designed for this purpose.
+
+1. How to use
+
+Burst trigger can be enabled and disabled from user space on led class
+devices that support this trigger as shown below:
+
+     echo burst > trigger
+
+Three properties are exported. They are freq, times and delay_off.
+
+     freq      - the blink frequency, default value is 3 means 3Hz
+     times     - burst blink times in one cycle, no default value
+     delay_off - off time between two burst blinks, default value is 500 ms
+
+2. Case studies
+
+     Example 1
+
+     echo burst > trigger
+     echo 2 > times
+
+     The behaviour is like below:
+
+     on(1/6s)off(1/6s)on(1/6s)off(1/6m)
+     ...off 500ms...
+     on(1/6s)off(1/6s)on(1/3s)off(1/6m)
+     ...off 500ms
+     ...
+
+     Example 2
+
+     echo burst > trigger
+     echo 4 > freq
+     echo 3 > times
+     echo 1000 > delay_off
+
+     The behaviour is like below:
+
+     on(1/8s)off(1/8s)on(1/8s)off(1/8m)on(1/8s)off(1/8m)
+     ...off 1s...
+     on(1/8s)off(1/8s)on(1/8s)off(1/8m)on(1/8s)off(1/8m)
+     ...off 1s
+     ...
diff --git a/drivers/leds/trigger/Kconfig b/drivers/leds/trigger/Kconfig
index 49794b4..8f4ebbf 100644
--- a/drivers/leds/trigger/Kconfig
+++ b/drivers/leds/trigger/Kconfig
@@ -108,4 +108,14 @@ config LEDS_TRIGGER_CAMERA
 	  This enables direct flash/torch on/off by the driver, kernel space.
 	  If unsure, say Y.
 
+config LEDS_TRIGGER_BURST
+	tristate "LED Burst Trigger"
+	depends on LEDS_TRIGGERS
+	help
+	  This allows LEDs to blink in burst mode with parameters
+	  controlled via sysfs.  It's useful to notify different states
+	  by using one led.
+	  For more details read Documentation/leds/leds-burst.txt.
+	  If unsure, say Y.
+
 endif # LEDS_TRIGGERS
diff --git a/drivers/leds/trigger/Makefile b/drivers/leds/trigger/Makefile
index 1abf48d..6c48517 100644
--- a/drivers/leds/trigger/Makefile
+++ b/drivers/leds/trigger/Makefile
@@ -8,3 +8,4 @@ obj-$(CONFIG_LEDS_TRIGGER_CPU)		+= ledtrig-cpu.o
 obj-$(CONFIG_LEDS_TRIGGER_DEFAULT_ON)	+= ledtrig-default-on.o
 obj-$(CONFIG_LEDS_TRIGGER_TRANSIENT)	+= ledtrig-transient.o
 obj-$(CONFIG_LEDS_TRIGGER_CAMERA)	+= ledtrig-camera.o
+obj-$(CONFIG_LEDS_TRIGGER_BURST)	+= ledtrig-burst.o
diff --git a/drivers/leds/trigger/ledtrig-burst.c b/drivers/leds/trigger/ledtrig-burst.c
new file mode 100644
index 0000000..4ba097a
--- /dev/null
+++ b/drivers/leds/trigger/ledtrig-burst.c
@@ -0,0 +1,250 @@
+/*
+ * LED Kernel Burst Trigger
+ *
+ * Copyright (C) 2013 Joe Xue <lgxue@hotmail.com>
+ *
+ * Based on Richard Purdie's ledtrig-timer.c and Atsushi Nemoto's
+ * ledtrig-heartbeat.c and Shuah Khan's ledtrig-burst.c
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ */
+/*
+ * Burst trigger allows LEDs to blink in burst mode. The difference
+ * between burst trigger and timer trigger is timer trigger makes the
+ * LEDs blink continually in a frequency while burst trigger makes the
+ * LEDs blink some times in a special frequency then have a stop.
+ * Burst trigger allows LEDs to indicate different stats. Users can easy
+ * to describe it to support engineers by saying 3/4/5/X times burst
+ * blink.
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
+struct burst_trig_data {
+	int state;
+	unsigned long freq;
+	unsigned long times;
+	unsigned long count;
+	unsigned long delay_off;
+	int brightness_on;
+	struct timer_list timer;
+};
+
+static void burst_timer_function(unsigned long data)
+{
+	struct led_classdev *led_cdev = (struct led_classdev *) data;
+	struct burst_trig_data *burst_data = led_cdev->trigger_data;
+
+	if (burst_data->count > 0) {
+		/* revert the light state */
+		burst_data->state = 1 - burst_data->state;
+		__led_set_brightness(led_cdev,
+				burst_data->state*burst_data->brightness_on);
+		burst_data->count--;
+		/* the delay time for on and off are 1000/(freq*2) = 500/freq */
+		mod_timer(&burst_data->timer,
+			jiffies + msecs_to_jiffies(500/burst_data->freq));
+	} else {
+		burst_data->count = burst_data->times * 2;
+		mod_timer(&burst_data->timer,
+			jiffies + msecs_to_jiffies(burst_data->delay_off));
+	}
+}
+
+static ssize_t burst_delay_off_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct led_classdev *led_cdev = dev_get_drvdata(dev);
+	struct burst_trig_data *burst_data = led_cdev->trigger_data;
+
+	return sprintf(buf, "%lu\n", burst_data->delay_off);
+}
+
+static ssize_t burst_delay_off_store(struct device *dev,
+		struct device_attribute *attr, const char *buf, size_t size)
+{
+	struct led_classdev *led_cdev = dev_get_drvdata(dev);
+	struct burst_trig_data *burst_data = led_cdev->trigger_data;
+	unsigned long state;
+	ssize_t ret = -EINVAL;
+
+	ret = kstrtoul(buf, 10, &state);
+	if (ret)
+		return ret;
+
+	burst_data->delay_off = state;
+
+	return size;
+}
+
+static ssize_t burst_times_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct led_classdev *led_cdev = dev_get_drvdata(dev);
+	struct burst_trig_data *burst_data = led_cdev->trigger_data;
+
+	return sprintf(buf, "%lu\n", burst_data->times);
+}
+
+static ssize_t burst_times_store(struct device *dev,
+		struct device_attribute *attr, const char *buf, size_t size)
+{
+	struct led_classdev *led_cdev = dev_get_drvdata(dev);
+	struct burst_trig_data *burst_data = led_cdev->trigger_data;
+	unsigned long state;
+	ssize_t ret = -EINVAL;
+
+	ret = kstrtoul(buf, 10, &state);
+	if (ret)
+		return ret;
+
+	/* if the times is larger then 0 then use it else stop burst */
+	if (state > 0) {
+		burst_data->times = state;
+		burst_data->count = state*2;
+		del_timer_sync(&burst_data->timer);
+		mod_timer(&burst_data->timer, jiffies + 1);
+	} else {
+		del_timer_sync(&burst_data->timer);
+	}
+
+	return size;
+}
+
+static ssize_t burst_freq_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct led_classdev *led_cdev = dev_get_drvdata(dev);
+	struct burst_trig_data *burst_data = led_cdev->trigger_data;
+
+	return sprintf(buf, "%lu\n", burst_data->freq);
+}
+
+static ssize_t burst_freq_store(struct device *dev,
+		struct device_attribute *attr, const char *buf, size_t size)
+{
+	struct led_classdev *led_cdev = dev_get_drvdata(dev);
+	struct burst_trig_data *burst_data = led_cdev->trigger_data;
+	unsigned long state;
+	ssize_t ret = -EINVAL;
+
+	ret = kstrtoul(buf, 10, &state);
+	if (ret)
+		return ret;
+
+	/* the frequency can not be 0 */
+	if (state == 0)
+		return -EINVAL;
+
+	burst_data->freq = state;
+
+	return size;
+}
+
+static DEVICE_ATTR(freq, 0644, burst_freq_show, burst_freq_store);
+static DEVICE_ATTR(times, 0644, burst_times_show, burst_times_store);
+static DEVICE_ATTR(delay_off, 0644,
+		burst_delay_off_show, burst_delay_off_store);
+
+static void burst_trig_activate(struct led_classdev *led_cdev)
+{
+	int rc;
+	struct burst_trig_data *tdata;
+
+	tdata = kzalloc(sizeof(struct burst_trig_data), GFP_KERNEL);
+	if (!tdata) {
+		dev_err(led_cdev->dev,
+			"unable to allocate burst trigger\n");
+		return;
+	}
+	/* default frequency 3Hz */
+	tdata->freq = 3;
+	/* default delay_off 500ms */
+	tdata->delay_off = 500;
+
+	tdata->state = 0;
+
+	led_cdev->trigger_data = tdata;
+
+	rc = device_create_file(led_cdev->dev, &dev_attr_freq);
+	if (rc)
+		goto err_out;
+
+	rc = device_create_file(led_cdev->dev, &dev_attr_times);
+	if (rc)
+		goto err_out_times;
+
+	rc = device_create_file(led_cdev->dev, &dev_attr_delay_off);
+	if (rc)
+		goto err_out_delay_off;
+
+	setup_timer(&tdata->timer, burst_timer_function,
+		    (unsigned long) led_cdev);
+
+	tdata->brightness_on = led_get_brightness(led_cdev);
+	if (tdata->brightness_on == LED_OFF)
+		tdata->brightness_on = led_cdev->max_brightness;
+
+	__led_set_brightness(led_cdev, LED_OFF);
+	led_cdev->activated = true;
+
+	return;
+
+err_out_delay_off:
+	device_remove_file(led_cdev->dev, &dev_attr_times);
+err_out_times:
+	device_remove_file(led_cdev->dev, &dev_attr_freq);
+err_out:
+	dev_err(led_cdev->dev, "unable to register burst trigger\n");
+	led_cdev->trigger_data = NULL;
+	kfree(tdata);
+}
+
+static void burst_trig_deactivate(struct led_classdev *led_cdev)
+{
+	struct burst_trig_data *burst_data = led_cdev->trigger_data;
+
+	if (led_cdev->activated) {
+		del_timer_sync(&burst_data->timer);
+		device_remove_file(led_cdev->dev, &dev_attr_freq);
+		device_remove_file(led_cdev->dev, &dev_attr_times);
+		device_remove_file(led_cdev->dev, &dev_attr_delay_off);
+		led_cdev->trigger_data = NULL;
+		led_cdev->activated = false;
+		kfree(burst_data);
+	}
+	__led_set_brightness(led_cdev, LED_OFF);
+}
+
+static struct led_trigger burst_trigger = {
+	.name     = "burst",
+	.activate = burst_trig_activate,
+	.deactivate = burst_trig_deactivate,
+};
+
+static int __init burst_trig_init(void)
+{
+	return led_trigger_register(&burst_trigger);
+}
+
+static void __exit burst_trig_exit(void)
+{
+	led_trigger_unregister(&burst_trigger);
+}
+
+module_init(burst_trig_init);
+module_exit(burst_trig_exit);
+
+MODULE_AUTHOR("Joe Xue <lgxue@hotmail.com");
+MODULE_DESCRIPTION("Burst LED trigger");
+MODULE_LICENSE("GPL");
-- 
1.8.1.2

