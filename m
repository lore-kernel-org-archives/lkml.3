Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754972AbbAWM2S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 07:28:18 -0500
Received: from domu-toccata.ens-lyon.fr ([140.77.166.138]:39433 "EHLO
	sonata.ens-lyon.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753270AbbAWM2Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 07:28:16 -0500
Date: Fri, 23 Jan 2015 13:28:14 +0100
From: Samuel Thibault <samuel.thibault@ens-lyon.org>
To: Pavel Machek <pavel@ucw.cz>, Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        David Herrmann <dh.herrmann@gmail.com>, akpm@linux-foundation.org,
        jslaby@suse.cz, Bryan Wu <cooloney@gmail.com>, rpurdie@rpsys.net,
        linux-kernel@vger.kernel.org, Evan Broder <evan@ebroder.net>,
        Arnaud Patard <arnaud.patard@rtp-net.org>,
        Peter Korsgaard <jacmet@sunsite.dk>,
        Sascha Hauer <s.hauer@pengutronix.de>, Rob Clark <robdclark@gmail.com>,
        Niels de Vos <devos@fedoraproject.org>,
        linux-arm-kernel@lists.infradead.org, blogic@openwrt.org,
        Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>
Subject: [PATCHv6 2/2] INPUT: Introduce generic trigger/LED pairs to input
 LEDs
Message-ID: <20150123122814.GB18514@type.bordeaux.inria.fr>
Mail-Followup-To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
	Pavel Machek <pavel@ucw.cz>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	David Herrmann <dh.herrmann@gmail.com>, akpm@linux-foundation.org,
	jslaby@suse.cz, Bryan Wu <cooloney@gmail.com>, rpurdie@rpsys.net,
	linux-kernel@vger.kernel.org, Evan Broder <evan@ebroder.net>,
	Arnaud Patard <arnaud.patard@rtp-net.org>,
	Peter Korsgaard <jacmet@sunsite.dk>,
	Sascha Hauer <s.hauer@pengutronix.de>,
	Rob Clark <robdclark@gmail.com>,
	Niels de Vos <devos@fedoraproject.org>,
	linux-arm-kernel@lists.infradead.org, blogic@openwrt.org,
	Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21+34 (58baf7c9f32f) (2010-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This permits to reassign input LEDs to something else than keyboard "leds"
state, by adding a trigger and a led for each input leds, the former being
triggered by EV_LED events, and the latter being by default triggered by the
former. The user can then make the LED use another trigger, including other LED
triggers of the same keyboard.

The hardware LEDs are now not actioned from the EV_LED event any more, but from
the per-device LED layer.

[ebroder@mokafive.com: Rebased to 3.2-rc1 or so, cleaned up some includes, and fixed some constants]
[akpm@linux-foundation.org: remove unneeded `extern', fix comment layout]
Signed-off-by: Samuel Thibault <samuel.thibault@ens-lyon.org>
Signed-off-by: Evan Broder <evan@ebroder.net>
Acked-by: Peter Korsgaard <jacmet@sunsite.dk>
Signed-off-by: John Crispin <blogic@openwrt.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---
Changed in this version:
- use drvdata instead of platform_data
- dropped CONFIG_INPUT_LEDS option
- compacted leds and triggers array allocation
- handle registration failure

--- a/drivers/input/input.c
+++ b/drivers/input/input.c
@@ -27,6 +27,7 @@
 #include <linux/device.h>
 #include <linux/mutex.h>
 #include <linux/rcupdate.h>
+#include <linux/leds.h>
 #include "input-compat.h"
 
 MODULE_AUTHOR("Vojtech Pavlik <vojtech@suse.cz>");
@@ -324,11 +325,16 @@ static int input_get_disposition(struct
 		break;
 
 	case EV_LED:
-		if (is_event_supported(code, dev->ledbit, LED_MAX) &&
-		    !!test_bit(code, dev->led) != !!value) {
-
-			__change_bit(code, dev->led);
-			disposition = INPUT_PASS_TO_ALL;
+		if (is_event_supported(code, dev->ledbit, LED_MAX)) {
+			/* Redirected through trigger/LED pair */
+			int j;
+			for (j = 0; j < dev->num_leds; j++)
+				if (dev->led_num[j] == code) {
+					led_trigger_event(&dev->triggers[j],
+						value ? LED_FULL : LED_OFF);
+					break;
+				}
+			disposition = INPUT_PASS_TO_HANDLERS;
 		}
 		break;
 
@@ -711,6 +717,9 @@ static void input_disconnect_device(stru
 		handle->open = 0;
 
 	spin_unlock_irq(&dev->event_lock);
+
+	if (is_event_supported(EV_LED, dev->evbit, EV_MAX))
+		input_led_disconnect(dev);
 }
 
 /**
@@ -2137,6 +2146,9 @@ int input_register_device(struct input_d
 
 	list_add_tail(&dev->node, &input_dev_list);
 
+	if (is_event_supported(EV_LED, dev->evbit, EV_MAX))
+		input_led_connect(dev);
+
 	list_for_each_entry(handler, &input_handler_list, node)
 		input_attach_handler(dev, handler);
 
--- a/drivers/input/Kconfig
+++ b/drivers/input/Kconfig
@@ -8,6 +8,9 @@ menu "Input device support"
 config INPUT
 	tristate "Generic input layer (needed for keyboard, mouse, ...)" if EXPERT
 	default y
+	select NEW_LEDS
+	select LEDS_CLASS
+	select LEDS_TRIGGERS
 	help
 	  Say Y here if you have any input device (mouse, keyboard, tablet,
 	  joystick, steering wheel ...) connected to your system and want
--- a/drivers/input/Makefile
+++ b/drivers/input/Makefile
@@ -5,7 +5,7 @@
 # Each configuration option enables a list of files.
 
 obj-$(CONFIG_INPUT)		+= input-core.o
-input-core-y := input.o input-compat.o input-mt.o ff-core.o
+input-core-y := input.o input-compat.o input-mt.o ff-core.o leds.o
 
 obj-$(CONFIG_INPUT_FF_MEMLESS)	+= ff-memless.o
 obj-$(CONFIG_INPUT_POLLDEV)	+= input-polldev.o
--- a/include/linux/input.h
+++ b/include/linux/input.h
@@ -79,6 +79,10 @@ struct input_value {
  * @led: reflects current state of device's LEDs
  * @snd: reflects current state of sound effects
  * @sw: reflects current state of device's switches
+ * @num_leds: size of led_num, leds, and triggers arrays
+ * @led_num: LED identifiers for the device's LEDs, between 0 and LED_MAX
+ * @leds: led objects for the device's LEDs
+ * @triggers: trigger objects for the device's LEDs
  * @open: this method is called when the very first user calls
  *	input_open_device(). The driver must prepare the device
  *	to start generating events (start polling thread,
@@ -164,6 +168,11 @@ struct input_dev {
 	unsigned long snd[BITS_TO_LONGS(SND_CNT)];
 	unsigned long sw[BITS_TO_LONGS(SW_CNT)];
 
+	unsigned int num_leds;
+	unsigned int *led_num;
+	struct led_classdev *leds;
+	struct led_trigger *triggers;
+
 	int (*open)(struct input_dev *dev);
 	void (*close)(struct input_dev *dev);
 	int (*flush)(struct input_dev *dev, struct file *file);
@@ -531,4 +540,7 @@ int input_ff_erase(struct input_dev *dev
 int input_ff_create_memless(struct input_dev *dev, void *data,
 		int (*play_effect)(struct input_dev *, void *, struct ff_effect *));
 
+int input_led_connect(struct input_dev *dev);
+void input_led_disconnect(struct input_dev *dev);
+
 #endif
--- /dev/null
+++ b/drivers/input/leds.c
@@ -0,0 +1,194 @@
+/*
+ * LED support for the input layer
+ *
+ * Copyright 2010-2015 Samuel Thibault <samuel.thibault@ens-lyon.org>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+/*
+ * This creates a trigger/LED pair per device:
+ * - the trigger is actioned from the core's input_get_disposition,
+ * - the LED is by default triggered by that trigger
+ * - the LED actuates the hardware.
+ */
+
+#include <linux/kernel.h>
+#include <linux/slab.h>
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/leds.h>
+#include <linux/input.h>
+
+static const char *const input_led_names[LED_CNT] = {
+	[LED_NUML] = "numl",
+	[LED_CAPSL] = "capsl",
+	[LED_SCROLLL] = "scrolll",
+	[LED_COMPOSE] = "compose",
+	[LED_KANA] = "kana",
+	[LED_SLEEP] = "sleep",
+	[LED_SUSPEND] = "suspend",
+	[LED_MUTE] = "mute",
+	[LED_MISC] = "misc",
+	[LED_MAIL] = "mail",
+	[LED_CHARGING] = "charging",
+};
+
+/* Free LED data from input device, used at abortion and disconnection.  */
+static void input_led_delete(struct input_dev *dev)
+{
+	if (dev) {
+		int j, n = dev->num_leds;
+		unsigned int *led_num = dev->led_num;
+		struct led_classdev *leds = dev->leds;
+		struct led_trigger *triggers = dev->triggers;
+
+		if (led_num) {
+			kfree(led_num);
+			dev->led_num = NULL;
+		}
+
+		if (leds) {
+			for (j = 0; j < n; j++)
+				kfree(leds[j].name);
+			kfree(leds);
+			dev->leds = NULL;
+		}
+
+		if (triggers) {
+			for (j = 0; j < n; j++)
+				kfree(triggers[j].name);
+			kfree(triggers);
+			dev->triggers = NULL;
+		}
+
+		dev->num_leds = 0;
+	}
+}
+
+/* LED state change for some keyboard, notify that keyboard.  */
+static void perdevice_input_led_set(struct led_classdev *cdev,
+			  enum led_brightness brightness)
+{
+	struct input_dev *dev;
+	unsigned int led;
+
+	dev = to_input_dev(cdev->dev->parent);
+	if (!dev)
+		/* Still initializing */
+		return;
+
+	led = dev->led_num[cdev - dev->leds];
+
+	if (test_bit(EV_LED, dev->evbit) &&
+		led <= LED_MAX && test_bit(led, dev->ledbit) &&
+		!!test_bit(led, dev->led) != !!brightness) {
+		__change_bit(led, dev->led);
+		dev->event(dev, EV_LED, led, !!brightness);
+	}
+}
+
+/* A new input device with potential LEDs to connect.  */
+int input_led_connect(struct input_dev *dev)
+{
+	int i, j, error = -ENOMEM;
+	unsigned int *led_num;
+	struct led_classdev *leds;
+	struct led_trigger *triggers;
+	int n;
+
+	/* Count how many LEDs it has.  */
+	n = 0;
+	for (i = 0; i < LED_CNT; i++)
+		if (input_led_names[i] && test_bit(i, dev->ledbit))
+			n++;
+
+	dev->num_leds = n;
+
+	led_num = kmalloc_array(n, sizeof(*led_num), GFP_KERNEL);
+	if (!led_num)
+		goto err;
+	dev->led_num = led_num;
+
+	leds = kcalloc(n, sizeof(*leds), GFP_KERNEL);
+	if (!leds)
+		goto err;
+	dev->leds = leds;
+
+	triggers = kcalloc(n, sizeof(*triggers), GFP_KERNEL);
+	if (!triggers)
+		goto err;
+	dev->triggers = triggers;
+
+	/* Register this device's LEDs and triggers */
+	j = 0;
+	for (i = 0; i < LED_CNT; i++)
+		if (input_led_names[i] && test_bit(i, dev->ledbit)) {
+			struct led_classdev *led = &leds[j];
+			struct led_trigger *trigger = &triggers[j];
+
+			led_num[j] = i;
+
+			led->name = kasprintf(GFP_KERNEL, "%s::%s",
+						dev_name(&dev->dev),
+						input_led_names[i]);
+			if (!led->name) {
+				error = -ENOMEM;
+				goto err;
+			}
+			led->max_brightness = 1;
+			led->brightness_set = perdevice_input_led_set;
+
+			trigger->name = kasprintf(GFP_KERNEL, "%s-%s",
+						dev_name(&dev->dev),
+						input_led_names[i]);
+			if (!trigger->name) {
+				error = -ENOMEM;
+				goto err;
+			}
+
+			/* make the LED triggered by the corresponding trigger
+			 * by default */
+			led->default_trigger = trigger->name;
+
+			/* No issue so far, we can register.  */
+			error = led_classdev_register(&dev->dev, led);
+			if (error)
+				goto err;
+			error = led_trigger_register(trigger);
+			if (error) {
+				led_classdev_unregister(led);
+				goto err;
+			}
+
+			j++;
+
+			BUG_ON(j > n);
+		}
+
+	return 0;
+
+err:
+	for (j-- ; j >= 0; j--) {
+		led_classdev_unregister(&leds[j]);
+		led_trigger_unregister(&triggers[j]);
+	}
+	input_led_delete(dev);
+	return error;
+}
+
+void input_led_disconnect(struct input_dev *dev)
+{
+	int j;
+	int n = dev->num_leds;
+	struct led_classdev *leds = dev->leds;
+	struct led_trigger *triggers = dev->triggers;
+
+	for (j = 0; j < n; j++) {
+		led_classdev_unregister(&leds[j]);
+		led_trigger_unregister(&triggers[j]);
+	}
+	input_led_delete(dev);
+}
