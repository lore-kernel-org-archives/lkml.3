Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933977Ab3GPUnm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 16:43:42 -0400
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:20305 "EHLO
	ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932993Ab3GPUnk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 16:43:40 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Aq0OAE6v5VF5LK4r/2dsb2JhbABagwa9SoUwBAGBERd0giMBAQQBJxMcIwULCAMYCSUPBSUDIROICgW1ahaOLIEdB4N5A5dbkU6DJCo
Date: Wed, 17 Jul 2013 06:43:35 +1000
From: Dave Chinner <david@fromorbit.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ben Myers <bpm@sgi.com>, Peter Zijlstra <peterz@infradead.org>,
        Oleg Nesterov <oleg@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Dave Jones <davej@redhat.com>, xfs@oss.sgi.com
Subject: Re: splice vs execve lockdep trace.
Message-ID: <20130716204335.GH11674@dastard>
References: <20130716015305.GB30569@redhat.com>
 <CA+55aFyLbqJp0-=7=HOF9sKGOHwsa7A7-V76b8tbsnra8Z2=-w@mail.gmail.com>
 <20130716023847.GA31481@redhat.com>
 <CA+55aFxiGXht8+Dox=C2ezYYf1yMaLAzMYr40j=+peP8j5Ha6w@mail.gmail.com>
 <20130716060351.GE11674@dastard>
 <20130716193332.GB3572@sgi.com>
 <CA+55aFzTBUKStdZu1GhKoiYc2knybhiaUFr2By98QYew_STE=A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFzTBUKStdZu1GhKoiYc2knybhiaUFr2By98QYew_STE=A@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 16, 2013 at 01:18:06PM -0700, Linus Torvalds wrote:
> On Tue, Jul 16, 2013 at 12:33 PM, Ben Myers <bpm@sgi.com> wrote:
> >> >
> >> > And looking more at that, I'm actually starting to think this is an
> >> > XFS locking problem. XFS really should not call back to splice while
> >> > holding the inode lock.
> 
> .. that was misleading, normally "inode lock" would be i_lock, but
> here I meant the XFS-specific i_iolock.
> 
> But you clearly picked up on it:
> 
> > CPU0                            CPU1                            CPU2
> > ----                            ----                            ----
> > lock(&sig->cred_guard_mutex);
> >                                 lock(&pipe->mutex/1);
> >                                                                 lock(&(&ip->io_lock)->mr_lock);
> > lock(&(&ip->io_lock)->mr_lock);
> >                                 lock(&sig->cred_guard_mutex);
> >                                                                 lock(&pipe->mutex/1);
> 
> Yup.
> 
> > I agree that fixing this in XFS seems to be the most reasonable plan,
> > and Dave's approach looks ok to me.  Seems like patch 1 should go
> > through Al's tree, but we'll also need to commit it to the xfs tree
> > prerequisite to patch 2.
> 
> Btw, is there some reason why XFS couldn't just use
> generic_file_splice_read() directly?

Yes - IO is serialised based on the ip->i_iolock, not i_mutex. We
don't use i_mutex for many things IO related, and so internal
locking is needed to serialise against stuff like truncate, hole
punching, etc, that are run through non-vfs interfaces.

> And splice has mmap semantics - the whole point of splice is about
> moving pages around, after all - so I *think* your current
> "xfs_rw_ilock(ip, XFS_IOLOCK_SHARED);" is actually over-serialization.

No, that's just taking the ip->i_iolock in shared mode - that's less
serialisation than holding i_mutex as it allow parallel read
operations but still locks out concurrent buffered writes to the
file (i.e. posix atomic write vs read requirements)

> The pages will be shared by the pipe buffers anyway, so splicing by
> definition doesn't imply full data serialization (because the reading
> of the data itself will happen much later).
> 
> So the per-page serialization done by readpage() should already be
> sufficient, no?
> 
> I dunno. Maybe there's something I'm missing. XFS does seem to wrap
> all the other generic functions in that lock too, but since mmap() etc
> clearly have to be able to get things one page at a time (without any
> wrapping at higher layers), I'm just wondering whether splice_read
> might not be able to avoid it.

Read isn't the problem - it's write that's the deadlock issue...

Cheers,

Dave.
> 
>                      Linus
> 

-- 
Dave Chinner
david@fromorbit.com
