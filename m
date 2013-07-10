Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753486Ab3GJInI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 04:43:08 -0400
Received: from e06smtp18.uk.ibm.com ([195.75.94.114]:36202 "EHLO
	e06smtp18.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750894Ab3GJInB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 04:43:01 -0400
Date: Wed, 10 Jul 2013 10:42:52 +0200
From: Michael Holzheu <holzheu@linux.vnet.ibm.com>
To: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
Cc: Vivek Goyal <vgoyal@redhat.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>, kexec@lists.infradead.org,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Jan Willeke <willeke@de.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6 3/5] vmcore: Introduce remap_oldmem_pfn_range()
Message-ID: <20130710104252.479a0f92@holzheu>
In-Reply-To: <51DBA47C.8090708@jp.fujitsu.com>
References: <1372707159-10425-1-git-send-email-holzheu@linux.vnet.ibm.com>
	<1372707159-10425-4-git-send-email-holzheu@linux.vnet.ibm.com>
	<51DA4ED9.60903@jp.fujitsu.com>
	<20130708112839.498ccfc6@holzheu>
	<20130708142826.GA9094@redhat.com>
	<51DBA47C.8090708@jp.fujitsu.com>
Organization: IBM
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13071008-6892-0000-0000-000005A48FDE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Hatayama,

On Tue, 09 Jul 2013 14:49:48 +0900
HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com> wrote:

> (2013/07/08 23:28), Vivek Goyal wrote:
> > On Mon, Jul 08, 2013 at 11:28:39AM +0200, Michael Holzheu wrote:
> >> On Mon, 08 Jul 2013 14:32:09 +0900
> >> HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com> wrote:

[snip]

> > I personally perfer not to special case it for s390 only and let the
> > handler be generic.
> >
> > If there is a bug in remap_old_pfn_range(), only side affect is that
> > we will fault in the page when it is accessed and that will be slow. BUG()
> > sounds excessive. At max it could be WARN_ONCE().
> >
> > In regular cases for x86, this path should not even hit. So special casing
> > it to detect issues with remap_old_pfn_range() does not sound very good
> > to me. I would rather leave it as it is and if there are bugs and mmap()
> > slows down, then somebody needs to debug it.
> >
> 
> I agree to WARN_ONCE(). Then, we can notice bug at least if it occurs.
> 
> Interface is like this?
> 
> [generic]
> 
> bool __weak in_valid_fault_range(pgoff_t pgoff)
> {
>      return false;
> }
> 
> [s390]
> 
> bool in_valid_fault_range(pgoff_t pgoff)
> {
>      loff_t offset = pgoff << PAGE_CACHE_SHIFT;
>      u64 paddr = vmcore_offset_to_paddr(offset);
> 
>      return paddr < ZFCPDUMP_HSA_SIZE;
> }
> 
> assuming vmcore_offset_to_paddr() that looks up vmcore_list and returns physical
> address corresponding to given offset of vmcore. I guess this could return error
> value if there's no entry corresponding to given offset in vmcore_list.

I think this is too much code (and overhead) just for checking the correctness the
kdump mmap implementation.

My suggestion is to add the WARN_ONCE() for #ifndef CONFIG_S390. This has the same
effect as your suggestion for all architectures besides of s390. And for s390 we
take the risk that a programming error would result in poor /proc/vmcore
performance.

So, at least for this patch series I would implement the fault handler as follows:

