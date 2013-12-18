Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753770Ab3LRVSX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 16:18:23 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:36644 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754652Ab3LRVOU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 16:14:20 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Josef Bacik <jbacik@fusionio.com>,
        Chris Mason <chris.mason@fusionio.com>
Subject: [PATCH 3.12 111/118] Btrfs: stop using vfs_read in send
Date: Wed, 18 Dec 2013 13:12:28 -0800
Message-Id: <20131218211222.602365045@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20131218211219.461663463@linuxfoundation.org>
References: <20131218211219.461663463@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josef Bacik <jbacik@fusionio.com>

commit ed2590953bd06b892f0411fc94e19175d32f197a upstream.

Apparently we don't actually close the files until we return to userspace, so
stop using vfs_read in send.  This is actually better for us since we can avoid
all the extra logic of holding the file we're sending open and making sure to
clean it up.  This will fix people who have been hitting too many files open
errors when trying to send.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fusionio.com>
Signed-off-by: Chris Mason <chris.mason@fusionio.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/btrfs/send.c |  175 +++++++++++++++++++++++---------------------------------
 1 file changed, 72 insertions(+), 103 deletions(-)

--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -121,7 +121,6 @@ struct send_ctx {
 	struct list_head name_cache_list;
 	int name_cache_size;
 
-	struct file *cur_inode_filp;
 	char *read_buf;
 };
 
@@ -2120,77 +2119,6 @@ out:
 }
 
 /*
- * Called for regular files when sending extents data. Opens a struct file
- * to read from the file.
- */
-static int open_cur_inode_file(struct send_ctx *sctx)
-{
-	int ret = 0;
-	struct btrfs_key key;
-	struct path path;
-	struct inode *inode;
-	struct dentry *dentry;
-	struct file *filp;
-	int new = 0;
-
-	if (sctx->cur_inode_filp)
-		goto out;
-
-	key.objectid = sctx->cur_ino;
-	key.type = BTRFS_INODE_ITEM_KEY;
-	key.offset = 0;
-
-	inode = btrfs_iget(sctx->send_root->fs_info->sb, &key, sctx->send_root,
-			&new);
-	if (IS_ERR(inode)) {
-		ret = PTR_ERR(inode);
-		goto out;
-	}
-
-	dentry = d_obtain_alias(inode);
-	inode = NULL;
-	if (IS_ERR(dentry)) {
-		ret = PTR_ERR(dentry);
-		goto out;
-	}
-
-	path.mnt = sctx->mnt;
-	path.dentry = dentry;
-	filp = dentry_open(&path, O_RDONLY | O_LARGEFILE, current_cred());
-	dput(dentry);
-	dentry = NULL;
-	if (IS_ERR(filp)) {
-		ret = PTR_ERR(filp);
-		goto out;
-	}
-	sctx->cur_inode_filp = filp;
-
-out:
-	/*
-	 * no xxxput required here as every vfs op
-	 * does it by itself on failure
-	 */
-	return ret;
-}
-
-/*
- * Closes the struct file that was created in open_cur_inode_file
- */
-static int close_cur_inode_file(struct send_ctx *sctx)
-{
-	int ret = 0;
-
-	if (!sctx->cur_inode_filp)
-		goto out;
-
-	ret = filp_close(sctx->cur_inode_filp, NULL);
-	sctx->cur_inode_filp = NULL;
-
-out:
-	return ret;
-}
-
-/*
  * Sends a BTRFS_SEND_C_SUBVOL command/item to userspace
  */
 static int send_subvol_begin(struct send_ctx *sctx)
@@ -3622,6 +3550,72 @@ out:
 	return ret;
 }
 
