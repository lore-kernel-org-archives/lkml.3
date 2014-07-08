Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754757AbaGHUrd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 16:47:33 -0400
Received: from mail-pa0-f48.google.com ([209.85.220.48]:36837 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754717AbaGHUrb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 16:47:31 -0400
Date: Tue, 8 Jul 2014 13:45:50 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Ben Hutchings <ben@decadent.org.uk>
cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        akpm@linux-foundation.org,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Minchan Kim <minchan.kim@gmail.com>, Christoph Lameter <cl@linux.com>,
        Hugh Dickins <hughd@google.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 3.2 099/125] mm: fix crashes from mbind() merging vmas
In-Reply-To: <lsq.1404846110.431506873@decadent.org.uk>
Message-ID: <alpine.LSU.2.11.1407081336180.31914@eggly.anvils>
References: <lsq.1404846110.431506873@decadent.org.uk>
User-Agent: Alpine 2.11 (LSU 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 8 Jul 2014, Ben Hutchings wrote:

> 3.2.61-rc1 review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Hugh Dickins <hughd@google.com>
> 
> commit d05f0cdcbe6388723f1900c549b4850360545201 upstream.
> 
> In v2.6.34 commit 9d8cebd4bcd7 ("mm: fix mbind vma merge problem")
> introduced vma merging to mbind(), but it should have also changed the
> convention of passing start vma from queue_pages_range() (formerly
> check_range()) to new_vma_page(): vma merging may have already freed
> that structure, resulting in BUG at mm/mempolicy.c:1738 and probably
> worse crashes.
> 
> Fixes: 9d8cebd4bcd7 ("mm: fix mbind vma merge problem")
> Reported-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
> Tested-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
> Signed-off-by: Hugh Dickins <hughd@google.com>
> Acked-by: Christoph Lameter <cl@linux.com>
> Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> Cc: Minchan Kim <minchan.kim@gmail.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
> [bwh: Backported to 3.2:
>  - Adjust context
>  - Keep the same arguments to migrate_pages() except for private=start]
> Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
> ---
>  mm/mempolicy.c | 46 ++++++++++++++++++++--------------------------
>  1 file changed, 20 insertions(+), 26 deletions(-)
> 
> --- a/mm/mempolicy.c
> +++ b/mm/mempolicy.c
> @@ -566,24 +566,23 @@ static inline int check_pgd_range(struct
>   * If pagelist != NULL then isolate pages from the LRU and
>   * put them on the pagelist.
>   */
> -static struct vm_area_struct *
> +static int
>  check_range(struct mm_struct *mm, unsigned long start, unsigned long end,
>  		const nodemask_t *nodes, unsigned long flags, void *private)
>  {
> -	int err;
> -	struct vm_area_struct *first, *vma, *prev;
> -
> +	int err = 0;
> +	struct vm_area_struct *vma, *prev;
>  
> -	first = find_vma(mm, start);
> -	if (!first)
> -		return ERR_PTR(-EFAULT);
> +	vma = find_vma(mm, start);
> +	if (!vma)
> +		return -EFAULT;
>  	prev = NULL;
> -	for (vma = first; vma && vma->vm_start < end; vma = vma->vm_next) {
> +	for (; vma && vma->vm_start < end; vma = vma->vm_next) {
>  		if (!(flags & MPOL_MF_DISCONTIG_OK)) {
>  			if (!vma->vm_next && vma->vm_end < end)
> -				return ERR_PTR(-EFAULT);
> +				return -EFAULT;
>  			if (prev && prev->vm_end < vma->vm_start)
> -				return ERR_PTR(-EFAULT);
> +				return -EFAULT;
>  		}
>  		if (!is_vm_hugetlb_page(vma) &&
>  		    ((flags & MPOL_MF_STRICT) ||
> @@ -597,14 +596,12 @@ check_range(struct mm_struct *mm, unsign
>  				start = vma->vm_start;
>  			err = check_pgd_range(vma, start, endvma, nodes,
>  						flags, private);
> -			if (err) {
> -				first = ERR_PTR(err);
> +			if (err)
>  				break;
> -			}
>  		}
>  		prev = vma;
>  	}
> -	return first;
> +	return err;
>  }
>  
>  /*
> @@ -1060,16 +1057,17 @@ out:
>  
>  /*
>   * Allocate a new page for page migration based on vma policy.
> - * Start assuming that page is mapped by vma pointed to by @private.
> + * Start by assuming the page is mapped by the same vma as contains @start.
>   * Search forward from there, if not.  N.B., this assumes that the
>   * list of pages handed to migrate_pages()--which is how we get here--
>   * is in virtual address order.
>   */
> -static struct page *new_vma_page(struct page *page, unsigned long private, int **x)
> +static struct page *new_page(struct page *page, unsigned long start, int **x)
>  {
> -	struct vm_area_struct *vma = (struct vm_area_struct *)private;
> +	struct vm_area_struct *vma;
>  	unsigned long uninitialized_var(address);
>  
> +	vma = find_vma(current->mm, start);
>  	while (vma) {
>  		address = page_address_in_vma(page, vma);
>  		if (address != -EFAULT)
> @@ -1095,7 +1093,7 @@ int do_migrate_pages(struct mm_struct *m
>  	return -ENOSYS;
>  }
>  
> -static struct page *new_vma_page(struct page *page, unsigned long private, int **x)
> +static struct page *new_page(struct page *page, unsigned long start, int **x)
>  {
>  	return NULL;
>  }
> @@ -1105,7 +1103,6 @@ static long do_mbind(unsigned long start
>  		     unsigned short mode, unsigned short mode_flags,
>  		     nodemask_t *nmask, unsigned long flags)
>  {
> -	struct vm_area_struct *vma;
>  	struct mm_struct *mm = current->mm;
>  	struct mempolicy *new;
>  	unsigned long end;
> @@ -1169,19 +1166,16 @@ static long do_mbind(unsigned long start
>  	if (err)
>  		goto mpol_out;
>  
> -	vma = check_range(mm, start, end, nmask,
> +	err = check_range(mm, start, end, nmask,
>  			  flags | MPOL_MF_INVERT, &pagelist);
> -
> -	err = PTR_ERR(vma);
> -	if (!IS_ERR(vma)) {
> +	if (!err) {
>  		int nr_failed = 0;
>  
>  		err = mbind_range(mm, start, end, new);
>  
>  		if (!list_empty(&pagelist)) {
> -			nr_failed = migrate_pages(&pagelist, new_vma_page,
> -						(unsigned long)vma,
> -						false, true);
> +			nr_failed = migrate_pages(&pagelist, new_page,
> +						start, false, true);
>  			if (nr_failed)
>  				putback_lru_pages(&pagelist);
>  		}

I don't think that's correct, I can't see a change to the
"vma = check_range(" in migrate_to_node() which 3.2 and 3.4 trees have.
Does it build (without warning) with CONFIG_NUMA and CONFIG_MIGRATION?
I expect this version I sent yesterday for 3.4.98 will be good for 3.2:

------------------ version for 3.4.98 ------------------

>From d05f0cdcbe6388723f1900c549b4850360545201 Mon Sep 17 00:00:00 2001
From: Hugh Dickins <hughd@google.com>
Date: Mon, 23 Jun 2014 13:22:07 -0700
Subject: [PATCH] mm: fix crashes from mbind() merging vmas

In v2.6.34 commit 9d8cebd4bcd7 ("mm: fix mbind vma merge problem")
introduced vma merging to mbind(), but it should have also changed the
convention of passing start vma from queue_pages_range() (formerly
check_range()) to new_vma_page(): vma merging may have already freed
that structure, resulting in BUG at mm/mempolicy.c:1738 and probably
worse crashes.

Fixes: 9d8cebd4bcd7 ("mm: fix mbind vma merge problem")
Reported-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Tested-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Signed-off-by: Hugh Dickins <hughd@google.com>
Acked-by: Christoph Lameter <cl@linux.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Minchan Kim <minchan.kim@gmail.com>
Cc: <stable@vger.kernel.org>	[2.6.34+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -566,24 +566,24 @@ static inline int check_pgd_range(struct
  * If pagelist != NULL then isolate pages from the LRU and
  * put them on the pagelist.
  */
-static struct vm_area_struct *
+static int
 check_range(struct mm_struct *mm, unsigned long start, unsigned long end,
 		const nodemask_t *nodes, unsigned long flags, void *private)
 {
-	int err;
-	struct vm_area_struct *first, *vma, *prev;
+	int err = 0;
+	struct vm_area_struct *vma, *prev;
 
 
-	first = find_vma(mm, start);
-	if (!first)
-		return ERR_PTR(-EFAULT);
+	vma = find_vma(mm, start);
+	if (!vma)
+		return -EFAULT;
 	prev = NULL;
-	for (vma = first; vma && vma->vm_start < end; vma = vma->vm_next) {
+	for (; vma && vma->vm_start < end; vma = vma->vm_next) {
 		if (!(flags & MPOL_MF_DISCONTIG_OK)) {
 			if (!vma->vm_next && vma->vm_end < end)
-				return ERR_PTR(-EFAULT);
+				return -EFAULT;
 			if (prev && prev->vm_end < vma->vm_start)
-				return ERR_PTR(-EFAULT);
+				return -EFAULT;
 		}
 		if (!is_vm_hugetlb_page(vma) &&
 		    ((flags & MPOL_MF_STRICT) ||
@@ -597,14 +597,12 @@ check_range(struct mm_struct *mm, unsign
 				start = vma->vm_start;
 			err = check_pgd_range(vma, start, endvma, nodes,
 						flags, private);
-			if (err) {
-				first = ERR_PTR(err);
+			if (err)
 				break;
-			}
 		}
 		prev = vma;
 	}
-	return first;
+	return err;
 }
 
 /*
@@ -945,16 +943,15 @@ static int migrate_to_node(struct mm_str
 {
 	nodemask_t nmask;
 	LIST_HEAD(pagelist);
-	int err = 0;
-	struct vm_area_struct *vma;
+	int err;
 
 	nodes_clear(nmask);
 	node_set(source, nmask);
 
-	vma = check_range(mm, mm->mmap->vm_start, mm->task_size, &nmask,
+	err = check_range(mm, mm->mmap->vm_start, mm->task_size, &nmask,
 			flags | MPOL_MF_DISCONTIG_OK, &pagelist);
-	if (IS_ERR(vma))
-		return PTR_ERR(vma);
+	if (err)
+		return err;
 
 	if (!list_empty(&pagelist)) {
 		err = migrate_pages(&pagelist, new_node_page, dest,
@@ -1058,16 +1055,17 @@ out:
 
 /*
  * Allocate a new page for page migration based on vma policy.
- * Start assuming that page is mapped by vma pointed to by @private.
+ * Start by assuming the page is mapped by the same vma as contains @start.
  * Search forward from there, if not.  N.B., this assumes that the
  * list of pages handed to migrate_pages()--which is how we get here--
  * is in virtual address order.
  */
-static struct page *new_vma_page(struct page *page, unsigned long private, int **x)
+static struct page *new_page(struct page *page, unsigned long start, int **x)
 {
-	struct vm_area_struct *vma = (struct vm_area_struct *)private;
+	struct vm_area_struct *vma;
 	unsigned long uninitialized_var(address);
 
+	vma = find_vma(current->mm, start);
 	while (vma) {
 		address = page_address_in_vma(page, vma);
 		if (address != -EFAULT)
@@ -1093,7 +1091,7 @@ int do_migrate_pages(struct mm_struct *m
 	return -ENOSYS;
 }
 
-static struct page *new_vma_page(struct page *page, unsigned long private, int **x)
+static struct page *new_page(struct page *page, unsigned long start, int **x)
 {
 	return NULL;
 }
@@ -1103,7 +1101,6 @@ static long do_mbind(unsigned long start
 		     unsigned short mode, unsigned short mode_flags,
 		     nodemask_t *nmask, unsigned long flags)
 {
-	struct vm_area_struct *vma;
 	struct mm_struct *mm = current->mm;
 	struct mempolicy *new;
 	unsigned long end;
@@ -1167,19 +1164,17 @@ static long do_mbind(unsigned long start
 	if (err)
 		goto mpol_out;
 
-	vma = check_range(mm, start, end, nmask,
+	err = check_range(mm, start, end, nmask,
 			  flags | MPOL_MF_INVERT, &pagelist);
 
-	err = PTR_ERR(vma);
-	if (!IS_ERR(vma)) {
+	if (!err) {
 		int nr_failed = 0;
 
 		err = mbind_range(mm, start, end, new);
 
 		if (!list_empty(&pagelist)) {
-			nr_failed = migrate_pages(&pagelist, new_vma_page,
-						(unsigned long)vma,
-						false, true);
+			nr_failed = migrate_pages(&pagelist, new_page,
+						  start, false, true);
 			if (nr_failed)
 				putback_lru_pages(&pagelist);
 		}
