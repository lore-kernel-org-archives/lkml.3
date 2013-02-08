Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1947088Ab3BHU3A (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 15:29:00 -0500
Received: from e37.co.us.ibm.com ([32.97.110.158]:50375 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946949Ab3BHU26 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 15:28:58 -0500
Subject: [PATCH 2/2] make /dev/kmem return error for highmem
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org, bp@alien8.de, hpa@zytor.com, mingo@kernel.org,
        tglx@linutronix.de, Dave Hansen <dave@linux.vnet.ibm.com>
From: Dave Hansen <dave@linux.vnet.ibm.com>
Date: Fri, 08 Feb 2013 12:28:14 -0800
References: <20130208202813.62965F25@kernel.stglabs.ibm.com>
In-Reply-To: <20130208202813.62965F25@kernel.stglabs.ibm.com>
Message-Id: <20130208202814.E1196596@kernel.stglabs.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13020820-7408-0000-0000-00000CA395A8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I was auding the /dev/mem code for more questionable uses of
__pa(), and ran across this.

My assumption is that if you use /dev/kmem, you expect to be
able to read the kernel virtual mappings.  However, those
mappings _stop_ as soon as we hit high memory.  The
pfn_valid() check in here is good for memory holes, but since
highmem pages are still valid, it does no good for those.

Also, since we are now checking that __pa() is being done on
valid virtual addresses, this might have tripped the new
check.  Even with the new check, this code would have been
broken with the NUMA remapping code had we not ripped it
out:

	https://patchwork.kernel.org/patch/2075911/

Signed-off-by: Dave Hansen <dave@linux.vnet.ibm.com>
---

 linux-2.6.git-dave/drivers/char/mem.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff -puN drivers/char/mem.c~make-kmem-return-error-for-highmem drivers/char/mem.c
--- linux-2.6.git/drivers/char/mem.c~make-kmem-return-error-for-highmem	2013-02-08 12:27:57.033770045 -0800
+++ linux-2.6.git-dave/drivers/char/mem.c	2013-02-08 12:27:57.041770125 -0800
@@ -337,10 +337,19 @@ static int mmap_mem(struct file *file, s
 #ifdef CONFIG_DEVKMEM
 static int mmap_kmem(struct file *file, struct vm_area_struct *vma)
 {
+	unsigned long kernel_vaddr;
 	unsigned long pfn;
 
+	kernel_vaddr = (u64)vma->vm_pgoff << PAGE_SHIFT;
+	/*
+	 * pfn_valid() (below) does not trip for highmem addresses.  This
+	 * essentially means that we will be mapping gibberish in for them
+	 * instead of what the _kernel_ has mapped at the requested address.
+	 */
+	if (kernel_vaddr >= high_memory)
+		return -EIO;
 	/* Turn a kernel-virtual address into a physical page frame */
-	pfn = __pa((u64)vma->vm_pgoff << PAGE_SHIFT) >> PAGE_SHIFT;
+	pfn = __pa(kernel_vaddr) >> PAGE_SHIFT;
 
 	/*
 	 * RED-PEN: on some architectures there is more mapped memory than
diff -puN mm/nommu.c~make-kmem-return-error-for-highmem mm/nommu.c
_

