Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757026AbaGQNK5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 09:10:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10875 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755175AbaGQNKz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 09:10:55 -0400
From: Vitaly Kuznetsov <vkuznets@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Michael Holzheu <holzheu@linux.vnet.ibm.com>,
        Vivek Goyal <vgoyal@redhat.com>,
        HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        David Vrabel <david.vrabel@citrix.com>,
        Andrew Jones <drjones@redhat.com>,
        Fengguang Wu <fengguang.wu@intel.com>, xen-devel@lists.xenproject.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v8] mmap_vmcore: skip non-ram pages reported by hypervisors
Date: Thu, 17 Jul 2014 15:10:31 +0200
Message-Id: <1405602631-9103-1-git-send-email-vkuznets@redhat.com>
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

Changes from v7:
- address kbuild test robot's warnings by making remap_oldmem_pfn_checked()
  and vmcore_remap_oldmem_pfn() static (Fengguang Wu's patch)

Changes from v6:
- remove useless len increment when remapping the rest of the region

Changes from v5:
- make len size_t to match do_unmap() interface

Changes from v4:
- change map_size type size_t -> unsigned long
- use prot instead of vma->vm_page_prot inside remap_oldmem_pfn_checked()

Changes from v3:
- multi line comment style changes
- minor code style changes

Changes from v2:
- make remap_oldmem_pfn_checked() interface exactly match
  remap_oldmem_pfn_range()
- unmap mapped part inside remap_oldmem_pfn_checked() in case of failure so
  we don't need to take care of it in mmap_vmcore()
- create vmcore_remap_oldmem_pfn() wrapper

Changes from v1:
- comment style changes
- change remap_oldmem_pfn_checked() interface to closer match the
  remap_oldmem_pfn() interface
- preserve formal parameters within the loop, make the loop conditions
  easier to understand
- use my_zero_pfn() for the zero page
- return remapped length instead of new offset

Reviewed-by: Andrew Jones <drjones@redhat.com>
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 fs/proc/vmcore.c | 82 +++++++++++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 79 insertions(+), 3 deletions(-)

diff --git a/fs/proc/vmcore.c b/fs/proc/vmcore.c
index 382aa89..a90d6d35 100644
--- a/fs/proc/vmcore.c
+++ b/fs/proc/vmcore.c
@@ -328,6 +328,82 @@ static inline char *alloc_elfnotes_buf(size_t notes_sz)
  * virtually contiguous user-space in ELF layout.
  */
 #ifdef CONFIG_MMU
+/*
+ * remap_oldmem_pfn_checked - do remap_oldmem_pfn_range replacing all pages
+ * reported as not being ram with the zero page.
+ *
+ * @vma: vm_area_struct describing requested mapping
+ * @from: start remapping from
+ * @pfn: page frame number to start remapping to
+ * @size: remapping size
+ * @prot: protection bits
+ *
+ * Returns zero on success, -EAGAIN on failure.
+ */
+static int remap_oldmem_pfn_checked(struct vm_area_struct *vma,
+				    unsigned long from, unsigned long pfn,
+				    unsigned long size, pgprot_t prot)
+{
+	unsigned long map_size;
+	unsigned long pos_start, pos_end, pos;
+	unsigned long zeropage_pfn = my_zero_pfn(0);
+	size_t len = 0;
+
+	pos_start = pfn;
+	pos_end = pfn + (size >> PAGE_SHIFT);
+
+	for (pos = pos_start; pos < pos_end; ++pos) {
+		if (!pfn_is_ram(pos)) {
+			/*
+			 * We hit a page which is not ram. Remap the continuous
+			 * region between pos_start and pos-1 and replace
+			 * the non-ram page at pos with the zero page.
+			 */
+			if (pos > pos_start) {
+				/* Remap continuous region */
+				map_size = (pos - pos_start) << PAGE_SHIFT;
+				if (remap_oldmem_pfn_range(vma, from + len,
+							   pos_start, map_size,
+							   prot))
+					goto fail;
+				len += map_size;
+			}
+			/* Remap the zero page */
+			if (remap_oldmem_pfn_range(vma, from + len,
+						   zeropage_pfn,
+						   PAGE_SIZE, prot))
+				goto fail;
+			len += PAGE_SIZE;
+			pos_start = pos + 1;
+		}
+	}
+	if (pos > pos_start) {
+		/* Remap the rest */
+		map_size = (pos - pos_start) << PAGE_SHIFT;
+		if (remap_oldmem_pfn_range(vma, from + len, pos_start,
+					   map_size, prot))
+			goto fail;
+	}
+	return 0;
+fail:
+	do_munmap(vma->vm_mm, from, len);
+	return -EAGAIN;
+}
+
+static int vmcore_remap_oldmem_pfn(struct vm_area_struct *vma,
+			    unsigned long from, unsigned long pfn,
+			    unsigned long size, pgprot_t prot)
+{
+	/*
+	 * Check if oldmem_pfn_is_ram was registered to avoid
+	 * looping over all pages without a reason.
+	 */
+	if (oldmem_pfn_is_ram)
+		return remap_oldmem_pfn_checked(vma, from, pfn, size, prot);
+	else
+		return remap_oldmem_pfn_range(vma, from, pfn, size, prot);
+}
+
 static int mmap_vmcore(struct file *file, struct vm_area_struct *vma)
 {
 	size_t size = vma->vm_end - vma->vm_start;
@@ -387,9 +463,9 @@ static int mmap_vmcore(struct file *file, struct vm_area_struct *vma)
 
 			tsz = min_t(size_t, m->offset + m->size - start, size);
 			paddr = m->paddr + start - m->offset;
-			if (remap_oldmem_pfn_range(vma, vma->vm_start + len,
-						   paddr >> PAGE_SHIFT, tsz,
-						   vma->vm_page_prot))
+			if (vmcore_remap_oldmem_pfn(vma, vma->vm_start + len,
+						    paddr >> PAGE_SHIFT, tsz,
+						    vma->vm_page_prot))
 				goto fail;
 			size -= tsz;
 			start += tsz;
-- 
1.9.3

