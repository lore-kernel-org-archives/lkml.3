Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756619AbbAWUWf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 15:22:35 -0500
Received: from mail-wi0-f179.google.com ([209.85.212.179]:56127 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755672AbbAWUWK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 15:22:10 -0500
From: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
To: linux-kernel@vger.kernel.org, ard.biesheuvel@linaro.org
Cc: dmidecode-devel@nongnu.org, grant.likely@linaro.org,
        leif.lindholm@linaro.org, matt.fleming@intel.com,
        Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
Subject: [PATCH 2/2] firmware: dmi-sysfs: add SMBIOS entry point area attribute
Date: Fri, 23 Jan 2015 22:21:47 +0200
Message-Id: <1422044507-22982-3-git-send-email-ivan.khoronzhuk@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1422044507-22982-1-git-send-email-ivan.khoronzhuk@linaro.org>
References: <1422044507-22982-1-git-send-email-ivan.khoronzhuk@linaro.org>
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
index e0f1cb3..b5c0558 100644
--- a/drivers/firmware/dmi-sysfs.c
+++ b/drivers/firmware/dmi-sysfs.c
@@ -46,6 +46,8 @@ struct dmi_sysfs_entry {
 static LIST_HEAD(entry_list);
 static DEFINE_SPINLOCK(entry_list_lock);
 
+static unsigned char smbios_raw_header[32];
+
 /* dmi_sysfs_attribute - Top level attribute. used by all entries. */
 struct dmi_sysfs_attribute {
 	struct attribute attr;
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
+static struct bin_attribute smbios_entry_area_raw_attr = {
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
 
+	size = dmi_get_smbios_entry_area(smbios_raw_header);
+	if (size == -ENODATA) {
+		pr_debug("dmi-sysfs: SMBIOS raw data is not available.\n");
+		error = size;
+		goto err;
+	}
+
+	/* Create the raw binary file to access the entry area */
+	smbios_entry_area_raw_attr.size = size;
+	if (sysfs_create_bin_file(dmi_kobj, &smbios_entry_area_raw_attr))
+		goto err;
+
 	pr_debug("dmi-sysfs: loaded.\n");
 
 	return 0;
-- 
1.9.1

