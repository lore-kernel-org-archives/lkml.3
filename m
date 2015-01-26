Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754859AbbAZN3E (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 08:29:04 -0500
Received: from mail-we0-f173.google.com ([74.125.82.173]:42043 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751885AbbAZN25 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 08:28:57 -0500
From: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
To: linux-kernel@vger.kernel.org, ard.biesheuvel@linaro.org
Cc: dmidecode-devel@nongnu.org, grant.likely@linaro.org,
        leif.lindholm@linaro.org, matt.fleming@intel.com,
        Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
Subject: [Patch v2 2/2] firmware: dmi-sysfs: add SMBIOS entry point area attribute
Date: Mon, 26 Jan 2015 15:28:38 +0200
Message-Id: <1422278918-31477-3-git-send-email-ivan.khoronzhuk@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1422278918-31477-1-git-send-email-ivan.khoronzhuk@linaro.org>
References: <1422278918-31477-1-git-send-email-ivan.khoronzhuk@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are situations when code needs to access SMBIOS entry table
area, but cannot use /dev/mem for this. As the table format is
consistent only for a version, and can be changed, use binary
attribute to give access to raw SMBIOS entry table area.

Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
---
 drivers/firmware/dmi-sysfs.c | 42 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 42 insertions(+)

diff --git a/drivers/firmware/dmi-sysfs.c b/drivers/firmware/dmi-sysfs.c
index e0f1cb3..61b6a38 100644
--- a/drivers/firmware/dmi-sysfs.c
+++ b/drivers/firmware/dmi-sysfs.c
@@ -29,6 +29,8 @@
 #define MAX_ENTRY_TYPE 255 /* Most of these aren't used, but we consider
 			      the top entry type is only 8 bits */
 
+static const u8 *smbios_raw_header;
+
 struct dmi_sysfs_entry {
 	struct dmi_header dh;
 	struct kobject kobj;
@@ -646,9 +648,37 @@ static void cleanup_entry_list(void)
 	}
 }
 
+static ssize_t smbios_entry_area_raw_read(struct file *filp,
+					  struct kobject *kobj,
+					  struct bin_attribute *bin_attr,
+					  char *buf, loff_t pos, size_t count)
+{
+	ssize_t size;
+
+	size = bin_attr->size;
+
+	if (size > pos)
+		size -= pos;
+	else
+		return 0;
+
+	if (count < size)
+		size = count;
+
+	memcpy(buf, &smbios_raw_header[pos], size);
+
+	return size;
+}
+
+static struct bin_attribute smbios_raw_area_attr = {
+	.read = smbios_entry_area_raw_read,
+	.attr = {.name = "smbios_raw_header", .mode = 0400},
+};
+
 static int __init dmi_sysfs_init(void)
 {
 	int error = -ENOMEM;
+	int size;
 	int val;
 
 	/* Set up our directory */
@@ -669,6 +699,18 @@ static int __init dmi_sysfs_init(void)
 		goto err;
 	}
 
+	smbios_raw_header = dmi_get_smbios_entry_area(&size);
+	if (!smbios_raw_header) {
+		pr_debug("dmi-sysfs: SMBIOS raw data is not available.\n");
+		error = -ENODATA;
+		goto err;
+	}
+
+	/* Create the raw binary file to access the entry area */
+	smbios_raw_area_attr.size = size;
+	if (sysfs_create_bin_file(dmi_kobj, &smbios_raw_area_attr))
+		goto err;
+
 	pr_debug("dmi-sysfs: loaded.\n");
 
 	return 0;
-- 
1.9.1

