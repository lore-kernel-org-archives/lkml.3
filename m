Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753526Ab3IWWIL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 18:08:11 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:40019 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752406Ab3IWWIK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 18:08:10 -0400
Date: Mon, 23 Sep 2013 17:07:57 -0500
From: Seth Jennings <sjenning@linux.vnet.ibm.com>
To: Bob Liu <bob.liu@oracle.com>
Cc: Krzysztof Kozlowski <k.kozlowski@samsung.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mgorman@suse.de>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Dave Hansen <dave.hansen@intel.com>, Minchan Kim <minchan@kernel.org>
Subject: Re: [PATCH v2 0/5] mm: migrate zbud pages
Message-ID: <20130923220757.GC16191@variantweb.net>
References: <1378889944-23192-1-git-send-email-k.kozlowski@samsung.com>
 <5237FDCC.5010109@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5237FDCC.5010109@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13092322-9332-0000-0000-00000183B716
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 17, 2013 at 02:59:24PM +0800, Bob Liu wrote:
> Mel mentioned several problems about zswap/zbud in thread "[PATCH v6
> 0/5] zram/zsmalloc promotion".
> 
> Like "it's clunky as hell and the layering between zswap and zbud is
> twisty" and "I think I brought up its stalling behaviour during review
> when it was being merged. It would have been preferable if writeback
> could be initiated in batches and then waited on at the very least..
>  It's worse that it uses _swap_writepage directly instead of going
> through a writepage ops.  It would have been better if zbud pages
> existed on the LRU and written back with an address space ops and
> properly handled asynchonous writeback."
> 
> So I think it would be better if we can address those issues at first
> and it would be easier to address these issues before adding more new
> features. Welcome any ideas.

I just had an idea this afternoon to potentially kill both these birds with one
stone: Replace the rbtree in zswap with an address_space.

Each swap type would have its own page_tree to organize the compressed objects
by type and offset (radix tree is more suited for this anyway) and a_ops that
could be called by shrink_page_list() (writepage) or the migration code
(migratepage).

Then zbud pages could be put on the normal LRU list, maybe at the beginning of
the inactive LRU so they would live for another cycle through the list, then be
reclaimed in the normal way with the mapping->a_ops->writepage() pointing to a
zswap_writepage() function that would decompress the pages and call
__swap_writepage() on them.

This might actually do away with the explicit pool size too as the compressed
pool pages wouldn't be outside the control of the MM anymore.

I'm just starting to explore this but I think it has promise.

Seth

