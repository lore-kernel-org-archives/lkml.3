Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754665Ab3LVPIc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Dec 2013 10:08:32 -0500
Received: from mx1.redhat.com ([209.132.183.28]:26350 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753424Ab3LVPIb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Dec 2013 10:08:31 -0500
Date: Sun, 22 Dec 2013 16:09:18 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Vaibhav Shinde <v.bhav.shinde@gmail.com>,
        Ajeet Yadav <ajeet.yadav.77@gmail.com>, Tejun Heo <tj@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] skip increamenting nr for TASK_UNINTERRUPTIBLE
Message-ID: <20131222150918.GB12544@redhat.com>
References: <CAB5gotvTv7Y=rMCvO0b5Jg-fx5rLUro+OfWMD0EoLpuHCsQ8TA@mail.gmail.com> <CA+55aFwBwrindu1AJU4S7XgYyxpuBUyq=wrwdDVn2EJUuChVDg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFwBwrindu1AJU4S7XgYyxpuBUyq=wrwdDVn2EJUuChVDg@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vaibhav,

again, I think that everything was explained by Linus, let me
add some details.

> > In coredump case, where thread_1 faults while thread_2 is in
> > TASK_UNINTERRUPTIBLE state, it cannot handle the SIGKILL.
> > Thus the process hangs on event.
> > The coredump routine freezes until the thread state is
> > uninterruptible.

Yes. But why we should even try to "fix" coredump in this case?

> > Solution: Continue for coredump, without waiting for uninterruptible
> >  thread,

This can't work, please see below.

> > as it will get killed as soon as it returns from
> >  uninterruptible state.

Not necessarily. It can play with ->mm before it notices the pending
SIGKILL. And, if nothing else, the coredumping paths do not even take
mmap_sem because we assume that the dumper is the only user.

But even if this doesn't happen,

> >  Therefore do not increament thread count for threads with
> >  TASK_UNINTERRUPTIBLE.

This is very wrong too. This means that we can start the coredump before
the _accounted_ thread exits (because a skipped thread can exit first and
decrement the counter). This also means that coredump_finish() can race
with the unaccounted threads.

> >   sigaddset(&t->pending.signal, SIGKILL);
> >   signal_wake_up(t, 1);
> > - nr++;
> > + if(!(t->state & TASK_UNINTERRUPTIBLE))
> > + nr++;

Again, we can't simply check t->state & TASK_UNINTERRUPTIBLE. This can
be false positive or it can sleep in TASK_UNINTERRUPTIBLE right after
the check. And even "& TASK_UNINTERRUPTIBLE" is wrong, please look at
TASK_KILLABLE.

Oleg.

