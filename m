Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757572Ab3JRTwl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 15:52:41 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54715 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754473Ab3JRTwf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 15:52:35 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Cyril Hrubis <chrubis@suse.cz>, Mel Gorman <mgorman@suse.de>,
        Wanpeng Li <liwanp@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Xishi Qiu <qiuxishi@huawei.com>
Subject: [ 10/11] mm/mmap: check for RLIMIT_AS before unmapping
Date: Fri, 18 Oct 2013 12:53:39 -0700
Message-Id: <20131018195049.769189161@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.6.g82e253f.dirty
In-Reply-To: <20131018195049.069623827@linuxfoundation.org>
References: <20131018195049.069623827@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Cc: Xishi Qiu <qiuxishi@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/mmap.c |   50 ++++++++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 46 insertions(+), 4 deletions(-)

--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -6,6 +6,7 @@
  * Address space accounting code	<alan@lxorguk.ukuu.org.uk>
  */
 
+#include <linux/kernel.h>
 #include <linux/slab.h>
 #include <linux/backing-dev.h>
 #include <linux/mm.h>
@@ -392,6 +393,34 @@ find_vma_prepare(struct mm_struct *mm, u
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
@@ -1245,6 +1274,23 @@ unsigned long mmap_region(struct file *f
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
@@ -1255,10 +1301,6 @@ munmap_back:
 		goto munmap_back;
 	}
 
-	/* Check against address space limit. */
-	if (!may_expand_vm(mm, len >> PAGE_SHIFT))
-		return -ENOMEM;
-
 	/*
 	 * Set 'VM_NORESERVE' if we should not account for the
 	 * memory use of this mapping.


