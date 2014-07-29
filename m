Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754048AbaG2SpU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 14:45:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53007 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751466AbaG2Sn3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 14:43:29 -0400
From: Benjamin Tissoires <benjamin.tissoires@redhat.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        Ping Cheng <pinglinux@gmail.com>, Jason Gerecke <killertofu@gmail.com>,
        Przemo Firszt <przemo@firszt.eu>
Cc: linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
Subject: [PATCH v3 4/7] Input - wacom: Check for bluetooth protocol while setting OLEDs
Date: Tue, 29 Jul 2014 14:43:02 -0400
Message-Id: <1406659385-3256-5-git-send-email-benjamin.tissoires@redhat.com>
In-Reply-To: <1406659385-3256-1-git-send-email-benjamin.tissoires@redhat.com>
References: <1406659385-3256-1-git-send-email-benjamin.tissoires@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bluetooth Intuos 4 use 1-bit definition while the USB ones use a 4-bits
definition. This changes the size of the raw image we receive, and thus
the kernel will only accept 1-bit images for Bluetooth and 4-bits for
USB.

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
---
 drivers/hid/wacom_sys.c | 29 +++++++++++++++++++++--------
 1 file changed, 21 insertions(+), 8 deletions(-)

diff --git a/drivers/hid/wacom_sys.c b/drivers/hid/wacom_sys.c
index f5c9c56..a12cd9c 100644
--- a/drivers/hid/wacom_sys.c
+++ b/drivers/hid/wacom_sys.c
@@ -20,6 +20,7 @@
 #define WAC_CMD_LED_CONTROL	0x20
 #define WAC_CMD_ICON_START	0x21
 #define WAC_CMD_ICON_XFER	0x23
+#define WAC_CMD_ICON_BT_XFER	0x26
 #define WAC_CMD_RETRIES		10
 
 static int wacom_get_report(struct hid_device *hdev, u8 type, u8 id,
@@ -526,12 +527,14 @@ static int wacom_led_control(struct wacom *wacom)
 	return retval;
 }
 
-static int wacom_led_putimage(struct wacom *wacom, int button_id, const void *img)
+static int wacom_led_putimage(struct wacom *wacom, int button_id, u8 xfer_id,
+		const unsigned len, const void *img)
 {
 	unsigned char *buf;
 	int i, retval;
+	const unsigned chunk_len = len / 4; /* 4 chunks are needed to be sent */
 
-	buf = kzalloc(259, GFP_KERNEL);
+	buf = kzalloc(chunk_len + 3 , GFP_KERNEL);
 	if (!buf)
 		return -ENOMEM;
 
@@ -543,15 +546,15 @@ static int wacom_led_putimage(struct wacom *wacom, int button_id, const void *im
 	if (retval < 0)
 		goto out;
 
-	buf[0] = WAC_CMD_ICON_XFER;
+	buf[0] = xfer_id;
 	buf[1] = button_id & 0x07;
 	for (i = 0; i < 4; i++) {
 		buf[2] = i;
-		memcpy(buf + 3, img + i * 256, 256);
+		memcpy(buf + 3, img + i * chunk_len, chunk_len);
 
 		retval = wacom_set_report(wacom->hdev, HID_FEATURE_REPORT,
-					  WAC_CMD_ICON_XFER,
-					  buf, 259, WAC_CMD_RETRIES);
+					  xfer_id, buf, chunk_len + 3,
+					  WAC_CMD_RETRIES);
 		if (retval < 0)
 			break;
 	}
@@ -652,13 +655,23 @@ static ssize_t wacom_button_image_store(struct device *dev, int button_id,
 	struct hid_device *hdev = container_of(dev, struct hid_device, dev);
 	struct wacom *wacom = hid_get_drvdata(hdev);
 	int err;
+	unsigned len;
+	u8 xfer_id;
 
-	if (count != 1024)
+	if (hdev->bus == BUS_BLUETOOTH) {
+		len = 256;
+		xfer_id = WAC_CMD_ICON_BT_XFER;
+	} else {
+		len = 1024;
+		xfer_id = WAC_CMD_ICON_XFER;
+	}
+
+	if (count != len)
 		return -EINVAL;
 
 	mutex_lock(&wacom->lock);
 
-	err = wacom_led_putimage(wacom, button_id, buf);
+	err = wacom_led_putimage(wacom, button_id, xfer_id, len, buf);
 
 	mutex_unlock(&wacom->lock);
 
-- 
2.0.3

