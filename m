Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754857Ab3BDN3u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 08:29:50 -0500
Received: from mail-lb0-f181.google.com ([209.85.217.181]:63190 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754143Ab3BDN3s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 08:29:48 -0500
Message-ID: <510FB7C5.3010805@openvz.org>
Date: Mon, 04 Feb 2013 17:29:41 +0400
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.11) Gecko/20121123 Firefox/10.0.11 Iceape/2.7.11
MIME-Version: 1.0
To: Hugh Dickins <hughd@google.com>
CC: Johannes Weiner <hannes@cmpxchg.org>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch] mm: shmem: use new radix tree iterator
References: <1359699238-7327-1-git-send-email-hannes@cmpxchg.org> <510CCD88.30200@openvz.org> <alpine.LNX.2.00.1302031802140.4120@eggly.anvils>
In-Reply-To: <alpine.LNX.2.00.1302031802140.4120@eggly.anvils>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hugh Dickins wrote:
> On Sat, 2 Feb 2013, Konstantin Khlebnikov wrote:
>> Johannes Weiner wrote:
>>> In shmem_find_get_pages_and_swap, use the faster radix tree iterator
>>> construct from 78c1d78 "radix-tree: introduce bit-optimized iterator".
>>>
>>> Signed-off-by: Johannes Weiner<hannes@cmpxchg.org>
>>
>> Hmm, ACK. shmem_unuse_inode() also can be redone in this way.
>> I did something similar year ago: https://lkml.org/lkml/2012/2/10/388
>> As result we can rid of radix_tree_locate_item() and
>> shmem_find_get_pages_and_swap()
>
> Indeed you did, and never got more than a "I have some reservations"
> response out of me; and already we had both moved on to much more
> pressing lruvec and other concerns.
>
> My first reaction on seeing Johannes' patch was, not to ack it immediately,
> but look back to your series of 6 (or 4): shmem_find_get_pages_and_swap()
> doesn't get updated in yours, but vanishes in the last patch, which was
> among the ones I was uneasy about.  Here's a belated account of my
> reactions to your series.

Thanks for review.

I mentioned that patchset with hope that somebody get interested to
continue that work. Recently there was many patches related to the swap.

Currently I'm working on replacing our homemade memory controller with
something based on memcg. So I'll revisit 'lruvec/lru_lock' patchset soon.

>
> [PATCH 1/4] shmem: simplify shmem_unlock_mapping
> Probably good, though should also update the "only reach" comment in
> find_get_pages(); and probably not worthwhile unless shmem_find_get_
> pages_and_swap() is to disappear entirely.
>
> [PATCH 2/4] shmem: tag swap entries in radix tree
> Using a tag instead of and in addition to the swap exceptional entries
> was certainly something I tried when I was updating shmem_unuse(): it
> just didn't work as well as I'd hoped and needed, nothing worked as
> "well" as the radix_tree_locate_item() thing I added, though I'd have
> preferred to avoid adding it.  So I needed to test and understand why
> you found tags worked where I had not: probably partly your intervening
> radix_tree changes, and partly a difference in how we tested.  There
> was also a little issue fo SHMEM_TAG_SWAP == PAGECACHE_TAG_DIRTY: you
> were absolutely right not to enlarge the tagspace, but at that time
> there was a weird issue of page migration putting a dirty tag into
> the tmpfs radix_tree, which later I worked around in 752dc185.
>
> [PATCH 3/4] shmem: use radix-tree iterator in shmem_unuse_inode()
> Removes lots of code which is great, but as I said, I'd need
> to investigate why tagging worked for you but not for me.
>
> [PATCH 4/4] mm: use swap readahead at swapoff
> I've tried that down the years from time to time, and never found
> it useful (but I see you found it works better in a virtual machine).
> I've no strong objection to the patch, but when I rewrote try_to_unuse()
> twelve years ago, I was overly sensitive to readahead adding pressure in
> the case where you're already swapping off under pressure, and preferred
> to avoid the readahead if it didn't help.  The slowness of swapoff has
> very little to do with readahead or not, or that's what I always found:
> if swapoff while loaded, readahead increased the memory pressure; if
> (usual case) swapoff while not loaded, apparently the disk's own
> caching was good enough that kernel readahead made no difference.
>
> [PATCH 5/4] shmem: put shmem_delete_from_page_cache under CONFIG_SWAP
> I'm completely schizophrenic about #fidef CONFIG_SWAPs, sometimes I
> love to add them, and sometimes I think they're ugly.  You're probably
> right that mm/shmem.c should have more of them, it helps document too.
>
> [PATCH 6/4] shmem: simplify shmem_truncate_range
> Where shmem_find_get_pages_and_swap() goes away.  But
> you replace (what was then) shmem_truncate_range() by two passes,
> truncate_inode_pages_range() followed by shmem_truncate_swap_range().
> That's not good enough, and part of what I was getting away from with
> the radix_tree exceptional swap changes: there needs to be more, to
> prevent pages moving to swap before the page pass finds them, then
> swap moving to pages before the swap pass finds them.  The old code
> used a flag to go back whenever that might happen, effective but not
> pretty (and I'm not sure complete).  I ought to like your end result,
> with so much code deleted; but somehow I did not, just too attached
> to my own I suppose :) Intervening (fallocate) changes have moved this
> code around, certainly your old patch would not apply, whether they've
> made any material difficulty I've not considered.
>
> As usual, I'm busy with other things, so not actually in any hurry
> for a resend; but thought I'd better let you know what I'd thought,
> in case Johannes' patch prompted you towards a resend.
>
> Hugh

