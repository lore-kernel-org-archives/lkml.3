Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756607Ab3JKSm6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 14:42:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28224 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752558Ab3JKSmy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 14:42:54 -0400
Date: Fri, 11 Oct 2013 14:42:40 -0400
From: Jeff Layton <jlayton@redhat.com>
To: "Frank Filz" <ffilzlnx@mindspring.com>
Cc: <linux-fsdevel@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <nfs-ganesha-devel@lists.sourceforge.net>,
        <samba-technical@lists.samba.org>
Subject: Re: [RFC PATCH 0/5] locks: implement "filp-private" (aka UNPOSIX)
 locks
Message-ID: <20131011144240.007f96c1@tlielax.poochiereds.net>
In-Reply-To: <020001cec6a4$601b6f70$20524e50$@mindspring.com>
References: <1381494322-2426-1-git-send-email-jlayton@redhat.com>
	<20131011093510.7ed9871a@tlielax.poochiereds.net>
	<01f801cec695$7e5d17e0$7b1747a0$@mindspring.com>
	<20131011115006.697d6bd7@tlielax.poochiereds.net>
	<020001cec6a4$601b6f70$20524e50$@mindspring.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 Oct 2013 10:07:30 -0700
"Frank Filz" <ffilzlnx@mindspring.com> wrote:

> > > > > At LSF this year, there was a discussion about the "wishlist" for
> > > > > userland file servers. One of the things brought up was the goofy
> > > > > and problematic behavior of POSIX locks when a file is closed.
> > > > > Boaz started a thread on it here:
> > > > >
> > > > >     http://permalink.gmane.org/gmane.linux.file-systems/73364
> > > > >
> > > > > Userland fileservers often need to maintain more than one open
> > > > > file descriptor on a file. The POSIX spec says:
> > > > >
> > > > > "All locks associated with a file for a given process shall be
> > > > > removed when a file descriptor for that file is closed by that
> > > > > process or the process holding that file descriptor terminates."
> > > > >
> > > > > This is problematic since you can't close any file descriptor
> > > > > without dropping all your POSIX locks. Most userland file servers
> > > > > therefore end up opening the file with more access than is really
> > > > > necessary, and keeping fd's open for longer than is necessary to
> work
> > around this.
> > > > >
> > > > > This patchset is a first stab at an approach to address this
> > > > > problem by adding two new l_type values -- F_RDLCKP and F_WRLCKP
> > > > > (the 'P' is short for "private" -- I'm open to changing that if
> > > > > you have a better mnemonic).
> > > > >
> > > > > For all intents and purposes these lock types act just like their
> > > > > "non-P" counterpart. The difference is that they are only
> > > > > implicitly released when the fd against which they were acquired
> > > > > is closed. As a side effect, these locks cannot be merged with
> > > > > "non-P" locks since they have different semantics on close.
> > > > >
> > > > > I've given this patchset some very basic smoke testing and it
> > > > > seems to do the right thing, but it is still pretty rough. If this
> > > > > looks reasonable I'll plan to do some documentation updates and
> > > > > will take a stab at trying to get these new lock types added to
> > > > > the POSIX spec (as HCH recommended).
> > > > >
> > > > > At this point, my main questions are:
> > > > >
> > > > > 1) does this look useful, particularly for fileserver implementors?
> > > > >
> > > > > 2) does this look OK API-wise? We could consider different "cmd"
> > values
> > > > >    or even different syscalls, but I figured this makes it clearer
> that
> > > > >    "P" and "non-P" locks will still conflict with one another.
> > >
> > > This is a good start.
> > >
> > > I'd prefer a model where the private locks are maintained even if all
> > > file descriptors are closed and released on garbage collection when
> > > the process terminates. The model presented would require a server to
> > > potentially have at least two file descriptors open (the descriptor
> > > originally used for the locks, and a descriptor used for current
> > > access mode needed for some I/O operation). The server will also need
> > > to "remember" to do all locks using the first file descriptor.
> > >
> > 
> > That's sort of a non-starter, I think at least in Linux. If you have no
> open file
> > descriptor then you have nothing to hang the lock off of.
> > That sort of interface sounds error-prone and "leaky" too. A long running
> > process could easily end up leaking POSIX locks over time if you forget to
> > explicitly unlock them.
> 
> There is a point there, however see below for discussion of file descriptor
> resources.
> 
> > > Another thing that would be very useful for servers is to be able to
> > > specify an arbitrary lock owner. Currently, Ganesha has to manage a
> > > union of all locks held on a file and carefully pick it apart when a
> > > client does an unlock. Allowing a process specified owner would allow
> > > Ganesha (or other
> > > servers) to have separate locks for each client lock owner.
> > >
> > 
> > The trivial answer there would be to give each lockowner its own file
> > descriptor, right?
> 
> Hmm, that would be a solution (of course that would imply that private locks
> held by the same process but by different file descriptors would conflict
> appropriately).
> 

Good point. In the implementation I have so far, POSIX locks held by
the same process don't conflict, just like normal POSIX locks do. For
these sorts of locks, I think it would make sense to have more
flock()-like behavior there, such that locks held by the same process
on different file descriptors will still conflict. I'll plan to make
that change on the next pass.

> There is a resource issue though of how many file descriptors we have open.
> Is there any practical limit on the number of file descriptors a process has
> open? Can the kernel support 1000s of descriptors? How much resource does a
> file descriptor take? Looks like a struct file isn't tiny, not quite sure
> just how big it is.
> 
> There is also some consideration of how this interacts with share
> reservations (where is that proposal going BTW?). But I don't think this
> really introduces anything new. We still have to guess the best access mode
> to open a file descriptor that will be used for locks no matter how we
> implement this.
> 

At least in the currently proposed patchset by Pavel, share
reservations are orthogonal to these since they're based on LOCK_MAND
flock() locks.

> So I guess my big concern is the resource impact of lots of file
> descriptors.
> 

That's understandable. I'm not clear on how big an overhead there is on
maintaining an open file descriptor. OTOH, people use flock() and such
and it has similar requirements.

I guess my main concern is that while I'm interested in adding
interfaces that make it _easier_ to implement fileservers, I'm not
terribly interested in adding interfaces that are _specific_ to
implementing them.

Whatever interface we add needs to be generic enough to be useful to
other applications as well. The changes you're suggesting sound rather
specific to a particular use-case.

-- 
Jeff Layton <jlayton@redhat.com>
