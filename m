Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756330Ab3BAMH4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 07:07:56 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:57022 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751688Ab3BAMHv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 07:07:51 -0500
From: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com
Subject: [PATCH v3] regmap: debugfs: Add a registers `range' file
Date: Fri,  1 Feb 2013 12:05:39 +0000
Message-Id: <1359720339-14862-1-git-send-email-dp@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This file lists the register ranges in the register map.  The condition
to split the range is based on the actual register attributes.  A range
is a contiguous block of registers with the same register attributes.

Signed-off-by: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>
---
 Simplified the code a bit, removed the `scanning' flag which was
 indeed unnecessary.

 This should be the final version of the patch.

 drivers/base/regmap/regmap-debugfs.c | 175 +++++++++++++++++++++++++++++++++++
 1 file changed, 175 insertions(+)

diff --git a/drivers/base/regmap/regmap-debugfs.c b/drivers/base/regmap/regmap-debugfs.c
index 0866c42..2c8fd4e 100644
--- a/drivers/base/regmap/regmap-debugfs.c
+++ b/drivers/base/regmap/regmap-debugfs.c
@@ -240,6 +240,178 @@ static const struct file_operations regmap_map_fops = {
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
+enum range_state {
+	RANGE_START,
+	RANGE_END,
+	RANGE_WITHIN,
+	RANGE_DONE,
+};
+
+struct regmap_reg_range  {
+	unsigned int start;
+	unsigned int end;
+	unsigned int attr;
+};
+
+static void regmap_range_format_line(struct regmap *map,
+				     struct regmap_reg_range *r,
+				     char *buf, size_t len)
+{
+	ssize_t buf_offset;
+
+	buf_offset = snprintf(buf, PAGE_SIZE, "%x-%x ",
+			      r->start, r->end);
+	buf_offset += snprintf(buf + buf_offset,
+			       PAGE_SIZE - buf_offset, "(");
+	if (r->attr & READABLE)
+		buf_offset += snprintf(buf + buf_offset,
+				       PAGE_SIZE - buf_offset,
+				       "read, ");
+	if (r->attr & WRITEABLE)
+		buf_offset += snprintf(buf + buf_offset,
+				       PAGE_SIZE - buf_offset,
+				       "write, ");
+	if (r->attr & VOLATILE)
+		buf_offset += snprintf(buf + buf_offset,
+				       PAGE_SIZE - buf_offset,
+				       "volatile, ");
+	/* Rewind the last ", " as well */
+	buf_offset += snprintf(buf + buf_offset - 2,
+			       PAGE_SIZE - buf_offset, ")");
+}
+
+static ssize_t regmap_range_read_file(struct file *file,
+				      char __user *user_buf, size_t count,
+				      loff_t *ppos)
+{
+	struct regmap *map = file->private_data;
+	int ret;
+	char *buf;
+	size_t buf_pos = 0;
+	loff_t p = 0;
+	unsigned int start_reg;
+	int i;
+	unsigned int reg_attr;
+	unsigned int block_start, block_end, block_attr;
+	enum range_state state;
+	struct regmap_reg_range r;
+	char *entry;
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
+	start_reg = 0;
+	block_attr = regmap_attr_bitmap(map, start_reg);
+	block_start = block_end = start_reg;
+	state = RANGE_START;
+
+	i = start_reg;
+	while (i <= map->max_register) {
+		reg_attr = regmap_attr_bitmap(map, i);
+		switch (state) {
+		case RANGE_START:
+			block_start = i;
+			block_attr = reg_attr;
+			state = RANGE_WITHIN;
+			break;
+		case RANGE_END:
+			r.start = block_start;
+			r.end = block_end;
+			r.attr = block_attr;
+			/* Only care about regions where any of the 3 register
+			   attributes are set */
+			if (r.attr) {
+				regmap_range_format_line(map, &r, entry, PAGE_SIZE);
+				if (p >= *ppos) {
+					/* We can't fit any more data into this buf
+					 * so no use to loop around anymore, just
+					 * give the data back to user */
+					if (buf_pos + 1 + strlen(entry) >= count)
+						goto out_entry;
+					snprintf(buf + buf_pos, count - buf_pos,
+						 "%s", entry);
+					buf_pos += strlen(entry);
+					buf[buf_pos] = '\n';
+					buf_pos++;
+				}
+				p += strlen(entry) + 1;
+			}
+			if (i + 1 > map->max_register)
+				state = RANGE_DONE;
+			else
+				state = RANGE_START;
+			break;
+		case RANGE_WITHIN:
+			if (reg_attr != block_attr) {
+				block_end = i - 1;
+				state = RANGE_END;
+			} else {
+				if (i + 1 > map->max_register) {
+					state = RANGE_END;
+					block_end = map->max_register;
+				}
+				else {
+					i++;
+				}
+			}
+			break;
+		case RANGE_DONE:
+			i++;
+			break;
+		}
+	}
+
+out_entry:
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
+static const struct file_operations regmap_range_fops = {
+	.open = simple_open,
+	.read = regmap_range_read_file,
+	.llseek = default_llseek,
+};
+
 static ssize_t regmap_access_read_file(struct file *file,
 				       char __user *user_buf, size_t count,
 				       loff_t *ppos)
@@ -322,6 +494,9 @@ void regmap_debugfs_init(struct regmap *map)
 	debugfs_create_file("name", 0400, map->debugfs,
 			    map, &regmap_name_fops);
 
+	debugfs_create_file("range", 0400, map->debugfs,
+			    map, &regmap_range_fops);
+
 	if (map->max_register) {
 		debugfs_create_file("registers", 0400, map->debugfs,
 				    map, &regmap_map_fops);
-- 
1.8.1.2

