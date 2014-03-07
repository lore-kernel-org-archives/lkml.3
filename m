Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752306AbaCGC7J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 21:59:09 -0500
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:56523 "EHLO
	lgemrelse6q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752083AbaCGC6y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 21:58:54 -0500
X-Original-SENDERIP: 10.177.222.157
X-Original-MAILFROM: minchan@kernel.org
Date: Fri, 7 Mar 2014 11:58:52 +0900
From: Minchan Kim <minchan@kernel.org>
To: Laura Abbott <lauraa@codeaurora.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@suse.de>,
        Vlastimil Babka <vbabka@suse.cz>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: Re: [PATCHv2] mm/compaction: Break out of loop on !PageBuddy in
 isolate_freepages_block
Message-ID: <20140307025852.GC3787@bbox>
References: <1394130092-25440-1-git-send-email-lauraa@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1394130092-25440-1-git-send-email-lauraa@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 06, 2014 at 10:21:32AM -0800, Laura Abbott wrote:
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
> uses), if any pages in the range cannot be isolated,
> isolate_freepages_block should return failure 0. The current check keeps
> track of the total number of isolated pages and compares against the size
> of the range:
> 
>         if (strict && nr_strict_required > total_isolated)
>                 total_isolated = 0;
> 
> After taking the zone lock, if one of the pages in the range is not
> in the buddy allocator, we continue through the loop and do not
> increment total_isolated. If in the last iteration of the loop we isolate
> more than one page (e.g. last page needed is a higher order page), the
> check for total_isolated may pass and we fail to detect that a page was
> skipped. The fix is to bail out if the loop immediately if we are in
> strict mode. There's no benfit to continuing anyway since we need all
> pages to be isolated. Additionally, drop the error checking based on
> nr_strict_required and just check the pfn ranges. This matches with
> what isolate_freepages_range does.
> 
> Signed-off-by: Laura Abbott <lauraa@codeaurora.org>

Nice catch! stable stuff?
Acked-by: Minchan Kim <minchan@kernel.org>

-- 
Kind regards,
Minchan Kim
