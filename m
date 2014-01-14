Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751954AbaANVSV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 16:18:21 -0500
Received: from mx1.redhat.com ([209.132.183.28]:40175 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751780AbaANVST (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 16:18:19 -0500
Date: Tue, 14 Jan 2014 16:18:04 -0500
From: Jeff Layton <jlayton@redhat.com>
To: "J. Bruce Fields" <bfields@fieldses.org>
Cc: Andy Lutomirski <luto@amacapital.net>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        nfs-ganesha-devel@lists.sourceforge.net,
        samba-technical@lists.samba.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        drh@hwaci.com, Florian Weimer <fweimer@redhat.com>
Subject: Re: [PATCH v5 13/14] locks: skip deadlock detection on FL_FILE_PVT
 locks
Message-ID: <20140114161804.3574ff3d@corrin.poochiereds.net>
In-Reply-To: <20140114211009.GA23999@fieldses.org>
References: <1389277187-18211-1-git-send-email-jlayton@redhat.com>
	<1389277187-18211-14-git-send-email-jlayton@redhat.com>
	<52CF05B5.5080700@amacapital.net>
	<20140109194930.1692fbbe@tlielax.poochiereds.net>
	<CALCETrXp-G2t9Lfd+tbyzWtXeBw+vLHWE4M7-297HQzyFDVU_g@mail.gmail.com>
	<20140114192713.GA22262@fieldses.org>
	<CALCETrWmOu-RVXNYmL--RMaiOiOMYVv5qd1+jfY0j8GZHh0rWg@mail.gmail.com>
	<20140114211009.GA23999@fieldses.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 14 Jan 2014 16:10:09 -0500
"J. Bruce Fields" <bfields@fieldses.org> wrote:

> On Tue, Jan 14, 2014 at 12:29:17PM -0800, Andy Lutomirski wrote:
> > [cc: drh, who I suspect is responsible for the most widespread
> > userspace software that uses this stuff]
> > 
> > On Tue, Jan 14, 2014 at 11:27 AM, J. Bruce Fields <bfields@fieldses.org> wrote:
> > > On Thu, Jan 09, 2014 at 04:58:59PM -0800, Andy Lutomirski wrote:
> > >> On Thu, Jan 9, 2014 at 4:49 PM, Jeff Layton <jlayton@redhat.com> wrote:
> > >> > On Thu, 09 Jan 2014 12:25:25 -0800
> > >> > Andy Lutomirski <luto@amacapital.net> wrote:
> > >> >> When I think of deadlocks caused by r/w locks (which these are), I think
> > >> >> of two kinds.  First is what the current code tries to detect: two
> > >> >> processes that are each waiting for each other.  I don't know whether
> > >> >> POSIX enshrines the idea of detecting that, but I wouldn't be surprised,
> > >> >> considering how awful the old POSIX locks are.
> > > ...
> > >> >> The sensible kind of detectable deadlock involves just one lock, and it
> > >> >> happens when two processes both hold read locks and try to upgrade to
> > >> >> write locks.  This should be efficiently detectable and makes upgrading
> > >> >> locks safe(r).
> > >
> > > This also involves two processes waiting on each other, and the current
> > > code should detect either case equally well.
> > >
> > > ...
> > >> For this kind of deadlock detection, nothing global is needed -- I'm
> > >> only talking about detecting deadlocks due to two tasks upgrading
> > >> locks on the same file (with overlapping ranges) at the same time.
> > >>
> > >> This is actually useful for SQL-like things.  Imagine this scenario:
> > >>
> > >> Program 1:
> > >>
> > >> Open a file
> > >> BEGIN;
> > >> SELECT whatever;  -- acquires a read lock
> > >>
> > >> Program 2:
> > >>
> > >> Open the same file
> > >> BEGIN;
> > >> SELECT whatever;  -- acquires a read lock
> > >>
> > >> Program 1:
> > >> UPDATE something;  -- upgrades to write
> > >>
> > >> Now program 1 is waiting for program 2 to release its lock.  But if
> > >> program 2 tries to UPDATE, then it deadlocks.  A friendly MySQL
> > >> implementation (which, sadly, does not include sqlite) will fail the
> > >> abort the transaction instead.
> > >
> > > And then I suppose you'd need to get an exclusive lock when you retry,
> > > to guarantee forward progress in the face of multiple processes retrying
> > > at once.
> > 
> > I don't think so -- as long as deadlock detection is 100% reliable and
> > if you have writer priority,
> 
> We don't have writer priority.  Depending on how it worked I'm not
> convinced it would help.  E.g. consider the above but with 3 processes:
> 
> 	processes 1, 2, and 3 each get a whole-file read lock.
> 
> 	process 1 requests a write lock, blocks because it conflicts
> 	with read locks held by 2 and 3.
> 
> 	process 2 requests a write lock, gets -EDEADLK, unlocks and
> 	requests a new read lock.  That request succeeds because there
> 	is no conflicting lock.  (Note the lock manager had no
> 	opportunity to upgrade 1's lock here thanks to the conflict with
> 	3's lock.)
> 
> 	process 3 requests a write lock, gets -EDEADLOCK, unlocks and
> 	requests a new read lock.
> 
> 	Etc.
> 
> > then all that readers need to do is to
> > drop and re-acquire the read lock.  (This property is critical to
> > avoid livelocks in SQL.  I rely on it here: a deadlocked UPDATE just
> > retries the entire transaction without any special exclusive locks.)
> > 
> > >
> > > I don't know, is this so useful?
> > >
> > >> It would be nice if the kernel
> > >> supported this.
> > >>
> > >> Note that unlocking and then re-locking for write is incorrect -- it
> > >> would allow program 2 to write inconsistent data.
> > >>
> > >> I think that implementing this could be as simple as having some way
> > >> to check if a struct file_lock is currently trying to upgrade from
> > >> read to write and, if you try to upgrade and end up waiting for such a
> > >> lock, aborting.
> > >
> > > You have to be clear what you mean by "such a lock".  What you really
> > > want to know is whether you'd be waiting on a lock that might be waiting
> > > on a lock you hold.
> > 
> > By "such a lock" I mean a read lock on the same file that's trying to
> > upgrade to write.  I think that's the main (only?) interesting case.
> > Checking for this has the nice property that you don't need to iterate
> > and you don't care whom the holder of that lock is waiting for -- if
> > it's upgrading and you overlap with it, you are certainly in the
> > deadlock case.
> 
> OK, I think.
> 
> > > To a first approximation, the current works with a graph with tasks as
> > > nodes and an arrow from node X to node Y if X is waiting on a lock held
> > > by node Y.  And it follows arrows in that graph looking for cycles.
> > >
> > > And sure I guess it would be a bit nicer if you only bothered checking
> > > for cycles that touch this one file.
> > >
> > > But I'd really rather avoid the complication of deadlock detection
> > > unless somebody can make a really strong case that they need it.
> > 
> > TBH, I suspect that the person you really want to ask is drh, who
> > writes/maintains sqlite (cc'd).  sqlite has fancy locks built on top
> > of fcntl locks.
> 
> A quick check of the sqlite source shows some complaints about posix
> locks in src/os.c.
> 
> Looks like all he's asking for his for the lock owner to be the file
> descriptor not the pid, and for locks not to be thrown away on first
> close.  Those are the two things jlayton addresses.
> 
> So yes I think it would be interesting to know whether some of the extra
> layer of internal sqlite locking could have been chucked if it could
> have been based on jlayton's locks.
> 

FWIW, Florian (cc'ed here) emailed me recently asking about the
status of these patches. He specifically mentioned hacking up the sqlite
code to use these locks instead of the existing posix lock layer.

At the time, the patches were still pretty rough but I think they're
getting closer to their final form now.

-- 
Jeff Layton <jlayton@redhat.com>
