Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752328AbaGaSPI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 14:15:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35287 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750859AbaGaSPF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 14:15:05 -0400
Date: Thu, 31 Jul 2014 20:12:30 +0200
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
Message-ID: <20140731181230.GA18695@redhat.com>
References: <3f649f5658a163645e3ce15156176c325283762e.1405992946.git.luto@amacapital.net> <20140728173723.GA20993@redhat.com> <20140728185803.GA24663@redhat.com> <20140728192209.GA26017@localhost.localdomain> <20140729175414.GA3289@redhat.com> <20140730163516.GC18158@localhost.localdomain> <20140730174630.GA30862@redhat.com> <20140731003034.GA32078@localhost.localdomain> <20140731160353.GA14772@redhat.com> <20140731171329.GD7842@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140731171329.GD7842@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/31, Frederic Weisbecker wrote:
>
> On Thu, Jul 31, 2014 at 06:03:53PM +0200, Oleg Nesterov wrote:
> > On 07/31, Frederic Weisbecker wrote:
> > >
> > > I was convinced that the very first kernel init task is PID 0 then
> > > it forks on rest_init() to launch the userspace init with PID 1. Then init/0 becomes the
> > > idle task of the boot CPU.
> >
> > Yes sure. But context_tracking_cpu_set() is called by init task with PID 1, not
> > by "swapper".
>
> Are you sure? It's called from start_kernel() which is init/0.

But do_initcalls() is called by kernel_init(), this is the init process which is
going to exec /sbin/init later.

But this doesn't really matter,

> Maybe we should just enable it everywhere.

Yes, yes, this doesn't really matter. We can even add set(TIF_NOHZ) at the start
of start_kernel(). The question is, I still can't understand why do we want to
have the global TIF_NOHZ.

> > OK. To simplify, lets discuss user_enter() only. So, it is actually a nop on
> > CPU_0, and CPU_1 can miss it anyway.
> >
> > > But global TIF_NOHZ should enforce context tracking everywhere.
> >
> > And this is what I can't understand. Lets return to my initial question, why
> > we can't change __context_tracking_task_switch()
> >
> > 	void __context_tracking_task_switch(struct task_struct *prev,
> > 					    struct task_struct *next)
> > 	{
> > 		if (context_tracking_cpu_is_enabled())
> > 			set_tsk_thread_flag(next, TIF_NOHZ);
> > 		else
> > 			clear_tsk_thread_flag(next, TIF_NOHZ);
> > 	}
> >
> > ?
>
> Well we can change it to global TIF_NOHZ
>
> > How can the global TIF_NOHZ help?
>
> It avoids that flag swap on task_switch.

Ah, you probably meant that we can kill context_tracking_task_switch() as
we discussed.

But I meant another thing, TIF_NOHZ is already global because it is always
set after context_tracking_cpu_set().

Performance-wise, this set/clear code above can be better because it avoids
the slow paths on the untracked CPU's. But let's ignore this, the question is
why the change above is not correct? Or why it can make the things worse?


> > OK, OK, a task can return to usermode on CPU_0, notice TIF_NOHZ, take the
> > slow path, and do the "right" thing if it migrates to CPU_1 _before_ it
> > comes to user_enter(). But this case is very unlikely, certainly this can't
> > explain why do we penalize the untracked CPU's ?
>
> It's rather that CPU 0 calls user_enter() and then migrate to CPU 1 and resume
> to userspace.

And in this case a) user_enter() is pointless on CPU_0, and b) CPU_1 misses
the necessary user_enter().

> It's unlikely but possible. I actually observed that very easily on early testing.

Sure. And this can happen anyway? Why the change in __context_tracking_task_switch()
is wrong?

> And it's a big problem because then the CPU runs in userspace, possibly for a long while
> in HPC case, and context tracking thinks it is in kernelspace. As a result, RCU waits
> for that CPU to complete grace periods and cputime is accounted to kernelspace instead of
> userspace.
>
> It looks like a harmless race but it can have big consequences.

I see. Again, does the global TIF_NOHZ really help?

> > > And also it's
> > > less context switch overhead.
> >
> > Why???
>
> Because calling context_switch_task_switch() on every context switch is costly.

See above. This depends, but forcing the slow paths on all CPU's can be more
costly.

> > And of course I can't understand exception_enter/exit(). Not to mention that
> > (afaics) "prev_ctx == IN_USER" in exception_exit() can be false positive even
> > if we forget that the caller can migrate in between. Just because, once again,
> > a tracked CPU can miss user_exit().
>
> You lost me on this. How can a tracked CPU miss user_exit()?

I am lost too ;) Didn't we already discuss this? A task calls user_exit() on
CPU_0 for no reason, migrates to the tracked CPU_1 and finally returns to user
space leaving this cpu in IN_KERNEL state?

> > So, why not
> >
> > 	static inline void exception_enter(void)
> > 	{
> > 		user_exit();
> > 	}
> >
> > 	static inline void exception_exit(struct pt_regs *regs)
> > 	{
> > 		if (user_mode(regs))
> > 			user_enter();
> > 	}
>
> That's how I implemented it first. But then I changed it the way it is now:
> 6c1e0256fad84a843d915414e4b5973b7443d48d
> ("context_tracking: Restore correct previous context state on exception exit")
>
> This is again due to the shift between hard and soft userspace boundaries.
> user_mode(regs) checks hard boundaries only.
>
> Lets get back to our beloved example:
>
>           CPU 0                                  CPU 1
>           ---------------------------------------------
>
>           returning from syscall {
>                user_enter();
>                exception {
>                     exception_enter()
>                     PREEMPT!
>                     ----------------------->
>                                                  //resume exception
>                                                    exception_exit();
>                                                    return to userspace

OK, thanks, so in this case we miss user_enter().

But again, we can miss it anyway if preemptions comes before "exception" ?
if CPU 1 was in IN_KERNEL state.

Oleg.

