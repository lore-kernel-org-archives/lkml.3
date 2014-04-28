Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932546AbaD1VKj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 17:10:39 -0400
Received: from mailrelay009.isp.belgacom.be ([195.238.6.176]:13486 "EHLO
	mailrelay009.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932415AbaD1VKh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 17:10:37 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvgTAP/CXlNXQw00/2dsb2JhbABZgwasDQUBAQEFmXICAoEaF3SCUxMcIxiBAiQTiEUByHWFWoh/hEABA458ig8Bkl6DMzs
Date: Mon, 28 Apr 2014 23:12:39 +0200
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: jack <jack@suse.cz>, hch <hch@infradead.org>,
        Viro <viro@zeniv.linux.org.uk>, tytso <tytso@mit.edu>,
        akpm <akpm@linux-foundation.org>
Subject: [PATCH V3 1/2] FS: Add generic data flush to fsync
Message-Id: <20140428231239.dbae4da4297c0b9230d9db4d@skynet.be>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch issues a flush in generic_file_fsync.
(Modern filesystems already do it)

-Behaviour can be reversed using /sys/devices/.../cache_type
-Filesystems can also call __generic_file_fsync with bool flush false

Suggested-by: Jan Kara <jack@suse.cz>
Suggested-by: Christoph Hellwig <hch@infradead.org>
Cc: Jan Kara <jack@suse.cz>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
V3: __generic_file_fsync = no flush
V2: No flag
V1: First version with MS_BARRIER flag

 fs/libfs.c         | 36 +++++++++++++++++++++++++++++++++---
 include/linux/fs.h |  1 +
 2 files changed, 34 insertions(+), 3 deletions(-)

diff --git a/fs/libfs.c b/fs/libfs.c
index a184424..4877906 100644
--- a/fs/libfs.c
+++ b/fs/libfs.c
@@ -3,6 +3,7 @@
  *	Library for filesystems writers.
  */
 
+#include <linux/blkdev.h>
 #include <linux/export.h>
 #include <linux/pagemap.h>
 #include <linux/slab.h>
@@ -923,16 +924,19 @@ struct dentry *generic_fh_to_parent(struct super_block *sb, struct fid *fid,
 EXPORT_SYMBOL_GPL(generic_fh_to_parent);
 
 /**
- * generic_file_fsync - generic fsync implementation for simple filesystems
+ * __generic_file_fsync - generic fsync implementation for simple filesystems
+ *
  * @file:	file to synchronize
+ * @start:	start offset in bytes
+ * @end:	end offset in bytes (inclusive)
  * @datasync:	only synchronize essential metadata if true
  *
  * This is a generic implementation of the fsync method for simple
  * filesystems which track all non-inode metadata in the buffers list
  * hanging off the address_space structure.
  */
-int generic_file_fsync(struct file *file, loff_t start, loff_t end,
-		       int datasync)
+int __generic_file_fsync(struct file *file, loff_t start, loff_t end,
+				 int datasync)
 {
 	struct inode *inode = file->f_mapping->host;
 	int err;
@@ -952,10 +956,36 @@ int generic_file_fsync(struct file *file, loff_t start, loff_t end,
 	err = sync_inode_metadata(inode, 1);
 	if (ret == 0)
 		ret = err;
+
 out:
 	mutex_unlock(&inode->i_mutex);
 	return ret;
 }
+EXPORT_SYMBOL(__generic_file_fsync);
+
+/**
+ * generic_file_fsync - generic fsync implementation for simple filesystems
+ *			with flush
+ * @file:	file to synchronize
+ * @start:	start offset in bytes
+ * @end:	end offset in bytes (inclusive)
+ * @datasync:	only synchronize essential metadata if true
+ *
+ */
+
+int generic_file_fsync(struct file *file, loff_t start, loff_t end,
+		       int datasync)
+{
+	struct inode *inode = file->f_mapping->host;
+	int err;
+
+	err = __generic_file_fsync(file, start, end, datasync);
+	if (err)
+		return err;
+
+	return blkdev_issue_flush(inode->i_sb->s_bdev, GFP_KERNEL, NULL);
+
+}
 EXPORT_SYMBOL(generic_file_fsync);
 
 /**
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 8780312..c3f46e4 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2590,6 +2590,7 @@ extern ssize_t simple_read_from_buffer(void __user *to, size_t count,
 extern ssize_t simple_write_to_buffer(void *to, size_t available, loff_t *ppos,
 		const void __user *from, size_t count);
 
+extern int __generic_file_fsync(struct file *, loff_t, loff_t, int);
 extern int generic_file_fsync(struct file *, loff_t, loff_t, int);
 
 extern int generic_check_addressable(unsigned, u64);
-- 
1.8.4.5
