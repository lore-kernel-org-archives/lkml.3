Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933171Ab3CSB6W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 21:58:22 -0400
Received: from mail-pb0-f45.google.com ([209.85.160.45]:46125 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755882Ab3CSB6V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 21:58:21 -0400
Date: Mon, 18 Mar 2013 18:59:36 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Peter Hurley <peter@hurleysoftware.com>
Cc: Jiri Slaby <jslaby@suse.cz>, Sasha Levin <levinsasha928@gmail.com>,
        Dave Jones <davej@redhat.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Shawn Guo <shawn.guo@linaro.org>, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org
Subject: Re: [PATCH v5 26/44] tty: Add read-recursive, writer-prioritized rw
 semaphore
Message-ID: <20130319015936.GA21241@kroah.com>
References: <1361390599-15195-1-git-send-email-peter@hurleysoftware.com>
 <1363034704-28036-1-git-send-email-peter@hurleysoftware.com>
 <1363034704-28036-27-git-send-email-peter@hurleysoftware.com>
 <20130318235815.GA5320@kroah.com>
 <1363654879.4568.42.camel@thor.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1363654879.4568.42.camel@thor.lan>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 18, 2013 at 09:01:19PM -0400, Peter Hurley wrote:
> On Mon, 2013-03-18 at 16:58 -0700, Greg Kroah-Hartman wrote:
> > On Mon, Mar 11, 2013 at 04:44:46PM -0400, Peter Hurley wrote:
> > > 2) TIOCSETD ioctl (change line discipline) expects to return an
> > >    error if the line discipline cannot be exclusively locked within
> > >    5 secs. Lock wait timeouts are not supported by rwsem.
> > 
> > Don't we have some other lock that can timeout?
> 
> Not that behaves like a r/w semaphore.

Can't we just add it?  Or is that too much work?

> > > 3) A tty hangup is expected to halt and scrap pending i/o, so
> > >    exclusive locking must be prioritized without precluding
> > >    existing reference holders from obtaining recursive read locks.
> > >    Writer priority is not supported by rwsem.
> > 
> > But how bad is it really if we have to wait a bit for that write lock to
> > get through all of the existing readers?  Either way, we are supposed to
> > be dropping i/o, so it shouldn't be a big deal, right?
> 
> The rwsem behavior is in the process of changing. Write lock stealing
> has already been added and refinements there will likely allow some
> readers in front of writers.
> 
> With slow serial i/o, I'd rather have hangups occur promptly than let a
> bunch more i/o through.

So all we are now lacking, with the changes to rwsem, is the timeout
problem?

> > > Add ld_semaphore which implements these requirements in a
> > > semantically and operationally similar way to rw_semaphore.
> > 
> > I _really_ don't want to add a new lock to the kernel, especially one
> > that is only used by one "driver".  You are going to have to convince
> > the current lock authors that this really is needed, before I can take
> > it, sorry.
> 
> That's fine. I can understand the reluctance to take on a new lock
> [although you might be interested to read my analysis of rwsem here
> https://lkml.org/lkml/2013/3/11/533 which outlines an existing flaw].
> 
> That said, part of the reason why the current ldisc implementation is
> broken is the lack of appropriate locks. As I recently explained
> (actually in this patchset's thread),
> 
>         a lack of existing options has spawned a DIY approach without
>         higher-order locks that is rarely correct, but which goes largely
>         unnoticed exactly because it's not a new lock. A brief review of the
>         hangs, races, and deadlocks fixed by this patchset should be convincing
>         enough of that fact. In my opinion, this is the overriding concern.
>         
>         The two main problems with a one-size-fits-all lock policy is that,
>         1) lock experts can't realistically foresee the consequences of policy
>         changes without already being experts in the subsystems in which that
>         lock is used. Even domain experts may miss potential consequences, and
>         2) domain experts typically wouldn't even consider writing a new lock.
>         So they make do with atomic bit states, spinlocks, reference counts,
>         mutexes, and waitqueues, making a mostly-functional, higher-order lock. 

I read that, however rolling your own lock is almost never the solution.

> From whom would you like me to get an ack for this?

The people who wrote the rwsem code?

> > What is wrong with the existing ldisc code that the creation of this
> > lock is needed?  Is our current code that broken?
> 
> Yes. Even just the acquistion of the ldisc reference is wrong [the
> analysis is in the patch 21 changelog].

Yes, very nice work, I'm not saying that this isn't a messed up area at
all, it's just that such deep flaws that require a new type of a lock
don't usually come up all that often.

> If you'd like, I can send you 6 or so short user test programs that
> hang, crash, or deadlock inside 60 seconds on mainline and next, but not
> with this patchset.

That would be interesting to have, please send them.

And I hope that they only lock up when run as root, but I'm afraid to
ask that question...

thanks,

greg k-h
