Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755018AbaHUWLS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 18:11:18 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54979 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754730AbaHUWLR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 18:11:17 -0400
Date: Thu, 21 Aug 2014 15:11:15 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: David Rientjes <rientjes@google.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Michal Nazarewicz <mina86@mina86.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Christoph Lameter <cl@linux.com>, Rik van Riel <riel@redhat.com>,
        Mel Gorman <mgorman@suse.de>, Minchan Kim <minchan@kernel.org>,
        Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Subject: Re: [PATCH v6 11/13] mm, compaction: skip buddy pages by their
 order in the migrate scanner
Message-Id: <20140821151115.bcc66c15d53f7dc89d1b9b73@linux-foundation.org>
In-Reply-To: <1407142524-2025-12-git-send-email-vbabka@suse.cz>
References: <1407142524-2025-1-git-send-email-vbabka@suse.cz>
	<1407142524-2025-12-git-send-email-vbabka@suse.cz>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon,  4 Aug 2014 10:55:22 +0200 Vlastimil Babka <vbabka@suse.cz> wrote:

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

What is this "later patch"?  Or is the changelog stale?
