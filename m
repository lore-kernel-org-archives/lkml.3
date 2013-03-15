Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753870Ab3CODYw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 23:24:52 -0400
Received: from mail.active-venture.com ([67.228.131.205]:50412 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753802Ab3CODYr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 23:24:47 -0400
X-Virus-Scan: Scanned by ClamAV 0.97.2 (no viruses);
  Thu, 14 Mar 2013 22:24:44 -0500
X-Originating-IP: 108.223.40.66
From: Guenter Roeck <linux@roeck-us.net>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Guenter Roeck <linux@roeck-us.net>
Subject: [RFC PATCH 2/2] drivers/core: Add support for devm_ functions
Date: Thu, 14 Mar 2013 20:24:47 -0700
Message-Id: <1363317887-24009-3-git-send-email-linux@roeck-us.net>
X-Mailer: git-send-email 1.7.9.7
In-Reply-To: <1363317887-24009-1-git-send-email-linux@roeck-us.net>
References: <1363317887-24009-1-git-send-email-linux@roeck-us.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for devm_device_create_file and devm_device_remove_file.

Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
 drivers/base/core.c    |   18 ++++++++++++++++++
 include/linux/device.h |    4 ++++
 2 files changed, 22 insertions(+)

diff --git a/drivers/base/core.c b/drivers/base/core.c
index 56536f4b0..76ff488 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -568,6 +568,16 @@ int device_create_file(struct device *dev,
 	return error;
 }
 
+int devm_device_create_file(struct device *dev,
+			    const struct device_attribute *attr)
+{
+	int error = 0;
+	if (dev)
+		error = devm_sysfs_create_file(dev, &attr->attr);
+	return error;
+}
+EXPORT_SYMBOL_GPL(devm_device_create_file);
+
 /**
  * device_remove_file - remove sysfs attribute file.
  * @dev: device.
@@ -580,6 +590,14 @@ void device_remove_file(struct device *dev,
 		sysfs_remove_file(&dev->kobj, &attr->attr);
 }
 
+void devm_device_remove_file(struct device *dev,
+			     const struct device_attribute *attr)
+{
+	if (dev)
+		devm_sysfs_remove_file(dev, &attr->attr);
+}
+EXPORT_SYMBOL_GPL(devm_device_remove_file);
+
 /**
  * device_create_bin_file - create sysfs binary attribute file for device.
  * @dev: device.
diff --git a/include/linux/device.h b/include/linux/device.h
index 9d6464e..1c56fb7 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -521,8 +521,12 @@ ssize_t device_store_bool(struct device *dev, struct device_attribute *attr,
 
 extern int device_create_file(struct device *device,
 			      const struct device_attribute *entry);
+extern int devm_device_create_file(struct device *device,
+				   const struct device_attribute *entry);
 extern void device_remove_file(struct device *dev,
 			       const struct device_attribute *attr);
+extern void devm_device_remove_file(struct device *dev,
+				    const struct device_attribute *attr);
 extern int __must_check device_create_bin_file(struct device *dev,
 					const struct bin_attribute *attr);
 extern void device_remove_bin_file(struct device *dev,
-- 
1.7.9.7

