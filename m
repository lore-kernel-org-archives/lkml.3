Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754797Ab3F1HVq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 03:21:46 -0400
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:6305 "EHLO
	ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752072Ab3F1HVp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 03:21:45 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AtENAL04zVF5LB/8/2dsb2JhbABbgwm6XYUhBAGBAxd0giMBAQQBJxMcIwULCAMYCSUPBSUDIRMbh20Fu10WjiKBHQeDAmMDl0SRRoMjKoEuJA
Date: Fri, 28 Jun 2013 17:21:41 +1000
From: Dave Chinner <david@fromorbit.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>,
        Dave Jones <davej@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrey Vagin <avagin@openvz.org>, Steven Rostedt <rostedt@goodmis.org>
Subject: Re: frequent softlockups with 3.10rc6.
Message-ID: <20130628072141.GB9047@dastard>
References: <20130624173510.GA1321@redhat.com>
 <20130625153520.GA7784@redhat.com>
 <20130626191853.GA29049@redhat.com>
 <20130627002255.GA16553@redhat.com>
 <20130627075543.GA32195@dastard>
 <20130627143055.GA1000@redhat.com>
 <20130628011843.GD32195@dastard>
 <CA+55aFze-=6e_P1syCs=3b6-xj-itVyZKvpejqBR83gA5tV+4w@mail.gmail.com>
 <20130628035437.GB29338@dastard>
 <CA+55aFyZYsbMpP+6dkdkhdDn9gpTx0dkv25MUtcnswer_a2x9w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFyZYsbMpP+6dkdkhdDn9gpTx0dkv25MUtcnswer_a2x9w@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 27, 2013 at 07:59:50PM -1000, Linus Torvalds wrote:
> On Thu, Jun 27, 2013 at 5:54 PM, Dave Chinner <david@fromorbit.com> wrote:
> > On Thu, Jun 27, 2013 at 04:54:53PM -1000, Linus Torvalds wrote:
> >>
> >> So what made it all start happening now? I don't recall us having had
> >> these kinds of issues before..
> >
> > Not sure - it's a sudden surprise for me, too. Then again, I haven't
> > been looking at sync from a performance or lock contention point of
> > view any time recently.  The algorithm that wait_sb_inodes() is
> > effectively unchanged since at least 2009, so it's probably a case
> > of it having been protected from contention by some external factor
> > we've fixed/removed recently.  Perhaps the bdi-flusher thread
> > replacement in -rc1 has changed the timing sufficiently that it no
> > longer serialises concurrent sync calls as much....
> >
> > However, the inode_sb_list_lock is known to be a badly contended
> > lock from a create/unlink fastpath for XFS, so it's not like this sort
> > of thing is completely unexpected.
> 
> That whole inode_sb_list_lock seems moronic. Why isn't it a per-sb
> one? No, that won't fix all problems, but it might at least help a
> *bit*.

Historic. That's how we initially split up the old global inode_lock
in 2.6.38 in preparation for the RCU dentry walk code. It was never
intended as a long term solution.....

Besides, making the inode_sb_list_lock per sb won't help solve this
problem, anyway. The case that I'm testing involves a filesystem
that contains 99.97% of all inodes cached by the system. This is a
pretty common situation....

> Also, looking some more now at that wait_sb_inodes logic, I have to
> say that if the problem is primarily the inode->i_lock, then that's
> just crazy. We normally shouldn't even *need* that lock, since we
> could do a totally unlocked iget() as long as the count is non-zero.

The problem is not the inode->i_lock. lockstat is pretty clear on
that...

> And no, I don't think really need the i_lock for checking
> "mapping->nrpages == 0" or the magical "inode is being freed" bits
> either. Or at least we could easily do some of this optimistically for
> the common cases.

Right, we could check some of it optimisitcally, but we'd still be
walking millions of inodes under the inode_sb_list_lock on each
sync() call just to find the one inode that is dirty. It's like
polishing a turd - no matter how shiny you make it, it's still just
a pile of shit.

> I'm attaching a pretty trivial patch, which may obviously be trivially
> totally flawed. I have not tested this in any way, but half the new
> lines are comments about why it's doing what it is doing.  And I
> really think that it should make the "actually take the inode lock" be
> something quite rare.

It looks ok, but I still think it is solving the wrong problem.
FWIW, your optimisation has much wider application that just this
one place. I'll have a look to see how we can apply this approach
across all the inode lookup+validate code we currently have that
unconditionally takes the inode->i_lock....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
