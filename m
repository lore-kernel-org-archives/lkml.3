Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755879Ab3GUQVV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Jul 2013 12:21:21 -0400
Received: from mga03.intel.com ([143.182.124.21]:20655 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755758Ab3GUQVU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Jul 2013 12:21:20 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,713,1367996400"; 
   d="scan'208";a="368725258"
Date: Mon, 22 Jul 2013 00:21:13 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: "H. Peter Anvin" <hpa@zytor.com>, "H. Peter Anvin" <hpa@linux.intel.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [x86] Kernel panic - not syncing: Fatal exception in interrupt
Message-ID: <20130721162113.GA5014@localhost>
References: <20130720131226.GA13893@localhost>
 <51EB29FD.60508@zytor.com>
 <alpine.LNX.2.00.1307211004100.31632@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1307211004100.31632@pobox.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jiri,

> Fengguang, as I am not able to reproduce this bug locally, could you do me 
> a favor and test whether the patch below works the problem around, just 
> for the sake of testing the hypothesis?

Sure. I just created a branch with this patch on top of the first bad
commit, and queued the branch for boot tests.

Thanks,
Fengguang

> From: Jiri Kosina <jkosina@suse.cz>
> Subject: [PATCH] x86: call out into int3 handler directly instead of using notifier
> 
> ---
>  arch/x86/include/asm/alternative.h |    2 ++
>  arch/x86/kernel/alternative.c      |   22 +++++++++++++++++++++-
>  arch/x86/kernel/traps.c            |    4 ++++
>  3 files changed, 27 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/x86/include/asm/alternative.h b/arch/x86/include/asm/alternative.h
> index 3abf8dd..c22a41d 100644
> --- a/arch/x86/include/asm/alternative.h
> +++ b/arch/x86/include/asm/alternative.h
> @@ -5,6 +5,7 @@
>  #include <linux/stddef.h>
>  #include <linux/stringify.h>
>  #include <asm/asm.h>
> +#include <asm/ptrace.h>
>  
>  /*
>   * Alternative inline assembly for SMP.
> @@ -232,6 +233,7 @@ struct text_poke_param {
>  	size_t len;
>  };
>  
> +extern int poke_bp_int3_handler(struct pt_regs *regs);
>  extern void *text_poke(void *addr, const void *opcode, size_t len);
>  extern void *text_poke_bp(void *addr, const void *opcode, size_t len, void *handler);
>  extern void *text_poke_smp(void *addr, const void *opcode, size_t len);
> diff --git a/arch/x86/kernel/alternative.c b/arch/x86/kernel/alternative.c
> index 0ab4936..e1088f2 100644
> --- a/arch/x86/kernel/alternative.c
> +++ b/arch/x86/kernel/alternative.c
> @@ -605,6 +605,24 @@ static void do_sync_core(void *info)
>  static bool bp_patching_in_progress;
>  static void *bp_int3_handler, *bp_int3_addr;
>  
> +int poke_bp_int3_handler(struct pt_regs *regs)
> +{
> +	/* bp_patching_in_progress */
> +	smp_rmb();
> +
> +	if (likely(!bp_patching_in_progress))
> +		return 0;
> +
> +	if (user_mode_vm(regs) || regs->ip != (unsigned long)bp_int3_addr)
> +		return 0;
> +
> +	/* set up the specified breakpoint handler */
> +	regs->ip = (unsigned long) bp_int3_handler;
> +
> +	return 1;
> +
> +}
> +
>  static int int3_notify(struct notifier_block *self, unsigned long val, void *data)
>  {
>  	struct die_args *args = data;
> @@ -689,6 +707,7 @@ void *text_poke_bp(void *addr, const void *opcode, size_t len, void *handler)
>  	return addr;
>  }
>  
> +#if 0
>  /* this one needs to run before anything else handles it as a
>   * regular exception */
>  static struct notifier_block int3_nb = {
> @@ -700,8 +719,9 @@ static int __init int3_init(void)
>  {
>  	return register_die_notifier(&int3_nb);
>  }
> -
>  arch_initcall(int3_init);
> +#endif
> +
>  /*
>   * Cross-modifying kernel text with stop_machine().
>   * This code originally comes from immediate value.
> diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
> index 772e2a8..e464764 100644
> --- a/arch/x86/kernel/traps.c
> +++ b/arch/x86/kernel/traps.c
> @@ -58,6 +58,7 @@
>  #include <asm/mce.h>
>  #include <asm/fixmap.h>
>  #include <asm/mach_traps.h>
> +#include <asm/alternative.h>
>  
>  #ifdef CONFIG_X86_64
>  #include <asm/x86_init.h>
> @@ -324,6 +325,9 @@ dotraplinkage void __kprobes notrace do_int3(struct pt_regs *regs, long error_co
>  	    ftrace_int3_handler(regs))
>  		return;
>  #endif
> +	if (poke_bp_int3_handler(regs))
> +		return;
> +
>  	prev_state = exception_enter();
>  #ifdef CONFIG_KGDB_LOW_LEVEL_TRAP
>  	if (kgdb_ll_trap(DIE_INT3, "int3", regs, error_code, X86_TRAP_BP,
> 
> -- 
> Jiri Kosina
> SUSE Labs
