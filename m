Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751171AbaFLWEp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 18:04:45 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36312 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750716AbaFLWEo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 18:04:44 -0400
Date: Thu, 12 Jun 2014 15:04:43 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: linux-mm@kvack.org, Dave Hansen <dave.hansen@intel.com>,
        Hugh Dickins <hughd@google.com>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 7/7] mincore: apply page table walker on do_mincore()
Message-Id: <20140612150443.72809d03688bdce9a84164a6@linux-foundation.org>
In-Reply-To: <1402095520-10109-8-git-send-email-n-horiguchi@ah.jp.nec.com>
References: <1402095520-10109-1-git-send-email-n-horiguchi@ah.jp.nec.com>
	<1402095520-10109-8-git-send-email-n-horiguchi@ah.jp.nec.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri,  6 Jun 2014 18:58:40 -0400 Naoya Horiguchi <n-horiguchi@ah.jp.nec.com> wrote:

> @@ -233,12 +163,20 @@ static long do_mincore(unsigned long addr, unsigned long pages, unsigned char *v
>  
>  	end = min(vma->vm_end, addr + (pages << PAGE_SHIFT));
>  
> -	if (is_vm_hugetlb_page(vma))
> -		mincore_hugetlb_page_range(vma, addr, end, vec);
> +	struct mm_walk mincore_walk = {
> +		.pmd_entry = mincore_pmd,
> +		.pte_entry = mincore_pte,
> +		.pte_hole = mincore_hole,
> +		.hugetlb_entry = mincore_hugetlb,
> +		.mm = vma->vm_mm,
> +		.vma = vma,
> +		.private = vec,
> +	};
> +	err = walk_page_vma(vma, &mincore_walk);
> +	if (err < 0)
> +		return err;
>  	else
> -		mincore_page_range(vma, addr, end, vec);
> -
> -	return (end - addr) >> PAGE_SHIFT;
> +		return (end - addr) >> PAGE_SHIFT;
>  }
>  
>  /*

Please review carefully.

From: Andrew Morton <akpm@linux-foundation.org>
Subject: mincore-apply-page-table-walker-on-do_mincore-fix

mm/mincore.c: In function 'do_mincore':
mm/mincore.c:166: warning: ISO C90 forbids mixed declarations and code

Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mincore.c |   28 +++++++++++++++-------------
 1 file changed, 15 insertions(+), 13 deletions(-)

diff -puN mm/huge_memory.c~mincore-apply-page-table-walker-on-do_mincore-fix mm/huge_memory.c
diff -puN mm/mincore.c~mincore-apply-page-table-walker-on-do_mincore-fix mm/mincore.c
--- a/mm/mincore.c~mincore-apply-page-table-walker-on-do_mincore-fix
+++ a/mm/mincore.c
@@ -151,32 +151,34 @@ static int mincore_pmd(pmd_t *pmd, unsig
  * all the arguments, we hold the mmap semaphore: we should
  * just return the amount of info we're asked for.
  */
-static long do_mincore(unsigned long addr, unsigned long pages, unsigned char *vec)
+static long do_mincore(unsigned long addr, unsigned long pages,
+		       unsigned char *vec)
 {
 	struct vm_area_struct *vma;
-	unsigned long end;
 	int err;
-
-	vma = find_vma(current->mm, addr);
-	if (!vma || addr < vma->vm_start)
-		return -ENOMEM;
-
-	end = min(vma->vm_end, addr + (pages << PAGE_SHIFT));
-
 	struct mm_walk mincore_walk = {
 		.pmd_entry = mincore_pmd,
 		.pte_entry = mincore_pte,
 		.pte_hole = mincore_hole,
 		.hugetlb_entry = mincore_hugetlb,
-		.mm = vma->vm_mm,
-		.vma = vma,
 		.private = vec,
 	};
+
+	vma = find_vma(current->mm, addr);
+	if (!vma || addr < vma->vm_start)
+		return -ENOMEM;
+	mincore_walk.vma = vma;
+	mincore_walk.mm = vma->vm_mm;
+
 	err = walk_page_vma(vma, &mincore_walk);
-	if (err < 0)
+	if (err < 0) {
 		return err;
-	else
+	} else {
+		unsigned long end;
+
+		end = min(vma->vm_end, addr + (pages << PAGE_SHIFT));
 		return (end - addr) >> PAGE_SHIFT;
+	}
 }
 
 /*
_

