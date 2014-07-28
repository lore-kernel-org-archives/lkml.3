Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751881AbaG1TW0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 15:22:26 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:34508 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750825AbaG1TWY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 15:22:24 -0400
Date: Mon, 28 Jul 2014 21:22:13 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andy Lutomirski <luto@amacapital.net>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, Kees Cook <keescook@chromium.org>,
        Will Drewry <wad@chromium.org>, x86@kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-mips@linux-mips.org,
        linux-arch@vger.kernel.org, linux-security-module@vger.kernel.org,
        Alexei Starovoitov <ast@plumgrid.com>, hpa@zytor.com
Subject: Re: TIF_NOHZ can escape nonhz mask? (Was: [PATCH v3 6/8] x86: Split
 syscall_trace_enter into two phases)
Message-ID: <20140728192209.GA26017@localhost.localdomain>
References: <cover.1405992946.git.luto@amacapital.net>
 <3f649f5658a163645e3ce15156176c325283762e.1405992946.git.luto@amacapital.net>
 <20140728173723.GA20993@redhat.com>
 <20140728185803.GA24663@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140728185803.GA24663@redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 28, 2014 at 08:58:03PM +0200, Oleg Nesterov wrote:
> Off-topic, but...
> 
> On 07/28, Oleg Nesterov wrote:
> >
> > But we should always call user_exit() unconditionally?
> 
> Frederic, don't we need the patch below? In fact clear_() can be moved
> under "if ()" too. and probably copy_process() should clear this flag...
> 
> Or. __context_tracking_task_switch() can simply do
> 
> 	 if (context_tracking_cpu_is_enabled())
> 	 	set_tsk_thread_flag(next, TIF_NOHZ);
> 	 else
> 	 	clear_tsk_thread_flag(next, TIF_NOHZ);
> 
> and then we can forget about copy_process(). Or I am totally confused?
> 
> 
> I am also wondering if we can extend user_return_notifier to handle
> enter/exit and kill TIF_NOHZ.
> 
> Oleg.
> 
> --- x/kernel/context_tracking.c
> +++ x/kernel/context_tracking.c
> @@ -202,7 +202,8 @@ void __context_tracking_task_switch(stru
>  				    struct task_struct *next)
>  {
>  	clear_tsk_thread_flag(prev, TIF_NOHZ);
> -	set_tsk_thread_flag(next, TIF_NOHZ);
> +	if (context_tracking_cpu_is_enabled())
> +		set_tsk_thread_flag(next, TIF_NOHZ);
>  }
>  
>  #ifdef CONFIG_CONTEXT_TRACKING_FORCE

Unfortunately, as long as tasks can migrate in and out a context tracked CPU, we
need to track all CPUs.

This is because there is always a small shift between hard and soft kernelspace
boundaries.

Hard boundaries are the real strict boundaries: between "int", "iret" or faulting
instructions for example.

Soft boundaries are the place where we put our context tracking probes. They
are just function calls and a distance between them and hard boundaries is inevitable.

So here is a scenario where this is a problem: a task runs on CPU 0, passes the context
tracking call before returning from a syscall to userspace, and gets an interrupt. The
interrupt preempts the task and it moves to CPU 1. So it returns from preempt_schedule_irq()
after which it is going to resume to userspace.

In this scenario, if context tracking is only enabled on CPU 1, we have no way to know that
the task is resuming to userspace, because we passed through the context tracking probe
already and it was ignored on CPU 0.

This might be hackbable by ensuring that irqs are disabled between context tracking
calls and actual returns to userspace. It's a nightmare to audit on all archs though,
and it makes the context tracking callers less flexible also that only solve the issue
for irqs. Exception have a similar problem and we can't mask them.
