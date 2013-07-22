Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757256Ab3GVUVQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 16:21:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14930 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756932Ab3GVUVP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 16:21:15 -0400
Message-ID: <51ED9433.60707@redhat.com>
Date: Mon, 22 Jul 2013 16:21:07 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Johannes Weiner <hannes@cmpxchg.org>
CC: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@suse.de>,
        Andrea Arcangeli <aarcange@redhat.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch 3/3] mm: page_alloc: fair zone allocator policy
References: <1374267325-22865-1-git-send-email-hannes@cmpxchg.org> <1374267325-22865-4-git-send-email-hannes@cmpxchg.org>
In-Reply-To: <1374267325-22865-4-git-send-email-hannes@cmpxchg.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/19/2013 04:55 PM, Johannes Weiner wrote:

> @@ -1984,7 +1992,8 @@ this_zone_full:
>   		goto zonelist_scan;
>   	}
>
> -	if (page)
> +	if (page) {
> +		atomic_sub(1U << order, &zone->alloc_batch);
>   		/*
>   		 * page->pfmemalloc is set when ALLOC_NO_WATERMARKS was
>   		 * necessary to allocate the page. The expectation is

Could this be moved into the slow path in buffered_rmqueue and
rmqueue_bulk, or would the effect of ignoring the pcp buffers be
too detrimental to keeping the balance between zones?

It would be kind of nice to not have this atomic operation on every
page allocation...

As a side benefit, higher-order buffered_rmqueue and rmqueue_bulk
both happen under the zone->lock, so moving this accounting down
to that layer might allow you to get rid of the atomics alltogether.

I like the overall approach though. This is something Linux has needed
for a long time, and could be extremely useful to automatic NUMA
balancing as well...

-- 
All rights reversed
