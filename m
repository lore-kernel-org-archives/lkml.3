Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757272Ab3C1QTr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 12:19:47 -0400
Received: from g4t0017.houston.hp.com ([15.201.24.20]:24320 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757225Ab3C1QTo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 12:19:44 -0400
Subject: [RFC PATCH] block: Add new generic block device naming interface
To: axboe@kernel.dk
From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Cc: Sumant.Patro@sandisk.com, chayan.biswas@sandisk.com,
        lsorense@csclub.uwaterloo.ca, linux-kernel@vger.kernel.org,
        stephenmcameron@gmail.com
Date: Thu, 28 Mar 2013 11:18:25 -0500
Message-ID: <20130328161825.29083.27606.stgit@beardog.cce.hp.com>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen M. Cameron <scameron@beardog.cce.hp.com>

Currently, when adding a new block device driver, if grub support is needed,
then grub needs to be modified to know about this new driver.

See this thread:
https://lists.gnu.org/archive/html/grub-devel/2013-03/msg00049.html

If block drivers could (optionally) share a common device namespace then
grub could be taught about this common namespace once, and any new block
device drivers could take advantage of this namespace and grub would
automatically work with them.

The idea is that instead of each new block driver manually setting the
gendisk's disk_name field (though legacy drivers could still do that) they
would call blk_get_new_disk_name(struct gendisk *disk), and the block layer
hands out a name.  When removing a device, blk_put_disk_name() releases the
device name.

The scheme implemented in this patch is to name the devices /dev/bdn, with n
being an integer starting at zero that counts up, so you'd get device names
like /dev/bd0, /dev/bd1, /dev/bd2, etc.

Maybe there is a good reason why such an obvious idea is not already
implemented, but if so, I don't know what that reason is.

-- steve
---
 block/genhd.c         |   52 +++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/genhd.h |    2 ++
 2 files changed, 54 insertions(+), 0 deletions(-)

diff --git a/block/genhd.c b/block/genhd.c
index 3c001fb..d4f1588 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -568,6 +568,58 @@ exit:
 	disk_part_iter_exit(&piter);
 }
 
+static DEFINE_SPINLOCK(bd_index_lock);
+static DEFINE_IDA(bd_index_ida);
+char *blk_get_disk_name(struct gendisk *disk)
+{
+	int index, error;
+	char name[DISK_NAME_LEN + 1];
+
+	do {
+		if (!ida_pre_get(&bd_index_ida, GFP_KERNEL))
+			goto out;
+
+		spin_lock(&bd_index_lock);
+		error = ida_get_new(&bd_index_ida, &index);
+		spin_unlock(&bd_index_lock);
+	} while (error == -EAGAIN);
+
+	if (error) {
+		pr_warn("blk_get_disk_name: memory exhausted\n");
+		goto out;
+	}
+
+	snprintf(name, DISK_NAME_LEN, "bd%d", index);
+	if (strlen(name) > DISK_NAME_LEN - 1) {
+		pr_warn("block disk (bd) name length exceeded.\n");
+		goto out_free_index;
+	}
+	strncpy(disk->disk_name, name, DISK_NAME_LEN - 1);
+	return disk->disk_name;
+
+out_free_index:
+	spin_lock(&bd_index_lock);
+	ida_remove(&bd_index_ida, index);
+	spin_unlock(&bd_index_lock);
+out:
+	return NULL;
+}
+EXPORT_SYMBOL(blk_get_disk_name);
+
+int blk_put_disk_name(char *name)
+{
+	int index;
+
+	if (sscanf(name, "bd%d", &index) != 1)
+		return -EINVAL;
+
+	spin_lock(&bd_index_lock);
+	ida_remove(&bd_index_ida, index);
+	spin_unlock(&bd_index_lock);
+	return 0;
+}
+EXPORT_SYMBOL(blk_put_disk_name);
+
 /**
  * add_disk - add partitioning information to kernel list
  * @disk: per-device partitioning information
diff --git a/include/linux/genhd.h b/include/linux/genhd.h
index 9f3c275..fddb41d 100644
--- a/include/linux/genhd.h
+++ b/include/linux/genhd.h
@@ -602,6 +602,8 @@ extern int blk_alloc_devt(struct hd_struct *part, dev_t *devt);
 extern void blk_free_devt(dev_t devt);
 extern dev_t blk_lookup_devt(const char *name, int partno);
 extern char *disk_name (struct gendisk *hd, int partno, char *buf);
+extern char *blk_get_disk_name(struct gendisk *disk);
+extern int blk_put_disk_name(char *name);
 
 extern int disk_expand_part_tbl(struct gendisk *disk, int target);
 extern int rescan_partitions(struct gendisk *disk, struct block_device *bdev);

