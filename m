Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757108Ab3CSBBl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 21:01:41 -0400
Received: from mailout02.c08.mtsvc.net ([205.186.168.190]:39694 "EHLO
	mailout02.c08.mtsvc.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753033Ab3CSBBh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 21:01:37 -0400
Message-ID: <1363654879.4568.42.camel@thor.lan>
Subject: Re: [PATCH v5 26/44] tty: Add read-recursive, writer-prioritized rw
 semaphore
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jslaby@suse.cz>, Sasha Levin <levinsasha928@gmail.com>,
        Dave Jones <davej@redhat.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Shawn Guo <shawn.guo@linaro.org>, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org
Date: Mon, 18 Mar 2013 21:01:19 -0400
In-Reply-To: <20130318235815.GA5320@kroah.com>
References: <1361390599-15195-1-git-send-email-peter@hurleysoftware.com>
	 <1363034704-28036-1-git-send-email-peter@hurleysoftware.com>
	 <1363034704-28036-27-git-send-email-peter@hurleysoftware.com>
	 <20130318235815.GA5320@kroah.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.3-0pjh1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 125194 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-03-18 at 16:58 -0700, Greg Kroah-Hartman wrote:
> On Mon, Mar 11, 2013 at 04:44:46PM -0400, Peter Hurley wrote:
> > The semantics of a rw semaphore are almost ideally suited
> > for tty line discipline lifetime management;  multiple active
> > threads obtain "references" (read locks) while performing i/o
> > to prevent the loss or change of the current line discipline
> > (write lock).
> > 
> > Unfortunately, the existing rw_semaphore is ill-suited in other
> > ways;
> > 1) obtaining a "reference" can be recursive, ie., a reference holder
> >    may attempt to obtain another "reference". Recursive read locks
> >    are not supported by rwsem.
> 
> Why does a ldisc need to obtain this recursively?

You already discovered it doesn't (but it used to be required).

BTW, it's only because I had a real lock with lockdep support, that this
recursive usage which deadlocks was even discoverable.

> > 2) TIOCSETD ioctl (change line discipline) expects to return an
> >    error if the line discipline cannot be exclusively locked within
> >    5 secs. Lock wait timeouts are not supported by rwsem.
> 
> Don't we have some other lock that can timeout?

Not that behaves like a r/w semaphore.

> > 3) A tty hangup is expected to halt and scrap pending i/o, so
> >    exclusive locking must be prioritized without precluding
> >    existing reference holders from obtaining recursive read locks.
> >    Writer priority is not supported by rwsem.
> 
> But how bad is it really if we have to wait a bit for that write lock to
> get through all of the existing readers?  Either way, we are supposed to
> be dropping i/o, so it shouldn't be a big deal, right?

The rwsem behavior is in the process of changing. Write lock stealing
has already been added and refinements there will likely allow some
readers in front of writers.

With slow serial i/o, I'd rather have hangups occur promptly than let a
bunch more i/o through.

> > Add ld_semaphore which implements these requirements in a
> > semantically and operationally similar way to rw_semaphore.
> 
> I _really_ don't want to add a new lock to the kernel, especially one
> that is only used by one "driver".  You are going to have to convince
> the current lock authors that this really is needed, before I can take
> it, sorry.

That's fine. I can understand the reluctance to take on a new lock
[although you might be interested to read my analysis of rwsem here
https://lkml.org/lkml/2013/3/11/533 which outlines an existing flaw].

That said, part of the reason why the current ldisc implementation is
broken is the lack of appropriate locks. As I recently explained
(actually in this patchset's thread),

        a lack of existing options has spawned a DIY approach without
        higher-order locks that is rarely correct, but which goes largely
        unnoticed exactly because it's not a new lock. A brief review of the
        hangs, races, and deadlocks fixed by this patchset should be convincing
        enough of that fact. In my opinion, this is the overriding concern.
        
        The two main problems with a one-size-fits-all lock policy is that,
        1) lock experts can't realistically foresee the consequences of policy
        changes without already being experts in the subsystems in which that
        lock is used. Even domain experts may miss potential consequences, and
        2) domain experts typically wouldn't even consider writing a new lock.
        So they make do with atomic bit states, spinlocks, reference counts,
        mutexes, and waitqueues, making a mostly-functional, higher-order lock. 

>From whom would you like me to get an ack for this?

> What is wrong with the existing ldisc code that the creation of this
> lock is needed?  Is our current code that broken?

Yes. Even just the acquistion of the ldisc reference is wrong [the
analysis is in the patch 21 changelog].

If you'd like, I can send you 6 or so short user test programs that
hang, crash, or deadlock inside 60 seconds on mainline and next, but not
with this patchset.

Regards,
Peter Hurley


