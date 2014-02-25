Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753772AbaBYOVP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 09:21:15 -0500
Received: from mga02.intel.com ([134.134.136.20]:18829 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753531AbaBYOTY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 09:19:24 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,540,1389772800"; 
   d="scan'208";a="481478529"
From: Matthew Wilcox <matthew.r.wilcox@intel.com>
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-fsdevel@vger.kernel.org, willy@linux.intel.com
Cc: Matthew Wilcox <matthew.r.wilcox@intel.com>
Subject: [PATCH v6 22/22] dax: Add reporting of major faults
Date: Tue, 25 Feb 2014 09:18:38 -0500
Message-Id: <1393337918-28265-23-git-send-email-matthew.r.wilcox@intel.com>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1393337918-28265-1-git-send-email-matthew.r.wilcox@intel.com>
References: <1393337918-28265-1-git-send-email-matthew.r.wilcox@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If we have to call get_block with the create argument set to 1, then
the filesystem almost certainly had to zero the block. which is an I/O,
which should be reported as a major fault.

Note that major faults on DAX files happen for different reasons than
major faults on non-DAX files.  DAX files behave as if everything except
file holes is already cached.  That's all the more reason to report
major faults when we do have to do I/O; it may be a valuable resource
for sysadmins trying to diagnose performance problems.

Signed-off-by: Matthew Wilcox <matthew.r.wilcox@intel.com>
---
 fs/dax.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/fs/dax.c b/fs/dax.c
index cdc8012..79a67c5 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -20,10 +20,12 @@
 #include <linux/fs.h>
 #include <linux/genhd.h>
 #include <linux/highmem.h>
+#include <linux/memcontrol.h>
 #include <linux/mm.h>
 #include <linux/mutex.h>
 #include <linux/sched.h>
 #include <linux/uio.h>
+#include <linux/vmstat.h>
 
 int dax_clear_blocks(struct inode *inode, sector_t block, long size)
 {
@@ -286,6 +288,7 @@ static int do_dax_fault(struct vm_area_struct *vma, struct vm_fault *vmf,
 	pgoff_t size;
 	unsigned long pfn;
 	int error;
+	int major = 0;
 
 	size = (i_size_read(inode) + PAGE_SIZE - 1) >> PAGE_SHIFT;
 	if (vmf->pgoff >= size)
@@ -301,6 +304,9 @@ static int do_dax_fault(struct vm_area_struct *vma, struct vm_fault *vmf,
 	if (!buffer_written(&bh) && !vmf->cow_page) {
 		if (vmf->flags & FAULT_FLAG_WRITE) {
 			error = get_block(inode, block, &bh, 1);
+			count_vm_event(PGMAJFAULT);
+			mem_cgroup_count_vm_event(vma->vm_mm, PGMAJFAULT);
+			major = VM_FAULT_MAJOR;
 			if (error || bh.b_size < PAGE_SIZE)
 				return VM_FAULT_SIGBUS;
 		} else {
@@ -332,7 +338,7 @@ static int do_dax_fault(struct vm_area_struct *vma, struct vm_fault *vmf,
 	/* -EBUSY is fine, somebody else faulted on the same PTE */
 	if (error != -EBUSY)
 		BUG_ON(error);
-	return VM_FAULT_NOPAGE;
+	return VM_FAULT_NOPAGE | major;
 }
 
 /**
-- 
1.8.5.3

