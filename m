Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752382AbaCITaz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Mar 2014 15:30:55 -0400
Received: from mail-ea0-f177.google.com ([209.85.215.177]:46685 "EHLO
	mail-ea0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750962AbaCITay (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Mar 2014 15:30:54 -0400
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Minchan Kim <minchan@kernel.org>, Jerome Marchand <jmarchan@redhat.com>,
        Nitin Gupta <ngupta@vflare.org>, linux-kernel@vger.kernel.org,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Subject: [PATCH] zram: use scnprintf() in attrs show() methods
Date: Sun,  9 Mar 2014 22:27:08 +0300
Message-Id: <1394393228-14713-1-git-send-email-sergey.senozhatsky@gmail.com>
X-Mailer: git-send-email 1.9.0.477.g83111a0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sysfs.txt documentation lists the following requirements:

 - The buffer will always be PAGE_SIZE bytes in length. On i386, this
   is 4096.

 - show() methods should return the number of bytes printed into the
   buffer. This is the return value of scnprintf().

 - show() should always use scnprintf().

Use scnprintf() in show() functions.

Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
---
 drivers/block/zram/zcomp.c    |  8 +++++---
 drivers/block/zram/zram_drv.c | 12 ++++++------
 2 files changed, 11 insertions(+), 9 deletions(-)

diff --git a/drivers/block/zram/zcomp.c b/drivers/block/zram/zcomp.c
index 92a83df..ffcaff7 100644
--- a/drivers/block/zram/zcomp.c
+++ b/drivers/block/zram/zcomp.c
@@ -274,12 +274,14 @@ ssize_t zcomp_available_show(const char *comp, char *buf)
 
 	while (backends[i]) {
 		if (sysfs_streq(comp, backends[i]->name))
-			sz += sprintf(buf + sz, "[%s] ", backends[i]->name);
+			sz += scnprintf(buf + sz, PAGE_SIZE - sz - 2,
+					"[%s] ", backends[i]->name);
 		else
-			sz += sprintf(buf + sz, "%s ", backends[i]->name);
+			sz += scnprintf(buf + sz, PAGE_SIZE - sz - 2,
+					"%s ", backends[i]->name);
 		i++;
 	}
-	sz += sprintf(buf + sz, "\n");
+	sz += scnprintf(buf + sz, PAGE_SIZE - sz, "\n");
 	return sz;
 }
 
diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index 7631ef0..e6ff420 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -47,7 +47,7 @@ static ssize_t zram_attr_##name##_show(struct device *d,		\
 				struct device_attribute *attr, char *b)	\
 {									\
 	struct zram *zram = dev_to_zram(d);				\
-	return sprintf(b, "%llu\n",					\
+	return scnprintf(b, PAGE_SIZE, "%llu\n",			\
 		(u64)atomic64_read(&zram->stats.name));			\
 }									\
 static struct device_attribute dev_attr_##name =			\
@@ -68,7 +68,7 @@ static ssize_t disksize_show(struct device *dev,
 {
 	struct zram *zram = dev_to_zram(dev);
 
-	return sprintf(buf, "%llu\n", zram->disksize);
+	return scnprintf(buf, PAGE_SIZE, "%llu\n", zram->disksize);
 }
 
 static ssize_t initstate_show(struct device *dev,
@@ -81,7 +81,7 @@ static ssize_t initstate_show(struct device *dev,
 	val = init_done(zram);
 	up_read(&zram->init_lock);
 
-	return sprintf(buf, "%u\n", val);
+	return scnprintf(buf, PAGE_SIZE, "%u\n", val);
 }
 
 static ssize_t orig_data_size_show(struct device *dev,
@@ -89,7 +89,7 @@ static ssize_t orig_data_size_show(struct device *dev,
 {
 	struct zram *zram = dev_to_zram(dev);
 
-	return sprintf(buf, "%llu\n",
+	return scnprintf(buf, PAGE_SIZE, "%llu\n",
 		(u64)(atomic64_read(&zram->stats.pages_stored)) << PAGE_SHIFT);
 }
 
@@ -105,7 +105,7 @@ static ssize_t mem_used_total_show(struct device *dev,
 		val = zs_get_total_size_bytes(meta->mem_pool);
 	up_read(&zram->init_lock);
 
-	return sprintf(buf, "%llu\n", val);
+	return scnprintf(buf, PAGE_SIZE, "%llu\n", val);
 }
 
 static ssize_t max_comp_streams_show(struct device *dev,
@@ -118,7 +118,7 @@ static ssize_t max_comp_streams_show(struct device *dev,
 	val = zram->max_comp_streams;
 	up_read(&zram->init_lock);
 
-	return sprintf(buf, "%d\n", val);
+	return scnprintf(buf, PAGE_SIZE, "%d\n", val);
 }
 
 static ssize_t max_comp_streams_store(struct device *dev,
-- 
1.9.0.477.g83111a0

