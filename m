Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758131AbaGOG2p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 02:28:45 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:38609 "EHLO
	lgemrelse6q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757767AbaGOGZy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 02:25:54 -0400
X-Original-SENDERIP: 10.178.33.69
X-Original-MAILFROM: gioh.kim@lge.com
Message-ID: <53C4C96C.3050104@lge.com>
Date: Tue, 15 Jul 2014 15:25:48 +0900
From: Gioh Kim <gioh.kim@lge.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>
CC: Michal Nazarewicz <mina86@mina86.com>,
        Laura Abbott <lauraa@codeaurora.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        =?UTF-8?B?7J206rG07Zi4?= <gunho.lee@lge.com>,
        Gi-Oh Kim <gurugio@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Mel Gorman <mel@csn.ul.ie>
Subject: Re: [PATCH] [RFC] CMA: clear buffer-head lru before page migration
References: <53B664E5.5060102@lge.com>	<20140707155252.15e81dff6683393ba3590478@linux-foundation.org>	<xa1tpphf4x3s.fsf@mina86.com>	<20140714070225.GE11317@js1304-P5Q-DELUXE> <20140714133714.343ff0be6ea2bae651dc6f57@linux-foundation.org>
In-Reply-To: <20140714133714.343ff0be6ea2bae651dc6f57@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



2014-07-15 오전 5:37, Andrew Morton 쓴 글:
> On Mon, 14 Jul 2014 16:02:25 +0900 Joonsoo Kim <iamjoonsoo.kim@lge.com> wrote:
>
>> On Tue, Jul 08, 2014 at 06:46:31PM +0200, Michal Nazarewicz wrote:
>>> On Mon, Jul 07 2014, Andrew Morton <akpm@linux-foundation.org> wrote:
>>>> What I proposed is that CMA call invalidate_bh_lrus() right at the
>>>> outset.  Something along the lines of
>>>>
>>>> --- a/mm/page_alloc.c~a
>>>> +++ a/mm/page_alloc.c
>>>> @@ -6329,6 +6329,14 @@ int alloc_contig_range(unsigned long sta
>>>>   	};
>>>>   	INIT_LIST_HEAD(&cc.migratepages);
>>>>
>>>> +#ifdef CONFIG_CMA
>>>> +	/*
>>>> +	 * Comment goes here
>>>> +	 */
>>>> +	if (migratetype == MIGRATE_CMA)
>>>> +		invalidate_bh_lrus();
>>>> +#endif
>>>> +
>>>
>>> This seems reasonable, except I think it should go after
>>> start_isolate_page_range call because otherwise there's no guarantee
>>> that someone won't grab those pages back.
>>>
>>> Also to avoid the #ifdef perhaps we want this as well:
>>
>> I think that we just want to remove ifdef CONFIG_CMA on above code
>> snippet, because invalidate_bh_lrus() would also help user of
>> alloc_contig_range() with MIGRATE_MOVABLE.
>
> That's what I believe also.  I pinged Mel and Johannes off-list and Mel
> said "I hit it, the invalidation cost wasn't worth it for a THP alloc".
>
> So hm.  I do think it's worth additional investigation but some careful
> testing would be needed to demonstrate that it's worthwhile.  If the
> invalidation cost is hurting then perhaps additional logic will be
> needed to perform the invalidation only as a last-resort thing.
>
>
>
Adding invalidate_bh_lrus() between start_isolate_page_range and
__alloc_contig_migrate_range is working well on my platform.

But I'd like to test performance before sending patch.
Would anybody recommend me a benchmark tool?



