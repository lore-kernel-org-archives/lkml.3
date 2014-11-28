Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751107AbaK1Dpr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 22:45:47 -0500
Received: from mail-oi0-f46.google.com ([209.85.218.46]:63884 "EHLO
	mail-oi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750801AbaK1Dpp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 22:45:45 -0500
MIME-Version: 1.0
In-Reply-To: <20141024052849.GF15243@js1304-P5Q-DELUXE>
References: <1413430551-22392-1-git-send-email-zhuhui@xiaomi.com>
 <1413430551-22392-5-git-send-email-zhuhui@xiaomi.com> <20141024052849.GF15243@js1304-P5Q-DELUXE>
From: Hui Zhu <teawater@gmail.com>
Date: Fri, 28 Nov 2014 11:45:04 +0800
Message-ID: <CANFwon0CP6jA4oq0U2xC340MbFsws5NmhEMGEUDm983N=mT-Pg@mail.gmail.com>
Subject: Re: [PATCH 4/4] (CMA_AGGRESSIVE) Update page alloc function
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Hui Zhu <zhuhui@xiaomi.com>, rjw@rjwysocki.net, len.brown@intel.com,
        pavel@ucw.cz, m.szyprowski@samsung.com,
        Andrew Morton <akpm@linux-foundation.org>, mina86@mina86.com,
        aneesh.kumar@linux.vnet.ibm.com, hannes@cmpxchg.org,
        Rik van Riel <riel@redhat.com>, mgorman@suse.de, minchan@kernel.org,
        nasa4836@gmail.com, ddstreet@ieee.org, Hugh Dickins <hughd@google.com>,
        mingo@kernel.org, rientjes@google.com,
        Peter Zijlstra <peterz@infradead.org>, keescook@chromium.org,
        atomlin@redhat.com, raistlin@linux.it, axboe@fb.com,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        kirill.shutemov@linux.intel.com, n-horiguchi@ah.jp.nec.com,
        k.khlebnikov@samsung.com, msalter@redhat.com, deller@gmx.de,
        tangchen@cn.fujitsu.com, ben@decadent.org.uk, akinobu.mita@gmail.com,
        lauraa@codeaurora.org, vbabka@suse.cz, sasha.levin@oracle.com,
        vdavydov@parallels.com, suleiman@google.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-pm@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 24, 2014 at 1:28 PM, Joonsoo Kim <iamjoonsoo.kim@lge.com> wrote:
> On Thu, Oct 16, 2014 at 11:35:51AM +0800, Hui Zhu wrote:
>> If page alloc function __rmqueue try to get pages from MIGRATE_MOVABLE and
>> conditions (cma_alloc_counter, cma_aggressive_free_min, cma_alloc_counter)
>> allow, MIGRATE_CMA will be allocated as MIGRATE_MOVABLE first.
>>
>> Signed-off-by: Hui Zhu <zhuhui@xiaomi.com>
>> ---
>>  mm/page_alloc.c | 42 +++++++++++++++++++++++++++++++-----------
>>  1 file changed, 31 insertions(+), 11 deletions(-)
>>
>> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
>> index 736d8e1..87bc326 100644
>> --- a/mm/page_alloc.c
>> +++ b/mm/page_alloc.c
>> @@ -65,6 +65,10 @@
>>  #include <asm/div64.h>
>>  #include "internal.h"
>>
>> +#ifdef CONFIG_CMA_AGGRESSIVE
>> +#include <linux/cma.h>
>> +#endif
>> +
>>  /* prevent >1 _updater_ of zone percpu pageset ->high and ->batch fields */
>>  static DEFINE_MUTEX(pcp_batch_high_lock);
>>  #define MIN_PERCPU_PAGELIST_FRACTION (8)
>> @@ -1189,20 +1193,36 @@ static struct page *__rmqueue(struct zone *zone, unsigned int order,
>>  {
>>       struct page *page;
>>
>> -retry_reserve:
>> +#ifdef CONFIG_CMA_AGGRESSIVE
>> +     if (cma_aggressive_switch
>> +         && migratetype == MIGRATE_MOVABLE
>> +         && atomic_read(&cma_alloc_counter) == 0
>> +         && global_page_state(NR_FREE_CMA_PAGES) > cma_aggressive_free_min
>> +                                                     + (1 << order))
>> +             migratetype = MIGRATE_CMA;
>> +#endif
>> +retry:
>
> I don't get it why cma_alloc_counter should be tested.
> When cma alloc is progress, pageblock is isolated so that pages on that
> pageblock cannot be allocated. Why should we prevent aggressive
> allocation in this case?
>

Hi Joonsoo,

Even if the pageblock is isolated in the begin of function
alloc_contig_range, it will unisolate if alloc_contig_range get some
error for example "PFNs busy".  And the cma_alloc will keep call
alloc_contig_range with another address if need.

So it will decrease the contradiction between CMA allocation in
cma_alloc and __rmqueue with  cma_alloc_counter.

Thanks,
Hui

> Thanks.
>
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
