Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755370Ab3I1Vup (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Sep 2013 17:50:45 -0400
Received: from mail-qa0-f49.google.com ([209.85.216.49]:46162 "EHLO
	mail-qa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755191Ab3I1Vt7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Sep 2013 17:49:59 -0400
From: Tejun Heo <tj@kernel.org>
To: gregkh@linuxfoundation.org
Cc: kay@vrfy.org, linux-kernel@vger.kernel.org, ebiederm@xmission.com,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 09/14] sysfs: prepare llseek path for unified regular / bin file handling
Date: Sat, 28 Sep 2013 17:49:39 -0400
Message-Id: <1380404984-31858-10-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1380404984-31858-1-git-send-email-tj@kernel.org>
References: <1380404984-31858-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sysfs bin file handling will be merged into the regular file support.
This patch prepares the llseek path.

sysfs currently unconditionally uses seq_lseek() whether the file
supports read or not, which means that sysfs_seq_show() may be used
purely for seeking even if the file doesn't implement read.
sysfs_seq_show() simply doesn't produce any data if sysfs_ops->show()
is not available.  This is good enough for write-only files as open()
doesn't allow FMODE_READ if sysfs_ops->show() is not implemented and
seq_lseek() sets f_pos to the requested offset as long as show()
doesn't fail.

However, bin files allow FMODE_READ when ->mmap() is implemented even
if ->read() is not, which means that sysfs_seq_show() would need to
fail if ->read() is not implemented, which is fine for read(2) but
would break lseek(2).

This patch implements sysfs_llseek() which uses seq_lseek() iff read
is implemented.  If not, generic_file_llseek() is used instead.  This
removes the case where sysfs_seq_show() is used purely for seeking
thus solving the above issue.  Plus, it's weird to use seq_seek() when
seq_file isn't being used anyway.

Note that sysfs_llseek() handles both regular and bin files.  While
this isn't used yet, it'll allow unifying handling of both types.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 fs/sysfs/file.c | 44 +++++++++++++++++++++++++++++++++++---------
 1 file changed, 35 insertions(+), 9 deletions(-)

diff --git a/fs/sysfs/file.c b/fs/sysfs/file.c
index 6211dd7..d9109d3 100644
--- a/fs/sysfs/file.c
+++ b/fs/sysfs/file.c
@@ -54,6 +54,11 @@ struct sysfs_open_file {
 	struct list_head	list;
 };
 
+static bool sysfs_is_bin(struct sysfs_dirent *sd)
+{
+	return sysfs_type(sd) == SYSFS_KOBJ_BIN_ATTR;
+}
+
 static struct sysfs_open_file *sysfs_of(struct file *file)
 {
 	return ((struct seq_file *)file->private_data)->private;
@@ -72,6 +77,33 @@ static const struct sysfs_ops *sysfs_file_ops(struct sysfs_dirent *sd)
 }
 
 /*
+ * llseek for sysfs.  Use seq_lseek() if read operation is implemented;
+ * otherwise, fall back to generic_file_llseek().  This ensures that
+ * sysfs_seq_show() isn't invoked to seek in a file which doesn't
+ * implemented read.
+ */
+static loff_t sysfs_llseek(struct file *file, loff_t offset, int whence)
+{
+	struct sysfs_open_file *of = sysfs_of(file);
+	bool has_read;
+
+	if (!sysfs_get_active(of->sd))
+		return -ENODEV;
+
+	if (sysfs_is_bin(of->sd))
+		has_read = of->sd->s_bin_attr.bin_attr->read;
+	else
+		has_read = sysfs_file_ops(of->sd)->show;
+
+	sysfs_put_active(of->sd);
+
+	if (has_read)
+		return seq_lseek(file, offset, whence);
+	else
+		return generic_file_llseek(file, offset, whence);
+}
+
+/*
  * Reads on sysfs are handled through seq_file, which takes care of hairy
  * details like buffering and seeking.  The following function pipes
  * sysfs_ops->show() result through seq_file.
@@ -104,15 +136,9 @@ static int sysfs_seq_show(struct seq_file *sf, void *v)
 
 	of->event = atomic_read(&of->sd->s_attr.open->event);
 
-	/*
-	 * Lookup @ops and invoke show().  Control may reach here via seq
-	 * file lseek even if @ops->show() isn't implemented.
-	 */
+	/* lookup @ops and invoke show() */
 	ops = sysfs_file_ops(of->sd);
-	if (ops->show)
-		count = ops->show(kobj, of->sd->s_attr.attr, buf);
-	else
-		count = 0;
+	count = ops->show(kobj, of->sd->s_attr.attr, buf);
 
 	sysfs_put_active(of->sd);
 	mutex_unlock(&of->mutex);
@@ -465,7 +491,7 @@ EXPORT_SYMBOL_GPL(sysfs_notify);
 const struct file_operations sysfs_file_operations = {
 	.read		= seq_read,
 	.write		= sysfs_write_file,
-	.llseek		= seq_lseek,
+	.llseek		= sysfs_llseek,
 	.open		= sysfs_open_file,
 	.release	= sysfs_release,
 	.poll		= sysfs_poll,
-- 
1.8.3.1

