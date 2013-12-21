Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755728Ab3LUS33 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Dec 2013 13:29:29 -0500
Received: from mx1.redhat.com ([209.132.183.28]:31707 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754805Ab3LUS32 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Dec 2013 13:29:28 -0500
Date: Sat, 21 Dec 2013 19:30:17 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Vaibhav Shinde <v.bhav.shinde@gmail.com>,
        Ajeet Yadav <ajeet.yadav.77@gmail.com>, Tejun Heo <tj@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] skip increamenting nr for TASK_UNINTERRUPTIBLE
Message-ID: <20131221183016.GB11516@redhat.com>
References: <CAB5gotvTv7Y=rMCvO0b5Jg-fx5rLUro+OfWMD0EoLpuHCsQ8TA@mail.gmail.com> <CA+55aFwBwrindu1AJU4S7XgYyxpuBUyq=wrwdDVn2EJUuChVDg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFwBwrindu1AJU4S7XgYyxpuBUyq=wrwdDVn2EJUuChVDg@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/21, Linus Torvalds wrote:
>
> Again, adding Oleg to the cc. And I don't think this is correct,

me too, but I can't reply right now, will do tomorrow,


> > In coredump case, where thread_1 faults while thread_2 is in
> > TASK_UNINTERRUPTIBLE state, it cannot handle the SIGKILL.

Yes, and we have to wait. We can not simply ignore its state.
Not to mention, every another_task->state check is racy.

> > Thus the process hangs on event.
> > The coredump routine freezes until the thread state is
> > uninterruptible.
> >
> > Solution: Continue for coredump, without waiting for uninterruptible
> >  thread, as it will get killed as soon as it returns from
> >  uninterruptible state.
> >  Therefore do not increament thread count for threads with
> >  TASK_UNINTERRUPTIBLE.
> >
> > Signed-off-by: Ajeet Yadav <ajeet.yadav.77@gmail.com>
> > Signed-off-by: Vaibhav Shinde <v.bhav.shinde@gmail.com>
> > ---
> >  fs/coredump.c |    3 ++-
> >  1 file changed, 2 insertions(+), 1 deletions(-)
> >
> > diff --git a/fs/coredump.c b/fs/coredump.c
> > index 447b02c..54b0664 100644
> > --- a/fs/coredump.c
> > +++ b/fs/coredump.c
> > @@ -281,7 +281,8 @@ static int zap_process(struct task_struct *start,
> > int exit_code)
> >   if (t != current && t->mm) {
> >   sigaddset(&t->pending.signal, SIGKILL);
> >   signal_wake_up(t, 1);
> > - nr++;
> > + if(!(t->state & TASK_UNINTERRUPTIBLE))
> > + nr++;
> >   }
> >   } while_each_thread(start, t);
> >
> > --
> > 1.7.9.5

