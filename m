Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752329Ab3KFXQj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 18:16:39 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:55182 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751889Ab3KFXQe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 18:16:34 -0500
Date: Wed, 6 Nov 2013 17:17:08 -0600
From: Serge Hallyn <serge.hallyn@ubuntu.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Brad Spengler <spender@grsecurity.net>,
        Christian Seiler <christian@iwakd.de>,
        lkml <linux-kernel@vger.kernel.org>,
        Andy Whitcroft <apw@canonical.com>,
        Lxc development list <lxc-devel@lists.sourceforge.net>
Subject: Re: CLONE_PARENT after setns(CLONE_NEWPID)
Message-ID: <20131106231708.GB16974@ac100>
References: <20131106180232.GA8980@ac100>
 <20131106193311.GA18720@redhat.com>
 <87vc05jgak.fsf@tw-ebiederman.twitter.com>
 <CALCETrX0BeKa+GWnV0RffhMzpTPyXeF5BK=7PFdSCz1WQKH62w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrX0BeKa+GWnV0RffhMzpTPyXeF5BK=7PFdSCz1WQKH62w@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Andy Lutomirski (luto@amacapital.net):
> On Wed, Nov 6, 2013 at 2:50 PM, Eric W. Biederman <ebiederm@xmission.com> wrote:
> > Oleg Nesterov <oleg@redhat.com> writes:
> >
> >> Hi Serge,
> >>
> >> On 11/06, Serge Hallyn wrote:
> >>>
> >>> Hi Oleg,
> >>>
> >>> commit 40a0d32d1eaffe6aac7324ca92604b6b3977eb0e :
> >>> "fork: unify and tighten up CLONE_NEWUSER/CLONE_NEWPID checks"
> >>> breaks lxc-attach in 3.12.  That code forks a child which does
> >>> setns() and then does a clone(CLONE_PARENT).  That way the
> >>> grandchild can be in the right namespaces (which the child was
> >>> not) and be a child of the original task, which is the monitor.
> >
> > Serge that is a clever trick to get around the limitation that we can
> > not change the pid namespace of our current process.  Given the
> > challenging relaying of signals etc I can see why you would use this.
> >
> > At the same time it makes me a little sad to see new users of
> > CLONE_PARENT.  With CLONE_THREAD in existence the original reasons for
> > CLONE_PARENT are gone now.
> >
> > Having used bash as an init process I know it can handle unexpeted
> > children.  However using CLONE_PARENT in this way still seems a little
> > dodgy.  Or am I misunderstanding why you are using CLONE_PARENT?
> >
> > That trick sounds like it might be worth adding to nsenter in util-linux
> > just to simplify the code.
> >
> >> Thanks...
> >>
> >> Yes, this is what 40a0d32d1ea explicitly tries to disallow.
> >>
> >>> Is there a real danger in allowing CLONE_PARENT
> >>> when current->nsproxy->pidns_for_children is not our pidns,
> >>> or was this done out of an "over-abundance of caution"?
> >>
> >> I am not sure... This all was based on the long discussion, and
> >> it was decided that the CLONE_PARENT check should be consistent
> >> wrt CLONE_NEWPID and pidns_for_children != task_active_pid_ns().
> >>
> >>> Can we
> >>> safely revert that new extra check?
> >>
> >> Well, usually we do not break user-space, but I am not sure about
> >> this case...
> >>
> >> Eric, Andy, what do you think?
> >>
> >> And if we allow CLONE_PARENT when ->pidns_for_children was changed,
> >> should we also allow, say, CLONE_NEWPID && CLONE_PARENT ?
> >
> > The two fundamental things I know we can not allow are:
> > - A shared signal queue aka CLONE_THREAD.  Because we compute the pid
> >   and uid of the signal when we place it in the queue.
> >
> > - Changing the pid and by extention pid_namespace of an existing
> >   process.
> >
> > From a parents perspective there is nothing special about the pid
> > namespace, to deny CLONE_PARENT, because the parent simply won't know or
> > care.
> >
> > From the childs perspective all that is special really are shared signal
> > queues.
> >
> > User mode threading with CLONE_PARENT|CLONE_VM|CLONE_SIGHAND and tasks
> > in different pid namespaces is almost certainly going to break because
> > it is complicated.  But shared signal handlers can look at per thread
> > information to know which pid namespace a process is in, so I don't know
> > of any reason not to support CLONE_PARENT|CLONE_VM|CLONE_SIGHAND threads
> > at the kernel level.  It would be absolutely stupid to implement but
> > that is a different thing.
> >
> > So hmm.
> >
> > Because it can do no harm, and because it is a regression let's remove
> > the CLONE_PARENT check and send it stable.
> >
> > diff --git a/kernel/fork.c b/kernel/fork.c
> > index 086fe73..c447fbc 100644
> > --- a/kernel/fork.c
> > +++ b/kernel/fork.c
> > @@ -1174,7 +1174,7 @@ static struct task_struct *copy_process(unsigned long clone_flags,
> >          * do not allow it to share a thread group or signal handlers or
> >          * parent with the forking task.
> >          */
> > -       if (clone_flags & (CLONE_SIGHAND | CLONE_PARENT)) {
> > +       if (clone_flags & (CLONE_SIGHAND)) {
> >                 if ((clone_flags & (CLONE_NEWUSER | CLONE_NEWPID)) ||
> >                     (task_active_pid_ns(current) !=
> >                                 current->nsproxy->pid_ns_for_children))
> >
> 
> Acked-by: Andy Lutomirski <luto@amacapital.net>

Also (obviously)

Acked-by: Serge E. Hallyn <serge.hallyn@ubuntu.com>

