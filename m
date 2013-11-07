Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754045Ab3KGUvJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 15:51:09 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:48910 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751701Ab3KGUvF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 15:51:05 -0500
Date: Thu, 7 Nov 2013 12:51:03 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Michal Hocko <mhocko@suse.cz>
Cc: Jerome Marchand <jmarchan@redhat.com>, kbuild-all@01.org,
        linux-mm@kvack.org, LKML <linux-kernel@vger.kernel.org>,
        fengguang.wu@intel.com
Subject: Re: [memcg:since-3.12 75/75] fs/proc/meminfo.c:undefined reference
 to `vm_commit_limit'
Message-Id: <20131107125103.c81016a87bfd72b0acf4058c@linux-foundation.org>
In-Reply-To: <20131107132505.GA16393@dhcp22.suse.cz>
References: <527b74a0.xBELNKuc6Ws8XONb%fengguang.wu@intel.com>
	<20131107132505.GA16393@dhcp22.suse.cz>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 7 Nov 2013 14:25:05 +0100 Michal Hocko <mhocko@suse.cz> wrote:

> On Thu 07-11-13 19:08:16, Wu Fengguang wrote:
> > tree:   git://git.kernel.org/pub/scm/linux/kernel/git/mhocko/mm.git since-3.12
> > head:   2f11d7af8df66cb4f217b6293ad8189aa101d601
> > commit: 2f11d7af8df66cb4f217b6293ad8189aa101d601 [75/75] mm-factor-commit-limit-calculation-fix
> > config: make ARCH=blackfin BF526-EZBRD_defconfig
> > 
> > All error/warnings:
> > 
> >    mm/built-in.o: In function `__vm_enough_memory':
> >    (.text+0x11b4c): undefined reference to `vm_commit_limit'
> >    fs/built-in.o: In function `meminfo_proc_show':
> > >> fs/proc/meminfo.c:(.text+0x37ef0): undefined reference to `vm_commit_limit'
> 
> Andrew, it seems that moving vm_commit_limit out of mman.h is not that
> easy because it breaks NOMMU configurations. mm/mmap.o is not part of
> the nommu build apparently.
> 
> So either we move it back to mman.h or put it somewhere else. I do not
> have a good idea where, though.
> 

util.c?

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

