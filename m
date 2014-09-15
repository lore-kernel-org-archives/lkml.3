Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932165AbaIOUVX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 16:21:23 -0400
Received: from mail-qc0-f173.google.com ([209.85.216.173]:54730 "EHLO
	mail-qc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755872AbaIOUVU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 16:21:20 -0400
Date: Mon, 15 Sep 2014 16:21:14 -0400
From: Milosz Tanski <milosz@adfin.com>
To: linux-kernel@vger.kernel.org
Cc: Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org,
        linux-aio@kvack.org, Mel Gorman <mgorman@suse.de>,
        Volker Lendecke <Volker.Lendecke@sernet.de>, Tejun Heo <tj@kernel.org>,
        Jeff Moyer <jmoyer@redhat.com>
Subject: [PATCH 4/7] O_NONBLOCK flag for readv2/preadv2
Message-ID: <ead00ff46b581749da6d1a6d2db9d8f8dc3aed67.1410810247.git.milosz@adfin.com>
References: <cover.1410810247.git.milosz@adfin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1410810247.git.milosz@adfin.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Filesystems that generic_file_read_iter will not be allowed to perform
non-blocking reads. This only will read data if it's in the page cache and if
there is no page error (causing a re-read).

Signed-off-by: Milosz Tanski <milosz@adfin.com>
---
 fs/read_write.c |    4 ++--
 mm/filemap.c    |   21 +++++++++++++++++++++
 2 files changed, 23 insertions(+), 2 deletions(-)

diff --git a/fs/read_write.c b/fs/read_write.c
index 6c5030a..87a6034 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -908,7 +908,7 @@ SYSCALL_DEFINE4(readv2, unsigned long, fd, const struct iovec __user *, vec,
 	struct fd f = fdget_pos(fd);
 	ssize_t ret = -EBADF;
 
-	if (flags & ~0)
+	if (flags & ~O_NONBLOCK)
 		return -EINVAL;
 
 	if (f.file) {
@@ -1006,7 +1006,7 @@ SYSCALL_DEFINE6(preadv2, unsigned long, fd, const struct iovec __user *, vec,
 	struct fd f;
 	ssize_t ret = -EBADF;
 
-	if (flags & ~0)
+	if (flags & ~O_NONBLOCK)
 		return -EINVAL;
 	if (pos < 0)
 		return -EINVAL;
diff --git a/mm/filemap.c b/mm/filemap.c
index c95edbf..5b72572 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -1483,7 +1483,10 @@ static ssize_t do_generic_file_read(struct file *filp, loff_t *ppos,
 		cond_resched();
 find_page:
 		page = find_get_page(mapping, index);
+
 		if (!page) {
+			if (flags & O_NONBLOCK)
+				goto would_block;
 			page_cache_sync_readahead(mapping,
 					ra, filp,
 					index, last_index - index);
@@ -1575,6 +1578,11 @@ page_ok:
 		continue;
 
 page_not_up_to_date:
+		if (flags & O_NONBLOCK) {
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
 
+		if (flags & O_NONBLOCK) {
+			unlock_page(page);
+			page_cache_release(page);
+			goto would_block;
+		}
+
 readpage:
 		/*
 		 * A previous I/O error may have been due to temporary
@@ -1662,6 +1676,10 @@ no_cached_page:
 			goto out;
 		}
 		goto readpage;
+
+would_block:
+		error = -EAGAIN;
+		goto out;
 	}
 
 out:
@@ -1697,6 +1715,9 @@ generic_file_read_iter(struct kiocb *iocb, struct iov_iter *iter, int flags)
 		size_t count = iov_iter_count(iter);
 		loff_t size;
 
+		if (flags & O_NONBLOCK)
+			return -EAGAIN;
+
 		if (!count)
 			goto out; /* skip atime */
 		size = i_size_read(inode);
-- 
1.7.9.5

