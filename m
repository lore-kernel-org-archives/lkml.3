Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758375Ab3EOJGf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 05:06:35 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:58435 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758310Ab3EOJG2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 05:06:28 -0400
From: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
Subject: [PATCH v6 8/8] vmcore: support mmap() on /proc/vmcore
To: vgoyal@redhat.com, ebiederm@xmission.com, akpm@linux-foundation.org
Cc: cpw@sgi.com, kumagai-atsushi@mxc.nes.nec.co.jp, lisa.mitchell@hp.com,
        kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
        zhangyanfei@cn.fujitsu.com, jingbai.ma@hp.com, linux-mm@kvack.org,
        riel@redhat.com, walken@google.com, hughd@google.com,
        kosaki.motohiro@jp.fujitsu.com
Date: Wed, 15 May 2013 18:06:26 +0900
Message-ID: <20130515090626.28109.95938.stgit@localhost6.localdomain6>
In-Reply-To: <20130515090507.28109.28956.stgit@localhost6.localdomain6>
References: <20130515090507.28109.28956.stgit@localhost6.localdomain6>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch introduces mmap_vmcore().

Don't permit writable nor executable mapping even with mprotect()
because this mmap() is aimed at reading crash dump memory.
Non-writable mapping is also requirement of remap_pfn_range() when
mapping linear pages on non-consecutive physical pages; see
is_cow_mapping().

Set VM_MIXEDMAP flag to remap memory by remap_pfn_range and by
remap_vmalloc_range_pertial at the same time for a single
vma. do_munmap() can correctly clean partially remapped vma with two
functions in abnormal case. See zap_pte_range(), vm_normal_page() and
their comments for details.

On x86-32 PAE kernels, mmap() supports at most 16TB memory only. This
limitation comes from the fact that the third argument of
remap_pfn_range(), pfn, is of 32-bit length on x86-32: unsigned long.

Signed-off-by: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
---

 fs/proc/vmcore.c |   86 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 86 insertions(+), 0 deletions(-)

diff --git a/fs/proc/vmcore.c b/fs/proc/vmcore.c
index 7f2041c..2c72487 100644
--- a/fs/proc/vmcore.c
+++ b/fs/proc/vmcore.c
@@ -20,6 +20,7 @@
 #include <linux/init.h>
 #include <linux/crash_dump.h>
 #include <linux/list.h>
+#include <linux/vmalloc.h>
 #include <asm/uaccess.h>
 #include <asm/io.h>
 #include "internal.h"
@@ -200,9 +201,94 @@ static ssize_t read_vmcore(struct file *file, char __user *buffer,
 	return acc;
 }
 
+static int mmap_vmcore(struct file *file, struct vm_area_struct *vma)
+{
+	size_t size = vma->vm_end - vma->vm_start;
+	u64 start, end, len, tsz;
+	struct vmcore *m;
+
+	start = (u64)vma->vm_pgoff << PAGE_SHIFT;
+	end = start + size;
+
+	if (size > vmcore_size || end > vmcore_size)
+		return -EINVAL;
+
+	if (vma->vm_flags & (VM_WRITE | VM_EXEC))
+		return -EPERM;
+
+	vma->vm_flags &= ~(VM_MAYWRITE | VM_MAYEXEC);
+	vma->vm_flags |= VM_MIXEDMAP;
+
+	len = 0;
+
+	if (start < elfcorebuf_sz) {
+		u64 pfn;
+
+		tsz = elfcorebuf_sz - start;
+		if (size < tsz)
+			tsz = size;
+		pfn = __pa(elfcorebuf + start) >> PAGE_SHIFT;
+		if (remap_pfn_range(vma, vma->vm_start, pfn, tsz,
+				    vma->vm_page_prot))
+			return -EAGAIN;
+		size -= tsz;
+		start += tsz;
+		len += tsz;
+
+		if (size == 0)
+			return 0;
+	}
+
+	if (start < elfcorebuf_sz + elfnotes_sz) {
+		void *kaddr;
+
+		tsz = elfcorebuf_sz + elfnotes_sz - start;
+		if (size < tsz)
+			tsz = size;
+		kaddr = elfnotes_buf + start - elfcorebuf_sz;
+		if (remap_vmalloc_range_partial(vma, vma->vm_start + len,
+						kaddr, tsz)) {
+			do_munmap(vma->vm_mm, vma->vm_start, len);
+			return -EAGAIN;
+		}
+		size -= tsz;
+		start += tsz;
+		len += tsz;
+
+		if (size == 0)
+			return 0;
+	}
+
+	list_for_each_entry(m, &vmcore_list, list) {
+		if (start < m->offset + m->size) {
+			u64 paddr = 0;
+
+			tsz = m->offset + m->size - start;
+			if (size < tsz)
+				tsz = size;
+			paddr = m->paddr + start - m->offset;
+			if (remap_pfn_range(vma, vma->vm_start + len,
+					    paddr >> PAGE_SHIFT, tsz,
+					    vma->vm_page_prot)) {
+				do_munmap(vma->vm_mm, vma->vm_start, len);
+				return -EAGAIN;
+			}
+			size -= tsz;
+			start += tsz;
+			len += tsz;
+
+			if (size == 0)
+				return 0;
+		}
+	}
+
+	return 0;
+}
+
 static const struct file_operations proc_vmcore_operations = {
 	.read		= read_vmcore,
 	.llseek		= default_llseek,
+	.mmap		= mmap_vmcore,
 };
 
 static struct vmcore* __init get_new_element(void)

