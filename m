Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751428AbaJAJLT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 05:11:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:62995 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750846AbaJAJLO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 05:11:14 -0400
Date: Wed, 1 Oct 2014 11:10:27 +0200
From: Andrea Arcangeli <aarcange@redhat.com>
To: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Cc: Andres Lagar-Cavilla <andreslc@google.com>, Gleb Natapov <gleb@kernel.org>,
        Radim Krcmar <rkrcmar@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>,
        Rik van Riel <riel@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Mel Gorman <mgorman@suse.de>, Andy Lutomirski <luto@amacapital.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Sasha Levin <sasha.levin@oracle.com>, Jianyu Zhan <nasa4836@gmail.com>,
        Paul Cassella <cassella@cray.com>, Hugh Dickins <hughd@google.com>,
        Peter Feiner <pfeiner@google.com>,
        "\\\"Dr. David Alan Gilbert\\\"" <dgilbert@redhat.com>
Subject: Re: [PATCH 3/4] mm: gup: use get_user_pages_fast and
 get_user_pages_unlocked
Message-ID: <20141001091027.GQ4590@redhat.com>
References: <1412153797-6667-1-git-send-email-aarcange@redhat.com>
 <1412153797-6667-4-git-send-email-aarcange@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1412153797-6667-4-git-send-email-aarcange@redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 01, 2014 at 10:56:36AM +0200, Andrea Arcangeli wrote:
> diff --git a/drivers/misc/sgi-gru/grufault.c b/drivers/misc/sgi-gru/grufault.c
> index f74fc0c..cd20669 100644
> --- a/drivers/misc/sgi-gru/grufault.c
> +++ b/drivers/misc/sgi-gru/grufault.c
> @@ -198,8 +198,7 @@ static int non_atomic_pte_lookup(struct vm_area_struct *vma,
>  #else
>  	*pageshift = PAGE_SHIFT;
>  #endif
> -	if (get_user_pages
> -	    (current, current->mm, vaddr, 1, write, 0, &page, NULL) <= 0)
> +	if (get_user_pages_fast(vaddr, 1, write, &page) <= 0)
>  		return -EFAULT;
>  	*paddr = page_to_phys(page);
>  	put_page(page);

> diff --git a/mm/mempolicy.c b/mm/mempolicy.c
> index 8f5330d..6606c10 100644
> --- a/mm/mempolicy.c
> +++ b/mm/mempolicy.c
> @@ -881,7 +881,7 @@ static int lookup_node(struct mm_struct *mm, unsigned long addr)
>  	struct page *p;
>  	int err;
>  
> -	err = get_user_pages(current, mm, addr & PAGE_MASK, 1, 0, 0, &p, NULL);
> +	err = get_user_pages_fast(addr & PAGE_MASK, 1, 0, &p);
>  	if (err >= 0) {
>  		err = page_to_nid(p);
>  		put_page(p);

I just noticed I need to revert the above two changes... (both weren't
exercised during the testing).
