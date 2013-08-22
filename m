Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754071Ab3HVS2J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 14:28:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16681 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753419Ab3HVS2H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 14:28:07 -0400
Date: Thu, 22 Aug 2013 20:22:13 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Brad Spengler <spender@grsecurity.net>,
        Colin Walters <walters@redhat.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] pidns: fix vfork() after unshare(CLONE_NEWPID)
Message-ID: <20130822182213.GB22995@redhat.com>
References: <20130822170939.GA20296@redhat.com> <20130822170958.GA20314@redhat.com> <CALCETrUGd-+Z4tWF3uJa18eKgK+GcMaOp0Jm4dtQm7E=wz1NMg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrUGd-+Z4tWF3uJa18eKgK+GcMaOp0Jm4dtQm7E=wz1NMg@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/22, Andy Lutomirski wrote:
>
> On Thu, Aug 22, 2013 at 10:09 AM, Oleg Nesterov <oleg@redhat.com> wrote:
> > 8382fcac "pidns: Outlaw thread creation after unshare(CLONE_NEWPID)"
> > nacks CLONE_VM if the forking process unshared pid_ns, this obviously
> > breaks vfork:
> >
> >         int main(void)
> >         {
> >                 assert(unshare(CLONE_NEWUSER | CLONE_NEWPID) == 0);
> >                 assert(vfork() >= 0);
> >                 _exit(0);
> >                 return 0;
> >         }
> >
> > fails without this patch.
> >
> > Change this check to use CLONE_SIGHAND instead. This also forbids
> > CLONE_THREAD automatically, and this is what the comment implies.
> >
> > We could probably even drop CLONE_SIGHAND and use CLONE_THREAD,
> > but it would be safer to not do this. The current check denies
> > CLONE_SIGHAND implicitely and there is no reason to change this.
>
> Acked-by: Andy Lutomirski <luto@amacapital.net>

Thanks Andy for taking a look.

> > --- a/kernel/fork.c
> > +++ b/kernel/fork.c
> > @@ -1173,10 +1173,10 @@ static struct task_struct *copy_process(unsigned long clone_flags,
> >                 return ERR_PTR(-EINVAL);
> >
> >         /*
> > -        * If the new process will be in a different pid namespace
> > -        * don't allow the creation of threads.
> > +        * If the new process will be in a different pid namespace don't
> > +        * allow the creation of threads, or share the signal handlers.
>
> ...how about "If the new process will be in a different pid namespace,
> don't allow it to share a thread group or signal handlers with the
> parent"?

Agreed... But in this case I do not how 3/3 should explain CLONE_PARENT,
it adds "or share the parent" into this comment.

OK, I'll wait for other comments, then try to update this comment somehow
and send v2.

Perhaps "... with the forking task" would be fine?

Thanks.

Oleg.

