Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753422Ab3A2QqJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 11:46:09 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:6375 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751155Ab3A2QqG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 11:46:06 -0500
X-Authority-Analysis: v=2.0 cv=W/m6pGqk c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=9Wk9NYerj9wA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=O1YP5waFyKMA:10 a=ffo6r3prYUDSJWiIHsQA:9 a=PUjeQqilurYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1359477963.17639.46.camel@gandalf.local.home>
Subject: Re: [GIT PULL] cputime: Full dynticks task/cputime accounting v7
From: Steven Rostedt <rostedt@goodmis.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Li Zhong <zhong@linux.vnet.ibm.com>,
        Namhyung Kim <namhyung.kim@lge.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sedat Dilek <sedat.dilek@gmail.com>, Gleb Natapov <gleb@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, Tony Luck <tony.luck@intel.com>,
        Fenghua Yu <fenghua.yu@intel.com>
Date: Tue, 29 Jan 2013 11:46:03 -0500
In-Reply-To: <CAFTL4hxfd_xr-X4dj_4bdeYb3YBCCJkYwnciZ939ee1PXbpNYg@mail.gmail.com>
References: <1359399845-10568-1-git-send-email-fweisbec@gmail.com>
	 <1359417749.17639.6.camel@gandalf.local.home>
	 <1359426979.17639.10.camel@gandalf.local.home>
	 <CAFTL4hwbbLoPYwvyEUYyn2EuEj=2nw2NPehe8G4rykRTE3LziA@mail.gmail.com>
	 <1359427458.17639.12.camel@gandalf.local.home>
	 <CAFTL4hxHUoFchx9wkvfLvOPVRq+P3VSHiZoPRnMJ4YdvzN=TWQ@mail.gmail.com>
	 <1359434299.17639.13.camel@gandalf.local.home>
	 <CAFTL4hxfd_xr-X4dj_4bdeYb3YBCCJkYwnciZ939ee1PXbpNYg@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-01-29 at 16:12 +0100, Frederic Weisbecker wrote:

> I have set some cputime tracepoint and looked at the stacktrace. They
> are sorted by weight, which is the amount of cputime accounted. I
> can't find anything wrong on these. See attachment.

That's because a histogram doesn't show the issue. You need to see the
order of events. That is, you need to see that user time is calculated
again within a system call. I ran my trace again with stack trace
enabled and it shows the race nicely:

kernelsp-2367    7....  7088.483227: funcgraph_entry:                   |  syscall_trace_leave() {
kernelsp-2367    7d..1  7088.483228: bprint:               account_system_time : system: 17887
kernelsp-2367    7d..1  7088.483242: kernel_stack:         <stack trace>
=> __vtime_account_system (ffffffff810646e5)
=> vtime_user_enter (ffffffff81064a5e)
=> user_enter (ffffffff810d8b2b)
=> syscall_trace_leave (ffffffff8100d03f)
=> return_to_handler (ffffffff814c8dc5)
=> int_check_syscall_exit_work (ffffffff814c925f)

syscall_trace_leave() was called, we are leaving a system call and going
back to userspace. We calculate the system time and set the state to
IN_USER by user_enter().


kernelsp-2367    7d..1  7088.483244: bprint:               account_user_time : user: 15753
kernelsp-2367    7d..1  7088.483262: kernel_stack:         <stack trace>
=> vtime_account_user (ffffffff81064a12)
=> vtime_account_irq_enter (ffffffff81064b40)
=> irq_enter (ffffffff8103d36e)
=> smp_apic_timer_interrupt (ffffffff814caa83)
=> apic_timer_interrupt (ffffffff814c9bb2)
=> user_enter (ffffffff810d8b58)
=> syscall_trace_leave (ffffffff8100d03f)
=> return_to_handler (ffffffff814c8dc5)
=> int_check_syscall_exit_work (ffffffff814c925f)


But before we got to user space, we took an interrupt (smp_apic_timer_interrupt).

Now the vtime_account_irq_enter() sees the IN_USER set, and accounts the
time back to userspace. That was 16us it calculated incorrectly.


kernelsp-2367    7d.h1  7088.483267: bprint:               account_system_time : system: 23401
kernelsp-2367    7d.h1  7088.483286: kernel_stack:         <stack trace>
=> __vtime_account_system (ffffffff810646e5)
=> vtime_account_irq_exit (ffffffff810649b8)
=> irq_exit (ffffffff8103d39e)
=> smp_apic_timer_interrupt (ffffffff814caacf)
=> apic_timer_interrupt (ffffffff814c9bb2)
=> user_enter (ffffffff810d8b58)
=> syscall_trace_leave (ffffffff8100d03f)
=> return_to_handler (ffffffff814c8dc5)
=> int_check_syscall_exit_work (ffffffff814c925f)

Now we are leaving the interrupt and since the state is still IN_USER,
the system time is calculated.

kernelsp-2367    7d..2  7088.483287: bprint:               account_user_time : user: 19865
kernelsp-2367    7d..2  7088.483309: kernel_stack:         <stack trace>
=> vtime_account_user (ffffffff81064a12)
=> vtime_account_irq_enter (ffffffff81064b40)
=> __do_softirq (ffffffff8103d0f5)
=> call_softirq (ffffffff814ca2fc)
=> do_softirq (ffffffff81003fdc)
=> irq_exit (ffffffff8103d3df)
=> smp_apic_timer_interrupt (ffffffff814caacf)
=> apic_timer_interrupt (ffffffff814c9bb2)
=> user_enter (ffffffff810d8b58)
=> syscall_trace_leave (ffffffff8100d03f)
=> return_to_handler (ffffffff814c8dc5)
=> int_check_syscall_exit_work (ffffffff814c925f)

But oops, we are now running a softirq, which happens to get everything
wrong again, and calculates another 20us incorrectly towards user time.

Perhaps the best thing to do is to have the irq vtime determine usermode
or not with "user_mode(get_irq_regs())". I'll try it.

-- Steve


