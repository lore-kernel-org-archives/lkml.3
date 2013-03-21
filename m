Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756299Ab3CUQN7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 12:13:59 -0400
Received: from www.sr71.net ([198.145.64.142]:50529 "EHLO blackbird.sr71.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756197Ab3CUQN4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 12:13:56 -0400
Message-ID: <514B320C.4030507@sr71.net>
Date: Thu, 21 Mar 2013 09:15:08 -0700
From: Dave Hansen <dave@sr71.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
CC: Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>, Hugh Dickins <hughd@google.com>,
        Wu Fengguang <fengguang.wu@intel.com>, Jan Kara <jack@suse.cz>,
        Mel Gorman <mgorman@suse.de>, linux-mm@kvack.org,
        Andi Kleen <ak@linux.intel.com>,
        Matthew Wilcox <matthew.r.wilcox@intel.com>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Hillf Danton <dhillf@gmail.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv2, RFC 05/30] thp, mm: avoid PageUnevictable on active/inactive
 lru lists
References: <1363283435-7666-1-git-send-email-kirill.shutemov@linux.intel.com> <1363283435-7666-6-git-send-email-kirill.shutemov@linux.intel.com>
In-Reply-To: <1363283435-7666-6-git-send-email-kirill.shutemov@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/14/2013 10:50 AM, Kirill A. Shutemov wrote:
> active/inactive lru lists can contain unevicable pages (i.e. ramfs pages
> that have been placed on the LRU lists when first allocated), but these
> pages must not have PageUnevictable set - otherwise shrink_active_list
> goes crazy:
...
> For lru_add_page_tail(), it means we should not set PageUnevictable()
> for tail pages unless we're sure that it will go to LRU_UNEVICTABLE.
> The tail page will go LRU_UNEVICTABLE if head page is not on LRU or if
> it's marked PageUnevictable() too.

This is only an issue once you're using lru_add_page_tail() for
non-anonymous pages, right?

> diff --git a/mm/swap.c b/mm/swap.c
> index 92a9be5..31584d0 100644
> --- a/mm/swap.c
> +++ b/mm/swap.c
> @@ -762,7 +762,8 @@ void lru_add_page_tail(struct page *page, struct page *page_tail,
>  			lru = LRU_INACTIVE_ANON;
>  		}
>  	} else {
> -		SetPageUnevictable(page_tail);
> +		if (!PageLRU(page) || PageUnevictable(page))
> +			SetPageUnevictable(page_tail);
>  		lru = LRU_UNEVICTABLE;
>  	}

You were saying above that ramfs pages can get on the normal
active/inactive lists.  But, this will end up getting them on the
unevictable list, right?  So, we have normal ramfs pages on the
active/inactive lists, but ramfs pages after a huge-page-split on the
unevictable list.  That seems a bit inconsistent.
