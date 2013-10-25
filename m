Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752955Ab3JYKPj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Oct 2013 06:15:39 -0400
Received: from mail-we0-f171.google.com ([74.125.82.171]:46753 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752781Ab3JYKPh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Oct 2013 06:15:37 -0400
Date: Fri, 25 Oct 2013 19:15:32 +0900
From: Minchan Kim <minchan@kernel.org>
To: Weijie Yang <weijie.yang@samsung.com>
Cc: akpm@linux-foundation.org, sjennings@variantweb.net, bob.liu@oracle.com,
        weijie.yang.kh@gmail.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH RESEND 1/2] =?utf-8?Q?mm=2Fzswa?=
 =?utf-8?Q?p=3A_bugfix=3A_memory_leak_when_invalidate_and_reclaim_occur_co?=
 =?utf-8?Q?ncurrent=E2=80=8Bly?=
Message-ID: <20131025101532.GD6612@gmail.com>
References: <000001ced09e$e3718180$aa548480$%yang@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <000001ced09e$e3718180$aa548480$%yang@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 24, 2013 at 05:51:11PM +0800, Weijie Yang wrote:
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
>  - check the refcount in fail path, free memory if it is not referenced.
> 
>  - use ZSWAP_SWAPCACHE_FAIL instead of ZSWAP_SWAPCACHE_NOMEM as the fail path
>    can be not only caused by nomem but also by invalidate.
> 
> Signed-off-by: Weijie Yang <weijie.yang@samsung.com>
> Reviewed-by: Bob Liu <bob.liu@oracle.com>
> Cc: Minchan Kim <minchan@kernel.org>
> Cc: <stable@vger.kernel.org>
> Acked-by: Seth Jennings <sjenning@linux.vnet.ibm.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

Reviewed-by: Minchan Kim <minchan@kernel.org>

Thanks, Weijie!

-- 
Kind regards,
Minchan Kim
