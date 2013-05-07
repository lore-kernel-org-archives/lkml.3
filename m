Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932428Ab3EGNkl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 09:40:41 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42083 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932201Ab3EGNkg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 09:40:36 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 015/118] vm: add vm_iomap_memory() helper function
Date: Tue,  7 May 2013 14:37:41 +0100
Message-Id: <1367933964-1564-16-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1367933964-1564-1-git-send-email-luis.henriques@canonical.com>
References: <1367933964-1564-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.12 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Linus Torvalds <torvalds@linux-foundation.org>

commit b4cbb197c7e7a68dbad0d491242e3ca67420c13e upstream.

Various drivers end up replicating the code to mmap() their memory
buffers into user space, and our core memory remapping function may be
very flexible but it is unnecessarily complicated for the common cases
to use.

Our internal VM uses pfn's ("page frame numbers") which simplifies
things for the VM, and allows us to pass physical addresses around in a
denser and more efficient format than passing a "phys_addr_t" around,
and having to shift it up and down by the page size.  But it just means
that drivers end up doing that shifting instead at the interface level.

It also means that drivers end up mucking around with internal VM things
like the vma details (vm_pgoff, vm_start/end) way more than they really
need to.

So this just exports a function to map a certain physical memory range
into user space (using a phys_addr_t based interface that is much more
natural for a driver) and hides all the complexity from the driver.
Some drivers will still end up tweaking the vm_page_prot details for
things like prefetching or cacheability etc, but that's actually
relevant to the driver, rather than caring about what the page offset of
the mapping is into the particular IO memory region.

Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 include/linux/mm.h |  2 ++
 mm/memory.c        | 47 +++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 49 insertions(+)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index f9f279c..920beba 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1503,6 +1503,8 @@ int vm_insert_pfn(struct vm_area_struct *vma, unsigned long addr,
 			unsigned long pfn);
 int vm_insert_mixed(struct vm_area_struct *vma, unsigned long addr,
 			unsigned long pfn);
+int vm_iomap_memory(struct vm_area_struct *vma, phys_addr_t start, unsigned long len);
+
 
 struct page *follow_page(struct vm_area_struct *, unsigned long address,
 			unsigned int foll_flags);
diff --git a/mm/memory.c b/mm/memory.c
index b1014bf..05414ef 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -2334,6 +2334,53 @@ int remap_pfn_range(struct vm_area_struct *vma, unsigned long addr,
 }
 EXPORT_SYMBOL(remap_pfn_range);
 
+/**
+ * vm_iomap_memory - remap memory to userspace
+ * @vma: user vma to map to
+ * @start: start of area
+ * @len: size of area
+ *
+ * This is a simplified io_remap_pfn_range() for common driver use. The
+ * driver just needs to give us the physical memory range to be mapped,
+ * we'll figure out the rest from the vma information.
+ *
+ * NOTE! Some drivers might want to tweak vma->vm_page_prot first to get
+ * whatever write-combining details or similar.
+ */
+int vm_iomap_memory(struct vm_area_struct *vma, phys_addr_t start, unsigned long len)
+{
+	unsigned long vm_len, pfn, pages;
+
+	/* Check that the physical memory area passed in looks valid */
+	if (start + len < start)
+		return -EINVAL;
+	/*
+	 * You *really* shouldn't map things that aren't page-aligned,
+	 * but we've historically allowed it because IO memory might
+	 * just have smaller alignment.
+	 */
+	len += start & ~PAGE_MASK;
+	pfn = start >> PAGE_SHIFT;
+	pages = (len + ~PAGE_MASK) >> PAGE_SHIFT;
+	if (pfn + pages < pfn)
+		return -EINVAL;
+
+	/* We start the mapping 'vm_pgoff' pages into the area */
+	if (vma->vm_pgoff > pages)
+		return -EINVAL;
+	pfn += vma->vm_pgoff;
+	pages -= vma->vm_pgoff;
+
+	/* Can we fit all of the mapping? */
+	vm_len = vma->vm_end - vma->vm_start;
+	if (vm_len >> PAGE_SHIFT > pages)
+		return -EINVAL;
+
+	/* Ok, let it rip */
+	return io_remap_pfn_range(vma, vma->vm_start, pfn, vm_len, vma->vm_page_prot);
+}
+EXPORT_SYMBOL(vm_iomap_memory);
+
 static int apply_to_pte_range(struct mm_struct *mm, pmd_t *pmd,
 				     unsigned long addr, unsigned long end,
 				     pte_fn_t fn, void *data)
-- 
1.8.1.2

