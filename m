Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755656AbaJNU32 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 16:29:28 -0400
Received: from mga02.intel.com ([134.134.136.20]:54424 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754524AbaJNU31 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 16:29:27 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,719,1406617200"; 
   d="scan'208";a="618662211"
Date: Tue, 14 Oct 2014 13:29:55 -0700
From: David Cohen <david.a.cohen@linux.intel.com>
To: Yu Zhao <yuzhao@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        Ingo Molnar <mingo@kernel.org>, Hugh Dickins <hughd@google.com>,
        Sasha Levin <sasha.levin@oracle.com>, Bob Liu <lliubbo@gmail.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        David Rientjes <rientjes@google.com>, Vlastimil Babka <vbabka@suse.cz>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] mm: verify compound order when freeing a page
Message-ID: <20141014202955.GA2889@psi-dev26.jf.intel.com>
References: <1413317800-25450-1-git-send-email-yuzhao@google.com>
 <1413317800-25450-2-git-send-email-yuzhao@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1413317800-25450-2-git-send-email-yuzhao@google.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Yu,

On Tue, Oct 14, 2014 at 01:16:40PM -0700, Yu Zhao wrote:
> This allows us to easily catch the bug fixed in previous patch.

Is the word "previous" a good way to relate patches after merged?
Maybe you could either detail the bug here or be more verbose about the
patch you're referring.

> 
> Here we also verify whether a page is tail page or not -- tail
> pages are supposed to be freed along with their head, not by
> themselves.
> 
> Signed-off-by: Yu Zhao <yuzhao@google.com>
> ---
>  mm/page_alloc.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 736d8e1..2bcc770 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -750,6 +750,9 @@ static bool free_pages_prepare(struct page *page, unsigned int order)
>  	int i;
>  	int bad = 0;
>  
> +	VM_BUG_ON(PageTail(page));
> +	VM_BUG_ON(PageHead(page) && compound_order(page) != order);

It may be too severe. AFAIU we're not talking about a fatal error.
How about VM_WARN_ON()?

Br, David Cohen

> +
>  	trace_mm_page_free(page, order);
>  	kmemcheck_free_shadow(page, order);
>  
> -- 
> 2.1.0.rc2.206.gedb03e5
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
