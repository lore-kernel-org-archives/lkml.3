Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752531AbaAGPaq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 10:30:46 -0500
Received: from mx1.redhat.com ([209.132.183.28]:23444 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751632AbaAGPai (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 10:30:38 -0500
Date: Tue, 7 Jan 2014 16:30:36 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Sergio Durigan Junior <sergiodj@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Roland McGrath <roland@hack.frob.com>,
        Denys Vlasenko <dvlasenk@redhat.com>, Pedro Alves <palves@redhat.com>,
        Tom Tromey <tromey@redhat.com>,
        Jan Kratochvil <jan.kratochvil@redhat.com>, Tejun Heo <tj@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [RFC/PATCH] Implement new PTRACE_EVENT_SYSCALL_{ENTER,EXIT}
Message-ID: <20140107153036.GA4749@redhat.com>
References: <m3wqic205t.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m3wqic205t.fsf@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/06, Sergio Durigan Junior wrote:
>
> This patch implements the new PTRACE_EVENT_SYSCALL_{ENTER,EXIT} events
> for ptrace.  The goal is kind of obvious: it lets the tracer to request
> for notifications when a syscall is called or has returned in the
> tracee.  This is very useful because currently there is no easy/direct
> way to inspect whether we are dealing with a call or a return of a
> syscall.  GDB itself has an open bug about this, because it can get
> confused when the program being debugged is restarted in the middle of a
> syscall that has been caught by "catch syscall".

Yes, this was suggested many times, probably makes sense.

But I am not sure about semantics, let me add more cc's.

> The other nice thing that I have implemented is the ability to obtain
> the syscall number related to the event by using PTRACE_GET_EVENTMSG.
> This way, we don't need to inspect registers anymore when we want to
> know which syscall is responsible for this or that event.

I won't argue, but it is not clear to me if this is really useful,
given that the debugger can read the regs.

And even if we do this, I disagree with this implementation, please
see below.

> --- a/arch/alpha/kernel/ptrace.c
> +++ b/arch/alpha/kernel/ptrace.c
> @@ -317,7 +317,8 @@ asmlinkage unsigned long syscall_trace_enter(void)
>  {
>  	unsigned long ret = 0;
>  	if (test_thread_flag(TIF_SYSCALL_TRACE) &&
> -	    tracehook_report_syscall_entry(current_pt_regs()))
> +	    tracehook_report_syscall_entry(current_pt_regs(),
> +					current_pt_regs()->r0))
>  		ret = -1UL;
>  	return ret ?: current_pt_regs()->r0;
>  }
> @@ -326,5 +327,6 @@ asmlinkage void
>  syscall_trace_leave(void)
>  {
>  	if (test_thread_flag(TIF_SYSCALL_TRACE))
> -		tracehook_report_syscall_exit(current_pt_regs(), 0);
> +		tracehook_report_syscall_exit(current_pt_regs(), 0,
> +						current_pt_regs()->r0);
>  }

And every arch/ is changed the same way. I do not think this is needed.
We already have syscall_get_nr(), this is what ptrace_report_syscall()
needs. So afaics this patch do not need to touch arch/ at all.


> +static inline int ptrace_report_syscall(struct pt_regs *regs, int entry,
> +	unsigned int sysno)
>  {
>  	int ptrace = current->ptrace;
> +	int is_sysenter = ptrace & PT_TRACE_SYSCALL_ENTER;
> +	int is_sysexit = ptrace & PT_TRACE_SYSCALL_EXIT;
> +	int is_ptsysgood = ptrace & PT_TRACESYSGOOD;
>
>  	if (!(ptrace & PT_PTRACED))
>  		return 0;
>
> -	ptrace_notify(SIGTRAP | ((ptrace & PT_TRACESYSGOOD) ? 0x80 : 0));
> +	if (is_sysenter || is_sysexit) {
> +		if (entry && is_sysenter)
> +			ptrace_event(PTRACE_EVENT_SYSCALL_ENTER, sysno);
> +		else if (!entry && is_sysexit)
> +			ptrace_event(PTRACE_EVENT_SYSCALL_EXIT, sysno);
> +		else
> +			return 0;
> +	} else
> +		ptrace_notify(SIGTRAP | (is_ptsysgood ? 0x80 : 0));

OK. So PTRACE_O_SYSCALL_ENTER acts like PTRACE_O_TRACESYSGOOD, you still
need ptrace(PTRACE_SYSCALL) if you want PTRACE_EVENT_SYSCALL_ENTER.

If we add the new API, perhaps we should change ptrace_resume ?
I mean,

	--- x/kernel/ptrace.c
	+++ x/kernel/ptrace.c
	@@ -723,7 +723,9 @@ static int ptrace_resume(struct task_str
		if (!valid_signal(data))
			return -EIO;
	 
	-	if (request == PTRACE_SYSCALL)
	+	if (request == PTRACE_SYSCALL ||
	+	    ptrace_event_enabled(PTRACE_EVENT_SYSCALL_ENTER) ||
	+	    ptrace_event_enabled(PTRACE_EVENT_SYSCALL_EXIT))
			set_tsk_thread_flag(child, TIF_SYSCALL_TRACE);
		else
			clear_tsk_thread_flag(child, TIF_SYSCALL_TRACE);


This way PTRACE_O_SYSCALL_* will work like other ptrace options which
ask to report an event.

Or. Instead, perhaps we can add a single option PTRACE_O_TRACESYSREALLYGOOD
which doesn't report the new event and simply does something like

	current->ptrace_message = syscall_get_nr() | (entry << 31);
	ptrace_notify(SIGTRAP | 0x80);

Finally. If we add this feature, we should probably also report
is_compat_task() somehow. Currently the debugger can't know if, say,
a 64bit tracee does int80.

OTOH, perhaps it would be better to report this via regs->flags as
(iirc) Linus suggested.

Once again, personally I am fine either way. Just I think we should
discuss every possible option.

Oleg.

