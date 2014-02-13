Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752708AbaBMRrG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 12:47:06 -0500
Received: from mail-ea0-f181.google.com ([209.85.215.181]:33941 "EHLO
	mail-ea0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752653AbaBMRrC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 12:47:02 -0500
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: Minchan Kim <minchan@kernel.org>
Cc: Jerome Marchand <jmarchan@redhat.com>, Nitin Gupta <ngupta@vflare.org>,
        linux-kernel@vger.kernel.org,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Subject: [PATCHv5 3/4] zram: zcomp support multi compressing streams
Date: Thu, 13 Feb 2014 20:43:21 +0300
Message-Id: <1392313402-5728-4-git-send-email-sergey.senozhatsky@gmail.com>
X-Mailer: git-send-email 1.9.0.rc3.260.g4cf525c
In-Reply-To: <1392313402-5728-1-git-send-email-sergey.senozhatsky@gmail.com>
References: <1392313402-5728-1-git-send-email-sergey.senozhatsky@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

1) Extend zcomp zcomp_create() with `num_strm' parameter.
`num_strm' limits the number of zcomp_strm structs in compression
backend's idle list (max_comp_streams). thus, it's possible to
have up to max_comp_streams parallel compress operations.

2) Introduce zram device attribute max_comp_streams to show and
store current device's zcomp max number of zcomp streams (num_strm).

Usage example:
        echo 4 > /sys/block/zram0/max_comp_streams

set max_comp_streams to 4

        cat /sys/block/zram0/max_comp_streams

show current max_comp_streams (default value is 1).

iozone -t 3 -R -r 16K -s 60M -I +Z
(write tests. ext4, lzo, each test performed on newly created
 zram0 device)

        test        max_comp_streams 1    max_comp_streams 3
-------------------------------------------------------------
"  Initial write "      549804.75      |       703499.52
"        Rewrite "      531435.43      |      1486276.59
" Mixed workload "     1085846.34      |      1237846.88
"   Random write "      549573.95      |      1375186.91
"         Pwrite "      515619.08      |       729404.86
"         Fwrite "     1443161.84      |      1469171.97

        test        max_comp_streams 1    max_comp_streams 3
-------------------------------------------------------------
"  Initial write "      571307.19      |       719940.72
"        Rewrite "      534797.36      |      1475686.41
" Mixed workload "     1588736.53      |      1662039.41
"   Random write "      563608.17      |      1373689.31
"         Pwrite "      586889.88      |       717255.91
"         Fwrite "     1479426.94      |      1482781.22

Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
---
 drivers/block/zram/zcomp.c    | 15 +++++++++------
 drivers/block/zram/zcomp.h    |  2 +-
 drivers/block/zram/zram_drv.c | 42 +++++++++++++++++++++++++++++++++++++++++-
 drivers/block/zram/zram_drv.h |  2 +-
 4 files changed, 52 insertions(+), 9 deletions(-)

diff --git a/drivers/block/zram/zcomp.c b/drivers/block/zram/zcomp.c
index 3af25b6..a032f49 100644
--- a/drivers/block/zram/zcomp.c
+++ b/drivers/block/zram/zcomp.c
@@ -122,11 +122,12 @@ static struct zcomp_backend *find_backend(const char *compress)
  * if requested algorithm is not supported or in case
  * of init error
  */
