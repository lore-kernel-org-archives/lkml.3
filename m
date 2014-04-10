Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935545AbaDJOqx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 10:46:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39427 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933057AbaDJOqv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 10:46:51 -0400
Date: Thu, 10 Apr 2014 16:46:55 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH RESEND 2/2] tracing: syscall_regfunc() should not skip
	kernel threads
Message-ID: <20140410144655.GA25316@redhat.com>
References: <1397059882-23063-1-git-send-email-fweisbec@gmail.com> <1397059882-23063-3-git-send-email-fweisbec@gmail.com> <360091921.1294.1397060915052.JavaMail.zimbra@efficios.com> <20140409124249.4081e665@gandalf.local.home> <20140409170505.GA27638@redhat.com> <20140409170616.GC27638@redhat.com> <20140410092842.1f9a8760@gandalf.local.home> <20140410133855.GC12228@redhat.com> <20140410102816.24337ffe@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140410102816.24337ffe@gandalf.local.home>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/10, Steven Rostedt wrote:
>
> On Thu, 10 Apr 2014 15:38:55 +0200
> Oleg Nesterov <oleg@redhat.com> wrote:
>
> > > > However, this means that a user-space task spawned by
> > > > call_usermodehelper() won't report the system calls if
> > > > kernel_execve() is called when sys_tracepoint_refcount != 0.
> > >
> > > What about doing the set there? That is, we could add a check in the
> > > call_userspacehelper() just before it does the do_execve, that if
> > > sys_tracepoint_refcount is set, we set the TIF flag.
> >
> > But for what?
>
> Isn't call_usermodehelper() the reason you added this?

Sure. I meant, why complicate ____call_usermodehelper() and keep the
unnecessary complication (PF_KTHREAD check( in syscall_*regfunc() ?

> > And if we do this, ____call_usermodehelper() needs write_lock_irq(tasklist)
> > to serialize with syscall_*regfunc().
>
> You mean for the slight race between checking if its set and when the
> tracepoint is actually activated?

Or deactivated.

> I don't think we really care about that race.

OK, I won't argue. I agree, the problem is minor, but in this case imho
it is better to do nothing than add the racy fix.

> I mean, the tracepoint is
> activated usually by humans, and if they enabled it just as a usermode
> helper is activated, and those are really fast to run, do we even care
> if it is missed?

A user space task spawned by call_usermodehelper() can do everything, it
can run forever.

> Now, if tracing is on and we need to set the flag, that should take the
> task list lock to make sure that we don't miss clearing it. Missing the
> set isn't a big deal, but missing the clearing of the flag is.
>
> void tracepoint_check_syscalls(void)
> {
> 	if (!sys_tracepoint_refcount)
> 		return;
>
> 	read_lock(&tasklist_lock);
> 	/* Make sure it wasn't cleared since taking the lock */
> 	if (sys_tracepoint_refcount)
> 		set_tsk_thread_flag(current, TIF_SYSCALL_TRACEPOINT);
> 	read_unlock(&tasklist_lock);
> }

And how this can help to avoid the race? We need write_lock_irq().

Perhaps I missed something... and I simply do not understand why do you
want to do this.

Oleg.

