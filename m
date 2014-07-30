Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755859AbaG3Rsv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 13:48:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:7719 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755667AbaG3Rst (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 13:48:49 -0400
Date: Wed, 30 Jul 2014 19:46:30 +0200
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
Message-ID: <20140730174630.GA30862@redhat.com>
References: <cover.1405992946.git.luto@amacapital.net> <3f649f5658a163645e3ce15156176c325283762e.1405992946.git.luto@amacapital.net> <20140728173723.GA20993@redhat.com> <20140728185803.GA24663@redhat.com> <20140728192209.GA26017@localhost.localdomain> <20140729175414.GA3289@redhat.com> <20140730163516.GC18158@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140730163516.GC18158@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/30, Frederic Weisbecker wrote:
>
> On Tue, Jul 29, 2014 at 07:54:14PM +0200, Oleg Nesterov wrote:
>
> >
> > Looks like, we can kill context_tracking_task_switch() and simply change the
> > "__init" callers of context_tracking_cpu_set() to do set_thread_flag(TIF_NOHZ) ?
> > Then this flag will be propagated by copy_process().
>
> Right, that would be much better. Good catch! context tracking is enabled from
> tick_nohz_init(). This is the init 0 task so the flag should be propagated from there.

actually init 1 task, but this doesn't matter.

> I still think we need a for_each_process_thread() set as well though because some
> kernel threads may well have been created at this stage already.

Yes... Or we can add set_thread_flag(TIF_NOHZ) into ____call_usermodehelper().

> > Or I am totally confused? (quite possible).
> >
> > > So here is a scenario where this is a problem: a task runs on CPU 0, passes the context
> > > tracking call before returning from a syscall to userspace, and gets an interrupt. The
> > > interrupt preempts the task and it moves to CPU 1. So it returns from preempt_schedule_irq()
> > > after which it is going to resume to userspace.
> > >
> > > In this scenario, if context tracking is only enabled on CPU 1, we have no way to know that
> > > the task is resuming to userspace, because we passed through the context tracking probe
> > > already and it was ignored on CPU 0.
> >
> > Thanks. But I still can't understand... So if we only track CPU 1, then in this
> > case context_tracking.state == IN_USER on CPU 0, but it can be IN_USER or IN_KERNEL
> > on CPU 1.
>
> I'm not sure I understand your question.

Probably because it was stupid. Seriously, I still have no idea what this code
actually does.

> Context tracking is either enabled everywhere or
> nowhere.
>
> I need to say though that there is a per CPU context tracking state named context_tracking.active.
> It's confusing because it suggests that context tracking is active per CPU. Actually it's tracked
> everywhere when globally enabled, but active determines if we call the RCU and vtime callbacks or
> not.
>
> So only nohz full CPUs have context_tracking.active set because only these need to call the RCU
> and vtime callbacks. Other CPUs still do the context tracking but they won't call rcu and vtime
> functions.

I meant that in the scenario you described above the "global" TIF_NOHZ doesn't
really make a difference, afaics.

Lets assume that context tracking is only enabled on CPU 1. To simplify,
assume that we have a single usermode task T which sleeps in kernel mode.

So context_tracking[0].state == context_tracking[1].state == IN_KERNEL.

T wakes up on CPU_0, returns to user space, calls user_enter(). This sets
context_tracking[0].state = IN_USER but otherwise does nothing else, this
CPU is not tracked and .active is false.

Right after local_irq_restore() this task can migrate to CPU_1 and finish
its ret-to-usermode path. But since it had already passed user_enter() we
do not change context_tracking[1].state and do not play with rcu/vtime.
(unless this task hits SCHEDULE_USER in asm).

The same for user_exit() of course.

Oleg.

