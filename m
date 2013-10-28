Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932857Ab3J1PGI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 11:06:08 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51071 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932113Ab3J1Osx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 10:48:53 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Cyril Hrubis <chrubis@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.5 15/64] mm/mmap: check for RLIMIT_AS before unmapping
Date: Mon, 28 Oct 2013 14:47:34 +0000
Message-Id: <1382971703-17393-16-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1382971703-17393-1-git-send-email-luis.henriques@canonical.com>
References: <1382971703-17393-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.24 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cyril Hrubis <chrubis@suse.cz>

commit e8420a8ece80b3fe810415ecf061d54ca7fab266 upstream.

Fix a corner case for MAP_FIXED when requested mapping length is larger
than rlimit for virtual memory.  In such case any overlapping mappings
are unmapped before we check for the limit and return ENOMEM.

The check is moved before the loop that unmaps overlapping parts of
existing mappings.  When we are about to hit the limit (currently mapped
pages + len > limit) we scan for overlapping pages and check again
accounting for them.

This fixes situation when userspace program expects that the previous
mappings are preserved after the mmap() syscall has returned with error.
(POSIX clearly states that successfull mapping shall replace any
previous mappings.)

This corner case was found and can be tested with LTP testcase:

testcases/open_posix_testsuite/conformance/interfaces/mmap/24-2.c

In this case the mmap, which is clearly over current limit, unmaps
dynamic libraries and the testcase segfaults right after returning into
userspace.

I've also looked at the second instance of the unmapping loop in the
do_brk().  The do_brk() is called from brk() syscall and from vm_brk().
The brk() syscall checks for overlapping mappings and bails out when
there are any (so it can't be triggered from the brk syscall).  The
vm_brk() is called only from binmft handlers so it shouldn't be
triggered unless binmft handler created overlapping mappings.

Signed-off-by: Cyril Hrubis <chrubis@suse.cz>
Reviewed-by: Mel Gorman <mgorman@suse.de>
Reviewed-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 mm/mmap.c | 50 ++++++++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 46 insertions(+), 4 deletions(-)

diff --git a/mm/mmap.c b/mm/mmap.c
index f1a9a72..74e0d0d 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -6,6 +6,7 @@
  * Address space accounting code	<alan@lxorguk.ukuu.org.uk>
  */
 
+#include <linux/kernel.h>
 #include <linux/slab.h>
 #include <linux/backing-dev.h>
 #include <linux/mm.h>
@@ -393,6 +394,34 @@ find_vma_prepare(struct mm_struct *mm, unsigned long addr,
 	return vma;
 }
 
+static unsigned long count_vma_pages_range(struct mm_struct *mm,
+		unsigned long addr, unsigned long end)
+{
+	unsigned long nr_pages = 0;
+	struct vm_area_struct *vma;
+
+	/* Find first overlaping mapping */
+	vma = find_vma_intersection(mm, addr, end);
+	if (!vma)
+		return 0;
+
+	nr_pages = (min(end, vma->vm_end) -
+		max(addr, vma->vm_start)) >> PAGE_SHIFT;
+
+	/* Iterate over the rest of the overlaps */
+	for (vma = vma->vm_next; vma; vma = vma->vm_next) {
+		unsigned long overlap_len;
+
+		if (vma->vm_start > end)
+			break;
+
+		overlap_len = min(end, vma->vm_end) - vma->vm_start;
+		nr_pages += overlap_len >> PAGE_SHIFT;
+	}
+
+	return nr_pages;
+}
+
 void __vma_link_rb(struct mm_struct *mm, struct vm_area_struct *vma,
 		struct rb_node **rb_link, struct rb_node *rb_parent)
 {
@@ -1228,6 +1257,23 @@ unsigned long mmap_region(struct file *file, unsigned long addr,
 	unsigned long charged = 0;
 	struct inode *inode =  file ? file->f_path.dentry->d_inode : NULL;
 
+	/* Check against address space limit. */
+	if (!may_expand_vm(mm, len >> PAGE_SHIFT)) {
+		unsigned long nr_pages;
+
+		/*
+		 * MAP_FIXED may remove pages of mappings that intersects with
+		 * requested mapping. Account for the pages it would unmap.
+		 */
+		if (!(vm_flags & MAP_FIXED))
+			return -ENOMEM;
+
+		nr_pages = count_vma_pages_range(mm, addr, addr + len);
+
+		if (!may_expand_vm(mm, (len >> PAGE_SHIFT) - nr_pages))
+			return -ENOMEM;
+	}
+
 	/* Clear old maps */
 	error = -ENOMEM;
 munmap_back:
@@ -1238,10 +1284,6 @@ munmap_back:
 		goto munmap_back;
 	}
 
-	/* Check against address space limit. */
-	if (!may_expand_vm(mm, len >> PAGE_SHIFT))
-		return -ENOMEM;
-
 	/*
 	 * Set 'VM_NORESERVE' if we should not account for the
 	 * memory use of this mapping.
-- 
1.8.3.2

