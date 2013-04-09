Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759848Ab3DINJK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 09:09:10 -0400
Received: from smtp1-g21.free.fr ([212.27.42.1]:57914 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759169Ab3DINJI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 09:09:08 -0400
From: Gabriel <g2p.code+bcache@gmail.com>
To: Kent Overstreet <koverstreet@google.com>, linux-bcache@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Gabriel <g2p.code+bcache@gmail.com>
Subject: [PATCH] bcache: Reload device size
Date: Tue,  9 Apr 2013 15:07:33 +0200
Message-Id: <1365512853-32135-1-git-send-email-g2p.code+bcache@gmail.com>
X-Mailer: git-send-email 1.8.2.rc3.7.g35aca0e
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adds /sys/block/bcache*/bcache/resize; writing "max"
to such a file will reload the device size to match
the size of the underlying device, minus the bcache
superblock.

This is useful to grow a filesystem stacked on top
of bcache and a logical volume.

Other values than max are reserved for now; support
for shrinking might be added if the need comes up.

Signed-off-by: Gabriel de Perthuis <g2p.code+bcache@gmail.com>
---
 Documentation/bcache.txt   |  4 ++++
 drivers/md/bcache/bcache.h |  1 +
 drivers/md/bcache/super.c  | 13 ++++++++-----
 drivers/md/bcache/sysfs.c  | 11 +++++++++++
 4 files changed, 24 insertions(+), 5 deletions(-)

diff --git a/Documentation/bcache.txt b/Documentation/bcache.txt
index 77db880..3d72856 100644
--- a/Documentation/bcache.txt
+++ b/Documentation/bcache.txt
@@ -217,6 +217,10 @@ readahead
   1M, it will round cache miss reads up to that size, but without overlapping
   existing cache entries.
 
+resize
+  Write "max" to this file after resizing the underlying device.
+  bcache will update its device size to match.
+
 running
   1 if bcache is running (i.e. whether the /dev/bcache device exists, whether
   it's in passthrough mode or caching).
diff --git a/drivers/md/bcache/bcache.h b/drivers/md/bcache/bcache.h
index 8a110e6..65bf44f 100644
--- a/drivers/md/bcache/bcache.h
+++ b/drivers/md/bcache/bcache.h
@@ -1219,6 +1219,7 @@ int bch_flash_dev_create(struct cache_set *c, uint64_t size);
 int bch_cached_dev_attach(struct cached_dev *, struct cache_set *);
 void bch_cached_dev_detach(struct cached_dev *);
 void bch_cached_dev_run(struct cached_dev *);
+void bch_cached_dev_resize(struct cached_dev *);
 void bcache_device_stop(struct bcache_device *);
 
 void bch_cache_set_unregister(struct cache_set *);
diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index a409bb5..c9f0e4c 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -766,6 +766,13 @@ static void calc_cached_dev_sectors(struct cache_set *c)
 	c->cached_dev_sectors = sectors;
 }
 
+void bch_cached_dev_resize(struct cached_dev *dc)
+{
+	set_capacity(
+		dc->disk.disk,
+		dc->bdev->bd_part->nr_sects - dc->data_start_sector);
+}
+
 void bch_cached_dev_run(struct cached_dev *dc)
 {
 	struct bcache_device *d = &dc->disk;
@@ -1036,7 +1043,6 @@ static const char *register_bdev(struct cache_sb *sb, struct page *sb_page,
 {
 	char name[BDEVNAME_SIZE];
 	const char *err = "cannot allocate memory";
-	struct gendisk *g;
 	struct cache_set *c;
 
 	if (!dc || cached_dev_init(dc, sb->block_size << 9) != 0)
@@ -1058,10 +1064,7 @@ static const char *register_bdev(struct cache_sb *sb, struct page *sb_page,
 			goto err;
 	}
 
-	g = dc->disk.disk;
-
-	set_capacity(g, dc->bdev->bd_part->nr_sects - dc->data_start_sector);
-
+	bch_cached_dev_resize(dc);
 	bch_cached_dev_request_init(dc);
 
 	err = "error creating kobject";
diff --git a/drivers/md/bcache/sysfs.c b/drivers/md/bcache/sysfs.c
index 4d9cca4..663b96d 100644
--- a/drivers/md/bcache/sysfs.c
+++ b/drivers/md/bcache/sysfs.c
@@ -27,6 +27,7 @@ write_attribute(clear_stats);
 write_attribute(trigger_gc);
 write_attribute(prune_cache);
 write_attribute(flash_vol_create);
+write_attribute(resize);
 
 read_attribute(bucket_size);
 read_attribute(block_size);
@@ -201,6 +202,15 @@ STORE(__cached_dev)
 	    strtoul_or_return(buf))
 		bch_cached_dev_run(dc);
 
+	if (attr == &sysfs_resize) {
+		if (!strcmp(buf, "max") || !strcmp(buf, "max\n"))
+			bch_cached_dev_resize(dc);
+		else
+			/* Reserved for future use, if someone needs sizes below the max.
+			 * memparse units would be consistent with fs resizing tools. */
+			return -EINVAL;
+	}
+
 	if (attr == &sysfs_cache_mode) {
 		ssize_t v = bch_read_string_list(buf, bch_cache_modes + 1);
 
@@ -288,6 +298,7 @@ static struct attribute *bch_cached_dev_files[] = {
 	&sysfs_sequential_merge,
 	&sysfs_clear_stats,
 	&sysfs_running,
+	&sysfs_resize,
 	&sysfs_state,
 	&sysfs_label,
 	&sysfs_readahead,
-- 
1.8.2.rc3.7.g35aca0e

