Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932403Ab3GBHa1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 03:30:27 -0400
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:59287 "EHLO
	ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932152Ab3GBHa0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 03:30:26 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: At4LALCA0lF5LCeA/2dsb2JhbABagwmDGbgChSgEAXwXdIIjAQEEAScTHDMIAxgJJQ8FJQMhARKICQW7SBaOIAuBJIMEYwOXR5FGgyMq
Date: Tue, 2 Jul 2013 17:30:20 +1000
From: Dave Chinner <david@fromorbit.com>
To: Dave Jones <davej@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrey Vagin <avagin@openvz.org>, Steven Rostedt <rostedt@goodmis.org>,
        axboe@kernel.dk
Subject: Re: block layer softlockup
Message-ID: <20130702073020.GB14996@dastard>
References: <20130626191853.GA29049@redhat.com>
 <20130627002255.GA16553@redhat.com>
 <20130627075543.GA32195@dastard>
 <20130627143055.GA1000@redhat.com>
 <20130628011843.GD32195@dastard>
 <CA+55aFze-=6e_P1syCs=3b6-xj-itVyZKvpejqBR83gA5tV+4w@mail.gmail.com>
 <20130628035437.GB29338@dastard>
 <20130701175734.GA13641@redhat.com>
 <20130702020741.GE4072@dastard>
 <20130702060146.GA5835@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130702060146.GA5835@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 02, 2013 at 02:01:46AM -0400, Dave Jones wrote:
> On Tue, Jul 02, 2013 at 12:07:41PM +1000, Dave Chinner wrote:
>  > On Mon, Jul 01, 2013 at 01:57:34PM -0400, Dave Jones wrote:
>  > > On Fri, Jun 28, 2013 at 01:54:37PM +1000, Dave Chinner wrote:
>  > >  > On Thu, Jun 27, 2013 at 04:54:53PM -1000, Linus Torvalds wrote:
>  > >  > > On Thu, Jun 27, 2013 at 3:18 PM, Dave Chinner <david@fromorbit.com> wrote:
>  > >  > > >
>  > >  > > > Right, that will be what is happening - the entire system will go
>  > >  > > > unresponsive when a sync call happens, so it's entirely possible
>  > >  > > > to see the soft lockups on inode_sb_list_add()/inode_sb_list_del()
>  > >  > > > trying to get the lock because of the way ticket spinlocks work...
>  > >  > > 
>  > >  > > So what made it all start happening now? I don't recall us having had
>  > >  > > these kinds of issues before..
>  > >  > 
>  > >  > Not sure - it's a sudden surprise for me, too. Then again, I haven't
>  > >  > been looking at sync from a performance or lock contention point of
>  > >  > view any time recently.  The algorithm that wait_sb_inodes() is
>  > >  > effectively unchanged since at least 2009, so it's probably a case
>  > >  > of it having been protected from contention by some external factor
>  > >  > we've fixed/removed recently.  Perhaps the bdi-flusher thread
>  > >  > replacement in -rc1 has changed the timing sufficiently that it no
>  > >  > longer serialises concurrent sync calls as much....
>  > > 
>  > > This mornings new trace reminded me of this last sentence. Related ?
>  > 
>  > Was this running the last patch I posted, or a vanilla kernel?
> 
> yeah, this had v2 of your patch (the one post lockdep warnings)

Ok, I can see how that one might cause that issues to occur. The
current patchset I'm working on doesn't have all the nasty io
completion time stuff in it, so shouldn't cause any problems like
this...

> 
>  > That's doing IO completion processing in softirq time, and the lock
>  > it just dropped was the q->queue_lock. But that lock is held over
>  > end IO processing, so it is possible that the way the page writeback
>  > transition handling of my POC patch caused this.
>  > 
>  > FWIW, I've attached a simple patch you might like to try to see if
>  > it *minimises* the inode_sb_list_lock contention problems. All it
>  > does is try to prevent concurrent entry in wait_sb_inodes() for a
>  > given superblock and hence only have one walker on the contending
>  > filesystem at a time. Replace the previous one I sent with it. If
>  > that doesn't work, I have another simple patch that makes the
>  > inode_sb_list_lock per-sb to take this isolation even further....
>  
> I can try it, though as always, proving a negative....

Very true, though all I'm really interested in is whether you see
the soft lockup warnings or not. i.e. if you don't see them, then we
have a minimal patch that might be sufficient for -stable kernels...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
