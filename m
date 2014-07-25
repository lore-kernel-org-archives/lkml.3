Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753633AbaGYXUc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 19:20:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53543 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751168AbaGYXUb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 19:20:31 -0400
From: Benjamin Tissoires <benjamin.tissoires@redhat.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        Ping Cheng <pinglinux@gmail.com>, Jason Gerecke <killertofu@gmail.com>,
        Przemo Firszt <przemo@firszt.eu>
Cc: linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
Subject: [PATCH 11/10] Input - wacom: Check for bluetooth protocol while setting OLEDs
Date: Fri, 25 Jul 2014 19:20:11 -0400
Message-Id: <1406330411-7851-1-git-send-email-benjamin.tissoires@redhat.com>
In-Reply-To: <1406225645-32141-1-git-send-email-benjamin.tissoires@redhat.com>
References: <1406225645-32141-1-git-send-email-benjamin.tissoires@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bluetooth Intuos 4 use 1-bit definition while the USB ones use a 4-bits
definition. This changes the size of the raw image we receive, and thus
the kernel will only accept 1-bit images for Bluetooth and 4-bits for
USB.

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
---
 drivers/hid/wacom_sys.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/drivers/hid/wacom_sys.c b/drivers/hid/wacom_sys.c
index 3adc6ef..42f139f 100644
--- a/drivers/hid/wacom_sys.c
+++ b/drivers/hid/wacom_sys.c
@@ -531,12 +531,14 @@ static int wacom_led_control(struct wacom *wacom)
 	return retval;
 }
 
-static int wacom_led_putimage(struct wacom *wacom, int button_id, const void *img)
+static int wacom_led_putimage(struct wacom *wacom, int button_id,
+		const unsigned len, const void *img)
 {
 	unsigned char *buf;
 	int i, retval;
+	const unsigned chunk_len = len / 4; /* 4 chunks are needed to be sent */
 
-	buf = kzalloc(259, GFP_KERNEL);
+	buf = kzalloc(chunk_len + 3 , GFP_KERNEL);
 	if (!buf)
 		return -ENOMEM;
 
@@ -552,11 +554,11 @@ static int wacom_led_putimage(struct wacom *wacom, int button_id, const void *im
 	buf[1] = button_id & 0x07;
 	for (i = 0; i < 4; i++) {
 		buf[2] = i;
-		memcpy(buf + 3, img + i * 256, 256);
+		memcpy(buf + 3, img + i * chunk_len, chunk_len);
 
 		retval = wacom_set_report(wacom->hdev, HID_FEATURE_REPORT,
 					  WAC_CMD_ICON_XFER,
-					  buf, 259, WAC_CMD_RETRIES);
+					  buf, chunk_len + 3, WAC_CMD_RETRIES);
 		if (retval < 0)
 			break;
 	}
@@ -657,13 +659,14 @@ static ssize_t wacom_button_image_store(struct device *dev, int button_id,
 	struct hid_device *hdev = container_of(dev, struct hid_device, dev);
 	struct wacom *wacom = hid_get_drvdata(hdev);
 	int err;
+	const unsigned len = hdev->bus == BUS_BLUETOOTH ? 256 : 1024;
 
-	if (count != 1024)
+	if (count != len)
 		return -EINVAL;
 
 	mutex_lock(&wacom->lock);
 
-	err = wacom_led_putimage(wacom, button_id, buf);
+	err = wacom_led_putimage(wacom, button_id, len, buf);
 
 	mutex_unlock(&wacom->lock);
 
-- 
2.0.1

