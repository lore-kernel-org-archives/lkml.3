Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934432AbaDIWBj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 18:01:39 -0400
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:9703 "EHLO
	ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933705AbaDIWBh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 18:01:37 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AnhVADTCRVN5LEcvPGdsb2JhbABZgwaDS4ULtnCFXYEkFwMBAQEBODWCJQEBAQMBOhwjBQsIAxIGCSUPBSUDBwYUE4d0B80LFxaNfwYBAU8HgySBFASYXZYFK4EtCBc
Date: Thu, 10 Apr 2014 08:01:30 +1000
From: Dave Chinner <david@fromorbit.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        Linux-Fsdevel <linux-fsdevel@vger.kernel.org>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andy Lutomirski <luto@amacapital.net>, Rob Landley <rob@landley.net>,
        Miklos Szeredi <miklos@szeredi.hu>,
        Christoph Hellwig <hch@infradead.org>, Karel Zak <kzak@redhat.com>,
        "J. Bruce Fields" <bfields@fieldses.org>,
        Fengguang Wu <fengguang.wu@intel.com>
Subject: Re: [GIT PULL] Detaching mounts on unlink for 3.15-rc1
Message-ID: <20140409220130.GB27519@dastard>
References: <CAJfpeguv+7giYNpAuXE9Ja_9BEwB0-fZBVgRSeVqpzSXgQYZ6Q@mail.gmail.com>
 <8761v7h2pt.fsf@tw-ebiederman.twitter.com>
 <CAJfpegtT7y-1HhbEVAMKkdQugTG_w7G_epGtQHGvQLpcZB5FVA@mail.gmail.com>
 <87li281wx6.fsf_-_@xmission.com>
 <87ob28kqks.fsf_-_@xmission.com>
 <874n3n7czm.fsf_-_@xmission.com>
 <87wqezl5df.fsf_-_@x220.int.ebiederm.org>
 <20140409023027.GX18016@ZenIV.linux.org.uk>
 <20140409023947.GY18016@ZenIV.linux.org.uk>
 <87sipmbe8x.fsf@x220.int.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87sipmbe8x.fsf@x220.int.ebiederm.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 09, 2014 at 10:32:14AM -0700, Eric W. Biederman wrote:
> Al Viro <viro@ZenIV.linux.org.uk> writes:
> 
> > On Wed, Apr 09, 2014 at 03:30:27AM +0100, Al Viro wrote:
> >
> >> > When renaming or unlinking directory entries that are not mountpoints
> >> > no additional locks are taken so no performance differences can result,
> >> > and my benchmark reflected that.
> >> 
> >> It also means that d_invalidate() now might trigger fs shutdown.  Which
> >> has bloody huge stack footprint, for obvious reasons.  And d_invalidate()
> >> can be called with pretty deep stack - walk into wrong dentry while
> >> resolving a deeply nested symlink and there you go...
> >
> > PS: I thought I actually replied with that point back a month or so ago,
> > but having checked sent-mail...  Looks like I had not.  My deep apologies.
> >
> > FWIW, I think that overall this thing is a good idea, provided that we can
> > live with semantics changes.  The implementation is too optimistic, though -
> > at the very least, we want this work done upon namespace_unlock() held
> > back until we are not too deep in stack.  task_work_add() fodder,
> > perhaps?
> 
> Hmm.
> 
> Just to confirm what I am dealing with I have proceeded to measure the
> amount of stack used by these operations.
> 
> For resolving a deeply nested symlink that hits the limit of 8 nested
> symlinks, I find 4688 bytes left on the stack.  Which means we use
> roughly 3504 bytes of stack when stating a deeply nested symlink.
> 
> For umount I had a little trouble measuring as typically the work done
> by umount was not the largest stack consumer, but I found for a small
> ext4 filesystem after the umount operation was complete there were
> 5152 bytes left on the stack, or umount used roughly 3040 bytes.

Try XFS, or make sure that the unmount path that you measure does
something that requires memory allocation and triggers memory
reclaim.

> 3504 + 3040 = 6544 bytes of stack used or 1684 bytes of stack left
> unused.  Which certainly isn't a lot of margin but it is not overflowing
> the kernel stack either. 
> 
> Is there a case that see where umount uses a lot more kernel stack?  Is
> your concern an architecture other than x86_64 with different
> limitations?

Anything that enters the block layer IO path can consume upwards of
4-5K of stack because memory allocation occurs right at the bottom
of the IO stack and memory allocation is extremely stack heavy
(think 2.5-3k of stack for a typical GFP_NOIO context allocation
when there is no memory available).

Even scheduling requires you have around 1.5k of stack space
available for the scheduler to do it's stuff so at 1684 bytes of
stack left you're borderline for triggering stack overflow issues if
there's a sleeping lock at that deep leaf function...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
