Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754693Ab3J3UTM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 16:19:12 -0400
Received: from mail-yh0-f44.google.com ([209.85.213.44]:47110 "EHLO
	mail-yh0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752698Ab3J3UTK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 16:19:10 -0400
Message-ID: <527169BB.8020104@gmail.com>
Date: Wed, 30 Oct 2013 16:19:07 -0400
From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Mel Gorman <mgorman@suse.de>
CC: kosaki.motohiro@gmail.com, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, akpm@linux-foundation.org,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Subject: Re: [PATCH] mm: get rid of unnecessary pageblock scanning in setup_zone_migrate_reserve
References: <1382562092-15570-1-git-send-email-kosaki.motohiro@gmail.com> <20131030151904.GO2400@suse.de>
In-Reply-To: <20131030151904.GO2400@suse.de>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> @@ -3926,11 +3929,11 @@ static void setup_zone_migrate_reserve(struct zone *zone)
>   	/*
>   	 * Reserve blocks are generally in place to help high-order atomic
>   	 * allocations that are short-lived. A min_free_kbytes value that
> -	 * would result in more than 2 reserve blocks for atomic allocations
> -	 * is assumed to be in place to help anti-fragmentation for the
> -	 * future allocation of hugepages at runtime.
> +	 * would result in more than MAX_MIGRATE_RESERVE_BLOCKS reserve blocks
> +	 * for atomic allocations is assumed to be in place to help
> +	 * anti-fragmentation for the future allocation of hugepages at runtime.
>   	 */
> -	reserve = min(2, reserve);
> +	reserve = min(MAX_MIGRATE_RESERVE_BLOCKS, reserve);
>
>   	for (pfn = start_pfn; pfn < end_pfn; pfn += pageblock_nr_pages) {
>   		if (!pfn_valid(pfn))
> @@ -3956,6 +3959,7 @@ static void setup_zone_migrate_reserve(struct zone *zone)
>   			/* If this block is reserved, account for it */
>   			if (block_migratetype == MIGRATE_RESERVE) {
>   				reserve--;
> +				found++;
>   				continue;
>   			}
>
> @@ -3970,6 +3974,10 @@ static void setup_zone_migrate_reserve(struct zone *zone)
>   			}
>   		}
>
> +		/* If all possible reserve blocks have been found, we're done */
> +		if (found >= MAX_MIGRATE_RESERVE_BLOCKS)
> +			break;
> +
>   		/*
>   		 * If the reserve is met and this is a previous reserved block,
>   		 * take it back

Nit. I would like to add following hunk. This is just nit because moving
reserve pageblock is extreme rare.

		if (block_migratetype == MIGRATE_RESERVE) {
+                       found++;
			set_pageblock_migratetype(page, MIGRATE_MOVABLE);
			move_freepages_block(zone, page, MIGRATE_MOVABLE);
		}



