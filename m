Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755424Ab3KKTwn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 14:52:43 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:50527 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755311Ab3KKTwX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 14:52:23 -0500
Date: Mon, 11 Nov 2013 11:52:21 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Uwe =?ISO-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: linux-kernel@vger.kernel.org, kernel@pengutronix.de
Subject: Re: mm-factor-commit-limit-calculation-fix broken on ARM-nommu
Message-Id: <20131111115221.7582f4d924d5ca16bb2c1100@linux-foundation.org>
In-Reply-To: <20131111092815.GJ14892@pengutronix.de>
References: <20131111092815.GJ14892@pengutronix.de>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 11 Nov 2013 10:28:15 +0100 Uwe Kleine-K__nig <u.kleine-koenig@pengutronix.de> wrote:

> Hello Andrew,
> 
> in mm-factor-commit-limit-calculation-fix you move vm_commit_limit to
> mm/mmap.c. This file is only compiled with CONFIG_MMU on though. So my
> build fails here.
> 
> There are some more problems that I didn't look into yet, but if you
> want to look into it, efm32_defconfig for ARCH=arm is what I'm seeing
> broken.

yup.  Hopefully mm-factor-commit-limit-calculation-fix-fix.patch
fix-fixes this.


From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-factor-commit-limit-calculation-fix-fix

Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Jerome Marchand <jmarchan@redhat.com>
Cc: Michal Hocko <mhocko@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |    9 ---------
 mm/util.c |   13 +++++++++++++
 2 files changed, 13 insertions(+), 9 deletions(-)

diff -puN mm/mmap.c~mm-factor-commit-limit-calculation-fix-fix mm/mmap.c
--- a/mm/mmap.c~mm-factor-commit-limit-calculation-fix-fix
+++ a/mm/mmap.c
@@ -110,15 +110,6 @@ unsigned long vm_memory_committed(void)
 EXPORT_SYMBOL_GPL(vm_memory_committed);
 
 /*
- * Commited memory limit enforced when OVERCOMMIT_NEVER policy is used
- */
-unsigned long vm_commit_limit(void)
-{
-	return ((totalram_pages - hugetlb_total_pages())
-		* sysctl_overcommit_ratio / 100) + total_swap_pages;
-}
-
-/*
  * Check that a process has enough memory to allocate a new virtual
  * mapping. 0 means there is enough memory for the allocation to
  * succeed and -ENOMEM implies there is not.
diff -puN mm/util.c~mm-factor-commit-limit-calculation-fix-fix mm/util.c
--- a/mm/util.c~mm-factor-commit-limit-calculation-fix-fix
+++ a/mm/util.c
@@ -7,6 +7,9 @@
 #include <linux/security.h>
 #include <linux/swap.h>
 #include <linux/swapops.h>
+#include <linux/mman.h>
+#include <linux/hugetlb.h>
+
 #include <asm/uaccess.h>
 
 #include "internal.h"
@@ -398,6 +401,16 @@ struct address_space *page_mapping(struc
 	return mapping;
 }
 
+/*
+ * Commited memory limit enforced when OVERCOMMIT_NEVER policy is used
+ */
+unsigned long vm_commit_limit(void)
+{
+	return ((totalram_pages - hugetlb_total_pages())
+		* sysctl_overcommit_ratio / 100) + total_swap_pages;
+}
+
+
 /* Tracepoints definitions. */
 EXPORT_TRACEPOINT_SYMBOL(kmalloc);
 EXPORT_TRACEPOINT_SYMBOL(kmem_cache_alloc);
_

