Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751853Ab3GPGES (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 02:04:18 -0400
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:23270 "EHLO
	ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751490Ab3GPGEQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 02:04:16 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AuwkAC3h5FF5LK4r/2dsb2JhbABagwY0riMCjlKFMAQBgQ8XdIIjAQEEAScTHCMFCwgDGAklDwUlAyETh34DCQUNrUgXiFQWjH2BBDCBHQeDC20Dl1uRToMkKg
Date: Tue, 16 Jul 2013 16:03:51 +1000
From: Dave Chinner <david@fromorbit.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Oleg Nesterov <oleg@redhat.com>, Ben Myers <bpm@sgi.com>,
        xfs@oss.sgi.com
Subject: Re: splice vs execve lockdep trace.
Message-ID: <20130716060351.GE11674@dastard>
References: <20130716015305.GB30569@redhat.com>
 <CA+55aFyLbqJp0-=7=HOF9sKGOHwsa7A7-V76b8tbsnra8Z2=-w@mail.gmail.com>
 <20130716023847.GA31481@redhat.com>
 <CA+55aFxiGXht8+Dox=C2ezYYf1yMaLAzMYr40j=+peP8j5Ha6w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFxiGXht8+Dox=C2ezYYf1yMaLAzMYr40j=+peP8j5Ha6w@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 15, 2013 at 08:25:14PM -0700, Linus Torvalds wrote:
> On Mon, Jul 15, 2013 at 7:38 PM, Dave Jones <davej@redhat.com> wrote:
> >
> >   The recent trinity changes shouldn't have really made
> > any notable difference here.
> 
> Hmm. I'm not aware pf anything that has changed in this area since
> 3.10 - neither in execve, xfs or in splice. Not even since 3.9.

It's been there for years.....

> The "pipe -> cred_guard_mutex" lock chain is pretty direct, and can be
> clearly attributed to splicing into /proc. Now, whether that is a
> *good* idea or not is clearly debatable, and I do think that maybe we
> should just not splice to/from proc files, but that doesn't seem to be
> new, and I don't think it's necessarily *broken* per se, it's just
> that splicing into /proc seems somewhat unnecessary, and various proc
> files do end up taking locks that can be "interesting".

But this is a new way of triggering the inversion, however....

> At the other end of the spectrum, the "cred_guard_mutex -> FS locks"
> thing from execve() is also pretty clear, and probably not fixable or
> necessarily something we'd even want to fix.
> 
> But the "FS locks -> pipe" part is a bit questionable. Honestly, I'd
> be much happier if XFS used generic_file_splice_read/write().
>
> And looking more at that, I'm actually starting to think this is an
> XFS locking problem. XFS really should not call back to splice while
> holding the inode lock.
> 
> But that XFS code doesn't seem new either. Is XFS a new thing for you
> to test with?

I posted patches to fix this i_mutex/i_iolock inversion a couple of
years ago (july 2011):

https://lkml.org/lkml/2011/7/18/4

And V2 was posted here and reviewed (aug 2011):

http://xfs.9218.n7.nabble.com/PATCH-0-2-splice-i-mutex-vs-splice-write-deadlock-V2-tt4072.html#none

It didn't get picked up by with a VFS tree, so sat moldering until
somebody else reported it (Nov 2012) and it reposted it again, only
to have it ignored again:

http://oss.sgi.com/archives/xfs/2012-11/msg00671.html

And I recently discussed it again with Al w.r.t. filesystem freeze
problems he was looking at, and I was waiting for that to settle
down before I posted the fixes again....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