-struct zcomp *zcomp_create(const char *compress)
+struct zcomp *zcomp_create(const char *compress, int num_strm)
 {
 	struct zcomp *comp;
 	struct zcomp_backend *backend;
 	struct zcomp_strm *zstrm;
+	int i;
 
 	backend = find_backend(compress);
 	if (!backend)
@@ -141,11 +142,13 @@ struct zcomp *zcomp_create(const char *compress)
 	INIT_LIST_HEAD(&comp->idle_strm);
 	init_waitqueue_head(&comp->strm_wait);
 
-	zstrm = zcomp_strm_alloc(comp);
-	if (!zstrm) {
-		zcomp_destroy(comp);
-		return NULL;
+	for (i = 0; i < num_strm; i++) {
+		zstrm = zcomp_strm_alloc(comp);
+		if (!zstrm) {
+			zcomp_destroy(comp);
+			return NULL;
+		}
+		list_add(&zstrm->list, &comp->idle_strm);
 	}
-	list_add(&zstrm->list, &comp->idle_strm);
 	return comp;
 }
diff --git a/drivers/block/zram/zcomp.h b/drivers/block/zram/zcomp.h
index 7e05d20..52899de 100644
--- a/drivers/block/zram/zcomp.h
+++ b/drivers/block/zram/zcomp.h
@@ -42,7 +42,7 @@ struct zcomp {
 	struct zcomp_backend *backend;
 };
 
-struct zcomp *zcomp_create(const char *comp);
+struct zcomp *zcomp_create(const char *comp, int num_strm);
 void zcomp_destroy(struct zcomp *comp);
 
 struct zcomp_strm *zcomp_strm_get(struct zcomp *comp);
diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index 200c12a..93c5d29 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -107,6 +107,41 @@ static ssize_t mem_used_total_show(struct device *dev,
 	return sprintf(buf, "%llu\n", val);
 }
 
+static ssize_t max_comp_streams_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	long val;
+	struct zram *zram = dev_to_zram(dev);
+
+	down_read(&zram->init_lock);
+	val = zram->max_comp_streams;
+	up_read(&zram->init_lock);
+
+	return sprintf(buf, "%ld\n", val);
+}
+
+static ssize_t max_comp_streams_store(struct device *dev,
+		struct device_attribute *attr, const char *buf, size_t len)
+{
+	long num;
+	struct zram *zram = dev_to_zram(dev);
+
+	if (kstrtol(buf, 0, &num))
+		return -EINVAL;
+	if (num < 1)
+		return -EINVAL;
+	down_write(&zram->init_lock);
+	if (init_done(zram)) {
+		up_write(&zram->init_lock);
+		pr_info("Can't set max_comp_streams for initialized device\n");
+		return -EBUSY;
+	}
+	zram->max_comp_streams = num;
+	up_write(&zram->init_lock);
+
+	return len;
+}
+
 /* flag operations needs meta->tb_lock */
 static int zram_test_flag(struct zram_meta *meta, u32 index,
 			enum zram_pageflags flag)
@@ -503,6 +538,7 @@ static void zram_reset_device(struct zram *zram, bool reset_capacity)
 
 	zcomp_destroy(zram->comp);
 	zram->comp = NULL;
+	zram->max_comp_streams = 1;
 
 	zram_meta_free(zram->meta);
 	zram->meta = NULL;
@@ -532,7 +568,7 @@ static ssize_t disksize_store(struct device *dev,
 		return -EBUSY;
 	}
 
-	zram->comp = zcomp_create(default_compressor);
+	zram->comp = zcomp_create(default_compressor, zram->max_comp_streams);
 	if (!zram->comp) {
 		up_write(&zram->init_lock);
 		pr_info("Cannot initialise compressing backend\n");
@@ -695,6 +731,8 @@ static DEVICE_ATTR(initstate, S_IRUGO, initstate_show, NULL);
 static DEVICE_ATTR(reset, S_IWUSR, NULL, reset_store);
 static DEVICE_ATTR(orig_data_size, S_IRUGO, orig_data_size_show, NULL);
 static DEVICE_ATTR(mem_used_total, S_IRUGO, mem_used_total_show, NULL);
+static DEVICE_ATTR(max_comp_streams, S_IRUGO | S_IWUSR,
+		max_comp_streams_show, max_comp_streams_store);
 
 ZRAM_ATTR_RO(num_reads);
 ZRAM_ATTR_RO(num_writes);
@@ -719,6 +757,7 @@ static struct attribute *zram_disk_attrs[] = {
 	&dev_attr_orig_data_size.attr,
 	&dev_attr_compr_data_size.attr,
 	&dev_attr_mem_used_total.attr,
+	&dev_attr_max_comp_streams.attr,
 	NULL,
 };
 
@@ -782,6 +821,7 @@ static int create_device(struct zram *zram, int device_id)
 
 	zram->meta = NULL;
 	zram->comp = NULL;
+	zram->max_comp_streams = 1;
 	return 0;
 
 out_free_disk:
diff --git a/drivers/block/zram/zram_drv.h b/drivers/block/zram/zram_drv.h
index 45e04f7..8dccb22 100644
--- a/drivers/block/zram/zram_drv.h
+++ b/drivers/block/zram/zram_drv.h
@@ -99,7 +99,7 @@ struct zram {
 	 * we can store in a disk.
 	 */
 	u64 disksize;	/* bytes */
-
+	long max_comp_streams;
 	struct zram_stats stats;
 };
 #endif
-- 
1.9.0.rc3.260.g4cf525c

