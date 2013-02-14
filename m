Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934743Ab3BNQcY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 11:32:24 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:57789 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761454Ab3BNQcV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 11:32:21 -0500
From: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com
Subject: [PATCH 3/3] regmap: debugfs: Add a registers `range' file
Date: Thu, 14 Feb 2013 16:30:01 +0000
Message-Id: <1360859401-752-3-git-send-email-dp@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.8.1.3
In-Reply-To: <1360859401-752-1-git-send-email-dp@opensource.wolfsonmicro.com>
References: <1360859401-752-1-git-send-email-dp@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This file lists the register ranges in the register map.  The condition
to split the range is based on whether the block is readable or not.

Signed-off-by: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>
---
 drivers/base/regmap/regmap-debugfs.c | 76 ++++++++++++++++++++++++++++++++++++
 1 file changed, 76 insertions(+)

diff --git a/drivers/base/regmap/regmap-debugfs.c b/drivers/base/regmap/regmap-debugfs.c
index a6b5606..61e2c52 100644
--- a/drivers/base/regmap/regmap-debugfs.c
+++ b/drivers/base/regmap/regmap-debugfs.c
@@ -312,6 +312,79 @@ static const struct file_operations regmap_range_fops = {
 	.llseek = default_llseek,
 };
 
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
+	mutex_lock(&map->cache_lock);
+	list_for_each_entry(c, &map->debugfs_off_cache, list) {
+		snprintf(entry, PAGE_SIZE, "%x-%x",
+			 c->base_reg, c->max_reg);
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
+	mutex_unlock(&map->cache_lock);
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
@@ -405,6 +478,9 @@ void regmap_debugfs_init(struct regmap *map, const char *name)
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

