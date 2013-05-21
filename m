Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752792Ab3EUUtz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 16:49:55 -0400
Received: from www.sr71.net ([198.145.64.142]:45073 "EHLO blackbird.sr71.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750897Ab3EUUty (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 16:49:54 -0400
Message-ID: <519BDDEF.9020705@sr71.net>
Date: Tue, 21 May 2013 13:49:51 -0700
From: Dave Hansen <dave@sr71.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
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
Subject: Re: [PATCHv4 17/39] thp, mm: handle tail pages in page_cache_get_speculative()
References: <1368321816-17719-1-git-send-email-kirill.shutemov@linux.intel.com> <1368321816-17719-18-git-send-email-kirill.shutemov@linux.intel.com>
In-Reply-To: <1368321816-17719-18-git-send-email-kirill.shutemov@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/11/2013 06:23 PM, Kirill A. Shutemov wrote:
> From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
> 
> For tail page we call __get_page_tail(). It has the same semantics, but
> for tail page.

page_cache_get_speculative() has a ~50-line comment above it with lots
of scariness about grace periods and RCU.  A two line comment saying
that the semantics are the same doesn't make me feel great that you've
done your homework here.

Are there any performance implications here?  __get_page_tail() says:
"It implements the slow path of get_page().".
page_cache_get_speculative() seems awfully speculative which would make
me think that it is part of a _fast_ path.

> diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
> index 28597ec..2e86251 100644
> --- a/include/linux/pagemap.h
> +++ b/include/linux/pagemap.h
> @@ -161,6 +161,9 @@ static inline int page_cache_get_speculative(struct page *page)
>  {
>  	VM_BUG_ON(in_interrupt());
>  
> +	if (unlikely(PageTail(page)))
> +		return __get_page_tail(page);
> +
>  #ifdef CONFIG_TINY_RCU
>  # ifdef CONFIG_PREEMPT_COUNT
>  	VM_BUG_ON(!in_atomic());
> @@ -187,7 +190,6 @@ static inline int page_cache_get_speculative(struct page *page)
>  		return 0;
>  	}
>  #endif
> -	VM_BUG_ON(PageTail(page));
>  
>  	return 1;
>  }

FWIW, that VM_BUG_ON() should theoretically be able to stay there since
it's unreachable now that you've short-circuited the function for
PageTail() pages.

