Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753264Ab3EPRTT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 13:19:19 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:42801 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752754Ab3EPRTO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 13:19:14 -0400
Date: Thu, 16 May 2013 10:19:07 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Robert Love <rlove@google.com>
Cc: Raul Xiong <raulxiong@gmail.com>, Neil Zhang <glacier1980@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Shankar Brahadeeswaran <shankoo77@gmail.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Bjorn Bringert <bringert@google.com>,
        devel <devel@driverdev.osuosl.org>, Hugh Dickins <hughd@google.com>,
        Anjana V Kumar <anjanavk12@gmail.com>,
        linux-next <linux-next@vger.kernel.org>
Subject: Re: [PATCH -next] ashmem: Fix ashmem_shrink deadlock.
Message-Id: <20130516101907.d102dd91.akpm@linux-foundation.org>
In-Reply-To: <CAG6tG3xLydqQTOHaXMpdCo8m+WkydAqgLvi5HW8_djoO-hcf9g@mail.gmail.com>
References: <1367416573-5430-1-git-send-email-rlove@google.com>
	<20130513214216.GA23743@kroah.com>
	<CA+2_TiZ3dECAW8LV-Es=BjHCwgWw69zbWkr73at+0_c-EaDHmA@mail.gmail.com>
	<CAG9bXvkH0L5FjkU3-=3X3zwp3vw8U7+jJRYp28GFXjLkQKBL5g@mail.gmail.com>
	<CAG9bXvkjV6-O3JZH6taVX-dZ1tzbSoqaC_sN00LRszsS4QAnrg@mail.gmail.com>
	<CAG6tG3zaU=gkJZzNezOX=s5WWDrc2x7SHiDy3UxVzDvKkw2foA@mail.gmail.com>
	<20130516094559.4d2c9212.akpm@linux-foundation.org>
	<CAG6tG3xLydqQTOHaXMpdCo8m+WkydAqgLvi5HW8_djoO-hcf9g@mail.gmail.com>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 16 May 2013 13:08:17 -0400 Robert Love <rlove@google.com> wrote:

> On Thu, May 16, 2013 at 12:45 PM, Andrew Morton
> <akpm@linux-foundation.org> wrote:
> > A better approach would be to add a new __GFP_NOSHRINKERS, but it's all
> > variations on a theme.
> 
> I don't like this proposal, either. Many of the existing GFP flags
> already exist to prevent recurse into that flag's respective shrinker.
> 
> This problem seems a rare proper use of mutex_trylock.

Not really.  The need for a trylock is often an indication that a
subsystem has a locking misdesign.  That is indeed the case here.

> > The mutex_trylock(ashmem_mutex) will actually have the best
> > performance, because it skips the least amount of memory reclaim
> > opportunities.
> 
> Right.
> 
> > But it still sucks!  The real problem is that there exists a lock
> > called "ashmem_mutex", taken by both the high-level mmap() and by the
> > low-level shrinker.  And taken by everything else too!  The ashmem
> > locking is pretty crude...
> 
> The locking is "crude" because I optimized for space, not time, and
> there was (and is) no indication we were suffering lock contention due
> to the global lock. I haven't thought through the implications of
> pushing locking into the ashmem_area and ashmem_range objects, but it
> does look like we'd end up often grabbing all of the locks ...
> 
> > What is the mutex_lock() in ashmem_mmap() actually protecting?  I don't
> > see much, apart from perhaps some incidental races around the contents
> > of the file's ashmem_area, and those could/should be protected by a
> > per-object lock, not a global one?
> 
> ... but not, as you note, in ashmem_mmap. The main race there is
> around the allocation of asma->file. That could definitely be a lock
> local to ashmem_area. I'm OK if anyone wants to take that on but it
> seems a lot of work for a driver with an unclear future.

Well, it's not exactly a ton of work, but adding a per-ashmem_area lock
to protect ->file would rather be putting lipstick on a pig.  I suppose
we can put the trylock in there and run away, but it wouldn't hurt to
drop in a big fat comment somewhere explaining that the driver should be
migrated to a per-object locking scheme.

