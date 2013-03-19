Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932730Ab3CSPnY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 11:43:24 -0400
Received: from mailout01.c08.mtsvc.net ([205.186.168.189]:32782 "EHLO
	mailout01.c08.mtsvc.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756995Ab3CSPnU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 11:43:20 -0400
Message-ID: <1363707781.3413.24.camel@thor.lan>
Subject: Re: [PATCH v5 26/44] tty: Add read-recursive, writer-prioritized rw
 semaphore
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jslaby@suse.cz>, Sasha Levin <levinsasha928@gmail.com>,
        Dave Jones <davej@redhat.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Shawn Guo <shawn.guo@linaro.org>, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org
Date: Tue, 19 Mar 2013 11:43:01 -0400
In-Reply-To: <20130319015936.GA21241@kroah.com>
References: <1361390599-15195-1-git-send-email-peter@hurleysoftware.com>
	 <1363034704-28036-1-git-send-email-peter@hurleysoftware.com>
	 <1363034704-28036-27-git-send-email-peter@hurleysoftware.com>
	 <20130318235815.GA5320@kroah.com> <1363654879.4568.42.camel@thor.lan>
	 <20130319015936.GA21241@kroah.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.3-0pjh1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 125194 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 2013-03-18 at 18:59 -0700, Greg Kroah-Hartman wrote:
> On Mon, Mar 18, 2013 at 09:01:19PM -0400, Peter Hurley wrote:
> > On Mon, 2013-03-18 at 16:58 -0700, Greg Kroah-Hartman wrote:
> > > On Mon, Mar 11, 2013 at 04:44:46PM -0400, Peter Hurley wrote:
> > > > 2) TIOCSETD ioctl (change line discipline) expects to return an
> > > >    error if the line discipline cannot be exclusively locked within
> > > >    5 secs. Lock wait timeouts are not supported by rwsem.
> > > 
> > > Don't we have some other lock that can timeout?
> > 
> > Not that behaves like a r/w semaphore.
> 
> Can't we just add it?  Or is that too much work?

See my comments below about rolling your own lock.

> > > > 3) A tty hangup is expected to halt and scrap pending i/o, so
> > > >    exclusive locking must be prioritized without precluding
> > > >    existing reference holders from obtaining recursive read locks.
> > > >    Writer priority is not supported by rwsem.
> > > 
> > > But how bad is it really if we have to wait a bit for that write lock to
> > > get through all of the existing readers?  Either way, we are supposed to
> > > be dropping i/o, so it shouldn't be a big deal, right?
> > 
> > The rwsem behavior is in the process of changing. Write lock stealing
> > has already been added and refinements there will likely allow some
> > readers in front of writers.
> > 
> > With slow serial i/o, I'd rather have hangups occur promptly than let a
> > bunch more i/o through.
> 
> So all we are now lacking, with the changes to rwsem, is the timeout
> problem?

No. What I'm saying is the existing rwsem lock policy is not ideal and
the future lock policy is unlikely to be any more ideal, and possibly
worse.

> > > > Add ld_semaphore which implements these requirements in a
> > > > semantically and operationally similar way to rw_semaphore.
> > > 
> > > I _really_ don't want to add a new lock to the kernel, especially one
> > > that is only used by one "driver".  You are going to have to convince
> > > the current lock authors that this really is needed, before I can take
> > > it, sorry.
> > 
> > That's fine. I can understand the reluctance to take on a new lock
> > [although you might be interested to read my analysis of rwsem here
> > https://lkml.org/lkml/2013/3/11/533 which outlines an existing flaw].
> > 
> > That said, part of the reason why the current ldisc implementation is
> > broken is the lack of appropriate locks. As I recently explained
> > (actually in this patchset's thread),
> > 
> >         a lack of existing options has spawned a DIY approach without
> >         higher-order locks that is rarely correct, but which goes largely
> >         unnoticed exactly because it's not a new lock. A brief review of the
> >         hangs, races, and deadlocks fixed by this patchset should be convincing
> >         enough of that fact. In my opinion, this is the overriding concern.
> >         
> >         The two main problems with a one-size-fits-all lock policy is that,
> >         1) lock experts can't realistically foresee the consequences of policy
> >         changes without already being experts in the subsystems in which that
> >         lock is used. Even domain experts may miss potential consequences, and
> >         2) domain experts typically wouldn't even consider writing a new lock.
> >         So they make do with atomic bit states, spinlocks, reference counts,
> >         mutexes, and waitqueues, making a mostly-functional, higher-order lock. 
> 
> I read that, however rolling your own lock is almost never the solution.

Except that's the whole issue, isn't it?

There is no existing lock solution because there is no r/w semaphore
that times out.

So, no matter what, a new lock is required.

Since there is only one use-case for the new lock, it makes sense for
that lock to have the lock policy best suited for the one use-case,
especially since it's already done.

> > From whom would you like me to get an ack for this?
> 
> The people who wrote the rwsem code?

Ok.


Regards,
Peter Hurley



