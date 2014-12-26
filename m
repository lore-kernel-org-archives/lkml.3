Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751700AbaLZXcR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Dec 2014 18:32:17 -0500
Received: from domu-toccata.ens-lyon.fr ([140.77.166.138]:44214 "EHLO
	sonata.ens-lyon.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751096AbaLZXcQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Dec 2014 18:32:16 -0500
Date: Sat, 27 Dec 2014 00:23:10 +0100
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
Subject: [PATCHv5 2/2] INPUT: Introduce generic trigger/LED pairs to input
 LEDs
Message-ID: <20141226232310.GD5069@type>
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
References: <20141226232116.GA5069@type>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141226232116.GA5069@type>
User-Agent: Mutt/1.5.21+34 (58baf7c9f32f) (2010-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This permits to reassign input LEDs to something else than keyboard "leds"
state, by adding a trigger and a led for each input leds, the former being
triggered by EV_LED events, and the latter being by default triggered by the
former. The user can then make the LED use another trigger, including other LED
triggers of the same keyboard.

The hardware LEDs are now not actioned from the ED_LED event any more, but from
the per-device LED layer.

[ebroder@mokafive.com: Rebased to 3.2-rc1 or so, cleaned up some includes, and fixed some constants]
[blogic@openwrt.org: CONFIG_INPUT_LEDS stubs should be static inline]
[akpm@linux-foundation.org: remove unneeded `extern', fix comment layout]
Signed-off-by: Samuel Thibault <samuel.thibault@ens-lyon.org>
Signed-off-by: Evan Broder <evan@ebroder.net>
Acked-by: Peter Korsgaard <jacmet@sunsite.dk>
Signed-off-by: John Crispin <blogic@openwrt.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---
Changed in this version:
- separate kbd LED changes from input LED changes
- add a per-device trigger, triggered by EV_LED events
- make the per-device LED triggered by default by the per-device trigger, so
  that evdev users get the modified behavior too
- make the hardware driven by the LED instead of EV_LED events

--- a/drivers/input/input.c
+++ b/drivers/input/input.c
@@ -27,6 +27,7 @@
 #include <linux/device.h>
 #include <linux/mutex.h>
 #include <linux/rcupdate.h>
+#include <linux/leds.h>
 #include "input-compat.h"
 
 MODULE_AUTHOR("Vojtech Pavlik <vojtech@suse.cz>");
@@ -324,11 +325,20 @@ static int input_get_disposition(struct
 		break;
 
 	case EV_LED:
-		if (is_event_supported(code, dev->ledbit, LED_MAX) &&
-		    !!test_bit(code, dev->led) != !!value) {
-
-			__change_bit(code, dev->led);
-			disposition = INPUT_PASS_TO_ALL;
+		if (is_event_supported(code, dev->ledbit, LED_MAX)) {
+#ifdef CONFIG_INPUT_LED
+			/* Redirect through trigger/LED pair */
+			if (dev->triggers && dev->triggers[code].name)
+				led_trigger_event(&dev->triggers[code],
+						  value ? LED_FULL : LED_OFF);
+			disposition = INPUT_PASS_TO_HANDLERS;
+#else /* !CONFIG_INPUT_LED */
+			/* Directly pass to device */
+			if (!!test_bit(code, dev->led) != !!value) {
+				__change_bit(code, dev->led);
+				disposition = INPUT_PASS_TO_ALL;
+			}
+#endif /* !CONFIG_INPUT_LED */
 		}
 		break;
 
@@ -711,6 +721,9 @@ static void input_disconnect_device(stru
 		handle->open = 0;
 
 	spin_unlock_irq(&dev->event_lock);
+
+	if (is_event_supported(EV_LED, dev->evbit, EV_MAX))
+		input_led_disconnect(dev);
 }
 
 /**
@@ -2137,6 +2150,9 @@ int input_register_device(struct input_d
 
 	list_add_tail(&dev->node, &input_dev_list);
 
+	if (is_event_supported(EV_LED, dev->evbit, EV_MAX))
+		input_led_connect(dev);
+
 	list_for_each_entry(handler, &input_handler_list, node)
 		input_attach_handler(dev, handler);
 
--- a/drivers/input/Kconfig
+++ b/drivers/input/Kconfig
@@ -178,6 +178,15 @@ comment "Input Device Drivers"
 
 source "drivers/input/keyboard/Kconfig"
 
+config INPUT_LEDS
+	bool "LED Support"
+	depends on LEDS_CLASS = INPUT || LEDS_CLASS = y
+	select LEDS_TRIGGERS
+	default y
+	help
+	  This option enables support for LEDs on keyboards managed
+	  by the input layer.
+
 source "drivers/input/mouse/Kconfig"
 
 source "drivers/input/joystick/Kconfig"
--- a/drivers/input/Makefile
+++ b/drivers/input/Makefile
@@ -6,6 +6,9 @@
 
 obj-$(CONFIG_INPUT)		+= input-core.o
 input-core-y := input.o input-compat.o input-mt.o ff-core.o
+ifeq ($(CONFIG_INPUT_LEDS),y)
+input-core-y += leds.o
+endif
 
 obj-$(CONFIG_INPUT_FF_MEMLESS)	+= ff-memless.o
 obj-$(CONFIG_INPUT_POLLDEV)	+= input-polldev.o
--- a/include/linux/input.h
+++ b/include/linux/input.h
@@ -79,6 +79,8 @@ struct input_value {
  * @led: reflects current state of device's LEDs
  * @snd: reflects current state of sound effects
  * @sw: reflects current state of device's switches
+ * @leds: led objects for the device's LEDs
+ * @triggers: trigger objects for the device's LEDs
  * @open: this method is called when the very first user calls
  *	input_open_device(). The driver must prepare the device
  *	to start generating events (start polling thread,
@@ -164,6 +166,9 @@ struct input_dev {
 	unsigned long snd[BITS_TO_LONGS(SND_CNT)];
 	unsigned long sw[BITS_TO_LONGS(SW_CNT)];
 
+	struct led_classdev *leds;
+	struct led_trigger *triggers;
+
 	int (*open)(struct input_dev *dev);
 	void (*close)(struct input_dev *dev);
 	int (*flush)(struct input_dev *dev, struct file *file);
@@ -531,4 +536,22 @@ int input_ff_erase(struct input_dev *dev
 int input_ff_create_memless(struct input_dev *dev, void *data,
 		int (*play_effect)(struct input_dev *, void *, struct ff_effect *));
 
+#ifdef CONFIG_INPUT_LEDS
+
+int input_led_connect(struct input_dev *dev);
+void input_led_disconnect(struct input_dev *dev);
+
+#else
+
+static inline int input_led_connect(struct input_dev *dev)
+{
+	return 0;
+}
+
+static inline void input_led_disconnect(struct input_dev *dev)
+{
+}
+
+#endif
+
 #endif
--- /dev/null
+++ b/drivers/input/leds.c
@@ -0,0 +1,155 @@
+/*
+ * LED support for the input layer
+ *
+ * Copyright 2010-2014 Samuel Thibault <samuel.thibault@ens-lyon.org>
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
+		struct led_classdev *leds = dev->leds;
+		struct led_trigger *triggers = dev->triggers;
+		int i;
+
+		if (leds) {
+			for (i = 0; i < LED_CNT; i++)
+				kfree(leds[i].name);
+			kfree(leds);
+			dev->leds = NULL;
+		}
+
+		if (triggers) {
+			for (i = 0; i < LED_CNT; i++)
+				kfree(triggers[i].name);
+			kfree(triggers);
+			dev->triggers = NULL;
+		}
+	}
+}
+
+/* LED state change for some keyboard, notify that keyboard.  */
+static void perdevice_input_led_set(struct led_classdev *cdev,
+			  enum led_brightness brightness)
+{
+	struct input_dev *dev;
+	struct led_classdev *leds;
+	int led;
+
+	dev = cdev->dev->platform_data;
+	if (!dev)
+		/* Still initializing */
+		return;
+
+	leds = dev->leds;
+	led = cdev - leds;
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
+	int i, error = -ENOMEM;
+	struct led_classdev *leds;
+	struct led_trigger *triggers;
+
+	leds = kcalloc(LED_CNT, sizeof(*leds), GFP_KERNEL);
+	if (!leds)
+		goto err;
+	dev->leds = leds;
+
+	triggers = kcalloc(LED_CNT, sizeof(*triggers), GFP_KERNEL);
+	if (!triggers)
+		goto err;
+	dev->triggers = triggers;
+
+	/* Register this device's LEDs and triggers */
+	for (i = 0; i < LED_CNT; i++)
+		if (input_led_names[i] && test_bit(i, dev->ledbit)) {
+			leds[i].name = kasprintf(GFP_KERNEL, "%s::%s",
+						dev_name(&dev->dev),
+						input_led_names[i]);
+			if (!leds[i].name)
+				goto err;
+			leds[i].max_brightness = 1;
+			leds[i].brightness_set = perdevice_input_led_set;
+
+			triggers[i].name = kasprintf(GFP_KERNEL, "%s-%s",
+						dev_name(&dev->dev),
+						input_led_names[i]);
+			if (!triggers[i].name)
+				goto err;
+
+			/* make the LED triggered by the corresponding trigger
+			 * by default */
+			leds[i].default_trigger = triggers[i].name;
+		}
+
+	/* No issue so far, we can register for real.  */
+	for (i = 0; i < LED_CNT; i++)
+		if (leds[i].name) {
+			led_classdev_register(&dev->dev, &leds[i]);
+			leds[i].dev->platform_data = dev;
+			led_trigger_register(&triggers[i]);
+		}
+
+	return 0;
+
+err:
+	input_led_delete(dev);
+	return error;
+}
+
+void input_led_disconnect(struct input_dev *dev)
+{
+	int i;
+	struct led_classdev *leds = dev->leds;
+	struct led_trigger *triggers = dev->triggers;
+
+	for (i = 0; i < LED_CNT; i++) {
+		if (leds[i].name)
+			led_classdev_unregister(&leds[i]);
+		if (triggers[i].name)
+			led_trigger_unregister(&triggers[i]);
+	}
+
+	input_led_delete(dev);
+}
