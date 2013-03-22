Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753548Ab3CVAFl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 20:05:41 -0400
Received: from mail-ia0-f176.google.com ([209.85.210.176]:46779 "EHLO
	mail-ia0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751407Ab3CVAFk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 20:05:40 -0400
Message-ID: <514BA04D.2090002@gmail.com>
Date: Fri, 22 Mar 2013 08:05:33 +0800
From: Will Huck <will.huckk@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Johannes Weiner <hannes@cmpxchg.org>
CC: Mel Gorman <mgorman@suse.de>, Linux-MM <linux-mm@kvack.org>,
        Jiri Slaby <jslaby@suse.cz>,
        Valdis Kletnieks <Valdis.Kletnieks@vt.edu>,
        Rik van Riel <riel@redhat.com>, Zlatko Calusic <zcalusic@bitsync.net>,
        dormando <dormando@rydia.net>, Satoru Moriya <satoru.moriya@hds.com>,
        Michal Hocko <mhocko@suse.cz>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 01/10] mm: vmscan: Limit the number of pages kswapd reclaims
 at each priority
References: <1363525456-10448-1-git-send-email-mgorman@suse.de> <1363525456-10448-2-git-send-email-mgorman@suse.de> <20130321155705.GA27848@cmpxchg.org>
In-Reply-To: <20130321155705.GA27848@cmpxchg.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Johannes,
On 03/21/2013 11:57 PM, Johannes Weiner wrote:
> On Sun, Mar 17, 2013 at 01:04:07PM +0000, Mel Gorman wrote:
>> The number of pages kswapd can reclaim is bound by the number of pages it
>> scans which is related to the size of the zone and the scanning priority. In
>> many cases the priority remains low because it's reset every SWAP_CLUSTER_MAX
>> reclaimed pages but in the event kswapd scans a large number of pages it
>> cannot reclaim, it will raise the priority and potentially discard a large
>> percentage of the zone as sc->nr_to_reclaim is ULONG_MAX. The user-visible
>> effect is a reclaim "spike" where a large percentage of memory is suddenly
>> freed. It would be bad enough if this was just unused memory but because
>> of how anon/file pages are balanced it is possible that applications get
>> pushed to swap unnecessarily.
>>
>> This patch limits the number of pages kswapd will reclaim to the high
>> watermark. Reclaim will will overshoot due to it not being a hard limit as
> will -> still?
>
>> shrink_lruvec() will ignore the sc.nr_to_reclaim at DEF_PRIORITY but it
>> prevents kswapd reclaiming the world at higher priorities. The number of
>> pages it reclaims is not adjusted for high-order allocations as kswapd will
>> reclaim excessively if it is to balance zones for high-order allocations.
> I don't really understand this last sentence.  Is the excessive
> reclaim a result of the patch, a description of what's happening
> now...?
>
>> Signed-off-by: Mel Gorman <mgorman@suse.de>
> Nice, thank you.  Using the high watermark for larger zones is more
> reasonable than my hack that just always went with SWAP_CLUSTER_MAX,
> what with inter-zone LRU cycle time balancing and all.
>
> Acked-by: Johannes Weiner <hannes@cmpxchg.org>

One offline question, how to understand this in function balance_pgdat:
/*
  * Do some background aging of the anon list, to give
  * pages a chance to be referenced before reclaiming.
  */
age_acitve_anon(zone, &sc);
>
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>

