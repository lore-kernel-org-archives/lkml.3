Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758612Ab3BTAkO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 19:40:14 -0500
Received: from mail-qa0-f46.google.com ([209.85.216.46]:33845 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758164Ab3BTAkM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 19:40:12 -0500
Message-ID: <51241B66.7080004@gmail.com>
Date: Wed, 20 Feb 2013 08:40:06 +0800
From: Ric Mason <ric.masonn@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Hugh Dickins <hughd@google.com>
CC: Li Haifeng <omycle@gmail.com>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: Should a swapped out page be deleted from swap cache?
References: <CAFNq8R4UYvygk8+X+NZgyGjgU5vBsEv1UM6MiUxah6iW8=0HrQ@mail.gmail.com> <alpine.LNX.2.00.1302180939200.2246@eggly.anvils> <512338A6.1030602@gmail.com> <alpine.LNX.2.00.1302191050330.2248@eggly.anvils>
In-Reply-To: <alpine.LNX.2.00.1302191050330.2248@eggly.anvils>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Hugh,

On 02/20/2013 02:56 AM, Hugh Dickins wrote:
> On Tue, 19 Feb 2013, Ric Mason wrote:
>> There is a call of try_to_free_swap in function swap_writepage, if
>> swap_writepage is call from shrink_page_list path, PageSwapCache(page) ==
>> trure, PageWriteback(page) maybe false, page_swapcount(page) == 0, then will
>> delete the page from swap cache and free swap slot, where I miss?
> That's correct.  PageWriteback is sure to be false there.  page_swapcount
> usually won't be 0 there, but sometimes it will be, and in that case we
> do want to delete from swap cache and free the swap slot.

1) If PageSwapCache(page)  == true, PageWriteback(page) == false, 
page_swapcount(page) == 0  in swap_writepage(shrink_page_list path), 
then will delete the page from swap cache and free swap slot, in 
function swap_writepage:

if (try_to_free_swap(page)) {
     unlock_page(page);
     goto out;
}
writeback will not execute, that's wrong. Where I miss?

2) In the function pageout, page will be set PG_Reclaim flag, since this 
flag is set, end_swap_bio_write->end_page_writeback:
if (TestClearPageReclaim(page))
      rotate_reclaimable_page(page);
it means that page will be add to the tail of lru list, page is clean 
anonymous page this time and will be reclaim to buddy system soon, correct?
If is correct, what is the meaning of rotate here?

>
> Hugh

