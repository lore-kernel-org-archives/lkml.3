Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754101Ab3LNUR0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Dec 2013 15:17:26 -0500
Received: from mx1.redhat.com ([209.132.183.28]:60327 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753880Ab3LNURY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Dec 2013 15:17:24 -0500
Date: Sat, 14 Dec 2013 21:17:46 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Dave Jones <davej@redhat.com>, Steven Rostedt <rostedt@goodmis.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Darren Hart <dvhart@linux.intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Mel Gorman <mgorman@suse.de>
Subject: Re: process 'stuck' at exit.
Message-ID: <20131214201746.GA31023@redhat.com>
References: <20131210213431.GA6342@redhat.com> <20131210214143.GG27373@redhat.com> <CA+55aFwr2e5x13fA+QWjt=iJFmCcugFErdqaeeUtH4XPBExC6Q@mail.gmail.com> <CA+55aFxLbFWhgzg=Rn0rhUpoOjbTE3QqUSxHTsCyk8GjDUFxJg@mail.gmail.com> <alpine.DEB.2.02.1312102329201.28330@ionos.tec.linutronix.de> <CA+55aFzhCSvc4Vy7tEC2K972h+vne6Y0QSekDDZbV_ATB-9mxw@mail.gmail.com> <20131210230009.GF5050@redhat.com> <20131211000504.GA13710@home.goodmis.org> <20131211002330.GA12924@redhat.com> <20131211005550.GA20404@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131211005550.GA20404@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/10, Dave Jones wrote:
>
> On Tue, Dec 10, 2013 at 07:23:30PM -0500, Dave Jones wrote:
>
>  > I was distracted by seeing all the other threads exiting, so I was only looking at
>  > what this one had already done.
>
> another thing that distracted me was that /proc/10818/stack was just showing that
>
> [<ffffffffffffffff>] 0xffffffffffffffff
>
> output.
>
> For my own education, what causes that ?

save_stack_trace_tsk() adds ULONG_MAX as the "last" entry.

and dump_trace() fails if task is running and != current (note that
cat /proc/self/stack works).

> How come it didn't show the same trace I saw when I sysrq-t'd ?

Because print_trace_address() does not skip !reliable entries,
unlike __save_stack_address(). This (afaics) makes the difference.

I'll try to make a patch but I am not sure... I am not even sure
it makes sense, but in any case this all doesn't look right to me.

First of all, stack = task->thread.sp is not really right if this
task is running. Worse, bp = *stack returned by stack_frame() is
random in this case. This equally applies to sysrq-t's output.
Not that bad, but still wrong and confusing, imho.

And lets look at dump_trace(),

	const unsigned cpu = get_cpu();
	unsigned long *irq_stack_end =
		(unsigned long *)per_cpu(irq_stack_ptr, cpu);

This (in general) has nothing to do with task_cpu(task).

And why dump_trace() checks irq_stack_end != NULL ? This is always true.

I think that these paths should not even try to guess what bp is
if the task is not running/current. But it is not clear to "disable"
reliable check in __save_stack_address(), we should report this fact
in proc_pid_stack()->seq_printf() somehow.

And proc_pid_stack() should drop ->cred_guard_mutex right after
save_stack_trace_tsk(), although this is off-topic.

Oleg.

