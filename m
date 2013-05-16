Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753146Ab3EPR24 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 13:28:56 -0400
Received: from mail-qe0-f52.google.com ([209.85.128.52]:65095 "EHLO
	mail-qe0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752055Ab3EPR2x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 13:28:53 -0400
MIME-Version: 1.0
In-Reply-To: <20130516101907.d102dd91.akpm@linux-foundation.org>
References: <1367416573-5430-1-git-send-email-rlove@google.com>
	<20130513214216.GA23743@kroah.com>
	<CA+2_TiZ3dECAW8LV-Es=BjHCwgWw69zbWkr73at+0_c-EaDHmA@mail.gmail.com>
	<CAG9bXvkH0L5FjkU3-=3X3zwp3vw8U7+jJRYp28GFXjLkQKBL5g@mail.gmail.com>
	<CAG9bXvkjV6-O3JZH6taVX-dZ1tzbSoqaC_sN00LRszsS4QAnrg@mail.gmail.com>
	<CAG6tG3zaU=gkJZzNezOX=s5WWDrc2x7SHiDy3UxVzDvKkw2foA@mail.gmail.com>
	<20130516094559.4d2c9212.akpm@linux-foundation.org>
	<CAG6tG3xLydqQTOHaXMpdCo8m+WkydAqgLvi5HW8_djoO-hcf9g@mail.gmail.com>
	<20130516101907.d102dd91.akpm@linux-foundation.org>
Date: Thu, 16 May 2013 13:28:52 -0400
Message-ID: <CAG6tG3yQVhANm1eHx3W3Hacp8t5Bh=pF9dQbHc3rSVs5n0WR9g@mail.gmail.com>
Subject: Re: [PATCH -next] ashmem: Fix ashmem_shrink deadlock.
From: Robert Love <rlove@google.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Raul Xiong <raulxiong@gmail.com>, Neil Zhang <glacier1980@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Shankar Brahadeeswaran <shankoo77@gmail.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Bjorn Bringert <bringert@google.com>,
        devel <devel@driverdev.osuosl.org>, Hugh Dickins <hughd@google.com>,
        Anjana V Kumar <anjanavk12@gmail.com>,
        linux-next <linux-next@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 16, 2013 at 1:19 PM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Thu, 16 May 2013 13:08:17 -0400 Robert Love <rlove@google.com> wrote:
>> This problem seems a rare proper use of mutex_trylock.
>
> Not really.  The need for a trylock is often an indication that a
> subsystem has a locking misdesign.  That is indeed the case here.

It is exactly the same as PF_MEMALLOC. We've got an effectively
asynchronous event (shrinking) that can occur while you are holding
locks requisite to that shrinking. Given that the shrinkage is best
effort, a trylock actually communicates the intent pretty well: "If
possible, grab this lock and shrink."

I think the idiomatic fix is to introduce a GFP_SHMEM but that seems
overkill. Lots of the GFP flags are really just preventing recursing
into the shrinkage code and it seems ill-designed that we require
developers to know where they might end up. But we can disagree. :)

> Well, it's not exactly a ton of work, but adding a per-ashmem_area lock
> to protect ->file would rather be putting lipstick on a pig.  I suppose
> we can put the trylock in there and run away, but it wouldn't hurt to
> drop in a big fat comment somewhere explaining that the driver should be
> migrated to a per-object locking scheme.

Unfortunately I think ashmem_shrink would need to grab the per-object
lock too; it needs to update the ranges. I'm sure we could re-design
this but I don't think it is as easy as simply pushing the locking
into the objects.

       Robert
