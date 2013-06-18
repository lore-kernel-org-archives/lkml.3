Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933661Ab3FRVsG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 17:48:06 -0400
Received: from 11.mo3.mail-out.ovh.net ([87.98.184.158]:38226 "EHLO
	mo3.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933380Ab3FRVsD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 17:48:03 -0400
X-Greylist: delayed 17999 seconds by postgrey-1.27 at vger.kernel.org; Tue, 18 Jun 2013 17:48:02 EDT
From: =?UTF-8?q?Ga=C3=ABl=20PORTAY?= <g.portay@overkiz.com>
To: Rob Landley <rob@landley.net>, Bryan Wu <cooloney@gmail.com>,
        Richard Purdie <rpurdie@rpsys.net>,
        "Milo(Woogyom) Kim" <milo.kim@ti.com>
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-leds@vger.kernel.org,
        =?UTF-8?q?Ga=C3=ABl=20PORTAY?= <g.portay@overkiz.com>
X-Ovh-Mailout: 178.32.228.3 (mo3.mail-out.ovh.net)
Subject: [RFC PATCH] led: add Cycle LED trigger.
Date: Tue, 18 Jun 2013 18:24:23 +0200
Message-Id: <1371572663-10846-1-git-send-email-g.portay@overkiz.com>
X-Mailer: git-send-email 1.8.1.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Ovh-Tracer-Id: 9936066678116182882
X-Ovh-Remote: 80.245.18.66 ()
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiiedrieekucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiiedrieekucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, none of available triggers supports playing with the LED brightness
level.  The cycle trigger provides a way to define custom brightness cycle.
For example, it is easy to customize the cycle to mock up the rhythm of human
breathing which is a nice cycle to tell the user the system is doing something.

This trigger is meant to be usable for waiting an event to happen, for example
when the system gets ready.  Those cycles may be used to reflect well known
system status (e.g. idle mode, startup...).

This implementation provides several interfaces:
 - to define the cycle itself:
   * plot: definition of plot points using plot or rawplot files,
           each points defines the brightness level
   * interval: constant time interval between each plot point
 - to control the cycle:
   * repeat: the number of repetition of the whole plot cycle
             0 for an infinite loop
   * control: used to control the cycle trigger
     + "start"/"stop": to start/stop the cycle
     + "reset" to clear the cycle counter and the internal plot point index
     + "pause"/"resume" to pause/resume the cycle

Signed-off-by: Gaël PORTAY <g.portay@overkiz.com>
---
 Documentation/leds/ledtrig-cycle.txt |  92 +++++++
 drivers/leds/trigger/Kconfig         |  10 +
 drivers/leds/trigger/Makefile        |   1 +
 drivers/leds/trigger/ledtrig-cycle.c | 497 +++++++++++++++++++++++++++++++++++
 4 files changed, 600 insertions(+)
 create mode 100644 Documentation/leds/ledtrig-cycle.txt
 create mode 100644 drivers/leds/trigger/ledtrig-cycle.c

diff --git a/Documentation/leds/ledtrig-cycle.txt b/Documentation/leds/ledtrig-cycle.txt
new file mode 100644
index 0000000..63d6843
--- /dev/null
+++ b/Documentation/leds/ledtrig-cycle.txt
@@ -0,0 +1,92 @@
+Cycle LED Trigger
+=================
+
+This is a LED trigger useful for headless system where the LEDs are the only
+way to reflect system status.
+
+Currently, none of available triggers supports playing with the LED brightness
+level.  The cycle trigger provides a way to define custom brightness cycle.
+For example, it is easy to customize the cycle to mock up the rhythm of human
+breathing which is a nice cycle to tell the user the system is doing something.
+
+This trigger is meant to be usable for waiting an event to happen, for example
+when the system gets ready.  Those cycles may be used to reflect well known
+system status (e.g. idle mode, startup...).
+
+The application simply has to initialize some trigger parameters:
+ - the preset cycle (brightness plot),
+ - the constant interval of time between each brightness change and
+ - the number of repeat (0 for an infinite loop).
+Then, the application controls the life of the cycle using the commands below:
+ - "start"/"stop" to control the cycle,
+ - "reset" to clear the repeat counter,
+ - "pause"/"resume" to suspend or recover the cycle.
+
+The trigger can be activated from user space on led class devices as shown
+below:
+
+  echo cycle > trigger
+
+This adds the following sysfs attributes to the LED:
+
+  plot - specifies the brightness level cycle (from LED_OFF to LED_FULL).
+         Every values are separated by an end of line (0x0a).
+         Default is a triangular cycle from LED_FULL to LED_OFF and LED_OFF to
+         LED_FULL.
+
+  rawplot - same as plot except the plot are given in binary format (array of
+            bytes). Each bytes must be positive and range from LED_OFF to
+            LED_FULL.
+
+  interval - specifies the time elapsed between every brightness change.
+             This interval remains constant along the cycle unless a change
+             happened during the cycle execution.
+             Default to 100 ms.
+
+  repeat - specifies the number of cycles the trigger has to run.
+           Set the repeat value to 0 will let the led repeats the same cycle
+           till the end of time.
+           Default to 0.
+
+  count - get the current number of cycles. The counter is incrementing even
+          for an infinite loop.
+
+  control - tells the trigger what action to do.
+            "start" will start a new number of cycles from 0 to repeat.
+            "stop" will stop the cycle. The brightness level is left untouched
+            and the number of cycles is reset to 0.
+            "reset" will clear the number of cycles.
+            "pause"/"resume" will pause/resume the cycle.
+
+Cycle duration is determine by sizeof("plot") * "interval" ms.
+
+Example use-case: headless system initialization with network device.
+It runs the cycle till the device has received a IP from the DHCP server.
+
+  echo cycle > trigger   # set trigger for this led
+  echo 0 > repeat        # set loop forever
+  echo 50 > interval     # set 50 ms between each brightness change
+  cat << EOF > plot
+255
+254
+254
+253
+...
+2
+1
+1
+0
+EOF                      # customize the cycle with a smoother one (sinus)
+  echo start > control   # starts the cycle trigger
+
+dhcp lease bound or renewed: stop cycle and turn led on.
+
+  echo stop > control   # halt the cycle
+  echo 255 > brightness # and turn led on roughly
+or
+  echo 1 > count     # let the cycle to terminate
+  echo 10 > interval # and accelerate the end of cycle smoothly end the cycle
+
+dhcp lease lost or being renewed: restart cycle.
+
+  echo start > control
diff --git a/drivers/leds/trigger/Kconfig b/drivers/leds/trigger/Kconfig
index 49794b4..6646db7 100644
--- a/drivers/leds/trigger/Kconfig
+++ b/drivers/leds/trigger/Kconfig
@@ -59,6 +59,16 @@ config LEDS_TRIGGER_BACKLIGHT
 
 	  If unsure, say N.
 
+config LEDS_TRIGGER_CYCLE
+	tristate "LED Cycle Trigger"
+	depends on LEDS_TRIGGERS
+	help
+	  This allows LEDs to follow a cycle where the brightness level vary all
+	  along the cycle. This cycle can be set up and controlled using sysfs.
+	  For more details read Documentation/leds/ledtrig-cycle.txt.
+
+	  If unsure, say N.
+
 config LEDS_TRIGGER_CPU
 	bool "LED CPU Trigger"
 	depends on LEDS_TRIGGERS
diff --git a/drivers/leds/trigger/Makefile b/drivers/leds/trigger/Makefile
index 1abf48d..57a14a1 100644
--- a/drivers/leds/trigger/Makefile
+++ b/drivers/leds/trigger/Makefile
@@ -3,6 +3,7 @@ obj-$(CONFIG_LEDS_TRIGGER_ONESHOT)	+= ledtrig-oneshot.o
 obj-$(CONFIG_LEDS_TRIGGER_IDE_DISK)	+= ledtrig-ide-disk.o
 obj-$(CONFIG_LEDS_TRIGGER_HEARTBEAT)	+= ledtrig-heartbeat.o
 obj-$(CONFIG_LEDS_TRIGGER_BACKLIGHT)	+= ledtrig-backlight.o
+obj-$(CONFIG_LEDS_TRIGGER_CYCLE)		+= ledtrig-cycle.o
 obj-$(CONFIG_LEDS_TRIGGER_GPIO)		+= ledtrig-gpio.o
 obj-$(CONFIG_LEDS_TRIGGER_CPU)		+= ledtrig-cpu.o
 obj-$(CONFIG_LEDS_TRIGGER_DEFAULT_ON)	+= ledtrig-default-on.o
diff --git a/drivers/leds/trigger/ledtrig-cycle.c b/drivers/leds/trigger/ledtrig-cycle.c
new file mode 100644
index 0000000..a6a7b24
--- /dev/null
+++ b/drivers/leds/trigger/ledtrig-cycle.c
@@ -0,0 +1,497 @@
+/*
+ * LED Cycle Trigger
+ *
+ * Copyright (C) 2013 Gaël Portay <g.portay@overkiz.com>
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
+#include <linux/slab.h>
+#include <linux/sched.h>
+#include <linux/leds.h>
+#include <linux/hrtimer.h>
+#include <linux/string.h>
+
+#include "../leds.h"
+
+#define timer_to_cycle(timer) \
+	container_of(timer, struct cycle_trig_data, timer)
+
+#define DEFAULT_INVERVAL 10000000
+#define DEFAULT_COUNT 0
+#define DELIMITER 0x0a
+
+struct cycle_trig_data {
+	struct led_classdev *cdev;
+	spinlock_t lock;
+	struct hrtimer timer;
+	ktime_t interval;
+	unsigned int plot_index;
+	size_t plot_count;
+	u8 *plot;
+	unsigned int cycle_count;
+	unsigned int cycle_repeat;
+};
+
+static int cycle_start(struct cycle_trig_data *data)
+{
+	unsigned long flags;
+
+	if (hrtimer_active(&data->timer))
+		return -EINVAL;
+
+	spin_lock_irqsave(&data->lock, flags);
+	data->plot_index = 0;
+	data->cycle_count = 0;
+	hrtimer_start(&data->timer, ktime_get(), HRTIMER_MODE_ABS);
+	spin_unlock_irqrestore(&data->lock, flags);
+
+	return 1;
+}
+
+static int cycle_stop(struct cycle_trig_data *data)
+{
+	unsigned long flags;
+
+	if (!hrtimer_active(&data->timer))
+		return -EINVAL;
+
+	spin_lock_irqsave(&data->lock, flags);
+	data->plot_index = 0;
+	data->cycle_count = 0;
+	hrtimer_cancel(&data->timer);
+	spin_unlock_irqrestore(&data->lock, flags);
+
+	return 1;
+}
+
+static int cycle_reset(struct cycle_trig_data *data)
+{
+	data->plot_index = 0;
+	data->cycle_count = 0;
+
+	return 1;
+}
+
+static int cycle_pause(struct cycle_trig_data *data)
+{
+	unsigned long flags;
+
+	if (!hrtimer_active(&data->timer))
+		return -EINVAL;
+
+	spin_lock_irqsave(&data->lock, flags);
+	hrtimer_cancel(&data->timer);
+	spin_unlock_irqrestore(&data->lock, flags);
+
+	return 1;
+}
+
+static int cycle_resume(struct cycle_trig_data *data)
+{
+	unsigned long flags;
+
+	if (hrtimer_active(&data->timer))
+		return -EINVAL;
+
+	spin_lock_irqsave(&data->lock, flags);
+	hrtimer_start(&data->timer, ktime_get(), HRTIMER_MODE_ABS);
+	spin_unlock_irqrestore(&data->lock, flags);
+
+	return 1;
+}
+
+static enum hrtimer_restart led_cycle_function(struct hrtimer *timer)
+{
+	struct cycle_trig_data *data = timer_to_cycle(timer);
+	struct led_classdev *cdev = data->cdev;
+	enum hrtimer_restart ret = HRTIMER_RESTART;
+	unsigned long flags;
+
+	spin_lock_irqsave(&data->lock, flags);
+	if (data->plot) {
+		led_set_brightness(cdev, data->plot[data->plot_index]);
+		data->plot_index++;
+		if (data->plot_index >= data->plot_count) {
+			data->plot_index = 0;
+			data->cycle_count++;
+			if (data->cycle_repeat &&
+			    data->cycle_count >= data->cycle_repeat)
+				ret = HRTIMER_NORESTART;
+		}
+	}
+	spin_unlock_irqrestore(&data->lock, flags);
+
+	if (ret == HRTIMER_RESTART)
+		hrtimer_add_expires(timer, data->interval);
+
+	return ret;
+}
+
+static ssize_t cycle_status_show(struct device *dev,
+				 struct device_attribute *attr, char *buf)
+{
+	struct led_classdev *led_cdev = dev_get_drvdata(dev);
+	struct cycle_trig_data *data = led_cdev->trigger_data;
+
+	return snprintf(buf, PAGE_SIZE, "%sactive\n",
+			hrtimer_active(&data->timer) ? "" : "in");
+}
+
+static DEVICE_ATTR(status, 0444, cycle_status_show, NULL);
+
+static ssize_t cycle_control_store(struct device *dev,
+				    struct device_attribute *attr,
+				    const char *buf, size_t size)
+{
+	struct led_classdev *led_cdev = dev_get_drvdata(dev);
+	struct cycle_trig_data *data = led_cdev->trigger_data;
+
+	if (strncmp(buf, "start", sizeof("start") - 1) == 0)
+		cycle_start(data);
+	else if (strncmp(buf, "stop", sizeof("stop") - 1) == 0)
+		cycle_stop(data);
+	else if (strncmp(buf, "reset", sizeof("reset") - 1) == 0)
+		cycle_reset(data);
+	else if (strncmp(buf, "pause", sizeof("stop") - 1) == 0)
+		cycle_pause(data);
+	else if (strncmp(buf, "resume", sizeof("resume") - 1) == 0)
+		cycle_resume(data);
+	else
+		return -EINVAL;
+
+	return size;
+}
+
+static DEVICE_ATTR(control, 0200, NULL, cycle_control_store);
+
+static ssize_t cycle_repeat_show(struct device *dev,
+				struct device_attribute *attr, char *buf)
+{
+	struct led_classdev *led_cdev = dev_get_drvdata(dev);
+	struct cycle_trig_data *data = led_cdev->trigger_data;
+
+	return snprintf(buf, PAGE_SIZE, "%u\n", data->cycle_repeat);
+}
+
+static ssize_t cycle_repeat_store(struct device *dev,
+				 struct device_attribute *attr,
+				 const char *buf, size_t size)
+{
+	struct led_classdev *led_cdev = dev_get_drvdata(dev);
+	struct cycle_trig_data *data = led_cdev->trigger_data;
+	unsigned long count;
+	int err;
+
+	err = kstrtoul(buf, 0, &count);
+	if (err)
+		return -EINVAL;
+
+	data->cycle_repeat = count;
+
+	return size;
+}
+
+static DEVICE_ATTR(repeat, 0644, cycle_repeat_show, cycle_repeat_store);
+
+static ssize_t cycle_count_show(struct device *dev,
+				struct device_attribute *attr, char *buf)
+{
+	struct led_classdev *led_cdev = dev_get_drvdata(dev);
+	struct cycle_trig_data *data = led_cdev->trigger_data;
+
+	return snprintf(buf, PAGE_SIZE, "%d\n", data->cycle_count);
+}
+
+static DEVICE_ATTR(count, 0444, cycle_count_show, NULL);
+
+static ssize_t cycle_interval_show(struct device *dev,
+				   struct device_attribute *attr, char *buf)
+{
+	struct led_classdev *led_cdev = dev_get_drvdata(dev);
+	struct cycle_trig_data *data = led_cdev->trigger_data;
+	unsigned long interval = div_s64(ktime_to_ns(data->interval), 1000000);
+
+	return snprintf(buf, PAGE_SIZE, "%lu\n", interval);
+}
+
+static ssize_t cycle_interval_store(struct device *dev,
+				    struct device_attribute *attr,
+				    const char *buf, size_t size)
+{
+	struct led_classdev *led_cdev = dev_get_drvdata(dev);
+	struct cycle_trig_data *data = led_cdev->trigger_data;
+	unsigned long interval;
+	int err;
+
+	err = kstrtoul(buf, 0, &interval);
+	if (err)
+		return -EINVAL;
+
+	data->interval = ktime_set(interval / 1000,
+				   (interval % 1000) * 1000000);
+
+	return size;
+}
+
+static DEVICE_ATTR(interval, 0644, cycle_interval_show,
+		cycle_interval_store);
+
+static ssize_t cycle_rawplot_show(struct device *dev,
+				  struct device_attribute *attr, char *buf)
+{
+	struct led_classdev *led_cdev = dev_get_drvdata(dev);
+	struct cycle_trig_data *data = led_cdev->trigger_data;
+	unsigned long flags;
+
+	spin_lock_irqsave(&data->lock, flags);
+	if (data->plot)
+		memcpy(buf, data->plot, data->plot_count);
+	spin_unlock_irqrestore(&data->lock, flags);
+
+	return data->plot_count;
+}
+
+static ssize_t cycle_rawplot_store(struct device *dev,
+				   struct device_attribute *attr,
+				   const char *buf, size_t size)
+{
+	struct led_classdev *led_cdev = dev_get_drvdata(dev);
+	struct cycle_trig_data *data = led_cdev->trigger_data;
+	unsigned long flags;
+	u8 *plot;
+	u8 *oldplot = NULL;
+
+	plot = kzalloc(size, GFP_KERNEL);
+	if (plot) {
+		hrtimer_cancel(&data->timer);
+
+		memcpy(plot, buf, size);
+
+		spin_lock_irqsave(&data->lock, flags);
+		if (data->plot)
+			oldplot = data->plot;
+		data->plot = plot;
+		data->plot_index = 0;
+		data->plot_count = size;
+		spin_unlock_irqrestore(&data->lock, flags);
+
+		kfree(oldplot);
+
+		hrtimer_start(&data->timer, ktime_get(), HRTIMER_MODE_ABS);
+	} else
+		return -ENOMEM;
+
+	return data->plot_count;
+}
+
+static DEVICE_ATTR(rawplot, 0644, cycle_rawplot_show,
+		cycle_rawplot_store);
+
+static ssize_t cycle_plot_show(struct device *dev,
+			       struct device_attribute *attr, char *buf)
+{
+	struct led_classdev *led_cdev = dev_get_drvdata(dev);
+	struct cycle_trig_data *data = led_cdev->trigger_data;
+	unsigned long flags;
+	int i;
+	size_t size = 0;
+
+	spin_lock_irqsave(&data->lock, flags);
+	if (data->plot)
+		for (i = 0; i < data->plot_count; i++)
+			size += snprintf(&buf[size], PAGE_SIZE - size, "%u%c",
+					 data->plot[i], DELIMITER);
+	spin_unlock_irqrestore(&data->lock, flags);
+
+	return size;
+}
+
+static ssize_t cycle_plot_store(struct device *dev,
+				struct device_attribute *attr, const char *buf,
+				size_t size)
+{
+	struct led_classdev *led_cdev = dev_get_drvdata(dev);
+	struct cycle_trig_data *data = led_cdev->trigger_data;
+	unsigned long flags;
+	ssize_t count;
+	const char *del;
+
+	count = 0;
+	del = buf;
+	for (;;) {
+		del = strchr(del, DELIMITER);
+		if (!del)
+			break;
+		del++;
+		count++;
+	}
+
+	if (count) {
+		int i = 0;
+		char str[4];
+		const char *ptr;
+		u8 *oldplot = NULL;
+		u8 *plot = kzalloc(size, GFP_KERNEL);
+
+		if (!plot)
+			return -ENOMEM;
+
+		ptr = buf;
+		del = buf;
+		for (;;) {
+			int err;
+			unsigned long val = 0;
+
+			del = strchr(ptr, DELIMITER);
+			if (!del)
+				break;
+
+			err = (del - ptr);
+			if (err >= sizeof(str)) {
+				kfree(plot);
+				return -EINVAL;
+			}
+
+			strncpy(str, ptr, err);
+			str[err] = 0;
+			err = kstrtoul(str, 0, &val);
+			if (err || (val > LED_FULL)) {
+				kfree(plot);
+				return (err < 0) ? err : -EINVAL;
+			}
+
+			plot[i] = val;
+			ptr = del + 1;
+			i++;
+		}
+
+		hrtimer_cancel(&data->timer);
+
+		spin_lock_irqsave(&data->lock, flags);
+		if (data->plot)
+			oldplot = data->plot;
+		data->plot = plot;
+		data->plot_index = 0;
+		data->plot_count = count;
+		spin_unlock_irqrestore(&data->lock, flags);
+
+		kfree(oldplot);
+
+		hrtimer_start(&data->timer, ktime_get(), HRTIMER_MODE_ABS);
+	}
+
+	return size;
+}
+
+static DEVICE_ATTR(plot, 0644, cycle_plot_show,
+		cycle_plot_store);
+
+static void cycle_trig_activate(struct led_classdev *led_cdev)
+{
+	struct cycle_trig_data *data;
+
+	data = kzalloc(sizeof(struct cycle_trig_data), GFP_KERNEL);
+	if (!data)
+		return;
+
+	led_cdev->trigger_data = data;
+
+	spin_lock_init(&data->lock);
+
+	data->cdev = led_cdev;
+	data->interval = ktime_set(0, DEFAULT_INVERVAL);
+	data->cycle_count = 0;
+	data->cycle_repeat = DEFAULT_COUNT;
+
+	data->plot_index = 0;
+	data->plot_count = (LED_FULL * 2);
+	data->plot = kzalloc(data->plot_count, GFP_KERNEL);
+	if (data->plot) {
+		int i;
+		int val = LED_FULL;
+		int step = 1;
+		for (i = 0; i < data->plot_count; i++) {
+			data->plot[i] = val;
+			if (val == LED_FULL)
+				step = -1;
+			else if (val == LED_OFF)
+				step = 1;
+			val += step;
+		}
+
+		hrtimer_init(&data->timer, CLOCK_MONOTONIC, HRTIMER_MODE_ABS);
+		data->timer.function = led_cycle_function;
+	}
+
+	device_create_file(led_cdev->dev, &dev_attr_status);
+	device_create_file(led_cdev->dev, &dev_attr_control);
+	device_create_file(led_cdev->dev, &dev_attr_repeat);
+	device_create_file(led_cdev->dev, &dev_attr_count);
+	device_create_file(led_cdev->dev, &dev_attr_interval);
+	device_create_file(led_cdev->dev, &dev_attr_rawplot);
+	device_create_file(led_cdev->dev, &dev_attr_plot);
+}
+
+static void cycle_trig_deactivate(struct led_classdev *led_cdev)
+{
+	struct cycle_trig_data *data = led_cdev->trigger_data;
+	unsigned long flags;
+	u8 *plot;
+
+	device_remove_file(led_cdev->dev, &dev_attr_status);
+	device_remove_file(led_cdev->dev, &dev_attr_control);
+	device_remove_file(led_cdev->dev, &dev_attr_repeat);
+	device_remove_file(led_cdev->dev, &dev_attr_count);
+	device_remove_file(led_cdev->dev, &dev_attr_interval);
+	device_remove_file(led_cdev->dev, &dev_attr_rawplot);
+	device_remove_file(led_cdev->dev, &dev_attr_plot);
+
+	if (data) {
+		hrtimer_cancel(&data->timer);
+
+		spin_lock_irqsave(&data->lock, flags);
+		plot = data->plot;
+		if (data->plot) {
+			data->plot = NULL;
+			data->plot_index = 0;
+			data->plot_count = 0;
+		}
+		spin_unlock_irqrestore(&data->lock, flags);
+
+		kfree(plot);
+
+		kfree(data);
+	}
+}
+
+static struct led_trigger cycle_led_trigger = {
+	.name = "cycle",
+	.activate = cycle_trig_activate,
+	.deactivate = cycle_trig_deactivate,
+};
+
+static int __init cycle_trig_init(void)
+{
+	return led_trigger_register(&cycle_led_trigger);
+}
+
+static void __exit cycle_trig_exit(void)
+{
+	led_trigger_unregister(&cycle_led_trigger);
+}
+
+module_init(cycle_trig_init);
+module_exit(cycle_trig_exit);
+
+MODULE_AUTHOR("Gaël Portay <g.portay@overkiz.com>");
+MODULE_DESCRIPTION("Cycle LED trigger");
+MODULE_LICENSE("GPL");
-- 
1.8.1.2

