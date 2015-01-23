Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754362AbbAWM1w (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 07:27:52 -0500
Received: from domu-toccata.ens-lyon.fr ([140.77.166.138]:39418 "EHLO
	sonata.ens-lyon.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751856AbbAWM1q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 07:27:46 -0500
Date: Fri, 23 Jan 2015 13:27:42 +0100
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
Subject: [PATCHv6 1/2] INPUT: Introduce generic trigger/LED pairs between
 keyboard modifiers and input LEDs
Message-ID: <20150123122742.GA18514@type.bordeaux.inria.fr>
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

This permits to change which modifier triggers which keyboard LEDs, by adding
modifier triggers, and a series of LEDs for the VT.

This permits to fix #7063 from userland by using a modifier to implement proper
CapsLock behavior and have the keyboard caps lock led show that modifier state.

[ebroder@mokafive.com: Rebased to 3.2-rc1 or so, cleaned up some includes, and fixed some constants]
[akpm@linux-foundation.org: remove unneeded `extern', fix comment layout]
Signed-off-by: Samuel Thibault <samuel.thibault@ens-lyon.org>
Signed-off-by: Evan Broder <evan@ebroder.net>
Acked-by: Peter Korsgaard <jacmet@sunsite.dk>
Signed-off-by: John Crispin <blogic@openwrt.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---
Nothing changed in this version compared to v5.

--- a/drivers/tty/Kconfig
+++ b/drivers/tty/Kconfig
@@ -13,6 +13,9 @@ config VT
 	bool "Virtual terminal" if EXPERT
 	depends on !S390 && !UML
 	select INPUT
+	select NEW_LEDS
+	select LEDS_CLASS
+	select LEDS_TRIGGERS
 	default y
 	---help---
 	  If you say Y here, you will get support for terminal devices with
--- a/drivers/tty/vt/keyboard.c
+++ b/drivers/tty/vt/keyboard.c
@@ -33,6 +33,7 @@
 #include <linux/string.h>
 #include <linux/init.h>
 #include <linux/slab.h>
+#include <linux/leds.h>
 
 #include <linux/kbd_kern.h>
 #include <linux/kbd_diacr.h>
@@ -130,6 +131,7 @@ static char rep;					/* flag telling cha
 static int shift_state = 0;
 
 static unsigned char ledstate = 0xff;			/* undefined */
+static unsigned char lockstate = 0xff;			/* undefined */
 static unsigned char ledioctl;
 
 /*
@@ -962,6 +964,146 @@ static void k_brl(struct vc_data *vc, un
 }
 
 /*
+ * Keyboard LEDs are propagated by default like the following example:
+ *
+ * VT keyboard LED state or modifier state, calls kbd_bh()
+ * -> kbd-xxx VT trigger
+ * -> vt::xxx VT LED
+ * -> input EV_DEV events (in vt_led_cb)
+ *
+ * KDSETLED directly triggers vt::xxx LEDs.
+ *
+ * Userland can however choose the trigger for the vt::numl LED, or
+ * independently choose the trigger for any inputx::numl LED.
+ */
+
+/* We route VT keyboard "leds" through triggers */
+static void kbd_ledstate_trigger_activate(struct led_classdev *cdev);
+
+static struct led_trigger ledtrig_ledstate[] = {
+#define DEFINE_LEDSTATE_TRIGGER(kbd_led, nam) \
+	[kbd_led] = { \
+		.name = nam, \
+		.activate = kbd_ledstate_trigger_activate, \
+	}
+	DEFINE_LEDSTATE_TRIGGER(VC_SCROLLOCK, "kbd-scrollock"),
+	DEFINE_LEDSTATE_TRIGGER(VC_NUMLOCK,   "kbd-numlock"),
+	DEFINE_LEDSTATE_TRIGGER(VC_CAPSLOCK,  "kbd-capslock"),
+	DEFINE_LEDSTATE_TRIGGER(VC_KANALOCK,  "kbd-kanalock"),
+#undef DEFINE_LEDSTATE_TRIGGER
+};
+
+static int input_leds[] = {
+	[VC_SCROLLOCK] = LED_SCROLLL,
+	[VC_NUMLOCK] = LED_NUML,
+	[VC_CAPSLOCK] = LED_CAPSL,
+	[VC_KANALOCK] = LED_KANA,
+};
+
+/* Called on trigger connection, to set initial state */
+static void kbd_ledstate_trigger_activate(struct led_classdev *cdev)
+{
+	struct led_trigger *trigger = cdev->trigger;
+	int led = trigger - ledtrig_ledstate;
+
+	tasklet_disable(&keyboard_tasklet);
+	led_trigger_event(trigger, ledstate & (1 << led) ? LED_FULL : LED_OFF);
+	tasklet_enable(&keyboard_tasklet);
+}
+
+/* We route VT keyboard lockstates through triggers */
+static void kbd_lockstate_trigger_activate(struct led_classdev *cdev);
+
+static struct led_trigger ledtrig_lockstate[] = {
+#define DEFINE_LOCKSTATE_TRIGGER(kbd_led, nam) \
+	[kbd_led] = { \
+		.name = nam, \
+		.activate = kbd_lockstate_trigger_activate, \
+	}
+	DEFINE_LOCKSTATE_TRIGGER(VC_SHIFTLOCK,  "kbd-shiftlock"),
+	DEFINE_LOCKSTATE_TRIGGER(VC_ALTGRLOCK,  "kbd-altgrlock"),
+	DEFINE_LOCKSTATE_TRIGGER(VC_CTRLLOCK,   "kbd-ctrllock"),
+	DEFINE_LOCKSTATE_TRIGGER(VC_ALTLOCK,    "kbd-altlock"),
+	DEFINE_LOCKSTATE_TRIGGER(VC_SHIFTLLOCK, "kbd-shiftllock"),
+	DEFINE_LOCKSTATE_TRIGGER(VC_SHIFTRLOCK, "kbd-shiftrlock"),
+	DEFINE_LOCKSTATE_TRIGGER(VC_CTRLLLOCK,  "kbd-ctrlllock"),
+	DEFINE_LOCKSTATE_TRIGGER(VC_CTRLRLOCK,  "kbd-ctrlrlock"),
+#undef DEFINE_LOCKSTATE_TRIGGER
+};
+
+/* Called on trigger connection, to set initial state */
+static void kbd_lockstate_trigger_activate(struct led_classdev *cdev)
+{
+	struct led_trigger *trigger = cdev->trigger;
+	int led = trigger - ledtrig_lockstate;
+
+	tasklet_disable(&keyboard_tasklet);
+	led_trigger_event(trigger, lockstate & (1 << led) ? LED_FULL : LED_OFF);
+	tasklet_enable(&keyboard_tasklet);
+}
+
+/* Handler for VT LEDs, scheduling injecting input events in a worker */
+static void vt_led_set(struct led_classdev *cdev,
+			  enum led_brightness brightness);
+static struct led_classdev vt_leds[LED_CNT] = {
+#define DEFINE_INPUT_LED(vt_led, nam, deftrig) \
+	[vt_led] = { \
+		.name = "vt::"nam, \
+		.max_brightness = 1, \
+		.brightness_set = vt_led_set, \
+		.default_trigger = deftrig, \
+	}
+/* Default triggers for the VT LEDs just correspond to the legacy
+ * usage. */
+	DEFINE_INPUT_LED(LED_NUML, "numl", "kbd-numlock"),
+	DEFINE_INPUT_LED(LED_CAPSL, "capsl", "kbd-capslock"),
+	DEFINE_INPUT_LED(LED_SCROLLL, "scrolll", "kbd-scrollock"),
+	DEFINE_INPUT_LED(LED_COMPOSE, "compose", NULL),
+	DEFINE_INPUT_LED(LED_KANA, "kana", "kbd-kanalock"),
+	DEFINE_INPUT_LED(LED_SLEEP, "sleep", NULL),
+	DEFINE_INPUT_LED(LED_SUSPEND, "suspend", NULL),
+	DEFINE_INPUT_LED(LED_MUTE, "mute", NULL),
+	DEFINE_INPUT_LED(LED_MISC, "misc", NULL),
+	DEFINE_INPUT_LED(LED_MAIL, "mail", NULL),
+	DEFINE_INPUT_LED(LED_CHARGING, "charging", NULL),
+};
+
+static struct work_struct vt_led_work[LED_CNT];
+static char vt_led_state[LED_CNT];
+
+/* Emit input events to actually update one LED */
+static int kbd_update_leds_helper(struct input_handle *handle, void *data)
+{
+	int led = *(int *)data;
+
+	if (test_bit(EV_LED, handle->dev->evbit)) {
+		input_inject_event(handle, EV_LED, led, vt_led_state[led]);
+		input_inject_event(handle, EV_SYN, SYN_REPORT, 0);
+	}
+
+	return 0;
+}
+
+/* Emit input events to actually update one LED on all keyboards */
+static void vt_led_cb(struct work_struct *work)
+{
+	int led = work - vt_led_work;
+
+	input_handler_for_each_handle(&kbd_handler, &led,
+				      kbd_update_leds_helper);
+}
+
+/* VT LED state change, scheduling triggering input events for it */
+static void vt_led_set(struct led_classdev *cdev,
+			  enum led_brightness brightness)
+{
+	int led = cdev - vt_leds;
+
+	vt_led_state[led] = !!brightness;
+	schedule_work(&vt_led_work[led]);
+}
+
+/*
  * The leds display either (i) the status of NumLock, CapsLock, ScrollLock,
  * or (ii) whatever pattern of lights people want to show using KDSETLED,
  * or (iii) specified bits of specified words in kernel memory.
@@ -995,20 +1137,6 @@ static inline unsigned char getleds(void
 	return kb->ledflagstate;
 }
 
-static int kbd_update_leds_helper(struct input_handle *handle, void *data)
-{
-	unsigned char leds = *(unsigned char *)data;
-
-	if (test_bit(EV_LED, handle->dev->evbit)) {
-		input_inject_event(handle, EV_LED, LED_SCROLLL, !!(leds & 0x01));
-		input_inject_event(handle, EV_LED, LED_NUML,    !!(leds & 0x02));
-		input_inject_event(handle, EV_LED, LED_CAPSL,   !!(leds & 0x04));
-		input_inject_event(handle, EV_SYN, SYN_REPORT, 0);
-	}
-
-	return 0;
-}
-
 /**
  *	vt_get_leds	-	helper for braille console
  *	@console: console to read
@@ -1085,26 +1213,39 @@ void vt_kbd_con_stop(int console)
 }
 
 /*
- * This is the tasklet that updates LED state on all keyboards
- * attached to the box. The reason we use tasklet is that we
- * need to handle the scenario when keyboard handler is not
- * registered yet but we already getting updates from the VT to
- * update led state.
+ * This is the tasklet that updates LED state of all LED triggers, which will
+ * thus update the VT LED status, and eventually submit input events.
+ * The reason we use tasklet is that we need to handle the scenario when
+ * keyboard handler is not registered yet but we already getting updates
+ * from the VT to update led state.
  */
 static void kbd_bh(unsigned long dummy)
 {
 	unsigned char leds;
 	unsigned long flags;
-	
+	int i;
+
 	spin_lock_irqsave(&led_lock, flags);
 	leds = getleds();
 	spin_unlock_irqrestore(&led_lock, flags);
 
 	if (leds != ledstate) {
-		input_handler_for_each_handle(&kbd_handler, &leds,
-					      kbd_update_leds_helper);
+		for (i = 0; i < ARRAY_SIZE(ledtrig_ledstate); i++)
+			if ((leds ^ ledstate) & (1 << i))
+				led_trigger_event(&ledtrig_ledstate[i],
+						leds & (1 << i)
+						? LED_FULL : LED_OFF);
 		ledstate = leds;
 	}
+
+	if (kbd->lockstate != lockstate) {
+		for (i = 0; i < ARRAY_SIZE(ledtrig_lockstate); i++)
+			if ((kbd->lockstate ^ lockstate) & (1 << i))
+				led_trigger_event(&ledtrig_lockstate[i],
+						kbd->lockstate & (1 << i)
+						? LED_FULL : LED_OFF);
+		lockstate = kbd->lockstate;
+	}
 }
 
 DECLARE_TASKLET_DISABLED(keyboard_tasklet, kbd_bh, 0);
@@ -1448,10 +1589,13 @@ static void kbd_disconnect(struct input_
  */
 static void kbd_start(struct input_handle *handle)
 {
+	int i;
+
 	tasklet_disable(&keyboard_tasklet);
 
 	if (ledstate != 0xff)
-		kbd_update_leds_helper(handle, &ledstate);
+		for (i = 0; i < ARRAY_SIZE(ledtrig_ledstate); i++)
+			kbd_update_leds_helper(handle, &input_leds[i]);
 
 	tasklet_enable(&keyboard_tasklet);
 }
@@ -1501,6 +1645,26 @@ int __init kbd_init(void)
 	if (error)
 		return error;
 
+	for (i = 0; i < ARRAY_SIZE(ledtrig_ledstate); i++) {
+		error = led_trigger_register(&ledtrig_ledstate[i]);
+		if (error)
+			pr_err("error %d while registering trigger %s\n",
+					error, ledtrig_ledstate[i].name);
+	}
+
+	for (i = 0; i < ARRAY_SIZE(ledtrig_lockstate); i++) {
+		error = led_trigger_register(&ledtrig_lockstate[i]);
+		if (error)
+			pr_err("error %d while registering trigger %s\n",
+					error, ledtrig_lockstate[i].name);
+	}
+
+	for (i = 0; i < LED_CNT; i++)
+		if (vt_leds[i].name) {
+			led_classdev_register(NULL, &vt_leds[i]);
+			INIT_WORK(&vt_led_work[i], vt_led_cb);
+		}
+
 	tasklet_enable(&keyboard_tasklet);
 	tasklet_schedule(&keyboard_tasklet);
 
--- a/Documentation/leds/leds-class.txt
+++ b/Documentation/leds/leds-class.txt
@@ -2,9 +2,6 @@
 LED handling under Linux
 ========================
 
-If you're reading this and thinking about keyboard leds, these are
-handled by the input subsystem and the led class is *not* needed.
-
 In its simplest form, the LED class just allows control of LEDs from
 userspace. LEDs appear in /sys/class/leds/. The maximum brightness of the
 LED is defined in max_brightness file. The brightness file will set the brightness
--- a/drivers/leds/Kconfig
+++ b/drivers/leds/Kconfig
@@ -11,9 +11,6 @@ menuconfig NEW_LEDS
 	  Say Y to enable Linux LED support.  This allows control of supported
 	  LEDs from both userspace and optionally, by kernel events (triggers).
 
-	  This is not related to standard keyboard LEDs which are controlled
-	  via the input system.
-
 if NEW_LEDS
 
 config LEDS_CLASS
