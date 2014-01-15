Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752078AbaAOPdg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 10:33:36 -0500
Received: from g4t0017.houston.hp.com ([15.201.24.20]:8559 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751502AbaAOPde (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 10:33:34 -0500
Message-ID: <52D6AA38.2040606@hp.com>
Date: Wed, 15 Jan 2014 10:33:12 -0500
From: Waiman Long <waiman.long@hp.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130109 Thunderbird/10.0.12
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Andy Lutomirski <luto@amacapital.net>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Aswin Chandramouleeswaran <aswin@hp.com>,
        Scott J Norton <scott.norton@hp.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: SIGSEGV when using "perf record -g" with 3.13-rc* kernel
References: <52D011C9.7000209@hp.com> <20140110165822.GI7572@laptop.programming.kicks-ass.net> <20140110170223.GD8224@laptop.programming.kicks-ass.net> <20140110174141.GE8224@laptop.programming.kicks-ass.net> <CALCETrW2r=_Vt7+4aNKkKGeCAi8=WPULvPX3eyUEKH5nsu_CKQ@mail.gmail.com> <20140110200603.GJ7572@laptop.programming.kicks-ass.net>
In-Reply-To: <20140110200603.GJ7572@laptop.programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/10/2014 03:06 PM, Peter Zijlstra wrote:
>
> :-)
>
> Something like this perhaps?
>
> ---
> Subject: x86, mm: Allow double faults from interrupts
>
> Waiman managed to trigger a PMI while in a emulate_vsyscall() fault, the
> PMI in turn managed to trigger a fault while obtaining a stack trace.
> This triggered the double fault logic and killed the process dead.
>
> Fix this by explicitly excluding interrupts from the double fault logic.
>
> Reported-by: Waiman Long<waiman.long@hp.com>
> Signed-off-by: Peter Zijlstra<peterz@infradead.org>
> ---
>   arch/x86/mm/fault.c | 18 ++++++++++++++++++
>   1 file changed, 18 insertions(+)
>
> diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
> index 9ff85bb8dd69..4c8e32986aad 100644
> --- a/arch/x86/mm/fault.c
> +++ b/arch/x86/mm/fault.c
> @@ -641,6 +641,20 @@ no_context(struct pt_regs *regs, unsigned long error_code,
>
>   	/* Are we prepared to handle this kernel fault? */
>   	if (fixup_exception(regs)) {
> +		/*
> +		 * Any interrupt that takes a fault gets the fixup. This
> +		 * makes the below double fault logic only apply to a
> +		 * task double faulting from task context.
> +		 */
> +		if (in_interrupt())
> +			return;
> +
> +		/*
> +		 * Per the above we're !in_interrupt(), aka. task context.
> +		 *
> +		 * In this case we need to make sure we're not double faulting
> +		 * through the emulate_vsyscall() logic.
> +		 */
>   		if (current_thread_info()->sig_on_uaccess_error&&  signal) {
>   			tsk->thread.trap_nr = X86_TRAP_PF;
>   			tsk->thread.error_code = error_code | PF_USER;
> @@ -649,6 +663,10 @@ no_context(struct pt_regs *regs, unsigned long error_code,
>   			/* XXX: hwpoison faults will set the wrong code. */
>   			force_sig_info_fault(signal, si_code, address, tsk, 0);
>   		}
> +
> +		/*
> +		 * Barring that, we can do the fixup and be happy.
> +		 */
>   		return;
>   	}
>

Are you going to send out an official patch to fix this problem? I 
really like to see it merged into 3.13 before it is released.

-Longman
