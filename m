Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937049Ab3DJXhx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 19:37:53 -0400
Received: from mga02.intel.com ([134.134.136.20]:23452 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936966Ab3DJXhu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 19:37:50 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,450,1363158000"; 
   d="scan'208";a="316276289"
Subject: [PATCH 2/5] make /dev/kmem return error for highmem
To: bp@alien8.de
Cc: hpa@linux.intel.com, linux-kernel@vger.kernel.org, x86@kernel.org,
        Dave Hansen <dave@sr71.net>
From: Dave Hansen <dave@sr71.net>
Date: Wed, 10 Apr 2013 16:32:52 -0700
References: <20130410233249.7FFCB63B@viggo.jf.intel.com>
In-Reply-To: <20130410233249.7FFCB63B@viggo.jf.intel.com>
Message-Id: <20130410233252.81839D50@viggo.jf.intel.com>
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
Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
---

 linux.git-davehans/drivers/char/mem.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff -puN drivers/char/mem.c~make-kmem-return-error-for-highmem drivers/char/mem.c
--- linux.git/drivers/char/mem.c~make-kmem-return-error-for-highmem	2013-04-10 16:23:45.151087081 -0700
+++ linux.git-davehans/drivers/char/mem.c	2013-04-10 16:23:45.154087084 -0700
@@ -336,10 +336,19 @@ static int mmap_mem(struct file *file, s
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
_
