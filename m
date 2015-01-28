Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761338AbbA1CW4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 21:22:56 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:41020 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755546AbbA1B2H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 20:28:07 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Joe Thornber <ejt@redhat.com>, Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 3.10 09/32] dm cache: share cache-metadata object across inactive and active DM tables
Date: Tue, 27 Jan 2015 17:26:39 -0800
Message-Id: <20150128012628.423051691@linuxfoundation.org>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <20150128012627.081285723@linuxfoundation.org>
References: <20150128012627.081285723@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joe Thornber <ejt@redhat.com>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/md/dm-cache-metadata.c |  101 ++++++++++++++++++++++++++++++++++++++---
 1 file changed, 95 insertions(+), 6 deletions(-)

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
@@ -634,10 +637,10 @@ static void unpack_value(__le64 value_le
 
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
@@ -648,6 +651,7 @@ struct dm_cache_metadata *dm_cache_metad
 		return NULL;
 	}
 
+	atomic_set(&cmd->ref_count, 1);
 	init_rwsem(&cmd->root_lock);
 	cmd->bdev = bdev;
 	cmd->data_block_size = data_block_size;
@@ -670,10 +674,95 @@ struct dm_cache_metadata *dm_cache_metad
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


