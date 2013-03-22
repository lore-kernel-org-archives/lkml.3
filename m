Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753747Ab3CVAJF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 20:09:05 -0400
Received: from mail-ia0-f180.google.com ([209.85.210.180]:42299 "EHLO
	mail-ia0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751407Ab3CVAJD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 20:09:03 -0400
Message-ID: <514BA118.5000305@gmail.com>
Date: Fri, 22 Mar 2013 08:08:56 +0800
From: Will Huck <will.huckk@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Rik van Riel <riel@redhat.com>
CC: Michal Hocko <mhocko@suse.cz>, Mel Gorman <mgorman@suse.de>,
        Linux-MM <linux-mm@kvack.org>, Jiri Slaby <jslaby@suse.cz>,
        Valdis Kletnieks <Valdis.Kletnieks@vt.edu>,
        Zlatko Calusic <zcalusic@bitsync.net>,
        Johannes Weiner <hannes@cmpxchg.org>, dormando <dormando@rydia.net>,
        Satoru Moriya <satoru.moriya@hds.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 01/10] mm: vmscan: Limit the number of pages kswapd reclaims
 at each priority
References: <1363525456-10448-1-git-send-email-mgorman@suse.de> <1363525456-10448-2-git-send-email-mgorman@suse.de> <20130320161847.GD27375@dhcp22.suse.cz> <514A59CD.3040108@redhat.com>
In-Reply-To: <514A59CD.3040108@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rik,
On 03/21/2013 08:52 AM, Rik van Riel wrote:
> On 03/20/2013 12:18 PM, Michal Hocko wrote:
>> On Sun 17-03-13 13:04:07, Mel Gorman wrote:
>> [...]
>>> diff --git a/mm/vmscan.c b/mm/vmscan.c
>>> index 88c5fed..4835a7a 100644
>>> --- a/mm/vmscan.c
>>> +++ b/mm/vmscan.c
>>> @@ -2593,6 +2593,32 @@ static bool prepare_kswapd_sleep(pg_data_t 
>>> *pgdat, int order, long remaining,
>>>   }
>>>
>>>   /*
>>> + * kswapd shrinks the zone by the number of pages required to reach
>>> + * the high watermark.
>>> + */
>>> +static void kswapd_shrink_zone(struct zone *zone,
>>> +                   struct scan_control *sc,
>>> +                   unsigned long lru_pages)
>>> +{
>>> +    unsigned long nr_slab;
>>> +    struct reclaim_state *reclaim_state = current->reclaim_state;
>>> +    struct shrink_control shrink = {
>>> +        .gfp_mask = sc->gfp_mask,
>>> +    };
>>> +
>>> +    /* Reclaim above the high watermark. */
>>> +    sc->nr_to_reclaim = max(SWAP_CLUSTER_MAX, high_wmark_pages(zone));
>>
>> OK, so the cap is at high watermark which sounds OK to me, although I
>> would expect balance_gap being considered here. Is it not used
>> intentionally or you just wanted to have a reasonable upper bound?
>>
>> I am not objecting to that it just hit my eyes.
>
> This is the maximum number of pages to reclaim, not the point
> at which to stop reclaiming.

What's the difference between the maximum number of pages to reclaim and 
the point at which to stop reclaiming?

>
> I assume Mel chose this value because it guarantees that enough
> pages will have been freed, while also making sure that the value
> is scaled according to zone size (keeping pressure between zones
> roughly equal).
>

