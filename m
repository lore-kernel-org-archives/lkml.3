Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934641Ab3DKK3q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 06:29:46 -0400
Received: from mail-qc0-f170.google.com ([209.85.216.170]:53661 "EHLO
	mail-qc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761383Ab3DKK3p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 06:29:45 -0400
Message-ID: <51669091.5070406@gmail.com>
Date: Thu, 11 Apr 2013 18:29:37 +0800
From: Ric Mason <ric.masonn@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Mel Gorman <mgorman@suse.de>
CC: Joonsoo Kim <iamjoonsoo.kim@lge.com>, Linux-MM <linux-mm@kvack.org>,
        Jiri Slaby <jslaby@suse.cz>,
        Valdis Kletnieks <Valdis.Kletnieks@vt.edu>,
        Rik van Riel <riel@redhat.com>, Zlatko Calusic <zcalusic@bitsync.net>,
        Johannes Weiner <hannes@cmpxchg.org>, dormando <dormando@rydia.net>,
        Satoru Moriya <satoru.moriya@hds.com>, Michal Hocko <mhocko@suse.cz>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 08/10] mm: vmscan: Have kswapd shrink slab only once per
 priority
References: <1363525456-10448-1-git-send-email-mgorman@suse.de> <1363525456-10448-9-git-send-email-mgorman@suse.de> <20130409065325.GA4411@lge.com> <20130409111358.GB2002@suse.de> <20130410052142.GB5872@lge.com> <20130411100115.GJ3710@suse.de>
In-Reply-To: <20130411100115.GJ3710@suse.de>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mel,
On 04/11/2013 06:01 PM, Mel Gorman wrote:
> On Wed, Apr 10, 2013 at 02:21:42PM +0900, Joonsoo Kim wrote:
>>>>> @@ -2673,9 +2674,15 @@ static bool kswapd_shrink_zone(struct zone *zone,
>>>>>   	sc->nr_to_reclaim = max(SWAP_CLUSTER_MAX, high_wmark_pages(zone));
>>>>>   	shrink_zone(zone, sc);
>>>>>   
>>>>> -	reclaim_state->reclaimed_slab = 0;
>>>>> -	nr_slab = shrink_slab(&shrink, sc->nr_scanned, lru_pages);
>>>>> -	sc->nr_reclaimed += reclaim_state->reclaimed_slab;
>>>>> +	/*
>>>>> +	 * Slabs are shrunk for each zone once per priority or if the zone
>>>>> +	 * being balanced is otherwise unreclaimable
>>>>> +	 */
>>>>> +	if (shrinking_slab || !zone_reclaimable(zone)) {
>>>>> +		reclaim_state->reclaimed_slab = 0;
>>>>> +		nr_slab = shrink_slab(&shrink, sc->nr_scanned, lru_pages);
>>>>> +		sc->nr_reclaimed += reclaim_state->reclaimed_slab;
>>>>> +	}
>>>>>   
>>>>>   	if (nr_slab == 0 && !zone_reclaimable(zone))
>>>>>   		zone->all_unreclaimable = 1;
>>>> Why shrink_slab() is called here?
>>> Preserves existing behaviour.
>> Yes, but, with this patch, existing behaviour is changed, that is, we call
>> shrink_slab() once per priority. For now, there is no reason this function
>> is called here. How about separating it and executing it outside of
>> zone loop?
>>
> We are calling it fewer times but it's still receiving the same information
> from sc->nr_scanned it received before. With the change you are suggesting
> it would be necessary to accumulating sc->nr_scanned for each zone shrunk
> and then pass the sum to shrink_slab() once per priority. While this is not
> necessarily wrong, there is little or no motivation to alter the shrinkers
> in this manner in this series.

Why the result is not the same?


