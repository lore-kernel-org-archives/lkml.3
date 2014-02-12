Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754272AbaBLTnh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 14:43:37 -0500
Received: from mail-ee0-f45.google.com ([74.125.83.45]:45088 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754251AbaBLTnc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 14:43:32 -0500
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: Minchan Kim <minchan@kernel.org>
Cc: Jerome Marchand <jmarchan@redhat.com>, Nitin Gupta <ngupta@vflare.org>,
        linux-kernel@vger.kernel.org,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Subject: [PATCHv4 3/4] zram: support multi compressing buffers
Date: Wed, 12 Feb 2014 22:39:35 +0300
Message-Id: <1392233976-26473-5-git-send-email-sergey.senozhatsky@gmail.com>
X-Mailer: git-send-email 1.9.0.rc3.256.g4af3ebd
In-Reply-To: <1392233976-26473-1-git-send-email-sergey.senozhatsky@gmail.com>
References: <1392233976-26473-1-git-send-email-sergey.senozhatsky@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

1) Extend zcomp zcomp_create() with `num_strm' parameter.
`num_strm' limits the number of zcomp_strm structs in compression
backend's idle list (max buffers).

2) Introduce zram device attribute max_comp_streams to show and
store current device's zcomp max number of zcomp streams (num_strm).

Usage example:
        echo 4 > /sys/block/zram0/max_comp_streams

set max_comp_streams to 4

        cat /sys/block/zram0/max_comp_streams

show current max_comp_streams (default value is 1).

iozone -t -T -R -l 3 -u 3 -r 16K -s 60M -I +Z
(write tests. ext4, lzo, each test performed on newly created
 zram0 device)

        test        max_comp_streams 1    max_comp_streams 3
-------------------------------------------------------------
"  Initial write "      631583.39     |      727834.88
"        Rewrite "      456248.23     |     2105054.97
" Mixed workload "     3370016.43     |     3509382.86
"   Random write "      467703.56     |     1953464.78
"         Pwrite "      629146.88     |      775372.46
"         Fwrite "     2573117.39     |     2529637.62

        test        max_comp_streams 1    max_comp_streams 3
-------------------------------------------------------------
"  Initial write "      601112.91     |      765866.05
"        Rewrite "      447834.33     |     2163449.58
" Mixed workload "     2575128.08     |     3257711.77
"   Random write "      461327.45     |     1974731.12
"         Pwrite "      567038.36     |      740242.52
"         Fwrite "     2527107.44     |     2754336.64

Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
---
 drivers/block/zram/zcomp.c    | 15 +++++++++------
 drivers/block/zram/zcomp.h    |  2 +-
 drivers/block/zram/zram_drv.c | 42 +++++++++++++++++++++++++++++++++++++++++-
 drivers/block/zram/zram_drv.h |  2 +-
 4 files changed, 52 insertions(+), 9 deletions(-)

diff --git a/drivers/block/zram/zcomp.c b/drivers/block/zram/zcomp.c
index 3b4920f..45d906a 100644
--- a/drivers/block/zram/zcomp.c
+++ b/drivers/block/zram/zcomp.c
@@ -124,11 +124,12 @@ static struct zcomp_backend *find_backend(const char *compress)
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
@@ -143,11 +144,13 @@ struct zcomp *zcomp_create(const char *compress)
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
+		list_add_tail(&zstrm->list, &comp->idle_strm);
 	}
-	list_add_tail(&zstrm->list, &comp->idle_strm);
 	return comp;
 }
diff --git a/drivers/block/zram/zcomp.h b/drivers/block/zram/zcomp.h
index 213e503..9b34f48 100644
--- a/drivers/block/zram/zcomp.h
+++ b/drivers/block/zram/zcomp.h
@@ -43,7 +43,7 @@ struct zcomp {
 	struct zcomp_backend *backend;
 };
 
-struct zcomp *zcomp_create(const char *comp);
+struct zcomp *zcomp_create(const char *comp, int num_strm);
 void zcomp_destroy(struct zcomp *comp);
 
 struct zcomp_strm *zcomp_strm_get(struct zcomp *comp);
diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index d0d7254..551202b 100644
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
+		pr_info("Cannot set max buffers for initialized device\n");
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
@@ -505,6 +540,7 @@ static void zram_reset_device(struct zram *zram, bool reset_capacity)
 	if (zram->comp)
 		zcomp_destroy(zram->comp);
 	zram->comp = NULL;
+	zram->max_comp_streams = 1;
 
 	zram_meta_free(zram->meta);
 	zram->meta = NULL;
@@ -534,7 +570,7 @@ static ssize_t disksize_store(struct device *dev,
 		return -EBUSY;
 	}
 
-	zram->comp = zcomp_create(default_compressor);
+	zram->comp = zcomp_create(default_compressor, zram->max_comp_streams);
 	if (!zram->comp) {
 		up_write(&zram->init_lock);
 		pr_info("Cannot initialise compressing backend\n");
@@ -697,6 +733,8 @@ static DEVICE_ATTR(initstate, S_IRUGO, initstate_show, NULL);
 static DEVICE_ATTR(reset, S_IWUSR, NULL, reset_store);
 static DEVICE_ATTR(orig_data_size, S_IRUGO, orig_data_size_show, NULL);
 static DEVICE_ATTR(mem_used_total, S_IRUGO, mem_used_total_show, NULL);
+static DEVICE_ATTR(max_comp_streams, S_IRUGO | S_IWUSR,
+		max_comp_streams_show, max_comp_streams_store);
 
 ZRAM_ATTR_RO(num_reads);
 ZRAM_ATTR_RO(num_writes);
@@ -721,6 +759,7 @@ static struct attribute *zram_disk_attrs[] = {
 	&dev_attr_orig_data_size.attr,
 	&dev_attr_compr_data_size.attr,
 	&dev_attr_mem_used_total.attr,
+	&dev_attr_max_comp_streams.attr,
 	NULL,
 };
 
@@ -784,6 +823,7 @@ static int create_device(struct zram *zram, int device_id)
 
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
1.9.0.rc3.256.g4af3ebd

