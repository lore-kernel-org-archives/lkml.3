Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753613Ab3JaKPb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 06:15:31 -0400
Received: from cantor2.suse.de ([195.135.220.15]:56945 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750712Ab3JaKPa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 06:15:30 -0400
Date: Thu, 31 Oct 2013 10:15:25 +0000
From: Mel Gorman <mgorman@suse.de>
To: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        akpm@linux-foundation.org,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Subject: Re: [PATCH] mm: get rid of unnecessary pageblock scanning in
 setup_zone_migrate_reserve
Message-ID: <20131031101525.GT2400@suse.de>
References: <1382562092-15570-1-git-send-email-kosaki.motohiro@gmail.com>
 <20131030151904.GO2400@suse.de>
 <527169BB.8020104@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <527169BB.8020104@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 30, 2013 at 04:19:07PM -0400, KOSAKI Motohiro wrote:
> >@@ -3926,11 +3929,11 @@ static void setup_zone_migrate_reserve(struct zone *zone)
> >  	/*
> >  	 * Reserve blocks are generally in place to help high-order atomic
> >  	 * allocations that are short-lived. A min_free_kbytes value that
> >-	 * would result in more than 2 reserve blocks for atomic allocations
> >-	 * is assumed to be in place to help anti-fragmentation for the
> >-	 * future allocation of hugepages at runtime.
> >+	 * would result in more than MAX_MIGRATE_RESERVE_BLOCKS reserve blocks
> >+	 * for atomic allocations is assumed to be in place to help
> >+	 * anti-fragmentation for the future allocation of hugepages at runtime.
> >  	 */
> >-	reserve = min(2, reserve);
> >+	reserve = min(MAX_MIGRATE_RESERVE_BLOCKS, reserve);
> >
> >  	for (pfn = start_pfn; pfn < end_pfn; pfn += pageblock_nr_pages) {
> >  		if (!pfn_valid(pfn))
> >@@ -3956,6 +3959,7 @@ static void setup_zone_migrate_reserve(struct zone *zone)
> >  			/* If this block is reserved, account for it */
> >  			if (block_migratetype == MIGRATE_RESERVE) {
> >  				reserve--;
> >+				found++;
> >  				continue;
> >  			}
> >
> >@@ -3970,6 +3974,10 @@ static void setup_zone_migrate_reserve(struct zone *zone)
> >  			}
> >  		}
> >
> >+		/* If all possible reserve blocks have been found, we're done */
> >+		if (found >= MAX_MIGRATE_RESERVE_BLOCKS)
> >+			break;
> >+
> >  		/*
> >  		 * If the reserve is met and this is a previous reserved block,
> >  		 * take it back
> 
> Nit. I would like to add following hunk. This is just nit because moving
> reserve pageblock is extreme rare.
> 
> 		if (block_migratetype == MIGRATE_RESERVE) {
> +                       found++;
> 			set_pageblock_migratetype(page, MIGRATE_MOVABLE);
> 			move_freepages_block(zone, page, MIGRATE_MOVABLE);
> 		}

I don't really see the advantage but if you think it is necessary then I
do not object either.

-- 
Mel Gorman
SUSE Labs
