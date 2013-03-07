Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933238Ab3CGSyx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 13:54:53 -0500
Received: from mail-pb0-f41.google.com ([209.85.160.41]:48132 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755963Ab3CGSyv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 13:54:51 -0500
Date: Thu, 7 Mar 2013 10:54:15 -0800 (PST)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH] mm: page_alloc: remove branch operation in
 free_pages_prepare()
In-Reply-To: <1362644480-18381-1-git-send-email-iamjoonsoo.kim@lge.com>
Message-ID: <alpine.LNX.2.00.1303071050080.6087@eggly.anvils>
References: <1362644480-18381-1-git-send-email-iamjoonsoo.kim@lge.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 7 Mar 2013, Joonsoo Kim wrote:

> When we found that the flag has a bit of PAGE_FLAGS_CHECK_AT_PREP,
> we reset the flag. If we always reset the flag, we can reduce one
> branch operation. So remove it.
> 
> Cc: Hugh Dickins <hughd@google.com>
> Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>

I don't object to this patch.  But certainly I would have written it
that way in order not to dirty a cacheline unnecessarily.  It may be
obvious to you that the cacheline in question is almost always already
dirty, and the branch almost always more expensive.  But I'll leave that
to you, and to those who know more about these subtle costs than I do.

Hugh

> 
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 8fcced7..778f2a9 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -614,8 +614,7 @@ static inline int free_pages_check(struct page *page)
>  		return 1;
>  	}
>  	page_nid_reset_last(page);
> -	if (page->flags & PAGE_FLAGS_CHECK_AT_PREP)
> -		page->flags &= ~PAGE_FLAGS_CHECK_AT_PREP;
> +	page->flags &= ~PAGE_FLAGS_CHECK_AT_PREP;
>  	return 0;
>  }
>  
