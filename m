Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751737AbaLPWBe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 17:01:34 -0500
Received: from marmot.wormnet.eu ([188.246.204.87]:35168 "EHLO
	marmot.wormnet.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751022AbaLPWBc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 17:01:32 -0500
X-Greylist: delayed 2029 seconds by postgrey-1.27 at vger.kernel.org; Tue, 16 Dec 2014 17:01:32 EST
From: Jamie Lentin <jm@lentin.co.uk>
To: Jiri Kosina <jkosina@suse.cz>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jamie Lentin <jm@lentin.co.uk>
Subject: [PATCH 1/2] HID: lenovo: Add sensitivity control to compact keyboards
Date: Tue, 16 Dec 2014 21:26:45 +0000
Message-Id: <1418765206-30885-2-git-send-email-jm@lentin.co.uk>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1418765206-30885-1-git-send-email-jm@lentin.co.uk>
References: <1418765206-30885-1-git-send-email-jm@lentin.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The trackpoint sensitivity can also be controlled, expose this via
sysfs.

Signed-off-by: Jamie Lentin <jm@lentin.co.uk>
---
 drivers/hid/hid-lenovo.c | 42 +++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 41 insertions(+), 1 deletion(-)

diff --git a/drivers/hid/hid-lenovo.c b/drivers/hid/hid-lenovo.c
index 4c55f4d..0f35a76 100644
--- a/drivers/hid/hid-lenovo.c
+++ b/drivers/hid/hid-lenovo.c
@@ -38,6 +38,7 @@ struct lenovo_drvdata_tpkbd {
 
 struct lenovo_drvdata_cptkbd {
 	bool fn_lock;
+	int sensitivity;
 };
 
 #define map_key_clear(c) hid_map_usage_clear(hi, usage, bit, max, EV_KEY, (c))
@@ -145,6 +146,7 @@ static void lenovo_features_set_cptkbd(struct hid_device *hdev)
 	struct lenovo_drvdata_cptkbd *cptkbd_data = hid_get_drvdata(hdev);
 
 	ret = lenovo_send_cmd_cptkbd(hdev, 0x05, cptkbd_data->fn_lock);
+	ret = lenovo_send_cmd_cptkbd(hdev, 0x02, cptkbd_data->sensitivity);
 	if (ret)
 		hid_err(hdev, "Fn-lock setting failed: %d\n", ret);
 }
@@ -179,13 +181,50 @@ static ssize_t attr_fn_lock_store_cptkbd(struct device *dev,
 	return count;
 }
 
+static ssize_t attr_sensitivity_show_cptkbd(struct device *dev,
+		struct device_attribute *attr,
+		char *buf)
+{
+	struct hid_device *hdev = container_of(dev, struct hid_device, dev);
+	struct lenovo_drvdata_cptkbd *cptkbd_data = hid_get_drvdata(hdev);
+
+	return snprintf(buf, PAGE_SIZE, "%u\n",
+		cptkbd_data->sensitivity);
+}
+
+static ssize_t attr_sensitivity_store_cptkbd(struct device *dev,
+		struct device_attribute *attr,
+		const char *buf,
+		size_t count)
+{
+	struct hid_device *hdev = container_of(dev, struct hid_device, dev);
+	struct lenovo_drvdata_cptkbd *cptkbd_data = hid_get_drvdata(hdev);
+	int value;
+
+	if (kstrtoint(buf, 10, &value) || value < 1 || value > 255)
+		return -EINVAL;
+
+	cptkbd_data->sensitivity = value;
+	lenovo_features_set_cptkbd(hdev);
+
+	return count;
+}
+
+
 static struct device_attribute dev_attr_fn_lock_cptkbd =
 	__ATTR(fn_lock, S_IWUSR | S_IRUGO,
 			attr_fn_lock_show_cptkbd,
 			attr_fn_lock_store_cptkbd);
 
+static struct device_attribute dev_attr_sensitivity_cptkbd =
+	__ATTR(sensitivity, S_IWUSR | S_IRUGO,
+			attr_sensitivity_show_cptkbd,
+			attr_sensitivity_store_cptkbd);
+
+
 static struct attribute *lenovo_attributes_cptkbd[] = {
 	&dev_attr_fn_lock_cptkbd.attr,
+	&dev_attr_sensitivity_cptkbd.attr,
 	NULL
 };
 
@@ -594,8 +633,9 @@ static int lenovo_probe_cptkbd(struct hid_device *hdev)
 	if (ret)
 		hid_warn(hdev, "Failed to switch F7/9/11 mode: %d\n", ret);
 
-	/* Turn Fn-Lock on by default */
+	/* Set keyboard settings to known state */
 	cptkbd_data->fn_lock = true;
+	cptkbd_data->sensitivity = 0x05;
 	lenovo_features_set_cptkbd(hdev);
 
 	ret = sysfs_create_group(&hdev->dev.kobj, &lenovo_attr_group_cptkbd);
-- 
2.1.3

