Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752233AbaANVvd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 16:51:33 -0500
Received: from fieldses.org ([174.143.236.118]:51742 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751462AbaANVva (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 16:51:30 -0500
Date: Tue, 14 Jan 2014 16:51:27 -0500
From: "J. Bruce Fields" <bfields@fieldses.org>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Frank Filz <ffilzlnx@mindspring.com>, Jeff Layton <jlayton@redhat.com>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        nfs-ganesha-devel@lists.sourceforge.net,
        samba-technical@lists.samba.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Richard Hipp <drh@hwaci.com>
Subject: Re: [PATCH v5 13/14] locks: skip deadlock detection on FL_FILE_PVT
 locks
Message-ID: <20140114215127.GE23999@fieldses.org>
References: <1389277187-18211-14-git-send-email-jlayton@redhat.com>
 <52CF05B5.5080700@amacapital.net>
 <20140109194930.1692fbbe@tlielax.poochiereds.net>
 <CALCETrXp-G2t9Lfd+tbyzWtXeBw+vLHWE4M7-297HQzyFDVU_g@mail.gmail.com>
 <20140114192713.GA22262@fieldses.org>
 <CALCETrWmOu-RVXNYmL--RMaiOiOMYVv5qd1+jfY0j8GZHh0rWg@mail.gmail.com>
 <20140114211009.GA23999@fieldses.org>
 <039101cf116e$56c2de80$04489b80$@mindspring.com>
 <CALCETrWRWnbiX+fpeXmn7ZKVvCpb+h99R01o8jchmx4=fgb0QA@mail.gmail.com>
 <CALCETrVRe2koQAwEiR7p10LqSi4durr9s6uo-1iv_aG-ZNGSkg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrVRe2koQAwEiR7p10LqSi4durr9s6uo-1iv_aG-ZNGSkg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 14, 2014 at 01:26:26PM -0800, Andy Lutomirski wrote:
> [grr, gmail -- I didn't actually intend to send that.]
> 
> On Tue, Jan 14, 2014 at 1:24 PM, Andy Lutomirski <luto@amacapital.net> wrote:
> > On Tue, Jan 14, 2014 at 1:19 PM, Frank Filz <ffilzlnx@mindspring.com> wrote:
> >>>       process 2 requests a write lock, gets -EDEADLK, unlocks and
> >>>       requests a new read lock.  That request succeeds because there
> >>>       is no conflicting lock.  (Note the lock manager had no
> >>>       opportunity to upgrade 1's lock here thanks to the conflict with
> >>>       3's lock.)
> >>
> >> As I understand write lock priority, process 2 requesting a new read lock
> >> would block, once there is a write lock waiter, no further read locks would
> >> be granted that would conflict with that waiting write lock.
> >
> > ...which reminds me -- if anyone implements writer priority, please
> > make it optional (either w/ a writer-priority-ignoring read lock or a
> > non-priority-granting write lock).  I have an application for which
> > writer priority would be really annoying.
> >
> > Even better: Have read-lock-and-wait-for-pending-writers be an explicit new operation.
> >
> > (Writer priority a
> 
> Writer priority can introduce new deadlocks.  Suppose that a reader
> (holding a read lock) starts a subprocess that takes a new read lock
> and waits for that subprocess.  Throw an unrelated process in that
> tries to take a write lock and you have an instant deadlock.

OK, so we definitely can't silently change existing lock behavior to
prioritize writes in this way.

A remaining interesting question is whether we'd like the new locks to
support either behavior or both.

I'd still be inclined to stick to the existing (unprioritized) behavior
just to minimize the scope of the project.

--b.
