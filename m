Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752073AbaGaQG2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 12:06:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22958 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750973AbaGaQGZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 12:06:25 -0400
Date: Thu, 31 Jul 2014 18:03:53 +0200
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
Message-ID: <20140731160353.GA14772@redhat.com>
References: <cover.1405992946.git.luto@amacapital.net> <3f649f5658a163645e3ce15156176c325283762e.1405992946.git.luto@amacapital.net> <20140728173723.GA20993@redhat.com> <20140728185803.GA24663@redhat.com> <20140728192209.GA26017@localhost.localdomain> <20140729175414.GA3289@redhat.com> <20140730163516.GC18158@localhost.localdomain> <20140730174630.GA30862@redhat.com> <20140731003034.GA32078@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140731003034.GA32078@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/31, Frederic Weisbecker wrote:
>
> On Wed, Jul 30, 2014 at 07:46:30PM +0200, Oleg Nesterov wrote:
> > On 07/30, Frederic Weisbecker wrote:
> > >
> > > On Tue, Jul 29, 2014 at 07:54:14PM +0200, Oleg Nesterov wrote:
> > >
> > > >
> > > > Looks like, we can kill context_tracking_task_switch() and simply change the
> > > > "__init" callers of context_tracking_cpu_set() to do set_thread_flag(TIF_NOHZ) ?
> > > > Then this flag will be propagated by copy_process().
> > >
> > > Right, that would be much better. Good catch! context tracking is enabled from
> > > tick_nohz_init(). This is the init 0 task so the flag should be propagated from there.
> >
> > actually init 1 task, but this doesn't matter.
>
> Are you sure? It does matter because that would invalidate everything I understood
> about init/main.c :)

Sorry for confusion ;)

> I was convinced that the very first kernel init task is PID 0 then
> it forks on rest_init() to launch the userspace init with PID 1. Then init/0 becomes the
> idle task of the boot CPU.

Yes sure. But context_tracking_cpu_set() is called by init task with PID 1, not
by "swapper". And we do not care about idle threads at all.

> > > I still think we need a for_each_process_thread() set as well though because some
> > > kernel threads may well have been created at this stage already.
> >
> > Yes... Or we can add set_thread_flag(TIF_NOHZ) into ____call_usermodehelper().
>
> Couldn't there be some other tasks than usermodehelper stuffs at this stage? Like workqueues
> or random kernel threads?

Sure, but we do not care. A kernel thread can never return to user space, it
must never call user_enter/exit().

> > I meant that in the scenario you described above the "global" TIF_NOHZ doesn't
> > really make a difference, afaics.
> >
> > Lets assume that context tracking is only enabled on CPU 1. To simplify,
> > assume that we have a single usermode task T which sleeps in kernel mode.
> >
> > So context_tracking[0].state == context_tracking[1].state == IN_KERNEL.
> >
> > T wakes up on CPU_0, returns to user space, calls user_enter(). This sets
> > context_tracking[0].state = IN_USER but otherwise does nothing else, this
> > CPU is not tracked and .active is false.
> >
> > Right after local_irq_restore() this task can migrate to CPU_1 and finish
> > its ret-to-usermode path. But since it had already passed user_enter() we
> > do not change context_tracking[1].state and do not play with rcu/vtime.
> > (unless this task hits SCHEDULE_USER in asm).
> >
> > The same for user_exit() of course.
>
> So indeed if context tracking is enabled on CPU 1 and not in CPU 0, we risk
> such situation where CPU 1 has wrong context tracking.

OK. To simplify, lets discuss user_enter() only. So, it is actually a nop on
CPU_0, and CPU_1 can miss it anyway.

> But global TIF_NOHZ should enforce context tracking everywhere.

And this is what I can't understand. Lets return to my initial question, why
we can't change __context_tracking_task_switch()

	void __context_tracking_task_switch(struct task_struct *prev,
					    struct task_struct *next)
	{
		if (context_tracking_cpu_is_enabled())
			set_tsk_thread_flag(next, TIF_NOHZ);
		else
			clear_tsk_thread_flag(next, TIF_NOHZ);
	}

? How can the global TIF_NOHZ help?

OK, OK, a task can return to usermode on CPU_0, notice TIF_NOHZ, take the
slow path, and do the "right" thing if it migrates to CPU_1 _before_ it
comes to user_enter(). But this case is very unlikely, certainly this can't
explain why do we penalize the untracked CPU's ?

> And also it's
> less context switch overhead.

Why???

I think I have a blind spot here. Help!



And of course I can't understand exception_enter/exit(). Not to mention that
(afaics) "prev_ctx == IN_USER" in exception_exit() can be false positive even
if we forget that the caller can migrate in between. Just because, once again,
a tracked CPU can miss user_exit().

So, why not

	static inline void exception_enter(void)
	{
		user_exit();
	}

	static inline void exception_exit(struct pt_regs *regs)
	{
		if (user_mode(regs))
			user_enter();
	}

?

Oleg.

