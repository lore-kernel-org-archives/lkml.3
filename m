Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751584AbaLPIw0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 03:52:26 -0500
Received: from cantor2.suse.de ([195.135.220.15]:45645 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750899AbaLPIwY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 03:52:24 -0500
Message-ID: <548FF2BE.4060601@suse.cz>
Date: Tue, 16 Dec 2014 09:52:14 +0100
From: Vlastimil Babka <vbabka@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        David Rientjes <rientjes@google.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Mel Gorman <mgorman@suse.de>, Michal Hocko <mhocko@suse.cz>,
        Minchan Kim <minchan@kernel.org>, Rik van Riel <riel@redhat.com>,
        Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Subject: Re: [PATCH v2 0/3] page stealing tweaks
References: <1418400085-3622-1-git-send-email-vbabka@suse.cz> <20141215075017.GB4898@js1304-P5Q-DELUXE> <548EA452.50706@suse.cz> <20141216025452.GC23270@js1304-P5Q-DELUXE>
In-Reply-To: <20141216025452.GC23270@js1304-P5Q-DELUXE>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/16/2014 03:54 AM, Joonsoo Kim wrote:
> On Mon, Dec 15, 2014 at 10:05:22AM +0100, Vlastimil Babka wrote:
>> On 12/15/2014 08:50 AM, Joonsoo Kim wrote:
>>> On Fri, Dec 12, 2014 at 05:01:22PM +0100, Vlastimil Babka wrote:
>>>> Changes since v1:
>>>> o Reorder patch 2 and 3, Cc stable for patch 1
>>>> o Fix tracepoint in patch 1 (Joonsoo Kim)
>>>> o Cleanup in patch 2 (suggested by Minchan Kim)
>>>> o Improved comments and changelogs per Minchan and Mel.
>>>> o Considered /proc/pagetypeinfo in evaluation with 3.18 as baseline
>>>>
>>>> When studying page stealing, I noticed some weird looking decisions in
>>>> try_to_steal_freepages(). The first I assume is a bug (Patch 1), the following
>>>> two patches were driven by evaluation.
>>>>
>>>> Testing was done with stress-highalloc of mmtests, using the
>>>> mm_page_alloc_extfrag tracepoint and postprocessing to get counts of how often
>>>> page stealing occurs for individual migratetypes, and what migratetypes are
>>>> used for fallbacks. Arguably, the worst case of page stealing is when
>>>> UNMOVABLE allocation steals from MOVABLE pageblock. RECLAIMABLE allocation
>>>> stealing from MOVABLE allocation is also not ideal, so the goal is to minimize
>>>> these two cases.
>>>>
>>>> For some reason, the first patch increased the number of page stealing events
>>>> for MOVABLE allocations in the former evaluation with 3.17-rc7 + compaction
>>>> patches. In theory these events are not as bad, and the second patch does more
>>>> than just to correct this. In v2 evaluation based on 3.18, the weird result
>>>> was gone completely.
>>>>
>>>> In v2 I also checked if /proc/pagetypeinfo has shown an increase of the number
>>>> of unmovable/reclaimable pageblocks during and after the test, and it didn't.
>>>> The test was repeated 25 times with reboot only after each 5 to show
>>>> longer-term differences in the state of the system, which also wasn't the case.
>>>>
>>>> Extfrag events summed over first iteration after reboot (5 repeats)
>>>>                                                          3.18            3.18            3.18            3.18
>>>>                                                     0-nothp-1       1-nothp-1       2-nothp-1       3-nothp-1
>>>> Page alloc extfrag event                                4547160     4593415     2343438     2198189
>>>> Extfrag fragmenting                                     4546361     4592610     2342595     2196611
>>>> Extfrag fragmenting for unmovable                          5725        9196        5720        1093
>>>> Extfrag fragmenting unmovable placed with movable          3877        4091        1330         859
>>>> Extfrag fragmenting for reclaimable                         770         628         511         616
>>>> Extfrag fragmenting reclaimable placed with movable         679         520         407         492
>>>> Extfrag fragmenting for movable                         4539866     4582786     2336364     2194902
>>>>
>>>> Compared to v1 this looks like a regression for patch 1 wrt unmovable events,
>>>> but I blame noise and less repeats (it was 10 in v1). On the other hand, the
>>>> the mysterious increase in movable allocation events in v1 is gone (due to
>>>> different baseline?)
>>>
>>> Hmm... the result on patch 2 looks odd.
>>> Because you reorder patches, patch 2 have some effects on unmovable
>>> stealing and I expect that 'Extfrag fragmenting for unmovable' decreases.
>>> But, the result looks not. Is there any reason you think?
>>
>> Hm, I don't see any obvious reason.
>>
>>> And, could you share compaction success rate and allocation success
>>> rate on each iteration? In fact, reducing Extfrag event isn't our goal.
>>> It is natural result of this patchset because we steal pages more
>>> aggressively. Our utimate goal is to make the system less fragmented
>>> and to get more high order freepage, so I'd like to know this results.
>>
>> I don't think there's much significant difference. Could be a limitation
>> of the benchmark. But even if there's no difference, it means the reduction
>> of fragmenting events at least saves time on allocations.
>
> Hmm... Allocation success rate of 3-nothp-N on phase 1,2 shows minor degradation
> from 2-nothp-N and compaction success rate also decreases. Isn't it?
> I think that allocation success rate on phase 1 is important because
> workload in phase 1 mostly resemble real world scenario. Do you have
> any idea why this happens?

It could be just noise, keep in mind that each 3-nothp-N is averaged 
from just from 5 repeats. And the iterations without reboot (N) are not 
independent, so if there's some "bad luck" upon boot, it will carry to 
all N of 3-nothp-N.

