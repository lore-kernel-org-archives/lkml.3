Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751640AbaDATx2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 15:53:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9441 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751310AbaDATx0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 15:53:26 -0400
Date: Tue, 1 Apr 2014 20:52:41 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Matthew Dempsky <mdempsky@chromium.org>
Cc: Kees Cook <keescook@chromium.org>, Julien Tinnes <jln@chromium.org>,
        Roland McGrath <mcgrathr@chromium.org>,
        Jan Kratochvil <jan.kratochvil@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] Fix ptrace events across pid namespaces
Message-ID: <20140401185241.GA29884@redhat.com>
References: <1396288478-1314-1-git-send-email-mdempsky@chromium.org> <20140331181651.GA27686@redhat.com> <CAF52+S5i7oqJnJ1NN0bk5Vg=CiYrussw0AunteE72kMMcWkeJA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAF52+S5i7oqJnJ1NN0bk5Vg=CiYrussw0AunteE72kMMcWkeJA@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry for slow response,

On 03/31, Matthew Dempsky wrote:
>
> On Mon, Mar 31, 2014 at 11:16 AM, Oleg Nesterov <oleg@redhat.com> wrote:
>
> >> --- a/kernel/fork.c
> >> +++ b/kernel/fork.c
> >> @@ -1621,12 +1621,18 @@ long do_fork(unsigned long clone_flags,
> >>               wake_up_new_task(p);
> >>
> >>               /* forking complete and child started to run, tell ptracer */
> >> -             if (unlikely(trace))
> >> -                     ptrace_event(trace, nr);
> >> +             if (unlikely(trace)) {
> >> +                     pid_t pid = task_pid_nr_ns(p,
> >> +                             task_active_pid_ns(current->parent));
> >> +                     ptrace_event(trace, pid);
> >
> > This is unsafe, both "p" or ->parent can go away. In fact "p" can be
> > already dead/freed/etc.
>
> True.  I suspect the problem of "p" going away could be solved by
> calculating the pid prior to calling wake_up_new_task(p)?

Yes. Or we can do get_pid(p) (unconditional get_task_struct() can't
help, task_pid_nr_ns(tsk) returns zero if tsk has exited), although
personaly I'd prefer to avoid this.

But see below.

> But how can I guard against current->parent disappearing?  Do I need
> to grab a read lock on the tasklist and rcu?

rcu_read_lock() should be enough.

The main question is how we can ensure that we use the correct namespace,
iow, how we can ensure that current->parent won't change after this.

Suppose that debugger detaches right after we calculated pid_t we were
going to report.

Now suppose that another task from the different namespace does
ptrace(PTRACE_SEIZE, PTRACE_O_TRACEFORK). Or PTRACE_O_TRACEVFORKDONE.

In this case ptrace_event() will still report the wrong pid. I simply do
not see how we can prevent this race without the really ugly complications.

But perhaps we do not really care? The race is very unlikely, and nothing
really bad can happen. So perhaps your simple patch makes sense anyway,
just the problem should be documented. Currently "nr" is always wrong if
the tracer is from another ns, this change will obviously makes the things
better in any case.

> >> --- a/kernel/ptrace.c
> >> +++ b/kernel/ptrace.c
> >> @@ -80,6 +80,7 @@ void __ptrace_unlink(struct task_struct *child)
> >>       BUG_ON(!child->ptrace);
> >>
> >>       child->ptrace = 0;
> >> +     child->ptrace_message = 0;
> >
> > It is too late for me to try to understand the reason for this change ;)
>
> Basically, if process A is being ptraced by process B and we record an
> event for it, I don't want process B to detach and then process C to
> attach and be able to still view the event.

Aha, so I got it right. But see above, this won't help anyway, C can
attach before ptrace_event() sets ->ptrace_message.

Perhaps this change makes sense anyway. I think it needs a separate patch
but I won't insist.

> > Probably this is related to detach/attach, but then it would be better
> > to do this in PTRACE_ATTACH. Because ->ptrace_message can be non-zero
> > if, say, a traced task forks.
>
> I think zeroing out ptrace_message at attach time works too, and I can
> do it that way if you prefer.

I do not really mind. But once again, unless we clear it in PTRACE_ATTACH,
PTRACE_GETEVENTMSG still can return non-zero right after PTRACE_ATTACH.
Of course we can change copy_process() to clear child->ptrace_message,
but I don't think this would be better.

Matthew, I just noticed we discuss this off-list, I added lkml.

Oleg.

