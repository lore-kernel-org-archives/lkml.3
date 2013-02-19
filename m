Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934144Ab3BSTPB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 14:15:01 -0500
Received: from mail-da0-f43.google.com ([209.85.210.43]:38782 "EHLO
	mail-da0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933908Ab3BSSun (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 13:50:43 -0500
Date: Tue, 19 Feb 2013 10:49:40 -0800 (PST)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Sha Zhengju <handai.szj@gmail.com>
cc: Li Haifeng <omycle@gmail.com>, Will Huck <will.huckk@gmail.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: Should a swapped out page be deleted from swap cache?
In-Reply-To: <CAFj3OHXredBPjjLMaqnAq0tYKbLXaO0DOfs8zGYzV4ntsXvi6A@mail.gmail.com>
Message-ID: <alpine.LNX.2.00.1302191040010.2248@eggly.anvils>
References: <CAFNq8R4UYvygk8+X+NZgyGjgU5vBsEv1UM6MiUxah6iW8=0HrQ@mail.gmail.com> <alpine.LNX.2.00.1302180939200.2246@eggly.anvils> <CAFNq8R5x3tD9Fn4TWna58VfdiRedPkrTDkeHXStkL7yBngL1mw@mail.gmail.com> <5122E591.5090108@gmail.com>
 <CAFNq8R5Y+obN0pufXriqmRUajPPq=N6XMAhQUgbzObvCpbbpxA@mail.gmail.com> <CAFj3OHXredBPjjLMaqnAq0tYKbLXaO0DOfs8zGYzV4ntsXvi6A@mail.gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 Feb 2013, Sha Zhengju wrote:
> On Tue, Feb 19, 2013 at 2:53 PM, Li Haifeng <omycle@gmail.com> wrote:
> > 2013/2/19 Will Huck <will.huckk@gmail.com>:
> >> On 02/19/2013 10:04 AM, Li Haifeng wrote:
> >>>
> >>> If a anonymous page is swapped out and  comes to be reclaimable,
> >>> shrink_page_list() will call __remove_mapping() to delete the page
> >>> swapped out from swap cache. Corresponding code lists as below.

Correct.

> >>
> >>
> >> I'm not sure if
> >> if (PageAnon(page) && !PageSwapCache(page)) {
> >>  .................
> >> }
> >> will add the page to swap cache again.

No, it's already in the swap cache.  Of course, the original pageframe
may be removed from swap cache, freed, data later read back from swap into
a new swap cache pageframe, that be mapped into user memory, removed from
swap cache and swap freed, then later arrive here in page reclaim at the
PageAnon(page) && !PageSwapCache(page) to be added to swap again.

> >>
> >
> > Adding the page to swap cache is the first stage of memory reclaiming.
> >
> > When an anonymous page will be reclaimed, it should be swapped out. If
> > it's not in the swap cache, it will insert into swap cache first and
> > set the bit of PG_swapcache on page->flags. Then, it will be swapped
> > out by try_to_unmap(). After it's swapped out, and no processes swap

Almost correct...

> 
> Swapout(writing to swap disk) is not done by try_to_unmap() which only
> tries to remove all page table mappings to a page. Before unmapping,
> add_to_swap() will set the swap cache page dirty and it will be
> written out by pageout()->swap_writepage().

... but yes, try_to_unmap() is not the one that writes out to swap.

Hugh
