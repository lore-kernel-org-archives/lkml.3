Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758049Ab3BKQtE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 11:49:04 -0500
Received: from mx1.redhat.com ([209.132.183.28]:48122 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757698Ab3BKQtC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 11:49:02 -0500
Date: Mon, 11 Feb 2013 17:47:27 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Vagin <avagin@parallels.com>
Cc: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>,
        David Howells <dhowells@redhat.com>,
        Pavel Emelyanov <xemul@parallels.com>, linux-api@vger.kernel.org,
        linux-kernel@vger.kernel.org, criu@openvz.org,
        Cyrill Gorcunov <gorcunov@openvz.org>, Andrey Wagin <avagin@gmail.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, Dave Jones <davej@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Denys Vlasenko <dvlasenk@redhat.com>
Subject: Re: [CRIU] [PATCH 3/3] signalfd: add ability to read siginfo-s
	without dequeuing signals (v2)
Message-ID: <20130211164727.GA27511@redhat.com>
References: <1358849741-9611-4-git-send-email-avagin@openvz.org> <1359486181-29088-1-git-send-email-avagin@openvz.org> <20130207173447.GA5888@redhat.com> <CANaxB-xmSiPfbUAh+rQSgVxBzTXmVQcC7U741WYKaasG3_yc5w@mail.gmail.com> <20130208191056.GA13674@redhat.com> <CAKgNAki0xt_wwixp7kdv04fKOCtCh-ObQjkFE9PiX6FapkO34A@mail.gmail.com> <20130209182239.GA9947@redhat.com> <CAKgNAkiYrP046mEv1_GJED5DckJrZSHvwu2u=P_BRxx-NuKALQ@mail.gmail.com> <20130210100424.GA15978@paralelels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130210100424.GA15978@paralelels.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/10, Andrew Vagin wrote:
>
> On Sat, Feb 09, 2013 at 11:53:04PM +0100, Michael Kerrisk (man-pages) wrote:
> >
> > This looks promising, but I am not sure I understand the user-space
> > API. Could you explain how it would look to (say) pull all per-thread
> > signals from user space?
> >
>
> 	siginfo_t *signals = malloc(...);
> 	...
>
> 	ret = ptrace(PTRACE_ATTACH, pid, NULL, NULL);

Yes. I assume this should not be a problem since c/r needs to ptrace
the task anyway?

> For shared (per-process) signals one line should be changed:
>  ret = ptrace(PTRACE_PEEKSIGNAL, pid, PTRACE_PEEK_SHARED + i, signals + i);

Yes. Except I'd say "PTRACE_PEEK_SHARED | i" to clarify that
PTRACE_PEEK_SHARED is "flag". Note that we can more flags, say,
PTRACE_PEEK_DEQUEUE which obviously means "dequeue signal" (but in
this case we should filter out SIGKILL/SIGSTOP).

And note that either way (I mean ptrace or signalfd) this can not
actually peek a signal which doesn't have the sigqueue (say,
SEND_SIG_FORCED). I guess this is not the problem, c/r can look
at /proc/pid/status#*Pnd aditionally.

OK, you seem to agree with this approach, I'll try to make the
working patch tomorrow. At least ptrace_peek_signal() needs another
is_compat argument for compat_ptrace_request().

Oleg.

> > > --- x/kernel/ptrace.c
> > > +++ x/kernel/ptrace.c
> > > @@ -618,6 +618,35 @@ static int ptrace_setsiginfo(struct task
> > >         return error;
> > >  }
> > >
> > > +static int ptrace_peek_signal(struct task_struct *child,
> > > +                               unsigned long addr, siginfo_t __user *uinfo)
> > > +{
> > > +       siginfo_t info;
> > > +       struct sigpending *pending;
> > > +       int ret = -ESOMETHING;
> > > +
> > > +       pending = &child->pending;
> > > +       if (addr & PTRACE_PEEK_SHARED) {
> > > +               addr &= ~PTRACE_PEEK_SHARED;
> > > +               pending = &child->signal->shared_pending;
> > > +       }
> > > +
> > > +       spin_lock_irq(&child->sighand->siglock);
> > > +       list_for_each_entry(q, &pending->list, list) {
> > > +               if (!addr--) {
> > > +                       copy_siginfo(info, &q->info);
> > > +                       ret = 0;
> > > +                       break;
> > > +               }
> > > +       }
> > > +       spin_lock_irq(&child->sighand->siglock);
> > > +
> > > +       if (!ret)
> > > +               ret = copy_siginfo_to_user(uinfo, info);
> > > +       if (!ret)
> > > +               ret = __put_user(info, si_code);
> > > +       return ret;
> > > +}
> > >
> > >  #ifdef PTRACE_SINGLESTEP
> > >  #define is_singlestep(request)         ((request) == PTRACE_SINGLESTEP)
> > > @@ -742,6 +771,10 @@ int ptrace_request(struct task_struct *c
> > >                 ret = put_user(child->ptrace_message, datalp);
> > >                 break;
> > >
> > > +       case PTRACE_PEEKSIGNAL:
> > > +               ret = ptrace_peek_signal(child, addr, datavp);
> > > +               break;
> > > +
> > >         case PTRACE_GETSIGINFO:
> > >                 ret = ptrace_getsiginfo(child, &siginfo);
> > >                 if (!ret)
> > >
> >
> >
> >
> > --
> > Michael Kerrisk
> > Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
> > Author of "The Linux Programming Interface"; http://man7.org/tlpi/
> > _______________________________________________
> > CRIU mailing list
> > CRIU@openvz.org
> > https://lists.openvz.org/mailman/listinfo/criu

