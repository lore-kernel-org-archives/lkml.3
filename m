Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752850Ab3CJLdl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Mar 2013 07:33:41 -0400
Received: from mail-in-06.arcor-online.net ([151.189.21.46]:44503 "EHLO
	mail-in-06.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751778Ab3CJLdE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Mar 2013 07:33:04 -0400
X-DKIM: Sendmail DKIM Filter v2.8.2 mail-in-18.arcor-online.net 36D633DC324
Subject: [PATCH 4/5] HID: roccat: Added support for IskuFX
From: Stefan Achatz <erazor_de@users.sourceforge.net>
Reply-To: erazor_de@users.sourceforge.net
To: Rob Landley <rob@landley.net>, Jiri Kosina <jkosina@suse.cz>,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-input@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 10 Mar 2013 12:33:02 +0100
Message-ID: <1362915182.2769.169.camel@neuromancer.tessier-ashpool>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 (2.30.3-1.fc13) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Extending isku module with one additional and one changed sysfs attr. IskuFX has
larger light sysfs attr. Made the code size tolerant so both devices can be
handled.

Signed-off-by: Stefan Achatz <erazor_de@users.sourceforge.net>
---
 .../ABI/testing/sysfs-driver-hid-roccat-isku       |   12 +++++++++++-
 drivers/hid/hid-ids.h                              |    1 +
 drivers/hid/hid-roccat-isku.c                      |   17 ++++++++++-------
 drivers/hid/hid-roccat-isku.h                      |    4 +++-
 4 files changed, 25 insertions(+), 9 deletions(-)

diff --git a/Documentation/ABI/testing/sysfs-driver-hid-roccat-isku b/Documentation/ABI/testing/sysfs-driver-hid-roccat-isku
index 9eca5a1..c601d0f 100644
--- a/Documentation/ABI/testing/sysfs-driver-hid-roccat-isku
+++ b/Documentation/ABI/testing/sysfs-driver-hid-roccat-isku
@@ -101,7 +101,8 @@ Date:		June 2011
 Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
 Description:	When written, this file lets one set the backlight intensity for
 		a specific profile. Profile number is included in written data.
-		The data has to be 10 bytes long.
+		The data has to be 10 bytes long for Isku, IskuFX needs	16 bytes
+		of data.
 		Before reading this file, control has to be written to select
 		which profile to read.
 Users:		http://roccat.sourceforge.net
@@ -141,3 +142,12 @@ Description:	When written, this file lets one trigger easyshift functionality
 		The data has to be 16 bytes long.
 		This file is writeonly.
 Users:		http://roccat.sourceforge.net
+
+What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/isku/roccatisku<minor>/talkfx
+Date:		February 2013
+Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
+Description:	When written, this file lets one trigger temporary color schemes
+		from the host.
+		The data has to be 16 bytes long.
+		This file is writeonly.
+Users:		http://roccat.sourceforge.net
diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index 007ee74..a2e767b 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -687,6 +687,7 @@
 #define USB_VENDOR_ID_ROCCAT		0x1e7d
 #define USB_DEVICE_ID_ROCCAT_ARVO	0x30d4
 #define USB_DEVICE_ID_ROCCAT_ISKU	0x319c
+#define USB_DEVICE_ID_ROCCAT_ISKUFX	0x3264
 #define USB_DEVICE_ID_ROCCAT_KONE	0x2ced
 #define USB_DEVICE_ID_ROCCAT_KONEPLUS	0x2d51
 #define USB_DEVICE_ID_ROCCAT_KONEPURE	0x2dbe
diff --git a/drivers/hid/hid-roccat-isku.c b/drivers/hid/hid-roccat-isku.c
index 8ac83bb..aea9280 100644
--- a/drivers/hid/hid-roccat-isku.c
+++ b/drivers/hid/hid-roccat-isku.c
@@ -122,14 +122,14 @@ static ssize_t isku_sysfs_read(struct file *fp, struct kobject *kobj,
 	if (off >= real_size)
 		return 0;
 
-	if (off != 0 || count != real_size)
+	if (off != 0 || count > real_size)
 		return -EINVAL;
 
 	mutex_lock(&isku->isku_lock);
-	retval = isku_receive(usb_dev, command, buf, real_size);
+	retval = isku_receive(usb_dev, command, buf, count);
 	mutex_unlock(&isku->isku_lock);
 
-	return retval ? retval : real_size;
+	return retval ? retval : count;
 }
 
 static ssize_t isku_sysfs_write(struct file *fp, struct kobject *kobj,
@@ -142,15 +142,15 @@ static ssize_t isku_sysfs_write(struct file *fp, struct kobject *kobj,
 	struct usb_device *usb_dev = interface_to_usbdev(to_usb_interface(dev));
 	int retval;
 
-	if (off != 0 || count != real_size)
+	if (off != 0 || count > real_size)
 		return -EINVAL;
 
 	mutex_lock(&isku->isku_lock);
 	retval = roccat_common2_send_with_status(usb_dev, command,
-			(void *)buf, real_size);
+			(void *)buf, count);
 	mutex_unlock(&isku->isku_lock);
 
-	return retval ? retval : real_size;
+	return retval ? retval : count;
 }
 
 #define ISKU_SYSFS_W(thingy, THINGY) \
@@ -208,6 +208,7 @@ ISKU_SYSFS_RW(light, LIGHT)
 ISKU_SYSFS_RW(key_mask, KEY_MASK)
 ISKU_SYSFS_RW(last_set, LAST_SET)
 ISKU_SYSFS_W(talk, TALK)
+ISKU_SYSFS_W(talkfx, TALKFX)
 ISKU_SYSFS_R(info, INFO)
 ISKU_SYSFS_W(control, CONTROL)
 ISKU_SYSFS_W(reset, RESET)
@@ -224,6 +225,7 @@ static struct bin_attribute isku_bin_attributes[] = {
 	ISKU_BIN_ATTR_RW(key_mask, KEY_MASK),
 	ISKU_BIN_ATTR_RW(last_set, LAST_SET),
 	ISKU_BIN_ATTR_W(talk, TALK),
+	ISKU_BIN_ATTR_W(talkfx, TALKFX),
 	ISKU_BIN_ATTR_R(info, INFO),
 	ISKU_BIN_ATTR_W(control, CONTROL),
 	ISKU_BIN_ATTR_W(reset, RESET),
@@ -369,6 +371,7 @@ static int isku_raw_event(struct hid_device *hdev,
 
 static const struct hid_device_id isku_devices[] = {
 	{ HID_USB_DEVICE(USB_VENDOR_ID_ROCCAT, USB_DEVICE_ID_ROCCAT_ISKU) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_ROCCAT, USB_DEVICE_ID_ROCCAT_ISKUFX) },
 	{ }
 };
 
@@ -407,5 +410,5 @@ module_init(isku_init);
 module_exit(isku_exit);
 
 MODULE_AUTHOR("Stefan Achatz");
-MODULE_DESCRIPTION("USB Roccat Isku driver");
+MODULE_DESCRIPTION("USB Roccat Isku/FX driver");
 MODULE_LICENSE("GPL v2");
diff --git a/drivers/hid/hid-roccat-isku.h b/drivers/hid/hid-roccat-isku.h
index 102cb1e..35de150 100644
--- a/drivers/hid/hid-roccat-isku.h
+++ b/drivers/hid/hid-roccat-isku.h
@@ -25,10 +25,11 @@ enum {
 	ISKU_SIZE_KEYS_MACRO = 0x23,
 	ISKU_SIZE_KEYS_CAPSLOCK = 0x06,
 	ISKU_SIZE_LAST_SET = 0x14,
-	ISKU_SIZE_LIGHT = 0x0a,
+	ISKU_SIZE_LIGHT = 0x10,
 	ISKU_SIZE_MACRO = 0x823,
 	ISKU_SIZE_RESET = 0x03,
 	ISKU_SIZE_TALK = 0x10,
+	ISKU_SIZE_TALKFX = 0x10,
 };
 
 enum {
@@ -59,6 +60,7 @@ enum isku_commands {
 	ISKU_COMMAND_LAST_SET = 0x14,
 	ISKU_COMMAND_15 = 0x15,
 	ISKU_COMMAND_TALK = 0x16,
+	ISKU_COMMAND_TALKFX = 0x17,
 	ISKU_COMMAND_FIRMWARE_WRITE = 0x1b,
 	ISKU_COMMAND_FIRMWARE_WRITE_CONTROL = 0x1c,
 };
-- 
1.7.3.4



