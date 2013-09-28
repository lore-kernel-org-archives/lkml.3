Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755352Ab3I1Vum (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Sep 2013 17:50:42 -0400
Received: from mail-qe0-f48.google.com ([209.85.128.48]:34684 "EHLO
	mail-qe0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755197Ab3I1VuA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Sep 2013 17:50:00 -0400
From: Tejun Heo <tj@kernel.org>
To: gregkh@linuxfoundation.org
Cc: kay@vrfy.org, linux-kernel@vger.kernel.org, ebiederm@xmission.com,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 10/14] sysfs: prepare path write for unified regular / bin file handling
Date: Sat, 28 Sep 2013 17:49:40 -0400
Message-Id: <1380404984-31858-11-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1380404984-31858-1-git-send-email-tj@kernel.org>
References: <1380404984-31858-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sysfs bin file handling will be merged into the regular file support.
This patch prepares the write path.

bin file write is almost identical to regular file write except that
the write length is capped by the inode size and @off is passed to the
write method.  This patch adds bin file handling to sysfs_write_file()
so that it can handle both regular and bin files.

This is a preparation and the new bin file path isn't used yet.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 fs/sysfs/file.c | 30 ++++++++++++++++++++++++------
 1 file changed, 24 insertions(+), 6 deletions(-)

diff --git a/fs/sysfs/file.c b/fs/sysfs/file.c
index d9109d3..5380009 100644
--- a/fs/sysfs/file.c
+++ b/fs/sysfs/file.c
@@ -164,16 +164,16 @@ static int sysfs_seq_show(struct seq_file *sf, void *v)
  * flush_write_buffer - push buffer to kobject
  * @of: open file
  * @buf: data buffer for file
+ * @off: file offset to write to
  * @count: number of bytes
  *
  * Get the correct pointers for the kobject and the attribute we're dealing
  * with, then call the store() method for it with @buf.
  */
-static int flush_write_buffer(struct sysfs_open_file *of, char *buf,
+static int flush_write_buffer(struct sysfs_open_file *of, char *buf, loff_t off,
 			      size_t count)
 {
 	struct kobject *kobj = of->sd->s_parent->s_dir.kobj;
-	const struct sysfs_ops *ops;
 	int rc = 0;
 
 	/*
@@ -187,8 +187,18 @@ static int flush_write_buffer(struct sysfs_open_file *of, char *buf,
 		return -ENODEV;
 	}
 
-	ops = sysfs_file_ops(of->sd);
-	rc = ops->store(kobj, of->sd->s_attr.attr, buf, count);
+	if (sysfs_is_bin(of->sd)) {
+		struct bin_attribute *battr = of->sd->s_bin_attr.bin_attr;
+
+		rc = -EIO;
+		if (battr->write)
+			rc = battr->write(of->file, kobj, battr, buf, off,
+					  count);
+	} else {
+		const struct sysfs_ops *ops = sysfs_file_ops(of->sd);
+
+		rc = ops->store(kobj, of->sd->s_attr.attr, buf, count);
+	}
 
 	sysfs_put_active(of->sd);
 	mutex_unlock(&of->mutex);
@@ -216,9 +226,17 @@ static ssize_t sysfs_write_file(struct file *file, const char __user *user_buf,
 				size_t count, loff_t *ppos)
 {
 	struct sysfs_open_file *of = sysfs_of(file);
-	ssize_t len = min(count, PAGE_SIZE - 1);
+	ssize_t len = min(count, PAGE_SIZE);
 	char *buf;
 
+	if (sysfs_is_bin(of->sd)) {
+		loff_t size = file_inode(file)->i_size;
+
+		if (size <= *ppos)
+			return 0;
+		len = min_t(ssize_t, len, size - *ppos);
+	}
+
 	if (!len)
 		return 0;
 
@@ -232,7 +250,7 @@ static ssize_t sysfs_write_file(struct file *file, const char __user *user_buf,
 	}
 	buf[len] = '\0';	/* guarantee string termination */
 
-	len = flush_write_buffer(of, buf, len);
+	len = flush_write_buffer(of, buf, *ppos, len);
 	if (len > 0)
 		*ppos += len;
 out_free:
-- 
1.8.3.1

