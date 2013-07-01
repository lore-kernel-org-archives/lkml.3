Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755205Ab3GATeE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 15:34:04 -0400
Received: from e06smtp13.uk.ibm.com ([195.75.94.109]:47215 "EHLO
	e06smtp13.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753365Ab3GATcp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 15:32:45 -0400
From: Michael Holzheu <holzheu@linux.vnet.ibm.com>
To: Vivek Goyal <vgoyal@redhat.com>,
        HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
Cc: Jan Willeke <willeke@de.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        linux-kernel@vger.kernel.org, kexec@lists.infradead.org
Subject: [PATCH v6 3/5] vmcore: Introduce remap_oldmem_pfn_range()
Date: Mon,  1 Jul 2013 21:32:37 +0200
Message-Id: <1372707159-10425-4-git-send-email-holzheu@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.2.2
In-Reply-To: <1372707159-10425-1-git-send-email-holzheu@linux.vnet.ibm.com>
References: <1372707159-10425-1-git-send-email-holzheu@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13070119-2966-0000-0000-00000805FE13
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
is called.

This handler works as follows:

* Get already available or new page from page cache (find_or_create_page)
* Check if /proc/vmcore page is filled with data (PageUptodate)
* If yes:
  Return that page
* If no:
  Fill page using __vmcore_read(), set PageUptodate, and return page

Signed-off-by: Michael Holzheu <holzheu@linux.vnet.ibm.com>
---
 fs/proc/vmcore.c           | 84 +++++++++++++++++++++++++++++++++++++++++-----
 include/linux/crash_dump.h |  3 ++
 2 files changed, 79 insertions(+), 8 deletions(-)

diff --git a/fs/proc/vmcore.c b/fs/proc/vmcore.c
index c28189c..77312c7 100644
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
@@ -153,11 +154,35 @@ ssize_t __weak elfcorehdr_read_notes(char *buf, size_t count, u64 *ppos)
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
+	} else {
+		memcpy(target, src, size);
+	}
+	return 0;
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
@@ -174,7 +199,7 @@ static ssize_t read_vmcore(struct file *file, char __user *buffer,
 	/* Read ELF core header */
 	if (*fpos < elfcorebuf_sz) {
 		tsz = min(elfcorebuf_sz - (size_t)*fpos, buflen);
-		if (copy_to_user(buffer, elfcorebuf + *fpos, tsz))
+		if (copy_to(buffer, elfcorebuf + *fpos, tsz, userbuf))
 			return -EFAULT;
 		buflen -= tsz;
 		*fpos += tsz;
@@ -192,7 +217,7 @@ static ssize_t read_vmcore(struct file *file, char __user *buffer,
 
 		tsz = min(elfcorebuf_sz + elfnotes_sz - (size_t)*fpos, buflen);
 		kaddr = elfnotes_buf + *fpos - elfcorebuf_sz;
-		if (copy_to_user(buffer, kaddr, tsz))
+		if (copy_to(buffer, kaddr, tsz, userbuf))
 			return -EFAULT;
 		buflen -= tsz;
 		*fpos += tsz;
@@ -208,7 +233,7 @@ static ssize_t read_vmcore(struct file *file, char __user *buffer,
 		if (*fpos < m->offset + m->size) {
 			tsz = min_t(size_t, m->offset + m->size - *fpos, buflen);
 			start = m->paddr + *fpos - m->offset;
-			tmp = read_from_oldmem(buffer, tsz, &start, 1);
+			tmp = read_from_oldmem(buffer, tsz, &start, userbuf);
 			if (tmp < 0)
 				return tmp;
 			buflen -= tsz;
@@ -225,6 +250,48 @@ static ssize_t read_vmcore(struct file *file, char __user *buffer,
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
+	struct address_space *mapping = vma->vm_file->f_mapping;
+	pgoff_t index = vmf->pgoff;
+	struct page *page;
+	loff_t src;
+	char *buf;
+	int rc;
+
+	page = find_or_create_page(mapping, index, GFP_KERNEL);
+	if (!page)
+		return VM_FAULT_OOM;
+	if (!PageUptodate(page)) {
+		src = index << PAGE_CACHE_SHIFT;
+		buf = (void *) (page_to_pfn(page) << PAGE_SHIFT);
+		rc = __read_vmcore(buf, PAGE_SIZE, &src, 0);
+		if (rc < 0) {
+			unlock_page(page);
+			page_cache_release(page);
+			return (rc == -ENOMEM) ? VM_FAULT_OOM : VM_FAULT_SIGBUS;
+		}
+		SetPageUptodate(page);
+	}
+	unlock_page(page);
+	vmf->page = page;
+	return 0;
+}
+
+static const struct vm_operations_struct vmcore_mmap_ops = {
+	.fault = mmap_vmcore_fault,
+};
+
 static int mmap_vmcore(struct file *file, struct vm_area_struct *vma)
 {
 	size_t size = vma->vm_end - vma->vm_start;
@@ -242,6 +309,7 @@ static int mmap_vmcore(struct file *file, struct vm_area_struct *vma)
 
 	vma->vm_flags &= ~(VM_MAYWRITE | VM_MAYEXEC);
 	vma->vm_flags |= VM_MIXEDMAP;
+	vma->vm_ops = &vmcore_mmap_ops;
 
 	len = 0;
 
@@ -283,9 +351,9 @@ static int mmap_vmcore(struct file *file, struct vm_area_struct *vma)
 
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
index 6571f82..fe68a5a 100644
--- a/include/linux/crash_dump.h
+++ b/include/linux/crash_dump.h
@@ -17,6 +17,9 @@ extern int __weak elfcorehdr_alloc(unsigned long long *addr,
 extern void __weak elfcorehdr_free(unsigned long long addr);
 extern ssize_t __weak elfcorehdr_read(char *buf, size_t count, u64 *ppos);
 extern ssize_t __weak elfcorehdr_read_notes(char *buf, size_t count, u64 *ppos);
+extern int __weak remap_oldmem_pfn_range(struct vm_area_struct *vma,
+					 unsigned long from, unsigned long pfn,
+					 unsigned long size, pgprot_t prot);
 
 extern ssize_t copy_oldmem_page(unsigned long, char *, size_t,
 						unsigned long, int);
-- 
1.8.2.2

