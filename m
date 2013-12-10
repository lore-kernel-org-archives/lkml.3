Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754988Ab3LJIUy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 03:20:54 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:58834 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753382Ab3LJIBX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 03:01:23 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Russell King <rmk+kernel@arm.linux.org.uk>
Subject: [PATCH 3.12 14/62] ARM: footbridge: fix EBSA285 LEDs
Date: Tue, 10 Dec 2013 00:00:45 -0800
Message-Id: <20131210080058.441824263@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.rc3
In-Reply-To: <20131210080057.415644748@linuxfoundation.org>
References: <20131210080057.415644748@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Russell King <rmk+kernel@arm.linux.org.uk>

commit 67130c5464f50428aea0b4526a6729d61f9a1d53 upstream.

- The LEDs register is write-only: it can't be read-modify-written.
- The LEDs are write-1-for-off not 0.
- The check for the platform was inverted.

Fixes: cf6856d693dd ("ARM: mach-footbridge: retire custom LED code")
Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/mach-footbridge/ebsa285.c |   22 +++++++++++++---------
 1 file changed, 13 insertions(+), 9 deletions(-)

--- a/arch/arm/mach-footbridge/ebsa285.c
+++ b/arch/arm/mach-footbridge/ebsa285.c
@@ -30,21 +30,24 @@ static const struct {
 	const char *name;
 	const char *trigger;
 } ebsa285_leds[] = {
-	{ "ebsa285:amber", "heartbeat", },
-	{ "ebsa285:green", "cpu0", },
+	{ "ebsa285:amber", "cpu0", },
+	{ "ebsa285:green", "heartbeat", },
 	{ "ebsa285:red",},
 };
 
+static unsigned char hw_led_state;
+
 static void ebsa285_led_set(struct led_classdev *cdev,
 		enum led_brightness b)
 {
 	struct ebsa285_led *led = container_of(cdev,
 			struct ebsa285_led, cdev);
 
-	if (b != LED_OFF)
-		*XBUS_LEDS |= led->mask;
+	if (b == LED_OFF)
+		hw_led_state |= led->mask;
 	else
-		*XBUS_LEDS &= ~led->mask;
+		hw_led_state &= ~led->mask;
+	*XBUS_LEDS = hw_led_state;
 }
 
 static enum led_brightness ebsa285_led_get(struct led_classdev *cdev)
@@ -52,18 +55,19 @@ static enum led_brightness ebsa285_led_g
 	struct ebsa285_led *led = container_of(cdev,
 			struct ebsa285_led, cdev);
 
-	return (*XBUS_LEDS & led->mask) ? LED_FULL : LED_OFF;
+	return hw_led_state & led->mask ? LED_OFF : LED_FULL;
 }
 
 static int __init ebsa285_leds_init(void)
 {
 	int i;
 
-	if (machine_is_ebsa285())
+	if (!machine_is_ebsa285())
 		return -ENODEV;
 
-	/* 3 LEDS All ON */
-	*XBUS_LEDS |= XBUS_LED_AMBER | XBUS_LED_GREEN | XBUS_LED_RED;
+	/* 3 LEDS all off */
+	hw_led_state = XBUS_LED_AMBER | XBUS_LED_GREEN | XBUS_LED_RED;
+	*XBUS_LEDS = hw_led_state;
 
 	for (i = 0; i < ARRAY_SIZE(ebsa285_leds); i++) {
 		struct ebsa285_led *led;


