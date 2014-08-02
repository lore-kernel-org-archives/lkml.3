Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755048AbaHBRcx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Aug 2014 13:32:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31629 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754547AbaHBRcu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Aug 2014 13:32:50 -0400
Date: Sat, 2 Aug 2014 19:30:24 +0200
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
Message-ID: <20140802173024.GB22510@redhat.com>
References: <20140728185803.GA24663@redhat.com> <20140728192209.GA26017@localhost.localdomain> <20140729175414.GA3289@redhat.com> <20140730163516.GC18158@localhost.localdomain> <20140730174630.GA30862@redhat.com> <20140731003034.GA32078@localhost.localdomain> <20140731160353.GA14772@redhat.com> <20140731171329.GD7842@localhost.localdomain> <20140731181230.GA18695@redhat.com> <20140731184729.GA12296@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140731184729.GA12296@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/31, Frederic Weisbecker wrote:
>
> On Thu, Jul 31, 2014 at 08:12:30PM +0200, Oleg Nesterov wrote:
> > > >
> > > > Yes sure. But context_tracking_cpu_set() is called by init task with PID 1, not
> > > > by "swapper".
> > >
> > > Are you sure? It's called from start_kernel() which is init/0.
> >
> > But do_initcalls() is called by kernel_init(), this is the init process which is
> > going to exec /sbin/init later.
> >
> > But this doesn't really matter,
>
> Yeah but tick_nohz_init() is not an initcall, it's a function called from start_kernel(),
> before initcalls.

Ah, indeed, and context_tracking_init() too. Even better, so we only need

	--- x/kernel/context_tracking.c
	+++ x/kernel/context_tracking.c
	@@ -30,8 +30,10 @@ EXPORT_SYMBOL_GPL(context_tracking_enabl
	 DEFINE_PER_CPU(struct context_tracking, context_tracking);
	 EXPORT_SYMBOL_GPL(context_tracking);
	 
	-void context_tracking_cpu_set(int cpu)
	+void __init context_tracking_cpu_set(int cpu)
	 {
	+	/* Called by "swapper" thread, all threads will inherit this flag */
	+	set_thread_flag(TIF_NOHZ);
		if (!per_cpu(context_tracking.active, cpu)) {
			per_cpu(context_tracking.active, cpu) = true;
			static_key_slow_inc(&context_tracking_enabled);

and now we can kill context_tracking_task_switch() ?

> > Yes, yes, this doesn't really matter. We can even add set(TIF_NOHZ) at the start
> > of start_kernel(). The question is, I still can't understand why do we want to
> > have the global TIF_NOHZ.
>
> Because then the flags is inherited in forks. It's better than inheriting it on
> context switch due to context switch being called much more often than fork.

This is clear, that is why I suggested this. Just we didn't understand each other,
when I said "global TIF_NOHZ" I meant the current situtation when every (running)
task has this bit set anyway. Sorry for confusion.

> No, because preempt_schedule_irq() does the ctx_state save and restore with
> exception_enter/exception_exit.

Thanks again. Can't understand how I managed to miss that exception_enter/exit
in preempt_schedule_*.

Damn. And after I spent more time, I don't have any idea how to make this
tracking cheaper.

Oleg.

