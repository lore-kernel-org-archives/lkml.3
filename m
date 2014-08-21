Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753877AbaHUFBy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 01:01:54 -0400
Received: from smtp-out-05.shaw.ca ([64.59.134.13]:60961 "EHLO
	smtp-out-05.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751430AbaHUFBN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 01:01:13 -0400
X-Greylist: delayed 564 seconds by postgrey-1.27 at vger.kernel.org; Thu, 21 Aug 2014 01:01:12 EDT
X-Cloudmark-SP-Filtered: true
X-Cloudmark-SP-Result: v=1.1 cv=/MiPqmMwFv6ha2ZBybe0ZU9m+O5sXPp7gEUgHVyRzyY= c=1 sm=1
 a=UH42RW5JK3gA:10 a=6glMKVRQ4jEA:10 a=3762yOXauukA:10 a=BLceEmwcHowA:10
 a=x/GiHf5VU5uXFAeKKVSXKg==:17 a=6LyOAG8cvV5gfRTAjJkA:9
 a=HpAAvcLHHh0Zw7uRqdWCyQ==:117
From: Simon Wood <simon@mungewell.org>
To: linux-input@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Jiri Kosina <jkosina@suse.cz>,
        Simon Wood <simon@mungewell.org>
Subject: [RFC 4/4] HID:hid-logitech: Add mode control via /sys interface
Date: Wed, 20 Aug 2014 22:51:42 -0600
Message-Id: <1408596702-3895-4-git-send-email-simon@mungewell.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1408596702-3895-1-git-send-email-simon@mungewell.org>
References: <1408596702-3895-1-git-send-email-simon@mungewell.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

---
 drivers/hid/hid-lg4ff.c | 81 +++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 78 insertions(+), 3 deletions(-)

diff --git a/drivers/hid/hid-lg4ff.c b/drivers/hid/hid-lg4ff.c
index 0ba0838..1be561e 100644
--- a/drivers/hid/hid-lg4ff.c
+++ b/drivers/hid/hid-lg4ff.c
@@ -41,11 +41,16 @@ static void hid_lg4ff_set_range_g25(struct hid_device *hid, u16 range);
 static ssize_t lg4ff_range_show(struct device *dev, struct device_attribute *attr, char *buf);
 static ssize_t lg4ff_range_store(struct device *dev, struct device_attribute *attr, const char *buf, size_t count);
 
+static ssize_t lg4ff_mode_show(struct device *dev, struct device_attribute *attr, char *buf);
+static ssize_t lg4ff_mode_store(struct device *dev, struct device_attribute *attr, const char *buf, size_t count);
+
 static DEVICE_ATTR(range, S_IRWXU | S_IRWXG | S_IROTH, lg4ff_range_show, lg4ff_range_store);
+static DEVICE_ATTR(mode, S_IRWXU | S_IRWXG | S_IROTH, lg4ff_mode_show, lg4ff_mode_store);
 
 struct lg4ff_device_entry {
 	__u32 product_id;
 	__u16 type;
+	__u16 mode;
 	__u16 range;
 	__u16 min_range;
 	__u16 max_range;
@@ -362,7 +367,7 @@ static int lg4ff_switch_mode(struct hid_device *hid, __u16 type, int mode)
 		value[6] = 0x00;
 
 		hid_hw_request(hid, report, HID_REQ_SET_REPORT);
-		return 0;
+		return LG4FF_MSW_G25;
 	}
 
 	if (mode == LG4FF_MSW_DFP) {
@@ -375,7 +380,7 @@ static int lg4ff_switch_mode(struct hid_device *hid, __u16 type, int mode)
 		value[6] = 0x00;
 
 		hid_hw_request(hid, report, HID_REQ_SET_REPORT);
-		return 0;
+		return LG4FF_MSW_DFP;
 	}
 
 	/* Prevent compat mode on USB reset */
@@ -400,7 +405,7 @@ static int lg4ff_switch_mode(struct hid_device *hid, __u16 type, int mode)
 	value[6] = 0x00;
 
 	hid_hw_request(hid, report, HID_REQ_SET_REPORT);
-	return 0;
+	return mode;
 }
 
 /* Read current range and display it in terminal */
