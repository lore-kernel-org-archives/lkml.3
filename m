Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751742AbaBNDjr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 22:39:47 -0500
Received: from mail-ie0-f169.google.com ([209.85.223.169]:46229 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751050AbaBNDjp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 22:39:45 -0500
MIME-Version: 1.0
In-Reply-To: <52FCEE74.9010602@redhat.com>
References: <000001cf2865$0aa2c0c0$1fe84240$%yang@samsung.com>
	<52FCEE74.9010602@redhat.com>
Date: Fri, 14 Feb 2014 11:39:45 +0800
Message-ID: <CAL1ERfPhWbKRGr50Jq61gJ90zYhpMFN+T1tPNxJm0e1n31mcag@mail.gmail.com>
Subject: Re: [PATCH 1/2] mm/vmscan: restore sc->gfp_mask after promoting it to __GFP_HIGHMEM
From: Weijie Yang <weijie.yang.kh@gmail.com>
To: Rik van Riel <riel@redhat.com>
Cc: Weijie Yang <weijie.yang@samsung.com>, Mel Gorman <mgorman@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Minchan Kim <minchan@kernel.org>, Linux-MM <linux-mm@kvack.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 14, 2014 at 12:10 AM, Rik van Riel <riel@redhat.com> wrote:
> On 02/12/2014 09:39 PM, Weijie Yang wrote:
>
>> --- a/mm/vmscan.c
>> +++ b/mm/vmscan.c
>> @@ -2298,14 +2298,17 @@ static bool shrink_zones(struct zonelist *zonelist, struct scan_control *sc)
>>       unsigned long nr_soft_reclaimed;
>>       unsigned long nr_soft_scanned;
>>       bool aborted_reclaim = false;
>> +     bool promoted_mask = false;
>>
>>       /*
>>        * If the number of buffer_heads in the machine exceeds the maximum
>>        * allowed level, force direct reclaim to scan the highmem zone as
>>        * highmem pages could be pinning lowmem pages storing buffer_heads
>>        */
>> -     if (buffer_heads_over_limit)
>> +     if (buffer_heads_over_limit) {
>
> It took me a minute to figure out why you are doing things this way,
> so maybe this could use a comment, or maybe it could be done in a
> simpler way, by simply saving and restoring the original mask?
>                 orig_mask = sc->gfp_mask;

Yes, you are right. This simpler way is better. I will turn to it in
V2 resend patch.

Thanks!

>> +             promoted_mask = !(sc->gfp_mask & __GFP_HIGHMEM);
>>               sc->gfp_mask |= __GFP_HIGHMEM;
>> +     }
>>
>>       for_each_zone_zonelist_nodemask(zone, z, zonelist,
>>                                       gfp_zone(sc->gfp_mask), sc->nodemask) {
>> @@ -2354,6 +2357,9 @@ static bool shrink_zones(struct zonelist *zonelist, struct scan_control *sc)
>>               shrink_zone(zone, sc);
>>       }
>>
>> +     if (promoted_mask)
>                 sc->gfp_mask = orig_mask;
>
>> +             sc->gfp_mask &= ~__GFP_HIGHMEM;
>> +
>>       return aborted_reclaim;
>>  }
>>
>>
>
>
> --
> All rights reversed