static int mmap_vmcore_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
{
...
        char *buf;
        int rc;

#ifndef CONFIG_S390
        WARN_ONCE(1, "vmcore: Unexpected call of mmap_vmcore_fault()");
#endif
        page = find_or_create_page(mapping, index, GFP_KERNEL);

At this point I have to tell you that we plan another vmcore patch series where
the fault handler might be called also for other architectures. But I think we
should *then* discuss your issue again.

So in order to make progress with this patch series (which is also needed to
make your mmap patches work for s390) I would suggest to use the following patch:
---
 fs/proc/vmcore.c           |   90 +++++++++++++++++++++++++++++++++++++++++----
 include/linux/crash_dump.h |    3 +
 2 files changed, 85 insertions(+), 8 deletions(-)

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
@@ -153,11 +154,35 @@ ssize_t __weak elfcorehdr_read_notes(cha
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
@@ -174,7 +199,7 @@ static ssize_t read_vmcore(struct file *
 	/* Read ELF core header */
 	if (*fpos < elfcorebuf_sz) {
 		tsz = min(elfcorebuf_sz - (size_t)*fpos, buflen);
-		if (copy_to_user(buffer, elfcorebuf + *fpos, tsz))
+		if (copy_to(buffer, elfcorebuf + *fpos, tsz, userbuf))
 			return -EFAULT;
 		buflen -= tsz;
 		*fpos += tsz;
@@ -192,7 +217,7 @@ static ssize_t read_vmcore(struct file *
 
 		tsz = min(elfcorebuf_sz + elfnotes_sz - (size_t)*fpos, buflen);
 		kaddr = elfnotes_buf + *fpos - elfcorebuf_sz;
-		if (copy_to_user(buffer, kaddr, tsz))
+		if (copy_to(buffer, kaddr, tsz, userbuf))
 			return -EFAULT;
 		buflen -= tsz;
 		*fpos += tsz;
@@ -208,7 +233,7 @@ static ssize_t read_vmcore(struct file *
 		if (*fpos < m->offset + m->size) {
 			tsz = min_t(size_t, m->offset + m->size - *fpos, buflen);
 			start = m->paddr + *fpos - m->offset;
-			tmp = read_from_oldmem(buffer, tsz, &start, 1);
+			tmp = read_from_oldmem(buffer, tsz, &start, userbuf);
 			if (tmp < 0)
 				return tmp;
 			buflen -= tsz;
@@ -225,6 +250,54 @@ static ssize_t read_vmcore(struct file *
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
+ *
+ * On s390 the fault handler is used for memory regions that can't be mapped
+ * directly with remap_pfn_range().
+ */
+static int mmap_vmcore_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
+{
+	struct address_space *mapping = vma->vm_file->f_mapping;
+	pgoff_t index = vmf->pgoff;
+	struct page *page;
+	loff_t offset;
+	char *buf;
+	int rc;
+
+#ifndef CONFIG_S390
+	WARN_ONCE(1, "vmcore: Unexpected call of mmap_vmcore_fault()");
+#endif
+	page = find_or_create_page(mapping, index, GFP_KERNEL);
+	if (!page)
+		return VM_FAULT_OOM;
+	if (!PageUptodate(page)) {
+		offset = (loff_t) index << PAGE_CACHE_SHIFT;
+		buf = __va((page_to_pfn(page) << PAGE_SHIFT));
+		rc = __read_vmcore(buf, PAGE_SIZE, &offset, 0);
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
@@ -242,6 +315,7 @@ static int mmap_vmcore(struct file *file
 
 	vma->vm_flags &= ~(VM_MAYWRITE | VM_MAYEXEC);
 	vma->vm_flags |= VM_MIXEDMAP;
+	vma->vm_ops = &vmcore_mmap_ops;
 
 	len = 0;
 
@@ -283,9 +357,9 @@ static int mmap_vmcore(struct file *file
 
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
--- a/include/linux/crash_dump.h
+++ b/include/linux/crash_dump.h
@@ -17,6 +17,9 @@ extern int __weak elfcorehdr_alloc(unsig
 extern void __weak elfcorehdr_free(unsigned long long addr);
 extern ssize_t __weak elfcorehdr_read(char *buf, size_t count, u64 *ppos);
 extern ssize_t __weak elfcorehdr_read_notes(char *buf, size_t count, u64 *ppos);
+extern int __weak remap_oldmem_pfn_range(struct vm_area_struct *vma,
+					 unsigned long from, unsigned long pfn,
+					 unsigned long size, pgprot_t prot);
 
 extern ssize_t copy_oldmem_page(unsigned long, char *, size_t,

