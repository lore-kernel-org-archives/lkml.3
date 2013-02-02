Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757320Ab3BBAIe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 19:08:34 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:53629 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757100Ab3BBAIY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 19:08:24 -0500
Date: Fri, 1 Feb 2013 16:08:23 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Michel Lespinasse <walken@google.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>, Rik van Riel <riel@redhat.com>,
        Mel Gorman <mgorman@suse.de>, Hugh Dickins <hughd@google.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] mm: accelerate mm_populate() treatment of THP pages
Message-Id: <20130201160823.f88f222f.akpm@linux-foundation.org>
In-Reply-To: <1359591980-29542-3-git-send-email-walken@google.com>
References: <1359591980-29542-1-git-send-email-walken@google.com>
	<1359591980-29542-3-git-send-email-walken@google.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Jan 2013 16:26:19 -0800
Michel Lespinasse <walken@google.com> wrote:

> This change adds a page_mask argument to follow_page.
> 
> follow_page sets *page_mask to HPAGE_PMD_NR - 1 when it encounters a THP page,
> and to 0 in other cases.
> 
> __get_user_pages() makes use of this in order to accelerate populating
> THP ranges - that is, when both the pages and vmas arrays are NULL,
> we don't need to iterate HPAGE_PMD_NR times to cover a single THP page
> (and we also avoid taking mm->page_table_lock that many times).
> 
> Other follow_page() call sites can safely ignore the value returned in
> *page_mask.

Seems sensible, but the implementation is rather ungainly.

If we're going to add this unused page_mask local to many functions
then let's at least miminize the scope of that variable and explain why
it's there.  For example,

--- a/mm/ksm.c~mm-accelerate-mm_populate-treatment-of-thp-pages-fix
+++ a/mm/ksm.c
@@ -356,9 +356,10 @@ static int break_ksm(struct vm_area_stru
 {
 	struct page *page;
 	int ret = 0;
-	long page_mask;
 
 	do {
+		long page_mask;		/* unused */
+
 		cond_resched();
 		page = follow_page(vma, addr, FOLL_GET, &page_mask);
 		if (IS_ERR_OR_NULL(page))
@@ -454,7 +455,7 @@ static struct page *get_mergeable_page(s
 	unsigned long addr = rmap_item->address;
 	struct vm_area_struct *vma;
 	struct page *page;
-	long page_mask;
+	long page_mask;		/* unused */
 
 	down_read(&mm->mmap_sem);
 	vma = find_mergeable_vma(mm, addr);
@@ -1525,7 +1526,6 @@ static struct rmap_item *scan_get_next_r
 	struct mm_slot *slot;
 	struct vm_area_struct *vma;
 	struct rmap_item *rmap_item;
-	long page_mask;
 	int nid;
 
 	if (list_empty(&ksm_mm_head.mm_list))
@@ -1600,6 +1600,8 @@ next_mm:
 			ksm_scan.address = vma->vm_end;
 
 		while (ksm_scan.address < vma->vm_end) {
+			long page_mask;		/* unused */
+
 			if (ksm_test_exit(mm))
 				break;
 			*page = follow_page(vma, ksm_scan.address, FOLL_GET,



Alternatively we could permit the passing of page_mask==NULL, which is
a common convention in the get_user_pages() area.  Possibly that's a
tad more expensive, but it will save a stack slot.


However I think the best approach here is to just leave the
follow_page() interface alone.  Rename the present implementation to
follow_page_mask() or whatever and add

static inline<?> void follow_page(args)
{
	long page_mask;		/* unused */

	return follow_page_mask(args, &page_mask);
}

Also, I see no sense in permitting negative page_mask values and I
doubt if we'll be needing 64-bit values here.  Make it `unsigned int'?


Finally, this version of the patch surely breaks the nommu build?
