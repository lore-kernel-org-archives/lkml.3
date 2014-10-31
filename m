Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758462AbaJaTHE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 15:07:04 -0400
Received: from mail-ig0-f201.google.com ([209.85.213.201]:57904 "EHLO
	mail-ig0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750886AbaJaTHB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 15:07:01 -0400
Date: Fri, 31 Oct 2014 12:06:58 -0700
From: Peter Feiner <pfeiner@google.com>
To: Andrea Arcangeli <aarcange@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, "Kirill A. Shutemov" <kirill@shutemov.name>,
        Michel Lespinasse <walken@google.com>,
        Andrew Jones <drjones@redhat.com>, Hugh Dickins <hughd@google.com>,
        Mel Gorman <mgorman@suse.de>,
        Andres Lagar-Cavilla <andreslc@google.com>,
        Minchan Kim <minchan@kernel.org>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        "\\\"Dr. David Alan Gilbert\\\"" <dgilbert@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        David Miller <davem@davemloft.net>,
        Steve Capper <steve.capper@linaro.org>,
        Johannes Weiner <jweiner@redhat.com>
Subject: Re: [PATCH 4/5] mm: gup: use get_user_pages_unlocked
Message-ID: <20141031190658.GA38315@google.com>
References: <1414600520-7664-1-git-send-email-aarcange@redhat.com>
 <1414600520-7664-5-git-send-email-aarcange@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1414600520-7664-5-git-send-email-aarcange@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 29, 2014 at 05:35:19PM +0100, Andrea Arcangeli wrote:
> This allows those get_user_pages calls to pass FAULT_FLAG_ALLOW_RETRY
> to the page fault in order to release the mmap_sem during the I/O.
> 
> Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Reviewed-by: Peter Feiner <pfeiner@google.com>

> diff --git a/net/ceph/pagevec.c b/net/ceph/pagevec.c
> index 5550130..096d914 100644
> --- a/net/ceph/pagevec.c
> +++ b/net/ceph/pagevec.c
> @@ -23,17 +23,15 @@ struct page **ceph_get_direct_page_vector(const void __user *data,
>  	if (!pages)
>  		return ERR_PTR(-ENOMEM);
>  
> -	down_read(&current->mm->mmap_sem);
>  	while (got < num_pages) {
> -		rc = get_user_pages(current, current->mm,
> +		rc = get_user_pages_unlocked(current, current->mm,
>  		    (unsigned long)data + ((unsigned long)got * PAGE_SIZE),
> -		    num_pages - got, write_page, 0, pages + got, NULL);
> +		    num_pages - got, write_page, 0, pages + got);
>  		if (rc < 0)
>  			break;
>  		BUG_ON(rc == 0);
>  		got += rc;
>  	}
> -	up_read(&current->mm->mmap_sem);
>  	if (rc < 0)
>  		goto fail;
>  	return pages;

I spent a while looking at this to make sure that BUG_ON(rc == 0) won't
trigger. AFAICT, __get_user_pages_locked can't return 0 since __get_user_pages
only returns 0 when nonblocking is not NULL; when __get_user_pages_locked
calls __get_user_pages with nonblocking != NULL (i.e., the first call in the
body of the for(;;) loop) and __get_user_pages returns 0, then
__get_user_pages_locked will call __get_user_pages again with nonblocking ==
NULL.
