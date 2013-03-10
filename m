Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752609Ab3CJLdC (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Mar 2013 07:33:02 -0400
Received: from mail-in-06.arcor-online.net ([151.189.21.46]:44422 "EHLO
	mail-in-06.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751965Ab3CJLc6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Mar 2013 07:32:58 -0400
X-DKIM: Sendmail DKIM Filter v2.8.2 mail-in-18.arcor-online.net 9890D3DC327
Subject: [PATCH 2/5] HID: roccat: Removed actual profile from chardev
 reports
From: Stefan Achatz <erazor_de@users.sourceforge.net>
Reply-To: erazor_de@users.sourceforge.net
To: Rob Landley <rob@landley.net>, Jiri Kosina <jkosina@suse.cz>,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-input@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 10 Mar 2013 12:32:55 +0100
Message-ID: <1362915175.2769.167.camel@neuromancer.tessier-ashpool>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 (2.30.3-1.fc13) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Userland-tools now keep track of actual profile themselves.
Spared out Pyra, which is a harder case.

Signed-off-by: Stefan Achatz <erazor_de@users.sourceforge.net>
---
 drivers/hid/hid-roccat-arvo.c     |   25 +++++++-----------
 drivers/hid/hid-roccat-arvo.h     |    4 +--
 drivers/hid/hid-roccat-isku.c     |   48 +++++++-----------------------------
 drivers/hid/hid-roccat-isku.h     |    4 +--
 drivers/hid/hid-roccat-koneplus.c |   49 +++++++------------------------------
 drivers/hid/hid-roccat-koneplus.h |    4 +--
 drivers/hid/hid-roccat-kovaplus.c |   15 +++++++----
 drivers/hid/hid-roccat-kovaplus.h |    3 +-
 8 files changed, 41 insertions(+), 111 deletions(-)

diff --git a/drivers/hid/hid-roccat-arvo.c b/drivers/hid/hid-roccat-arvo.c
index 327f9b8..d4eabc2 100644
--- a/drivers/hid/hid-roccat-arvo.c
+++ b/drivers/hid/hid-roccat-arvo.c
@@ -142,10 +142,15 @@ static int arvo_get_actual_profile(struct usb_device *usb_dev)
 static ssize_t arvo_sysfs_show_actual_profile(struct device *dev,
 		struct device_attribute *attr, char *buf)
 {
-	struct arvo_device *arvo =
-			hid_get_drvdata(dev_get_drvdata(dev->parent->parent));
+	struct usb_device *usb_dev =
+			interface_to_usbdev(to_usb_interface(dev->parent->parent));
+	int retval;
+
+	retval = arvo_get_actual_profile(usb_dev);
+	if (retval < 0)
+		return retval;
 
-	return snprintf(buf, PAGE_SIZE, "%d\n", arvo->actual_profile);
+	return snprintf(buf, PAGE_SIZE, "%d\n", retval);
 }
 
 static ssize_t arvo_sysfs_set_actual_profile(struct device *dev,
@@ -172,10 +177,9 @@ static ssize_t arvo_sysfs_set_actual_profile(struct device *dev,
 	mutex_lock(&arvo->arvo_lock);
 	retval = roccat_common2_send(usb_dev, ARVO_COMMAND_ACTUAL_PROFILE,
 			&temp_buf, sizeof(struct arvo_actual_profile));
-	if (!retval) {
-		arvo->actual_profile = profile;
+	if (!retval)
 		retval = size;
-	}
+
 	mutex_unlock(&arvo->arvo_lock);
 	return retval;
 }
@@ -268,15 +272,7 @@ static struct bin_attribute arvo_bin_attributes[] = {
 static int arvo_init_arvo_device_struct(struct usb_device *usb_dev,
 		struct arvo_device *arvo)
 {
-	int retval;
-
 	mutex_init(&arvo->arvo_lock);
-
-	retval = arvo_get_actual_profile(usb_dev);
-	if (retval < 0)
-		return retval;
-	arvo->actual_profile = retval;
-
 	return 0;
 }
 
@@ -381,7 +377,6 @@ static void arvo_report_to_chrdev(struct arvo_device const *arvo,
 
 	special_report = (struct arvo_special_report const *)data;
 
-	roccat_report.profile = arvo->actual_profile;
 	roccat_report.button = special_report->event &
 			ARVO_SPECIAL_REPORT_EVENT_MASK_BUTTON;
 	if ((special_report->event & ARVO_SPECIAL_REPORT_EVENT_MASK_ACTION) ==
diff --git a/drivers/hid/hid-roccat-arvo.h b/drivers/hid/hid-roccat-arvo.h
index ce8415e..d3b2fe9 100644
--- a/drivers/hid/hid-roccat-arvo.h
+++ b/drivers/hid/hid-roccat-arvo.h
@@ -63,7 +63,7 @@ enum arvo_special_report_event_masks {
 };
 
 struct arvo_roccat_report {
-	uint8_t profile;
+	uint8_t unused;
 	uint8_t button;
 	uint8_t action;
 } __packed;
@@ -78,8 +78,6 @@ struct arvo_device {
 	int chrdev_minor;
 
 	struct mutex arvo_lock;
-
-	int actual_profile;
 };
 
 #endif
diff --git a/drivers/hid/hid-roccat-isku.c b/drivers/hid/hid-roccat-isku.c
index 1219998..b43c792 100644
--- a/drivers/hid/hid-roccat-isku.c
+++ b/drivers/hid/hid-roccat-isku.c
@@ -28,11 +28,6 @@
 
 static struct class *isku_class;
 
-static void isku_profile_activated(struct isku_device *isku, uint new_profile)
-{
-	isku->actual_profile = new_profile;
-}
-
 static int isku_receive(struct usb_device *usb_dev, uint command,
 		void *buf, uint size)
 {
@@ -64,9 +59,15 @@ static int isku_set_actual_profile(struct usb_device *usb_dev, int new_profile)
 static ssize_t isku_sysfs_show_actual_profile(struct device *dev,
 		struct device_attribute *attr, char *buf)
 {
-	struct isku_device *isku =
-			hid_get_drvdata(dev_get_drvdata(dev->parent->parent));
-	return snprintf(buf, PAGE_SIZE, "%d\n", isku->actual_profile);
+	struct usb_device *usb_dev =
+			interface_to_usbdev(to_usb_interface(dev->parent->parent));
+	int retval;
+
+	retval = isku_get_actual_profile(usb_dev);
+	if (retval < 0)
+		return retval;
+
+	return snprintf(buf, PAGE_SIZE, "%d\n", retval);
 }
 
 static ssize_t isku_sysfs_set_actual_profile(struct device *dev,
@@ -97,12 +98,9 @@ static ssize_t isku_sysfs_set_actual_profile(struct device *dev,
 		return retval;
 	}
 
-	isku_profile_activated(isku, profile);
-
 	roccat_report.event = ISKU_REPORT_BUTTON_EVENT_PROFILE;
 	roccat_report.data1 = profile + 1;
 	roccat_report.data2 = 0;
-	roccat_report.profile = profile + 1;
 	roccat_report_event(isku->chrdev_minor, (uint8_t const *)&roccat_report);
 
 	mutex_unlock(&isku->isku_lock);
@@ -241,15 +239,7 @@ static struct bin_attribute isku_bin_attributes[] = {
 static int isku_init_isku_device_struct(struct usb_device *usb_dev,
 		struct isku_device *isku)
 {
-	int retval;
-
 	mutex_init(&isku->isku_lock);
-
-	retval = isku_get_actual_profile(usb_dev);
-	if (retval < 0)
-		return retval;
-	isku_profile_activated(isku, retval);
-
 	return 0;
 }
 
@@ -346,23 +336,6 @@ static void isku_remove(struct hid_device *hdev)
 	hid_hw_stop(hdev);
 }
 
-static void isku_keep_values_up_to_date(struct isku_device *isku,
-		u8 const *data)
-{
-	struct isku_report_button const *button_report;
-
-	switch (data[0]) {
-	case ISKU_REPORT_NUMBER_BUTTON:
-		button_report = (struct isku_report_button const *)data;
-		switch (button_report->event) {
-		case ISKU_REPORT_BUTTON_EVENT_PROFILE:
-			isku_profile_activated(isku, button_report->data1 - 1);
-			break;
-		}
-		break;
-	}
-}
-
 static void isku_report_to_chrdev(struct isku_device const *isku,
 		u8 const *data)
 {
@@ -377,7 +350,6 @@ static void isku_report_to_chrdev(struct isku_device const *isku,
 	roccat_report.event = button_report->event;
 	roccat_report.data1 = button_report->data1;
 	roccat_report.data2 = button_report->data2;
-	roccat_report.profile = isku->actual_profile + 1;
 	roccat_report_event(isku->chrdev_minor,
 			(uint8_t const *)&roccat_report);
 }
@@ -395,8 +367,6 @@ static int isku_raw_event(struct hid_device *hdev,
 	if (isku == NULL)
 		return 0;
 
-	isku_keep_values_up_to_date(isku, data);
-
 	if (isku->roccat_claimed)
 		isku_report_to_chrdev(isku, data);
 
diff --git a/drivers/hid/hid-roccat-isku.h b/drivers/hid/hid-roccat-isku.h
index cf6896c..102cb1e 100644
--- a/drivers/hid/hid-roccat-isku.h
+++ b/drivers/hid/hid-roccat-isku.h
@@ -83,7 +83,7 @@ struct isku_roccat_report {
 	uint8_t event;
 	uint8_t data1;
 	uint8_t data2;
-	uint8_t profile;
+	uint8_t unused;
 } __packed;
 
 struct isku_device {
@@ -91,8 +91,6 @@ struct isku_device {
 	int chrdev_minor;
 
 	struct mutex isku_lock;
-
-	int actual_profile;
 };
 
 #endif
diff --git a/drivers/hid/hid-roccat-koneplus.c b/drivers/hid/hid-roccat-koneplus.c
index 6a48fa3..1c9ed19 100644
--- a/drivers/hid/hid-roccat-koneplus.c
+++ b/drivers/hid/hid-roccat-koneplus.c
@@ -31,12 +31,6 @@ static uint profile_numbers[5] = {0, 1, 2, 3, 4};
 
 static struct class *koneplus_class;
 
-static void koneplus_profile_activated(struct koneplus_device *koneplus,
-		uint new_profile)
-{
-	koneplus->actual_profile = new_profile;
-}
-
 static int koneplus_send_control(struct usb_device *usb_dev, uint value,
 		enum koneplus_control_requests request)
 {
@@ -228,9 +222,15 @@ static ssize_t koneplus_sysfs_read_profilex_buttons(struct file *fp,
 static ssize_t koneplus_sysfs_show_actual_profile(struct device *dev,
 		struct device_attribute *attr, char *buf)
 {
-	struct koneplus_device *koneplus =
-			hid_get_drvdata(dev_get_drvdata(dev->parent->parent));
-	return snprintf(buf, PAGE_SIZE, "%d\n", koneplus->actual_profile);
+	struct usb_device *usb_dev =
+			interface_to_usbdev(to_usb_interface(dev->parent->parent));
+	int retval;
+
+	retval = koneplus_get_actual_profile(usb_dev);
+	if (retval < 0)
+		return retval;
+
+	return snprintf(buf, PAGE_SIZE, "%d\n", retval);
 }
 
 static ssize_t koneplus_sysfs_set_actual_profile(struct device *dev,
@@ -261,12 +261,9 @@ static ssize_t koneplus_sysfs_set_actual_profile(struct device *dev,
 		return retval;
 	}
 
-	koneplus_profile_activated(koneplus, profile);
-
 	roccat_report.type = KONEPLUS_MOUSE_REPORT_BUTTON_TYPE_PROFILE;
 	roccat_report.data1 = profile + 1;
 	roccat_report.data2 = 0;
-	roccat_report.profile = profile + 1;
 	roccat_report_event(koneplus->chrdev_minor,
 			(uint8_t const *)&roccat_report);
 
@@ -382,15 +379,7 @@ static struct bin_attribute koneplus_bin_attributes[] = {
 static int koneplus_init_koneplus_device_struct(struct usb_device *usb_dev,
 		struct koneplus_device *koneplus)
 {
-	int retval;
-
 	mutex_init(&koneplus->koneplus_lock);
-
-	retval = koneplus_get_actual_profile(usb_dev);
-	if (retval < 0)
-		return retval;
-	koneplus_profile_activated(koneplus, retval);
-
 	return 0;
 }
 
@@ -486,23 +475,6 @@ static void koneplus_remove(struct hid_device *hdev)
 	hid_hw_stop(hdev);
 }
 
-static void koneplus_keep_values_up_to_date(struct koneplus_device *koneplus,
-		u8 const *data)
-{
-	struct koneplus_mouse_report_button const *button_report;
-
-	switch (data[0]) {
-	case KONEPLUS_MOUSE_REPORT_NUMBER_BUTTON:
-		button_report = (struct koneplus_mouse_report_button const *)data;
-		switch (button_report->type) {
-		case KONEPLUS_MOUSE_REPORT_BUTTON_TYPE_PROFILE:
-			koneplus_profile_activated(koneplus, button_report->data1 - 1);
-			break;
-		}
-		break;
-	}
-}
-
 static void koneplus_report_to_chrdev(struct koneplus_device const *koneplus,
 		u8 const *data)
 {
@@ -522,7 +494,6 @@ static void koneplus_report_to_chrdev(struct koneplus_device const *koneplus,
 	roccat_report.type = button_report->type;
 	roccat_report.data1 = button_report->data1;
 	roccat_report.data2 = button_report->data2;
-	roccat_report.profile = koneplus->actual_profile + 1;
 	roccat_report_event(koneplus->chrdev_minor,
 			(uint8_t const *)&roccat_report);
 }
@@ -540,8 +511,6 @@ static int koneplus_raw_event(struct hid_device *hdev,
 	if (koneplus == NULL)
 		return 0;
 
-	koneplus_keep_values_up_to_date(koneplus, data);
-
 	if (koneplus->roccat_claimed)
 		koneplus_report_to_chrdev(koneplus, data);
 
diff --git a/drivers/hid/hid-roccat-koneplus.h b/drivers/hid/hid-roccat-koneplus.h
index af7f57e..46033b8 100644
--- a/drivers/hid/hid-roccat-koneplus.h
+++ b/drivers/hid/hid-roccat-koneplus.h
@@ -110,12 +110,10 @@ struct koneplus_roccat_report {
 	uint8_t type;
 	uint8_t data1;
 	uint8_t data2;
-	uint8_t profile;
+	uint8_t unused;
 } __attribute__ ((__packed__));
 
 struct koneplus_device {
-	int actual_profile;
-
 	int roccat_claimed;
 	int chrdev_minor;
 
diff --git a/drivers/hid/hid-roccat-kovaplus.c b/drivers/hid/hid-roccat-kovaplus.c
index b8b3778..eac248d 100644
--- a/drivers/hid/hid-roccat-kovaplus.c
+++ b/drivers/hid/hid-roccat-kovaplus.c
@@ -37,7 +37,6 @@ static uint kovaplus_convert_event_cpi(uint value)
 static void kovaplus_profile_activated(struct kovaplus_device *kovaplus,
 		uint new_profile_index)
 {
-	kovaplus->actual_profile = new_profile_index;
 	kovaplus->actual_cpi = kovaplus->profile_settings[new_profile_index].cpi_startup_level;
 	kovaplus->actual_x_sensitivity = kovaplus->profile_settings[new_profile_index].sensitivity_x;
 	kovaplus->actual_y_sensitivity = kovaplus->profile_settings[new_profile_index].sensitivity_y;
@@ -264,9 +263,15 @@ static ssize_t kovaplus_sysfs_read_profilex_buttons(struct file *fp,
 static ssize_t kovaplus_sysfs_show_actual_profile(struct device *dev,
 		struct device_attribute *attr, char *buf)
 {
-	struct kovaplus_device *kovaplus =
-			hid_get_drvdata(dev_get_drvdata(dev->parent->parent));
-	return snprintf(buf, PAGE_SIZE, "%d\n", kovaplus->actual_profile);
+	struct usb_device *usb_dev =
+			interface_to_usbdev(to_usb_interface(dev->parent->parent));
+	int retval;
+
+	retval = kovaplus_get_actual_profile(usb_dev);
+	if (retval < 0)
+		return retval;
+
+	return snprintf(buf, PAGE_SIZE, "%d\n", retval);
 }
 
 static ssize_t kovaplus_sysfs_set_actual_profile(struct device *dev,
@@ -299,7 +304,6 @@ static ssize_t kovaplus_sysfs_set_actual_profile(struct device *dev,
 	kovaplus_profile_activated(kovaplus, profile);
 
 	roccat_report.type = KOVAPLUS_MOUSE_REPORT_BUTTON_TYPE_PROFILE_1;
-	roccat_report.profile = profile + 1;
 	roccat_report.button = 0;
 	roccat_report.data1 = profile + 1;
 	roccat_report.data2 = 0;
@@ -598,7 +602,6 @@ static void kovaplus_report_to_chrdev(struct kovaplus_device const *kovaplus,
 		return;
 
 	roccat_report.type = button_report->type;
-	roccat_report.profile = kovaplus->actual_profile + 1;
 
 	if (roccat_report.type == KOVAPLUS_MOUSE_REPORT_BUTTON_TYPE_MACRO ||
 			roccat_report.type == KOVAPLUS_MOUSE_REPORT_BUTTON_TYPE_SHORTCUT ||
diff --git a/drivers/hid/hid-roccat-kovaplus.h b/drivers/hid/hid-roccat-kovaplus.h
index fbb7a16..82ab676 100644
--- a/drivers/hid/hid-roccat-kovaplus.h
+++ b/drivers/hid/hid-roccat-kovaplus.h
@@ -112,14 +112,13 @@ enum kovaplus_mouse_report_button_actions {
 
 struct kovaplus_roccat_report {
 	uint8_t type;
-	uint8_t profile;
+	uint8_t unused;
 	uint8_t button;
 	uint8_t data1;
 	uint8_t data2;
 } __packed;
 
 struct kovaplus_device {
-	int actual_profile;
 	int actual_cpi;
 	int actual_x_sensitivity;
 	int actual_y_sensitivity;
-- 
1.7.3.4



