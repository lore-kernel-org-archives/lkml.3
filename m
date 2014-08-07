Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757361AbaHGM0R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 08:26:17 -0400
Received: from mail-oa0-f43.google.com ([209.85.219.43]:54265 "EHLO
	mail-oa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754303AbaHGM0Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 08:26:16 -0400
MIME-Version: 1.0
In-Reply-To: <53E33E6D.1080002@suse.cz>
References: <1407309517-3270-1-git-send-email-iamjoonsoo.kim@lge.com>
	<1407309517-3270-9-git-send-email-iamjoonsoo.kim@lge.com>
	<53E245D4.9080506@suse.cz>
	<20140807081945.GA2427@js1304-P5Q-DELUXE>
	<53E33E6D.1080002@suse.cz>
Date: Thu, 7 Aug 2014 21:26:15 +0900
Message-ID: <CAAmzW4MoARz7Mp_Y1PUEQEJnMouKighgUOHaQH63B+6eKiA9nw@mail.gmail.com>
Subject: Re: [PATCH v2 5/8] mm/isolation: change pageblock isolation logic to
 fix freepage counting bugs
From: Joonsoo Kim <js1304@gmail.com>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
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
        Gioh Kim <gioh.kim@lge.com>,
        Linux Memory Management List <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-08-07 17:53 GMT+09:00 Vlastimil Babka <vbabka@suse.cz>:
> On 08/07/2014 10:19 AM, Joonsoo Kim wrote:
>>>
>>> Is it needed to disable the pcp list? Shouldn't drain be enough?
>>> After the drain you already are sure that future freeing will see
>>> MIGRATE_ISOLATE and skip pcp list anyway, so why disable it
>>> completely?
>>
>>
>> Yes, it is needed. Until we move freepages from normal buddy list
>> to isolate buddy list, freepages could be allocated by others. In this
>> case, they could be moved to pcp list. When it is flushed from pcp list
>> to buddy list, we need to check whether it is on isolate migratetype
>> pageblock or not. But, we don't want that hook in free_pcppages_bulk()
>> because it is page allocator's normal freepath. To remove it, we shoule
>> disable the pcp list here.
>
>
> Ah, right. I thought that everything going to pcp lists would be through
> freeing which would already observe the isolate migratetype and skip
> pcplist. I forgot about the direct filling of pcplists from buddy list.
> You're right that we don't want extra hooks there.
>
> Still, couldn't this be solved in a simpler way via another pcplist drain
> after the pages are moved from normal to isolate buddy list? Should be even
> faster because instead of disable - drain - enable (5 all-cpu kicks, since
> each pageset_update does 2 kicks) you have drain - drain (2 kicks). While
> it's true that pageset_update is single-zone operation, I guess we would
> easily benefit from having a single-zone drain operation as well.

I hope so, but, it's not possible. Consider following situation.

Page A: on pcplist of CPU2 and it is on isolate pageblock.

CPU 1                   CPU 2
drain pcplist
wait IPI finished     move A to normal buddy list
finish IPI
                            A is moved to pcplist by allocation request

move doesn't catch A,
because it is on pcplist.

drain pcplist
wait IPI finished     move A to normal buddy list
finish IPI
                            A is moved to pcplist by allocation request

repeat!!

It could happen infinitely, though, low possibility.

Thanks.
