Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753261AbaBYOS5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 09:18:57 -0500
Received: from mga11.intel.com ([192.55.52.93]:16755 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752439AbaBYOSz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 09:18:55 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,540,1389772800"; 
   d="scan'208";a="487770279"
From: Matthew Wilcox <matthew.r.wilcox@intel.com>
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-fsdevel@vger.kernel.org, willy@linux.intel.com
Cc: Matthew Wilcox <matthew.r.wilcox@intel.com>
Subject: [PATCH v6 01/22] Fix XIP fault vs truncate race
Date: Tue, 25 Feb 2014 09:18:17 -0500
Message-Id: <1393337918-28265-2-git-send-email-matthew.r.wilcox@intel.com>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1393337918-28265-1-git-send-email-matthew.r.wilcox@intel.com>
References: <1393337918-28265-1-git-send-email-matthew.r.wilcox@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pagecache faults recheck i_size after taking the page lock to ensure that
the fault didn't race against a truncate.  We don't have a page to lock
in the XIP case, so use the i_mmap_mutex instead.  It is locked in the
truncate path in unmap_mapping_range() after updating i_size.  So while
we hold it in the fault path, we are guaranteed that either i_size has
already been updated in the truncate path, or that the truncate will
subsequently call zap_page_range_single() and so remove the mapping we
have just inserted.

There is a window of time in which i_size has been reduced and the
thread has a mapping to a page which will be removed from the file,
but this is harmless as the page will not be allocated to a different
purpose before the thread's access to it is revoked.

Signed-off-by: Matthew Wilcox <matthew.r.wilcox@intel.com>
---
 mm/filemap_xip.c | 24 ++++++++++++++++++++++--
 1 file changed, 22 insertions(+), 2 deletions(-)

diff --git a/mm/filemap_xip.c b/mm/filemap_xip.c
index d8d9fe3..c8d23e9 100644
--- a/mm/filemap_xip.c
+++ b/mm/filemap_xip.c
@@ -260,8 +260,17 @@ again:
 		__xip_unmap(mapping, vmf->pgoff);
 
 found:
+		/* We must recheck i_size under i_mmap_mutex */
+		mutex_lock(&mapping->i_mmap_mutex);
+		size = (i_size_read(inode) + PAGE_CACHE_SIZE - 1) >>
+							PAGE_CACHE_SHIFT;
+		if (unlikely(vmf->pgoff >= size)) {
+			mutex_unlock(&mapping->i_mmap_mutex);
+			return VM_FAULT_SIGBUS;
+		}
 		err = vm_insert_mixed(vma, (unsigned long)vmf->virtual_address,
 							xip_pfn);
+		mutex_unlock(&mapping->i_mmap_mutex);
 		if (err == -ENOMEM)
 			return VM_FAULT_OOM;
 		/*
@@ -285,16 +294,27 @@ found:
 		}
 		if (error != -ENODATA)
 			goto out;
+
+		/* We must recheck i_size under i_mmap_mutex */
+		mutex_lock(&mapping->i_mmap_mutex);
+		size = (i_size_read(inode) + PAGE_CACHE_SIZE - 1) >>
+							PAGE_CACHE_SHIFT;
+		if (unlikely(vmf->pgoff >= size)) {
+			ret = VM_FAULT_SIGBUS;
+			goto unlock;
+		}
 		/* not shared and writable, use xip_sparse_page() */
 		page = xip_sparse_page();
 		if (!page)
-			goto out;
+			goto unlock;
 		err = vm_insert_page(vma, (unsigned long)vmf->virtual_address,
 							page);
 		if (err == -ENOMEM)
-			goto out;
+			goto unlock;
 
 		ret = VM_FAULT_NOPAGE;
+unlock:
+		mutex_unlock(&mapping->i_mmap_mutex);
 out:
 		write_seqcount_end(&xip_sparse_seq);
 		mutex_unlock(&xip_sparse_mutex);
-- 
1.8.5.3

