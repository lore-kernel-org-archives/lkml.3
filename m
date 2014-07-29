Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752199AbaG2R5T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 13:57:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54513 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751066AbaG2R5S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 13:57:18 -0400
Date: Tue, 29 Jul 2014 19:54:14 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Andy Lutomirski <luto@amacapital.net>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, Kees Cook <keescook@chromium.org>,
        Will Drewry <wad@chromium.org>, x86@kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-mips@linux-mips.org,
        linux-arch@vger.kernel.org, linux-security-module@vger.kernel.org,
        Alexei Starovoitov <ast@plumgrid.com>, hpa@zytor.com
Subject: Re: TIF_NOHZ can escape nonhz mask? (Was: [PATCH v3 6/8] x86:
	Split syscall_trace_enter into two phases)
Message-ID: <20140729175414.GA3289@redhat.com>
References: <cover.1405992946.git.luto@amacapital.net> <3f649f5658a163645e3ce15156176c325283762e.1405992946.git.luto@amacapital.net> <20140728173723.GA20993@redhat.com> <20140728185803.GA24663@redhat.com> <20140728192209.GA26017@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140728192209.GA26017@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/28, Frederic Weisbecker wrote:
>
> On Mon, Jul 28, 2014 at 08:58:03PM +0200, Oleg Nesterov wrote:
> >
> > Frederic, don't we need the patch below? In fact clear_() can be moved
> > under "if ()" too. and probably copy_process() should clear this flag...
> >
> > Or. __context_tracking_task_switch() can simply do
> >
> > 	 if (context_tracking_cpu_is_enabled())
> > 	 	set_tsk_thread_flag(next, TIF_NOHZ);
> > 	 else
> > 	 	clear_tsk_thread_flag(next, TIF_NOHZ);
> >
> > and then we can forget about copy_process(). Or I am totally confused?
> >
> >
> > I am also wondering if we can extend user_return_notifier to handle
> > enter/exit and kill TIF_NOHZ.
> >
> > Oleg.
> >
> > --- x/kernel/context_tracking.c
> > +++ x/kernel/context_tracking.c
> > @@ -202,7 +202,8 @@ void __context_tracking_task_switch(stru
> >  				    struct task_struct *next)
> >  {
> >  	clear_tsk_thread_flag(prev, TIF_NOHZ);
> > -	set_tsk_thread_flag(next, TIF_NOHZ);
> > +	if (context_tracking_cpu_is_enabled())
> > +		set_tsk_thread_flag(next, TIF_NOHZ);
> >  }
> >
> >  #ifdef CONFIG_CONTEXT_TRACKING_FORCE
>
> Unfortunately, as long as tasks can migrate in and out a context tracked CPU, we
> need to track all CPUs.

Thanks Frederic for your explanations. Yes, I was confused. But cough, now I am
even more confused.

I didn't even try to read this code, perhaps I'll try later, but let me ask
another question while you are here ;)

The comment above __context_tracking_task_switch() says:

	 * The context tracking uses the syscall slow path to implement its user-kernel
	 * boundaries probes on syscalls. This way it doesn't impact the syscall fast
	 * path on CPUs that don't do context tracking.
	        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

How? Every running task should have TIF_NOHZ set if context_tracking_is_enabled() ?

	 * But we need to clear the flag on the previous task because it may later
	 * migrate to some CPU that doesn't do the context tracking. As such the TIF
	 * flag may not be desired there.

For what? How this can help? This flag will be set again when we switch to this
task again?

Looks like, we can kill context_tracking_task_switch() and simply change the
"__init" callers of context_tracking_cpu_set() to do set_thread_flag(TIF_NOHZ) ?
Then this flag will be propagated by copy_process().

Or I am totally confused? (quite possible).

> So here is a scenario where this is a problem: a task runs on CPU 0, passes the context
> tracking call before returning from a syscall to userspace, and gets an interrupt. The
> interrupt preempts the task and it moves to CPU 1. So it returns from preempt_schedule_irq()
> after which it is going to resume to userspace.
>
> In this scenario, if context tracking is only enabled on CPU 1, we have no way to know that
> the task is resuming to userspace, because we passed through the context tracking probe
> already and it was ignored on CPU 0.

Thanks. But I still can't understand... So if we only track CPU 1, then in this
case context_tracking.state == IN_USER on CPU 0, but it can be IN_USER or IN_KERNEL
on CPU 1.

Oleg.

