Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752668AbaCAMbN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Mar 2014 07:31:13 -0500
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:34033 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752017AbaCAMbL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Mar 2014 07:31:11 -0500
Date: Sat, 1 Mar 2014 12:30:26 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: David Long <dave.long@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, Rabin Vincent <rabin@rab.in>,
        "Jon Medhurst (Tixy)" <tixy@linaro.org>,
        Oleg Nesterov <oleg@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        davem@davemloft.net, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6 00/14] uprobes: Add uprobes support for ARM
Message-ID: <20140301123026.GD21483@n2100.arm.linux.org.uk>
References: <1392017945-4507-1-git-send-email-dave.long@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1392017945-4507-1-git-send-email-dave.long@linaro.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 10, 2014 at 02:38:51AM -0500, David Long wrote:
> This patch series adds basic uprobes support to ARM. It is based on patches
> developed earlier by Rabin Vincent. That approach of adding hooks into
> the kprobes instruction parsing code was not well received. This approach
> separates the ARM instruction parsing code in kprobes out into a separate set
> of functions which can be used by both kprobes and uprobes. Both kprobes and
> uprobes then provide their own semantic action tables to process the results of
> the parsing.

Here's more build errors, from omap4430-sdp's randconfig build from
last night - note that the linker can't always get the filenames
right:

arch/arm/kernel/built-in.o: In function `do_work_pending':
psci_smp.c:(.text+0x2e44): undefined reference to `uprobe_notify_resume'
arch/arm/kernel/built-in.o: In function `uprobe_trap_handler':
psci_smp.c:(.text+0x79d4): undefined reference to `uprobe_pre_sstep_notifier'
psci_smp.c:(.text+0x79e8): undefined reference to `uprobe_post_sstep_notifier'
arch/arm/kernel/built-in.o: In function `set_swbp':
psci_smp.c:(.text+0x7a54): undefined reference to `uprobe_write_opcode'
kernel/built-in.o: In function `mmput.part.45':
context_tracking.c:(.text+0xaf0): undefined reference to `uprobe_clear_state'
kernel/built-in.o: In function `mm_release':
context_tracking.c:(.text+0xd3c): undefined reference to `uprobe_free_utask'
kernel/built-in.o: In function `copy_process.part.47':
context_tracking.c:(.text+0x1748): undefined reference to `uprobe_copy_process'
kernel/built-in.o: In function `get_signal_to_deliver':
context_tracking.c:(.text+0x111bc): undefined reference to `uprobe_deny_signal'
kernel/built-in.o: In function `probe_event_enable.constprop.5':
context_tracking.c:(.text+0x9f0b8): undefined reference to `uprobe_register'
kernel/built-in.o: In function `trace_uprobe_register':
context_tracking.c:(.text+0x9f134): undefined reference to `uprobe_unregister'
kernel/built-in.o: In function `dup_mmap':
context_tracking.c:(.text.unlikely+0x354): undefined reference to `uprobe_start_dup_mmap'
context_tracking.c:(.text.unlikely+0x380): undefined reference to `uprobe_dup_mmap'
context_tracking.c:(.text.unlikely+0x5e8): undefined reference to `uprobe_end_dup_mmap'
mm/built-in.o: In function `unmap_single_vma':
page_isolation.c:(.text+0x22d10): undefined reference to `uprobe_munmap'
mm/built-in.o: In function `vma_adjust':
page_isolation.c:(.text+0x2748c): undefined reference to `uprobe_munmap'
page_isolation.c:(.text+0x274a0): undefined reference to `uprobe_munmap'
page_isolation.c:(.text+0x27858): undefined reference to `uprobe_mmap'
page_isolation.c:(.text+0x2786c): undefined reference to `uprobe_mmap'
page_isolation.c:(.text+0x2788c): undefined reference to `uprobe_munmap'
page_isolation.c:(.text+0x2790c): undefined reference to `uprobe_mmap'
mm/built-in.o: In function `mmap_region':
page_isolation.c:(.text+0x2963c): undefined reference to `uprobe_mmap'
make[1]: *** [vmlinux] Error 1
make[1]: Target `zImage' not remade because of errors.

So, let's take uprobe_notify_resume().  This is unconditionally referenced
by arch/arm/kernel/signal.c:

                                syscall = 0;
                        } else if (thread_flags & _TIF_UPROBE) {
                                clear_thread_flag(TIF_UPROBE);
                                uprobe_notify_resume(regs);
                        } else {
                                clear_thread_flag(TIF_NOTIFY_RESUME);
                                tracehook_notify_resume(regs);
                        }

and is declared in include/linux/uprobes.h:

	#ifdef CONFIG_UPROBES
	#include <asm/uprobes.h>
	...
	extern void uprobe_notify_resume(struct pt_regs *regs);
	...
	#else /* !CONFIG_UPROBES */
	...
	static inline void uprobe_notify_resume(struct pt_regs *regs)
	{
	}
	...
	#endif /* !CONFIG_UPROBES */

It is defined in kernel/events/uprobes.c:

	kernel/events/uprobes.c:void uprobe_notify_resume(struct pt_regs *regs)

which is built when CONFIG_UPROBES is set:

	obj-$(CONFIG_UPROBES) += uprobes.o

but, the events directory is only built when CONFIG_PERF_EVENTS is also
set:

	obj-$(CONFIG_PERF_EVENTS) += events/

and the failing configuration has:

	# CONFIG_PERF_EVENTS is not set
	CONFIG_UPROBES=y

Clearly, it doesn't make sense for UPROBES to be enabled with PERF_EVENTS
disabled - and indeed the Kconfig ensures that this dependency is properly
expressed:

	config UPROBES
	        bool "Transparent user-space probes (EXPERIMENTAL)"
	        depends on UPROBE_EVENT && PERF_EVENTS
	        default n
	        select PERCPU_RWSEM

but where this all falls down is here:

	config UPROBE_EVENT
	        bool "Enable uprobes-based dynamic events"
	        depends on ARCH_SUPPORTS_UPROBES
	        depends on MMU
	        select UPROBES
	        select PROBE_EVENTS
	        select TRACING
	        default n

Which is yet another brilliant example of why this "select" crap is soo
evil.  Yes, the failing configuration has:

	CONFIG_UPROBE_EVENT=y

Ineed, there was a Kconfig warning:

	warning: (UPROBE_EVENT) selects UPROBES which has unmet direct dependencies (UPROBE_EVENT && PERF_EVENTS)

This is not your fault.  It's the fault of everyone who passed through
commit f3f096cfedf8113380c56fc855275cc75cd8cf55 without properly reviewing
it and paying attention to that select crap.  Given how evil "select" is,
it's something which should always be thoroughly reviewed - with analysis
of the dependencies.  I believe commits which introduce new select
statements should document an analysis of why those new select statements
are appropriate and how they ensure that any dependencies of the selected
symbol are not violated.

Therefore, I will not take the ARM uprobes code while this kind of
select abortion is present - it needs to be fixed first to avoid these
build errors.  Sorry.

-- 
FTTC broadband for 0.8mile line: now at 9.7Mbps down 460kbps up... slowly
improving, and getting towards what was expected from it.
