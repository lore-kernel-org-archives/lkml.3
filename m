Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756240Ab3EPIPx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 04:15:53 -0400
Received: from mail-ie0-f169.google.com ([209.85.223.169]:56301 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755310Ab3EPIPu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 04:15:50 -0400
MIME-Version: 1.0
In-Reply-To: <CAG9bXvkH0L5FjkU3-=3X3zwp3vw8U7+jJRYp28GFXjLkQKBL5g@mail.gmail.com>
References: <1367416573-5430-1-git-send-email-rlove@google.com>
	<20130513214216.GA23743@kroah.com>
	<CA+2_TiZ3dECAW8LV-Es=BjHCwgWw69zbWkr73at+0_c-EaDHmA@mail.gmail.com>
	<CAG9bXvkH0L5FjkU3-=3X3zwp3vw8U7+jJRYp28GFXjLkQKBL5g@mail.gmail.com>
Date: Thu, 16 May 2013 16:15:49 +0800
Message-ID: <CAG9bXvkjV6-O3JZH6taVX-dZ1tzbSoqaC_sN00LRszsS4QAnrg@mail.gmail.com>
Subject: Re: [PATCH -next] ashmem: Fix ashmem_shrink deadlock.
From: Raul Xiong <raulxiong@gmail.com>
To: Neil Zhang <glacier1980@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Robert Love <rlove@google.com>,
        Shankar Brahadeeswaran <shankoo77@gmail.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Bjorn Bringert <bringert@google.com>,
        devel <devel@driverdev.osuosl.org>, Hugh Dickins <hughd@google.com>,
        Anjana V Kumar <anjanavk12@gmail.com>, Dad <akpm@linux-foundation.org>,
        linux-next <linux-next@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/5/14 Raul Xiong <raulxiong@gmail.com>
>
> 2013/5/14 Neil Zhang <glacier1980@gmail.com>:
> > 2013/5/14 Greg Kroah-Hartman <gregkh@linuxfoundation.org>:
> >> On Wed, May 01, 2013 at 09:56:13AM -0400, Robert Love wrote:
> >>> Don't acquire ashmem_mutex in ashmem_shrink if we've somehow recursed
> >>> into the
> >>> shrinker code from within ashmem. Just bail out, avoiding a deadlock.
> >>> This is
> >>> fine, as ashmem cache pruning is advisory anyhow.
> >>>
> >>> Signed-off-by: Robert Love <rlove@google.com>
> >>> ---
> >>>  drivers/staging/android/ashmem.c | 6 +++++-
> >>>  1 file changed, 5 insertions(+), 1 deletion(-)
> >>
> >> Based on Andrew's review comments, I'll drop this from my queue and wait
> >> for a "better" fix for this.
> >>
> >> thanks,
> >>
> >> greg k-h
> >> --
> >> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> >> the body of a message to majordomo@vger.kernel.org
> >> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >> Please read the FAQ at  http://www.tux.org/lkml/
> >
> > We found the similar issue these days.
> > Add RaulXiong to paste the call stack.
> >
> > Best Regards,
> > Neil Zhang
>
> Hi all,
> I just encountered this deadlock during some stress test and it can be
> described clearly by below function stack. Please check and suggest a
> formal fix for it.
>
> [<c05d3370>] (__schedule) from [<c05d3818>]
> [<c05d3818>] (schedule_preempt_disabled) from [<c05d2578>]
> [<c05d2578>] (__mutex_lock_slowpath) from [<c05d263c>]
> [<c05d263c>] (mutex_lock) from [<c0441dd8>]
> [<c0441dd8>] (ashmem_shrink) from [<c01ae00c>]
> [<c01ae00c>] (shrink_slab) from [<c01b0ec8>]
> [<c01b0ec8>] (try_to_free_pages) from [<c01a65ec>]
> [<c01a65ec>] (__alloc_pages_nodemask) from [<c01d0414>]
> [<c01d0414>] (new_slab) from [<c05cf3a0>]
> [<c05cf3a0>] (__slab_alloc.isra.46.constprop.52) from [<c01d08cc>]
> [<c01d08cc>] (kmem_cache_alloc) from [<c01b1f6c>]
> [<c01b1f6c>] (shmem_alloc_inode) from [<c01e8d18>]
> [<c01e8d18>] (alloc_inode) from [<c01ea3c4>]
> [<c01ea3c4>] (new_inode_pseudo) from [<c01ea404>]
> [<c01ea404>] (new_inode) from [<c01b157c>]
> [<c01b157c>] (shmem_get_inode) from [<c01b3eac>]
> [<c01b3eac>] (shmem_file_setup) from [<c0441d1c>]
> [<c0441d1c>] (ashmem_mmap) from [<c01c1908>]
> [<c01c1908>] (mmap_region) from [<c01c1eac>]
> [<c01c1eac>] (sys_mmap_pgoff) from [<c0112d80>]
>
> Thanks,
> Raul Xiong



Hi Andrew, Greg,

Any feedback?

The issue happens in such sequence:
ashmem_mmap acquired ashmem_mutex --> ashmem_mutex:shmem_file_setup
called kmem_cache_alloc --> shrink due to low memory --> ashmem_shrink
tries to acquire the same ashmem_mutex -- it blocks here.

I think this reports the bug clearly. Please have a look.


Thanks,
Raul Xiong
