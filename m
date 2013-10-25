Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755201Ab3JYBMa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Oct 2013 21:12:30 -0400
Received: from mail-ie0-f181.google.com ([209.85.223.181]:42795 "EHLO
	mail-ie0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753807Ab3JYBM2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Oct 2013 21:12:28 -0400
MIME-Version: 1.0
In-Reply-To: <5269BCCC.6090509@codeaurora.org>
References: <526844E6.1080307@codeaurora.org>
	<52686FF4.5000303@oracle.com>
	<5269BCCC.6090509@codeaurora.org>
Date: Thu, 24 Oct 2013 18:12:28 -0700
Message-ID: <CAA25o9R_jAZyGFU3xYVjsxCCiBwiEC4gRw+JX6WG9X7G-E3LNw@mail.gmail.com>
Subject: Re: zram/zsmalloc issues in very low memory conditions
From: Luigi Semenzato <semenzato@google.com>
To: Olav Haugan <ohaugan@codeaurora.org>
Cc: Bob Liu <bob.liu@oracle.com>, Minchan Kim <minchan@kernel.org>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 24, 2013 at 5:35 PM, Olav Haugan <ohaugan@codeaurora.org> wrote:
> Hi Bob, Luigi,
>
> On 10/23/2013 5:55 PM, Bob Liu wrote:
>>
>> On 10/24/2013 05:51 AM, Olav Haugan wrote:
>>> I am trying to use zram in very low memory conditions and I am having
>>> some issues. zram is in the reclaim path. So if the system is very low
>>> on memory the system is trying to reclaim pages by swapping out (in this
>>> case to zram). However, since we are very low on memory zram fails to
>>> get a page from zsmalloc and thus zram fails to store the page. We get
>>> into a cycle where the system is low on memory so it tries to swap out
>>> to get more memory but swap out fails because there is not enough memory
>>> in the system! The major problem I am seeing is that there does not seem
>>> to be a way for zram to tell the upper layers to stop swapping out
>>> because the swap device is essentially "full" (since there is no more
>>> memory available for zram pages). Has anyone thought about this issue
>>> already and have ideas how to solve this or am I missing something and I
>>> should not be seeing this issue?
>>>
>>
>> The same question as Luigi "What do you want the system to do at this
>> point?"
>>
>> If swap fails then OOM killer will be triggered, I don't think this will
>> be a issue.
>
> I definitely don't want OOM killer to run since OOM killer can kill
> critical processes (this is on Android so we have Android LMK to handle
> the killing in a more "safe" way). However, what I am seeing is that
> when I run low on memory zram fails to swap out and returns error but
> the swap subsystem just continues to try to swap out even when this
> error occurs (it tries over and over again very rapidly causing the
> kernel to be filled with error messages [at least two error messages per
> failure btw]).
>
> What I expected to happen is for the swap subsystem to stop trying to
> swap out until memory is available to swap out. I guess this could be
> handled several ways. Either 1) the swap subsystem, upon encountering an
> error to swap out, backs off from trying to swap out for some time or 2)
> zram informs the swap subsystem that the swap device is full.

There is a lot I don't know, both about the specifics of your case and
the MM subsystem in general, so I'll make some guesses.  Don't trust
anything I say here (as if you would anyway :-).

As the system gets low on memory, the MM tries to reclaim it in
various ways.  The biggest (I think) sources of reclaim come from
swapping out anonymous pages (process data), and discarding
file-backed pages (code, for instance).  The "swappiness" parameter
decides how much attention to give to each of these types of memory.

It's possible that you get in a situation in which attempts to swap
out anonymous pages with zram fail because you're out of memory at
that point, but then some memory is reclaimed by discarding file
pages, and that's why you don't see OOM kills or kernel panic.  Either
way you should be really close to that moment, unless something funny
is going on.

You could try to snapshot the memory usage when those message are
produced.  You can, for instance, use SysRQ-M to dump a bunch of data
in the syslog.  You may also want to monitor the zram device
utlization from the sysfs.

It's possible that by the time you see those messages you're already
thrashing badly and that things slowed down so much that you aren't
quite getting to the OOM killer.  You could try to reduce the size of
your swap device, and/or change the swappiness.

By the way, I am under the impression that Android uses the OOM killer
as part of their memory management strategy.


> Could this be handled by congestion control? However, I found the
> following comment in the code in vmscan.c:
>
> * If the page is swapcache, write it back even if that would
> * block, for some throttling. This happens by accident, because
> * swap_backing_dev_info is bust: it doesn't reflect the
> * congestion state of the swapdevs.  Easy to fix, if needed.
>
> However, how would one update the congested state of zram when it
> becomes un-congested?
>
>> By the way, could you take a try with zswap? Which can write pages to
>> real swap device if compressed pool is full.
>
> zswap might not be feasible in all cases if you only have flash as
> backing storage.

Zswap can be configured to run without a backing storage.

>
>>> I am also seeing a couple other issues that I was wondering whether
>>> folks have already thought about:
>>>
>>> 2) zsmalloc fails when the page allocated is at physical address 0 (pfn
>>
>> AFAIK, this will never happen.
>
> I can easily get this to happen since I have memory starting at physical
> address 0.
>
> Thanks,
>
> Olav Haugan
>
> --
> The Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
> hosted by The Linux Foundation
