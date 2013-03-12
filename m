Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932881Ab3CLQr7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 12:47:59 -0400
Received: from mailout02.c08.mtsvc.net ([205.186.168.190]:43558 "EHLO
	mailout02.c08.mtsvc.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932188Ab3CLQrz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 12:47:55 -0400
Message-ID: <1363106846.27803.174.camel@thor.lan>
Subject: Re: [PATCH v5 00/44] ldisc patchset
From: Peter Hurley <peter@hurleysoftware.com>
To: Michel Lespinasse <walken@google.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, Sasha Levin <levinsasha928@gmail.com>,
        Dave Jones <davej@redhat.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Shawn Guo <shawn.guo@linaro.org>, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org
Date: Tue, 12 Mar 2013 12:47:26 -0400
In-Reply-To: <CANN689HvZK3gHyxRBPZyXwz2cJfheiEoQMA23oRARMCp=7GUCQ@mail.gmail.com>
References: <1361390599-15195-1-git-send-email-peter@hurleysoftware.com>
	 <1363034704-28036-1-git-send-email-peter@hurleysoftware.com>
	 <CANN689HvZK3gHyxRBPZyXwz2cJfheiEoQMA23oRARMCp=7GUCQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.3-0pjh1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 125194 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-03-11 at 19:28 -0700, Michel Lespinasse wrote:
> On Mon, Mar 11, 2013 at 1:44 PM, Peter Hurley <peter@hurleysoftware.com> wrote:
> > Greg,
> > This patchset includes
> >   'tty: Drop lock contention stat from ldsem trylocks'
> > so no need to apply that on this series. Also, I noticed you
> > kept the 'tty is NULL' removal on a different branch so I left
> > my patch in this series that removes it.
> >
> > This series applies cleanly to tty-next.
> >
> > v5 changes:
> >
> > After completing an audit of the recursive use of ldisc
> > references, I discovered the _blocking_ recursive acquisition
> > of ldisc references was limited to line disciplines misusing
> > the tty_perform_flush() function.
> > With that now resolved in,
> >   'tty: Fix recursive deadlock in tty_perform_flush()'
> > the recursion design in ldsem has been removed.
> >
> > The recursion removal is in its own patch,
> >   'tty: Remove ldsem recursion support'
> > to ease review for those that have already reviewed the
> > ldsem implementation.
> >
> > In addition, this patchset implements lock stealing derived
> > from the work of Michel Lespinasse <walken@google.com> on
> > writer lock stealing in rwsem.
> >
> > Although the rwsem write lock stealing changes are motivated
> > by performance criteria, these changes are motivated by reduced
> > code line count and simplicity of design.
> >
> > *** Edited below to remove recursion discussion ***
> >
> > Back in early December I realized that a classic read/write semaphore
> > with writer priority was the ideal mechanism for handling the
> > line discipline referencing.
> >
> > Line discipline references act as "readers"; closing or changing the
> > line discipline is prevented while these references are outstanding.
> > Conversely, line discipline references should not be granted while
> > the line discipline is closing or changing; these are the "writers".
> >
> > Unfortunately, the existing rwsem uses a FIFO priority for
> > waiting threads and does not support timeouts.
> >
> > So this implements just that: a writer-priority
> > read/write semaphore with timed waits.
> 
> Thanks for eliminating the recursion requirement. I think this really
> helps - I didn't like that multiple readers with a colliding current
> hash could basically starve out a writer forever.

Yeah, writer starvation was a definite down-side. It looked like the
only option at the time.

> Not knowing anything about the tty layer, I am curious about the
> context for your other requirements. What are ldisc references taken
> for and for how long are they held ? I am surprised that the writers
> may hit a 5 second timeout (because I didn't expect the references to
> be held for very long).

Some background:

A line discipline (ldisc) abstracts raw device-side i/o for the tty
layer. The line discipline is responsible for i/o translation,
buffering, and flow control. Line disciplines can also provide other
features, such as i/o routing; eg., N_PPP routes serial i/o out to the
network stack, instead of providing user-space file i/o.

Line disciplines are packaged as loadable drivers. Each tty device has
its own 'instance' of a line discipline. In addition, a tty's line
discipline can be changed via the TIOCSETD ioctl.

The N_TTY line discipline is the default ldisc and implements the
standard terminal control features such as ^C -> SIGINT, CR/NL mangling,
echoing and line-edit mode.

While the tty layer manages the state of the tty device and provides the
user-space file i/o interface, the line discipline actually implements
the file i/o. This means that user-space blocking reads and blocking
polls block in the respective line discipline i/o methods.

Ldisc references:

Line discipline (ldisc) references pin the tty device's ldisc instance
while in use. This can be short -- eg., when device-side input is
received -- or can be really long -- eg., getty uses blocking read to
park the virtual terminals.

Two requirements complicate this otherwise straightforward
reference-counting pattern.

First, the TIOCSETD ioctl must change the line discipline atomically
wrt. user-space file i/o _and_ device-side i/o. Of course, this can only
happen if there are no existing references to this ldisc. Since ldisc
references have highly variable lifetimes, changing the line discipline
may fail if all existing references to this ldisc are not released. Thus
the lock timeout requirement.

Second, ttys can be hung up, synchronously (like logout and usb
disconnect) and asynchronously (like carrier loss). A tty hangup
recycles the ldisc so at the conclusion of the tty hangup, a fresh reset
ldisc is ready for use. This idiosyncrasy is both a security measure,
and also a requirement to support legacy logins which don't properly
reset the terminal state.

>From the point at which a hangup occurs, all current and future i/o must
cease. Foreground processes which may have existing ldisc references are
signalled so they can exit the ldisc i/o loop and drop their references.

> Also why the write-priority requirement rather than reader-writer
> fairness ? Is it to make it less likely to hit the writer timeouts ?

Since tty i/o can be really [painfully] slow, allowing waiting future
references to succeed is not an option.

> In short: I am worried about the introduciton of a new lock type, and
> would be happier if rwsem could be made to fit. BTW, extending rwsem
> itself to add writer timeouts seems quite doable (but making it work
> as a write priority lock would seem like a bad idea).

I understand the concern regarding the potential proliferation of new
lock types. Lock implementations are hard to get right, and no one wants
to debug 7 different lock policy implementations of a read/write
semaphore.

OTOH, a lack of existing options has spawned a DIY approach without
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

I won't make a case for 2) above, as I think that's self-evident.

As an example of 1) above, Alex's and your work on write lock stealing
is predicated on the proposition that writers advancing in front of
waiting readers is acceptable; that may or may not be true for every use
case.  [ It's not my intention to be critical here -- obviously I
appreciate your work because I used it in ldsem. :) ]

Perhaps a future direction for rwsem would be to provide a selectable
lock policy (fifo, mostly-fair, writer-first) on initialization so that
the different use cases can be easily accomodated?

Regards,
Peter Hurley

