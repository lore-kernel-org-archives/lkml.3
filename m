Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753459Ab3HSCR4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Aug 2013 22:17:56 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:25466 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752410Ab3HSCRy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Aug 2013 22:17:54 -0400
Message-ID: <52118042.30101@oracle.com>
Date: Mon, 19 Aug 2013 10:17:38 +0800
From: Bob Liu <bob.liu@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Weijie Yang <weijie.yang.kh@gmail.com>
CC: sjenning@linux.vnet.ibm.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, dan.magenheimer@oracle.com
Subject: Re: [BUG REPORT] ZSWAP: theoretical race condition issues
References: <CAL1ERfOiT7QV4UUoKi8+gwbHc9an4rUWriufpOJOUdnTYHHEAw@mail.gmail.com>
In-Reply-To: <CAL1ERfOiT7QV4UUoKi8+gwbHc9an4rUWriufpOJOUdnTYHHEAw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Weijie,

On 08/19/2013 12:14 AM, Weijie Yang wrote:
> I found a few bugs in zswap when I review Linux-3.11-rc5, and I have
> also some questions about it, described as following:
> 
> BUG:
> 1. A race condition when reclaim a page
> when a handle alloced from zbud, zbud considers this handle is used
> validly by upper(zswap) and can be a candidate for reclaim.
> But zswap has to initialize it such as setting swapentry and addding
> it to rbtree. so there is a race condition, such as:
> thread 0: obtain handle x from zbud_alloc
> thread 1: zbud_reclaim_page is called
> thread 1: callback zswap_writeback_entry to reclaim handle x
> thread 1: get swpentry from handle x (it is random value now)
> thread 1: bad thing may happen
> thread 0: initialize handle x with swapentry

Yes, this may happen potentially but in rare case.
Because we have a LRU list for page frames, after Thread 0 called
zbud_alloc the corresponding page will be add to the head of LRU
list,While zbud_reclaim_page(Thread 1 called) is started from the tail
of LRU list.

> Of course, this situation almost never happen, it is a "theoretical
> race condition" issue.
> 
> 2. Pollute swapcache data by add a pre-invalided swap page
> when a swap_entry is invalidated, it will be reused by other anon
> page. At the same time, zswap is reclaiming old page, pollute
> swapcache of new page as a result, because old page and new page use
> the same swap_entry, such as:
> thread 1: zswap reclaim entry x
> thread 0: zswap_frontswap_invalidate_page entry x
> thread 0: entry x reused by other anon page
> thread 1: add old data to swapcache of entry x

I didn't get your idea here, why thread1 will add old data to entry x?

> thread 0: swapcache of entry x is polluted
> Of course, this situation almost never happen, it is another
> "theoretical race condition" issue.
> 
> 3. Frontswap uses frontswap_map bitmap to track page in "backend"
> implementation, when zswap reclaim a
> page, the corresponding bitmap record is not cleared.
>

That's true, but I don't think it's a big problem.
Only waste little time to search rbtree during zswap_frontswap_load().

> 4. zswap_tree is not freed when swapoff, and it got re-kzalloc in
> swapon, memory leak occurs.

Nice catch! I think it should be freed in zswap_frontswap_invalidate_area().

> 
> questions:
> 1. How about SetPageReclaim befor __swap_writepage, so that move it to
> the tail of the inactive list?

It will be added to inactive now.

> 2. zswap uses GFP_KERNEL flag to alloc things in store and reclaim
> function, does this lead to these function called recursively?

Yes, that's a potential problem.

> 3. for reclaiming one zbud page which contains two buddies, zswap
> needs to alloc two pages. Does this reclaim cost-efficient?
> 

Yes, that's a problem too. And that's why we use zbud as the default
allocator instead of zsmalloc.
I think improving the write back path of zswap is the next important
step for zswap.

-- 
Regards,
-Bob
