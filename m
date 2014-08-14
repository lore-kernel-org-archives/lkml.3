Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754059AbaHNBMX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 21:12:23 -0400
Received: from lgeamrelo04.lge.com ([156.147.1.127]:61932 "EHLO
	lgeamrelo04.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752789AbaHNBMT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 21:12:19 -0400
X-Original-SENDERIP: 10.177.222.156
X-Original-MAILFROM: minchan@kernel.org
From: Minchan Kim <minchan@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Jerome Marchand <jmarchan@redhat.com>, juno.choi@lge.com,
        seungho1.park@lge.com, Luigi Semenzato <semenzato@google.com>,
        Nitin Gupta <ngupta@vflare.org>,
        Seth Jennings <sjennings@variantweb.net>,
        Dan Streetman <ddstreet@ieee.org>, ds2horner@gmail.com,
        Minchan Kim <minchan@kernel.org>
Subject: [PATCH 3/3] zram: add mem_used_max via sysfs
Date: Thu, 14 Aug 2014 10:12:26 +0900
Message-Id: <1407978746-20587-3-git-send-email-minchan@kernel.org>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1407978746-20587-1-git-send-email-minchan@kernel.org>
References: <1407978746-20587-1-git-send-email-minchan@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Normally, zram user can get maximum memory zsmalloc consumed via
polling mem_used_total with sysfs in userspace.

But it has a critical problem because user can miss peak memory
usage during update interval of polling. For avoiding that,
user should poll it frequently with mlocking to avoid delay
when memory pressure is heavy so it would be handy if the
kernel supports the function.

This patch adds mem_used_max via sysfs.

Signed-off-by: Minchan Kim <minchan@kernel.org>
---
 Documentation/blockdev/zram.txt |  1 +
 drivers/block/zram/zram_drv.c   | 35 +++++++++++++++++++++++++++++++++--
 drivers/block/zram/zram_drv.h   |  2 ++
 3 files changed, 36 insertions(+), 2 deletions(-)

diff --git a/Documentation/blockdev/zram.txt b/Documentation/blockdev/zram.txt
index 9f239ff8c444..3b2247c2d4cf 100644
--- a/Documentation/blockdev/zram.txt
+++ b/Documentation/blockdev/zram.txt
@@ -107,6 +107,7 @@ size of the disk when not in use so a huge zram is wasteful.
 		orig_data_size
 		compr_data_size
 		mem_used_total
+		mem_used_max
 
 8) Deactivate:
 	swapoff /dev/zram0
diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index b48a3d0e9031..311699f18bd5 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -109,6 +109,30 @@ static ssize_t mem_used_total_show(struct device *dev,
 	return scnprintf(buf, PAGE_SIZE, "%llu\n", val);
 }
 
+static ssize_t mem_used_max_reset(struct device *dev,
+		struct device_attribute *attr, const char *buf, size_t len)
+{
+	struct zram *zram = dev_to_zram(dev);
+
+	down_write(&zram->init_lock);
+	zram->max_used_bytes = 0;
+	up_write(&zram->init_lock);
+	return len;
+}
+
+static ssize_t mem_used_max_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	u64 max_used_bytes;
+	struct zram *zram = dev_to_zram(dev);
+
+	down_read(&zram->init_lock);
+	max_used_bytes = zram->max_used_bytes;
+	up_read(&zram->init_lock);
+
+	return scnprintf(buf, PAGE_SIZE, "%llu\n", max_used_bytes);
+}
+
 static ssize_t max_comp_streams_show(struct device *dev,
 		struct device_attribute *attr, char *buf)
 {
@@ -474,6 +498,7 @@ static int zram_bvec_write(struct zram *zram, struct bio_vec *bvec, u32 index,
 	struct zram_meta *meta = zram->meta;
 	struct zcomp_strm *zstrm;
 	bool locked = false;
+	u64 total_bytes;
 
 	page = bvec->bv_page;
 	if (is_partial_io(bvec)) {
@@ -543,8 +568,8 @@ static int zram_bvec_write(struct zram *zram, struct bio_vec *bvec, u32 index,
 		goto out;
 	}
 
-	if (zram->limit_bytes &&
-		zs_get_total_size_bytes(meta->mem_pool) > zram->limit_bytes) {
+	total_bytes = zs_get_total_size_bytes(meta->mem_pool);
+	if (zram->limit_bytes && total_bytes > zram->limit_bytes) {
 		zs_free(meta->mem_pool, handle);
 		ret = -ENOMEM;
 		goto out;
@@ -578,6 +603,8 @@ static int zram_bvec_write(struct zram *zram, struct bio_vec *bvec, u32 index,
 	/* Update stats */
 	atomic64_add(clen, &zram->stats.compr_data_size);
 	atomic64_inc(&zram->stats.pages_stored);
+
+	zram->max_used_bytes = max(zram->max_used_bytes, total_bytes);
 out:
 	if (locked)
 		zcomp_strm_release(zram->comp, zstrm);
@@ -656,6 +683,7 @@ static void zram_reset_device(struct zram *zram, bool reset_capacity)
 	down_write(&zram->init_lock);
 
 	zram->limit_bytes = 0;
+	zram->max_used_bytes = 0;
 
 	if (!init_done(zram)) {
 		up_write(&zram->init_lock);
@@ -897,6 +925,8 @@ static DEVICE_ATTR(initstate, S_IRUGO, initstate_show, NULL);
 static DEVICE_ATTR(reset, S_IWUSR, NULL, reset_store);
 static DEVICE_ATTR(orig_data_size, S_IRUGO, orig_data_size_show, NULL);
 static DEVICE_ATTR(mem_used_total, S_IRUGO, mem_used_total_show, NULL);
+static DEVICE_ATTR(mem_used_max, S_IRUGO | S_IWUSR, mem_used_max_show,
+		mem_used_max_reset);
 static DEVICE_ATTR(mem_limit, S_IRUGO | S_IWUSR, mem_limit_show,
 		mem_limit_store);
 static DEVICE_ATTR(max_comp_streams, S_IRUGO | S_IWUSR,
@@ -927,6 +957,7 @@ static struct attribute *zram_disk_attrs[] = {
 	&dev_attr_orig_data_size.attr,
 	&dev_attr_compr_data_size.attr,
 	&dev_attr_mem_used_total.attr,
+	&dev_attr_mem_used_max.attr,
 	&dev_attr_mem_limit.attr,
 	&dev_attr_max_comp_streams.attr,
 	&dev_attr_comp_algorithm.attr,
diff --git a/drivers/block/zram/zram_drv.h b/drivers/block/zram/zram_drv.h
index 086c51782e75..aca09b18fcbd 100644
--- a/drivers/block/zram/zram_drv.h
+++ b/drivers/block/zram/zram_drv.h
@@ -111,6 +111,8 @@ struct zram {
 	 */
 	u64 disksize;	/* bytes */
 	u64 limit_bytes;
+	u64 max_used_bytes;
+
 	int max_comp_streams;
 	struct zram_stats stats;
 	char compressor[10];
-- 
2.0.0

