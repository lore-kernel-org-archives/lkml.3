Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756852Ab3GYRWb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 13:22:31 -0400
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:47955 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756739Ab3GYRWI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 13:22:08 -0400
From: Robert Jennings <rcj@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Rik van Riel <riel@redhat.com>, Andrea Arcangeli <aarcange@redhat.com>,
        Dave Hansen <dave@sr71.net>, Robert Jennings <rcj@linux.vnet.ibm.com>,
        Matt Helsley <matt.helsley@gmail.com>,
        Anthony Liguori <aliguori@us.ibm.com>,
        Michael Roth <mdroth@linux.vnet.ibm.com>,
        Lei Li <lilei@linux.vnet.ibm.com>,
        Leonardo Garcia <lagarcia@linux.vnet.ibm.com>
Subject: [RFC PATCH 1/2] vmsplice unmap gifted pages for recipient
Date: Thu, 25 Jul 2013 12:21:45 -0500
Message-Id: <1374772906-21511-2-git-send-email-rcj@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1374772906-21511-1-git-send-email-rcj@linux.vnet.ibm.com>
References: <1374772906-21511-1-git-send-email-rcj@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13072604-3568-0000-0000-000003FC381D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matt Helsley <matthltc@us.ibm.com>

Introduce use of the unused SPLICE_F_MOVE flag for vmsplice to zap
pages.

When vmsplice is called with flags (SPLICE_F_GIFT | SPLICE_F_MOVE) the
writer's gift'ed pages would be zapped.  This patch supports further work
to move vmsplice'd pages rather than copying them.  That patch has the
restriction that the page must not be mapped by the source for the move,
otherwise it will fall back to copying the page.

Signed-off-by: Matt Helsley <matthltc@us.ibm.com>
Signed-off-by: Matt Helsley <matt.helsley@gmail.com>
Signed-off-by: Robert Jennings <rcj@linux.vnet.ibm.com>
---
 fs/splice.c            | 25 ++++++++++++++++++++++++-
 include/linux/splice.h |  1 +
 2 files changed, 25 insertions(+), 1 deletion(-)

diff --git a/fs/splice.c b/fs/splice.c
index 3b7ee65..6aa964f 100644
--- a/fs/splice.c
+++ b/fs/splice.c
@@ -172,6 +172,18 @@ static void wakeup_pipe_readers(struct pipe_inode_info *pipe)
 	kill_fasync(&pipe->fasync_readers, SIGIO, POLL_IN);
 }
 
+static void zap_buf_page(unsigned long useraddr)
+{
+	struct vm_area_struct *vma;
+
+	down_read(&current->mm->mmap_sem);
+	vma = find_vma_intersection(current->mm, useraddr,
+			useraddr + PAGE_SIZE);
+	if (!IS_ERR_OR_NULL(vma))
+		zap_page_range(vma, useraddr, PAGE_SIZE, NULL);
+	up_read(&current->mm->mmap_sem);
+}
+
 /**
  * splice_to_pipe - fill passed data into a pipe
  * @pipe:	pipe to fill
@@ -212,8 +224,16 @@ ssize_t splice_to_pipe(struct pipe_inode_info *pipe,
 			buf->len = spd->partial[page_nr].len;
 			buf->private = spd->partial[page_nr].private;
 			buf->ops = spd->ops;
-			if (spd->flags & SPLICE_F_GIFT)
+			if (spd->flags & SPLICE_F_GIFT) {
+				unsigned long useraddr =
+						spd->partial[page_nr].useraddr;
+
+				if ((spd->flags & SPLICE_F_MOVE) &&
+				    !buf->offset && (buf->len == PAGE_SIZE))
+					/* Can move page aligned buf */
+					zap_buf_page(useraddr);
 				buf->flags |= PIPE_BUF_FLAG_GIFT;
+			}
 
 			pipe->nrbufs++;
 			page_nr++;
@@ -485,6 +505,7 @@ fill_it:
 
 		spd.partial[page_nr].offset = loff;
 		spd.partial[page_nr].len = this_len;
+		spd.partial[page_nr].useraddr = index << PAGE_CACHE_SHIFT;
 		len -= this_len;
 		loff = 0;
 		spd.nr_pages++;
@@ -656,6 +677,7 @@ ssize_t default_file_splice_read(struct file *in, loff_t *ppos,
 		this_len = min_t(size_t, vec[i].iov_len, res);
 		spd.partial[i].offset = 0;
 		spd.partial[i].len = this_len;
+		spd.partial[i].useraddr = (unsigned long)vec[i].iov_base;
 		if (!this_len) {
 			__free_page(spd.pages[i]);
 			spd.pages[i] = NULL;
@@ -1475,6 +1497,7 @@ static int get_iovec_page_array(const struct iovec __user *iov,
 
 			partial[buffers].offset = off;
 			partial[buffers].len = plen;
+			partial[buffers].useraddr = (unsigned long)base;
 
 			off = 0;
 			len -= plen;
diff --git a/include/linux/splice.h b/include/linux/splice.h
index 74575cb..56661e3 100644
--- a/include/linux/splice.h
+++ b/include/linux/splice.h
@@ -44,6 +44,7 @@ struct partial_page {
 	unsigned int offset;
 	unsigned int len;
 	unsigned long private;
+	unsigned long useraddr;
 };
 
 /*
-- 
1.8.1.2

