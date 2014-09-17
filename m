Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757294AbaIQWV6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 18:21:58 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:56502 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757126AbaIQWVD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 18:21:03 -0400
From: Milosz Tanski <milosz@adfin.com>
To: linux-kernel@vger.kernel.org
Cc: Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org,
        linux-aio@kvack.org, Mel Gorman <mgorman@suse.de>,
        Volker Lendecke <Volker.Lendecke@sernet.de>, Tejun Heo <tj@kernel.org>,
        Jeff Moyer <jmoyer@redhat.com>, "Theodore Ts'o" <tytso@mit.edu>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: [RFC v2 4/5] O_NONBLOCK flag for readv2/preadv2
Date: Wed, 17 Sep 2014 22:20:49 +0000
Message-Id: <e190ba39a6244ec19344f7fe161d6e4e89962a3d.1410983999.git.milosz@adfin.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <cover.1410983998.git.milosz@adfin.com>
References: <cover.1410810247.git.milosz@adfin.com>
 <cover.1410983998.git.milosz@adfin.com>
In-Reply-To: <cover.1410983998.git.milosz@adfin.com>
References: <cover.1410983998.git.milosz@adfin.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Filesystems that generic_file_read_iter will not be allowed to perform
non-blocking reads. This only will read data if it's in the page cache and if
there is no page error (causing a re-read).

Signed-off-by: Milosz Tanski <milosz@adfin.com>
---
 fs/read_write.c    |  4 +++-
 include/linux/fs.h |  3 +++
 mm/filemap.c       | 19 +++++++++++++++++++
 3 files changed, 25 insertions(+), 1 deletion(-)

diff --git a/fs/read_write.c b/fs/read_write.c
index 3db2e87..29b5823 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -864,8 +864,10 @@ ssize_t vfs_readv(struct file *file, const struct iovec __user *vec,
 		return -EBADF;
 	if (!(file->f_mode & FMODE_CAN_READ))
 		return -EINVAL;
-	if (flags & ~0)
+	if (flags & ~RWF_NONBLOCK)
 		return -EINVAL;
+	if ((file->f_flags & O_DIRECT) && (flags & RWF_NONBLOCK))
+		return -EAGAIN;
 
 	return do_readv_writev(READ, file, vec, vlen, pos, flags);
 }
diff --git a/include/linux/fs.h b/include/linux/fs.h
index e9bea52..c9c6ac5 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1477,6 +1477,9 @@ struct block_device_operations;
 #define HAVE_COMPAT_IOCTL 1
 #define HAVE_UNLOCKED_IOCTL 1
 
+/* These flags are used for the readv/writev syscalls with flags. */
+#define RWF_NONBLOCK O_NONBLOCK
+
 struct iov_iter;
 
 struct file_operations {
diff --git a/mm/filemap.c b/mm/filemap.c
index e0919ba..6b7aba8 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -1483,7 +1483,10 @@ static ssize_t do_generic_file_read(struct file *filp, loff_t *ppos,
 		cond_resched();
 find_page:
 		page = find_get_page(mapping, index);
+
 		if (!page) {
+			if (flags & RWF_NONBLOCK)
+				goto would_block;
 			page_cache_sync_readahead(mapping,
 					ra, filp,
 					index, last_index - index);
@@ -1575,6 +1578,11 @@ page_ok:
 		continue;
 
 page_not_up_to_date:
+		if (flags & RWF_NONBLOCK) {
+			page_cache_release(page);
+			goto would_block;
+		}
+
 		/* Get exclusive access to the page ... */
 		error = lock_page_killable(page);
 		if (unlikely(error))
@@ -1594,6 +1602,12 @@ page_not_up_to_date_locked:
 			goto page_ok;
 		}
 
+		if (flags & RWF_NONBLOCK) {
+			unlock_page(page);
+			page_cache_release(page);
+			goto would_block;
+		}
+
 readpage:
 		/*
 		 * A previous I/O error may have been due to temporary
@@ -1664,6 +1678,8 @@ no_cached_page:
 		goto readpage;
 	}
 
+would_block:
+	error = -EAGAIN;
 out:
 	ra->prev_pos = prev_index;
 	ra->prev_pos <<= PAGE_CACHE_SHIFT;
@@ -1697,6 +1713,9 @@ generic_file_read_iter(struct kiocb *iocb, struct iov_iter *iter)
 		size_t count = iov_iter_count(iter);
 		loff_t size;
 
+		if (iocb->ki_rwflags & RWF_NONBLOCK)
+			return -EAGAIN;
+
 		if (!count)
 			goto out; /* skip atime */
 		size = i_size_read(inode);
-- 
2.1.0

