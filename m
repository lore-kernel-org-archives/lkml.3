Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752377Ab3JYJTz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Oct 2013 05:19:55 -0400
Received: from mail-wi0-f177.google.com ([209.85.212.177]:54004 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751377Ab3JYJTx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Oct 2013 05:19:53 -0400
Date: Fri, 25 Oct 2013 18:19:44 +0900
From: Minchan Kim <minchan@kernel.org>
To: Olav Haugan <ohaugan@codeaurora.org>
Cc: sjenning@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: zram/zsmalloc issues in very low memory conditions
Message-ID: <20131025091924.GA4970@gmail.com>
References: <526844E6.1080307@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <526844E6.1080307@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I had no enough time to think over your great questions since I should enjoy
in Edinburgh so if I miss something, Sorry!

On Wed, Oct 23, 2013 at 02:51:34PM -0700, Olav Haugan wrote:
> I am trying to use zram in very low memory conditions and I am having
> some issues. zram is in the reclaim path. So if the system is very low
> on memory the system is trying to reclaim pages by swapping out (in this
> case to zram). However, since we are very low on memory zram fails to
> get a page from zsmalloc and thus zram fails to store the page. We get
> into a cycle where the system is low on memory so it tries to swap out
> to get more memory but swap out fails because there is not enough memory
> in the system! The major problem I am seeing is that there does not seem
> to be a way for zram to tell the upper layers to stop swapping out

True. The zram is block device so at a moment, I don't want to make zram
swap-specific if it's possible.

> because the swap device is essentially "full" (since there is no more
> memory available for zram pages). Has anyone thought about this issue
> already and have ideas how to solve this or am I missing something and I
> should not be seeing this issue?

It's true. We might need feedback loop and it shoudn't be specific for
zram-swap. One think I can imagine is that we could move failed victim
pages into LRU active list when the swapout failed so VM will have more
weight for file pages than anon ones. For detail, you could see
AOP_WRITEPAGE_ACTIVATE and get_scan_count for detail.

The problem is it's on fs layer while zram is on block layer so what I
can think at a moment is follwing as

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 8ed1b77..c80b0b4 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -502,6 +502,8 @@ static pageout_t pageout(struct page *page, struct address_space *mapping,
                if (!PageWriteback(page)) {
                        /* synchronous write or broken a_ops? */
                        ClearPageReclaim(page);
+                       if (PageError(page))
+                               return PAGE_ACTIVATE;
                }
                trace_mm_vmscan_writepage(page, trace_reclaim_flags(page));
                inc_zone_page_state(page, NR_VMSCAN_WRITE);


It doesn't prevent swapout at all but it should throttle pick up anonymous
pages for reclaiming so file-backed pages will be preferred by VM so sometime,
zsmalloc succeed to allocate a free page and swapout will resume again.

> 
> I am also seeing a couple other issues that I was wondering whether
> folks have already thought about:
> 
> 1) The size of a swap device is statically computed when the swap device
> is turned on (nr_swap_pages). The size of zram swap device is dynamic
> since we are compressing the pages and thus the swap subsystem thinks
> that the zram swap device is full when it is not really full. Any
> plans/thoughts about the possibility of being able to update the size
> and/or the # of available pages in a swap device on the fly?

It's really good question. We could make zram's size bigger to prevent
such problem when you set zram's disksize from the beginning but in this case,
zram's meta(ie, struct table) size will be increased a bit. Is such memory
overhead is critical for you?

> 
> 2) zsmalloc fails when the page allocated is at physical address 0 (pfn
> = 0) since the handle returned from zsmalloc is encoded as (<PFN>,
> <obj_idx>) and thus the resulting handle will be 0 (since obj_idx starts
> at 0). zs_malloc returns the handle but does not distinguish between a
> valid handle of 0 and a failure to allocate. A possible solution to this
> would be to start the obj_idx at 1. Is this feasible?

I think it's doable.

> 
> Thanks,
> 
> Olav Haugan
> 
> -- 
> The Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
> hosted by The Linux Foundation

-- 
Kind regards,
Minchan Kim
