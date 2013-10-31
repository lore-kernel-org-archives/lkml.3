Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752410Ab3JaFPm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 01:15:42 -0400
Received: from mail-qe0-f49.google.com ([209.85.128.49]:59918 "EHLO
	mail-qe0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751563Ab3JaFPl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 01:15:41 -0400
Message-ID: <5271E77A.7080701@gmail.com>
Date: Thu, 31 Oct 2013 01:15:38 -0400
From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: linux-mm@kvack.org, akpm@linux-foundation.org,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Mel Gorman <mgorman@suse.de>
Subject: Re: [PATCH] mm: __rmqueue_fallback() should respect pageblock type
References: <1383193489-27331-1-git-send-email-kosaki.motohiro@gmail.com>
In-Reply-To: <1383193489-27331-1-git-send-email-kosaki.motohiro@gmail.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(10/31/13 12:24 AM), kosaki.motohiro@gmail.com wrote:
> From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> 
> When __rmqueue_fallback() don't find out a free block with the same size
> of required, it splits a larger page and puts back rest peiece of the page
> to free list.
> 
> But it has one serious mistake. When putting back, __rmqueue_fallback()
> always use start_migratetype if type is not CMA. However, __rmqueue_fallback()
> is only called when all of start_migratetype queue are empty. That said,
> __rmqueue_fallback always put back memory to wrong queue except
> try_to_steal_freepages() changed pageblock type (i.e. requested size is
> smaller than half of page block). Finally, antifragmentation framework
> increase fragmenation instead of decrease.
> 
> Mel's original anti fragmentation do the right thing. But commit 47118af076
> (mm: mmzone: MIGRATE_CMA migration type added) broke it.
> 
> This patch restores sane and old behavior.
> 
> Cc: Mel Gorman <mgorman@suse.de>
> Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> ---
>   mm/page_alloc.c |    2 +-
>   1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index dd886fa..ea7bb9a 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -1101,7 +1101,7 @@ __rmqueue_fallback(struct zone *zone, int order, int start_migratetype)
>   			 */
>   			expand(zone, page, order, current_order, area,
>   			       is_migrate_cma(migratetype)
> -			     ? migratetype : start_migratetype);
> +			     ? migratetype : new_type);

Oops, this can be simplified to following because try_to_steal_freepages() has cma check.


-                       expand(zone, page, order, current_order, area,
-                              is_migrate_cma(migratetype)
-                            ? migratetype : start_migratetype);
+                       expand(zone, page, order, current_order, area, new_type);



