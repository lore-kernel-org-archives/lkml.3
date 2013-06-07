Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756810Ab3FGQ4V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 12:56:21 -0400
Received: from e06smtp17.uk.ibm.com ([195.75.94.113]:58703 "EHLO
	e06smtp17.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756478Ab3FGQ4H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 12:56:07 -0400
From: Michael Holzheu <holzheu@linux.vnet.ibm.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>,
        Jan Willeke <willeke@de.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        linux-kernel@vger.kernel.org, kexec@lists.infradead.org
Subject: [PATCH v5 3/5] vmcore: Introduce remap_oldmem_pfn_range()
Date: Fri,  7 Jun 2013 18:55:59 +0200
Message-Id: <1370624161-2298-4-git-send-email-holzheu@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.6
In-Reply-To: <1370624161-2298-1-git-send-email-holzheu@linux.vnet.ibm.com>
References: <1370624161-2298-1-git-send-email-holzheu@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13060716-0542-0000-0000-0000057AC7EC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For zfcpdump we can't map the HSA storage because it is only available
via a read interface. Therefore, for the new vmcore mmap feature we have
introduce a new mechanism to create mappings on demand.

This patch introduces a new architecture function remap_oldmem_pfn_range()
that should be used to create mappings with remap_pfn_range() for oldmem
areas that can be directly mapped. For zfcpdump this is everything besides
of the HSA memory. For the areas that are not mapped by remap_oldmem_pfn_range()
a generic vmcore a new generic vmcore fault handler mmap_vmcore_fault()
is called. This handler does the following:

* Check if /proc/vmcore page cache page is already available
* If yes:
  - Return that page
* If no:
  - Allocate new page
  - Fill page using __vmcore_read()
  - Add new page to page cache

Signed-off-by: Michael Holzheu <holzheu@linux.vnet.ibm.com>
---
 fs/proc/vmcore.c           | 94 ++++++++++++++++++++++++++++++++++++++++++----
 include/linux/crash_dump.h |  3 ++
 2 files changed, 89 insertions(+), 8 deletions(-)

diff --git a/fs/proc/vmcore.c b/fs/proc/vmcore.c
index 221f84b..259a639 100644
--- a/fs/proc/vmcore.c
+++ b/fs/proc/vmcore.c
@@ -21,6 +21,7 @@
 #include <linux/crash_dump.h>
 #include <linux/list.h>
 #include <linux/vmalloc.h>
+#include <linux/pagemap.h>
 #include <asm/uaccess.h>
 #include <asm/io.h>
 #include "internal.h"
@@ -153,11 +154,36 @@ ssize_t __weak elfcorehdr_read_notes(char *buf, size_t count, u64 *ppos)
 	return read_from_oldmem(buf, count, ppos, 0);
 }
 
+/*
+ * Architectures may override this function to map oldmem
+ */
+int __weak remap_oldmem_pfn_range(struct vm_area_struct *vma,
+				  unsigned long from, unsigned long pfn,
+				  unsigned long size, pgprot_t prot)
+{
+	return remap_pfn_range(vma, from, pfn, size, prot);
+}
+
+/*
+ * Copy to either kernel or user space
+ */
+static int copy_to(void *target, void *src, size_t size, int userbuf)
+{
+	if (userbuf) {
+		if (copy_to_user(target, src, size))
+			return -EFAULT;
+		return 0;
+	} else {
+		memcpy(target, src, size);
+		return 0;
+	}
+}
+
 /* Read from the ELF header and then the crash dump. On error, negative value is
  * returned otherwise number of bytes read are returned.
  */
