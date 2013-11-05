Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755856Ab3KEXvJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 18:51:09 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:59501 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755549Ab3KEXvG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 18:51:06 -0500
Date: Tue, 5 Nov 2013 15:51:05 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Jerome Marchand <jmarchan@redhat.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, dave.hansen@intel.com
Subject: Re: [PATCH v4 1/2] mm: factor commit limit calculation
Message-Id: <20131105155105.41c9a624689c3262f5141e41@linux-foundation.org>
In-Reply-To: <1382101019-23563-1-git-send-email-jmarchan@redhat.com>
References: <1382101019-23563-1-git-send-email-jmarchan@redhat.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 Oct 2013 14:56:58 +0200 Jerome Marchand <jmarchan@redhat.com> wrote:

> Change since v3:
>  - rebase on 3.12-rc5
> 
> The same calculation is currently done in three differents places.
> Factor that code so future changes has to be made at only one place.
> 

lgtm.

> --- a/include/linux/mman.h
> +++ b/include/linux/mman.h
> @@ -7,6 +7,9 @@
>  #include <linux/atomic.h>
>  #include <uapi/linux/mman.h>
>  
> +#include <linux/hugetlb.h>
> +#include <linux/swap.h>
> +
>  extern int sysctl_overcommit_memory;
>  extern int sysctl_overcommit_ratio;
>  extern struct percpu_counter vm_committed_as;
> @@ -87,4 +90,13 @@ calc_vm_flag_bits(unsigned long flags)
>  	       _calc_vm_trans(flags, MAP_DENYWRITE,  VM_DENYWRITE ) |
>  	       _calc_vm_trans(flags, MAP_LOCKED,     VM_LOCKED    );
>  }
> +
> +/*
> + * Commited memory limit enforced when OVERCOMMIT_NEVER policy is used
> + */
> +static inline unsigned long vm_commit_limit()
> +{
> +	return ((totalram_pages - hugetlb_total_pages())
> +		* sysctl_overcommit_ratio / 100) + total_swap_pages;
> +}

Not sure I like this part much.  This function is large and slow and
doesn't merit inlining, plus it requires worsening our nested-include
mess.  This?

Also, it should be vm_commit_limit(void).



From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-factor-commit-limit-calculation-fix

Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Jerome Marchand <jmarchan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mman.h |   12 +-----------
 mm/mmap.c            |    9 +++++++++
 2 files changed, 10 insertions(+), 11 deletions(-)

diff -puN fs/proc/meminfo.c~mm-factor-commit-limit-calculation-fix fs/proc/meminfo.c
diff -puN include/linux/mman.h~mm-factor-commit-limit-calculation-fix include/linux/mman.h
--- a/include/linux/mman.h~mm-factor-commit-limit-calculation-fix
+++ a/include/linux/mman.h
@@ -7,9 +7,6 @@
 #include <linux/atomic.h>
 #include <uapi/linux/mman.h>
 
-#include <linux/hugetlb.h>
-#include <linux/swap.h>
-
 extern int sysctl_overcommit_memory;
 extern int sysctl_overcommit_ratio;
 extern struct percpu_counter vm_committed_as;
@@ -91,12 +88,5 @@ calc_vm_flag_bits(unsigned long flags)
 	       _calc_vm_trans(flags, MAP_LOCKED,     VM_LOCKED    );
 }
 
-/*
- * Commited memory limit enforced when OVERCOMMIT_NEVER policy is used
- */
-static inline unsigned long vm_commit_limit()
-{
-	return ((totalram_pages - hugetlb_total_pages())
-		* sysctl_overcommit_ratio / 100) + total_swap_pages;
-}
+unsigned long vm_commit_limit(void);
 #endif /* _LINUX_MMAN_H */
diff -puN mm/mmap.c~mm-factor-commit-limit-calculation-fix mm/mmap.c
--- a/mm/mmap.c~mm-factor-commit-limit-calculation-fix
+++ a/mm/mmap.c
@@ -110,6 +110,15 @@ unsigned long vm_memory_committed(void)
 EXPORT_SYMBOL_GPL(vm_memory_committed);
 
 /*
+ * Commited memory limit enforced when OVERCOMMIT_NEVER policy is used
+ */
+unsigned long vm_commit_limit(void)
+{
+	return ((totalram_pages - hugetlb_total_pages())
+		* sysctl_overcommit_ratio / 100) + total_swap_pages;
+}
+
+/*
  * Check that a process has enough memory to allocate a new virtual
  * mapping. 0 means there is enough memory for the allocation to
  * succeed and -ENOMEM implies there is not.
diff -puN mm/nommu.c~mm-factor-commit-limit-calculation-fix mm/nommu.c
diff -puN mm/util.c~mm-factor-commit-limit-calculation-fix mm/util.c
diff -puN include/linux/mm.h~mm-factor-commit-limit-calculation-fix include/linux/mm.h
_

