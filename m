Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755234Ab3F1OVt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 10:21:49 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:28508 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755178Ab3F1OVr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 10:21:47 -0400
X-Authority-Analysis: v=2.0 cv=KtrPKBqN c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=F6bfKC6atTwA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=4o3xqwvaRjkA:10 a=x30EXVXcAAAA:8 a=3Cv3BT6-Dkr-EQOFqdMA:9 a=QEXdDO2ut3YA:10 a=2F0HLYTCHDIA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1372429303.18733.325.camel@gandalf.local.home>
Subject: Re: [PATCH -tip] x86,trace: Add rcu_irq_enter/exit() in
 smp_trace_reschedule_interrupt()
From: Steven Rostedt <rostedt@goodmis.org>
To: Seiji Aguchi <seiji.aguchi@hds.com>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, hpa@zytor.com, mingo@elte.hu,
        tglx@linutronix.de, "Paul E. McKenney" <paulmck@us.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>
Date: Fri, 28 Jun 2013 10:21:43 -0400
In-Reply-To: <51C8AA31.3070208@hds.com>
References: <51C8AA31.3070208@hds.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ Added Peter Z. and Paul ]

On Mon, 2013-06-24 at 16:21 -0400, Seiji Aguchi wrote:
> Reschedule vector tracepoints may be called in cpu idle state.
> This causes lockdep check warning below.
> So, add rcu_irq_enter/exit() to smp_trace_reschedule_interrupt().
> 
> [   50.720557] Testing event reschedule_exit:
> [   50.721349]
> [   50.721502] ===============================
> [   50.721835] [ INFO: suspicious RCU usage. ]
> [   50.722169] 3.10.0-rc6-00004-gcf910e8 #190 Not tainted
> [   50.722582] -------------------------------
> [   50.722915] /c/kernel-tests/src/linux/arch/x86/include/asm/trace/irq_vectors.h:50 suspicious rcu_dereference_check() usage!
> [   50.723770]
> [   50.723770] other info that might help us debug this:
> [   50.723770]
> [   50.724385]
> [   50.724385] RCU used illegally from idle CPU!
> [   50.724385] rcu_scheduler_active = 1, debug_locks = 0
> [   50.725232] RCU used illegally from extended quiescent state!
> [   50.725690] no locks held by swapper/0/0.
> [   50.726010]
> [   50.726010] stack backtrace:
> [   50.726359] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 3.10.0-rc6-00004-gcf910e8 #190
> [   50.726965] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
> 
> [   50.727417]  00000001 00000001 79c53f04 798bd9f9 79c53f2c 79077a70 79b412c6 79b41fd1
> [   50.728159]  00000001 00000000 79c5ef8c 87147c58 00000000 79c55800 79c53f38 79010b65
> [   50.728849]  79c52000 79c53f7c 798c720e 79c52000 79c5ef8c 00000004 00000000 79c55800
> [   50.729532] Call Trace:
> [   50.729730]  [<798bd9f9>] dump_stack+0x16/0x18
> [   50.730072]  [<79077a70>] lockdep_rcu_suspicious+0xf2/0xfa
> [   50.730498]  [<79010b65>] smp_trace_reschedule_interrupt+0x1c8/0x1d0
> [   50.730979]  [<798c720e>] trace_reschedule_interrupt+0x36/0x3c
> [   50.731214]  [<7901875f>] ? native_safe_halt+0x5/0x7
> [   50.731214]  [<790085cc>] default_idle+0xb1/0x1e2
> [   50.731214]  [<79008d05>] arch_cpu_idle+0xe/0x10
> [   50.731214]  [<79069ddf>] cpu_startup_entry+0x1e4/0x2c3
> [   50.731214]  [<798adb34>] rest_init+0x12c/0x132
> [   50.731214]  [<798ada08>] ? __read_lock_failed+0x14/0x14
> [   50.731214]  [<79d309e4>] start_kernel+0x38d/0x393
> [   50.731214]  [<79d30489>] ? repair_env_string+0x51/0x51
> [   50.731214]  [<79d302c3>] i386_start_kernel+0x79/0x7d
> [   50.771947] OK
> [   50.772099] Testing event reschedule_entry: OK
> 
> Signed-off-by: Seiji Aguchi <seiji.aguchi@hds.com>
> ---
>  arch/x86/kernel/smp.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/x86/kernel/smp.c b/arch/x86/kernel/smp.c
> index f4fe0b8..b959056 100644
> --- a/arch/x86/kernel/smp.c
> +++ b/arch/x86/kernel/smp.c
> @@ -268,9 +268,11 @@ void smp_reschedule_interrupt(struct pt_regs *regs)
>  void smp_trace_reschedule_interrupt(struct pt_regs *regs)
>  {
>  	ack_APIC_irq();
> +	rcu_irq_enter();
>  	trace_reschedule_entry(RESCHEDULE_VECTOR);
>  	__smp_reschedule_interrupt();
>  	trace_reschedule_exit(RESCHEDULE_VECTOR);
> +	rcu_irq_exit();

The question is, should we add normal irq_enter/exit here? As that
should be OK to nest. There's a comment in scheduler_ipi():

	/*
	 * Not all reschedule IPI handlers call irq_enter/irq_exit, since
	 * traditionally all their work was done from the interrupt return
	 * path. Now that we actually do some work, we need to make sure
	 * we do call them.
	 *
	 * Some archs already do call them, luckily irq_enter/exit nest
	 * properly.
	 *
	 * Arguably we should visit all archs and update all handlers,
	 * however a fair share of IPIs are still resched only so this would
	 * somewhat pessimize the simple resched case.
	 */

just before it calls irq_enter(). Seems that not calling irq_enter() for
the reschedule ipi interrupt is more of a legacy thing. It also states
that its OK for an arch to call irq_enter() before calling this as it
can nest. I wonder if we should invest time in fixing all archs and
remove this irq_enter? But that's out of scope for this change.

Either way, the tracepoint requires rcu but for accuracy it also
requires irq_enter() (tracepoints record the irq context), thus, the
tracepoint interrupt handler should be calling irq_enter() and not
rcu_irq_enter() (irq_enter() calls rcu_irq_enter())

-- Steve

>  	/*
>  	 * KVM uses this interrupt to force a cpu out of guest mode
>  	 */


