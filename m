Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754289Ab3JYPqn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Oct 2013 11:46:43 -0400
Received: from e28smtp04.in.ibm.com ([122.248.162.4]:59279 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751917Ab3JYPql (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Oct 2013 11:46:41 -0400
From: Robert Jennings <rcj@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Rik van Riel <riel@redhat.com>, Andrea Arcangeli <aarcange@redhat.com>,
        Dave Hansen <dave@sr71.net>, Robert Jennings <rcj@linux.vnet.ibm.com>,
        Matt Helsley <matt.helsley@gmail.com>,
        Anthony Liguori <anthony@codemonkey.ws>,
        Michael Roth <mdroth@linux.vnet.ibm.com>,
        Lei Li <lilei@linux.vnet.ibm.com>,
        Leonardo Garcia <lagarcia@linux.vnet.ibm.com>,
        Simon Jin <simonjin@linux.vnet.ibm.com>,
        Vlastimil Babka <vbabka@suse.cz>
Subject: [PATCH v2 1/2] vmsplice: unmap gifted pages for recipient
Date: Fri, 25 Oct 2013 10:46:23 -0500
Message-Id: <1382715984-10558-2-git-send-email-rcj@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1382715984-10558-1-git-send-email-rcj@linux.vnet.ibm.com>
References: <1382715984-10558-1-git-send-email-rcj@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13102515-5564-0000-0000-00000A5E7DD9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Robert C Jennings <rcj@linux.vnet.ibm.com>

Introduce use of the unused SPLICE_F_MOVE flag for vmsplice to zap
pages.

When vmsplice is called with flags (SPLICE_F_GIFT | SPLICE_F_MOVE) the
writer's gift'ed pages would be zapped.  This patch supports further work
to move vmsplice'd pages rather than copying them.  That patch has the
restriction that the page must not be mapped by the source for the move,
otherwise it will fall back to copying the page.

Signed-off-by: Matt Helsley <matt.helsley@gmail.com>
Signed-off-by: Robert C Jennings <rcj@linux.vnet.ibm.com>
---
Changes since v1:
 - Cleanup zap coalescing in splice_to_pipe for readability
 - Field added to struct partial_page in v1 was unnecessary, using 
   private field instead.
---
 fs/splice.c | 38 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 38 insertions(+)

diff --git a/fs/splice.c b/fs/splice.c
index 3b7ee65..c14be6f 100644
--- a/fs/splice.c
+++ b/fs/splice.c
@@ -188,12 +188,18 @@ ssize_t splice_to_pipe(struct pipe_inode_info *pipe,
 {
 	unsigned int spd_pages = spd->nr_pages;
 	int ret, do_wakeup, page_nr;
+	struct vm_area_struct *vma;
+	unsigned long user_start, user_end, addr;
 
 	ret = 0;
 	do_wakeup = 0;
 	page_nr = 0;
+	vma = NULL;
+	user_start = user_end = 0;
 
 	pipe_lock(pipe);
+	/* mmap_sem taken for zap_page_range with SPLICE_F_MOVE */
+	down_read(&current->mm->mmap_sem);
 
 	for (;;) {
 		if (!pipe->readers) {
@@ -215,6 +221,33 @@ ssize_t splice_to_pipe(struct pipe_inode_info *pipe,
 			if (spd->flags & SPLICE_F_GIFT)
 				buf->flags |= PIPE_BUF_FLAG_GIFT;
 
+			/* Prepare to move page sized/aligned bufs.
+			 * Gather pages for a single zap_page_range()
+			 * call per VMA.
+			 */
+			if (spd->flags & (SPLICE_F_GIFT | SPLICE_F_MOVE) &&
+					!buf->offset &&
+					(buf->len == PAGE_SIZE)) {
+				addr = buf->private;
+
+				if (vma && (addr == user_end) &&
+					   (addr + PAGE_SIZE <= vma->vm_end)) {
+					/* Same vma, no holes */
+					user_end += PAGE_SIZE;
+				} else {
+					if (vma)
+						zap_page_range(vma, user_start,
+							(user_end - user_start),
+							NULL);
+					vma = find_vma(current->mm, addr);
+					if (!IS_ERR_OR_NULL(vma)) {
+						user_start = addr;
+						user_end = (addr + PAGE_SIZE);
+					} else
+						vma = NULL;
+				}
+			}
+
 			pipe->nrbufs++;
 			page_nr++;
 			ret += buf->len;
@@ -255,6 +288,10 @@ ssize_t splice_to_pipe(struct pipe_inode_info *pipe,
 		pipe->waiting_writers--;
 	}
 
+	if (vma)
+		zap_page_range(vma, user_start, (user_end - user_start), NULL);
+
+	up_read(&current->mm->mmap_sem);
 	pipe_unlock(pipe);
 
 	if (do_wakeup)
@@ -1475,6 +1512,7 @@ static int get_iovec_page_array(const struct iovec __user *iov,
 
 			partial[buffers].offset = off;
 			partial[buffers].len = plen;
+			partial[buffers].private = (unsigned long)base;
 
 			off = 0;
 			len -= plen;
-- 
1.8.1.2

