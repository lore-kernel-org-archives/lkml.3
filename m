Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752238Ab3BKE3L (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2013 23:29:11 -0500
Received: from g6t0185.atlanta.hp.com ([15.193.32.62]:42503 "EHLO
	g6t0185.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751929Ab3BKE3J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2013 23:29:09 -0500
Message-ID: <1360556946.4204.5.camel@buesod1.americas.hpqcorp.net>
Subject: [PATCH 2/2] zram: gather statistics in a unique file
From: Davidlohr Bueso <davidlohr.bueso@hp.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Nitin Gupta <ngupta@vflare.org>
Date: Sun, 10 Feb 2013 20:29:06 -0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of having one sysfs file per zram statistic, group them all
in a single, reader-friendly, 'statistics' file. This not only reduces
code but is also makes it easier to visualize. The new file looks like:

Number of reads:        24
Number of writes:       1055
Invalid IO:             0
Notify free:            0
Zero pages:             1042
Orig data size:         49152 bytes
Compressed data:        838 bytes
Total memory used:      53248 bytes

Signed-off-by: Davidlohr Bueso <davidlohr.bueso@hp.com>
---
 drivers/staging/zram/zram.txt     |  20 ++-----
 drivers/staging/zram/zram_sysfs.c | 109 ++++++++------------------------------
 2 files changed, 25 insertions(+), 104 deletions(-)

diff --git a/drivers/staging/zram/zram.txt b/drivers/staging/zram/zram.txt
index 765d790..b3111bc 100644
--- a/drivers/staging/zram/zram.txt
+++ b/drivers/staging/zram/zram.txt
@@ -12,7 +12,7 @@ good amounts of memory savings. Some of the usecases include /tmp storage,
 use as swap disks, various caches under /var and maybe many more :)
 
 Statistics for individual zram devices are exported through sysfs nodes at
-/sys/block/zram<id>/
+/sys/block/zram<id>/statistics
 
 * Usage
 
@@ -42,25 +42,11 @@ Following shows a typical sequence of steps for using zram.
 	mkfs.ext4 /dev/zram1
 	mount /dev/zram1 /tmp
 
-4) Stats:
-	Per-device statistics are exported as various nodes under
-	/sys/block/zram<id>/
-		disksize
-		num_reads
-		num_writes
-		invalid_io
-		notify_free
-		discard
-		zero_pages
-		orig_data_size
-		compr_data_size
-		mem_used_total
-
-5) Deactivate:
+4) Deactivate:
 	swapoff /dev/zram0
 	umount /dev/zram1
 
-6) Reset:
+5) Reset:
 	Write any positive value to 'reset' sysfs node
 	echo 1 > /sys/block/zram0/reset
 	echo 1 > /sys/block/zram1/reset
diff --git a/drivers/staging/zram/zram_sysfs.c b/drivers/staging/zram/zram_sysfs.c
index e6a929d..2aac370 100644
--- a/drivers/staging/zram/zram_sysfs.c
+++ b/drivers/staging/zram/zram_sysfs.c
@@ -119,106 +119,41 @@ static ssize_t reset_store(struct device *dev,
 	return len;
 }
 
