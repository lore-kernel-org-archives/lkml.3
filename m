Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755999Ab3CFWUO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 17:20:14 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:48497 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751354Ab3CFWUM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 17:20:12 -0500
Date: Wed, 6 Mar 2013 14:20:11 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Hillf Danton <dhillf@gmail.com>
Cc: Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        Michal Hocko <mhocko@suse.cz>, Michel Lespinasse <walken@google.com>
Subject: Re: [PATCH resend] rmap: recompute pgoff for unmapping huge page
Message-Id: <20130306142011.c6260e416cef6a906660fa4d@linux-foundation.org>
In-Reply-To: <CAJd=RBD0UWxpMv7W78fH0U_zBAOozP1owaMePGaUEVitotRfBg@mail.gmail.com>
References: <CAJd=RBD0UWxpMv7W78fH0U_zBAOozP1owaMePGaUEVitotRfBg@mail.gmail.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 4 Mar 2013 20:47:31 +0800 Hillf Danton <dhillf@gmail.com> wrote:

> [Resend due to error in delivering to linux-kernel@vger.kernel.org,
> caused probably by the rich format provided by the mail agent by default.]
> 
> We have to recompute pgoff if the given page is huge, since result based on
> HPAGE_SIZE is not approapriate for scanning the vma interval tree, as shown
> by commit 36e4f20af833(hugetlb: do not use vma_hugecache_offset() for
> vma_prio_tree_foreach)
> 
> Signed-off-by: Hillf Danton <dhillf@gmail.com>
> ---
> 
> --- a/mm/rmap.c	Mon Mar  4 20:00:00 2013
> +++ b/mm/rmap.c	Mon Mar  4 20:02:16 2013
> @@ -1513,6 +1513,9 @@ static int try_to_unmap_file(struct page
>  	unsigned long max_nl_size = 0;
>  	unsigned int mapcount;
> 
> +	if (PageHuge(page))
> +		pgoff = page->index << compound_order(page);
> +
>  	mutex_lock(&mapping->i_mmap_mutex);
>  	vma_interval_tree_foreach(vma, &mapping->i_mmap, pgoff, pgoff) {
>  		unsigned long address = vma_address(page, vma);

How are we getting here for hugepages?  Trying to migrate a hugetlbfs
page?

Can we just do this?

--- a/mm/rmap.c~a
+++ a/mm/rmap.c
@@ -1505,7 +1505,7 @@ static int try_to_unmap_anon(struct page
 static int try_to_unmap_file(struct page *page, enum ttu_flags flags)
 {
 	struct address_space *mapping = page->mapping;
-	pgoff_t pgoff = page->index << (PAGE_CACHE_SHIFT - PAGE_SHIFT);
+	pgoff_t pgoff;
 	struct vm_area_struct *vma;
 	int ret = SWAP_AGAIN;
 	unsigned long cursor;
@@ -1513,6 +1513,7 @@ static int try_to_unmap_file(struct page
 	unsigned long max_nl_size = 0;
 	unsigned int mapcount;
 
+	pgoff = page->index << compound_order(page);
 	mutex_lock(&mapping->i_mmap_mutex);
 	vma_interval_tree_foreach(vma, &mapping->i_mmap, pgoff, pgoff) {
 		unsigned long address = vma_address(page, vma);
_

It's a lot less fuss.
