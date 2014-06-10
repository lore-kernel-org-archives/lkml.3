Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933999AbaFJAIp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 20:08:45 -0400
Received: from mail-ie0-f175.google.com ([209.85.223.175]:43486 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933252AbaFJAIo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 20:08:44 -0400
Date: Mon, 9 Jun 2014 17:08:40 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Vlastimil Babka <vbabka@suse.cz>
cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Thelen <gthelen@google.com>, Minchan Kim <minchan@kernel.org>,
        Mel Gorman <mgorman@suse.de>, Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Michal Nazarewicz <mina86@mina86.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Christoph Lameter <cl@linux.com>, Rik van Riel <riel@redhat.com>
Subject: Re: [PATCH 06/10] mm, compaction: skip buddy pages by their order
 in the migrate scanner
In-Reply-To: <1402305982-6928-6-git-send-email-vbabka@suse.cz>
Message-ID: <alpine.DEB.2.02.1406091708240.17705@chino.kir.corp.google.com>
References: <1402305982-6928-1-git-send-email-vbabka@suse.cz> <1402305982-6928-6-git-send-email-vbabka@suse.cz>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 9 Jun 2014, Vlastimil Babka wrote:

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
> Preliminary results with stress-highalloc from mmtests show a 10% reduction in
> number of pages scanned by migration scanner. This change is also important to
> later allow detecting when a cc->order block of pages cannot be compacted, and
> the scanner should skip to the next block instead of wasting time.
> 
> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
> Cc: Minchan Kim <minchan@kernel.org>
> Cc: Mel Gorman <mgorman@suse.de>
> Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
> Cc: Michal Nazarewicz <mina86@mina86.com>
> Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
> Cc: Christoph Lameter <cl@linux.com>
> Cc: Rik van Riel <riel@redhat.com>
> Cc: David Rientjes <rientjes@google.com>
> ---
> V2: fix low_pfn > end_pfn check; comments
>     kept page_order_unsafe() approach for now
> 

Please see http://marc.info/?l=linux-mm&m=140235272808846, I'd love to be 
proved wrong.
