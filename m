Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932121Ab3KVRso (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 12:48:44 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:40988 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755983Ab3KVRsk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 12:48:40 -0500
Message-ID: <528F98F3.1020909@oracle.com>
Date: Fri, 22 Nov 2013 11:48:35 -0600
From: Dave Kleikamp <dave.kleikamp@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Al Viro <viro@ZenIV.linux.org.uk>
CC: linux-kernel@vger.kernel.org,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Subject: [PATCH] fs: create file_has_read_ops and file_has_write_ops helpers
References: <20131111125328.ef8f0641ccdbb28a0d0564da@canb.auug.org.au> <20131111032052.GV13318@ZenIV.linux.org.uk>
In-Reply-To: <20131111032052.GV13318@ZenIV.linux.org.uk>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/10/2013 09:20 PM, Al Viro wrote:
> On Mon, Nov 11, 2013 at 12:53:28PM +1100, Stephen Rothwell wrote:
>> Hi Dave,
>>
>> Today's linux-next merge of the aio-direct tree got a conflict in
>> drivers/mtd/nand/nandsim.c between commit 72c2d5319200 ("file->f_op is
>> never NULL...") from the vfs tree and commit dd458300240b ("fs: create
>> file_readable() and file_writable() functions") from the aio-direct tree.
>>
>> I fixed it up (I just used the aio-direct tree version) and can carry the
>> fix as necessary (no action is required).
> 
> Hrm...  Pity that this thing sits in the middle of aio-direct; it would
> make more sense to take it in vfs.git ;-/  There are several more places
> where we get the conflicts of the same sort.

Well, Linus rejected my patchset as it is, so I'm going to have to
rework it. I'd appreciate if you could pick up this patch in vfs.git
targeting the next merge window.

> FWIW, I have two nitpicks with these helpers:
> 	a) checks for NULL argument do not belong there
> 	b) please, please, do not breed more instances of that stupid
> 'filp' thing; AFAICS, it's an example of really bad taste on part of
> AST - it stands for 'file pointer' and yes, it's a minixism.  Linus has
> used that naming convention in 0.01 and it spread when people copied
> stuff.  There's a perfectly good identifier - 'file'...

I've fixed both of these. In addition, on hindsight I didn't like
the names file_readable and file_writable. It wasn't clear what
they actually tested. I have renamed them file_has_read_ops and
file_has_write_ops.

Thanks,
Dave

Create functions to simplify testing if file_ops contain either a
read or aio_read op, or likewise write or aio_write. I anticipate
adding alternate read and write functions in the near future and
would like to avoid adding another clause to the test in multiple
places.

Signed-off-by: Dave Kleikamp <dave.kleikamp@oracle.com>
---
 drivers/mtd/nand/nandsim.c          |  4 ++--
 drivers/usb/gadget/storage_common.c |  4 ++--
 fs/read_write.c                     | 14 +++++++-------
 include/linux/fs.h                  | 10 ++++++++++
 4 files changed, 21 insertions(+), 11 deletions(-)

diff --git a/drivers/mtd/nand/nandsim.c b/drivers/mtd/nand/nandsim.c
index 42e8a77..3fca8b3 100644
--- a/drivers/mtd/nand/nandsim.c
+++ b/drivers/mtd/nand/nandsim.c
@@ -575,12 +575,12 @@ static int alloc_device(struct nandsim *ns)
 		cfile = filp_open(cache_file, O_CREAT | O_RDWR | O_LARGEFILE, 0600);
 		if (IS_ERR(cfile))
 			return PTR_ERR(cfile);
