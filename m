Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751887AbaHCIaM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Aug 2014 04:30:12 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:34810 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751279AbaHCIaI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Aug 2014 04:30:08 -0400
Date: Sun, 3 Aug 2014 10:30:06 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Sergey Oboguev <oboguev.public@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC] sched: deferred set priority (dprio)
Message-ID: <20140803083006.GA1758@amd.pavel.ucw.cz>
References: <CA+80gGYVjprinWEJWbVq4VxjOLjQri8EvGAJ+sx+ihcOxdstCA@mail.gmail.com>
 <20140730130238.GE13965@amd.pavel.ucw.cz>
 <CA+80gGbOx9istV4UG7PF+qam81u+HzJyjznE5sjVV82jjWa=MQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+80gGbOx9istV4UG7PF+qam81u+HzJyjznE5sjVV82jjWa=MQ@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat 2014-08-02 17:47:52, Sergey Oboguev wrote:
> On Wed, Jul 30, 2014 at 6:02 AM, Pavel Machek <pavel@ucw.cz> wrote:
> > Hi!
> >
> >> One of the intended purposes of this facility (but its not sole purpose) is to
> >> render a lightweight mechanism for priority protection of lock-holding critical
> >> sections that would be an adequate match for lightweight locking primitives
> >> such as futex, with both featuring a fast path completing within the
> >> userspace.
> 
> > Do we get a manpage describing the interface...?
> 
> At this point it is just an RFC, and the only available write-up is an article
> (URL is in the original message).
> 
> There has been no word from the maintainers yet whether the proposal appears
> to be a "go" or "no-go" in general.

It appears to be "no-go" to me.

> Regular "set priority" cannot be wrapped around "deferred set priority".

Umm. Why not?

int getpriority(int which, int who);
int setpriority(int which, int who, int prio);

Description


 The scheduling priority of the process, process group, or user, as
 indicated by which and who is obtained with the getpriority() call
 and set with the setpriority() call.
The value which is one of PRIO_PROCESS, PRIO_PGRP, or PRIO_USER, and
 who is interpreted relative to which (a process identifier for
 PRIO_PROCESS, process group identifier for PRIO_PGRP, and a user ID
 for PRIO_USER). A zero value for who denotes (respectively) the
 calling process, the process group of the calling process, or the
 real user ID of the calling process. Prio is a value in the range -20
 to 19 (but see the Notes below). The default priority is 0; lower
 priorities cause more favorable scheduling.

In vsyscall area:

   if (which==PRIO_PROCESS && who==0) {
      perform your optimized priority set
   } else {
      perform syscall
}

Now, you have to make sure to keep reasonably close semantics, but
that would be good idea, anyway.
   
> Even more importantly, its use also relies on a thread caching the application's
> current knowledge of the thread priority in the userspace, and if the thread
> priority had been changed from the outside of the application (or even by
> another thread within the same application), this knowledge becomes invalid,
> and then the application is responsible for performing whatever recovery action
> is appropriate.

You mean "we rely on applications handling the situation they can't
and will not handle"?

Actually, it seems to be a security issue to me.

If root renices the application to high nice value, application should
not be able to work around it by the DPRIO interface.

IOW the priority should be always the lower of DPRIO and normal one,
at the very least.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
