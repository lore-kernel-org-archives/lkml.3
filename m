Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753414Ab3CFFeP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 00:34:15 -0500
Received: from mail-we0-f180.google.com ([74.125.82.180]:43784 "EHLO
	mail-we0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752444Ab3CFFeK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 00:34:10 -0500
MIME-Version: 1.0
In-Reply-To: <51241B66.7080004@gmail.com>
References: <CAFNq8R4UYvygk8+X+NZgyGjgU5vBsEv1UM6MiUxah6iW8=0HrQ@mail.gmail.com>
	<alpine.LNX.2.00.1302180939200.2246@eggly.anvils>
	<512338A6.1030602@gmail.com>
	<alpine.LNX.2.00.1302191050330.2248@eggly.anvils>
	<51241B66.7080004@gmail.com>
Date: Wed, 6 Mar 2013 13:34:09 +0800
Message-ID: <CAFNq8R5ni4jKRsHJLyGiNPcj4epz8q5zva_0XEJrL1-uVZHb9w@mail.gmail.com>
Subject: Re: Should a swapped out page be deleted from swap cache?
From: Li Haifeng <omycle@gmail.com>
To: Ric Mason <ric.masonn@gmail.com>
Cc: Hugh Dickins <hughd@google.com>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/2/20 Ric Mason <ric.masonn@gmail.com>:
>
> Hi Hugh,
>
>
> On 02/20/2013 02:56 AM, Hugh Dickins wrote:
>>
>> On Tue, 19 Feb 2013, Ric Mason wrote:
>>>
>>> There is a call of try_to_free_swap in function swap_writepage, if
>>> swap_writepage is call from shrink_page_list path, PageSwapCache(page) ==
>>> trure, PageWriteback(page) maybe false, page_swapcount(page) == 0, then
>>> will
>>> delete the page from swap cache and free swap slot, where I miss?
>>
>> That's correct.  PageWriteback is sure to be false there.  page_swapcount
>> usually won't be 0 there, but sometimes it will be, and in that case we
>> do want to delete from swap cache and free the swap slot.
>
>
> 1) If PageSwapCache(page)  == true, PageWriteback(page) == false,
> page_swapcount(page) == 0  in swap_writepage(shrink_page_list path), then
> will delete the page from swap cache and free swap slot, in function
> swap_writepage:
>
> if (try_to_free_swap(page)) {
>     unlock_page(page);
>     goto out;
> }
> writeback will not execute, that's wrong. Where I miss?

when the page is deleted from swap cache and corresponding swap slot
is free, the page is set dirty. The dirty page won't be reclaimed. It
is not wrong.

corresponding path lists as below.
when swap_writepage() is called by pageout() in shrink_page_list().
pageout() will return PAGE_SUCCESS. For PAGE_SUCCESS, when
PageDirty(page) is true, this reclaiming page will be keeped in the
inactive LRU list.
shrink_page_list()
{
...
 904                         switch (pageout(page, mapping, sc)) {
 905                         case PAGE_KEEP:
 906                                 nr_congested++;
 907                                 goto keep_locked;
 908                         case PAGE_ACTIVATE:
 909                                 goto activate_locked;
 910                         case PAGE_SUCCESS:
 911                                 if (PageWriteback(page))
 912                                         goto keep_lumpy;
 913                                 if (PageDirty(page))
 914                                         goto keep;
...}

>
> 2) In the function pageout, page will be set PG_Reclaim flag, since this
> flag is set, end_swap_bio_write->end_page_writeback:
> if (TestClearPageReclaim(page))
>      rotate_reclaimable_page(page);
> it means that page will be add to the tail of lru list, page is clean
> anonymous page this time and will be reclaim to buddy system soon, correct?
correct
> If is correct, what is the meaning of rotate here?

Rotating here is to add the page to the tail of inactive LRU list. So
this page will be reclaimed ASAP while reclaiming.

>
>>
>> Hugh
>
>
