Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756504AbaAFVqz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 16:46:55 -0500
Received: from 173-195-60.141.tel-ott.com ([173.195.60.141]:34989 "EHLO kokopo"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756482AbaAFVqx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 16:46:53 -0500
From: lgxue@hotmail.com
To: cooloney@gmail.com, rpurdie@rpsys.net, rob@landley.net, milo.kim@ti.com,
        pavel@ucw.cz
Cc: Joe Xue <lgxue@hotmail.com>, linux-leds@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org
Subject: [PATCH v3 1/1] leds: Add LED pattern trigger
Date: Mon,  6 Jan 2014 16:47:14 -0500
Message-Id: <1389044834-22870-1-git-send-email-lgxue@hotmail.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1388362275-1618-1-git-send-email-lgxue@hotmail.com>
References: <1388362275-1618-1-git-send-email-lgxue@hotmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joe Xue <lgxue@hotmail.com>

The LED pattern trigger allows LEDs blink in user defined pattern.

v2: Change the pattern memory from fixed static to malloc
    Change the timer schedule way to save cpu time
    Add the mutex to protect the pattern operation

v3: Tiny fix, add the missed parameter in example of document

	new file:   Documentation/leds/ledtrig-pattern.txt
	modified:   drivers/leds/trigger/Kconfig
	modified:   drivers/leds/trigger/Makefile
	new file:   drivers/leds/trigger/ledtrig-pattern.c

Signed-off-by: Joe Xue <lgxue@hotmail.com>
---
 Documentation/leds/ledtrig-pattern.txt |  60 +++++++++
 drivers/leds/trigger/Kconfig           |   9 ++
 drivers/leds/trigger/Makefile          |   1 +
 drivers/leds/trigger/ledtrig-pattern.c | 233 +++++++++++++++++++++++++++++++++
 4 files changed, 303 insertions(+)
 create mode 100644 Documentation/leds/ledtrig-pattern.txt
 create mode 100644 drivers/leds/trigger/ledtrig-pattern.c

diff --git a/Documentation/leds/ledtrig-pattern.txt b/Documentation/leds/ledtrig-pattern.txt
new file mode 100644
index 0000000..ac0877c
--- /dev/null
+++ b/Documentation/leds/ledtrig-pattern.txt
@@ -0,0 +1,60 @@
+LED Pattern Trigger
+===================
+
+0. Introduction
+
+LED Pattern trigger is designed to let LEDs indicate the patterns defined by
+users. This is very useful for those scenarios where only one non-color led
+needs to indicate different states.
+
+1. How to use
+
+Pattern trigger can be enabled and disabled from user space on led class
+devices that support this trigger as shown below:
+
+     echo pattern > trigger
+
+When the pattern trigger is activated, it will get the current brightness as
+its brightness if the led is on. Otherwise, it will use the maximum brightness.
+
+If the led supports different values rather than ON/OFF, the brightness can be
+set in advance before enabling the trigger.
+
+     echo 128 > brightness
+     echo pattern > trigger
+
+Two properties are exported. They are delay_unit and pattern.
+
+     delay_unit - a delay time unit, default value is 125 ms
+     pattern    - blink pattern, includes three legal characters
+                  '#', ' '(space), and '/'
+                  '#' let LED on and last delay_unit long time
+                  ' ' let LED off and last delay_unit long time
+                  '/' stop pattern
+                      pattern will be repeated without it
+
+3. Examples
+
+     Example 1
+
+     echo pattern > trigger
+     echo "# ## /" > pattern
+
+     The behaviour is like below:
+
+     on(125ms)off(125ms)on(250ms)off
+     This is Morse code 'A'
+
+     Example 2
+
+     echo pattern > trigger
+     echo 200 > delay_unit
+     echo "# #    " > pattern
+
+     The behaviour is like below:
+
+     on(200ms)off(200ms)on(200ms)off(800ms)
+     on(200ms)off(200ms)on(200ms)off(800ms)
+     ...(Repeat)
+
+     This is 2 times burst blinking.
diff --git a/drivers/leds/trigger/Kconfig b/drivers/leds/trigger/Kconfig
index 49794b4..23d0967 100644
--- a/drivers/leds/trigger/Kconfig
+++ b/drivers/leds/trigger/Kconfig
@@ -108,4 +108,13 @@ config LEDS_TRIGGER_CAMERA
 	  This enables direct flash/torch on/off by the driver, kernel space.
 	  If unsure, say Y.
 
+config LEDS_TRIGGER_PATTERN
+	tristate "LED Pattern Trigger"
+	depends on LEDS_TRIGGERS
+	help
+	  This allows LEDs to blink in a user defined pattern controlled via
+          sysfs. It's useful to notify different states by using one led.
+	  For more details read Documentation/leds/leds-pattern.txt.
+	  If unsure, say Y.
+
 endif # LEDS_TRIGGERS
diff --git a/drivers/leds/trigger/Makefile b/drivers/leds/trigger/Makefile
index 1abf48d..a739429 100644
--- a/drivers/leds/trigger/Makefile
+++ b/drivers/leds/trigger/Makefile
@@ -8,3 +8,4 @@ obj-$(CONFIG_LEDS_TRIGGER_CPU)		+= ledtrig-cpu.o
 obj-$(CONFIG_LEDS_TRIGGER_DEFAULT_ON)	+= ledtrig-default-on.o
 obj-$(CONFIG_LEDS_TRIGGER_TRANSIENT)	+= ledtrig-transient.o
 obj-$(CONFIG_LEDS_TRIGGER_CAMERA)	+= ledtrig-camera.o
+obj-$(CONFIG_LEDS_TRIGGER_PATTERN)	+= ledtrig-pattern.o
diff --git a/drivers/leds/trigger/ledtrig-pattern.c b/drivers/leds/trigger/ledtrig-pattern.c
new file mode 100644
index 0000000..9c688e7
--- /dev/null
+++ b/drivers/leds/trigger/ledtrig-pattern.c
@@ -0,0 +1,233 @@
+/*
+ * LED Kernel Morse Code Trigger
+ *
+ * Copyright (C) 2013 Joe Xue <lgxue@hotmail.com>
+ *
+ * Based on Richard Purdie's ledtrig-timer.c and Atsushi Nemoto's
+ * ledtrig-heartbeat.c and Shuah Khan's ledtrig-transient.c
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
+#include <linux/slab.h>
+#include <linux/timer.h>
+#include <linux/leds.h>
+#include "../leds.h"
+
+struct pattern_trig_data {
+	unsigned long delay_unit;
+	unsigned long pattern_len;
+	unsigned long count;
+	int brightness_on;
+	char *pattern;
+	struct timer_list timer;
+	struct mutex pattern_mutex;
+};
+
+static void pattern_timer_function(unsigned long data)
+{
+	int repeat = 1;
+	struct led_classdev *led_cdev = (struct led_classdev *) data;
+	struct pattern_trig_data *pattern_data = led_cdev->trigger_data;
+	char this = pattern_data->pattern[pattern_data->count];
+
+	if (this == '#') {
+		__led_set_brightness(led_cdev, pattern_data->brightness_on);
+	} else if (this == ' ') {
+		__led_set_brightness(led_cdev, LED_OFF);
+	/* stop blinking */
+	} else if (this == '/') {
+		return;
+	}
+
+	while (pattern_data->pattern[pattern_data->count + repeat] == this)
+		repeat++;
+
+	mod_timer(&pattern_data->timer,
+		jiffies + msecs_to_jiffies(pattern_data->delay_unit * repeat));
+
+	pattern_data->count += repeat;
+	if (pattern_data->count == pattern_data->pattern_len)
+		pattern_data->count = 0;
+}
+
+static ssize_t pattern_delay_unit_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct led_classdev *led_cdev = dev_get_drvdata(dev);
+	struct pattern_trig_data *pattern_data = led_cdev->trigger_data;
+
+	return sprintf(buf, "%lu\n", pattern_data->delay_unit);
+}
+
+static ssize_t pattern_delay_unit_store(struct device *dev,
+		struct device_attribute *attr, const char *buf, size_t size)
+{
+	struct led_classdev *led_cdev = dev_get_drvdata(dev);
+	struct pattern_trig_data *pattern_data = led_cdev->trigger_data;
+	unsigned long state;
+	ssize_t ret = -EINVAL;
+
+	ret = kstrtoul(buf, 10, &state);
+	if (ret)
+		return ret;
+
+	/* this value can't be 0 */
+	if (state == 0)
+		return -EINVAL;
+
+	pattern_data->delay_unit = state;
+
+	return size;
+}
+
+static ssize_t pattern_pattern_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct led_classdev *led_cdev = dev_get_drvdata(dev);
+	struct pattern_trig_data *pattern_data = led_cdev->trigger_data;
+
+	if (pattern_data->pattern)
+		return scnprintf(buf, PAGE_SIZE, "%s\n",
+				pattern_data->pattern);
+	return 0;
+}
+
+static ssize_t pattern_pattern_store(struct device *dev,
+		struct device_attribute *attr, const char *buf, size_t size)
+{
+	struct led_classdev *led_cdev = dev_get_drvdata(dev);
+	struct pattern_trig_data *pattern_data = led_cdev->trigger_data;
+	int i, len;
+	ssize_t ret = -EINVAL;
+
+	len = 0;
+
+	/* legality check */
+	for (i = 0; i < size; i++) {
+		if (buf[i] != ' ' && buf[i] != '#' && buf[i] != '/')
+			break;
+		len++;
+	}
+
+	if (len == 0)
+		return ret;
+
+	mutex_lock(&pattern_data->pattern_mutex);
+	kfree(pattern_data->pattern);
+	pattern_data->pattern = NULL;
+
+	pattern_data->pattern = kzalloc(len + 1, GFP_KERNEL);
+	if (!pattern_data->pattern) {
+		len = -ENOMEM;
+		goto unlock;
+	}
+	scnprintf(pattern_data->pattern, len + 1, "%s", buf);
+
+	del_timer_sync(&pattern_data->timer);
+
+	pattern_data->pattern_len = len;
+	pattern_data->count = 0;
+
+	mod_timer(&pattern_data->timer, jiffies + 1);
+unlock:
+	mutex_unlock(&pattern_data->pattern_mutex);
+	return size;
+}
+
+static DEVICE_ATTR(pattern, 0644, pattern_pattern_show, pattern_pattern_store);
+static DEVICE_ATTR(delay_unit, 0644,
+		pattern_delay_unit_show, pattern_delay_unit_store);
+
+static void pattern_trig_activate(struct led_classdev *led_cdev)
+{
+	int rc;
+	struct pattern_trig_data *tdata;
+
+	tdata = kzalloc(sizeof(struct pattern_trig_data), GFP_KERNEL);
+	if (!tdata) {
+		dev_err(led_cdev->dev,
+			"unable to allocate pattern trigger\n");
+		return;
+	}
+
+	led_cdev->trigger_data = tdata;
+
+	mutex_init(&tdata->pattern_mutex);
+
+	rc = device_create_file(led_cdev->dev, &dev_attr_pattern);
+	if (rc)
+		goto err_out;
+
+	rc = device_create_file(led_cdev->dev, &dev_attr_delay_unit);
+	if (rc)
+		goto err_out_delay_unit;
+
+	/* default delay_unit 125ms */
+	tdata->delay_unit = 125;
+
+	setup_timer(&tdata->timer, pattern_timer_function,
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
+err_out_delay_unit:
+	device_remove_file(led_cdev->dev, &dev_attr_pattern);
+err_out:
+	dev_err(led_cdev->dev, "unable to register pattern trigger\n");
+	led_cdev->trigger_data = NULL;
+	kfree(tdata);
+}
+
+static void pattern_trig_deactivate(struct led_classdev *led_cdev)
+{
+	struct pattern_trig_data *pattern_data = led_cdev->trigger_data;
+
+	if (led_cdev->activated) {
+		del_timer_sync(&pattern_data->timer);
+		device_remove_file(led_cdev->dev, &dev_attr_pattern);
+		device_remove_file(led_cdev->dev, &dev_attr_delay_unit);
+		led_cdev->trigger_data = NULL;
+		led_cdev->activated = false;
+		kfree(pattern_data->pattern);
+		kfree(pattern_data);
+	}
+	__led_set_brightness(led_cdev, LED_OFF);
+}
+
+static struct led_trigger pattern_trigger = {
+	.name     = "pattern",
+	.activate = pattern_trig_activate,
+	.deactivate = pattern_trig_deactivate,
+};
+
+static int __init pattern_trig_init(void)
+{
+	return led_trigger_register(&pattern_trigger);
+}
+
+static void __exit pattern_trig_exit(void)
+{
+	led_trigger_unregister(&pattern_trigger);
+}
+
+module_init(pattern_trig_init);
+module_exit(pattern_trig_exit);
+
+MODULE_AUTHOR("Joe Xue <lgxue@hotmail.com");
+MODULE_DESCRIPTION("Pattern LED trigger");
+MODULE_LICENSE("GPL");
-- 
1.8.1.2

