Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759230AbaD3O4G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 10:56:06 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.228]:6562 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1759185AbaD3O4E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 10:56:04 -0400
Date: Wed, 30 Apr 2014 10:56:02 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Jiri Slaby <jslaby@suse.cz>
Cc: linux-kernel@vger.kernel.org, jirislaby@gmail.com,
        Vojtech Pavlik <vojtech@suse.cz>, Michael Matz <matz@suse.de>,
        Jiri Kosina <jkosina@suse.cz>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: [RFC 03/16] kgr: initial code
Message-ID: <20140430105602.1bed3090@gandalf.local.home>
In-Reply-To: <1398868249-26169-4-git-send-email-jslaby@suse.cz>
References: <1398868249-26169-1-git-send-email-jslaby@suse.cz>
	<1398868249-26169-4-git-send-email-jslaby@suse.cz>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Apr 2014 16:30:36 +0200
Jiri Slaby <jslaby@suse.cz> wrote:

> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> index 25d2c6f7325e..789a4c870ab3 100644
> --- a/arch/x86/Kconfig
> +++ b/arch/x86/Kconfig
> @@ -130,6 +130,7 @@ config X86
>  	select HAVE_CC_STACKPROTECTOR
>  	select GENERIC_CPU_AUTOPROBE
>  	select HAVE_ARCH_AUDITSYSCALL
> +	select HAVE_KGR
>  
>  config INSTRUCTION_DECODER
>  	def_bool y
> @@ -263,6 +264,7 @@ config ARCH_SUPPORTS_UPROBES
>  
>  source "init/Kconfig"
>  source "kernel/Kconfig.freezer"
> +source "kernel/Kconfig.kgr"
>  
>  menu "Processor type and features"
>  
> diff --git a/arch/x86/include/asm/kgr.h b/arch/x86/include/asm/kgr.h
> new file mode 100644
> index 000000000000..172f7b966bb5
> --- /dev/null
> +++ b/arch/x86/include/asm/kgr.h
> @@ -0,0 +1,39 @@
> +#ifndef ASM_KGR_H
> +#define ASM_KGR_H
> +
> +#include <linux/linkage.h>
> +
> +/*
> + * The stub needs to modify the RIP value stored in struct pt_regs
> + * so that ftrace redirects the execution properly.
> + */
> +#define KGR_STUB_ARCH_SLOW(_name, _new_function)			\
> +static void _new_function ##_stub_slow (unsigned long ip, unsigned long parent_ip,	\
> +		struct ftrace_ops *ops, struct pt_regs *regs)		\
> +{									\
> +	struct kgr_loc_caches *c = ops->private;			\
> +									\
> +	if (task_thread_info(current)->kgr_in_progress && current->mm) {\
> +		pr_info("kgr: slow stub: calling old code at %lx\n",	\
> +				c->old);				\
> +		regs->ip = c->old + MCOUNT_INSN_SIZE;			\
> +	} else {							\
> +		pr_info("kgr: slow stub: calling new code at %lx\n",	\
> +				c->new);				\
> +		regs->ip = c->new;					\
> +	}								\
> +}
> +
> +#define KGR_STUB_ARCH_FAST(_name, _new_function)			\
> +static void _new_function ##_stub_fast (unsigned long ip,		\
> +		unsigned long parent_ip, struct ftrace_ops *ops,	\
> +		struct pt_regs *regs)					\
> +{									\
> +	struct kgr_loc_caches *c = ops->private;			\
> +									\
> +	BUG_ON(!c->new);				\
> +	pr_info("kgr: fast stub: calling new code at %lx\n", c->new); \
> +	regs->ip = c->new;				\
> +}
> +
> +#endif
> diff --git a/arch/x86/include/asm/thread_info.h b/arch/x86/include/asm/thread_info.h
> index 47e5de25ba79..1fdc144dcc9c 100644
> --- a/arch/x86/include/asm/thread_info.h
> +++ b/arch/x86/include/asm/thread_info.h
> @@ -35,6 +35,7 @@ struct thread_info {
>  	void __user		*sysenter_return;
>  	unsigned int		sig_on_uaccess_error:1;
>  	unsigned int		uaccess_err:1;	/* uaccess failed */
> +	unsigned short		kgr_in_progress;
>  };
>  
>  #define INIT_THREAD_INFO(tsk)			\
> diff --git a/arch/x86/kernel/asm-offsets.c b/arch/x86/kernel/asm-offsets.c
> index 9f6b9341950f..0db0437967a2 100644
> --- a/arch/x86/kernel/asm-offsets.c
> +++ b/arch/x86/kernel/asm-offsets.c
> @@ -32,6 +32,7 @@ void common(void) {
>  	OFFSET(TI_flags, thread_info, flags);
>  	OFFSET(TI_status, thread_info, status);
>  	OFFSET(TI_addr_limit, thread_info, addr_limit);
> +	OFFSET(TI_kgr_in_progress, thread_info, kgr_in_progress);
>  
>  	BLANK();
>  	OFFSET(crypto_tfm_ctx_offset, crypto_tfm, __crt_ctx);
> diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
> index 1e96c3628bf2..a03b1e9d2de3 100644
> --- a/arch/x86/kernel/entry_64.S
> +++ b/arch/x86/kernel/entry_64.S
> @@ -615,6 +615,7 @@ GLOBAL(system_call_after_swapgs)
>  	movq  %rax,ORIG_RAX-ARGOFFSET(%rsp)
>  	movq  %rcx,RIP-ARGOFFSET(%rsp)
>  	CFI_REL_OFFSET rip,RIP-ARGOFFSET
> +	movw $0, TI_kgr_in_progress+THREAD_INFO(%rsp,RIP-ARGOFFSET)

Why is this not a entry flag? Because you just added a store into a
fast path of the kernel for something that will be hardly ever used.


>  	testl $_TIF_WORK_SYSCALL_ENTRY,TI_flags+THREAD_INFO(%rsp,RIP-ARGOFFSET)
>  	jnz tracesys
>  system_call_fastpath:
> @@ -639,6 +640,7 @@ sysret_check:
>  	LOCKDEP_SYS_EXIT
>  	DISABLE_INTERRUPTS(CLBR_NONE)
>  	TRACE_IRQS_OFF
> +	movw $0, TI_kgr_in_progress+THREAD_INFO(%rsp,RIP-ARGOFFSET)
>  	movl TI_flags+THREAD_INFO(%rsp,RIP-ARGOFFSET),%edx
>  	andl %edi,%edx
>  	jnz  sysret_careful
> @@ -761,6 +763,7 @@ GLOBAL(int_ret_from_sys_call)
>  GLOBAL(int_with_check)
>  	LOCKDEP_SYS_EXIT_IRQ
>  	GET_THREAD_INFO(%rcx)
> +	movw $0, TI_kgr_in_progress(%rcx)
>  	movl TI_flags(%rcx),%edx
>  	andl %edi,%edx
>  	jnz   int_careful
> diff --git a/arch/x86/kernel/x8664_ksyms_64.c b/arch/x86/kernel/x8664_ksyms_64.c
> index 040681928e9d..df6425d44fa0 100644
> --- a/arch/x86/kernel/x8664_ksyms_64.c
> +++ b/arch/x86/kernel/x8664_ksyms_64.c
> @@ -3,6 +3,7 @@
>  
>  #include <linux/module.h>
>  #include <linux/smp.h>
> +#include <linux/kgr.h>
>  
>  #include <net/checksum.h>
>  
> diff --git a/include/linux/kgr.h b/include/linux/kgr.h
> new file mode 100644
> index 000000000000..d72add7f3d5d
> --- /dev/null
> +++ b/include/linux/kgr.h
> @@ -0,0 +1,71 @@
> +#ifndef LINUX_KGR_H
> +#define LINUX_KGR_H
> +
> +#include <linux/init.h>
> +#include <linux/ftrace.h>
> +
> +#include <asm/kgr.h>
> +
> +#ifdef CONFIG_KGR
> +
> +#define KGR_TIMEOUT 30
> +#define KGR_DEBUG 1
> +
> +#ifdef KGR_DEBUG
> +#define kgr_debug(args...)	\
> +	pr_info(args);
> +#else
> +#define kgr_debug(args...) { }
> +#endif

Why not just use pr_debug(), as that's not defined unless you add DEBUG
as a define anyway?

-- Steve

> +
> +struct kgr_patch {
> +	char reserved;
> +	const struct kgr_patch_fun {
> +		const char *name;
> +		const char *new_name;
> +		void *new_function;
> +		struct ftrace_ops *ftrace_ops_slow;
> +		struct ftrace_ops *ftrace_ops_fast;
> +
> +	} *patches[];
> +};
> +
> +/*
