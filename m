Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161247AbaJ3RAQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 13:00:16 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.228]:4038 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758161AbaJ3RAN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 13:00:13 -0400
Date: Thu, 30 Oct 2014 13:00:09 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Jiri Kosina <jkosina@suse.cz>, Josh Poimboeuf <jpoimboe@redhat.com>,
        Vojtech Pavlik <vojtech@suse.cz>, Seth Jennings <sjenning@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [for-next][PATCH 1/4] ftrace/x86: Add dynamic allocated
 trampoline for ftrace_ops
Message-ID: <20141030130009.7b8b2730@gandalf.local.home>
In-Reply-To: <20141027182948.284867581@goodmis.org>
References: <20141027182702.778680710@goodmis.org>
	<20141027182948.284867581@goodmis.org>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


H. Peter,

Can you give me your acked-by for this.

Thanks!

-- Steve


On Mon, 27 Oct 2014 14:27:03 -0400
Steven Rostedt <rostedt@goodmis.org> wrote:

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
>  arch/x86/kernel/ftrace.c    | 195 ++++++++++++++++++++++++++++++++++++++++++--
>  arch/x86/kernel/mcount_64.S |  25 +++++-
>  include/linux/ftrace.h      |   8 ++
>  kernel/trace/ftrace.c       |  40 ++++++++-
>  4 files changed, 254 insertions(+), 14 deletions(-)
> 
> diff --git a/arch/x86/kernel/ftrace.c b/arch/x86/kernel/ftrace.c
> index 3386dc9aa333..e4d48f6cad86 100644
> --- a/arch/x86/kernel/ftrace.c
> +++ b/arch/x86/kernel/ftrace.c
> @@ -17,6 +17,7 @@
>  #include <linux/ftrace.h>
>  #include <linux/percpu.h>
>  #include <linux/sched.h>
> +#include <linux/slab.h>
>  #include <linux/init.h>
>  #include <linux/list.h>
>  #include <linux/module.h>
> @@ -644,13 +645,8 @@ int __init ftrace_dyn_arch_init(void)
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
> +#if defined(CONFIG_X86_64) || defined(CONFIG_FUNCTION_GRAPH_TRACER)
>  static unsigned char *ftrace_jmp_replace(unsigned long ip, unsigned long addr)
>  {
>  	static union ftrace_code_union calc;
> @@ -664,6 +660,193 @@ static unsigned char *ftrace_jmp_replace(unsigned long ip, unsigned long addr)
>  	 */
>  	return calc.code;
>  }
> +#endif
> +
> +/* Currently only x86_64 supports dynamic trampolines */
> +#ifdef CONFIG_X86_64
> +
> +#ifdef CONFIG_MODULES
> +#include <linux/moduleloader.h>
> +/* Module allocation simplifies allocating memory for code */
> +static inline void *alloc_tramp(unsigned long size)
> +{
> +	return module_alloc(size);
> +}
> +static inline void tramp_free(void *tramp)
> +{
> +	module_free(NULL, tramp);
> +}
> +#else
> +/* Trampolines can only be created if modules are supported */
> +static inline void *alloc_tramp(unsigned long size)
> +{
> +	return NULL;
> +}
> +static inline void tramp_free(void *tramp) { }
> +#endif
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
> + * The ftrace_ops is passed to the function callback. Since the
> + * trampoline only services a single ftrace_ops, we can pass in
> + * that ops directly.
> + *
> + * The ftrace_op_code_union is used to create a pointer to the
> + * ftrace_ops that will be passed to the callback function.
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
> +	/* 48 8b 15 <offset> is movq <offset>(%rip), %rdx */
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
> +	/*
> +	 * Allocate enough size to store the ftrace_caller code,
> +	 * the jmp to ftrace_return, as well as the address of
> +	 * the ftrace_ops this trampoline is used for.
> +	 */
> +	trampoline = alloc_tramp(size + MCOUNT_INSN_SIZE + sizeof(void *));
> +	if (!trampoline)
> +		return 0;
> +
> +	/* Copy ftrace_caller onto the trampoline memory */
> +	ret = probe_kernel_read(trampoline, (void *)start_offset, size);
> +	if (WARN_ON(ret < 0)) {
> +		tramp_free(trampoline);
> +		return 0;
> +	}
> +
> +	ip = (unsigned long)trampoline + size;
> +
> +	/* The trampoline ends with a jmp to ftrace_return */
> +	jmp = ftrace_jmp_replace(ip, (unsigned long)ftrace_return);
> +	memcpy(trampoline + size, jmp, MCOUNT_INSN_SIZE);
> +
> +	/*
> +	 * The address of the ftrace_ops that is used for this trampoline
> +	 * is stored at the end of the trampoline. This will be used to
> +	 * load the third parameter for the callback. Basically, that
> +	 * location at the end of the trampoline takes the place of
> +	 * the global function_trace_op variable.
> +	 */
> +
> +	ptr = (unsigned long *)(trampoline + size + MCOUNT_INSN_SIZE);
> +	*ptr = (unsigned long)ops;
> +
> +	op_offset -= start_offset;
> +	memcpy(&op_ptr, trampoline + op_offset, OP_REF_SIZE);
> +
> +	/* Are we pointing to the reference? */
> +	if (WARN_ON(memcmp(op_ptr.op, op_ref, 3) != 0)) {
> +		tramp_free(trampoline);
> +		return 0;
> +	}
> +
> +	/* Load the contents of ptr into the callback parameter */
> +	offset = (unsigned long)ptr;
> +	offset -= (unsigned long)trampoline + op_offset + OP_REF_SIZE;
> +
> +	op_ptr.offset = offset;
> +
> +	/* put in the new offset to the ftrace_ops */
> +	memcpy(trampoline + op_offset, &op_ptr, OP_REF_SIZE);
> +
> +	/* ALLOC_TRAMP flags lets us know we created it */
> +	ops->flags |= FTRACE_OPS_FL_ALLOC_TRAMP;
> +
> +	return (unsigned long)trampoline;
> +}
> +
> +void arch_ftrace_update_trampoline(struct ftrace_ops *ops)
> +{
> +	ftrace_func_t func;
> +	unsigned char *new;
> +	unsigned long start_offset;
> +	unsigned long call_offset;
> +	unsigned long offset;
> +	unsigned long ip;
> +	int ret;
> +
> +	if (ops->trampoline) {
> +		/*
> +		 * The ftrace_ops caller may set up its own trampoline.
> +		 * In such a case, this code must not modify it.
> +		 */
> +		if (!(ops->flags & FTRACE_OPS_FL_ALLOC_TRAMP))
> +			return;
> +	} else {
> +		ops->trampoline = create_trampoline(ops);
> +		if (!ops->trampoline)
> +			return;
> +	}
> +
> +	if (ops->flags & FTRACE_OPS_FL_SAVE_REGS) {
> +		start_offset = (unsigned long)ftrace_regs_caller;
> +		call_offset = (unsigned long)ftrace_regs_call;
> +	} else {
> +		start_offset = (unsigned long)ftrace_caller;
> +		call_offset = (unsigned long)ftrace_call;
> +	}
> +
> +	offset = call_offset - start_offset;
> +	ip = ops->trampoline + offset;
> +
> +	func = ftrace_ops_get_func(ops);
> +
> +	/* Do a safe modify in case the trampoline is executing */
> +	new = ftrace_call_replace(ip, (unsigned long)func);
> +	ret = update_ftrace_func(ip, new);
> +
> +	/* The update should never fail */
> +	WARN_ON(ret);
> +}
> +#endif /* CONFIG_X86_64 */
> +#endif /* CONFIG_DYNAMIC_FTRACE */
> +
> +#ifdef CONFIG_FUNCTION_GRAPH_TRACER
> +
> +#ifdef CONFIG_DYNAMIC_FTRACE
> +extern void ftrace_graph_call(void);
>  
>  static int ftrace_mod_jmp(unsigned long ip, void *func)
>  {
> diff --git a/arch/x86/kernel/mcount_64.S b/arch/x86/kernel/mcount_64.S
> index c73aecf10d34..42f0cdd20baf 100644
> --- a/arch/x86/kernel/mcount_64.S
> +++ b/arch/x86/kernel/mcount_64.S
> @@ -28,9 +28,11 @@ ENTRY(function_hook)
>  END(function_hook)
>  
>  /* skip is set if stack has been adjusted */
> -.macro ftrace_caller_setup skip=0
> +.macro ftrace_caller_setup trace_label skip=0
>  	MCOUNT_SAVE_FRAME \skip
>  
> +	/* Save this location */
> +GLOBAL(\trace_label)
>  	/* Load the ftrace_ops into the 3rd parameter */
>  	movq function_trace_op(%rip), %rdx
>  
> @@ -46,7 +48,7 @@ END(function_hook)
>  .endm
>  
>  ENTRY(ftrace_caller)
> -	ftrace_caller_setup
> +	ftrace_caller_setup ftrace_caller_op_ptr
>  	/* regs go into 4th parameter (but make it NULL) */
>  	movq $0, %rcx
>  
> @@ -54,7 +56,14 @@ GLOBAL(ftrace_call)
>  	call ftrace_stub
>  
>  	MCOUNT_RESTORE_FRAME
> -ftrace_return:
> +
> +	/*
> +	 * The copied trampoline must call ftrace_return as it
> +	 * still may need to call the function graph tracer.
> +	 */
> +GLOBAL(ftrace_caller_end)
> +
> +GLOBAL(ftrace_return)
>  
>  #ifdef CONFIG_FUNCTION_GRAPH_TRACER
>  GLOBAL(ftrace_graph_call)
> @@ -70,7 +79,7 @@ ENTRY(ftrace_regs_caller)
>  	pushfq
>  
>  	/* skip=8 to skip flags saved in SS */
> -	ftrace_caller_setup 8
> +	ftrace_caller_setup ftrace_regs_caller_op_ptr 8
>  
>  	/* Save the rest of pt_regs */
>  	movq %r15, R15(%rsp)
> @@ -122,6 +131,14 @@ GLOBAL(ftrace_regs_call)
>  	/* Restore flags */
>  	popfq
>  
> +	/*
> +	 * As this jmp to ftrace_return can be a short jump
> +	 * it must not be copied into the trampoline.
> +	 * The trampoline will add the code to jump
> +	 * to the return.
> +	 */
> +GLOBAL(ftrace_regs_caller_end)
> +
>  	jmp ftrace_return
>  
>  	popfq
> diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
> index 662697babd48..06e3ca5a5083 100644
> --- a/include/linux/ftrace.h
> +++ b/include/linux/ftrace.h
> @@ -94,6 +94,13 @@ ftrace_func_t ftrace_ops_get_func(struct ftrace_ops *ops);
>   * ADDING  - The ops is in the process of being added.
>   * REMOVING - The ops is in the process of being removed.
>   * MODIFYING - The ops is in the process of changing its filter functions.
> + * ALLOC_TRAMP - A dynamic trampoline was allocated by the core code.
> + *            The arch specific code sets this flag when it allocated a
> + *            trampoline. This lets the arch know that it can update the
> + *            trampoline in case the callback function changes.
> + *            The ftrace_ops trampoline can be set by the ftrace users, and
> + *            in such cases the arch must not modify it. Only the arch ftrace
> + *            core code should set this flag.
>   */
>  enum {
>  	FTRACE_OPS_FL_ENABLED			= 1 << 0,
> @@ -108,6 +115,7 @@ enum {
>  	FTRACE_OPS_FL_ADDING			= 1 << 9,
>  	FTRACE_OPS_FL_REMOVING			= 1 << 10,
>  	FTRACE_OPS_FL_MODIFYING			= 1 << 11,
> +	FTRACE_OPS_FL_ALLOC_TRAMP		= 1 << 12,
>  };
>  
>  #ifdef CONFIG_DYNAMIC_FTRACE
> diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
> index 31c90fec4158..15f85eac7e95 100644
> --- a/kernel/trace/ftrace.c
> +++ b/kernel/trace/ftrace.c
> @@ -387,6 +387,8 @@ static int remove_ftrace_list_ops(struct ftrace_ops **list,
>  	return ret;
>  }
>  
> +static void ftrace_update_trampoline(struct ftrace_ops *ops);
> +
>  static int __register_ftrace_function(struct ftrace_ops *ops)
>  {
>  	if (ops->flags & FTRACE_OPS_FL_DELETED)
> @@ -419,6 +421,8 @@ static int __register_ftrace_function(struct ftrace_ops *ops)
>  	} else
>  		add_ftrace_ops(&ftrace_ops_list, ops);
>  
> +	ftrace_update_trampoline(ops);
> +
>  	if (ftrace_enabled)
>  		update_ftrace_function();
>  
> @@ -3020,9 +3024,6 @@ ftrace_enabled_open(struct inode *inode, struct file *file)
>  {
>  	struct ftrace_iterator *iter;
>  
> -	if (unlikely(ftrace_disabled))
> -		return -ENODEV;
> -
>  	iter = __seq_open_private(file, &show_ftrace_seq_ops, sizeof(*iter));
>  	if (iter) {
>  		iter->pg = ftrace_pages_start;
> @@ -3975,6 +3976,9 @@ static char ftrace_graph_buf[FTRACE_FILTER_SIZE] __initdata;
>  static char ftrace_graph_notrace_buf[FTRACE_FILTER_SIZE] __initdata;
>  static int ftrace_set_func(unsigned long *array, int *idx, int size, char *buffer);
>  
> +static unsigned long save_global_trampoline;
> +static unsigned long save_global_flags;
> +
>  static int __init set_graph_function(char *str)
>  {
>  	strlcpy(ftrace_graph_buf, str, FTRACE_FILTER_SIZE);
> @@ -4696,6 +4700,20 @@ void __init ftrace_init(void)
>  	ftrace_disabled = 1;
>  }
>  
> +/* Do nothing if arch does not support this */
> +void __weak arch_ftrace_update_trampoline(struct ftrace_ops *ops)
> +{
> +}
> +
> +static void ftrace_update_trampoline(struct ftrace_ops *ops)
> +{
> +	/* Currently, only non dynamic ops can have a trampoline */
> +	if (ops->flags & FTRACE_OPS_FL_DYNAMIC)
> +		return;
> +
> +	arch_ftrace_update_trampoline(ops);
> +}
> +
>  #else
>  
>  static struct ftrace_ops global_ops = {
> @@ -4738,6 +4756,10 @@ ftrace_ops_test(struct ftrace_ops *ops, unsigned long ip, void *regs)
>  	return 1;
>  }
>  
> +static void ftrace_update_trampoline(struct ftrace_ops *ops)
> +{
> +}
> +
>  #endif /* CONFIG_DYNAMIC_FTRACE */
>  
>  __init void ftrace_init_global_array_ops(struct trace_array *tr)
> @@ -5522,7 +5544,6 @@ int register_ftrace_graph(trace_func_graph_ret_t retfunc,
>  	update_function_graph_func();
>  
>  	ret = ftrace_startup(&graph_ops, FTRACE_START_FUNC_RET);
> -
>  out:
>  	mutex_unlock(&ftrace_lock);
>  	return ret;
> @@ -5543,6 +5564,17 @@ void unregister_ftrace_graph(void)
>  	unregister_pm_notifier(&ftrace_suspend_notifier);
>  	unregister_trace_sched_switch(ftrace_graph_probe_sched_switch, NULL);
>  
> +#ifdef CONFIG_DYNAMIC_FTRACE
> +	/*
> +	 * Function graph does not allocate the trampoline, but
> +	 * other global_ops do. We need to reset the ALLOC_TRAMP flag
> +	 * if one was used.
> +	 */
> +	global_ops.trampoline = save_global_trampoline;
> +	if (save_global_flags & FTRACE_OPS_FL_ALLOC_TRAMP)
> +		global_ops.flags |= FTRACE_OPS_FL_ALLOC_TRAMP;
> +#endif
> +
>   out:
>  	mutex_unlock(&ftrace_lock);
>  }

