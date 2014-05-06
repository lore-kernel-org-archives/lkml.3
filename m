Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757880AbaEFPa4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 11:30:56 -0400
Received: from cantor2.suse.de ([195.135.220.15]:40916 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752018AbaEFPaz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 11:30:55 -0400
Message-ID: <5369002D.7030600@suse.cz>
Date: Tue, 06 May 2014 17:30:53 +0200
From: Vlastimil Babka <vbabka@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Mel Gorman <mgorman@suse.de>, Linux-MM <linux-mm@kvack.org>,
        Linux-FSDevel <linux-fsdevel@vger.kernel.org>
CC: Johannes Weiner <hannes@cmpxchg.org>, Jan Kara <jack@suse.cz>,
        Michal Hocko <mhocko@suse.cz>, Hugh Dickins <hughd@google.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 15/17] mm: Do not use unnecessary atomic operations when
 adding pages to the LRU
References: <1398933888-4940-1-git-send-email-mgorman@suse.de> <1398933888-4940-16-git-send-email-mgorman@suse.de>
In-Reply-To: <1398933888-4940-16-git-send-email-mgorman@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/01/2014 10:44 AM, Mel Gorman wrote:
> When adding pages to the LRU we clear the active bit unconditionally. As the
> page could be reachable from other paths we cannot use unlocked operations
> without risk of corruption such as a parallel mark_page_accessed. This
> patch test if is necessary to clear the atomic flag before using an atomic

                                           active

> operation. In the unlikely even this races with mark_page_accesssed the
> consequences are simply that the page may be promoted to the active list
> that might have been left on the inactive list before the patch. This is
> a marginal consequence.

Well if this is racy, then even before the patch, mark_page_accessed 
might have come right after ClearPageActive(page) anyway? Or is the 
changelog saying that this change only extended the race window that 
already existed? If yes it could be more explicit, as now it might sound 
as if the race was introduced.

> Signed-off-by: Mel Gorman <mgorman@suse.de>
> ---
>   include/linux/swap.h | 6 ++++--
>   1 file changed, 4 insertions(+), 2 deletions(-)
>
> diff --git a/include/linux/swap.h b/include/linux/swap.h
> index da8a250..395dcab 100644
> --- a/include/linux/swap.h
> +++ b/include/linux/swap.h
> @@ -329,13 +329,15 @@ extern void add_page_to_unevictable_list(struct page *page);
>    */
>   static inline void lru_cache_add_anon(struct page *page)
>   {
> -	ClearPageActive(page);
> +	if (PageActive(page))
> +		ClearPageActive(page);
>   	__lru_cache_add(page);
>   }
>
>   static inline void lru_cache_add_file(struct page *page)
>   {
> -	ClearPageActive(page);
> +	if (PageActive(page))
> +		ClearPageActive(page);
>   	__lru_cache_add(page);
>   }
>
>

