Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762034AbbA2K2h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 05:28:37 -0500
Received: from ip4-83-240-67-251.cust.nbox.cz ([83.240.67.251]:44737 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755767AbbA2JAg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 04:00:36 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Joe Thornber <ejt@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 148/176] dm cache: share cache-metadata object across inactive and active DM tables
Date: Wed, 28 Jan 2015 15:29:38 +0100
Message-Id: <806a7659a58ba3c8d22af1e1a72e9ff1a53fd27c.1422455352.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <ce4a451f616a1e7ab58cfeceea5e49c8b1c68c81.1422455352.git.jslaby@suse.cz>
References: <ce4a451f616a1e7ab58cfeceea5e49c8b1c68c81.1422455352.git.jslaby@suse.cz>
In-Reply-To: <cover.1422455352.git.jslaby@suse.cz>
References: <cover.1422455352.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joe Thornber <ejt@redhat.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 9b1cc9f251affdd27f29fe46d0989ba76c33faf6 upstream.

If a DM table is reloaded with an inactive table when the device is not
suspended (normal procedure for LVM2), then there will be two dm-bufio
objects that can diverge.  This can lead to a situation where the
inactive table uses bufio to read metadata at the same time the active
table writes metadata -- resulting in the inactive table having stale
metadata buffers once it is promoted to the active table slot.

Fix this by using reference counting and a global list of cache metadata
objects to ensure there is only one metadata object per metadata device.

Signed-off-by: Joe Thornber <ejt@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/md/dm-cache-metadata.c | 101 ++++++++++++++++++++++++++++++++++++++---
 1 file changed, 95 insertions(+), 6 deletions(-)

diff --git a/drivers/md/dm-cache-metadata.c b/drivers/md/dm-cache-metadata.c
index b564c0610259..0bfd9c0611a0 100644
--- a/drivers/md/dm-cache-metadata.c
+++ b/drivers/md/dm-cache-metadata.c
@@ -88,6 +88,9 @@ struct cache_disk_superblock {
 } __packed;
 
 struct dm_cache_metadata {
+	atomic_t ref_count;
+	struct list_head list;
+
 	struct block_device *bdev;
 	struct dm_block_manager *bm;
 	struct dm_space_map *metadata_sm;
@@ -650,10 +653,10 @@ static void unpack_value(__le64 value_le, dm_oblock_t *block, unsigned *flags)
 
 /*----------------------------------------------------------------*/
 
-struct dm_cache_metadata *dm_cache_metadata_open(struct block_device *bdev,
-						 sector_t data_block_size,
-						 bool may_format_device,
-						 size_t policy_hint_size)
+static struct dm_cache_metadata *metadata_open(struct block_device *bdev,
+					       sector_t data_block_size,
+					       bool may_format_device,
+					       size_t policy_hint_size)
 {
 	int r;
 	struct dm_cache_metadata *cmd;
@@ -664,6 +667,7 @@ struct dm_cache_metadata *dm_cache_metadata_open(struct block_device *bdev,
 		return NULL;
 	}
 
+	atomic_set(&cmd->ref_count, 1);
 	init_rwsem(&cmd->root_lock);
 	cmd->bdev = bdev;
 	cmd->data_block_size = data_block_size;
@@ -686,10 +690,95 @@ struct dm_cache_metadata *dm_cache_metadata_open(struct block_device *bdev,
 	return cmd;
 }
 
+/*
+ * We keep a little list of ref counted metadata objects to prevent two
+ * different target instances creating separate bufio instances.  This is
+ * an issue if a table is reloaded before the suspend.
+ */
+static DEFINE_MUTEX(table_lock);
+static LIST_HEAD(table);
+
+static struct dm_cache_metadata *lookup(struct block_device *bdev)
+{
+	struct dm_cache_metadata *cmd;
+
+	list_for_each_entry(cmd, &table, list)
+		if (cmd->bdev == bdev) {
+			atomic_inc(&cmd->ref_count);
+			return cmd;
+		}
+
+	return NULL;
+}
+
+static struct dm_cache_metadata *lookup_or_open(struct block_device *bdev,
+						sector_t data_block_size,
+						bool may_format_device,
+						size_t policy_hint_size)
+{
+	struct dm_cache_metadata *cmd, *cmd2;
+
+	mutex_lock(&table_lock);
+	cmd = lookup(bdev);
+	mutex_unlock(&table_lock);
+
+	if (cmd)
+		return cmd;
+
+	cmd = metadata_open(bdev, data_block_size, may_format_device, policy_hint_size);
+	if (cmd) {
+		mutex_lock(&table_lock);
+		cmd2 = lookup(bdev);
+		if (cmd2) {
+			mutex_unlock(&table_lock);
+			__destroy_persistent_data_objects(cmd);
+			kfree(cmd);
+			return cmd2;
+		}
+		list_add(&cmd->list, &table);
+		mutex_unlock(&table_lock);
+	}
+
+	return cmd;
+}
+
+static bool same_params(struct dm_cache_metadata *cmd, sector_t data_block_size)
+{
+	if (cmd->data_block_size != data_block_size) {
+		DMERR("data_block_size (%llu) different from that in metadata (%llu)\n",
+		      (unsigned long long) data_block_size,
+		      (unsigned long long) cmd->data_block_size);
+		return false;
+	}
+
+	return true;
+}
+
+struct dm_cache_metadata *dm_cache_metadata_open(struct block_device *bdev,
+						 sector_t data_block_size,
+						 bool may_format_device,
+						 size_t policy_hint_size)
+{
+	struct dm_cache_metadata *cmd = lookup_or_open(bdev, data_block_size,
+						       may_format_device, policy_hint_size);
+	if (cmd && !same_params(cmd, data_block_size)) {
+		dm_cache_metadata_close(cmd);
+		return NULL;
+	}
+
+	return cmd;
+}
+
 void dm_cache_metadata_close(struct dm_cache_metadata *cmd)
 {
-	__destroy_persistent_data_objects(cmd);
-	kfree(cmd);
+	if (atomic_dec_and_test(&cmd->ref_count)) {
+		mutex_lock(&table_lock);
+		list_del(&cmd->list);
+		mutex_unlock(&table_lock);
+
+		__destroy_persistent_data_objects(cmd);
+		kfree(cmd);
+	}
 }
 
 int dm_cache_resize(struct dm_cache_metadata *cmd, dm_cblock_t new_cache_size)
-- 
2.2.2

