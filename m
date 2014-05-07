Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755943AbaEGMKs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 08:10:48 -0400
Received: from cantor2.suse.de ([195.135.220.15]:60189 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751358AbaEGMKr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 08:10:47 -0400
Message-ID: <536A22C5.6060704@suse.cz>
Date: Wed, 07 May 2014 14:10:45 +0200
From: Vlastimil Babka <vbabka@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>,
        Andrew Morton <akpm@linux-foundation.org>
CC: Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>, Greg Thelen <gthelen@google.com>,
        Hugh Dickins <hughd@google.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [patch v3 6/6] mm, compaction: terminate async compaction when
 rescheduling
References: <alpine.DEB.2.02.1404301744110.8415@chino.kir.corp.google.com> <alpine.DEB.2.02.1405011434140.23898@chino.kir.corp.google.com> <alpine.DEB.2.02.1405061920470.18635@chino.kir.corp.google.com> <alpine.DEB.2.02.1405061922220.18635@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.02.1405061922220.18635@chino.kir.corp.google.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/07/2014 04:22 AM, David Rientjes wrote:
> Async compaction terminates prematurely when need_resched(), see
> compact_checklock_irqsave().  This can never trigger, however, if the
> cond_resched() in isolate_migratepages_range() always takes care of the
> scheduling.
>
> If the cond_resched() actually triggers, then terminate this pageblock scan for
> async compaction as well.
>
> Signed-off-by: David Rientjes <rientjes@google.com>

Acked-by: Vlastimil Babka <vbabka@suse.cz>

> ---
>   mm/compaction.c | 7 ++++++-
>   1 file changed, 6 insertions(+), 1 deletion(-)
>
> diff --git a/mm/compaction.c b/mm/compaction.c
> --- a/mm/compaction.c
> +++ b/mm/compaction.c
> @@ -500,8 +500,13 @@ isolate_migratepages_range(struct zone *zone, struct compact_control *cc,
>   			return 0;
>   	}
>
> +	if (cond_resched()) {
> +		/* Async terminates prematurely on need_resched() */
> +		if (cc->mode == MIGRATE_ASYNC)
> +			return 0;
> +	}
> +
>   	/* Time to isolate some pages for migration */
> -	cond_resched();
>   	for (; low_pfn < end_pfn; low_pfn++) {
>   		/* give a chance to irqs before checking need_resched() */
>   		if (locked && !(low_pfn % SWAP_CLUSTER_MAX)) {
>

