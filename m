Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752264Ab3FQWOT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 18:14:19 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:41676 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751971Ab3FQWOS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 18:14:18 -0400
Date: Mon, 17 Jun 2013 15:14:17 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Andrea Arcangeli <aarcange@redhat.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH] thp: define HPAGE_PMD_* constans as BUILD_BUG() if !THP
Message-Id: <20130617151417.f7610d56b4b43ced30c40133@linux-foundation.org>
In-Reply-To: <1371506740-14606-1-git-send-email-kirill.shutemov@linux.intel.com>
References: <1371506740-14606-1-git-send-email-kirill.shutemov@linux.intel.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 Jun 2013 01:05:40 +0300 "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com> wrote:

> From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
> 
> Currently, HPAGE_PMD_* constans rely on PMD_SHIFT regardless of
> CONFIG_TRANSPARENT_HUGEPAGE. PMD_SHIFT is not defined everywhere (e.g.
> arm nommu case).
> 
> It means we can't use anything like this in generic code:
> 
>         if (PageTransHuge(page))
>                 zero_huge_user(page, 0, HPAGE_PMD_SIZE);
>         else
>                 clear_highpage(page);
> 
> For !THP case, PageTransHuge() is 0 and compiler can eliminate
> zero_huge_user() call. But it still need to be valid C expression, means
> HPAGE_PMD_SIZE has to expand to something compiler can understand.
> 
> Previously, HPAGE_PMD_* were defined to BUILD_BUG() for !THP. Let's come
> back to it.
> 
> ...
>
> --- a/include/linux/huge_mm.h
> +++ b/include/linux/huge_mm.h
> @@ -58,11 +58,12 @@ extern pmd_t *page_check_address_pmd(struct page *page,
>  
>  #define HPAGE_PMD_ORDER (HPAGE_PMD_SHIFT-PAGE_SHIFT)
>  #define HPAGE_PMD_NR (1<<HPAGE_PMD_ORDER)
> +
> +#ifdef CONFIG_TRANSPARENT_HUGEPAGE
>  #define HPAGE_PMD_SHIFT PMD_SHIFT
>  #define HPAGE_PMD_SIZE	((1UL) << HPAGE_PMD_SHIFT)
>  #define HPAGE_PMD_MASK	(~(HPAGE_PMD_SIZE - 1))
>  
> -#ifdef CONFIG_TRANSPARENT_HUGEPAGE
>  extern bool is_vma_temporary_stack(struct vm_area_struct *vma);
>  
>  #define transparent_hugepage_enabled(__vma)				\
> @@ -180,6 +181,9 @@ extern int do_huge_pmd_numa_page(struct mm_struct *mm, struct vm_area_struct *vm
>  				unsigned long addr, pmd_t pmd, pmd_t *pmdp);
>  
>  #else /* CONFIG_TRANSPARENT_HUGEPAGE */
> +#define HPAGE_PMD_SHIFT ({ BUILD_BUG(); 0; })
> +#define HPAGE_PMD_MASK ({ BUILD_BUG(); 0; })
> +#define HPAGE_PMD_SIZE ({ BUILD_BUG(); 0; })
>  

We've done this sort of thing before and it blew up.  We do want to be
able to use things like HPAGE_PMD_foo in global-var initialisers and
definitions, but the problem is that BUILD_BUG() can't be used outside
functions.  For example,

--- a/fs/open.c
+++ b/fs/open.c
@@ -34,6 +34,11 @@
 
 #include "internal.h"
 
+#define FOOB ({ BUILD_BUG(); 0; })
+
+int x = FOOB;
+int y[FOOB];
+
 int do_truncate(struct dentry *dentry, loff_t length, unsigned int time_attrs,
 	struct file *filp)
 {

fs/open.c:39: error: braced-group within expression allowed only inside a function
fs/open.c:40: error: braced-group within expression allowed only inside a function

