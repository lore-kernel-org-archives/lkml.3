Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756958Ab3EJOkr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 10:40:47 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:57085 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754774Ab3EJOUy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 10:20:54 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org,
        "Linus Torvalds" <torvalds@linux-foundation.org>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
Date: Fri, 10 May 2013 14:39:41 +0100
Message-ID: <lsq.1368193181.450891056@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [081/118] vm: add vm_iomap_memory() helper function
In-Reply-To: <lsq.1368193179.973009354@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:d51a:8785:aa0a:cebe
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.45-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 include/linux/mm.h |    2 ++
 mm/memory.c        |   47 +++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 49 insertions(+)

--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1509,6 +1509,8 @@ int vm_insert_pfn(struct vm_area_struct
 			unsigned long pfn);
 int vm_insert_mixed(struct vm_area_struct *vma, unsigned long addr,
 			unsigned long pfn);
+int vm_iomap_memory(struct vm_area_struct *vma, phys_addr_t start, unsigned long len);
+
 
 struct page *follow_page(struct vm_area_struct *, unsigned long address,
 			unsigned int foll_flags);
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -2309,6 +2309,53 @@ int remap_pfn_range(struct vm_area_struc
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