-		if (!cfile->f_op->read && !cfile->f_op->aio_read) {
+		if (!file_has_read_ops(cfile)) {
 			NS_ERR("alloc_device: cache file not readable\n");
 			err = -EINVAL;
 			goto err_close;
 		}
-		if (!cfile->f_op->write && !cfile->f_op->aio_write) {
+		if (!file_has_write_ops(cfile)) {
 			NS_ERR("alloc_device: cache file not writeable\n");
 			err = -EINVAL;
 			goto err_close;
diff --git a/drivers/usb/gadget/storage_common.c b/drivers/usb/gadget/storage_common.c
index ec20a1f..92d250c 100644
--- a/drivers/usb/gadget/storage_common.c
+++ b/drivers/usb/gadget/storage_common.c
@@ -220,11 +220,11 @@ int fsg_lun_open(struct fsg_lun *curlun, const char *filename)
 	 * If we can't read the file, it's no good.
 	 * If we can't write the file, use it read-only.
 	 */
-	if (!(filp->f_op->read || filp->f_op->aio_read)) {
+	if (!file_has_read_ops(filp)) {
 		LINFO(curlun, "file not readable: %s\n", filename);
 		goto out;
 	}
-	if (!(filp->f_op->write || filp->f_op->aio_write))
+	if (!file_has_write_ops(filp))
 		ro = 1;
 
 	size = i_size_read(inode->i_mapping->host);
diff --git a/fs/read_write.c b/fs/read_write.c
index 58e440d..2cde934 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -384,7 +384,7 @@ ssize_t vfs_read(struct file *file, char __user *buf, size_t count, loff_t *pos)
 
 	if (!(file->f_mode & FMODE_READ))
 		return -EBADF;
-	if (!file->f_op->read && !file->f_op->aio_read)
+	if (!file_has_read_ops(file))
 		return -EINVAL;
 	if (unlikely(!access_ok(VERIFY_WRITE, buf, count)))
 		return -EFAULT;
@@ -433,7 +433,7 @@ ssize_t __kernel_write(struct file *file, const char *buf, size_t count, loff_t
 	const char __user *p;
 	ssize_t ret;
 
-	if (!file->f_op->write && !file->f_op->aio_write)
+	if (!file_has_write_ops(file))
 		return -EINVAL;
 
 	old_fs = get_fs();
@@ -460,7 +460,7 @@ ssize_t vfs_write(struct file *file, const char __user *buf, size_t count, loff_
 
 	if (!(file->f_mode & FMODE_WRITE))
 		return -EBADF;
-	if (!file->f_op->write && !file->f_op->aio_write)
+	if (!file_has_write_ops(file))
 		return -EINVAL;
 	if (unlikely(!access_ok(VERIFY_READ, buf, count)))
 		return -EFAULT;
@@ -773,7 +773,7 @@ ssize_t vfs_readv(struct file *file, const struct iovec __user *vec,
 {
 	if (!(file->f_mode & FMODE_READ))
 		return -EBADF;
-	if (!file->f_op->aio_read && !file->f_op->read)
+	if (!file_has_read_ops(file))
 		return -EINVAL;
 
 	return do_readv_writev(READ, file, vec, vlen, pos);
@@ -786,7 +786,7 @@ ssize_t vfs_writev(struct file *file, const struct iovec __user *vec,
 {
 	if (!(file->f_mode & FMODE_WRITE))
 		return -EBADF;
-	if (!file->f_op->aio_write && !file->f_op->write)
+	if (!file_has_write_ops(file))
 		return -EINVAL;
 
 	return do_readv_writev(WRITE, file, vec, vlen, pos);
@@ -956,7 +956,7 @@ static size_t compat_readv(struct file *file,
 		goto out;
 
 	ret = -EINVAL;
-	if (!file->f_op->aio_read && !file->f_op->read)
+	if (!file_has_read_ops(file))
 		goto out;
 
 	ret = compat_do_readv_writev(READ, file, vec, vlen, pos);
@@ -1023,7 +1023,7 @@ static size_t compat_writev(struct file *file,
 		goto out;
 
 	ret = -EINVAL;
-	if (!file->f_op->aio_write && !file->f_op->write)
+	if (!file_has_write_ops(file))
 		goto out;
 
 	ret = compat_do_readv_writev(WRITE, file, vec, vlen, pos);
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 121f11f..86d4279 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1549,6 +1549,16 @@ struct file_operations {
 	int (*show_fdinfo)(struct seq_file *m, struct file *f);
 };
 
+static inline int file_has_read_ops(struct file *file)
+{
+	return file->f_op->read || file->f_op->aio_read;
+}
+
+static inline int file_has_write_ops(struct file *file)
+{
+	return file->f_op->write || file->f_op->aio_write;
+}
+
 struct inode_operations {
 	struct dentry * (*lookup) (struct inode *,struct dentry *, unsigned int);
 	void * (*follow_link) (struct dentry *, struct nameidata *);
-- 
1.8.4.2

