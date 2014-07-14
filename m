Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752606AbaGNCfB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2014 22:35:01 -0400
Received: from mail4.hitachi.co.jp ([133.145.228.5]:46223 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752466AbaGNCex (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2014 22:34:53 -0400
Message-ID: <53C341C4.1060201@hitachi.com>
Date: Mon, 14 Jul 2014 11:34:44 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Namhyung Kim <namhyung@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Oleg Nesterov <oleg@redhat.com>, Josh Poimboeuf <jpoimboe@redhat.com>,
        Jiri Kosina <jkosina@suse.cz>, Seth Jennings <sjenning@redhat.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: Re: [RFC][PATCH 1/3] ftrace/x86: Add dynamic allocated trampoline
 for ftrace_ops
References: <20140703200750.648550267@goodmis.org> <20140703202324.832135644@goodmis.org>
In-Reply-To: <20140703202324.832135644@goodmis.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/07/04 5:07), Steven Rostedt wrote:
> From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>
> 
> The current method of handling multiple function callbacks is to register
> a list function callback that calls all the other callbacks based on
> their hash tables and compare it to the function that the callback was
> called on. But this is very inefficient.
> 
> For example, if you are tracing all functions in the kernel and then
> add a kprobe to a function such that the kprobe uses ftrace, the
> mcount trampoline will switch from calling the function trace callback
> to calling the list callback that will iterate over all registered
> ftrace_ops (in this case, the function tracer and the kprobes callback).
> That means for every function being traced it checks the hash of the
> ftrace_ops for function tracing and kprobes, even though the kprobes
> is only set at a single function. The kprobes ftrace_ops is checked
> for every function being traced!
> 
> Instead of calling the list function for functions that are only being
> traced by a single callback, we can call a dynamically allocated
> trampoline that calls the callback directly. The function graph tracer
> already uses a direct call trampoline when it is being traced by itself
> but it is not dynamically allocated. It's trampoline is static in the
> kernel core. The infrastructure that called the function graph trampoline
> can also be used to call a dynamically allocated one.
> 
> For now, only ftrace_ops that are not dynamically allocated can have
> a trampoline. That is, users such as function tracer or stack tracer.
> kprobes and perf allocate their ftrace_ops, and until there's a safe
> way to free the trampoline, it can not be used. The dynamically allocated
> ftrace_ops may, although, use the trampoline if the kernel is not
> compiled with CONFIG_PREEMPT. But that will come later.
> 
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> ---
>  arch/x86/kernel/ftrace.c    | 157 ++++++++++++++++++++++++++++++++++++++++++--
>  arch/x86/kernel/mcount_64.S |  26 ++++++--
>  include/linux/ftrace.h      |   8 +++
>  kernel/trace/ftrace.c       |  46 ++++++++++++-
>  4 files changed, 224 insertions(+), 13 deletions(-)
> 
> diff --git a/arch/x86/kernel/ftrace.c b/arch/x86/kernel/ftrace.c
> index 3386dc9aa333..fcc256a33c1d 100644
> --- a/arch/x86/kernel/ftrace.c
> +++ b/arch/x86/kernel/ftrace.c
> @@ -17,9 +17,11 @@
>  #include <linux/ftrace.h>
>  #include <linux/percpu.h>
>  #include <linux/sched.h>
> +#include <linux/slab.h>
>  #include <linux/init.h>
>  #include <linux/list.h>
>  #include <linux/module.h>
> +#include <linux/moduleloader.h>
>  
>  #include <trace/syscall.h>
>  
> @@ -644,12 +646,6 @@ int __init ftrace_dyn_arch_init(void)
>  {
>  	return 0;
>  }
> -#endif
> -
> -#ifdef CONFIG_FUNCTION_GRAPH_TRACER
> -
> -#ifdef CONFIG_DYNAMIC_FTRACE
> -extern void ftrace_graph_call(void);
>  
>  static unsigned char *ftrace_jmp_replace(unsigned long ip, unsigned long addr)
>  {
> @@ -665,6 +661,155 @@ static unsigned char *ftrace_jmp_replace(unsigned long ip, unsigned long addr)
>  	return calc.code;
>  }
>  
> +/* Currently only x86_64 supports dynamic trampolines */
> +#ifdef CONFIG_X86_64
> +
> +/* Defined as markers to the end of the ftrace default trampolines */
> +extern void ftrace_caller_end(void);
> +extern void ftrace_regs_caller_end(void);
> +extern void ftrace_return(void);
> +extern void ftrace_caller_op_ptr(void);
> +extern void ftrace_regs_caller_op_ptr(void);
> +
> +/* movq function_trace_op(%rip), %rdx */
> +/* 0x48 0x8b 0x15 <offset-to-ftrace_trace_op (4 bytes)> */
> +#define OP_REF_SIZE	7
> +
> +/*
> + * The ftrace_ops is passed to the function, we can pass
> + * in the ops directly as this trampoline will only call
> + * a function for a single ops.
> + */
> +union ftrace_op_code_union {
> +	char code[OP_REF_SIZE];
> +	struct {
> +		char op[3];
> +		int offset;
> +	} __attribute__((packed));
> +};
> +
> +static unsigned long create_trampoline(struct ftrace_ops *ops)
> +{
> +	unsigned const char *jmp;
> +	unsigned long start_offset;
> +	unsigned long end_offset;
> +	unsigned long op_offset;
> +	unsigned long offset;
> +	unsigned long size;
> +	unsigned long ip;
> +	unsigned long *ptr;
> +	void *trampoline;
> +	unsigned const char op_ref[] = { 0x48, 0x8b, 0x15 };
> +	union ftrace_op_code_union op_ptr;
> +	int ret;
> +
> +	if (ops->flags & FTRACE_OPS_FL_SAVE_REGS) {
> +		start_offset = (unsigned long)ftrace_regs_caller;
> +		end_offset = (unsigned long)ftrace_regs_caller_end;
> +		op_offset = (unsigned long)ftrace_regs_caller_op_ptr;
> +	} else {
> +		start_offset = (unsigned long)ftrace_caller;
> +		end_offset = (unsigned long)ftrace_caller_end;
> +		op_offset = (unsigned long)ftrace_caller_op_ptr;
> +	}
> +
> +	size = end_offset - start_offset;
> +
> +	trampoline = module_alloc(size + MCOUNT_INSN_SIZE + sizeof(void *));

Here, since module_alloc always allocates pages like vmalloc, this wastes most
of the memory area in the page. (e.g. ftrace_regs_caller needs less than 0x150
bytes on x86_64 as below)

ffffffff8156ec00 T ftrace_regs_caller
ffffffff8156eccd T ftrace_regs_call
ffffffff8156ed44 t ftrace_restore_flags
ffffffff8156ed50 T ftrace_graph_caller

kprobes has its own insn_slot which allocates a small amount of executable memory
for each kprobe. Perhaps, we can make a generic trampoline mechanism for both, or
just share the insn_slot with ftrace.

Thank you,


-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Research Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


