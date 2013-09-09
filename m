Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754960Ab3IIQ3g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 12:29:36 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:49637 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754782Ab3IIQ3f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 12:29:35 -0400
Date: Mon, 9 Sep 2013 11:28:15 -0500
From: Seth Jennings <sjenning@linux.vnet.ibm.com>
To: Weijie Yang <weijie.yang@samsung.com>
Cc: minchan@kernel.org, bob.liu@oracle.com, weijie.yang.kh@gmail.com,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/4] mm/zswap: bugfix: memory leak when invalidate and
 reclaim occur concurrently
Message-ID: <20130909162815.GA4701@variantweb.net>
References: <000801ceaac0$8d1f6210$a75e2630$%yang@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <000801ceaac0$8d1f6210$a75e2630$%yang@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13090916-7182-0000-0000-000008573DF2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 06, 2013 at 01:16:45PM +0800, Weijie Yang wrote:
> Consider the following scenario:
> thread 0: reclaim entry x (get refcount, but not call zswap_get_swap_cache_page)
> thread 1: call zswap_frontswap_invalidate_page to invalidate entry x.
> 	finished, entry x and its zbud is not freed as its refcount != 0
> 	now, the swap_map[x] = 0
> thread 0: now call zswap_get_swap_cache_page
> 	swapcache_prepare return -ENOENT because entry x is not used any more
> 	zswap_get_swap_cache_page return ZSWAP_SWAPCACHE_NOMEM
> 	zswap_writeback_entry do nothing except put refcount
> Now, the memory of zswap_entry x and its zpage leak.
> 
> Modify:
> - check the refcount in fail path, free memory if it is not referenced.
> - use ZSWAP_SWAPCACHE_FAIL instead of ZSWAP_SWAPCACHE_NOMEM as the fail path
> can be not only caused by nomem but also by invalidate.
> 
> Signed-off-by: Weijie Yang <weijie.yang@samsung.com>

Thanks!

Acked-by: Seth Jennings <sjenning@linux.vnet.ibm.com>

Seth

