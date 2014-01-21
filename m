Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753255AbaAUD6z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 22:58:55 -0500
Received: from mail-vb0-f47.google.com ([209.85.212.47]:52932 "EHLO
	mail-vb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752187AbaAUD6r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 22:58:47 -0500
MIME-Version: 1.0
In-Reply-To: <CAFLCcBqyhL=wfC4uJmpp9MkGExBuPJC4EqY2RHRngnEn_1ytSA@mail.gmail.com>
References: <CAFLCcBqyhL=wfC4uJmpp9MkGExBuPJC4EqY2RHRngnEn_1ytSA@mail.gmail.com>
Date: Tue, 21 Jan 2014 11:58:46 +0800
Message-ID: <CAA_GA1eR++9u+WrCnv-eLoAa-6K18aQwLJ+TkpC8LGQPEeHGSQ@mail.gmail.com>
Subject: Re: [PATCH v2] mm/zswap: Check all pool pages instead of one pool pages
From: Bob Liu <lliubbo@gmail.com>
To: Cai Liu <liucai.lfn@gmail.com>
Cc: Minchan Kim <minchan@kernel.org>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Bob Liu <bob.liu@oracle.com>, Cai Liu <cai.liu@samsung.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux-MM <linux-mm@kvack.org>,
        Linux-Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 21, 2014 at 11:07 AM, Cai Liu <liucai.lfn@gmail.com> wrote:
> Thanks for your review.
>
> 2014/1/21 Minchan Kim <minchan@kernel.org>:
>> Hello Cai,
>>
>> On Mon, Jan 20, 2014 at 03:50:18PM +0800, Cai Liu wrote:
>>> zswap can support multiple swapfiles. So we need to check
>>> all zbud pool pages in zswap.
>>>
>>> Version 2:
>>>   * add *total_zbud_pages* in zbud to record all the pages in pools
>>>   * move the updating of pool pages statistics to
>>>     alloc_zbud_page/free_zbud_page to hide the details
>>>
>>> Signed-off-by: Cai Liu <cai.liu@samsung.com>
>>> ---
>>>  include/linux/zbud.h |    2 +-
>>>  mm/zbud.c            |   44 ++++++++++++++++++++++++++++++++------------
>>>  mm/zswap.c           |    4 ++--
>>>  3 files changed, 35 insertions(+), 15 deletions(-)
>>>
>>> diff --git a/include/linux/zbud.h b/include/linux/zbud.h
>>> index 2571a5c..1dbc13e 100644
>>> --- a/include/linux/zbud.h
>>> +++ b/include/linux/zbud.h
>>> @@ -17,6 +17,6 @@ void zbud_free(struct zbud_pool *pool, unsigned long handle);
>>>  int zbud_reclaim_page(struct zbud_pool *pool, unsigned int retries);
>>>  void *zbud_map(struct zbud_pool *pool, unsigned long handle);
>>>  void zbud_unmap(struct zbud_pool *pool, unsigned long handle);
>>> -u64 zbud_get_pool_size(struct zbud_pool *pool);
>>> +u64 zbud_get_pool_size(void);
>>>
>>>  #endif /* _ZBUD_H_ */
>>> diff --git a/mm/zbud.c b/mm/zbud.c
>>> index 9451361..711aaf4 100644
>>> --- a/mm/zbud.c
>>> +++ b/mm/zbud.c
>>> @@ -52,6 +52,13 @@
>>>  #include <linux/spinlock.h>
>>>  #include <linux/zbud.h>
>>>
>>> +/*********************************
>>> +* statistics
>>> +**********************************/
>>> +
>>> +/* zbud pages in all pools */
>>> +static u64 total_zbud_pages;
>>> +
>>>  /*****************
>>>   * Structures
>>>  *****************/
>>> @@ -142,10 +149,28 @@ static struct zbud_header *init_zbud_page(struct page *page)
>>>       return zhdr;
>>>  }
>>>
>>> +static struct page *alloc_zbud_page(struct zbud_pool *pool, gfp_t gfp)
>>> +{
>>> +     struct page *page;
>>> +
>>> +     page = alloc_page(gfp);
>>> +
>>> +     if (page) {
>>> +             pool->pages_nr++;
>>> +             total_zbud_pages++;
>>
>> Who protect race?
>
> Yes, here the pool->pages_nr and also the total_zbud_pages are not protected.
> I will re-do it.
>
> I will change *total_zbud_pages* to atomic type.

And how about just add total_zbud_pages++ and leave pool->pages_nr in
its original place which already protected by pool->lock?

> For *pool->pages_nr*, one way is to use pool->lock to protect. But I
> think it is too heavy.
> So does it ok to change pages_nr to atomic type too?
>

-- 
Regards,
--Bob
