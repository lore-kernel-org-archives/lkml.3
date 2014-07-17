Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756055AbaGQJ20 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 05:28:26 -0400
Received: from cantor2.suse.de ([195.135.220.15]:46593 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755703AbaGQJ2V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 05:28:21 -0400
Message-ID: <53C793F0.6030707@suse.cz>
Date: Thu, 17 Jul 2014 11:14:24 +0200
From: Vlastimil Babka <vbabka@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Rik van Riel <riel@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Mel Gorman <mgorman@suse.de>, Johannes Weiner <hannes@cmpxchg.org>,
        Minchan Kim <minchan@kernel.org>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        Zhang Yanfei <zhangyanfei@cn.fujitsu.com>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Tang Chen <tangchen@cn.fujitsu.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Wen Congyang <wency@cn.fujitsu.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Michal Nazarewicz <mina86@mina86.com>,
        Laura Abbott <lauraa@codeaurora.org>,
        Heesub Shin <heesub.shin@samsung.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Ritesh Harjani <ritesh.list@gmail.com>, t.stanislaws@samsung.com,
        Gioh Kim <gioh.kim@lge.com>, linux-mm@kvack.org,
        Lisa Du <cldu@marvell.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/10] fix freepage count problems due to memory isolation
References: <1404460675-24456-1-git-send-email-iamjoonsoo.kim@lge.com> <53B6C947.1070603@suse.cz> <20140707044932.GA29236@js1304-P5Q-DELUXE> <53BAAFA5.9070403@suse.cz> <20140714062222.GA11317@js1304-P5Q-DELUXE> <53C3A7A5.9060005@suse.cz> <20140715082828.GM11317@js1304-P5Q-DELUXE> <53C4E813.7020108@suse.cz> <20140716084333.GA20359@js1304-P5Q-DELUXE> <53C65E92.2000606@suse.cz> <20140717061205.GA22418@js1304-P5Q-DELUXE>
In-Reply-To: <20140717061205.GA22418@js1304-P5Q-DELUXE>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/17/2014 08:12 AM, Joonsoo Kim wrote:
>>
>> Hm I see. So what if it wasn't a special pcplist, but a special "free list"
>> where the pages would be just linked together as on pcplist, regardless of
>> order, and would not merge until the CPU that drives the memory isolation
>> process decides it is safe to flush them away. That would remove the need for
>> IPI's and provide the same guarantees I think.
>
> Looks good. It would work. I think that your solution is better than mine.
> I will implement it and test.

Thanks. But maybe there's still a good use for marking pages specially 
as isolated, and not PageBuddy with freepage_migratetype set to 
MIGRATE_ISOLATE. Why do we buddy-merge them anyway? I don't think CMA or 
memory offlining benefits from that, and it only makes the code more 
complex?
So maybe we could split isolated buddy pages to order-0 marked as 
PageIsolated and have a single per-zone list instead of order-based 
freelists?

>> Do we really need to check PageBuddy()? Could a page get marked as PageIsolate()
>> but still go to normal list instead of isolate list?
>
> Checking PageBuddy() is used for identifying page linked in normal
> list.

Ah right, forgot it walks by pfn scanning, not by traversing the free list.

> Thanks.
>
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
>

