Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752940AbaBOXxw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Feb 2014 18:53:52 -0500
Received: from mail-pa0-f45.google.com ([209.85.220.45]:59264 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752047AbaBOXxv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Feb 2014 18:53:51 -0500
Date: Sat, 15 Feb 2014 15:53:06 -0800 (PST)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Andrew Morton <akpm@linux-foundation.org>
cc: Hugh Dickins <hughd@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] swapoff tmpfs radix_tree: remember to rcu_read_unlock
In-Reply-To: <20140213143005.9aea5709d5befd1df84b19a7@linux-foundation.org>
Message-ID: <alpine.LSU.2.11.1402151529060.8605@eggly.anvils>
References: <alpine.LSU.2.11.1402121840500.6398@eggly.anvils> <20140213143005.9aea5709d5befd1df84b19a7@linux-foundation.org>
User-Agent: Alpine 2.11 (LSU 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Feb 2014, Andrew Morton wrote:
> On Wed, 12 Feb 2014 18:45:07 -0800 (PST) Hugh Dickins <hughd@google.com> wrote:
> 
> > Running fsx on tmpfs with concurrent memhog-swapoff-swapon, lots of
> > 
> > BUG: sleeping function called from invalid context at kernel/fork.c:606
> > in_atomic(): 0, irqs_disabled(): 0, pid: 1394, name: swapoff
> > 1 lock held by swapoff/1394:
> >  #0:  (rcu_read_lock){.+.+.+}, at: [<ffffffff812520a1>] radix_tree_locate_item+0x1f/0x2b6
> > followed by
> > ================================================
> > [ BUG: lock held when returning to user space! ]
> > 3.14.0-rc1 #3 Not tainted
> > ------------------------------------------------
> > swapoff/1394 is leaving the kernel with locks still held!
> > 1 lock held by swapoff/1394:
> >  #0:  (rcu_read_lock){.+.+.+}, at: [<ffffffff812520a1>] radix_tree_locate_item+0x1f/0x2b6
> > after which the system recovered nicely.
> > 
> > Whoops, I long ago forgot the rcu_read_unlock() on one unlikely branch.
> > 
> > Fixes: e504f3fdd63d ("tmpfs radix_tree: locate_item to speed up swapoff")
> 
> huh.  Venerable.  I'm surprised that such an obvious blooper wasn't
> spotted at review.  Why didn't anyone else hit this.

No surprise that it missed review, obvious though it is in the fix.

And not much surprise that noone else hit this: for most people, even
those using tmpfs and pushing out to swap, swapoff is just something
that happens shortly before the screen goes blank when you shutdown
(and, I haven't noticed how distros order it these days, but swapoff
is anyway better done after unmounting tmpfss, to avoid its slowness).

And it does need the swapped tmpfs file to be truncated or unlinked
while swapoff is searching through it racily with RCU lookups.

What puzzled me more was, why hadn't I seen it before?  I don't run
that fsx test particularly often, but have certainly run it dozens
of times between then and now.  I think the answer must be where I
said "after which the system recovered nicely": I probably did hit
it before, but wasn't attending to the screen at the time, the
warnings got scrolled off by timestamps I was printing, and I
failed to check dmesg or /var/log/messages afterwards.

> 
> 
> > Of course, the truth is that I had been hoping to break Johannes's
> > patchset in mmotm, was thrilled to get this on that, then despondent
> > to realize that the only bug I had found was mine.  Surprised I've
> > not seen it before in 2.5 years: tried again on 3.14-rc1, got the
> > same after 25 minutes.  Probably not serious enough for -stable,
> > but please can we slip the fix into 3.14 - sorry, Johannes's
> > mm-keep-page-cache-radix-tree-nodes-in-check.patch will need a refresh.
> 
> I fixed it up.

Thanks!

Hugh
