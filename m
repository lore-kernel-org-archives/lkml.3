Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752838AbaD0ENy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2014 00:13:54 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:35419 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751902AbaD0ENw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2014 00:13:52 -0400
MIME-Version: 1.0
In-Reply-To: <CAL1ERfMPcfyUeACnmZ2QF5WxJUQ2PaKbtRzis8sPbQsjnvf_GQ@mail.gmail.com>
References: <1397922764-1512-1-git-send-email-ddstreet@ieee.org>
 <1397922764-1512-3-git-send-email-ddstreet@ieee.org> <CAL1ERfMPcfyUeACnmZ2QF5WxJUQ2PaKbtRzis8sPbQsjnvf_GQ@mail.gmail.com>
From: Dan Streetman <ddstreet@ieee.org>
Date: Sun, 27 Apr 2014 00:13:30 -0400
X-Google-Sender-Auth: K3hWrsPd78lo_E4227SJzVDFUvo
Message-ID: <CALZtONB4j=yd=cGBnkHy0+H0nyUCwG3PGb4K6XYCyRHA=mqt-g@mail.gmail.com>
Subject: Re: [PATCH 2/4] mm: zpool: implement zsmalloc shrinking
To: Weijie Yang <weijie.yang.kh@gmail.com>
Cc: Seth Jennings <sjennings@variantweb.net>, Minchan Kim <minchan@kernel.org>,
        Nitin Gupta <ngupta@vflare.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Bob Liu <bob.liu@oracle.com>, Hugh Dickins <hughd@google.com>,
        Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        Weijie Yang <weijie.yang@samsung.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Linux-MM <linux-mm@kvack.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 26, 2014 at 4:37 AM, Weijie Yang <weijie.yang.kh@gmail.com> wrote:
> On Sat, Apr 19, 2014 at 11:52 PM, Dan Streetman <ddstreet@ieee.org> wrote:
>> Add zs_shrink() and helper functions to zsmalloc.  Update zsmalloc
>> zs_create_pool() creation function to include ops param that provides
>> an evict() function for use during shrinking.  Update helper function
>> fix_fullness_group() to always reinsert changed zspages even if the
>> fullness group did not change, so they are updated in the fullness
>> group lru.  Also update zram to use the new zsmalloc pool creation
>> function but pass NULL as the ops param, since zram does not use
>> pool shrinking.
>>
>
> I only review the code without test, however, I think this patch is
> not acceptable.
>
> The biggest problem is it will call zswap_writeback_entry() under lock,
> zswap_writeback_entry() may sleep, so it is a bug. see below

thanks for catching that!

>
> The 3/4 patch has a lot of #ifdef, I don't think it's a good kind of
> abstract way.

it has the #ifdef's because there's no point in compiling in code to
use zbud/zsmalloc if zbud/zsmalloc isn't compiled...what alternative
to #ifdef's would you suggest?  Or are there just specific #ifdefs you
suggest to remove?

>
> What about just disable zswap reclaim when using zsmalloc?
> There is a long way to optimize writeback reclaim(both zswap and zram) ,
> Maybe a small and simple step forward is better.

I think it's possible to just remove the zspage from the class while
under lock, then unlock and reclaim it.  As long as there's a
guarantee that zswap (or any zpool/zsmalloc reclaim user) doesn't
map/access the handle after evict() completes successfully, that
should work.  There does need to be some synchronization between
zs_free() and each handle's eviction though, similar to zbud's
under_reclaim flag.  I'll work on a v2 patch.
