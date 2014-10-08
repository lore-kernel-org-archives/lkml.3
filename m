Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754125AbaJHS0G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 14:26:06 -0400
Received: from mail-pd0-f181.google.com ([209.85.192.181]:53067 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751928AbaJHS0E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 14:26:04 -0400
From: Jason Gerecke <killertofu@gmail.com>
To: jkosina@suse.cz, benjamin.tissoires@gmail.com, pinglinux@gmail.com
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jason Gerecke <killertofu@gmail.com>
Subject: [PATCH v2] HID: wacom: Prevent potential null dereference after disconnect
Date: Wed,  8 Oct 2014 11:25:42 -0700
Message-Id: <1412792742-4075-1-git-send-email-killertofu@gmail.com>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <1412704473-6708-1-git-send-email-killertofu@gmail.com>
References: <1412704473-6708-1-git-send-email-killertofu@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Repeated connect/disconnect cycles under GNOME can trigger an occasional
OOPS from within e.g. wacom_led_select_store, presumably due to a timing
issue where userspace begins setting a value immediately before the
device disconnects and our shared data is whisked away.

Signed-off-by: Jason Gerecke <killertofu@gmail.com>
---
Changes in v2:
 * Added in missing escape character

 drivers/hid/wacom_sys.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/drivers/hid/wacom_sys.c b/drivers/hid/wacom_sys.c
index 8593047..265429b 100644
--- a/drivers/hid/wacom_sys.c
+++ b/drivers/hid/wacom_sys.c
@@ -641,6 +641,9 @@ static ssize_t wacom_led_select_store(struct device *dev, int set_id,
 	unsigned int id;
 	int err;
 
+	if (!wacom)
+		return -ENODEV;
+
 	err = kstrtouint(buf, 10, &id);
 	if (err)
 		return err;
@@ -666,6 +669,8 @@ static ssize_t wacom_led##SET_ID##_select_show(struct device *dev,	\
 {									\
 	struct hid_device *hdev = container_of(dev, struct hid_device, dev);\
 	struct wacom *wacom = hid_get_drvdata(hdev);			\
+	if (!wacom)							\
+		return -ENODEV;						\
 	return scnprintf(buf, PAGE_SIZE, "%d\n",			\
 			 wacom->led.select[SET_ID]);			\
 }									\
@@ -702,7 +707,8 @@ static ssize_t wacom_##name##_luminance_store(struct device *dev,	\
 {									\
 	struct hid_device *hdev = container_of(dev, struct hid_device, dev);\
 	struct wacom *wacom = hid_get_drvdata(hdev);			\
-									\
+	if (!wacom)							\
+		return -ENODEV;						\
 	return wacom_luminance_store(wacom, &wacom->led.field,		\
 				     buf, count);			\
 }									\
@@ -710,6 +716,8 @@ static ssize_t wacom_##name##_luminance_show(struct device *dev,	\
 	struct device_attribute *attr, char *buf)			\
 {									\
 	struct wacom *wacom = dev_get_drvdata(dev);			\
+	if (!wacom)							\
+		return -ENODEV;						\
 	return scnprintf(buf, PAGE_SIZE, "%d\n", wacom->led.field);	\
 }									\
 static DEVICE_ATTR(name##_luminance, DEV_ATTR_RW_PERM,			\
@@ -729,6 +737,9 @@ static ssize_t wacom_button_image_store(struct device *dev, int button_id,
 	unsigned len;
 	u8 xfer_id;
 
+	if (!wacom)
+		return -ENODEV;
+
 	if (hdev->bus == BUS_BLUETOOTH) {
 		len = 256;
 		xfer_id = WAC_CMD_ICON_BT_XFER;
-- 
2.1.2

