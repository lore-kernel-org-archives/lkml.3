Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753749AbaFMU3g (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 16:29:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38616 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753427AbaFMU3e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 16:29:34 -0400
From: Benjamin Tissoires <benjamin.tissoires@redhat.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Ping Cheng <pinglinux@gmail.com>, Jason Gerecke <killertofu@gmail.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] Input - wacom: put a flag when the led are initialized
Date: Fri, 13 Jun 2014 16:29:32 -0400
Message-Id: <1402691372-26282-1-git-send-email-benjamin.tissoires@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This solves a bug with the wireless receiver:
- at plug, the wireless receiver does not know which Wacom device it is
  connected to, so it does not actually creates all the LEDs
- when the tablet connects, wacom->wacom_wac.features.type is set to the
  proper device so that wacom_wac can understand the packets
- when the receiver is unplugged, it detects that a LED should have been
  created (based on wacom->wacom_wac.features.type) and tries to remove
  it: crash when removing the sysfs group.

Side effect, we can now safely call several times wacom_destroy_leds().

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
---
 drivers/input/tablet/wacom.h     | 1 +
 drivers/input/tablet/wacom_sys.c | 6 ++++++
 2 files changed, 7 insertions(+)

diff --git a/drivers/input/tablet/wacom.h b/drivers/input/tablet/wacom.h
index 70b1e71..f13ad31 100644
--- a/drivers/input/tablet/wacom.h
+++ b/drivers/input/tablet/wacom.h
@@ -120,6 +120,7 @@ struct wacom {
 		u8 hlv;       /* status led brightness button pressed (1..127) */
 		u8 img_lum;   /* OLED matrix display brightness */
 	} led;
+	bool led_initialized;
 	struct power_supply battery;
 };
 
diff --git a/drivers/input/tablet/wacom_sys.c b/drivers/input/tablet/wacom_sys.c
index 94096fd..7087b33 100644
--- a/drivers/input/tablet/wacom_sys.c
+++ b/drivers/input/tablet/wacom_sys.c
@@ -1016,12 +1016,18 @@ static int wacom_initialize_leds(struct wacom *wacom)
 		return error;
 	}
 	wacom_led_control(wacom);
+	wacom->led_initialized = true;
 
 	return 0;
 }
 
 static void wacom_destroy_leds(struct wacom *wacom)
 {
+	if (!wacom->led_initialized)
+		return;
+
+	wacom->led_initialized = false;
+
 	switch (wacom->wacom_wac.features.type) {
 	case INTUOS4S:
 	case INTUOS4:
-- 
1.9.0

