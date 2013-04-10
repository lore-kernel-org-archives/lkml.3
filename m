Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937186Ab3DJXh4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 19:37:56 -0400
Received: from mga02.intel.com ([134.134.136.20]:23452 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S937052Ab3DJXhx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 19:37:53 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,450,1363158000"; 
   d="scan'208";a="293206093"
Subject: [PATCH 5/5] keep /dev/kmem from triggering BUG_ON() with DEBUG_VIRTUAL
To: bp@alien8.de
Cc: hpa@linux.intel.com, linux-kernel@vger.kernel.org, x86@kernel.org,
        Dave Hansen <dave@sr71.net>
From: Dave Hansen <dave@sr71.net>
Date: Wed, 10 Apr 2013 16:32:56 -0700
References: <20130410233249.7FFCB63B@viggo.jf.intel.com>
In-Reply-To: <20130410233249.7FFCB63B@viggo.jf.intel.com>
Message-Id: <20130410233256.D9FE46E1@viggo.jf.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


/dev/kmem can essentially be used to make the kernel call __pa()
on any address.  But, with DEBUG_VIRTUAL, we are now ensuring
that when __pa() is only called on addresses for which its
results are correct.  For everything else, we BUG_ON().

What this means is that a hapless /dev/kmem user can
unintentionally make the kernel BUG_ON().

This adds a function, is_kernel_linear_vaddr() to the /dev/kmem
code to ensure that __pa() will not BUG_ON().  It will, instead,
return an error up to the user.

Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
---

 linux.git-davehans/arch/x86/mm/pageattr.c  |   19 +++++++++++++++++++
 linux.git-davehans/drivers/char/mem.c      |    8 ++++++++
 linux.git-davehans/include/linux/mmdebug.h |    2 ++
 3 files changed, 29 insertions(+)

diff -puN arch/x86/mm/pageattr.c~make-devmem-work-on-highmem3b arch/x86/mm/pageattr.c
--- linux.git/arch/x86/mm/pageattr.c~make-devmem-work-on-highmem3b	2013-04-10 16:23:45.780087708 -0700
+++ linux.git-davehans/arch/x86/mm/pageattr.c	2013-04-10 16:23:45.786087714 -0700
@@ -406,6 +406,25 @@ phys_addr_t slow_virt_to_phys(void *virt
 }
 EXPORT_SYMBOL_GPL(slow_virt_to_phys);
 
+#ifdef CONFIG_DEBUG_VIRTUAL
+int is_kernel_linear_vaddr(void *kernel_vaddr)
+{
+	int err;
+	unsigned long pte_walk_paddr;
+	unsigned long linear_paddr = __pa_nodebug(kernel_vaddr);
+
+	err = kernel_lookup_vaddr(kernel_vaddr, &pte_walk_paddr);
+	/* if there is no pte, it can not be in the normal linear map */
+	if (err)
+		return 0;
+	/* is there is a pte which does not match the linear layout? */
+	if (pte_walk_paddr != linear_paddr)
+		return 0;
+
+	return 1;
+}
+#endif /* CONFIG_DEBUG_VIRTUAL */
+
 /*
  * Set the new pmd in all the pgds we know about:
  */
diff -puN drivers/char/mem.c~make-devmem-work-on-highmem3b drivers/char/mem.c
--- linux.git/drivers/char/mem.c~make-devmem-work-on-highmem3b	2013-04-10 16:23:45.781087709 -0700
+++ linux.git-davehans/drivers/char/mem.c	2013-04-10 16:23:45.787087715 -0700
@@ -357,6 +357,14 @@ static int mmap_kmem(struct file *file,
 	if (!pfn_valid(pfn))
 		return -EIO;
 
+	/*
+	 * the __pa() calculation below only makes sense if the kernel's
+	 * pagetables are set up in the way that __pa() expects.  Otherwise,
+	 * we are effectively mapping random memory in to place.
+	 */
+	if (!is_kernel_linear_vaddr(kernel_vaddr))
+		return -EIO;
+
 	/* Turn a kernel-virtual address into a physical page frame */
 	pfn = __pa(kernel_vaddr) >> PAGE_SHIFT;
 
diff -puN include/linux/mmdebug.h~make-devmem-work-on-highmem3b include/linux/mmdebug.h
--- linux.git/include/linux/mmdebug.h~make-devmem-work-on-highmem3b	2013-04-10 16:23:45.783087711 -0700
+++ linux.git-davehans/include/linux/mmdebug.h	2013-04-10 16:23:45.787087715 -0700
@@ -9,8 +9,10 @@
 
 #ifdef CONFIG_DEBUG_VIRTUAL
 #define VIRTUAL_BUG_ON(cond) BUG_ON(cond)
+extern int is_kernel_linear_vaddr(void *kernel_vaddr);
 #else
 #define VIRTUAL_BUG_ON(cond) do { } while (0)
+static inline int is_kernel_linear_vaddr(void *kernel_vaddr) { return 1; }
 #endif
 
 #endif
_