-static ssize_t read_vmcore(struct file *file, char __user *buffer,
-				size_t buflen, loff_t *fpos)
+static ssize_t __read_vmcore(char *buffer, size_t buflen, loff_t *fpos,
+			     int userbuf)
 {
 	ssize_t acc = 0, tmp;
 	size_t tsz;
@@ -174,7 +200,7 @@ static ssize_t read_vmcore(struct file *file, char __user *buffer,
 	/* Read ELF core header */
 	if (*fpos < elfcorebuf_sz) {
 		tsz = min(elfcorebuf_sz - (size_t)*fpos, buflen);
-		if (copy_to_user(buffer, elfcorebuf + *fpos, tsz))
+		if (copy_to(buffer, elfcorebuf + *fpos, tsz, userbuf))
 			return -EFAULT;
 		buflen -= tsz;
 		*fpos += tsz;
@@ -192,7 +218,7 @@ static ssize_t read_vmcore(struct file *file, char __user *buffer,
 
 		tsz = min(elfcorebuf_sz + elfnotes_sz - (size_t)*fpos, buflen);
 		kaddr = elfnotes_buf + *fpos - elfcorebuf_sz;
-		if (copy_to_user(buffer, kaddr, tsz))
+		if (copy_to(buffer, kaddr, tsz, userbuf))
 			return -EFAULT;
 		buflen -= tsz;
 		*fpos += tsz;
@@ -208,7 +234,7 @@ static ssize_t read_vmcore(struct file *file, char __user *buffer,
 		if (*fpos < m->offset + m->size) {
 			tsz = min_t(size_t, m->offset + m->size - *fpos, buflen);
 			start = m->paddr + *fpos - m->offset;
-			tmp = read_from_oldmem(buffer, tsz, &start, 1);
+			tmp = read_from_oldmem(buffer, tsz, &start, userbuf);
 			if (tmp < 0)
 				return tmp;
 			buflen -= tsz;
@@ -225,6 +251,56 @@ static ssize_t read_vmcore(struct file *file, char __user *buffer,
 	return acc;
 }
 
+static ssize_t read_vmcore(struct file *file, char __user *buffer,
+			   size_t buflen, loff_t *fpos)
+{
+	return __read_vmcore(buffer, buflen, fpos, 1);
+}
+
+/*
+ * The vmcore fault handler uses the page cache and fills data using the
+ * standard __vmcore_read() function.
+ */
+static int mmap_vmcore_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
+{
+	struct address_space *mapping = vma->vm_private_data;
+	pgoff_t index = vmf->pgoff;
+	struct page *page;
+	loff_t src;
+	char *buf;
+	int rc;
+
+find_page:
+	page = find_lock_page(mapping, index);
+	if (page) {
+		unlock_page(page);
+		rc = VM_FAULT_MINOR;
+	} else {
+		page = page_cache_alloc_cold(mapping);
+		if (!page)
+			return VM_FAULT_OOM;
+		rc = add_to_page_cache_lru(page, mapping, index, GFP_KERNEL);
+		if (rc) {
+			page_cache_release(page);
+			if (rc == -EEXIST)
+				goto find_page;
+			/* Probably ENOMEM for radix tree node */
+			return VM_FAULT_OOM;
+		}
+		buf = (void *) (page_to_pfn(page) << PAGE_SHIFT);
+		src = index << PAGE_CACHE_SHIFT;
+		__read_vmcore(buf, PAGE_SIZE, &src, 0);
+		unlock_page(page);
+		rc = VM_FAULT_MAJOR;
+	}
+	vmf->page = page;
+	return rc;
+}
+
+static const struct vm_operations_struct vmcore_mmap_ops = {
+	.fault = mmap_vmcore_fault,
+};
+
 static int mmap_vmcore(struct file *file, struct vm_area_struct *vma)
 {
 	size_t size = vma->vm_end - vma->vm_start;
@@ -242,6 +318,8 @@ static int mmap_vmcore(struct file *file, struct vm_area_struct *vma)
 
 	vma->vm_flags &= ~(VM_MAYWRITE | VM_MAYEXEC);
 	vma->vm_flags |= VM_MIXEDMAP;
+	vma->vm_ops = &vmcore_mmap_ops;
+	vma->vm_private_data = file->f_mapping;
 
 	len = 0;
 
@@ -283,9 +361,9 @@ static int mmap_vmcore(struct file *file, struct vm_area_struct *vma)
 
 			tsz = min_t(size_t, m->offset + m->size - start, size);
 			paddr = m->paddr + start - m->offset;
-			if (remap_pfn_range(vma, vma->vm_start + len,
-					    paddr >> PAGE_SHIFT, tsz,
-					    vma->vm_page_prot))
+			if (remap_oldmem_pfn_range(vma, vma->vm_start + len,
+						   paddr >> PAGE_SHIFT, tsz,
+						   vma->vm_page_prot))
 				goto fail;
 			size -= tsz;
 			start += tsz;
diff --git a/include/linux/crash_dump.h b/include/linux/crash_dump.h
index dd0f434..c0818de 100644
--- a/include/linux/crash_dump.h
+++ b/include/linux/crash_dump.h
@@ -16,6 +16,9 @@ extern int __weak elfcorehdr_alloc(void);
 extern void __weak elfcorehdr_free(void);
 extern ssize_t __weak elfcorehdr_read(char *buf, size_t count, u64 *ppos);
 extern ssize_t __weak elfcorehdr_read_notes(char *buf, size_t count, u64 *ppos);
+extern int __weak remap_oldmem_pfn_range(struct vm_area_struct *vma,
+					 unsigned long from, unsigned long pfn,
+					 unsigned long size, pgprot_t prot);
 
 extern ssize_t copy_oldmem_page(unsigned long, char *, size_t,
 						unsigned long, int);
-- 
1.8.1.6

