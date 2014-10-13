Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752937AbaJMFmv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2014 01:42:51 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43335 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751450AbaJMFmp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2014 01:42:45 -0400
From: NeilBrown <neilb@suse.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Date: Mon, 13 Oct 2014 16:41:28 +1100
Subject: [PATCH 2/2] sysfs/kernfs: make read requests on pre-alloc files use
 the buffer.
Cc: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org,
        Al Viro <viro@ZenIV.linux.org.uk>
Message-ID: <20141013054128.19481.21008.stgit@notabene.brown>
In-Reply-To: <20141013053733.19481.43981.stgit@notabene.brown>
References: <20141013053733.19481.43981.stgit@notabene.brown>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To match the previous patch which used the pre-alloc buffer for
writes, this patch causes reads to use the same buffer.
This is not strictly necessary as the current seq_read() will allocate
on first read, so user-space can trigger the required pre-alloc.  But
consistency is valuable.

The read function is somewhat simpler than seq_read() and, for example,
does not support reading from an offset into the file: reads must be
at the start of the file.

As seq_read() does not use the prealloc buffer, ->seq_show is
incompatible with ->prealloc and caused an EINVAL return from open().
sysfs code which calls into kernfs always chooses the correct function.

As the buffer is shared with writes and other reads, the mutex is
extended to cover the copy_to_user.

Signed-off-by: NeilBrown <neilb@suse.de>
Reviewed-by: Tejun Heo <tj@kernel.org>
---
 fs/kernfs/file.c |   30 +++++++++++++++++++++---------
 fs/sysfs/file.c  |   32 ++++++++++++++++++++++++++++----
 2 files changed, 49 insertions(+), 13 deletions(-)

diff --git a/fs/kernfs/file.c b/fs/kernfs/file.c
index 70186e2e692a..697390ea47b8 100644
--- a/fs/kernfs/file.c
+++ b/fs/kernfs/file.c
@@ -189,13 +189,16 @@ static ssize_t kernfs_file_direct_read(struct kernfs_open_file *of,
 	const struct kernfs_ops *ops;
 	char *buf;
 
-	buf = kmalloc(len, GFP_KERNEL);
+	buf = of->prealloc_buf;
+	if (!buf)
+		buf = kmalloc(len, GFP_KERNEL);
 	if (!buf)
 		return -ENOMEM;
 
 	/*
-	 * @of->mutex nests outside active ref and is primarily to ensure that
-	 * the ops aren't called concurrently for the same open file.
+	 * @of->mutex nests outside active ref and is used both to ensure that
+	 * the ops aren't called concurrently for the same open file, and
+	 * to provide exclusive access to ->prealloc_buf (when that exists).
 	 */
 	mutex_lock(&of->mutex);
 	if (!kernfs_get_active(of->kn)) {
@@ -210,21 +213,22 @@ static ssize_t kernfs_file_direct_read(struct kernfs_open_file *of,
 	else
 		len = -EINVAL;
 
-	kernfs_put_active(of->kn);
-	mutex_unlock(&of->mutex);
-
 	if (len < 0)
-		goto out_free;
+		goto out_unlock;
 
 	if (copy_to_user(user_buf, buf, len)) {
 		len = -EFAULT;
-		goto out_free;
+		goto out_unlock;
 	}
 
 	*ppos += len;
 
+ out_unlock:
+	kernfs_put_active(of->kn);
+	mutex_unlock(&of->mutex);
  out_free:
-	kfree(buf);
+	if (buf != of->prealloc_buf)
+		kfree(buf);
 	return len;
 }
 
@@ -690,6 +694,14 @@ static int kernfs_fop_open(struct inode *inode, struct file *file)
 	 */
 	of->atomic_write_len = ops->atomic_write_len;
 
+	error = -EINVAL;
+	/*
+	 * ->seq_show is incompatible with ->prealloc,
+	 * as seq_read does its own allocation.
+	 * ->read must be used instead.
+	 */
+	if (ops->prealloc && ops->seq_show)
+		goto err_free;
 	if (ops->prealloc) {
 		int len = of->atomic_write_len ?: PAGE_SIZE;
 		of->prealloc_buf = kmalloc(len + 1, GFP_KERNEL);
diff --git a/fs/sysfs/file.c b/fs/sysfs/file.c
index 4a959d231b43..9ff511a4e2da 100644
--- a/fs/sysfs/file.c
+++ b/fs/sysfs/file.c
@@ -102,6 +102,22 @@ static ssize_t sysfs_kf_bin_read(struct kernfs_open_file *of, char *buf,
 	return battr->read(of->file, kobj, battr, buf, pos, count);
 }
 
+/* kernfs read callback for regular sysfs files with pre-alloc */
+static ssize_t sysfs_kf_read(struct kernfs_open_file *of, char *buf,
+			     size_t count, loff_t pos)
+{
+	const struct sysfs_ops *ops = sysfs_file_ops(of->kn);
+	struct kobject *kobj = of->kn->parent->priv;
+
+	/*
+	 * If buf != of->prealloc_buf, we don't know how
+	 * large it is, so cannot safely pass it to ->show
+	 */
+	if (pos || WARN_ON_ONCE(buf != of->prealloc_buf)) {
+		return 0;
+	return ops->show(kobj, of->kn->priv, buf);
+}
+
 /* kernfs write callback for regular sysfs files */
 static ssize_t sysfs_kf_write(struct kernfs_open_file *of, char *buf,
 			      size_t count, loff_t pos)
@@ -184,13 +200,18 @@ static const struct kernfs_ops sysfs_file_kfops_rw = {
 	.write		= sysfs_kf_write,
 };
 
+static const struct kernfs_ops sysfs_prealloc_kfops_ro = {
+	.read		= sysfs_kf_read,
+	.prealloc	= true,
+};
+
 static const struct kernfs_ops sysfs_prealloc_kfops_wo = {
 	.write		= sysfs_kf_write,
 	.prealloc	= true,
 };
 
 static const struct kernfs_ops sysfs_prealloc_kfops_rw = {
-	.seq_show	= sysfs_kf_seq_show,
+	.read		= sysfs_kf_read,
 	.write		= sysfs_kf_write,
 	.prealloc	= true,
 };
@@ -238,9 +259,12 @@ int sysfs_add_file_mode_ns(struct kernfs_node *parent,
 				ops = &sysfs_prealloc_kfops_rw;
 			else
 				ops = &sysfs_file_kfops_rw;
-		} else if (sysfs_ops->show)
-			ops = &sysfs_file_kfops_ro;
-		else if (sysfs_ops->store) {
+		} else if (sysfs_ops->show) {
+			if (mode & SYSFS_PREALLOC)
+				ops = &sysfs_prealloc_kfops_ro;
+			else
+				ops = &sysfs_file_kfops_ro;
+		} else if (sysfs_ops->store) {
 			if (mode & SYSFS_PREALLOC)
 				ops = &sysfs_prealloc_kfops_wo;
 			else