+static ssize_t fill_read_buf(struct send_ctx *sctx, u64 offset, u32 len)
+{
+	struct btrfs_root *root = sctx->send_root;
+	struct btrfs_fs_info *fs_info = root->fs_info;
+	struct inode *inode;
+	struct page *page;
+	char *addr;
+	struct btrfs_key key;
+	pgoff_t index = offset >> PAGE_CACHE_SHIFT;
+	pgoff_t last_index;
+	unsigned pg_offset = offset & ~PAGE_CACHE_MASK;
+	ssize_t ret = 0;
+
+	key.objectid = sctx->cur_ino;
+	key.type = BTRFS_INODE_ITEM_KEY;
+	key.offset = 0;
+
+	inode = btrfs_iget(fs_info->sb, &key, root, NULL);
+	if (IS_ERR(inode))
+		return PTR_ERR(inode);
+
+	if (offset + len > i_size_read(inode)) {
+		if (offset > i_size_read(inode))
+			len = 0;
+		else
+			len = offset - i_size_read(inode);
+	}
+	if (len == 0)
+		goto out;
+
+	last_index = (offset + len - 1) >> PAGE_CACHE_SHIFT;
+	while (index <= last_index) {
+		unsigned cur_len = min_t(unsigned, len,
+					 PAGE_CACHE_SIZE - pg_offset);
+		page = find_or_create_page(inode->i_mapping, index, GFP_NOFS);
+		if (!page) {
+			ret = -ENOMEM;
+			break;
+		}
+
+		if (!PageUptodate(page)) {
+			btrfs_readpage(NULL, page);
+			lock_page(page);
+			if (!PageUptodate(page)) {
+				unlock_page(page);
+				page_cache_release(page);
+				ret = -EIO;
+				break;
+			}
+		}
+
+		addr = kmap(page);
+		memcpy(sctx->read_buf + ret, addr + pg_offset, cur_len);
+		kunmap(page);
+		unlock_page(page);
+		page_cache_release(page);
+		index++;
+		pg_offset = 0;
+		len -= cur_len;
+		ret += cur_len;
+	}
+out:
+	iput(inode);
+	return ret;
+}
+
 /*
  * Read some bytes from the current inode/file and send a write command to
  * user space.
@@ -3630,35 +3624,20 @@ static int send_write(struct send_ctx *s
 {
 	int ret = 0;
 	struct fs_path *p;
-	loff_t pos = offset;
-	int num_read = 0;
-	mm_segment_t old_fs;
+	ssize_t num_read = 0;
 
 	p = fs_path_alloc();
 	if (!p)
 		return -ENOMEM;
 
-	/*
-	 * vfs normally only accepts user space buffers for security reasons.
-	 * we only read from the file and also only provide the read_buf buffer
-	 * to vfs. As this buffer does not come from a user space call, it's
-	 * ok to temporary allow kernel space buffers.
-	 */
-	old_fs = get_fs();
-	set_fs(KERNEL_DS);
-
 verbose_printk("btrfs: send_write offset=%llu, len=%d\n", offset, len);
 
-	ret = open_cur_inode_file(sctx);
-	if (ret < 0)
-		goto out;
-
-	ret = vfs_read(sctx->cur_inode_filp, sctx->read_buf, len, &pos);
-	if (ret < 0)
-		goto out;
-	num_read = ret;
-	if (!num_read)
+	num_read = fill_read_buf(sctx, offset, len);
+	if (num_read <= 0) {
+		if (num_read < 0)
+			ret = num_read;
 		goto out;
+	}
 
 	ret = begin_cmd(sctx, BTRFS_SEND_C_WRITE);
 	if (ret < 0)
@@ -3677,7 +3656,6 @@ verbose_printk("btrfs: send_write offset
 tlv_put_failure:
 out:
 	fs_path_free(p);
-	set_fs(old_fs);
 	if (ret < 0)
 		return ret;
 	return num_read;
@@ -4222,10 +4200,6 @@ static int changed_inode(struct send_ctx
 	u64 left_gen = 0;
 	u64 right_gen = 0;
 
-	ret = close_cur_inode_file(sctx);
-	if (ret < 0)
-		goto out;
-
 	sctx->cur_ino = key->objectid;
 	sctx->cur_inode_new_gen = 0;
 
@@ -4686,11 +4660,6 @@ static int send_subvol(struct send_ctx *
 	}
 
 out:
-	if (!ret)
-		ret = close_cur_inode_file(sctx);
-	else
-		close_cur_inode_file(sctx);
-
 	free_recorded_refs(sctx);
 	return ret;
 }


