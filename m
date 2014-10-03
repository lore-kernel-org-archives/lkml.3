Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753768AbaJCQFs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 12:05:48 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:33633 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752922AbaJCQFp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 12:05:45 -0400
Date: Fri, 3 Oct 2014 17:03:06 +0100
From: Will Deacon <will.deacon@arm.com>
To: AKASHI Takahiro <takahiro.akashi@linaro.org>
Cc: Catalin Marinas <Catalin.Marinas@arm.com>,
        "dsaxena@linaro.org" <dsaxena@linaro.org>,
        "Vijaya.Kumar@caviumnetworks.com" <Vijaya.Kumar@caviumnetworks.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC v2] arm64: kgdb: fix single stepping
Message-ID: <20141003160306.GC32451@arm.com>
References: <1411732453-5437-1-git-send-email-takahiro.akashi@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1411732453-5437-1-git-send-email-takahiro.akashi@linaro.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Akashi,

On Fri, Sep 26, 2014 at 12:54:13PM +0100, AKASHI Takahiro wrote:
> I tried to verify kgdb in vanilla kernel on fast model, but it seems that
> the single stepping with kgdb doesn't work correctly since its first
> appearance at v3.15.
> 
> On v3.15, 'stepi' command after breaking the kernel at some breakpoint
> steps forward to the next instruction, but the succeeding 'stepi' never
> goes beyond that.
> On v3.16, 'stepi' moves forward and stops at the next instruction just
> after enable_dbg in el1_dbg, and never goes beyond that. This variance of
> behavior seems to come in with the following patch in v3.16:
> 
>     commit 2a2830703a23 ("arm64: debug: avoid accessing mdscr_el1 on fault
>     paths where possible")
> 
> This patch
> (1) moves kgdb_disable_single_step() from 'c' command handling to single
>     step handler.
>     This makes sure that single stepping gets effective at every 's' command.
>     Please note that, under the current implementation, single step bit in
>     spsr, which is cleared by the first single stepping, will not be set
>     again for the consecutive 's' commands because single step bit in mdscr
>     is still kept on (that is, kernel_active_single_step() in
>     kgdb_arch_handle_exception() is true).
> (2) removes 'enable_dbg' in el1_dbg.
>     Single step bit in mdscr is turned on in do_handle_exception()->
>     kgdb_handle_expection() before returning to debugged context, and if
>     debug exception is enabled in el1_dbg, we will see unexpected single-
>     stepping in el1_dbg.
> (3) masks interrupts while single-stepping one instruction.
>     If an interrupt is caught during processing a single-stepping, debug
>     exception is unintentionally enabled by el1_irq's 'enable_dbg' before
>     returning to debugged context.
>     Thus, like in (2), we will see unexpected single-stepping in el1_irq.
> 
> Basically (1) is for v3.15, (2) and (3) with (1) for v3.16.
> 
> With those changes, we will see another problem if a breakpoint is set
> at interrupt-sensible places, like gic_handle_irq():

So it seems to me like kgdb is a complete mess in this area. The low-level
debug exception code for arm64 will single-step *into* interrupt handlers. I
believe that this is the correct behaviour, as otherwise we're artifically
restricting what you can and can't debug (for example, leaving debug
exceptions masked on the interrupt path means that you can't put breakpoints
in interrupt handlers).

>     KGDB: re-enter error: breakpoint removed ffffffc000081258
>     ------------[ cut here ]------------
>     WARNING: CPU: 0 PID: 650 at kernel/debug/debug_core.c:435
> 					kgdb_handle_exception+0x1dc/0x1f4()
>     Modules linked in:
>     CPU: 0 PID: 650 Comm: sh Not tainted 3.17.0-rc2+ #177
>     Call trace:
>     [<ffffffc000087fac>] dump_backtrace+0x0/0x130
>     [<ffffffc0000880ec>] show_stack+0x10/0x1c
>     [<ffffffc0004d683c>] dump_stack+0x74/0xb8
>     [<ffffffc0000ab824>] warn_slowpath_common+0x8c/0xb4
>     [<ffffffc0000ab90c>] warn_slowpath_null+0x14/0x20
>     [<ffffffc000121bfc>] kgdb_handle_exception+0x1d8/0x1f4
>     [<ffffffc000092ffc>] kgdb_brk_fn+0x18/0x28
>     [<ffffffc0000821c8>] brk_handler+0x9c/0xe8
>     [<ffffffc0000811e8>] do_debug_exception+0x3c/0xac
>     Exception stack(0xffffffc07e027650 to 0xffffffc07e027770)
>     ...
>     [<ffffffc000083cac>] el1_dbg+0x14/0x68
>     [<ffffffc00012178c>] kgdb_cpu_enter+0x464/0x5c0
>     [<ffffffc000121bb4>] kgdb_handle_exception+0x190/0x1f4
>     [<ffffffc000092ffc>] kgdb_brk_fn+0x18/0x28
>     [<ffffffc0000821c8>] brk_handler+0x9c/0xe8
>     [<ffffffc0000811e8>] do_debug_exception+0x3c/0xac
>     Exception stack(0xffffffc07e027ac0 to 0xffffffc07e027be0)
>     ...
>     [<ffffffc000083cac>] el1_dbg+0x14/0x68
>     [<ffffffc00032e4b4>] __handle_sysrq+0x11c/0x190
>     [<ffffffc00032e93c>] write_sysrq_trigger+0x4c/0x60
>     [<ffffffc0001e7d58>] proc_reg_write+0x54/0x84
>     [<ffffffc000192fa4>] vfs_write+0x98/0x1c8
>     [<ffffffc0001939b0>] SyS_write+0x40/0xa0
> 
> Once some interrupt occurs, a breakpoint at gic_handle_irq() triggers kgdb.
> Kgdb then calls kgdb_roundup_cpus() to sync with other cpus.
> Current kgdb_roundup_cpus() unmasks interrupts temporarily to
> use smp_call_function().
> This eventually allows another interrupt to occur and likely results in
> hitting a breakpoint at gic_handle_irq() again since debug exception is
> always enabled in el1_irq.
> 
> We can avoid this issue by specifying "nokgdbroundup" in kernel parameter,
> but this will also leave other cpus be in unknown state in terms of kgdb,
> and may result in interfering with kgdb activity.

Yuck. This really sounds like kgdb is broken in its SMP synchronisation
for arm64. On x86, they use a NMI and powerpc uses an IPI which can run
with irqs disabled. Since we don't have an NMI, how about we do the
following to avoid the panic?

  (1) Change our kgdb_roundup_cpus to use smp_call_function_single_async,
      which will avoid the need to enable interrupts

  (2) Introduce a timeout into the waiting loop in kgdb_cpu_enter, where
      we spin on &slaves_in_kgdb and warn if the timeout expires.

Will
