Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761969AbbA1Uq1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 15:46:27 -0500
Received: from cantor2.suse.de ([195.135.220.15]:59832 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753649AbbA1UqU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 15:46:20 -0500
From: Takashi Iwai <tiwai@suse.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] driver core: Add device_create_files() and device_remove_files() helpers
Date: Wed, 28 Jan 2015 21:46:13 +0100
Message-Id: <1422477974-8369-2-git-send-email-tiwai@suse.de>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <1422477974-8369-1-git-send-email-tiwai@suse.de>
References: <1422477974-8369-1-git-send-email-tiwai@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are lots of open codes that call multiple device_create_file()
or device_remove_file() sequentially.  This patch provides the helper
functions for such cases to be performed in a shot.

Also, device_create_files() rolls back at the error path, and this
will simplify the error handling code in many drivers, too.

Signed-off-by: Takashi Iwai <tiwai@suse.de>
---
 drivers/base/core.c    | 36 ++++++++++++++++++++++++++++++++++++
 include/linux/device.h |  4 ++++
 2 files changed, 40 insertions(+)

diff --git a/drivers/base/core.c b/drivers/base/core.c
index 97e2baf6e5d8..d3fa3d55f1fb 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -557,6 +557,29 @@ int device_create_file(struct device *dev,
 EXPORT_SYMBOL_GPL(device_create_file);
 
 /**
+ * device_create_files - create multiple sysfs attribute files for device.
+ * @dev: device.
+ * @attr: NULL-terminated list of device attribute descriptors.
+ */
+int device_create_files(struct device *dev,
+			const struct device_attribute **attrs)
+{
+	int i, err;
+
+	for (i = 0; attrs[i]; i++) {
+		err = device_create_file(dev, attrs[i]);
+		if (err) {
+			while (--i >= 0)
+				device_remove_file(dev, attrs[i]);
+			return err;
+		}
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(device_create_files);
+
+/**
  * device_remove_file - remove sysfs attribute file.
  * @dev: device.
  * @attr: device attribute descriptor.
@@ -570,6 +593,19 @@ void device_remove_file(struct device *dev,
 EXPORT_SYMBOL_GPL(device_remove_file);
 
 /**
+ * device_remove_file - remove multiple sysfs attribute files.
+ * @dev: device.
+ * @attr: NULL-terminated list of device attribute descriptors.
+ */
+void device_remove_files(struct device *dev,
+			 const struct device_attribute **attrs)
+{
+	for (; *attrs; attrs++)
+		device_remove_file(dev, *attrs);
+}
+EXPORT_SYMBOL_GPL(device_remove_files);
+
+/**
  * device_remove_file_self - remove sysfs attribute file from its own method.
  * @dev: device.
  * @attr: device attribute descriptor.
diff --git a/include/linux/device.h b/include/linux/device.h
index fb506738f7b7..45b6cef1a12b 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -559,8 +559,12 @@ ssize_t device_store_bool(struct device *dev, struct device_attribute *attr,
 
 extern int device_create_file(struct device *device,
 			      const struct device_attribute *entry);
+extern int device_create_files(struct device *device,
+			       const struct device_attribute **attrs);
 extern void device_remove_file(struct device *dev,
 			       const struct device_attribute *attr);
+extern void device_remove_files(struct device *dev,
+				const struct device_attribute **attrs);
 extern bool device_remove_file_self(struct device *dev,
 				    const struct device_attribute *attr);
 extern int __must_check device_create_bin_file(struct device *dev,
-- 
2.2.2

