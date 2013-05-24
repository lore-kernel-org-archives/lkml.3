Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755929Ab3EXNIT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 May 2013 09:08:19 -0400
Received: from e06smtp16.uk.ibm.com ([195.75.94.112]:58071 "EHLO
	e06smtp16.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754780Ab3EXNIO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 May 2013 09:08:14 -0400
From: Michael Holzheu <holzheu@linux.vnet.ibm.com>
To: Vivek Goyal <vgoyal@redhat.com>,
        HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
Cc: Jan Willeke <willeke@de.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        linux-kernel@vger.kernel.org, kexec@lists.infradead.org
Subject: [PATCH 1/2] kdump/mmap: Introduce arch_oldmem_remap_pfn_range()
Date: Fri, 24 May 2013 15:08:08 +0200
Message-Id: <1369400889-11064-2-git-send-email-holzheu@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.6
In-Reply-To: <1369400889-11064-1-git-send-email-holzheu@linux.vnet.ibm.com>
References: <1369400889-11064-1-git-send-email-holzheu@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13052413-3548-0000-0000-0000057CA388
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan Willeke <willeke@de.ibm.com>

Currently the /proc/vmcore mmap patches are not working on s390. The
problem is that on s390 the kernel in not relocatable and therefore
always runs in the lower memory area. Therefore for kdump on s390 we
swap the lower memory area with the crashkernel area before starting
the kdump kernel:

[0 - OLDMEM_SIZE] is mapped to [OLDMEM_BASE - OLDMEM_BASE + OLDMEM_SIZE]

To fix /proc/vmcore mmap memory below OLDMEMSIZE needs to be mapped
with OLDMEM_BASE as offset. To achieve that, a new weak function
arch_oldmem_remap_pfn_range() is introduced.

Signed-off-by: Jan Willeke <willeke@de.ibm.com>
Signed-off-by: Michael Holzheu <holzheu@linux.vnet.ibm.com>
---
 fs/proc/vmcore.c           | 15 ++++++++++++++-
 include/linux/crash_dump.h |  5 +++++
 2 files changed, 19 insertions(+), 1 deletion(-)

diff --git a/fs/proc/vmcore.c b/fs/proc/vmcore.c
index 80221d7..3eda0ac 100644
--- a/fs/proc/vmcore.c
+++ b/fs/proc/vmcore.c
@@ -123,6 +123,19 @@ static ssize_t read_from_oldmem(char *buf, size_t count,
 	return read;
 }
 
+/*
+ * Architetures may override this function to map oldmen
+ */
+int __weak arch_oldmem_remap_pfn_range(struct vm_area_struct *vma,
+				       unsigned long from,
+				       unsigned long pfn,
+				       unsigned long size,
+				       pgprot_t prot)
+{
+	return remap_pfn_range(vma, from, pfn, size, prot);
+}
+
+
 /* Read from the ELF header and then the crash dump. On error, negative value is
  * returned otherwise number of bytes read are returned.
  */
@@ -267,7 +280,7 @@ static int mmap_vmcore(struct file *file, struct vm_area_struct *vma)
 			if (size < tsz)
 				tsz = size;
 			paddr = m->paddr + start - m->offset;
-			if (remap_pfn_range(vma, vma->vm_start + len,
+			if (arch_oldmem_remap_pfn_range(vma, vma->vm_start + len,
 					    paddr >> PAGE_SHIFT, tsz,
 					    vma->vm_page_prot)) {
 				do_munmap(vma->vm_mm, vma->vm_start, len);
diff --git a/include/linux/crash_dump.h b/include/linux/crash_dump.h
index 37e4f8d..da300a7 100644
--- a/include/linux/crash_dump.h
+++ b/include/linux/crash_dump.h
@@ -14,6 +14,11 @@ extern unsigned long long elfcorehdr_size;
 
 extern ssize_t copy_oldmem_page(unsigned long, char *, size_t,
 						unsigned long, int);
+extern int __weak arch_oldmem_remap_pfn_range(struct vm_area_struct *vma,
+					      unsigned long from,
+					      unsigned long pfn,
+					      unsigned long size,
+					      pgprot_t prot);
 
 /* Architecture code defines this if there are other possible ELF
  * machine types, e.g. on bi-arch capable hardware. */
-- 
1.8.1.6