@@ -461,6 +466,66 @@ static ssize_t lg4ff_range_store(struct device *dev, struct device_attribute *at
 	return count;
 }
 
+/* Read current mode and display it in terminal */
+static ssize_t lg4ff_mode_show(struct device *dev, struct device_attribute *attr, char *buf)
+{
+	struct hid_device *hid = to_hid_device(dev);
+	struct lg4ff_device_entry *entry;
+	struct lg_drv_data *drv_data;
+	size_t count;
+
+	drv_data = hid_get_drvdata(hid);
+	if (!drv_data) {
+		hid_err(hid, "Private driver data not found!\n");
+		return 0;
+	}
+
+	entry = drv_data->device_props;
+	if (!entry) {
+		hid_err(hid, "Device properties not found!\n");
+		return 0;
+	}
+
+	count = scnprintf(buf, PAGE_SIZE, "%u\n", entry->mode);
+	return count;
+}
+
+/* Set mode to user specified value */
+static ssize_t lg4ff_mode_store(struct device *dev, struct device_attribute *attr, const char *buf, size_t count)
+{
+	struct hid_device *hid = to_hid_device(dev);
+	struct lg4ff_device_entry *entry;
+	struct lg_drv_data *drv_data;
+	int err;
+	__u16 mode = simple_strtoul(buf, NULL, 10);
+
+	drv_data = hid_get_drvdata(hid);
+	if (!drv_data) {
+		hid_err(hid, "Private driver data not found!\n");
+		return -EINVAL;
+	}
+
+	entry = drv_data->device_props;
+	if (!entry) {
+		hid_err(hid, "Device properties not found!\n");
+		return -EINVAL;
+	}
+
+	if (mode == entry->mode) {
+		dbg_hid("Device is already in mode %d\n", mode);
+		return count;
+	}
+
+	err = lg4ff_switch_mode(hid, entry->type, mode);
+	if (err != mode) {
+		hid_err(hid, "Unable to switch mode\n");
+		return -1;
+	}
+
+	entry->mode = mode;
+	return count;
+}
+
 #ifdef CONFIG_LEDS_CLASS
 static void lg4ff_set_leds(struct hid_device *hid, __u8 leds)
 {
@@ -583,6 +648,7 @@ int lg4ff_init(struct hid_device *hid, const int switch_mode)
 	entry->product_id = hid->product;
 	entry->set_range = NULL;
 	entry->type = LG4FF_MSW_EMU;
+	entry->mode = LG4FF_MSW_EMU;
 
 	/* Check which wheel has been connected */
 	bcdDevice = le16_to_cpu(udesc->bcdDevice);
@@ -602,6 +668,11 @@ int lg4ff_init(struct hid_device *hid, const int switch_mode)
 			entry->min_range = 40;
 			entry->max_range = 900;
 			entry->set_range = s->set_range;
+
+			if (switch_mode == LG4FF_MSW_NAT)
+				entry->mode = s->type;
+			else
+				entry->mode = switch_mode;
 		}
 
 		if (hid->product == USB_DEVICE_ID_LOGITECH_WHEEL && switch_mode != LG4FF_MSW_EMU) {
@@ -635,6 +706,9 @@ int lg4ff_init(struct hid_device *hid, const int switch_mode)
 	error = device_create_file(&hid->dev, &dev_attr_range);
 	if (error)
 		return error;
+	error = device_create_file(&hid->dev, &dev_attr_mode);
+	if (error)
+		return error;
 	dbg_hid("sysfs interface created\n");
 
 	/* Set the maximum range to start with */
@@ -705,6 +779,7 @@ int lg4ff_deinit(struct hid_device *hid)
 	struct lg_drv_data *drv_data;
 
 	device_remove_file(&hid->dev, &dev_attr_range);
+	device_remove_file(&hid->dev, &dev_attr_mode);
 
 	drv_data = hid_get_drvdata(hid);
 	if (!drv_data) {
-- 
1.9.1

