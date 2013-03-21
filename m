Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932248Ab3CUMbe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 08:31:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38369 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755297Ab3CUMbd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 08:31:33 -0400
Message-ID: <514AFD71.5080509@redhat.com>
Date: Thu, 21 Mar 2013 08:30:41 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Mel Gorman <mgorman@suse.de>
CC: Linux-MM <linux-mm@kvack.org>, Jiri Slaby <jslaby@suse.cz>,
        Valdis Kletnieks <Valdis.Kletnieks@vt.edu>,
        Zlatko Calusic <zcalusic@bitsync.net>,
        Johannes Weiner <hannes@cmpxchg.org>, dormando <dormando@rydia.net>,
        Satoru Moriya <satoru.moriya@hds.com>, Michal Hocko <mhocko@suse.cz>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 05/10] mm: vmscan: Do not allow kswapd to scan at maximum
 priority
References: <1363525456-10448-1-git-send-email-mgorman@suse.de> <1363525456-10448-6-git-send-email-mgorman@suse.de> <514A604E.40303@redhat.com> <20130321101210.GF1878@suse.de>
In-Reply-To: <20130321101210.GF1878@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/21/2013 06:12 AM, Mel Gorman wrote:
> On Wed, Mar 20, 2013 at 09:20:14PM -0400, Rik van Riel wrote:
>> On 03/17/2013 09:04 AM, Mel Gorman wrote:
>>> Page reclaim at priority 0 will scan the entire LRU as priority 0 is
>>> considered to be a near OOM condition. Kswapd can reach priority 0 quite
>>> easily if it is encountering a large number of pages it cannot reclaim
>>> such as pages under writeback. When this happens, kswapd reclaims very
>>> aggressively even though there may be no real risk of allocation failure
>>> or OOM.
>>>
>>> This patch prevents kswapd reaching priority 0 and trying to reclaim
>>> the world. Direct reclaimers will still reach priority 0 in the event
>>> of an OOM situation.
>>>
>>> Signed-off-by: Mel Gorman <mgorman@suse.de>
>>> ---
>>>   mm/vmscan.c | 2 +-
>>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>>
>>> diff --git a/mm/vmscan.c b/mm/vmscan.c
>>> index 7513bd1..af3bb6f 100644
>>> --- a/mm/vmscan.c
>>> +++ b/mm/vmscan.c
>>> @@ -2891,7 +2891,7 @@ static unsigned long balance_pgdat(pg_data_t *pgdat, int order,
>>>   		 */
>>>   		if (raise_priority || !this_reclaimed)
>>>   			sc.priority--;
>>> -	} while (sc.priority >= 0 &&
>>> +	} while (sc.priority >= 1 &&
>>>   		 !pgdat_balanced(pgdat, order, *classzone_idx));
>>>
>>>   out:
>>>
>>
>> If priority 0 is way way way way way too aggressive, what makes
>> priority 1 safe?
>>
>
> The fact that priority 1 selects a sensible number of pages to reclaim and
> obeys swappiness makes it a lot safer. Priority 0 does this in get_scan_count
   ^^^^^^^^^^^^^^^^

Ahhh, good point!  We stay away from all the "emergency" code, which
kswapd should never run.

Acked-by: Rik van Riel <riel@redhat.com>

-- 
All rights reversed
