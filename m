Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753022Ab3L3AUT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Dec 2013 19:20:19 -0500
Received: from blu0-omc1-s37.blu0.hotmail.com ([65.55.116.48]:6001 "EHLO
	blu0-omc1-s37.blu0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752749Ab3L3AUR convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Dec 2013 19:20:17 -0500
X-Greylist: delayed 306 seconds by postgrey-1.27 at vger.kernel.org; Sun, 29 Dec 2013 19:20:16 EST
X-TMN: [m/6kuR+lcsIlN0VDN75K9y6JNth5ymmP]
X-Originating-Email: [lgxue@hotmail.com]
Message-ID: <BLU172-W26BE6B46CC3228F885CCAAACCE0@phx.gbl>
From: Joe Xue <lgxue@hotmail.com>
To: "cooloney@gmail.com" <cooloney@gmail.com>,
        "rpurdie@rpsys.net" <rpurdie@rpsys.net>,
        "rob@landley.net" <rob@landley.net>,
        "milo.kim@ti.com" <milo.kim@ti.com>
CC: "linux-leds@vger.kernel.org" <linux-leds@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>
Subject: RE: [PATCH] Add the LED burst trigger
Date: Sun, 29 Dec 2013 19:15:09 -0500
Importance: Normal
In-Reply-To: <1387895407-28031-1-git-send-email-lgxue@hotmail.com>
References: <1387895407-28031-1-git-send-email-lgxue@hotmail.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginalArrivalTime: 30 Dec 2013 00:15:09.0681 (UTC) FILETIME=[33558E10:01CF04F4]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All, I have finished the pattern trigger and submitted it. For your convince to discuss, I also put it here.

Joe 

The LED pattern trigger allows LEDs blink in user defined pattern.

    new file:   Documentation/leds/ledtrig-pattern.txt
    modified:   drivers/leds/trigger/Kconfig
    modified:   drivers/leds/trigger/Makefile
    new file:   drivers/leds/trigger/ledtrig-pattern.c

Suggested-by: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Joe Xue <lgxue@hotmail.com>
---
 Documentation/leds/ledtrig-pattern.txt |  60 ++++++++++
 drivers/leds/trigger/Kconfig           |   9 ++
 drivers/leds/trigger/Makefile          |   1 +
 drivers/leds/trigger/ledtrig-pattern.c | 207 +++++++++++++++++++++++++++++++++
 4 files changed, 277 insertions(+)
 create mode 100644 Documentation/leds/ledtrig-pattern.txt
 create mode 100644 drivers/leds/trigger/ledtrig-pattern.c

diff --git a/Documentation/leds/ledtrig-pattern.txt b/Documentation/leds/ledtrig-pattern.txt
new file mode 100644
index 0000000..4b546c3
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
+     echo pattern> trigger
+
+When the pattern trigger is activated, it will get the current brightness as
+its brightness if the led is on. Otherwise, it will use the maximum brightness.
+
+If the led supports different values rather than ON/OFF, the brightness can be
+set in advance before enabling the trigger.
+
+     echo 128> brightness
+     echo pattern> trigger
+
+Two properties are exported. They are delay_unit and pattern.
+
+     delay_unit - a delay time unit, default value is 125 ms
+     pattern    - blink pattern, includes three legal characters
+                  '#', ' '(space), and '/'
+                  '#' let LED on and last delay_unit long time
+                  ' ' let LED off and last delay_unit long time
+                  '/' stop pattern
+                      pattern will be repeated without it
+
+3. Examples
+
+     Example 1
+
+     echo pattern> trigger
+     echo "# ## /"
+
+     The behaviour is like below:
+
+     on(125ms)off(125ms)on(250ms)off
+     This is Morse code 'A'
+
+     Example 2
+
+     echo pattern> trigger
+     echo 200> delay_unit
+     echo "# #    "
+
+     The behaviour is like below:
+
+     on(200ms)off(200ms)on(200ms)off(800ms)
+     on(200ms)off(200ms)on(200ms)off(800ms)
+     ...(Repeat)
+
+     This is 2 times burst blinking.
diff --git a/drivers/leds/trigger/Kconfig b/drivers/leds/trigger/Kconfig
index 49794b4..23d0967 100644
--- a/drivers/leds/trigger/Kconfig
+++ b/drivers/leds/trigger/Kconfig
@@ -108,4 +108,13 @@ config LEDS_TRIGGER_CAMERA
       This enables direct flash/torch on/off by the driver, kernel space.
       If unsure, say Y.
 
+config LEDS_TRIGGER_PATTERN
+    tristate "LED Pattern Trigger"
+    depends on LEDS_TRIGGERS
+    help
+      This allows LEDs to blink in a user defined pattern controlled via
+          sysfs. It's useful to notify different states by using one led.
+      For more details read Documentation/leds/leds-pattern.txt.
+      If unsure, say Y.
+
 endif # LEDS_TRIGGERS
diff --git a/drivers/leds/trigger/Makefile b/drivers/leds/trigger/Makefile
index 1abf48d..a739429 100644
--- a/drivers/leds/trigger/Makefile
+++ b/drivers/leds/trigger/Makefile
@@ -8,3 +8,4 @@ obj-$(CONFIG_LEDS_TRIGGER_CPU)        += ledtrig-cpu.o
 obj-$(CONFIG_LEDS_TRIGGER_DEFAULT_ON)    += ledtrig-default-on.o
 obj-$(CONFIG_LEDS_TRIGGER_TRANSIENT)    += ledtrig-transient.o
 obj-$(CONFIG_LEDS_TRIGGER_CAMERA)    += ledtrig-camera.o
+obj-$(CONFIG_LEDS_TRIGGER_PATTERN)    += ledtrig-pattern.o
diff --git a/drivers/leds/trigger/ledtrig-pattern.c b/drivers/leds/trigger/ledtrig-pattern.c
new file mode 100644
index 0000000..80fc238
--- /dev/null
+++ b/drivers/leds/trigger/ledtrig-pattern.c
@@ -0,0 +1,207 @@
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
+#define MAX_PATTEN_LEN    255
+
+struct pattern_trig_data {
+    unsigned long delay_unit;
+    unsigned long pattern_len;
+    unsigned long count;
+    int brightness_on;
+    char pattern[MAX_PATTEN_LEN + 1];
+    struct timer_list timer;
+};
+
+static void pattern_timer_function(unsigned long data)
+{
+    struct led_classdev *led_cdev = (struct led_classdev *) data;
+    struct pattern_trig_data *pattern_data = led_cdev->trigger_data;
+
+    if (pattern_data->pattern[pattern_data->count] == '#') {
+        __led_set_brightness(led_cdev, pattern_data->brightness_on);
+        mod_timer(&pattern_data->timer,
+            jiffies + msecs_to_jiffies(pattern_data->delay_unit));
+    } else if (pattern_data->pattern[pattern_data->count] == ' ') {
+        __led_set_brightness(led_cdev, LED_OFF);
+        mod_timer(&pattern_data->timer,
+            jiffies + msecs_to_jiffies(pattern_data->delay_unit));
+    /* stop blinking */
+    } else if (pattern_data->pattern[pattern_data->count] == '/') {
+        return;
+    }
+
+    pattern_data->count++;
+    if (pattern_data->count == pattern_data->pattern_len)
+        pattern_data->count = 0;
+}
+
+static ssize_t pattern_delay_unit_show(struct device *dev,
+        struct device_attribute *attr, char *buf)
+{
+    struct led_classdev *led_cdev = dev_get_drvdata(dev);
+    struct pattern_trig_data *pattern_data = led_cdev->trigger_data;
+
+    return sprintf(buf, "%lu\n", pattern_data->delay_unit);
+}
+
+static ssize_t pattern_delay_unit_store(struct device *dev,
+        struct device_attribute *attr, const char *buf, size_t size)
+{
+    struct led_classdev *led_cdev = dev_get_drvdata(dev);
+    struct pattern_trig_data *pattern_data = led_cdev->trigger_data;
+    unsigned long state;
+    ssize_t ret = -EINVAL;
+
+    ret = kstrtoul(buf, 10, &state);
+    if (ret)
+        return ret;
+
+    pattern_data->delay_unit = state;
+
+    return size;
+}
+
+static ssize_t pattern_pattern_show(struct device *dev,
+        struct device_attribute *attr, char *buf)
+{
+    struct led_classdev *led_cdev = dev_get_drvdata(dev);
+    struct pattern_trig_data *pattern_data = led_cdev->trigger_data;
+
+    return sprintf(buf, "%s\n", pattern_data->pattern);
+}
+
+static ssize_t pattern_pattern_store(struct device *dev,
+        struct device_attribute *attr, const char *buf, size_t size)
+{
+    struct led_classdev *led_cdev = dev_get_drvdata(dev);
+    struct pattern_trig_data *pattern_data = led_cdev->trigger_data;
+    int i;
+    ssize_t ret = -EINVAL;
+
+    int len = (size> MAX_PATTEN_LEN) ? MAX_PATTEN_LEN : (size - 1);
+
+    /* legality check */
+    for (i = 0; i < len; i++) {
+        if (buf[i] != ' ' && buf[i] != '#' && buf[i] != '/')
+            return ret;
+    }
+
+    del_timer_sync(&pattern_data->timer);
+
+    memcpy(pattern_data->pattern, buf, len);
+    pattern_data->pattern[len] = '\0';
+    pattern_data->pattern_len = len;
+    pattern_data->count = 0;
+
+    mod_timer(&pattern_data->timer, jiffies + 1);
+
+    return size;
+}
+
+static DEVICE_ATTR(pattern, 0644, pattern_pattern_show, pattern_pattern_store);
+static DEVICE_ATTR(delay_unit, 0644,
+        pattern_delay_unit_show, pattern_delay_unit_store);
+
+static void pattern_trig_activate(struct led_classdev *led_cdev)
+{
+    int rc;
+    struct pattern_trig_data *tdata;
+
+    tdata = kzalloc(sizeof(struct pattern_trig_data), GFP_KERNEL);
+    if (!tdata) {
+        dev_err(led_cdev->dev,
+            "unable to allocate pattern trigger\n");
+        return;
+    }
+
+    led_cdev->trigger_data = tdata;
+
+    rc = device_create_file(led_cdev->dev, &dev_attr_pattern);
+    if (rc)
+        goto err_out;
+
+    rc = device_create_file(led_cdev->dev, &dev_attr_delay_unit);
+    if (rc)
+        goto err_out_delay_unit;
+
+    memset(tdata->pattern, 0, MAX_PATTEN_LEN + 1);
+    /* default delay_unit 125ms */
+    tdata->delay_unit = 125;
+
+    setup_timer(&tdata->timer, pattern_timer_function,
+            (unsigned long) led_cdev);
+
+    tdata->brightness_on = led_get_brightness(led_cdev);
+    if (tdata->brightness_on == LED_OFF)
+        tdata->brightness_on = led_cdev->max_brightness;
+
+    __led_set_brightness(led_cdev, LED_OFF);
+    led_cdev->activated = true;
+
+    return;
+
+err_out_delay_unit:
+    device_remove_file(led_cdev->dev, &dev_attr_pattern);
+err_out:
+    dev_err(led_cdev->dev, "unable to register pattern trigger\n");
+    led_cdev->trigger_data = NULL;
+    kfree(tdata);
+}
+
+static void pattern_trig_deactivate(struct led_classdev *led_cdev)
+{
+    struct pattern_trig_data *pattern_data = led_cdev->trigger_data;
+
+    if (led_cdev->activated) {
+        del_timer_sync(&pattern_data->timer);
+        device_remove_file(led_cdev->dev, &dev_attr_pattern);
+        device_remove_file(led_cdev->dev, &dev_attr_delay_unit);
+        led_cdev->trigger_data = NULL;
+        led_cdev->activated = false;
+        kfree(pattern_data);
+    }
+    __led_set_brightness(led_cdev, LED_OFF);
+}
+
+static struct led_trigger pattern_trigger = {
+    .name     = "pattern",
+    .activate = pattern_trig_activate,
+    .deactivate = pattern_trig_deactivate,
+};
+
+static int __init pattern_trig_init(void)
+{
+    return led_trigger_register(&pattern_trigger);
+}
+
+static void __exit pattern_trig_exit(void)
+{
+    led_trigger_unregister(&pattern_trigger);
+}
+
+module_init(pattern_trig_init);
+module_exit(pattern_trig_exit);
+
+MODULE_AUTHOR("Joe Xue <lgxue@hotmail.com");
+MODULE_DESCRIPTION("Patten LED trigger");
+MODULE_LICENSE("GPL");
-- 
1.8.1.2

----------------------------------------
> From: lgxue@hotmail.com
> To: cooloney@gmail.com; rpurdie@rpsys.net; rob@landley.net; milo.kim@ti.com
> CC: lgxue@hotmail.com; linux-leds@vger.kernel.org; linux-kernel@vger.kernel.org; linux-doc@vger.kernel.org
> Subject: [PATCH] Add the LED burst trigger
> Date: Tue, 24 Dec 2013 09:30:07 -0500
>
> From: Joe Xue <lgxue@hotmail.com>
>
> Allow LEDs blink in burst mode. Three parameters are exported to
> sysfs: freq, delay_off and times.
>
> new file: Documentation/leds/ledtrig-burst.txt
> modified: drivers/leds/trigger/Kconfig
> modified: drivers/leds/trigger/Makefile
> new file: drivers/leds/trigger/ledtrig-burst.c
>
> Signed-off-by: Joe Xue <lgxue@hotmail.com>
> ---
> Documentation/leds/ledtrig-burst.txt | 58 ++++++++
> drivers/leds/trigger/Kconfig | 10 ++
> drivers/leds/trigger/Makefile | 1 +
> drivers/leds/trigger/ledtrig-burst.c | 250 +++++++++++++++++++++++++++++++++++
> 4 files changed, 319 insertions(+)
> create mode 100644 Documentation/leds/ledtrig-burst.txt
> create mode 100644 drivers/leds/trigger/ledtrig-burst.c
>
> diff --git a/Documentation/leds/ledtrig-burst.txt b/Documentation/leds/ledtrig-burst.txt
> new file mode 100644
> index 0000000..50a7955
> --- /dev/null
> +++ b/Documentation/leds/ledtrig-burst.txt
> @@ -0,0 +1,58 @@
> +LED Burst Trigger
> +=================
> +
> +0. Introduction
> +
> +Sometimes, the system has only one no-color led to indicate different stats.
> +The LED timer trigger can let LEDs to blink in different frequency, but most
> +people maybe just can discriminate two states, slow and fast.
> +
> +In this case, Morse code maybe is a good choice :-), but who can bear it.
> +
> +Besides the Morse code, another way is using burst mode. People can easily tell
> +how many times the LED blinks in one cycle.
> +
> +Burst trigger is designed for this purpose.
> +
> +1. How to use
> +
> +Burst trigger can be enabled and disabled from user space on led class
> +devices that support this trigger as shown below:
> +
> + echo burst> trigger
> +
> +Three properties are exported. They are freq, times and delay_off.
> +
> + freq - the blink frequency, default value is 3 means 3HZ
> + times - burst blink times in one cycle, no default value
> + delay_off - off time between two burst blinks, default value is 500 ms
> +
> +2. Case studies
> +
> + Example 1
> +
> + echo burst> trigger
> + echo 2> times
> +
> + The behaviour is like below:
> +
> + on(1/6s)off(1/6s)on(1/6s)off(1/6m)
> + ...off 500ms...
> + on(1/6s)off(1/6s)on(1/3s)off(1/6m)
> + ...off 500ms
> + ...
> +
> + Example 2
> +
> + echo burst> trigger
> + echo 4> freq
> + echo 3> times
> + echo 1000> delay_off
> +
> + The behaviour is like below:
> +
> + on(1/8s)off(1/8s)on(1/8s)off(1/8m)on(1/8s)off(1/8m)
> + ...off 1s...
> + on(1/8s)off(1/8s)on(1/8s)off(1/8m)on(1/8s)off(1/8m)
> + ...off 1s
> + ...
> diff --git a/drivers/leds/trigger/Kconfig b/drivers/leds/trigger/Kconfig
> index 49794b4..8f4ebbf 100644
> --- a/drivers/leds/trigger/Kconfig
> +++ b/drivers/leds/trigger/Kconfig
> @@ -108,4 +108,14 @@ config LEDS_TRIGGER_CAMERA
> This enables direct flash/torch on/off by the driver, kernel space.
> If unsure, say Y.
>
> +config LEDS_TRIGGER_BURST
> + tristate "LED Burst Trigger"
> + depends on LEDS_TRIGGERS
> + help
> + This allows LEDs to blink in burst mode with parameters
> + controlled via sysfs. It's useful to notify different states
> + by using one led.
> + For more details read Documentation/leds/leds-burst.txt.
> + If unsure, say Y.
> +
> endif # LEDS_TRIGGERS
> diff --git a/drivers/leds/trigger/Makefile b/drivers/leds/trigger/Makefile
> index 1abf48d..6c48517 100644
> --- a/drivers/leds/trigger/Makefile
> +++ b/drivers/leds/trigger/Makefile
> @@ -8,3 +8,4 @@ obj-$(CONFIG_LEDS_TRIGGER_CPU) += ledtrig-cpu.o
> obj-$(CONFIG_LEDS_TRIGGER_DEFAULT_ON) += ledtrig-default-on.o
> obj-$(CONFIG_LEDS_TRIGGER_TRANSIENT) += ledtrig-transient.o
> obj-$(CONFIG_LEDS_TRIGGER_CAMERA) += ledtrig-camera.o
> +obj-$(CONFIG_LEDS_TRIGGER_BURST) += ledtrig-burst.o
> diff --git a/drivers/leds/trigger/ledtrig-burst.c b/drivers/leds/trigger/ledtrig-burst.c
> new file mode 100644
> index 0000000..95eda2a
> --- /dev/null
> +++ b/drivers/leds/trigger/ledtrig-burst.c
> @@ -0,0 +1,250 @@
> +/*
> + * LED Kernel Burst Trigger
> + *
> + * Copyright (C) 2013 Joe Xue <lgxue@hotmail.com>
> + *
> + * Based on Richard Purdie's ledtrig-timer.c and Atsushi Nemoto's
> + * ledtrig-heartbeat.c and Shuah Khan's ledtrig-burst.c
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + *
> + */
> +/*
> + * Burst trigger allows LEDs to blink in burst mode. The difference
> + * between burst trigger and timer trigger is timer trigger makes the
> + * LEDs blink continually in a frequency while burst trigger makes the
> + * LEDs blink some times in a special frequency then have a stop.
> + * Burst trigger allows LEDs to indicate different stats. Users can easy
> + * to describe it to support engineers by saying 3/4/5/X times burst
> + * blink.
> +*/
> +
> +#include <linux/module.h>
> +#include <linux/kernel.h>
> +#include <linux/init.h>
> +#include <linux/device.h>
> +#include <linux/slab.h>
> +#include <linux/timer.h>
> +#include <linux/leds.h>
> +#include "../leds.h"
> +
> +struct burst_trig_data {
> + int state;
> + unsigned long freq;
> + unsigned long times;
> + unsigned long count;
> + unsigned long delay_off;
> + int brightness_on;
> + struct timer_list timer;
> +};
> +
> +static void burst_timer_function(unsigned long data)
> +{
> + struct led_classdev *led_cdev = (struct led_classdev *) data;
> + struct burst_trig_data *burst_data = led_cdev->trigger_data;
> +
> + if (burst_data->count> 0) {
> + /* revert the light state */
> + burst_data->state = 1 - burst_data->state;
> + __led_set_brightness(led_cdev,
> + burst_data->state*burst_data->brightness_on);
> + burst_data->count--;
> + /* the delay time for on and off are 1000/(freq*2) = 500/freq */
> + mod_timer(&burst_data->timer,
> + jiffies + msecs_to_jiffies(500/burst_data->freq));
> + } else {
> + burst_data->count = burst_data->times * 2;
> + mod_timer(&burst_data->timer,
> + jiffies + msecs_to_jiffies(burst_data->delay_off));
> + }
> +}
> +
> +static ssize_t burst_delay_off_show(struct device *dev,
> + struct device_attribute *attr, char *buf)
> +{
> + struct led_classdev *led_cdev = dev_get_drvdata(dev);
> + struct burst_trig_data *burst_data = led_cdev->trigger_data;
> +
> + return sprintf(buf, "%lu\n", burst_data->delay_off);
> +}
> +
> +static ssize_t burst_delay_off_store(struct device *dev,
> + struct device_attribute *attr, const char *buf, size_t size)
> +{
> + struct led_classdev *led_cdev = dev_get_drvdata(dev);
> + struct burst_trig_data *burst_data = led_cdev->trigger_data;
> + unsigned long state;
> + ssize_t ret = -EINVAL;
> +
> + ret = kstrtoul(buf, 10, &state);
> + if (ret)
> + return ret;
> +
> + burst_data->delay_off = state;
> +
> + return size;
> +}
> +
> +static ssize_t burst_times_show(struct device *dev,
> + struct device_attribute *attr, char *buf)
> +{
> + struct led_classdev *led_cdev = dev_get_drvdata(dev);
> + struct burst_trig_data *burst_data = led_cdev->trigger_data;
> +
> + return sprintf(buf, "%lu\n", burst_data->times);
> +}
> +
> +static ssize_t burst_times_store(struct device *dev,
> + struct device_attribute *attr, const char *buf, size_t size)
> +{
> + struct led_classdev *led_cdev = dev_get_drvdata(dev);
> + struct burst_trig_data *burst_data = led_cdev->trigger_data;
> + unsigned long state;
> + ssize_t ret = -EINVAL;
> +
> + ret = kstrtoul(buf, 10, &state);
> + if (ret)
> + return ret;
> +
> + /* if the times is larger then 0 then use it else stop burst */
> + if (state> 0) {
> + burst_data->times = state;
> + burst_data->count = state*2;
> + del_timer_sync(&burst_data->timer);
> + mod_timer(&burst_data->timer, jiffies + 1);
> + } else {
> + del_timer_sync(&burst_data->timer);
> + }
> +
> + return size;
> +}
> +
> +static ssize_t burst_freq_show(struct device *dev,
> + struct device_attribute *attr, char *buf)
> +{
> + struct led_classdev *led_cdev = dev_get_drvdata(dev);
> + struct burst_trig_data *burst_data = led_cdev->trigger_data;
> +
> + return sprintf(buf, "%lu\n", burst_data->freq);
> +}
> +
> +static ssize_t burst_freq_store(struct device *dev,
> + struct device_attribute *attr, const char *buf, size_t size)
> +{
> + struct led_classdev *led_cdev = dev_get_drvdata(dev);
> + struct burst_trig_data *burst_data = led_cdev->trigger_data;
> + unsigned long state;
> + ssize_t ret = -EINVAL;
> +
> + ret = kstrtoul(buf, 10, &state);
> + if (ret)
> + return ret;
> +
> + /* the frequency can not be 0 */
> + if (state == 0)
> + return -EINVAL;
> +
> + burst_data->freq = state;
> +
> + return size;
> +}
> +
> +static DEVICE_ATTR(freq, 0644, burst_freq_show, burst_freq_store);
> +static DEVICE_ATTR(times, 0644, burst_times_show, burst_times_store);
> +static DEVICE_ATTR(delay_off, 0644,
> + burst_delay_off_show, burst_delay_off_store);
> +
> +static void burst_trig_activate(struct led_classdev *led_cdev)
> +{
> + int rc;
> + struct burst_trig_data *tdata;
> +
> + tdata = kzalloc(sizeof(struct burst_trig_data), GFP_KERNEL);
> + if (!tdata) {
> + dev_err(led_cdev->dev,
> + "unable to allocate burst trigger\n");
> + return;
> + }
> + /* default frequency 3HZ */
> + tdata->freq = 3;
> + /* default delay_off 500ms */
> + tdata->delay_off = 500;
> +
> + tdata->state = 0;
> +
> + led_cdev->trigger_data = tdata;
> +
> + rc = device_create_file(led_cdev->dev, &dev_attr_freq);
> + if (rc)
> + goto err_out;
> +
> + rc = device_create_file(led_cdev->dev, &dev_attr_times);
> + if (rc)
> + goto err_out_times;
> +
> + rc = device_create_file(led_cdev->dev, &dev_attr_delay_off);
> + if (rc)
> + goto err_out_delay_off;
> +
> + setup_timer(&tdata->timer, burst_timer_function,
> + (unsigned long) led_cdev);
> +
> + tdata->brightness_on = led_get_brightness(led_cdev);
> + if (tdata->brightness_on == LED_OFF)
> + tdata->brightness_on = led_cdev->max_brightness;
> +
> + __led_set_brightness(led_cdev, LED_OFF);
> + led_cdev->activated = true;
> +
> + return;
> +
> +err_out_delay_off:
> + device_remove_file(led_cdev->dev, &dev_attr_times);
> +err_out_times:
> + device_remove_file(led_cdev->dev, &dev_attr_freq);
> +err_out:
> + dev_err(led_cdev->dev, "unable to register burst trigger\n");
> + led_cdev->trigger_data = NULL;
> + kfree(tdata);
> +}
> +
> +static void burst_trig_deactivate(struct led_classdev *led_cdev)
> +{
> + struct burst_trig_data *burst_data = led_cdev->trigger_data;
> +
> + if (led_cdev->activated) {
> + del_timer_sync(&burst_data->timer);
> + device_remove_file(led_cdev->dev, &dev_attr_freq);
> + device_remove_file(led_cdev->dev, &dev_attr_times);
> + device_remove_file(led_cdev->dev, &dev_attr_delay_off);
> + led_cdev->trigger_data = NULL;
> + led_cdev->activated = false;
> + kfree(burst_data);
> + }
> + __led_set_brightness(led_cdev, LED_OFF);
> +}
> +
> +static struct led_trigger burst_trigger = {
> + .name = "burst",
> + .activate = burst_trig_activate,
> + .deactivate = burst_trig_deactivate,
> +};
> +
> +static int __init burst_trig_init(void)
> +{
> + return led_trigger_register(&burst_trigger);
> +}
> +
> +static void __exit burst_trig_exit(void)
> +{
> + led_trigger_unregister(&burst_trigger);
> +}
> +
> +module_init(burst_trig_init);
> +module_exit(burst_trig_exit);
> +
> +MODULE_AUTHOR("Joe Xue <lgxue@hotmail.com");
> +MODULE_DESCRIPTION("Burst LED trigger");
> +MODULE_LICENSE("GPL");
> --
> 1.8.1.2
> 		 	   		  