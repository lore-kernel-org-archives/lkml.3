Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934286AbaGXSOn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 14:14:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59743 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933705AbaGXSOj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 14:14:39 -0400
From: Benjamin Tissoires <benjamin.tissoires@redhat.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        Ping Cheng <pinglinux@gmail.com>, Jason Gerecke <killertofu@gmail.com>,
        Przemo Firszt <przemo@firszt.eu>
Cc: linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
Subject: [PATCH v2 02/10] Input - wacom: put a flag when the led are initialized
Date: Thu, 24 Jul 2014 14:13:57 -0400
Message-Id: <1406225645-32141-3-git-send-email-benjamin.tissoires@redhat.com>
In-Reply-To: <1406225645-32141-1-git-send-email-benjamin.tissoires@redhat.com>
References: <1406225645-32141-1-git-send-email-benjamin.tissoires@redhat.com>
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
Acked-by: Ping Cheng <pingc@wacom.com>
---

no changes in v2

 drivers/hid/wacom.h     | 1 +
 drivers/hid/wacom_sys.c | 6 ++++++
 2 files changed, 7 insertions(+)

diff --git a/drivers/hid/wacom.h b/drivers/hid/wacom.h
index dd67b7d..a678f82 100644
--- a/drivers/hid/wacom.h
+++ b/drivers/hid/wacom.h
@@ -118,6 +118,7 @@ struct wacom {
 		u8 hlv;       /* status led brightness button pressed (1..127) */
 		u8 img_lum;   /* OLED matrix display brightness */
 	} led;
+	bool led_initialized;
 	struct power_supply battery;
 };
 
diff --git a/drivers/hid/wacom_sys.c b/drivers/hid/wacom_sys.c
index 9dbb6dd..c857b3d 100644
--- a/drivers/hid/wacom_sys.c
+++ b/drivers/hid/wacom_sys.c
@@ -729,12 +729,18 @@ static int wacom_initialize_leds(struct wacom *wacom)
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
2.0.1

