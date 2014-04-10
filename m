Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935635AbaDJR5F (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 13:57:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30217 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932804AbaDJR5D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 13:57:03 -0400
Date: Thu, 10 Apr 2014 19:57:05 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Hendrik Brueckner <brueckner@linux.vnet.ibm.com>
Subject: Re: [PATCH RESEND 2/2] tracing: syscall_regfunc() should not skip
	kernel threads
Message-ID: <20140410175705.GB32332@redhat.com>
References: <1397059882-23063-3-git-send-email-fweisbec@gmail.com> <360091921.1294.1397060915052.JavaMail.zimbra@efficios.com> <20140409124249.4081e665@gandalf.local.home> <20140409170505.GA27638@redhat.com> <20140409170616.GC27638@redhat.com> <20140410092842.1f9a8760@gandalf.local.home> <20140410133855.GC12228@redhat.com> <20140410102816.24337ffe@gandalf.local.home> <20140410144655.GA25316@redhat.com> <20140410110848.64c3f25e@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140410110848.64c3f25e@gandalf.local.home>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/10, Steven Rostedt wrote:
>
> On Thu, 10 Apr 2014 16:46:55 +0200
> Oleg Nesterov <oleg@redhat.com> wrote:
>
> > > void tracepoint_check_syscalls(void)
> > > {
> > > 	if (!sys_tracepoint_refcount)
> > > 		return;
> > >
> > > 	read_lock(&tasklist_lock);
> > > 	/* Make sure it wasn't cleared since taking the lock */
> > > 	if (sys_tracepoint_refcount)
> > > 		set_tsk_thread_flag(current, TIF_SYSCALL_TRACEPOINT);
> > > 	read_unlock(&tasklist_lock);
> > > }
> >
> > And how this can help to avoid the race? We need write_lock_irq().
>
> But you chopped off the last part. Where I replaced tasklist_lock with
> a tracepoint specific lock that would synchronize
> sys_tracepoint_refcount with the setting of the flags.

Yes sure, if we add another lock everything is fine.

> > Perhaps I missed something... and I simply do not understand why do you
> > want to do this.
>
> Because I'm being an ass ;-)

Nothing new, I always knew this ;)

> The real reason I'm doing this debate is more to find out exactly what
> the problems are. A learning exercise if you will. I just don't want to
> add a regression, as Hendrik (which I just Cc'd) added the commit for a
> reason. Perhaps you are correct that we should just go back to the way
> things were.

Sure, this should be verified. Besides, the changelog is very old. It says
"kernel_execve() itself does "int 80" on X86_32.", this is no longer true.

> Hendrik, we are debating about removing
> cc3b13c11c567c69a6356be98d0c03ff11541d5c as it stops
> call_usermodehelper tasks from tracing their syscalls.
>
> If Hendrik has no problems with this, neither do I.

OK.

cc3b13c11c567 mentions ret_from_fork, today copy_thread(PF_KTHREAD) uses
ret_from_kernel_thread on 32bit, and still ret_from_fork on 64 bit but
in the last case it checks PF_KTHREAD... I am wondering why they both
(ret_from_kernel_thread and "1: " label in ret_from_fork) can't simply
call do_exit() at the end?

And, since they do not, every kernel_thread's function (fn argument of
kernel_thread) must call do_exit itself?

Looks a bit strange, I guess I missed something obvious.

Oleg.

