Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752433Ab3JLLr0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Oct 2013 07:47:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64551 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751731Ab3JLLrY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Oct 2013 07:47:24 -0400
Date: Sat, 12 Oct 2013 07:47:12 -0400
From: Jeff Layton <jlayton@redhat.com>
To: "Stefan (metze) Metzmacher" <metze@samba.org>
Cc: linux-fsdevel@vger.kernel.org, nfs-ganesha-devel@lists.sourceforge.net,
        samba-technical@lists.samba.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 0/5] locks: implement "filp-private" (aka UNPOSIX)
 locks
Message-ID: <20131012074712.3d3b9148@tlielax.poochiereds.net>
In-Reply-To: <52591461.7070605@samba.org>
References: <1381494322-2426-1-git-send-email-jlayton@redhat.com>
	<52591461.7070605@samba.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 12 Oct 2013 11:20:33 +0200
"Stefan (metze) Metzmacher" <metze@samba.org> wrote:

> Hi Jeff,
> 
> > At LSF this year, there was a discussion about the "wishlist" for
> > userland file servers. One of the things brought up was the goofy and
> > problematic behavior of POSIX locks when a file is closed. Boaz started
> > a thread on it here:
> > 
> >     http://permalink.gmane.org/gmane.linux.file-systems/73364
> > 
> > Userland fileservers often need to maintain more than one open file
> > descriptor on a file. The POSIX spec says:
> > 
> > "All locks associated with a file for a given process shall be removed
> >  when a file descriptor for that file is closed by that process or the
> >  process holding that file descriptor terminates."
> > 
> > This is problematic since you can't close any file descriptor without
> > dropping all your POSIX locks. Most userland file servers therefore
> > end up opening the file with more access than is really necessary, and
> > keeping fd's open for longer than is necessary to work around this.
> > 
> > This patchset is a first stab at an approach to address this problem by
> > adding two new l_type values -- F_RDLCKP and F_WRLCKP (the 'P' is short
> > for "private" -- I'm open to changing that if you have a better
> > mnemonic).
> > 
> > For all intents and purposes these lock types act just like their
> > "non-P" counterpart. The difference is that they are only implicitly
> > released when the fd against which they were acquired is closed. As a
> > side effect, these locks cannot be merged with "non-P" locks since they
> > have different semantics on close.
> > 
> > I've given this patchset some very basic smoke testing and it seems to
> > do the right thing, but it is still pretty rough. If this looks
> > reasonable I'll plan to do some documentation updates and will take a
> > stab at trying to get these new lock types added to the POSIX spec (as
> > HCH recommended).
> > 
> > At this point, my main questions are:
> > 
> > 1) does this look useful, particularly for fileserver implementors?
> > 
> > 2) does this look OK API-wise? We could consider different "cmd" values
> >    or even different syscalls, but I figured this makes it clearer that
> >    "P" and "non-P" locks will still conflict with one another.
> > 
> > Jeff Layton (5):
> >   locks: consolidate checks for compatible filp->f_mode values in setlk
> >     handlers
> >   locks: add definitions for F_RDLCKP and F_WRLCKP
> >   locks: skip FL_FILP_PRIVATE locks on close unless we're closing the
> >     correct filp
> >   locks: handle merging of locks when FL_FILP_PRIVATE is set
> >   locks: show private lock types in /proc/locks
> 
> I haven't looked at the patches, but it would be very good to have locks
> per "open" and not per "fd".
> 

My intent is to make it "per-filp" (aka "struct file") in the same way
that flock() locks are today. Note that the patchset posted so far
doesn't quite have the right semantics yet.

Currently, I think that we want to give these locks flock-like
inheritance and close semantics, but to allow them to conflict with
"legacy" POSIX range locks.

> What happens in this example?
> 

As I said, I haven't sat down to change the implementation yet, but
I'll try to answer this in the way that I think we'll want to do it...

> fd1 = open("/somefile", ...);
> fd2 = open("/somefile", ...);
> fd3 = dup(fd1);
> 

At this point:

fd1 = filp1
fd2 = filp2
fd3 = filp1

...fd1 and fd3 both hold a reference to filp1.

> lock(fd1, range1)
> lock(fd2, range2)
> lock(fd3, range3)
> 

I'll assume that lock() means setting a F_SETLK with F_WRLCKP

> lock(fd2, range1) // => error already locked?
> 

Right. fd1 will hold the lock on range1 so -EAGAIN.

> lock(fd3, range1) // stacked lock?
> 

Not stacked per-se, but replaced. Since fd1 == fd3, this lock() call
won't conflict and the new lock will replace the old one. Since the
range is the same though, there will be no real difference in the
outcome.

> close(fd1)
> 

fput(filp1), but fd3 still has a reference so the lock won't be
released.

> lock(fd2, range1) // is range1 still locked by fd3 ?
> 

Yep, still locked.

> What about fd-passing, will the locks be transferred/shared with the
> other process?
> 

Yes, I think so. Locks will be passed to the other process in the same
way that flock() locks are today. AIUI, when you fork() you basically
dup() all the file descriptors of the parent so that's basically the
same as what happens above.

Again though, I'm still trying to settle on what the semantics should
be. None of this is etched in stone yet.

-- 
Jeff Layton <jlayton@redhat.com>
