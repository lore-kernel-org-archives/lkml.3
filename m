Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758210Ab3AQBGU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 20:06:20 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:47008 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755652Ab3AQBGS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 20:06:18 -0500
From: "Kim, Milo" <Milo.Kim@ti.com>
To: Bryan Wu <cooloney@gmail.com>
CC: "linux-leds@vger.kernel.org" <linux-leds@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/2] leds: simply LED trigger list management
Thread-Topic: [PATCH 1/2] leds: simply LED trigger list management
Thread-Index: Ac30TtaxAtsXlGEuQfKWKcphpn75LQ==
Date: Thu, 17 Jan 2013 01:06:13 +0000
Message-ID: <A874F61F95741C4A9BA573A70FE3998F69E17700@DQHE02.ent.ti.com>
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

 There are two list_heads for handling LED trigger function.
 'trig_list' of led_classdev and 'led_cdevs' of led_trigger.
 Those are added/removed with led_trigger_set().
 To find exact LED device, those are scanned in led_trigger_event() and
 led_trigger_blink_setup().

 But without additional lists, we can get LED device information.
 Here is a simple solution.
  "Scan LED list and find same trigger pointer as requested. Then we can
   get LED device from the LED device list."

 Changed list iteration: refer LED list and find the trigger.
   Just find same registered trigger pointer in each LED device.
   We can get LED device from registered LED device list.

 Removed list heads: 'trig_list' and 'led_cdevs'.
   Not used any more

Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
---
 drivers/leds/led-triggers.c |   27 ++++++++-------------------
 include/linux/leds.h        |    2 --
 2 files changed, 8 insertions(+), 21 deletions(-)

diff --git a/drivers/leds/led-triggers.c b/drivers/leds/led-triggers.c
index 3c972b2..5aa0252 100644
--- a/drivers/leds/led-triggers.c
+++ b/drivers/leds/led-triggers.c
@@ -101,7 +101,6 @@ EXPORT_SYMBOL_GPL(led_trigger_show);
 /* Caller must ensure led_cdev->trigger_lock held */
 void led_trigger_set(struct led_classdev *led_cdev, struct led_trigger *trig)
 {
-	unsigned long flags;
 	char *event = NULL;
 	char *envp[2];
 	const char *name;
@@ -111,10 +110,6 @@ void led_trigger_set(struct led_classdev *led_cdev, struct led_trigger *trig)
 
 	/* Remove any existing trigger */
 	if (led_cdev->trigger) {
-		write_lock_irqsave(&led_cdev->trigger->leddev_list_lock, flags);
-		list_del(&led_cdev->trig_list);
-		write_unlock_irqrestore(&led_cdev->trigger->leddev_list_lock,
-			flags);
 		cancel_work_sync(&led_cdev->set_brightness_work);
 		led_stop_software_blink(led_cdev);
 		if (led_cdev->trigger->deactivate)
@@ -123,9 +118,6 @@ void led_trigger_set(struct led_classdev *led_cdev, struct led_trigger *trig)
 		led_set_brightness(led_cdev, LED_OFF);
 	}
 	if (trig) {
-		write_lock_irqsave(&trig->leddev_list_lock, flags);
-		list_add_tail(&led_cdev->trig_list, &trig->led_cdevs);
-		write_unlock_irqrestore(&trig->leddev_list_lock, flags);
 		led_cdev->trigger = trig;
 		if (trig->activate)
 			trig->activate(led_cdev);
@@ -187,7 +179,6 @@ int led_trigger_register(struct led_trigger *trig)
 	struct led_trigger *_trig;
 
 	rwlock_init(&trig->leddev_list_lock);
-	INIT_LIST_HEAD(&trig->led_cdevs);
 
 	down_write(&triggers_list_lock);
 	/* Make sure the trigger's name isn't already in use */
@@ -242,17 +233,15 @@ EXPORT_SYMBOL_GPL(led_trigger_unregister);
 void led_trigger_event(struct led_trigger *trig,
 			enum led_brightness brightness)
 {
-	struct list_head *entry;
+	struct led_classdev *led_cdev;
 
 	if (!trig)
 		return;
 
 	read_lock(&trig->leddev_list_lock);
-	list_for_each(entry, &trig->led_cdevs) {
-		struct led_classdev *led_cdev;
-
-		led_cdev = list_entry(entry, struct led_classdev, trig_list);
-		led_set_brightness(led_cdev, brightness);
+	list_for_each_entry(led_cdev, &leds_list, node) {
+		if (led_cdev->trigger == trig)
+			led_set_brightness(led_cdev, brightness);
 	}
 	read_unlock(&trig->leddev_list_lock);
 }
@@ -264,16 +253,16 @@ static void led_trigger_blink_setup(struct led_trigger *trig,
 			     int oneshot,
 			     int invert)
 {
-	struct list_head *entry;
+	struct led_classdev *led_cdev;
 
 	if (!trig)
 		return;
 
 	read_lock(&trig->leddev_list_lock);
-	list_for_each(entry, &trig->led_cdevs) {
-		struct led_classdev *led_cdev;
+	list_for_each_entry(led_cdev, &leds_list, node) {
+		if (led_cdev->trigger != trig)
+			continue;
 
-		led_cdev = list_entry(entry, struct led_classdev, trig_list);
 		if (oneshot)
 			led_blink_set_oneshot(led_cdev, delay_on, delay_off,
 					      invert);
diff --git a/include/linux/leds.h b/include/linux/leds.h
index 0d9b5ee..4c593c6 100644
--- a/include/linux/leds.h
+++ b/include/linux/leds.h
@@ -78,7 +78,6 @@ struct led_classdev {
 	struct rw_semaphore	 trigger_lock;
 
 	struct led_trigger	*trigger;
-	struct list_head	 trig_list;
 	void			*trigger_data;
 	/* true if activated - deactivate routine uses it to do cleanup */
 	bool			activated;
@@ -154,7 +153,6 @@ struct led_trigger {
 
 	/* LEDs under control by this trigger (for simple triggers) */
 	rwlock_t	  leddev_list_lock;
-	struct list_head  led_cdevs;
 
 	/* Link to next registered trigger */
 	struct list_head  next_trig;
-- 
1.7.9.5


Best Regards,
Milo

