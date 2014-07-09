Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756072AbaGILkk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 07:40:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32790 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755479AbaGILke (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 07:40:34 -0400
From: Vitaly Kuznetsov <vkuznets@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Michael Holzheu <holzheu@linux.vnet.ibm.com>,
        Vivek Goyal <vgoyal@redhat.com>,
        David Vrabel <david.vrabel@citrix.com>
Cc: Andrew Jones <drjones@redhat.com>, xen-devel@lists.xenproject.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2] mmap_vmcore: skip non-ram pages reported by hypervisors
Date: Wed,  9 Jul 2014 13:40:22 +0200
Message-Id: <1404906022-487-1-git-send-email-vkuznets@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We have a special check in read_vmcore() handler to check if the page was
reported as ram or not by the hypervisor (pfn_is_ram()). However, when
vmcore is read with mmap() no such check is performed. That can lead to
unpredictable results, e.g. when running Xen PVHVM guest memcpy() after
mmap() on /proc/vmcore will hang processing HVMMEM_mmio_dm pages creating
enormous load in both DomU and Dom0.

Fix the issue by mapping each non-ram page to the zero page. Keep direct
path with remap_oldmem_pfn_range() to avoid looping through all pages on
bare metal.

The issue can also be solved by overriding remap_oldmem_pfn_range() in
xen-specific code, as remap_oldmem_pfn_range() was been designed for.
That, however, would involve non-obvious xen code path for all x86 builds
with CONFIG_XEN_PVHVM=y and would prevent all other hypervisor-specific
code on x86 arch from doing the same override.

Changes from v1:
- comment style changes
- change remap_oldmem_pfn_checked() interface to closer match the
  remap_oldmem_pfn() interface
- preserve formal parameters within the loop, make the loop conditions
  easier to understand
- use my_zero_pfn() for the zero page
- return remapped length instead of new offset

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Reviewed-by: Andrew Jones <drjones@redhat.com>
---
 fs/proc/vmcore.c | 89 ++++++++++++++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 84 insertions(+), 5 deletions(-)

diff --git a/fs/proc/vmcore.c b/fs/proc/vmcore.c
index 382aa89..5cd13f8 100644
--- a/fs/proc/vmcore.c
+++ b/fs/proc/vmcore.c
@@ -328,6 +328,67 @@ static inline char *alloc_elfnotes_buf(size_t notes_sz)
  * virtually contiguous user-space in ELF layout.
  */
 #ifdef CONFIG_MMU
+/*
+ * remap_oldmem_pfn_checked - do remap_oldmem_pfn replacing all pages reported
+ * as not being ram with the zero page.
+ *
+ * @vma: vm_area_struct describing requested mapping
+ * @vma_addr: start remapping from
+ * @pfn: page frame number to start remapping to
+ * @size: remapping size
+ *
+ * Returns the remapped length. If no errors were hit during the remapping it
+ * should be equal to size.
+ */
+static u64 remap_oldmem_pfn_checked(struct vm_area_struct *vma,
+				    unsigned long vma_addr, unsigned long pfn,
+				    unsigned long size)
+{
+	size_t map_size;
+	unsigned long pos_start, pos_end, pos;
+	unsigned long zeropage_pfn = my_zero_pfn(0);
+	u64 len = 0;
+
+	pos_start = pfn;
+	pos_end = pfn + (size >> PAGE_SHIFT);
+
+	for (pos = pos_start; pos < pos_end; ++pos) {
+		if (!pfn_is_ram(pos)) {
+			/* We hit a page which is not ram. Remap the continuous
+			 * region between pos_start and pos-1 and replace
+			 * the non-ram page at pos with the zero page.
+			 */
+			if (pos > pos_start) {
+				/* Remap continuous region */
+				map_size = (pos - pos_start) << PAGE_SHIFT;
+				if (remap_oldmem_pfn_range(vma, vma_addr + len,
+							   pos_start, map_size,
+							   vma->vm_page_prot))
+					return len;
+				len += map_size;
+			}
+			/* Remap the zero page */
+			if (remap_oldmem_pfn_range(vma, vma_addr + len,
+						   zeropage_pfn,
+						   PAGE_SIZE,
+						   vma->vm_page_prot))
+				return len;
+			len += PAGE_SIZE;
+			pos_start = pos + 1;
+		}
+	}
+	if (pos > pos_start) {
+		/* Remap the rest */
+		map_size = (pos - pos_start) << PAGE_SHIFT;
+		if (remap_oldmem_pfn_range(vma, vma_addr + len, pos_start,
+					   map_size,
+					   vma->vm_page_prot))
+			return len;
+		len += map_size;
+	}
+	return len;
+}
+
 static int mmap_vmcore(struct file *file, struct vm_area_struct *vma)
 {
 	size_t size = vma->vm_end - vma->vm_start;
@@ -387,13 +448,31 @@ static int mmap_vmcore(struct file *file, struct vm_area_struct *vma)
 
 			tsz = min_t(size_t, m->offset + m->size - start, size);
 			paddr = m->paddr + start - m->offset;
-			if (remap_oldmem_pfn_range(vma, vma->vm_start + len,
-						   paddr >> PAGE_SHIFT, tsz,
-						   vma->vm_page_prot))
-				goto fail;
+
+			/* Check if oldmem_pfn_is_ram was registered to avoid
+			   looping over all pages without a reason. */
+			if (oldmem_pfn_is_ram) {
+				u64 original_len;
+				unsigned long pfn, vma_addr;
+
+				pfn = paddr >> PAGE_SHIFT;
+				vma_addr = vma->vm_start + len;
+				original_len = len;
+				len += remap_oldmem_pfn_checked(vma, vma_addr,
+								pfn, tsz);
+				if (len != original_len + tsz)
+					goto fail;
+			} else {
+				if (remap_oldmem_pfn_range(vma,
+							   vma->vm_start + len,
+							   paddr >> PAGE_SHIFT,
+							   tsz,
+							   vma->vm_page_prot))
+					goto fail;
+				len += tsz;
+			}
 			size -= tsz;
 			start += tsz;
-			len += tsz;
 
 			if (size == 0)
 				return 0;
-- 
1.9.3

