Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755921AbaHFPMa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 11:12:30 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43698 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752854AbaHFPM2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 11:12:28 -0400
Message-ID: <53E245D4.9080506@suse.cz>
Date: Wed, 06 Aug 2014 17:12:20 +0200
From: Vlastimil Babka <vbabka@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>
CC: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Rik van Riel <riel@redhat.com>, Mel Gorman <mgorman@suse.de>,
        Johannes Weiner <hannes@cmpxchg.org>, Minchan Kim <minchan@kernel.org>,
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
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 5/8] mm/isolation: change pageblock isolation logic
 to fix freepage counting bugs
References: <1407309517-3270-1-git-send-email-iamjoonsoo.kim@lge.com> <1407309517-3270-9-git-send-email-iamjoonsoo.kim@lge.com>
In-Reply-To: <1407309517-3270-9-git-send-email-iamjoonsoo.kim@lge.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/06/2014 09:18 AM, Joonsoo Kim wrote:
> Overall design of changed pageblock isolation logic is as following.

I'll reply here since the overall design part is described in this patch 
(would be worth to have it in cover letter as well IMHO).

> 1. ISOLATION
> - check pageblock is suitable for pageblock isolation.
> - change migratetype of pageblock to MIGRATE_ISOLATE.
> - disable pcp list.

Is it needed to disable the pcp list? Shouldn't drain be enough? After 
the drain you already are sure that future freeing will see 
MIGRATE_ISOLATE and skip pcp list anyway, so why disable it completely?

> - drain pcp list.
> - pcp couldn't have any freepage at this point.
> - synchronize all cpus to see correct migratetype.

This synchronization should already happen through the drain, no?

> - freed pages on this pageblock will be handled specially and
> not added to buddy list from here. With this way, there is no
> possibility of merging pages on different buddy list.
> - move freepages on normal buddy list to isolate buddy list.

Is there any advantage of moving the pages to isolate buddy list at this 
point, when we already have the new PageIsolated marking? Maybe not 
right now, but could this be later replaced by just splitting and 
marking PageIsolated the pages from normal buddy list? I guess memory 
hot-remove does not benefit from having buddy-merged pages and CMA 
probably also doesn't?

> There is no page on isolate buddy list so move_freepages_block()
> returns number of moved freepages correctly.
> - enable pcp list.
>
> 2. TEST-ISOLATION
> - activates freepages marked as PageIsolated() and add to isolate
> buddy list.
> - test if pageblock is properly isolated.
>
> 3. UNDO-ISOLATION
> - move freepages from isolate buddy list to normal buddy list.
> There is no page on normal buddy list so move_freepages_block()
> return number of moved freepages correctly.
> - change migratetype of pageblock to normal migratetype
> - synchronize all cpus.
> - activate isolated freepages and add to normal buddy list.

The lack of pcp list deactivation in the undo part IMHO suggests that it 
is indeed not needed.

> With this patch, most of freepage counting bugs are solved and
> exceptional handling for freepage count is done in pageblock isolation
> logic rather than allocator.

\o/

