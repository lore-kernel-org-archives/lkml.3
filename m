Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753022AbaA3RG6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jan 2014 12:06:58 -0500
Received: from mail.lang.hm ([64.81.33.126]:34007 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751148AbaA3RG4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jan 2014 12:06:56 -0500
Date: Thu, 30 Jan 2014 09:06:54 -0800 (PST)
From: David Lang <david@lang.hm>
X-X-Sender: dlang@asgard.lang.hm
To: Igor Podlesny <for.poige+linux@gmail.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: That greedy Linux VM cache
In-Reply-To: <CA+sTkh4fYZr-8vBuhA0c1BRt5D7oNiK=KrSF+kJ2KRW7e_LFaA@mail.gmail.com>
Message-ID: <alpine.DEB.2.02.1401300902260.11623@nftneq.ynat.uz>
References: <CA+sTkh4fYZr-8vBuhA0c1BRt5D7oNiK=KrSF+kJ2KRW7e_LFaA@mail.gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 31 Jan 2014, Igor Podlesny wrote:

>   Hello!
>
>   Probably every Linux newcomer's going to have concerns regarding
> low free memory and hear an explanation from Linux old fellows that's
> actually there's plenty of -- it's just cached, but when it's needed
> for applications it's gonna be used -- on demand. I also thought so
> until recently I noticed that even when free memory's is almost
> exhausted (~ 75 Mib)

that's actually quite a bit of free memory, it's very common for servers to be 
far lower than that.

> , and processes are in sleep_on_page_killable, the
> cache is somewhat like ~ 500 MiB and it's not going to return back
> what it's gained. Naturally, vm.drop_caches 3 doesn't squeeze it as
> well.

this is telling you that this data isn't clean cache that can just be dropped, 
it's dirty cache that is waiting to be written, or is otherwise locked.

rather than looking at the memory numbers, instead look at the swap numbers. If 
you are doing any noticable amount of swapping (si so in vmstat), then you are 
out of memory and the cache that can be dropped has been dropped.

this does mean that you ahve a hard time telling when you are getting close to 
running out of memory, but it's easy to see when you have.

> That drama has been happening on rather
> outdated-but-yet-still-has-2GiB-of-RAM notebook with kernel from 3.10
> till 3.12.9 (3.13 is the first release for a long time which simply
> freezes the notebook so cold, that SysRq_B's not working, but that's
> another story). Everything RAM demanding just yet crawls, load average
> is getting higher and there's no paging out, but on going disk mostly
> _read_ and a bit write activity. If vm.swaPPineSS not 0, it's swapping
> out, but not much, right now I ran Chromium (in addition to long-run
> Firefox) and only 32 MiB went to swap, load avg. ~ 7

that much read activity probably means that you are swapping pages in to use 
them, then dropping them to swap in another page, which you then drop to go back 
and fetch the first page.

David Lang

>   Again: 25 % is told (by top, free and finally /proc/meminfo) to be
> cached, but kinda greedy.
>
>   I came across similar issue report:
> http://www.spinics.net/lists/linux-btrfs/msg11723.html but still
> questions remain:
>
>   * How to analyze it? slabtop doesn't mention even 100 MiB of slab
>   * Why that's possible?
>   * The system is on Btrfs but /home is on XFS, so disk I/O might be
> related to text segment paging? But anyway this leads us to question,
> hey, there's 500 MiB free^Wcached.
>
>   While I'm thinking about moving system back to XFS...
>
>   P. S. While writing these, swapped ~ 100 MiB, and cache reduced(!)
> to 377 MiB, Firefox is mostly in "D" -- sleep_on_page_killable, so is
> Chrome, load avg. ~ 7. I had to close Skype to be able to finish that
> letter, and cached mem. now is 439 MiB. :) I know it's time to
> upgrade, but hey, cached memory is free memory, right?
>
>
