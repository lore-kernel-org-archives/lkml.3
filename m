Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932924Ab3EGE0H (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 00:26:07 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:25931 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759553Ab3EGEZw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 00:25:52 -0400
X-Authority-Analysis: v=2.0 cv=cOZiQyiN c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=uC5-5-8ARbIA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=DnD9a93tG1UA:10 a=Z4Rwk6OoAAAA:8 a=ag1SF4gXAAAA:8 a=Da1No7cPAAAA:8 a=0AWPF2qeU-xyIF9p1esA:9 a=6z04QOUsx9AA:10 a=jbrJJM5MRmoA:10 a=1TSTQ8KKaH4A:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130507035854.998045471@goodmis.org>
User-Agent: quilt/0.60-1
Date: Mon, 06 May 2013 23:58:36 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [084/126] vm: add vm_iomap_memory() helper function
References: <20130507035712.909872333@goodmis.org>
Content-Disposition: inline; filename=0084-vm-add-vm_iomap_memory-helper-function.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.3 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Linus Torvalds <torvalds@linux-foundation.org>

[ Upstream commit b4cbb197c7e7a68dbad0d491242e3ca67420c13e ]

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
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/mm.h |    2 ++
 mm/memory.c        |   47 +++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 49 insertions(+)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 311be90..a8a3df0 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1534,6 +1534,8 @@ int vm_insert_pfn(struct vm_area_struct *vma, unsigned long addr,
 			unsigned long pfn);
 int vm_insert_mixed(struct vm_area_struct *vma, unsigned long addr,
 			unsigned long pfn);
+int vm_iomap_memory(struct vm_area_struct *vma, phys_addr_t start, unsigned long len);
+
 
 struct page *follow_page(struct vm_area_struct *, unsigned long address,
 			unsigned int foll_flags);
diff --git a/mm/memory.c b/mm/memory.c
index 3a8b06b..06ff7fb 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -2342,6 +2342,53 @@ int remap_pfn_range(struct vm_area_struct *vma, unsigned long addr,
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
1.7.10.4


