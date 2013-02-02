Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753651Ab3BBIZ4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2013 03:25:56 -0500
Received: from mail-la0-f47.google.com ([209.85.215.47]:44915 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751611Ab3BBIZw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2013 03:25:52 -0500
Message-ID: <510CCD88.30200@openvz.org>
Date: Sat, 02 Feb 2013 12:25:44 +0400
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.11) Gecko/20121123 Firefox/10.0.11 Iceape/2.7.11
MIME-Version: 1.0
To: Johannes Weiner <hannes@cmpxchg.org>
CC: Andrew Morton <akpm@linux-foundation.org>, Hugh Dickins <hughd@google.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [patch] mm: shmem: use new radix tree iterator
References: <1359699238-7327-1-git-send-email-hannes@cmpxchg.org>
In-Reply-To: <1359699238-7327-1-git-send-email-hannes@cmpxchg.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Johannes Weiner wrote:
> In shmem_find_get_pages_and_swap, use the faster radix tree iterator
> construct from 78c1d78 "radix-tree: introduce bit-optimized iterator".
>
> Signed-off-by: Johannes Weiner<hannes@cmpxchg.org>

Hmm, ACK. shmem_unuse_inode() also can be redone in this way.
I did something similar year ago: https://lkml.org/lkml/2012/2/10/388
As result we can rid of radix_tree_locate_item() and shmem_find_get_pages_and_swap()

> ---
>   mm/shmem.c | 25 ++++++++++++-------------
>   1 file changed, 12 insertions(+), 13 deletions(-)
>
> diff --git a/mm/shmem.c b/mm/shmem.c
> index a368a1c..c5dc8ae 100644
> --- a/mm/shmem.c
> +++ b/mm/shmem.c
> @@ -336,19 +336,19 @@ static unsigned shmem_find_get_pages_and_swap(struct address_space *mapping,
>   					pgoff_t start, unsigned int nr_pages,
>   					struct page **pages, pgoff_t *indices)
>   {
> -	unsigned int i;
> -	unsigned int ret;
> -	unsigned int nr_found;
> +	void **slot;
> +	unsigned int ret = 0;
> +	struct radix_tree_iter iter;
> +
> +	if (!nr_pages)
> +		return 0;
>
>   	rcu_read_lock();
>   restart:
> -	nr_found = radix_tree_gang_lookup_slot(&mapping->page_tree,
> -				(void ***)pages, indices, start, nr_pages);
> -	ret = 0;
> -	for (i = 0; i<  nr_found; i++) {
> +	radix_tree_for_each_slot(slot,&mapping->page_tree,&iter, start) {
>   		struct page *page;
>   repeat:
> -		page = radix_tree_deref_slot((void **)pages[i]);
> +		page = radix_tree_deref_slot(slot);
>   		if (unlikely(!page))
>   			continue;
>   		if (radix_tree_exception(page)) {
> @@ -365,17 +365,16 @@ static unsigned shmem_find_get_pages_and_swap(struct address_space *mapping,
>   			goto repeat;
>
>   		/* Has the page moved? */
> -		if (unlikely(page != *((void **)pages[i]))) {
> +		if (unlikely(page != *slot)) {
>   			page_cache_release(page);
>   			goto repeat;
>   		}
>   export:
> -		indices[ret] = indices[i];
> +		indices[ret] = iter.index;
>   		pages[ret] = page;
> -		ret++;
> +		if (++ret == nr_pages)
> +			break;
>   	}
> -	if (unlikely(!ret&&  nr_found))
> -		goto restart;
>   	rcu_read_unlock();
>   	return ret;
>   }

