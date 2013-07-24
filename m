Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753584Ab3GXPnf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 11:43:35 -0400
Received: from mga02.intel.com ([134.134.136.20]:53657 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753058Ab3GXPnb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 11:43:31 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,736,1367996400"; 
   d="scan'208";a="350846079"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org,
        Tomas Winkler <tomas.winkler@intel.com>,
        Natalia Ovsyanikov <natalia.ovsyanikov@intel.com>
Subject: [char-misc-next 2/3] mei: adding sysfs fw_status attribute
Date: Wed, 24 Jul 2013 18:41:56 +0300
Message-Id: <1374680517-30894-3-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1374680517-30894-1-git-send-email-tomas.winkler@intel.com>
References: <1374680517-30894-1-git-send-email-tomas.winkler@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Export fw status register through sysfs interface.
The interface is for applications that monitors
fw health.

Signed-off-by: Natalia Ovsyanikov <natalia.ovsyanikov@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/misc/mei/main.c | 54 ++++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 51 insertions(+), 3 deletions(-)

diff --git a/drivers/misc/mei/main.c b/drivers/misc/mei/main.c
index 173ff09..64e36a8 100644
--- a/drivers/misc/mei/main.c
+++ b/drivers/misc/mei/main.c
@@ -659,6 +659,44 @@ out:
 	return mask;
 }
 
+/**
+ * mei_show_fw_status - mei device attribute show method
+ *
+ * @dev:  device pointer
+ * @attr: attribute pointer
+ * @buf:  char out buffer
+ *
+ * returns number of the bytes, printed into the buffer
+ */
+
+static ssize_t mei_show_fw_status(struct device *device,
+		struct device_attribute *attr, char *buf)
+{
+	struct mei_device *dev = dev_get_drvdata(device);
+	u32 fw_status;
+	int err;
+
+	mutex_lock(&dev->device_lock);
+	err = mei_fw_status(dev, &fw_status);
+	mutex_unlock(&dev->device_lock);
+	if (err) {
+		dev_err(device, "attribute show: read fw_status error = %d\n",
+			err);
+		return err;
+	}
+
+	dev_dbg(device, "attribute show: fw_status 0x%x\n", fw_status);
+	return sprintf(buf, "%08X\n", fw_status);
+}
+static DEVICE_ATTR(fw_status, S_IRUGO, mei_show_fw_status, NULL);
+static struct attribute *mei_attributes[] = {
+	&dev_attr_fw_status.attr,
+	NULL
+};
+static const struct attribute_group mei_attr_group = {
+	.attrs  = mei_attributes,
+};
+
 /*
  * file operations structure will be used for mei char device.
  */
@@ -685,17 +723,22 @@ static struct miscdevice  mei_misc_device = {
 		.minor = MISC_DYNAMIC_MINOR,
 };
 
-
 int mei_register(struct mei_device *dev)
 {
+	struct device *device = &dev->pdev->dev;
 	int ret;
-	mei_misc_device.parent = &dev->pdev->dev;
+
+	mei_misc_device.parent = device;
 	ret = misc_register(&mei_misc_device);
 	if (ret)
 		return ret;
 
+	ret = sysfs_create_group(&device->kobj, &mei_attr_group);
+	if (ret)
+		return ret;
+
 	if (mei_dbgfs_register(dev, mei_misc_device.name))
-		dev_err(&dev->pdev->dev, "cannot register debugfs\n");
+		dev_err(device, "cannot register debugfs\n");
 
 	return 0;
 }
@@ -703,7 +746,12 @@ EXPORT_SYMBOL_GPL(mei_register);
 
 void mei_deregister(struct mei_device *dev)
 {
+	struct device *device = &dev->pdev->dev;
+
+	sysfs_remove_group(&device->kobj, &mei_attr_group);
+
 	mei_dbgfs_deregister(dev);
+
 	misc_deregister(&mei_misc_device);
 	mei_misc_device.parent = NULL;
 }
-- 
1.8.1.2

