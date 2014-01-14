Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752182AbaANVZY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 16:25:24 -0500
Received: from fieldses.org ([174.143.236.118]:39968 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751713AbaANVZU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 16:25:20 -0500
Date: Tue, 14 Jan 2014 16:25:13 -0500
From: "J. Bruce Fields" <bfields@fieldses.org>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Jeff Layton <jlayton@redhat.com>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        nfs-ganesha-devel@lists.sourceforge.net,
        samba-technical@lists.samba.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        drh@hwaci.com
Subject: Re: [PATCH v5 13/14] locks: skip deadlock detection on FL_FILE_PVT
 locks
Message-ID: <20140114212513.GB23999@fieldses.org>
References: <1389277187-18211-1-git-send-email-jlayton@redhat.com>
 <1389277187-18211-14-git-send-email-jlayton@redhat.com>
 <52CF05B5.5080700@amacapital.net>
 <20140109194930.1692fbbe@tlielax.poochiereds.net>
 <CALCETrXp-G2t9Lfd+tbyzWtXeBw+vLHWE4M7-297HQzyFDVU_g@mail.gmail.com>
 <20140114192713.GA22262@fieldses.org>
 <CALCETrWmOu-RVXNYmL--RMaiOiOMYVv5qd1+jfY0j8GZHh0rWg@mail.gmail.com>
 <20140114211009.GA23999@fieldses.org>
 <CALCETrWhZ3OPznoNEQoXtBtd2BzFveYiJyHkDtOFLi9pvSk+vw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrWhZ3OPznoNEQoXtBtd2BzFveYiJyHkDtOFLi9pvSk+vw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 14, 2014 at 01:17:20PM -0800, Andy Lutomirski wrote:
> On Tue, Jan 14, 2014 at 1:10 PM, J. Bruce Fields <bfields@fieldses.org> wrote:
> > On Tue, Jan 14, 2014 at 12:29:17PM -0800, Andy Lutomirski wrote:
> >> [cc: drh, who I suspect is responsible for the most widespread
> >> userspace software that uses this stuff]
> >>
> >> On Tue, Jan 14, 2014 at 11:27 AM, J. Bruce Fields <bfields@fieldses.org> wrote:
> >> > On Thu, Jan 09, 2014 at 04:58:59PM -0800, Andy Lutomirski wrote:
> >> >> For this kind of deadlock detection, nothing global is needed -- I'm
> >> >> only talking about detecting deadlocks due to two tasks upgrading
> >> >> locks on the same file (with overlapping ranges) at the same time.
> >> >>
> >> >> This is actually useful for SQL-like things.  Imagine this scenario:
> >> >>
> >> >> Program 1:
> >> >>
> >> >> Open a file
> >> >> BEGIN;
> >> >> SELECT whatever;  -- acquires a read lock
> >> >>
> >> >> Program 2:
> >> >>
> >> >> Open the same file
> >> >> BEGIN;
> >> >> SELECT whatever;  -- acquires a read lock
> >> >>
> >> >> Program 1:
> >> >> UPDATE something;  -- upgrades to write
> >> >>
> >> >> Now program 1 is waiting for program 2 to release its lock.  But if
> >> >> program 2 tries to UPDATE, then it deadlocks.  A friendly MySQL
> >> >> implementation (which, sadly, does not include sqlite) will fail the
> >> >> abort the transaction instead.
> >> >
> >> > And then I suppose you'd need to get an exclusive lock when you retry,
> >> > to guarantee forward progress in the face of multiple processes retrying
> >> > at once.
> >>
> >> I don't think so -- as long as deadlock detection is 100% reliable and
> >> if you have writer priority,
> >
> > We don't have writer priority.  Depending on how it worked I'm not
> > convinced it would help.  E.g. consider the above but with 3 processes:
> >
> >         processes 1, 2, and 3 each get a whole-file read lock.
> >
> >         process 1 requests a write lock, blocks because it conflicts
> >         with read locks held by 2 and 3.
> >
> >         process 2 requests a write lock, gets -EDEADLK, unlocks and
> >         requests a new read lock.  That request succeeds because there
> >         is no conflicting lock.  (Note the lock manager had no
> >         opportunity to upgrade 1's lock here thanks to the conflict with
> >         3's lock.)
> 
> Writer priority here would detect that someone's waiting for write
> access and would cause new readers to block.

OK, got it, thanks.

I don't *think* traditional posix locks are allowed to block on a lock
that's not yet applied.  But I haven't thought it through.  If not, it
might be worth adding to a new lock type, though that could be a
slightly subtle distinction to document.

...
> FWIW, at least last time I checked, sqlite didn't implement deadlock
> detection (it uses timeouts instead).  That was one of my least
> favorite things about sqlite.
> 
> With this feature in fcntl, I think that sqlite could add deadlock
> detection and a true blocking mode without changing the file/locking
> format, at least if it still works the way I remember it working.
> 
> Anyway, I still don't think that this feature should be a prerequisite
> for the new lock types.

Well, if there's another posix lock brokenness here that we could easily
fix at the same time, it might make sense to.  At least it seems worth
understanding.

--b.
