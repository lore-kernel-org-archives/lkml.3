Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754543Ab3CKTBw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 15:01:52 -0400
Received: from g5t0009.atlanta.hp.com ([15.192.0.46]:14387 "EHLO
	g5t0009.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754047Ab3CKTBu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 15:01:50 -0400
Subject: [RFC PATCH] block: Add new generic block device naming interface
To: linux-kernel@vger.kernel.org
From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Cc: axboe@kernel.dk, Chayan.Biswas@sandisk.com, lsorense@csclub.uwaterloo.ca,
        Sumant.Patro@sandisk.com, stephenmcameron@gmail.com
Date: Mon, 11 Mar 2013 14:00:30 -0500
Message-ID: <20130311190030.5753.92288.stgit@beardog.cce.hp.com>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen M. Cameron <scameron@beardog.cce.hp.com>

This is really the merest sketch of an idea, I'm not asking that
this patch be taken in its current form, just asking for feedback
on the idea, and if someone else better acquainted with the block
layer wants to take this idea and implement it in a better, proper
way, please, have at it.

Upon requesting advice from the grub developers about best practices
for naming device nodes for new block device drivers[*] to cause the
least amount of pain in grub, I was understandably greeted with the
advice to make it a SCSI driver or have a damn good reason why not.

See this thread:
https://lists.gnu.org/archive/html/grub-devel/2013-03/msg00049.html

Well, I did have what I think is a good reason, but this got me to
thinking that adding a new block device driver really shouldn't be causing
the grub guys any extra work, yet, it seems that it does.  This is because
there is no standardized naming system for block drivers as there is for
SCSI drivers -- the block device drivers kind of choose their own device
names, as does the sd driver -- but all the scsi hba drivers share the sd
driver -- so all the scsi block devices share the same device namespace,
and grub only has to know about this shared namespace.

So I cooked up a similar system for the block drivers, copied from sd
pretty much.  The idea is that instead of each new block driver manually
setting gendisk's disk_name field (though legacy drivers could still do
that) they call blk_assign_new_disk_name(struct gendisk *disk), and the
block layer hands out a name, so that all the new block drivers share
a namespace, and grub only has to learn about this one new naming
scheme, and any new block drivers can leverage that for booting support
automatically.

The scheme implemented in this patch is to name the devices /dev/bda,
/dev/bdb, /dev/bdc, etc.  in the exact same manner as the sd driver names
its devices /dev/sda, etc. (I literally copied the code from the sd
driver and tweaked it ever so slightly.)  This of course may not be the
best solution (as that ancient scheme came from what, SunOS?) but it
was the quickest to get up and running for a proof of concept.

It does occur to me that this seems like such an obvious idea that perhaps
there is a good reason why it's not done already, but if so, I don't know
what that reason is.

[*] the new driver I have in mind which triggered this question is here:
    https://github.com/HPSmartStorage/scsi-over-pcie

-- steve
---
 block/genhd.c         |   86 +++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/genhd.h |    1 +
 2 files changed, 87 insertions(+), 0 deletions(-)

diff --git a/block/genhd.c b/block/genhd.c
index 3c001fb..9d735f6 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -569,6 +569,92 @@ exit:
 }
 
 /**
+ *	bd_format_disk_name - format disk name
+ *	@prefix: name prefix - ie. "bd" for SCSI disks
+ *	@index: index of the disk to format name for
+ *	@buf: output buffer
+ *	@buflen: length of the output buffer
+ *
+ *	block disk names starts at bda.  The 26th device is bdz and the
+ *	27th is bdaa.  The last one for two lettered suffix is bdzz
+ *	which is followed by bdaaa.
+ *
+ *	This is basically 26 base counting with one extra 'nil' entry
+ *	at the beginning from the second digit on and can be
+ *	determined using similar method as 26 base conversion with the
+ *	index shifted -1 after each digit is computed.
+ *
+ *	CONTEXT:
+ *	Don't care.
+ *
+ *	RETURNS:
+ *	0 on success, -errno on failure.
+ *
+ *	bd_format_disk_name is obviously cribbed from sd_format_disk_name
+ *
+ */
+static int bd_format_disk_name(char *prefix, int index, char *buf, int buflen)
+{
+	const int base = 'z' - 'a' + 1;
+	char *begin = buf + strlen(prefix);
+	char *end = buf + buflen;
+	char *p;
+	int unit;
+
+	p = end - 1;
+	*p = '\0';
+	unit = base;
+	do {
+		if (p == begin)
+			return -EINVAL;
+		*--p = 'a' + (index % unit);
+		index = (index / unit) - 1;
+	} while (index >= 0);
+
+	memmove(begin, p, end - p);
+	memcpy(buf, prefix, strlen(prefix));
+
+	return 0;
+}
+
+DEFINE_SPINLOCK(bd_index_lock);
+DEFINE_IDA(bd_index_ida);
+char *blk_assign_new_disk_name(struct gendisk *disk)
+{
+	int index, error;
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
+		pr_warn("blk_assign_new_disk_name: memory exhausted\n");
+		goto out;
+	}
+
+	error = bd_format_disk_name("bd", index, disk->disk_name,
+					DISK_NAME_LEN);
+	if (error) {
+		pr_warn("block disk (bd) name length exceeded.\n");
+		goto out_free_index;
+	}
+	return disk->disk_name;
+
+out_free_index:
+	spin_lock(&bd_index_lock);
+	ida_remove(&bd_index_ida, index);
+	spin_unlock(&bd_index_lock);
+out:
+	return NULL;
+}
+EXPORT_SYMBOL(blk_assign_new_disk_name);
+
+/**
  * add_disk - add partitioning information to kernel list
  * @disk: per-device partitioning information
  *
diff --git a/include/linux/genhd.h b/include/linux/genhd.h
index 9f3c275..cef2169 100644
--- a/include/linux/genhd.h
+++ b/include/linux/genhd.h
@@ -602,6 +602,7 @@ extern int blk_alloc_devt(struct hd_struct *part, dev_t *devt);
 extern void blk_free_devt(dev_t devt);
 extern dev_t blk_lookup_devt(const char *name, int partno);
 extern char *disk_name (struct gendisk *hd, int partno, char *buf);
+extern char *blk_assign_new_disk_name(struct gendisk *hd);
 
 extern int disk_expand_part_tbl(struct gendisk *disk, int target);
 extern int rescan_partitions(struct gendisk *disk, struct block_device *bdev);

