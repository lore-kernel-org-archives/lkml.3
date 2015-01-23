Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755857AbbAWTEg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 14:04:36 -0500
Received: from mx1.redhat.com ([209.132.183.28]:36000 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753402AbbAWTEe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 14:04:34 -0500
Message-ID: <54C29B2B.4070800@redhat.com>
Date: Fri, 23 Jan 2015 14:04:11 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Ebru Akagunduz <ebru.akagunduz@gmail.com>, linux-mm@kvack.org
CC: akpm@linux-foundation.org, kirill@shutemov.name, mhocko@suse.cz,
        mgorman@suse.de, rientjes@google.com, sasha.levin@oracle.com,
        hughd@google.com, hannes@cmpxchg.org, vbabka@suse.cz,
        linux-kernel@vger.kernel.org, aarcange@redhat.com
Subject: Re: [PATCH] mm: incorporate read-only pages into transparent huge
 pages
References: <1421999256-3881-1-git-send-email-ebru.akagunduz@gmail.com>
In-Reply-To: <1421999256-3881-1-git-send-email-ebru.akagunduz@gmail.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/23/2015 02:47 AM, Ebru Akagunduz wrote:

> @@ -2169,7 +2169,7 @@ static int __collapse_huge_page_isolate(struct vm_area_struct *vma,
>  		VM_BUG_ON_PAGE(!PageSwapBacked(page), page);
>  
>  		/* cannot use mapcount: can't collapse if there's a gup pin */
> -		if (page_count(page) != 1)
> +		if (page_count(page) != 1 + !!PageSwapCache(page))
>  			goto out;
>  		/*
>  		 * We can do it before isolate_lru_page because the
> @@ -2179,6 +2179,17 @@ static int __collapse_huge_page_isolate(struct vm_area_struct *vma,
>  		 */
>  		if (!trylock_page(page))
>  			goto out;
> +		if (!pte_write(pteval)) {
> +			if (PageSwapCache(page) && !reuse_swap_page(page)) {
> +					unlock_page(page);
> +					goto out;
> +			}
> +			/*
> +			 * Page is not in the swap cache, and page count is
> +			 * one (see above). It can be collapsed into a THP.
> +			 */
> +		}

Andrea pointed out a bug between the above two parts of
the patch.

In-between where we check page_count(page), and where we
check whether the page got added to the swap cache, the
page count may change, causing us to get into a race
condition with get_user_pages_fast, the pageout code, etc.

It is necessary to check the page count again right after
the trylock_page(page) above, to make sure it was not changed
while the page was not yet locked.

That second check should have a comment explaining that
the first "page_count(page) != 1 + !!PageSwapCache(page)"
check could be unsafe due to the page not yet locked,
so the check needs to be repeated. Maybe something along
the lines of:

     /* Re-check the page count with the page locked */
