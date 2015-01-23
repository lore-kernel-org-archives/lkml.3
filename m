Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756580AbbAWUWM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 15:22:12 -0500
Received: from mail-wi0-f172.google.com ([209.85.212.172]:48413 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756516AbbAWUWI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 15:22:08 -0500
From: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
To: linux-kernel@vger.kernel.org, ard.biesheuvel@linaro.org
Cc: dmidecode-devel@nongnu.org, grant.likely@linaro.org,
        leif.lindholm@linaro.org, matt.fleming@intel.com,
        Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
Subject: [PATCH 1/2] firmware: dmi_scan: add symbol to get SMBIOS entry area
Date: Fri, 23 Jan 2015 22:21:46 +0200
Message-Id: <1422044507-22982-2-git-send-email-ivan.khoronzhuk@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1422044507-22982-1-git-send-email-ivan.khoronzhuk@linaro.org>
References: <1422044507-22982-1-git-send-email-ivan.khoronzhuk@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are situations when code needs to access SMBIOS entry table
area. For example, to pass it via sysfs to userspace when it's not
allowed to get SMBIOS info via /dev/mem.

Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
---
 drivers/firmware/dmi_scan.c | 34 ++++++++++++++++++++++++++++++++++
 include/linux/dmi.h         |  2 ++
 2 files changed, 36 insertions(+)

diff --git a/drivers/firmware/dmi_scan.c b/drivers/firmware/dmi_scan.c
index 420c8d8..ae9204a 100644
--- a/drivers/firmware/dmi_scan.c
+++ b/drivers/firmware/dmi_scan.c
@@ -113,6 +113,7 @@ static void dmi_table(u8 *buf, int len, int num,
 	}
 }
 
+static unsigned char smbios_header[32];
 static phys_addr_t dmi_base;
 static u16 dmi_len;
 static u16 dmi_num;
@@ -474,6 +475,7 @@ static int __init dmi_present(const u8 *buf)
 	if (memcmp(buf, "_SM_", 4) == 0 &&
 	    buf[5] < 32 && dmi_checksum(buf, buf[5])) {
 		smbios_ver = get_unaligned_be16(buf + 6);
+		memcpy(smbios_header, buf, buf[5]);
 
 		/* Some BIOS report weird SMBIOS version, fix that up */
 		switch (smbios_ver) {
@@ -505,6 +507,7 @@ static int __init dmi_present(const u8 *buf)
 				pr_info("SMBIOS %d.%d present.\n",
 				       dmi_ver >> 8, dmi_ver & 0xFF);
 			} else {
+				memcpy(smbios_header, buf, 15);
 				dmi_ver = (buf[14] & 0xF0) << 4 |
 					   (buf[14] & 0x0F);
 				pr_info("Legacy DMI %d.%d present.\n",
@@ -531,6 +534,7 @@ static int __init dmi_smbios3_present(const u8 *buf)
 		dmi_ver &= 0xFFFFFF;
 		dmi_len = get_unaligned_le32(buf + 12);
 		dmi_base = get_unaligned_le64(buf + 16);
+		memcpy(smbios_header, buf, buf[6]);
 
 		/*
 		 * The 64-bit SMBIOS 3.0 entry point no longer has a field
@@ -944,3 +948,33 @@ void dmi_memdev_name(u16 handle, const char **bank, const char **device)
 	}
 }
 EXPORT_SYMBOL_GPL(dmi_memdev_name);
+
+/**
+ * dmi_get_smbios_entry_area - copy SMBIOS entry point area to array.
+ * @entry - pointer on array to read area in, current max size is 32 bytes.
+ *
+ * returns -ENODATA if table is not available, otherwise returns actual
+ * size of SMBIOS entry point area.
+ */
+int dmi_get_smbios_entry_area(char *table)
+{
+	int size = 0;
+
+	if (!dmi_available)
+		return -ENODATA;
+
+	if (memcmp(smbios_header, "_SM3_", 5) == 0)
+		size = smbios_header[6];
+	else if (memcmp(smbios_header, "_SM_", 4) == 0)
+		size = smbios_header[5];
+	else if (memcmp(smbios_header, "_DMI_", 5) == 0)
+		size = 15;
+
+	memcpy(table, smbios_header, size);
+
+	if (!size)
+		return -ENODATA;
+
+	return size;
+}
+EXPORT_SYMBOL_GPL(dmi_get_smbios_entry_area);
diff --git a/include/linux/dmi.h b/include/linux/dmi.h
index f820f0a..7cae713 100644
--- a/include/linux/dmi.h
+++ b/include/linux/dmi.h
@@ -109,6 +109,7 @@ extern int dmi_walk(void (*decode)(const struct dmi_header *, void *),
 	void *private_data);
 extern bool dmi_match(enum dmi_field f, const char *str);
 extern void dmi_memdev_name(u16 handle, const char **bank, const char **device);
+int dmi_get_smbios_entry_area(char *table);
 
 #else
 
@@ -140,6 +141,7 @@ static inline void dmi_memdev_name(u16 handle, const char **bank,
 		const char **device) { }
 static inline const struct dmi_system_id *
 	dmi_first_match(const struct dmi_system_id *list) { return NULL; }
+static inline int dmi_get_smbios_entry_area(char *table) { return -ENODATA; }
 
 #endif
 
-- 
1.9.1

