Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753232Ab3IXBLJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 21:11:09 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:46414 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752583Ab3IXBLI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 21:11:08 -0400
X-AuditID: 9c93016f-b7bc8ae000004e6e-2c-5240e6aa14f5
Date: Tue, 24 Sep 2013 10:11:34 +0900
From: Minchan Kim <minchan@kernel.org>
To: Weijie Yang <weijie.yang@samsung.com>
Cc: akpm@linux-foundation.org, sjenning@linux.vnet.ibm.com, bob.liu@oracle.com,
        weijie.yang.kh@gmail.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        d.j.shin@samsung.com, heesub.shin@samsung.com,
        kyungmin.park@samsung.com, hau.chen@samsung.com,
        bifeng.tong@samsung.com, rui.xie@samsung.com
Subject: Re: [PATCH v3 0/3] mm/zswap bugfix: memory leaks and other problems
Message-ID: <20130924011134.GI17725@bbox>
References: <000001ceb835$f0899910$d19ccb30$%yang@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <000001ceb835$f0899910$d19ccb30$%yang@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 23, 2013 at 04:19:36PM +0800, Weijie Yang wrote:
> This patch series fix a few bugs in mm/zswap based on Linux-3.11.
> 
> v2 --> v3
> 	- keep GFP_KERNEL flag

Why do you drop this?

It's plain BUG. I read Bob's reply but it couldn't justify to let the pain
remain. First of all, let's fix it and better idea could come later.

> 
> v1 --> v2
> 	- free memory in zswap_frontswap_invalidate_area(in patch 1)
> 	- fix whitespace corruption (line wrapping)
> 	
> Corresponding mail thread: https://lkml.org/lkml/2013/8/18/59
> 
> These issues fixed/optimized are:
> 
>  1. memory leaks when re-swapon
>  
>  2. memory leaks when invalidate and reclaim occur concurrently
>  
>  3. avoid unnecessary page scanning
> 
> 
> Issues discussed in that mail thread NOT fixed as it happens rarely or
> not a big problem or controversial:
> 
>  1. a "theoretical race condition" when reclaim page
> When a handle alloced from zbud, zbud considers this handle is used
> validly by upper(zswap) and can be a candidate for reclaim. But zswap has
> to initialize it such as setting swapentry and adding it to rbtree.
> so there is a race condition, such as:
>  thread 0: obtain handle x from zbud_alloc
>  thread 1: zbud_reclaim_page is called
>  thread 1: callback zswap_writeback_entry to reclaim handle x
>  thread 1: get swpentry from handle x (it is random value now)
>  thread 1: bad thing may happen
>  thread 0: initialize handle x with swapentry
> 
> 2. frontswap_map bitmap not cleared after zswap reclaim
> Frontswap uses frontswap_map bitmap to track page in "backend" implementation,
> when zswap reclaim a page, the corresponding bitmap record is not cleared.
> 
> 3. the potential that zswap store and reclaim functions called recursively
> 
> 
>  mm/zswap.c |   28 ++++++++++++++++++++--------
>  1 file changed, 20 insertions(+), 8 deletions(-)
> 
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>

-- 
Kind regards,
Minchan Kim
