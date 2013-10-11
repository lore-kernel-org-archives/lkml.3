Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758641Ab3JKQeX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 12:34:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10835 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757893Ab3JKQeW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 12:34:22 -0400
Date: Fri, 11 Oct 2013 11:50:06 -0400
From: Jeff Layton <jlayton@redhat.com>
To: "Frank Filz" <ffilzlnx@mindspring.com>
Cc: <linux-fsdevel@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <nfs-ganesha-devel@lists.sourceforge.net>,
        <samba-technical@lists.samba.org>
Subject: Re: [RFC PATCH 0/5] locks: implement "filp-private" (aka UNPOSIX)
 locks
Message-ID: <20131011115006.697d6bd7@tlielax.poochiereds.net>
In-Reply-To: <01f801cec695$7e5d17e0$7b1747a0$@mindspring.com>
References: <1381494322-2426-1-git-send-email-jlayton@redhat.com>
	<20131011093510.7ed9871a@tlielax.poochiereds.net>
	<01f801cec695$7e5d17e0$7b1747a0$@mindspring.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 Oct 2013 08:20:59 -0700
"Frank Filz" <ffilzlnx@mindspring.com> wrote:

> > > At LSF this year, there was a discussion about the "wishlist" for
> > > userland file servers. One of the things brought up was the goofy and
> > > problematic behavior of POSIX locks when a file is closed. Boaz
> > > started a thread on it here:
> > >
> > >     http://permalink.gmane.org/gmane.linux.file-systems/73364
> > >
> > > Userland fileservers often need to maintain more than one open file
> > > descriptor on a file. The POSIX spec says:
> > >
> > > "All locks associated with a file for a given process shall be removed
> > > when a file descriptor for that file is closed by that process or the
> > > process holding that file descriptor terminates."
> > >
> > > This is problematic since you can't close any file descriptor without
> > > dropping all your POSIX locks. Most userland file servers therefore
> > > end up opening the file with more access than is really necessary, and
> > > keeping fd's open for longer than is necessary to work around this.
> > >
> > > This patchset is a first stab at an approach to address this problem
> > > by adding two new l_type values -- F_RDLCKP and F_WRLCKP (the 'P' is
> > > short for "private" -- I'm open to changing that if you have a better
> > > mnemonic).
> > >
> > > For all intents and purposes these lock types act just like their
> > > "non-P" counterpart. The difference is that they are only implicitly
> > > released when the fd against which they were acquired is closed. As a
> > > side effect, these locks cannot be merged with "non-P" locks since
> > > they have different semantics on close.
> > >
> > > I've given this patchset some very basic smoke testing and it seems to
> > > do the right thing, but it is still pretty rough. If this looks
> > > reasonable I'll plan to do some documentation updates and will take a
> > > stab at trying to get these new lock types added to the POSIX spec (as
> > > HCH recommended).
> > >
> > > At this point, my main questions are:
> > >
> > > 1) does this look useful, particularly for fileserver implementors?
> > >
> > > 2) does this look OK API-wise? We could consider different "cmd" values
> > >    or even different syscalls, but I figured this makes it clearer that
> > >    "P" and "non-P" locks will still conflict with one another.
> 
> This is a good start.
> 
> I'd prefer a model where the private locks are maintained even if all file
> descriptors are closed and released on garbage collection when the process
> terminates. The model presented would require a server to potentially have
> at least two file descriptors open (the descriptor originally used for the
> locks, and a descriptor used for current access mode needed for some I/O
> operation). The server will also need to "remember" to do all locks using
> the first file descriptor.
> 

That's sort of a non-starter, I think at least in Linux. If you have no
open file descriptor then you have nothing to hang the lock off of.
That sort of interface sounds error-prone and "leaky" too. A long
running process could easily end up leaking POSIX locks over time if
you forget to explicitly unlock them.

> Another thing that would be very useful for servers is to be able to specify
> an arbitrary lock owner. Currently, Ganesha has to manage a union of all
> locks held on a file and carefully pick it apart when a client does an
> unlock. Allowing a process specified owner would allow Ganesha (or other
> servers) to have separate locks for each client lock owner.
> 

The trivial answer there would be to give each lockowner its own file
descriptor, right?

-- 
Jeff Layton <jlayton@redhat.com>
