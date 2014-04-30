Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759556AbaD3UyX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 16:54:23 -0400
Received: from mta-out1.inet.fi ([62.71.2.199]:33308 "EHLO jenni2.inet.fi"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759165AbaD3UyW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 16:54:22 -0400
Date: Wed, 30 Apr 2014 23:54:08 +0300
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: Jianyu Zhan <nasa4836@gmail.com>
Cc: akpm@linux-foundation.org, hannes@cmpxchg.org, riel@redhat.com,
        mgorman@suse.de, aarcange@redhat.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] mm/swap.c: split put_compound_page function
Message-ID: <20140430205408.GB27455@node.dhcp.inet.fi>
References: <b1987d6fb09745a5274895efbde79e37ff9557a3.1398764420.git.nasa4836@gmail.com>
 <1fc028045336844fe9ba9ee27c406e6ebe4726f4.1398764420.git.nasa4836@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1fc028045336844fe9ba9ee27c406e6ebe4726f4.1398764420.git.nasa4836@gmail.com>
User-Agent: Mutt/1.5.22.1-rc1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 29, 2014 at 05:42:28PM +0800, Jianyu Zhan wrote:
> Currently, put_compound_page should carefully handle tricky case
> to avoid racing with compound page releasing or spliting, which
> makes it growing quite lenthy(about 200+ lines) and need deep
> tab indention, which makes it quite hard to follow and maintain.
> 
> Now based on two helpers introduced in the previous patch
> ("mm/swap.c: introduce put_[un]refcounted_compound_page helpers
> for spliting put_compound_page"), this patch just replaces those
> two lenthy code path with these two helpers, respectively.
> Also, it has some comment rephrasing.
> 
> After this patch, the put_compound_page() will be very compact,
> thus easy to read and maintain.
> 
> After spliting, the object file is of same size as the original one.
> Actually, I've diff'ed put_compound_page()'s orginal disassemble code
> and the patched disassemble code, the are 100% the same!
> 
> This fact shows that this spliting has no functinal change,
> but it brings readability.
> 
> This patch and the previous one blow the code by 32 lines, which
> mostly credits to comments.
> 
> Signed-off-by: Jianyu Zhan <nasa4836@gmail.com>
> ---
>  mm/swap.c | 142 +++++++-------------------------------------------------------
>  1 file changed, 16 insertions(+), 126 deletions(-)
> 
> diff --git a/mm/swap.c b/mm/swap.c
> index a576449..d8654d8 100644
> --- a/mm/swap.c
> +++ b/mm/swap.c
> @@ -225,6 +225,11 @@ static void put_compound_page(struct page *page)
>  {
>  	struct page *page_head;
>  
> +	/*
> +	 * We see the PageCompound set and PageTail not set, so @page maybe:
> +	 *  1. hugetlbfs head page, or
> +	 *  2. THP head page.

3. Head of slab compound page.

> +	 */
>  	if (likely(!PageTail(page))) {
>  		if (put_page_testzero(page)) {
>  			/*
> @@ -239,135 +244,20 @@ static void put_compound_page(struct page *page)
>  		return;
>  	}
>  

...

> +	 * We see the PageCompound set and PageTail set, so @page maybe:
> +	 *  1. a tail hugetlbfs page, or
> +	 *  2. a tail THP page, or
> +	 *  3. a split THP page.

4. Tail of slab compound page

-- 
 Kirill A. Shutemov
