Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752241AbaGHEoJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 00:44:09 -0400
Received: from lgeamrelo04.lge.com ([156.147.1.127]:45151 "EHLO
	lgeamrelo04.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751217AbaGHEoH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 00:44:07 -0400
X-Original-SENDERIP: 10.178.33.69
X-Original-MAILFROM: gioh.kim@lge.com
Message-ID: <53BB7714.2020102@lge.com>
Date: Tue, 08 Jul 2014 13:44:04 +0900
From: Gioh Kim <gioh.kim@lge.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Laura Abbott <lauraa@codeaurora.org>,
        Michal Nazarewicz <mina86@mina86.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Joonsoo Kim <js1304@gmail.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        =?UTF-8?B?7J206rG07Zi4?= <gunho.lee@lge.com>,
        Gi-Oh Kim <gurugio@gmail.com>
Subject: Re: [PATCH] [RFC] CMA: clear buffer-head lru before page migration
References: <53B664E5.5060102@lge.com> <20140707155252.15e81dff6683393ba3590478@linux-foundation.org>
In-Reply-To: <20140707155252.15e81dff6683393ba3590478@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's my fault.
I'm going to send another patch ASAP.



2014-07-08 오전 7:52, Andrew Morton 쓴 글:
> On Fri, 04 Jul 2014 17:25:09 +0900 Gioh Kim <gioh.kim@lge.com> wrote:
>
>> From: Gioh Kim <gioh.kim@lge.com>
>> Date: Fri, 4 Jul 2014 16:53:22 +0900
>> Subject: [PATCH] [RFC] CMA: clear buffer-head lru before page migration
>>
>> When CMA try to migrate page, some buffer-heads can exist on lru.
>> The bh on lru has non-zero count value so that it cannot be dropped
>> even-if it is not used. We can drop only buffers related to the
>> migrated page, but it can take long time more than dropping all
>> because of searching list. There all buffers in lru are dropped.
>>
>> Signed-off-by: Laura Abbott <lauraa@codeaurora.org>
>> Signed-off-by: Gioh Kim <gioh.kim@lge.com>
>> ---
>>   fs/buffer.c |   13 +++++++++++++
>>   1 file changed, 13 insertions(+)
>>
>> diff --git a/fs/buffer.c b/fs/buffer.c
>> index eba6e4f..4f11b7a 100644
>> --- a/fs/buffer.c
>> +++ b/fs/buffer.c
>> @@ -3233,6 +3233,19 @@ int try_to_free_buffers(struct page *page)
>>          if (PageWriteback(page))
>>                  return 0;
>>
>> +#ifdef CONFIG_CMA
>> +       /*
>> +        * When CMA try to migrate page, some buffer-heads can exist on lru.
>> +        * The bh on lru has non-zero count value so that it cannot
>> +        * be dropped even-if it is not used.
>> +        * We can drop only buffers related to the migrated page,
>> +        * but it can take long time more than dropping all
>> +        * because of searching list.
>> +        * There all buffers in lru are dropped first.
>> +        */
>> +       invalidate_bh_lrus();
>> +#endif
>
> No, this will be tremendously expensive.
>
> What I proposed is that CMA call invalidate_bh_lrus() right at the
> outset.  Something along the lines of
>
> --- a/mm/page_alloc.c~a
> +++ a/mm/page_alloc.c
> @@ -6329,6 +6329,14 @@ int alloc_contig_range(unsigned long sta
>   	};
>   	INIT_LIST_HEAD(&cc.migratepages);
>
> +#ifdef CONFIG_CMA
> +	/*
> +	 * Comment goes here
> +	 */
> +	if (migratetype == MIGRATE_CMA)
> +		invalidate_bh_lrus();
> +#endif
> +
>   	/*
>   	 * What we do here is we mark all pageblocks in range as
>   	 * MIGRATE_ISOLATE.  Because pageblock and max order pages may
>
>
> - I'd have thought that it would make sense to do this for huge pages
>    as well (MIGRATE_MOVABLE) but nobody really seems to know.
>
> - There's a patch floating around ("Allow increasing the buffer-head
>    per-CPU LRU size") which will double the size of the bh lrus, so this
>    all becomes more important.
>
> - alloc_contig_range() does lru_add_drain_all() and drain_all_pages()
>    *after* performing the allocation.  I can't work out why this is the
>    case and of course it is undocumented.  If this is indeed not a bug
>    then probably the invalidate_bh_lrus() should happen in the same
>    place.
>
