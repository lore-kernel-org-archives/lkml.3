Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755928AbaKSPEJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 10:04:09 -0500
Received: from mga01.intel.com ([192.55.52.88]:51750 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754921AbaKSPEH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 10:04:07 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,417,1413270000"; 
   d="scan'208";a="624910781"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [char-misc-next 2/3] mei: export fw status registers through sysfs
Date: Wed, 19 Nov 2014 17:01:39 +0200
Message-Id: <1416409300-14431-2-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1416409300-14431-1-git-send-email-tomas.winkler@intel.com>
References: <1416409300-14431-1-git-send-email-tomas.winkler@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The interface is for applications that monitor
the fw health.

We use device_create_with_groups interface
to register attribute with the mei class device

Signed-off-by :Tomas Winkler <tomas.winkler@intel.com>

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/misc/mei/main.c | 43 +++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 41 insertions(+), 2 deletions(-)

diff --git a/drivers/misc/mei/main.c b/drivers/misc/mei/main.c
index 5d6a15c3619a..3c019c0e60eb 100644
--- a/drivers/misc/mei/main.c
+++ b/drivers/misc/mei/main.c
@@ -627,6 +627,44 @@ out:
 	return mask;
 }
 
+/**
+ * fw_status_show - mei device attribute show method
+ *
+ * @device: device pointer
+ * @attr: attribute pointer
+ * @buf:  char out buffer
+ *
+ * Return: number of the bytes printed into buf or error
+ */
+static ssize_t fw_status_show(struct device *device,
+		struct device_attribute *attr, char *buf)
+{
+	struct mei_device *dev = dev_get_drvdata(device);
+	struct mei_fw_status fw_status;
+	int err, i;
+	ssize_t cnt = 0;
+
+	mutex_lock(&dev->device_lock);
+	err = mei_fw_status(dev, &fw_status);
+	mutex_unlock(&dev->device_lock);
+	if (err) {
+		dev_err(device, "read fw_status error = %d\n", err);
+		return err;
+	}
+
+	for (i = 0; i < fw_status.count; i++)
+		cnt += scnprintf(buf + cnt, PAGE_SIZE - cnt, "%08X\n",
+				fw_status.status[i]);
+	return cnt;
+}
+static DEVICE_ATTR_RO(fw_status);
+
+static struct attribute *mei_attrs[] = {
+	&dev_attr_fw_status.attr,
+	NULL
+};
+ATTRIBUTE_GROUPS(mei);
+
 /*
  * file operations structure will be used for mei char device.
  */
@@ -706,8 +744,9 @@ int mei_register(struct mei_device *dev, struct device *parent)
 		goto err_dev_add;
 	}
 
-	clsdev = device_create(mei_class, parent, devno,
-			 NULL, "mei%d", dev->minor);
+	clsdev = device_create_with_groups(mei_class, parent, devno,
+					   dev, mei_groups,
+					   "mei%d", dev->minor);
 
 	if (IS_ERR(clsdev)) {
 		dev_err(parent, "unable to create device %d:%d\n",
-- 
1.9.3

