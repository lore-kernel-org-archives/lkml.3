Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753753AbaLJBlS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 20:41:18 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:53031 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752679AbaLJBlR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 20:41:17 -0500
X-SecurityPolicyCheck: OK by SHieldMailChecker v2.0.1
X-SHieldMailCheckerPolicyVersion: FJ-ISEC-20120718-3
Message-ID: <5487A418.4060800@jp.fujitsu.com>
Date: Wed, 10 Dec 2014 10:38:32 +0900
From: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: James Custer <jcuster@sgi.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "kamezawa.hiroyu@jp.fujitsu.com" <kamezawa.hiroyu@jp.fujitsu.com>
CC: Russ Anderson <rja@sgi.com>, Derek Fults <dfults@sgi.com>
Subject: Re: [PATCH] mm: fix invalid use of pfn_valid_within in test_pages_in_a_zone
References: <1418153696-167580-1-git-send-email-jcuster@sgi.com>,<54878D56.4030508@jp.fujitsu.com> <E0FB9EDDBE1AAD4EA62C90D3B6E4783B739E643B@P-EXMB2-DC21.corp.sgi.com>
In-Reply-To: <E0FB9EDDBE1AAD4EA62C90D3B6E4783B739E643B@P-EXMB2-DC21.corp.sgi.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-SecurityPolicyCheck-GC: OK by FENCE-Mail
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/12/10 9:14), James Custer wrote:
> It is exactly the same if CONFIG_HOLES_IN_NODE is set, but if CONFIG_HOLES_IN_NODE is not set, then pfn_valid_within is always 1.

Why don't you set CONFIG_HOLES_IN_ZONE? This BUG is occrred by hole in zone.
CONFIG_HOLE_IN_ZONE is propered for the system.

I think your patch fixes the BUG. But even if fixing the BUG, other issues
will be occurred by hole in zone.

Thanks,
Yasuaki Ishimatsu

>
> From: https://lkml.org/lkml/2007/3/21/272
>
> "Generally we work under the assumption that memory the mem_map
> array is contigious and valid out to MAX_ORDER_NR_PAGES block
> of pages, ie. that if we have validated any page within this
> MAX_ORDER_NR_PAGES block we need not check any other.  This is not
> true when CONFIG_HOLES_IN_ZONE is set and we must check each and
> every reference we make from a pfn.
>
> Add a pfn_valid_within() helper which should be used when scanning
> pages within a MAX_ORDER_NR_PAGES block when we have already
> checked the validility of the block normally with pfn_valid().
> This can then be optimised away when we do not have holes within
> a MAX_ORDER_NR_PAGES block of pages."
>
> So, since we're iterating over a pageblock there must be a valid pfn to be able to use pfn_valid_within (which makes sense since if CONFIG_HOLES_IN_NODE is not set, it is always 1).
>
> I'm just going off of the documentation there and what makes sense to me based off that documentation. Does that explanation help?
>
> Regards,
> James Custer
> ________________________________________
> From: Yasuaki Ishimatsu [isimatu.yasuaki@jp.fujitsu.com]
> Sent: Tuesday, December 09, 2014 6:01 PM
> To: James Custer; linux-kernel@vger.kernel.org; linux-mm@kvack.org; akpm@linux-foundation.org; kamezawa.hiroyu@jp.fujitsu.com
> Cc: Russ Anderson; Derek Fults
> Subject: Re: [PATCH] mm: fix invalid use of pfn_valid_within in test_pages_in_a_zone
>
> (2014/12/10 4:34), James Custer wrote:
>> Offlining memory by 'echo 0 > /sys/devices/system/memory/memory#/online'
>> or reading valid_zones 'cat /sys/devices/system/memory/memory#/valid_zones'
>
>> causes BUG: unable to handle kernel paging request due to invalid use of
>> pfn_valid_within. This is due to a bug in test_pages_in_a_zone.
>
> The information is not enough to understand what happened on your system.
> Could you show full BUG messages?
>
>>
>> In order to use pfn_valid_within within a MAX_ORDER_NR_PAGES block of pages,
>> a valid pfn within the block must first be found. There only needs to be
>> one valid pfn found in test_pages_in_a_zone in the first place. So the
>> fix is to replace pfn_valid_within with pfn_valid such that the first
>> valid pfn within the pageblock is found (if it exists). This works
>> independently of CONFIG_HOLES_IN_ZONE.
>>
>> Signed-off-by: James Custer <jcuster@sgi.com>
>> ---
>>    mm/memory_hotplug.c | 11 ++++++-----
>>    1 file changed, 6 insertions(+), 5 deletions(-)
>>
>> diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
>> index 1bf4807..304c187 100644
>> --- a/mm/memory_hotplug.c
>> +++ b/mm/memory_hotplug.c
>> @@ -1331,7 +1331,7 @@ int is_mem_section_removable(unsigned long start_pfn, unsigned long nr_pages)
>>    }
>>
>>    /*
>> - * Confirm all pages in a range [start, end) is belongs to the same zone.
>> + * Confirm all pages in a range [start, end) belong to the same zone.
>>     */
>>    int test_pages_in_a_zone(unsigned long start_pfn, unsigned long end_pfn)
>>    {
>> @@ -1342,10 +1342,11 @@ int test_pages_in_a_zone(unsigned long start_pfn, unsigned long end_pfn)
>>        for (pfn = start_pfn;
>>             pfn < end_pfn;
>>             pfn += MAX_ORDER_NR_PAGES) {
>
>> -             i = 0;
>> -             /* This is just a CONFIG_HOLES_IN_ZONE check.*/
>> -             while ((i < MAX_ORDER_NR_PAGES) && !pfn_valid_within(pfn + i))
>> -                     i++;
>> +             /* Find the first valid pfn in this pageblock */
>> +             for (i = 0; i < MAX_ORDER_NR_PAGES; i++) {
>> +                     if (pfn_valid(pfn + i))
>> +                             break;
>> +             }
>
> If CONFIG_HOLES_IN_NODE is set, there is no difference. Am I making a mistake?
>
> Thanks,
> Yasuaki Ishimatsu
>
>
>>                if (i == MAX_ORDER_NR_PAGES)
>>                        continue;
>>                page = pfn_to_page(pfn + i);
>>
>
>


