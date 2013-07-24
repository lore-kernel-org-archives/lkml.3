Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753445Ab3GXORs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 10:17:48 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:45816 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752406Ab3GXOGs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 10:06:48 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Dmitry Torokhov" <rydberg@euromail.se>,
        "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
Date: Wed, 24 Jul 2013 15:02:45 +0100
Message-ID: <lsq.1374674565.258792026@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [63/85] Input: bcm5974 - add support for the 2013 MacBook Air
In-Reply-To: <lsq.1374674564.753305150@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.49-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Torokhov <rydberg@euromail.se>

commit 148c1c8ad3c4170186ebe6ea5900adde27d2a0e7 upstream.

The June 2013 Macbook Air (13'') has a new trackpad protocol; four new
values are inserted in the header, and the mode switch is no longer
needed. This patch adds support for the new devices.

Reported-and-tested-by: Brad Ford <plymouthffl@gmail.com>
Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
[bwh: Backported to 3.2: format of limits in bcm5974 changed]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/input/mouse/bcm5974.c | 36 ++++++++++++++++++++++++++++++++++--
 1 file changed, 34 insertions(+), 2 deletions(-)

--- a/drivers/input/mouse/bcm5974.c
+++ b/drivers/input/mouse/bcm5974.c
@@ -87,6 +87,10 @@
 #define USB_DEVICE_ID_APPLE_WELLSPRING7A_ANSI	0x0259
 #define USB_DEVICE_ID_APPLE_WELLSPRING7A_ISO	0x025a
 #define USB_DEVICE_ID_APPLE_WELLSPRING7A_JIS	0x025b
+/* MacbookAir6,2 (unibody, June 2013) */
+#define USB_DEVICE_ID_APPLE_WELLSPRING8_ANSI	0x0291
+#define USB_DEVICE_ID_APPLE_WELLSPRING8_ISO	0x0292
+#define USB_DEVICE_ID_APPLE_WELLSPRING8_JIS	0x0293
 
 #define BCM5974_DEVICE(prod) {					\
 	.match_flags = (USB_DEVICE_ID_MATCH_DEVICE |		\
@@ -144,6 +148,10 @@ static const struct usb_device_id bcm597
 	BCM5974_DEVICE(USB_DEVICE_ID_APPLE_WELLSPRING7A_ANSI),
 	BCM5974_DEVICE(USB_DEVICE_ID_APPLE_WELLSPRING7A_ISO),
 	BCM5974_DEVICE(USB_DEVICE_ID_APPLE_WELLSPRING7A_JIS),
+	/* MacbookAir6,2 */
+	BCM5974_DEVICE(USB_DEVICE_ID_APPLE_WELLSPRING8_ANSI),
+	BCM5974_DEVICE(USB_DEVICE_ID_APPLE_WELLSPRING8_ISO),
+	BCM5974_DEVICE(USB_DEVICE_ID_APPLE_WELLSPRING8_JIS),
 	/* Terminating entry */
 	{}
 };
@@ -171,15 +179,18 @@ struct bt_data {
 /* trackpad header types */
 enum tp_type {
 	TYPE1,			/* plain trackpad */
-	TYPE2			/* button integrated in trackpad */
+	TYPE2,			/* button integrated in trackpad */
+	TYPE3			/* additional header fields since June 2013 */
 };
 
 /* trackpad finger data offsets, le16-aligned */
 #define FINGER_TYPE1		(13 * sizeof(__le16))
 #define FINGER_TYPE2		(15 * sizeof(__le16))
+#define FINGER_TYPE3		(19 * sizeof(__le16))
 
 /* trackpad button data offsets */
 #define BUTTON_TYPE2		15
+#define BUTTON_TYPE3		23
 
 /* list of device capability bits */
 #define HAS_INTEGRATED_BUTTON	1
@@ -394,6 +405,18 @@ static const struct bcm5974_config bcm59
 		{ DIM_X, DIM_X / SN_COORD, -4750, 5280 },
 		{ DIM_Y, DIM_Y / SN_COORD, -150, 6730 }
 	},
+	{
+		USB_DEVICE_ID_APPLE_WELLSPRING8_ANSI,
+		USB_DEVICE_ID_APPLE_WELLSPRING8_ISO,
+		USB_DEVICE_ID_APPLE_WELLSPRING8_JIS,
+		HAS_INTEGRATED_BUTTON,
+		0, sizeof(struct bt_data),
+		0x83, TYPE3, FINGER_TYPE3, FINGER_TYPE3 + SIZEOF_ALL_FINGERS,
+		{ DIM_PRESSURE, DIM_PRESSURE / SN_PRESSURE, 0, 300 },
+		{ DIM_WIDTH, DIM_WIDTH / SN_WIDTH, 0, 2048 },
+		{ DIM_X, DIM_X / SN_COORD, -4620, 5140 },
+		{ DIM_Y, DIM_Y / SN_COORD, -150, 6600 },
+	},
 	{}
 };
 
@@ -604,6 +627,9 @@ static int report_tp_state(struct bcm597
 	if (c->tp_type == TYPE2)
 		input_report_key(input, BTN_LEFT, ibt);
 
+	if (c->tp_type == TYPE3)
+		input_report_key(input, BTN_LEFT, dev->tp_data[BUTTON_TYPE3]);
+
 	input_sync(input);
 
 	return 0;
@@ -619,9 +645,14 @@ static int report_tp_state(struct bcm597
 
 static int bcm5974_wellspring_mode(struct bcm5974 *dev, bool on)
 {
-	char *data = kmalloc(8, GFP_KERNEL);
 	int retval = 0, size;
+	char *data;
+
+	/* Type 3 does not require a mode switch */
+	if (dev->cfg.tp_type == TYPE3)
+		return 0;
 
+	data = kmalloc(8, GFP_KERNEL);
 	if (!data) {
 		err("bcm5974: out of memory");
 		retval = -ENOMEM;

