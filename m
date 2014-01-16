Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752898AbaAPNQJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 08:16:09 -0500
Received: from mail-ee0-f48.google.com ([74.125.83.48]:41916 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752870AbaAPNQG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 08:16:06 -0500
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Minchan Kim <minchan@kernel.org>, Jerome Marchand <jmarchan@redhat.com>,
        Nitin Gupta <ngupta@vflare.org>, linux-kernel@vger.kernel.org,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Subject: [PATCHv3 5/8] zram: remove zram stats code duplication
Date: Thu, 16 Jan 2014 16:12:13 +0300
Message-Id: <1389877936-15543-6-git-send-email-sergey.senozhatsky@gmail.com>
X-Mailer: git-send-email 1.8.5.3.493.gb139ac2
In-Reply-To: <1389877936-15543-1-git-send-email-sergey.senozhatsky@gmail.com>
References: <1389877936-15543-1-git-send-email-sergey.senozhatsky@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce ZRAM_ATTR_RO macro that generates device_attribute
and default ATTR show() function for existing atomic64_t zram
stats.

Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
---
 drivers/block/zram/zram_drv.c | 82 ++++++++++++-------------------------------
 1 file changed, 23 insertions(+), 59 deletions(-)

diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index 0035d39..e7102f1 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -42,6 +42,17 @@ static struct zram *zram_devices;
 /* Module params (documentation at end) */
 static unsigned int num_devices = 1;
 
+#define ZRAM_ATTR_RO(name)						\
+static ssize_t zram_attr_##name##_show(struct device *d,		\
+				struct device_attribute *attr, char *b)	\
+{									\
+	struct zram *zram = dev_to_zram(d);				\
+	return sprintf(b, "%llu\n",					\
+		(u64)atomic64_read(&zram->stats.name));			\
+}									\
+static struct device_attribute dev_attr_##name =			\
+	__ATTR(name, S_IRUGO, zram_attr_##name##_show, NULL);
+
 static inline int init_done(struct zram *zram)
 {
 	return zram->meta != NULL;
@@ -63,53 +74,14 @@ static ssize_t disksize_show(struct device *dev,
 static ssize_t initstate_show(struct device *dev,
 		struct device_attribute *attr, char *buf)
 {
+	u32 val;
 	struct zram *zram = dev_to_zram(dev);
 
-	return sprintf(buf, "%u\n", init_done(zram));
-}
-
-static ssize_t num_reads_show(struct device *dev,
-		struct device_attribute *attr, char *buf)
-{
-	struct zram *zram = dev_to_zram(dev);
-
-	return sprintf(buf, "%llu\n",
-			(u64)atomic64_read(&zram->stats.num_reads));
-}
-
-static ssize_t num_writes_show(struct device *dev,
-		struct device_attribute *attr, char *buf)
-{
-	struct zram *zram = dev_to_zram(dev);
-
-	return sprintf(buf, "%llu\n",
-			(u64)atomic64_read(&zram->stats.num_writes));
-}
-
-static ssize_t invalid_io_show(struct device *dev,
-		struct device_attribute *attr, char *buf)
-{
-	struct zram *zram = dev_to_zram(dev);
-
-	return sprintf(buf, "%llu\n",
-			(u64)atomic64_read(&zram->stats.invalid_io));
-}
-
-static ssize_t notify_free_show(struct device *dev,
-		struct device_attribute *attr, char *buf)
-{
-	struct zram *zram = dev_to_zram(dev);
-
-	return sprintf(buf, "%llu\n",
-			(u64)atomic64_read(&zram->stats.notify_free));
-}
-
-static ssize_t zero_pages_show(struct device *dev,
-		struct device_attribute *attr, char *buf)
-{
-	struct zram *zram = dev_to_zram(dev);
+	down_read(&zram->init_lock);
+	val = init_done(zram);
+	up_read(&zram->init_lock);
 
-	return sprintf(buf, "%llu\n", (u64)atomic64_read(&zram->stats.zero_pages));
+	return sprintf(buf, "%u\n", val);
 }
 
 static ssize_t orig_data_size_show(struct device *dev,
@@ -121,15 +93,6 @@ static ssize_t orig_data_size_show(struct device *dev,
 		(u64)(atomic64_read(&zram->stats.pages_stored)) << PAGE_SHIFT);
 }
 
-static ssize_t compr_data_size_show(struct device *dev,
-		struct device_attribute *attr, char *buf)
-{
-	struct zram *zram = dev_to_zram(dev);
-
-	return sprintf(buf, "%llu\n",
-			(u64)atomic64_read(&zram->stats.compr_data_size));
-}
-
 static ssize_t mem_used_total_show(struct device *dev,
 		struct device_attribute *attr, char *buf)
 {
@@ -760,15 +723,16 @@ static DEVICE_ATTR(disksize, S_IRUGO | S_IWUSR,
 		disksize_show, disksize_store);
 static DEVICE_ATTR(initstate, S_IRUGO, initstate_show, NULL);
 static DEVICE_ATTR(reset, S_IWUSR, NULL, reset_store);
-static DEVICE_ATTR(num_reads, S_IRUGO, num_reads_show, NULL);
-static DEVICE_ATTR(num_writes, S_IRUGO, num_writes_show, NULL);
-static DEVICE_ATTR(invalid_io, S_IRUGO, invalid_io_show, NULL);
-static DEVICE_ATTR(notify_free, S_IRUGO, notify_free_show, NULL);
-static DEVICE_ATTR(zero_pages, S_IRUGO, zero_pages_show, NULL);
 static DEVICE_ATTR(orig_data_size, S_IRUGO, orig_data_size_show, NULL);
-static DEVICE_ATTR(compr_data_size, S_IRUGO, compr_data_size_show, NULL);
 static DEVICE_ATTR(mem_used_total, S_IRUGO, mem_used_total_show, NULL);
 
+ZRAM_ATTR_RO(num_reads);
+ZRAM_ATTR_RO(num_writes);
+ZRAM_ATTR_RO(invalid_io);
+ZRAM_ATTR_RO(notify_free);
+ZRAM_ATTR_RO(zero_pages);
+ZRAM_ATTR_RO(compr_data_size);
+
 static struct attribute *zram_disk_attrs[] = {
 	&dev_attr_disksize.attr,
 	&dev_attr_initstate.attr,
-- 
1.8.5.3.493.gb139ac2

