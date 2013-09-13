Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756209Ab3IMVwu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 17:52:50 -0400
Received: from mail-pd0-f177.google.com ([209.85.192.177]:54580 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755784Ab3IMVws (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 17:52:48 -0400
From: Benson Leung <bleung@chromium.org>
To: dmitry.torokhov@gmail.com, linux-kernel@vger.kernel.org,
        linux-input@vger.kernel.org, linux-gpio@vger.kernel.org,
        devicetree@vger.kernel.org, david@protonic.nl
Cc: bleung@chromium.org, dianders@chromium.org
Subject: [PATCH] Input: gpio_keys - wakeup_trigger
Date: Fri, 13 Sep 2013 14:52:40 -0700
Message-Id: <1379109160-32437-1-git-send-email-bleung@chromium.org>
X-Mailer: git-send-email 1.8.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allow wakeup_trigger to be defined per gpio button. Currently, all
gpio buttons are set up as IRQF_TRIGGER_RISING | IRQF_TRIGGER_FALLING.
It may be more appropriate to only wake the system on one edge, for example
if the gpio is for a Lid Switch.

Signed-off-by: Benson Leung <bleung@chromium.org>
---
 .../devicetree/bindings/gpio/gpio_keys.txt         |  7 +++++++
 drivers/input/keyboard/gpio_keys.c                 | 23 ++++++++++++++++++++--
 include/linux/gpio_keys.h                          |  3 +++
 3 files changed, 31 insertions(+), 2 deletions(-)

diff --git a/Documentation/devicetree/bindings/gpio/gpio_keys.txt b/Documentation/devicetree/bindings/gpio/gpio_keys.txt
index 5c2c021..243f569 100644
--- a/Documentation/devicetree/bindings/gpio/gpio_keys.txt
+++ b/Documentation/devicetree/bindings/gpio/gpio_keys.txt
@@ -20,6 +20,13 @@ Optional subnode-properties:
 	- debounce-interval: Debouncing interval time in milliseconds.
 	  If not specified defaults to 5.
 	- gpio-key,wakeup: Boolean, button can wake-up the system.
+	- gpio-key,wakeup-trigger : Specifies the type of wakeup behavior.
+	  <1> == Rising Edge Trigger
+	  <2> == Falling Edge Trigger
+	  <3> == Both Rising and Falling Edge Trigger
+	  <4> == Level High Trigger
+	  <8> == Level Low Trigger
+	  If not specified, defaults to <3> == Both Rising and Falling.
 
 Example nodes:
 
diff --git a/drivers/input/keyboard/gpio_keys.c b/drivers/input/keyboard/gpio_keys.c
index 440ce32..28b6992 100644
--- a/drivers/input/keyboard/gpio_keys.c
+++ b/drivers/input/keyboard/gpio_keys.c
@@ -40,6 +40,7 @@ struct gpio_button_data {
 	spinlock_t lock;
 	bool disabled;
 	bool key_pressed;
+	unsigned long irqflags;
 };
 
 struct gpio_keys_drvdata {
@@ -493,6 +494,8 @@ static int gpio_keys_setup_key(struct platform_device *pdev,
 		irqflags = 0;
 	}
 
+	bdata->irqflags = irqflags;
+
 	input_set_capability(input, button->type ?: EV_KEY, button->code);
 
 	/*
@@ -643,6 +646,9 @@ gpio_keys_get_devtree_pdata(struct device *dev)
 		if (of_property_read_u32(pp, "debounce-interval",
 					 &button->debounce_interval))
 			button->debounce_interval = 5;
+
+		of_property_read_u32(pp, "gpio-key,wakeup-trigger",
+				     &button->wakeup_trigger);
 	}
 
 	if (pdata->nbuttons == 0) {
@@ -811,8 +817,14 @@ static int gpio_keys_suspend(struct device *dev)
 	if (device_may_wakeup(dev)) {
 		for (i = 0; i < ddata->pdata->nbuttons; i++) {
 			struct gpio_button_data *bdata = &ddata->data[i];
-			if (bdata->button->wakeup)
+			if (bdata->button->wakeup) {
+				unsigned int flags;
+				flags = bdata->button->wakeup_trigger &
+					IRQF_TRIGGER_MASK;
+				if (flags && flags != bdata->irqflags)
+					irq_set_irq_type(bdata->irq, flags);
 				enable_irq_wake(bdata->irq);
+			}
 		}
 	} else {
 		mutex_lock(&input->mutex);
@@ -834,8 +846,15 @@ static int gpio_keys_resume(struct device *dev)
 	if (device_may_wakeup(dev)) {
 		for (i = 0; i < ddata->pdata->nbuttons; i++) {
 			struct gpio_button_data *bdata = &ddata->data[i];
-			if (bdata->button->wakeup)
+			if (bdata->button->wakeup) {
+				unsigned int flags;
+				flags = bdata->button->wakeup_trigger &
+					IRQF_TRIGGER_MASK;
 				disable_irq_wake(bdata->irq);
+				if (flags && flags != bdata->irqflags)
+					irq_set_irq_type(bdata->irq,
+							 bdata->irqflags);
+			}
 		}
 	} else {
 		mutex_lock(&input->mutex);
diff --git a/include/linux/gpio_keys.h b/include/linux/gpio_keys.h
index a7e977f..d8d5a4f 100644
--- a/include/linux/gpio_keys.h
+++ b/include/linux/gpio_keys.h
@@ -15,6 +15,9 @@ struct gpio_keys_button {
 	bool can_disable;
 	int value;		/* axis value for EV_ABS */
 	unsigned int irq;	/* Irq number in case of interrupt keys */
+
+	/* trigger value (IRQF_TRIGGER_*) while used as a wake-up source */
+	unsigned int wakeup_trigger;
 };
 
 struct gpio_keys_platform_data {
-- 
1.8.4

