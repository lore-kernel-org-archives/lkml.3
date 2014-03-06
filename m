Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752640AbaCFKW3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 05:22:29 -0500
Received: from cantor2.suse.de ([195.135.220.15]:51079 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752461AbaCFKW0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 05:22:26 -0500
Message-ID: <53184C5F.1080406@suse.cz>
Date: Thu, 06 Mar 2014 11:22:23 +0100
From: Vlastimil Babka <vbabka@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Laura Abbott <lauraa@codeaurora.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mgorman@suse.de>
CC: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: Re: [PATCH] mm/compaction: Break out of loop on !PageBuddy in isolate_freepages_block
References: <1394072800-11776-1-git-send-email-lauraa@codeaurora.org>
In-Reply-To: <1394072800-11776-1-git-send-email-lauraa@codeaurora.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/06/2014 03:26 AM, Laura Abbott wrote:
> We received several reports of bad page state when freeing CMA pages
> previously allocated with alloc_contig_range:
>
> <1>[ 1258.084111] BUG: Bad page state in process Binder_A  pfn:63202
> <1>[ 1258.089763] page:d21130b0 count:0 mapcount:1 mapping:  (null) index:0x7dfbf
> <1>[ 1258.096109] page flags: 0x40080068(uptodate|lru|active|swapbacked)
>
> Based on the page state, it looks like the page was still in use. The page
> flags do not make sense for the use case though. Further debugging showed
> that despite alloc_contig_range returning success, at least one page in the
> range still remained in the buddy allocator.
>
> There is an issue with isolate_freepages_block. In strict mode (which CMA
> uses), if any pages in the range cannot be isolated, isolate_freepages_block
> should return failure 0. The current check keeps track of the total number
> of isolated pages and compares against the size of the range:
>
>          if (strict && nr_strict_required > total_isolated)
>                  total_isolated = 0;
>
> After taking the zone lock, if one of the pages in the range is not
> in the buddy allocator, we continue through the loop and do not

> increment total_isolated. If we end up over isolating by more than
> one page (e.g. last since page needed is a higher order page), it
> is not possible to detect that the page was skipped. The fix is to

I found it hard to grasp this sentence at first. Perhaps something like 
"if in the last iteration of the loop we isolate more than one page 
(e.g. ...), the check for total_isolated may pass and we fail to detect 
that a page was skipped" would be better?

> bail out if the loop immediately if we are in strict mode. There's
> no benfit to continuing anyway since we need all pages to be
> isolated.

That looks sound , but I wonder if it makes sense to keep the 
nr_strict_required stuff after this change. The check could then simply 
use 'if (pfn < end_pfn)' the same way as isolate_freepages_range does, 
right?

> Signed-off-by: Laura Abbott <lauraa@codeaurora.org>
> ---
>   mm/compaction.c |   25 +++++++++++++++++++------
>   1 files changed, 19 insertions(+), 6 deletions(-)
>
> diff --git a/mm/compaction.c b/mm/compaction.c
> index b48c525..3190cef 100644
> --- a/mm/compaction.c
> +++ b/mm/compaction.c
> @@ -263,12 +263,21 @@ static unsigned long isolate_freepages_block(struct compact_control *cc,
>   		struct page *page = cursor;
>
>   		nr_scanned++;
> -		if (!pfn_valid_within(blockpfn))
> -			continue;
> +		if (!pfn_valid_within(blockpfn)) {
> +			if (strict)
> +				break;
> +			else
> +				continue;
> +		}
> +
>   		if (!valid_page)
>   			valid_page = page;
> -		if (!PageBuddy(page))
> -			continue;
> +		if (!PageBuddy(page)) {
> +			if (strict)
> +				break;
> +			else
> +				continue;
> +		}
>
>   		/*
>   		 * The zone lock must be held to isolate freepages.
> @@ -288,8 +297,12 @@ static unsigned long isolate_freepages_block(struct compact_control *cc,
>   			break;
>
>   		/* Recheck this is a buddy page under lock */
> -		if (!PageBuddy(page))
> -			continue;
> +		if (!PageBuddy(page)) {
> +			if (strict)
> +				break;
> +			else
> +				continue;
> +		}

To avoid this triple if-else occurence, you could instead do a "goto 
isolate_failed;" and put the if-else under said label at the end of the 
loop, also allowing extra cleanup, something like this:

@@ -298,8 +298,6 @@ static unsigned long isolate_freepages_block(struct 
compact_control *cc,

                 /* Found a free page, break it into order-0 pages */
                 isolated = split_free_page(page);
-               if (!isolated && strict)
-                       break;
                 total_isolated += isolated;
                 for (i = 0; i < isolated; i++) {
                         list_add(&page->lru, freelist);
@@ -310,7 +308,13 @@ static unsigned long isolate_freepages_block(struct 
compact_control *cc,
                 if (isolated) {
                         blockpfn += isolated - 1;
                         cursor += isolated - 1;
+                       continue;
                 }
+isolate_fail:
+               if (strict)
+                       break;
+               else
+                       continue;


Thanks,
Vlastimil

>   		/* Found a free page, break it into order-0 pages */
>   		isolated = split_free_page(page);
>

