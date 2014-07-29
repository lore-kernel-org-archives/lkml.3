Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752576AbaG2BFi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 21:05:38 -0400
Received: from mail-ig0-f181.google.com ([209.85.213.181]:34495 "EHLO
	mail-ig0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751730AbaG2BFh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 21:05:37 -0400
Date: Mon, 28 Jul 2014 18:05:34 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Vlastimil Babka <vbabka@suse.cz>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-mm:;
Subject: Re: [PATCH v5 11/14] mm, compaction: skip buddy pages by their order
 in the migrate scanner
In-Reply-To: <1406553101-29326-12-git-send-email-vbabka@suse.cz>
Message-ID: <alpine.DEB.2.02.1407281804380.8998@chino.kir.corp.google.com>
References: <1406553101-29326-1-git-send-email-vbabka@suse.cz> <1406553101-29326-12-git-send-email-vbabka@suse.cz>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Jul 2014, Vlastimil Babka wrote:

> The migration scanner skips PageBuddy pages, but does not consider their order
> as checking page_order() is generally unsafe without holding the zone->lock,
> and acquiring the lock just for the check wouldn't be a good tradeoff.
> 
> Still, this could avoid some iterations over the rest of the buddy page, and
> if we are careful, the race window between PageBuddy() check and page_order()
> is small, and the worst thing that can happen is that we skip too much and miss
> some isolation candidates. This is not that bad, as compaction can already fail
> for many other reasons like parallel allocations, and those have much larger
> race window.
> 
> This patch therefore makes the migration scanner obtain the buddy page order
> and use it to skip the whole buddy page, if the order appears to be in the
> valid range.
> 
> It's important that the page_order() is read only once, so that the value used
> in the checks and in the pfn calculation is the same. But in theory the
> compiler can replace the local variable by multiple inlines of page_order().
> Therefore, the patch introduces page_order_unsafe() that uses ACCESS_ONCE to
> prevent this.
> 
> Testing with stress-highalloc from mmtests shows a 15% reduction in number of
> pages scanned by migration scanner. The reduction is >60% with __GFP_NO_KSWAPD
> allocations, along with success rates better by few percent.
> This change is also a prerequisite for a later patch which is detecting when
> a cc->order block of pages contains non-buddy pages that cannot be isolated,
> and the scanner should thus skip to the next block immediately.
> 
> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
> Reviewed-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
> Acked-by: Minchan Kim <minchan@kernel.org>
> Acked-by: Mel Gorman <mgorman@suse.de>
> Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
> Cc: Michal Nazarewicz <mina86@mina86.com>
> Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
> Cc: Christoph Lameter <cl@linux.com>
> Cc: Rik van Riel <riel@redhat.com>
> Cc: David Rientjes <rientjes@google.com>

Acked-by: David Rientjes <rientjes@google.com>

Seems I'm overruled in the definition of page_order_unsafe().  Owell, you 
have more than one caller so I guess it makes sense.
