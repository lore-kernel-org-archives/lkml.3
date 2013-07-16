Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933901Ab3GPTdl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 15:33:41 -0400
Received: from relay2.sgi.com ([192.48.179.30]:51047 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933239Ab3GPTdj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 15:33:39 -0400
Date: Tue, 16 Jul 2013 14:33:32 -0500
From: Ben Myers <bpm@sgi.com>
To: Dave Chinner <david@fromorbit.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Oleg Nesterov <oleg@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Dave Jones <davej@redhat.com>, xfs@oss.sgi.com
Subject: Re: splice vs execve lockdep trace.
Message-ID: <20130716193332.GB3572@sgi.com>
References: <20130716015305.GB30569@redhat.com>
 <CA+55aFyLbqJp0-=7=HOF9sKGOHwsa7A7-V76b8tbsnra8Z2=-w@mail.gmail.com>
 <20130716023847.GA31481@redhat.com>
 <CA+55aFxiGXht8+Dox=C2ezYYf1yMaLAzMYr40j=+peP8j5Ha6w@mail.gmail.com>
 <20130716060351.GE11674@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130716060351.GE11674@dastard>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dave, Linus,

On Tue, Jul 16, 2013 at 04:03:51PM +1000, Dave Chinner wrote:
> On Mon, Jul 15, 2013 at 08:25:14PM -0700, Linus Torvalds wrote:
> > On Mon, Jul 15, 2013 at 7:38 PM, Dave Jones <davej@redhat.com> wrote:
> > >
> > >   The recent trinity changes shouldn't have really made
> > > any notable difference here.
> > 
> > Hmm. I'm not aware pf anything that has changed in this area since
> > 3.10 - neither in execve, xfs or in splice. Not even since 3.9.
> 
> It's been there for years.....
> 
> > The "pipe -> cred_guard_mutex" lock chain is pretty direct, and can be
> > clearly attributed to splicing into /proc. Now, whether that is a
> > *good* idea or not is clearly debatable, and I do think that maybe we
> > should just not splice to/from proc files, but that doesn't seem to be
> > new, and I don't think it's necessarily *broken* per se, it's just
> > that splicing into /proc seems somewhat unnecessary, and various proc
> > files do end up taking locks that can be "interesting".
> 
> But this is a new way of triggering the inversion, however....
> 
> > At the other end of the spectrum, the "cred_guard_mutex -> FS locks"
> > thing from execve() is also pretty clear, and probably not fixable or
> > necessarily something we'd even want to fix.
> > 
> > But the "FS locks -> pipe" part is a bit questionable. Honestly, I'd
> > be much happier if XFS used generic_file_splice_read/write().
> >
> > And looking more at that, I'm actually starting to think this is an
> > XFS locking problem. XFS really should not call back to splice while
> > holding the inode lock.

CPU0				CPU1				CPU2
----				----				----
lock(&sig->cred_guard_mutex);
				lock(&pipe->mutex/1);
								lock(&(&ip->io_lock)->mr_lock);
lock(&(&ip->io_lock)->mr_lock);
				lock(&sig->cred_guard_mutex);
								lock(&pipe->mutex/1);

CPU0 is do_execve_common, which called prepare_bprm_creds which takes the
cred_guard_mutex, and it is held across the call to xfs_file_aio_read, which
takes the iolock.

CPU1 is the /proc related codepath, where splice_from_pipe has held the
pipe_lock across the call to __splice_from_pipe, where proc_pid_attr_write is
eventually called and goes takes the cred_guard_mutex.

CPU2 is xfs_file_splice_write, which takes the iolock and holds it across the
call to generic_file_splice_write, which takes the pipe_mutex.

Yeah, I'll buy that.

> > But that XFS code doesn't seem new either. Is XFS a new thing for you
> > to test with?
> 
> I posted patches to fix this i_mutex/i_iolock inversion a couple of
> years ago (july 2011):
> 
> https://lkml.org/lkml/2011/7/18/4
> 
> And V2 was posted here and reviewed (aug 2011):
> 
> http://xfs.9218.n7.nabble.com/PATCH-0-2-splice-i-mutex-vs-splice-write-deadlock-V2-tt4072.html#none
> 
> It didn't get picked up by with a VFS tree, so sat moldering until
> somebody else reported it (Nov 2012) and it reposted it again, only
> to have it ignored again:
> 
> http://oss.sgi.com/archives/xfs/2012-11/msg00671.html
> 
> And I recently discussed it again with Al w.r.t. filesystem freeze
> problems he was looking at, and I was waiting for that to settle
> down before I posted the fixes again....

I agree that fixing this in XFS seems to be the most reasonable plan,
and Dave's approach looks ok to me.  Seems like patch 1 should go
through Al's tree, but we'll also need to commit it to the xfs tree
prerequisite to patch 2.

Dave, I'm sorry for my part in letting these moulder.  I'll be happy to
review them once you have reposted.

Thanks,
Ben
