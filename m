Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754753Ab3LSL5Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 06:57:16 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44776 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754711Ab3LSL5J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 06:57:09 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Russell King <rmk+kernel@arm.linux.org.uk>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 076/208] ARM: footbridge: fix EBSA285 LEDs
Date: Thu, 19 Dec 2013 11:52:54 +0000
Message-Id: <1387454106-19326-77-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1387454106-19326-1-git-send-email-luis.henriques@canonical.com>
References: <1387454106-19326-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Russell King <rmk+kernel@arm.linux.org.uk>

commit 67130c5464f50428aea0b4526a6729d61f9a1d53 upstream.

- The LEDs register is write-only: it can't be read-modify-written.
- The LEDs are write-1-for-off not 0.
- The check for the platform was inverted.

Fixes: cf6856d693dd ("ARM: mach-footbridge: retire custom LED code")
Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/arm/mach-footbridge/ebsa285.c | 22 +++++++++++++---------
 1 file changed, 13 insertions(+), 9 deletions(-)

diff --git a/arch/arm/mach-footbridge/ebsa285.c b/arch/arm/mach-footbridge/ebsa285.c
index b082435..1a7235f 100644
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
@@ -52,18 +55,19 @@ static enum led_brightness ebsa285_led_get(struct led_classdev *cdev)
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
-- 
1.8.3.2

