Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934588Ab3BNMeL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 07:34:11 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:56568 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755252Ab3BNMeJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 07:34:09 -0500
From: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com
Subject: [PATCH 1/2] regmap: debugfs: Add a registers `range' file
Date: Thu, 14 Feb 2013 12:31:44 +0000
Message-Id: <1360845104-30392-1-git-send-email-dp@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.8.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This file lists the register ranges in the register map.  The condition
to split the range is based on the actual register attributes.  A range
is a contiguous block of registers with the same register attributes.

Signed-off-by: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>
---
 drivers/base/regmap/internal.h       |   1 +
 drivers/base/regmap/regmap-debugfs.c | 122 +++++++++++++++++++++++++++++++++++
 2 files changed, 123 insertions(+)

diff --git a/drivers/base/regmap/internal.h b/drivers/base/regmap/internal.h
index 5a22bd3..b4e55a0 100644
--- a/drivers/base/regmap/internal.h
+++ b/drivers/base/regmap/internal.h
@@ -27,6 +27,7 @@ struct regmap_debugfs_off_cache {
 	off_t max;
 	unsigned int base_reg;
 	unsigned int max_reg;
+	unsigned int reg_attr;
 };
 
 struct regmap_format {
diff --git a/drivers/base/regmap/regmap-debugfs.c b/drivers/base/regmap/regmap-debugfs.c
index 5fb23cb..5843eb1 100644
--- a/drivers/base/regmap/regmap-debugfs.c
+++ b/drivers/base/regmap/regmap-debugfs.c
@@ -56,6 +56,26 @@ static const struct file_operations regmap_name_fops = {
 	.llseek = default_llseek,
 };
 
+enum reg_attributes {
+	READABLE = 0x1,
+	WRITEABLE = 0x2,
+	VOLATILE = 0x4,
+};
+
+static inline unsigned int regmap_attr_bitmap(struct regmap *map,
+					      unsigned int reg)
+{
+	unsigned int reg_attr = 0;
+
+	if (regmap_readable(map, reg))
+		reg_attr |= READABLE;
+	if (regmap_writeable(map, reg))
+		reg_attr |= WRITEABLE;
+	if (regmap_volatile(map, reg))
+		reg_attr |= VOLATILE;
+	return reg_attr;
+}
+
 static void regmap_debugfs_free_dump_cache(struct regmap *map)
 {
 	struct regmap_debugfs_off_cache *c;
@@ -96,6 +116,7 @@ static unsigned int regmap_debugfs_get_dump_start(struct regmap *map,
 				if (c) {
 					c->max = p - 1;
 					c->max_reg = i - 1;
+					c->reg_attr = regmap_attr_bitmap(map, c->max_reg);
 					list_add_tail(&c->list,
 						      &map->debugfs_off_cache);
 					c = NULL;
@@ -123,6 +144,7 @@ static unsigned int regmap_debugfs_get_dump_start(struct regmap *map,
 	if (c) {
 		c->max = p - 1;
 		c->max_reg = i - 1;
+		c->reg_attr = regmap_attr_bitmap(map, c->max_reg);
 		list_add_tail(&c->list,
 			      &map->debugfs_off_cache);
 	}
@@ -307,6 +329,103 @@ static const struct file_operations regmap_range_fops = {
 	.llseek = default_llseek,
 };
 
+static void regmap_range_format_line(struct regmap *map,
+				     struct regmap_debugfs_off_cache *c,
+				     char *buf, size_t len)
+{
+	ssize_t buf_offset;
+
+	buf_offset = snprintf(buf, PAGE_SIZE, "%x-%x ",
+			      c->base_reg, c->max_reg);
+	buf_offset += snprintf(buf + buf_offset,
+			       PAGE_SIZE - buf_offset, "(");
+	if (c->reg_attr & READABLE)
+		buf_offset += snprintf(buf + buf_offset,
+				       PAGE_SIZE - buf_offset,
+				       "read, ");
+	if (c->reg_attr & WRITEABLE)
+		buf_offset += snprintf(buf + buf_offset,
+				       PAGE_SIZE - buf_offset,
+				       "write, ");
+	if (c->reg_attr & VOLATILE)
+		buf_offset += snprintf(buf + buf_offset,
+				       PAGE_SIZE - buf_offset,
+				       "volatile, ");
+	/* Rewind the last ", " as well */
+	buf_offset += snprintf(buf + buf_offset - 2,
+			       PAGE_SIZE - buf_offset, ")");
+}
+
+static ssize_t regmap_reg_ranges_read_file(struct file *file,
+					   char __user *user_buf, size_t count,
+					   loff_t *ppos)
+{
+	struct regmap *map = file->private_data;
+	struct regmap_debugfs_off_cache *c;
+	loff_t p = 0;
+	size_t buf_pos = 0;
+	char *buf;
+	char *entry;
+	int ret;
+
+	if (*ppos < 0 || !count)
+		return -EINVAL;
+
+	buf = kmalloc(count, GFP_KERNEL);
+	if (!buf)
+		return -ENOMEM;
+
+	entry = kmalloc(PAGE_SIZE, GFP_KERNEL);
+	if (!entry) {
+		kfree(buf);
+		return -ENOMEM;
+	}
+
+	/* While we are at it, build the register dump cache
+	 * now so the read() operation on the `registers' file
+	 * can benefit from using the cache.  We do not care
+	 * about the file position information that is contained
+	 * in the cache, just about the actual register blocks */
+	regmap_calc_tot_len(map, buf, count);
+	regmap_debugfs_get_dump_start(map, 0, *ppos, &p);
+
+	/* Reset file pointer as the fixed-format of the `registers'
+	 * file is not compatible with the `range' file */
+	p = 0;
+	list_for_each_entry(c, &map->debugfs_off_cache, list) {
+		regmap_range_format_line(map, c, entry, PAGE_SIZE);
+		if (p >= *ppos) {
+			if (buf_pos + 1 + strlen(entry) > count)
+				break;
+			snprintf(buf + buf_pos, count - buf_pos,
+				 "%s", entry);
+			buf_pos += strlen(entry);
+			buf[buf_pos] = '\n';
+			buf_pos++;
+		}
+		p += strlen(entry) + 1;
+	}
+
+	kfree(entry);
+	ret = buf_pos;
+
+	if (copy_to_user(user_buf, buf, buf_pos)) {
+		ret = -EFAULT;
+		goto out_buf;
+	}
+
+	*ppos += buf_pos;
+out_buf:
+	kfree(buf);
+	return ret;
+}
+
+static const struct file_operations regmap_reg_ranges_fops = {
+	.open = simple_open,
+	.read = regmap_reg_ranges_read_file,
+	.llseek = default_llseek,
+};
+
 static ssize_t regmap_access_read_file(struct file *file,
 				       char __user *user_buf, size_t count,
 				       loff_t *ppos)
@@ -399,6 +518,9 @@ void regmap_debugfs_init(struct regmap *map, const char *name)
 	debugfs_create_file("name", 0400, map->debugfs,
 			    map, &regmap_name_fops);
 
+	debugfs_create_file("range", 0400, map->debugfs,
+			    map, &regmap_reg_ranges_fops);
+
 	if (map->max_register) {
 		debugfs_create_file("registers", 0400, map->debugfs,
 				    map, &regmap_map_fops);
-- 
1.8.1.3