-static ssize_t num_reads_show(struct device *dev,
-		struct device_attribute *attr, char *buf)
-{
-	struct zram *zram = dev_to_zram(dev);
-
-	return sprintf(buf, "%llu\n",
-		zram_stat64_read(zram, &zram->stats.num_reads));
-}
-
-static ssize_t num_writes_show(struct device *dev,
-		struct device_attribute *attr, char *buf)
-{
-	struct zram *zram = dev_to_zram(dev);
-
-	return sprintf(buf, "%llu\n",
-		zram_stat64_read(zram, &zram->stats.num_writes));
-}
-
-static ssize_t invalid_io_show(struct device *dev,
-		struct device_attribute *attr, char *buf)
-{
-	struct zram *zram = dev_to_zram(dev);
-
-	return sprintf(buf, "%llu\n",
-		zram_stat64_read(zram, &zram->stats.invalid_io));
-}
-
-static ssize_t notify_free_show(struct device *dev,
-		struct device_attribute *attr, char *buf)
-{
-	struct zram *zram = dev_to_zram(dev);
-
-	return sprintf(buf, "%llu\n",
-		zram_stat64_read(zram, &zram->stats.notify_free));
-}
-
-static ssize_t zero_pages_show(struct device *dev,
-		struct device_attribute *attr, char *buf)
-{
-	struct zram *zram = dev_to_zram(dev);
-
-	return sprintf(buf, "%u\n", zram->stats.pages_zero);
-}
-
-static ssize_t orig_data_size_show(struct device *dev,
-		struct device_attribute *attr, char *buf)
-{
-	struct zram *zram = dev_to_zram(dev);
-
-	return sprintf(buf, "%llu\n",
-		(u64)(zram->stats.pages_stored) << PAGE_SHIFT);
-}
-
-static ssize_t compr_data_size_show(struct device *dev,
-		struct device_attribute *attr, char *buf)
+static ssize_t statistics_show(struct device *dev,
+			       struct device_attribute *attr, char *buf)
 {
 	struct zram *zram = dev_to_zram(dev);
-
-	return sprintf(buf, "%llu\n",
-		zram_stat64_read(zram, &zram->stats.compr_size));
-}
-
-static ssize_t mem_used_total_show(struct device *dev,
-		struct device_attribute *attr, char *buf)
-{
-	u64 val = 0;
-	struct zram *zram = dev_to_zram(dev);
 	struct zram_meta *meta = zram->meta;
 
-	if (zram->init_done)
-		val = zs_get_total_size_bytes(meta->mem_pool);
-
-	return sprintf(buf, "%llu\n", val);
+	return sprintf(buf,
+		       "Number of reads:\t%llu\n"
+		       "Number of writes:\t%llu\n"
+		       "Invalid IO:\t\t%llu\n"
+		       "Notify free:\t\t%llu\n"
+		       "Zero pages:\t\t%u\n"
+		       "Orig data size:\t\t%llu bytes\n"
+		       "Compressed data:\t%llu bytes\n"
+		       "Total memory used:\t%llu bytes\n",
+		       zram_stat64_read(zram, &zram->stats.num_reads),
+		       zram_stat64_read(zram, &zram->stats.num_writes),
+		       zram_stat64_read(zram, &zram->stats.invalid_io),
+		       zram_stat64_read(zram, &zram->stats.notify_free),
+		       zram->stats.pages_zero,
+		       (u64)(zram->stats.pages_stored) << PAGE_SHIFT,
+		       zram_stat64_read(zram, &zram->stats.compr_size),
+		       zram->init_done ? zs_get_total_size_bytes(meta->mem_pool) : 0);
 }
 
-static DEVICE_ATTR(disksize, S_IRUGO | S_IWUSR,
-		disksize_show, disksize_store);
+static DEVICE_ATTR(disksize, S_IRUGO | S_IWUSR, disksize_show, disksize_store);
 static DEVICE_ATTR(initstate, S_IRUGO, initstate_show, NULL);
 static DEVICE_ATTR(reset, S_IWUSR, NULL, reset_store);
-static DEVICE_ATTR(num_reads, S_IRUGO, num_reads_show, NULL);
-static DEVICE_ATTR(num_writes, S_IRUGO, num_writes_show, NULL);
-static DEVICE_ATTR(invalid_io, S_IRUGO, invalid_io_show, NULL);
-static DEVICE_ATTR(notify_free, S_IRUGO, notify_free_show, NULL);
-static DEVICE_ATTR(zero_pages, S_IRUGO, zero_pages_show, NULL);
-static DEVICE_ATTR(orig_data_size, S_IRUGO, orig_data_size_show, NULL);
-static DEVICE_ATTR(compr_data_size, S_IRUGO, compr_data_size_show, NULL);
-static DEVICE_ATTR(mem_used_total, S_IRUGO, mem_used_total_show, NULL);
+static DEVICE_ATTR(statistics, S_IRUGO, statistics_show, NULL);
 
 static struct attribute *zram_disk_attrs[] = {
 	&dev_attr_disksize.attr,
 	&dev_attr_initstate.attr,
 	&dev_attr_reset.attr,
-	&dev_attr_num_reads.attr,
-	&dev_attr_num_writes.attr,
-	&dev_attr_invalid_io.attr,
-	&dev_attr_notify_free.attr,
-	&dev_attr_zero_pages.attr,
-	&dev_attr_orig_data_size.attr,
-	&dev_attr_compr_data_size.attr,
-	&dev_attr_mem_used_total.attr,
+	&dev_attr_statistics.attr,
 	NULL,
 };
 
-- 
1.7.11.7




