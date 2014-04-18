Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752069AbaDRIfT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 04:35:19 -0400
Received: from mail-ee0-f50.google.com ([74.125.83.50]:35466 "EHLO
	mail-ee0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751159AbaDRIfP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 04:35:15 -0400
Date: Fri, 18 Apr 2014 10:35:10 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <aarapov@redhat.com>, David Long <dave.long@linaro.org>,
        Denys Vlasenko <dvlasenk@redhat.com>,
        "Frank Ch. Eigler" <fche@redhat.com>,
        Jim Keniston <jkenisto@us.ibm.com>, Jonathan Lebon <jlebon@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] uprobes: fix the handling of relative jmp/call's
Message-ID: <20140418083510.GA19006@gmail.com>
References: <20140417200228.GA31097@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140417200228.GA31097@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Oleg Nesterov <oleg@redhat.com> wrote:

> Ingo, please pull from
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/oleg/misc uprobes/core
> 
> 
> To remind, we have a serious bug. Any probed jmp/call can kill the
> application, see the changelog in 11/15.
> 
> I tried to test this as much as possible, seems to work. I also wrote
> the test-case which explicitly checks every conditional jump with all
> possible bits combinations in eflags:
> 
> 	#include <asm/processor-flags.h>
> 	#include <stdio.h>
> 
> 	static int nojmp;
> 
> 	#define __MK_FUNC(opc, name)				\
> 		asm (						\
> 			".text\n"				\
> 			".globl " #name "; " #name ":\n"	\
> 			".byte 0x" #opc "\n"			\
> 			".byte 0x0a \n"	/* offs to 1f below */	\
> 			"movl $1, nojmp(%rip)\n"		\
> 			"1: ret\n"				\
> 		);						\
> 
> 	#define MK_FUNC(opc)	__MK_FUNC(opc, probe_func_ ## opc)
> 
> 	MK_FUNC(70) MK_FUNC(71) MK_FUNC(72) MK_FUNC(73)
> 	MK_FUNC(74) MK_FUNC(75) MK_FUNC(76) MK_FUNC(77)
> 	MK_FUNC(78) MK_FUNC(79) MK_FUNC(7a) MK_FUNC(7b)
> 	MK_FUNC(7c) MK_FUNC(7d) MK_FUNC(7e) MK_FUNC(7f)
> 
> 
> 	#define __CALL(flags, func)	\
> 		asm volatile ("pushf; push %0; popf; call " #func "; popf"	\
> 				: : "m" (flags) : "memory");
> 
> 	#define CALL(opc)		\
> 	({						\
> 		nojmp = 0;				\
> 		__CALL(flags, probe_func_ ## opc);	\
> 		!nojmp;					\
> 	})
> 
> 	long test_flags(unsigned long flags)
> 	{
> 		printf("%04lx %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d\n",
> 			flags,
> 			CALL(70), CALL(71), CALL(72), CALL(73),
> 			CALL(74), CALL(75), CALL(76), CALL(77),
> 			CALL(78), CALL(79), CALL(7a), CALL(7b),
> 			CALL(7c), CALL(7d), CALL(7e), CALL(7f));
> 
> 		return 0;
> 	}
> 
> 	#define XF(xf)		(X86_EFLAGS_ ## xf)
> 	#define XF_MASK		(XF(CF) | XF(OF) | XF(PF) | XF(SF) | XF(ZF))
> 
> 	int main(void)
> 	{
> 		unsigned int bits;
> 		unsigned long __flags, flags;
> 
> 		asm volatile("pushf; pop %0" : "=rm" (__flags) : : "memory");
> 
> 		for (bits = 0; bits < (1 << 5); bits++) {
> 			flags = __flags & ~XF_MASK;
> 
> 			#define	CPY_BIT(nr, xf) \
> 				if (bits & (1 << nr)) flags |= XF(xf)
> 
> 			CPY_BIT(0, CF);
> 			CPY_BIT(1, OF);
> 			CPY_BIT(2, PF);
> 			CPY_BIT(3, SF);
> 			CPY_BIT(4, ZF);
> 
> 			test_flags(flags);
> 		}
> 
> 		return 0;
> 	}
> 
> The output is the same with probe_func_70..probe_func_7f probed.
> 
> This series only fixes the problem. I'll send more changes to address
> some of TODO's mentioned in the changelogs later. In particular, we
> need to do something with "callw", see "Note: in 13/15.
> 
> Oleg Nesterov (15):
>       uprobes: Kill UPROBE_SKIP_SSTEP and can_skip_sstep()
>       uprobes/x86: Fold prepare_fixups() into arch_uprobe_analyze_insn()
>       uprobes/x86: Kill the "ia32_compat" check in handle_riprel_insn(), remove "mm" arg
>       uprobes/x86: Gather "riprel" functions together
>       uprobes/x86: move the UPROBE_FIX_{RIP,IP,CALL} code at the end of pre/post hooks
>       uprobes/x86: Introduce uprobe_xol_ops and arch_uprobe->ops
>       uprobes/x86: Conditionalize the usage of handle_riprel_insn()
>       uprobes/x86: Send SIGILL if arch_uprobe_post_xol() fails
>       uprobes/x86: Teach arch_uprobe_post_xol() to restart if possible
>       uprobes/x86: Introduce sizeof_long(), cleanup adjust_ret_addr() and arch_uretprobe_hijack_return_addr()
>       uprobes/x86: Emulate unconditional relative jmp's
>       uprobes/x86: Emulate nop's using ops->emulate()
>       uprobes/x86: Emulate relative call's
>       uprobes/x86: Emulate relative conditional "short" jmp's
>       uprobes/x86: Emulate relative conditional "near" jmp's
> 
>  arch/x86/include/asm/uprobes.h |   16 +-
>  arch/x86/kernel/uprobes.c      |  551 +++++++++++++++++++++++++---------------
>  kernel/events/uprobes.c        |   31 +--
>  3 files changed, 372 insertions(+), 226 deletions(-)

Pulled into tip:perf/core, thanks a lot Oleg!

	Ingo
