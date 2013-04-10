Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937098Ab3DJXhz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 19:37:55 -0400
Received: from mga02.intel.com ([134.134.136.20]:23452 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762080Ab3DJXhu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 19:37:50 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,450,1363158000"; 
   d="scan'208";a="293206073"
Subject: [PATCH 3/5] avoid /dev/kmem oopses with DEBUG_VIRTUAL
To: bp@alien8.de
Cc: hpa@linux.intel.com, linux-kernel@vger.kernel.org, x86@kernel.org,
        Dave Hansen <dave@sr71.net>
From: Dave Hansen <dave@sr71.net>
Date: Wed, 10 Apr 2013 16:32:53 -0700
References: <20130410233249.7FFCB63B@viggo.jf.intel.com>
In-Reply-To: <20130410233249.7FFCB63B@viggo.jf.intel.com>
Message-Id: <20130410233253.250AD1EA@viggo.jf.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


DEBUG_VIRTUAL, ensures that when __pa() is only called on
addresses for which its results are correct.  For everything
else, we BUG_ON().

This changes the /dev/kmem ordering so that we check pfn_valid()
_before_ we call __pa().  This ensures we're not calling __pa()
with gibberish and avoids the BUG_ON() in those cases, instead
returning the error to userspace _before_ the __pa() call.



Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
---

 linux.git-davehans/drivers/char/mem.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN drivers/char/mem.c~make-devmem-work-on-highmem3a drivers/char/mem.c
--- linux.git/drivers/char/mem.c~make-devmem-work-on-highmem3a	2013-04-10 16:23:45.361087291 -0700
+++ linux.git-davehans/drivers/char/mem.c	2013-04-10 16:23:45.365087295 -0700
@@ -347,9 +347,6 @@ static int mmap_kmem(struct file *file,
 	 */
 	if (kernel_vaddr >= high_memory)
 		return -EIO;
-	/* Turn a kernel-virtual address into a physical page frame */
-	pfn = __pa(kernel_vaddr) >> PAGE_SHIFT;
-
 	/*
 	 * RED-PEN: on some architectures there is more mapped memory than
 	 * available in mem_map which pfn_valid checks for. Perhaps should add a
@@ -360,6 +357,9 @@ static int mmap_kmem(struct file *file,
 	if (!pfn_valid(pfn))
 		return -EIO;
 
+	/* Turn a kernel-virtual address into a physical page frame */
+	pfn = __pa(kernel_vaddr) >> PAGE_SHIFT;
+
 	vma->vm_pgoff = pfn;
 	return mmap_mem(file, vma);
 }
_
