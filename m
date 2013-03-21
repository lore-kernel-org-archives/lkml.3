Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755659Ab3CUCdP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 22:33:15 -0400
Received: from mail-da0-f47.google.com ([209.85.210.47]:44134 "EHLO
	mail-da0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752690Ab3CUCdO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 22:33:14 -0400
Message-ID: <514A7163.5070700@gmail.com>
Date: Thu, 21 Mar 2013 10:33:07 +0800
From: Simon Jeons <simon.jeons@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Mel Gorman <mgorman@suse.de>
CC: Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.cz>,
        Hedi Berriche <hedi@sgi.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: page_alloc: Avoid marking zones full prematurely
 after zone_reclaim()
References: <20130320181957.GA1878@suse.de>
In-Reply-To: <20130320181957.GA1878@suse.de>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mel,
On 03/21/2013 02:19 AM, Mel Gorman wrote:
> The following problem was reported against a distribution kernel when
> zone_reclaim was enabled but the same problem applies to the mainline
> kernel. The reproduction case was as follows
>
> 1. Run numactl -m +0 dd if=largefile of=/dev/null
>     This allocates a large number of clean pages in node 0

I confuse why this need allocate a large number of clean pages?

>
> 2. numactl -N +0 memhog 0.5*Mg
>     This start a memory-using application in node 0.
>
> The expected behaviour is that the clean pages get reclaimed and the
> application uses node 0 for its memory. The observed behaviour was that
> the memory for the memhog application was allocated off-node since commits
> cd38b11 (mm: page allocator: initialise ZLC for first zone eligible for
> zone_reclaim) and commit 76d3fbf (mm: page allocator: reconsider zones
> for allocation after direct reclaim).
>
> The assumption of those patches was that it was always preferable to
> allocate quickly than stall for long periods of time and they were
> meant to take care that the zone was only marked full when necessary but
> an important case was missed.
>
> In the allocator fast path, only the low watermarks are checked. If the
> zones free pages are between the low and min watermark then allocations
> from the allocators slow path will succeed. However, zone_reclaim
> will only reclaim SWAP_CLUSTER_MAX or 1<<order pages. There is no
> guarantee that this will meet the low watermark causing the zone to be
> marked full prematurely.
>
> This patch will only mark the zone full after zone_reclaim if it the min
> watermarks are checked or if page reclaim failed to make sufficient
> progress.
>
> Reported-and-tested-by: Hedi Berriche <hedi@sgi.com>
> Signed-off-by: Mel Gorman <mgorman@suse.de>
> ---
>   mm/page_alloc.c | 17 ++++++++++++++++-
>   1 file changed, 16 insertions(+), 1 deletion(-)
>
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 8fcced7..adce823 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -1940,9 +1940,24 @@ zonelist_scan:
>   				continue;
>   			default:
>   				/* did we reclaim enough */
> -				if (!zone_watermark_ok(zone, order, mark,
> +				if (zone_watermark_ok(zone, order, mark,
>   						classzone_idx, alloc_flags))
> +					goto try_this_zone;
> +
> +				/*
> +				 * Failed to reclaim enough to meet watermark.
> +				 * Only mark the zone full if checking the min
> +				 * watermark or if we failed to reclaim just
> +				 * 1<<order pages or else the page allocator
> +				 * fastpath will prematurely mark zones full
> +				 * when the watermark is between the low and
> +				 * min watermarks.
> +				 */
> +				if ((alloc_flags & ALLOC_WMARK_MIN) ||
> +				    ret == ZONE_RECLAIM_SOME)
>   					goto this_zone_full;
> +
> +				continue;
>   			}
>   		}
>   
>
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>

