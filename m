Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755628Ab3H3Nxb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Aug 2013 09:53:31 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:32358 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752329Ab3H3Nxa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Aug 2013 09:53:30 -0400
X-Authority-Analysis: v=2.0 cv=fJG7LOme c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=LejNgpe0rVIA:10 a=5SG0PmZfjMsA:10 a=kj9zAlcOel0A:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=Mis5YI5z8AYA:10 a=20KFwNOVAAAA:8 a=VnNF1IyMAAAA:8 a=35CZl5Ya33idUAynvngA:9 a=CjuIK1q_8ugA:10 a=jeBq3FmKZ4MA:10 a=jEp0ucaQiEUA:10 a=mXFEB-vdxMvAMOTi:21 a=F7c_RORtTihrzh7V:21 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Date: Fri, 30 Aug 2013 09:53:28 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Jiri Olsa <jolsa@redhat.com>, Dave Jones <davej@redhat.com>
Subject: Re: [RFC][PATCH 1/8] ftrace: Add hash list to save RCU unsafe
 functions
Message-ID: <20130830095328.3976e332@gandalf.local.home>
In-Reply-To: <20130830132403.955140954@goodmis.org>
References: <20130830130205.504335754@goodmis.org>
	<20130830132403.955140954@goodmis.org>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 30 Aug 2013 09:02:06 -0400
Steven Rostedt <rostedt@goodmis.org> wrote:

> From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>
> 
> Some ftrace function tracing callbacks use RCU (perf), thus if
> it gets called from tracing a function outside of the RCU tracking,
> like in entering or leaving NO_HZ idle/userspace, the RCU read locks
> in the callback are useless.
> 
> As normal function tracing does not use RCU, and function tracing
> happens to help debug RCU, we do not want to limit all callbacks
> from tracing these "unsafe" RCU functions. Instead, we create an
> infrastructure that will let us mark these unsafe RCU functions
> and we will only allow callbacks that explicitly say they do not
> use RCU to be called by these functions.
> 
> This patch adds the infrastructure to create the hash of functions
> that are RCU unsafe. This is done with the FTRACE_UNSAFE_RCU()
> macro. It works like EXPORT_SYMBOL() does. Simply place the macro
> under the RCU unsafe function:
> 
> void func(void)
> {
> 	[...]
> }
> FTRACE_UNSAFE_RCU(func);
> 
> Cc: Jiri Olsa <jolsa@redhat.com>
> Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

I need to add:

Reported-by: Dave Jones <davej@redhat.com>

-- Steve

> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> ---
>  include/asm-generic/vmlinux.lds.h |   10 ++++
>  include/linux/ftrace.h            |   38 ++++++++++++++
>  kernel/trace/ftrace.c             |  105 +++++++++++++++++++++++++++++++++++++
>  3 files changed, 153 insertions(+)
> 
> diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
> index 69732d2..fdfddd2 100644
> --- a/include/asm-generic/vmlinux.lds.h
> +++ b/include/asm-generic/vmlinux.lds.h
> @@ -93,6 +93,15 @@
>  #define MCOUNT_REC()
>  #endif
>  
> +#ifdef CONFIG_FUNCTION_TRACER
> +#define FTRACE_UNSAFE_RCU()	. = ALIGN(8);				\
> +			VMLINUX_SYMBOL(__start_ftrace_unsafe_rcu) = .;	\
> +			*(_ftrace_unsafe_rcu)				\
> +			VMLINUX_SYMBOL(__stop_ftrace_unsafe_rcu) = .;
> +#else
> +#define FTRACE_UNSAFE_RCU()
> +#endif
> +
>  #ifdef CONFIG_TRACE_BRANCH_PROFILING
>  #define LIKELY_PROFILE()	VMLINUX_SYMBOL(__start_annotated_branch_profile) = .; \
>  				*(_ftrace_annotated_branch)			      \
> @@ -479,6 +488,7 @@
>  	MEM_DISCARD(init.data)						\
>  	KERNEL_CTORS()							\
>  	MCOUNT_REC()							\
> +	FTRACE_UNSAFE_RCU()						\
>  	*(.init.rodata)							\
>  	FTRACE_EVENTS()							\
>  	TRACE_SYSCALLS()						\
> diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
> index 9f15c00..1d17a82 100644
> --- a/include/linux/ftrace.h
> +++ b/include/linux/ftrace.h
> @@ -92,6 +92,9 @@ typedef void (*ftrace_func_t)(unsigned long ip, unsigned long parent_ip,
>   * STUB   - The ftrace_ops is just a place holder.
>   * INITIALIZED - The ftrace_ops has already been initialized (first use time
>   *            register_ftrace_function() is called, it will initialized the ops)
> + * RCU_SAFE - The callback uses no rcu type locking. This allows the
> + *            callback to be called in locations that RCU is not active.
> + *            (like going into or coming out of idle NO_HZ)
>   */
>  enum {
>  	FTRACE_OPS_FL_ENABLED			= 1 << 0,
> @@ -103,6 +106,7 @@ enum {
>  	FTRACE_OPS_FL_RECURSION_SAFE		= 1 << 6,
>  	FTRACE_OPS_FL_STUB			= 1 << 7,
>  	FTRACE_OPS_FL_INITIALIZED		= 1 << 8,
> +	FTRACE_OPS_FL_RCU_SAFE			= 1 << 9,
>  };
>  
>  struct ftrace_ops {
> @@ -219,6 +223,40 @@ static inline int ftrace_function_local_disabled(struct ftrace_ops *ops)
>  extern void ftrace_stub(unsigned long a0, unsigned long a1,
>  			struct ftrace_ops *op, struct pt_regs *regs);
>  
> +/*
> + * In order to speed up boot, save both the name and the
> + * address of the function to find to add to hashes. The
> + * list of function mcount addresses are sorted by the address,
> + * but we still need to use the name to find the actual location
> + * as the mcount call is usually not at the address of the
> + * start of the function.
> + */
> +struct ftrace_func_finder {
> +	const char		*name;
> +	unsigned long		ip;
> +};
> +
> +/*
> + * For functions that are called when RCU is not tracking the CPU
> + * (like for entering or leaving NO_HZ mode, and RCU then ignores
> + * the CPU), they need to be marked with FTRACE_UNSAFE_RCU().
> + * This will prevent all function tracing callbacks from calling
> + * this function unless the callback explicitly states that it
> + * doesn't use RCU with the FTRACE_OPS_FL_RCU_SAFE flag.
> + *
> + * The usage of FTRACE_UNSAFE_RCU() is the same as EXPORT_SYMBOL().
> + * Just place the macro underneath the function that is unsafe.
> + */
> +#define FTRACE_UNSAFE_RCU(func) \
> +	static struct ftrace_func_finder __ftrace_unsafe_rcu_##func	\
> +	 __initdata = {							\
> +		.name = #func,						\
> +		.ip = (unsigned long)func,				\
> +	};							\
> +	struct ftrace_func_finder *__ftrace_unsafe_rcu_ptr_##func	\
> +		  __attribute__((__section__("_ftrace_unsafe_rcu"))) =	\
> +		&__ftrace_unsafe_rcu_##func
> +
>  #else /* !CONFIG_FUNCTION_TRACER */
>  /*
>   * (un)register_ftrace_function must be a macro since the ops parameter
> diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
> index a6d098c..2580cdb 100644
> --- a/kernel/trace/ftrace.c
> +++ b/kernel/trace/ftrace.c
> @@ -1486,6 +1486,72 @@ ftrace_ops_test(struct ftrace_ops *ops, unsigned long ip, void *regs)
>  	}
>  
>  
> +static __init int ftrace_find_ip(const void *a, const void *b)
> +{
> +	const struct dyn_ftrace *key = a;
> +	const struct dyn_ftrace *rec = b;
> +
> +	if (key->ip == rec->ip)
> +		return 0;
> +
> +	if (key->ip < rec->ip) {
> +		/* If previous is less than, then this is our func */
> +		rec--;
> +		if (rec->ip < key->ip)
> +			return 0;
> +		return -1;
> +	}
> +
> +	/* All else, we are greater */
> +	return 1;
> +}
> +
> +/*
> + * Find the mcount caller location given the ip address of the
> + * function that contains it. As the mcount caller is usually
> + * after the mcount itself.
> + *
> + * Done for just core functions at boot.
> + */
> +static __init unsigned long ftrace_mcount_from_func(unsigned long ip)
> +{
> +	struct ftrace_page *pg, *last_pg = NULL;
> +	struct dyn_ftrace *rec;
> +	struct dyn_ftrace key;
> +
> +	key.ip = ip;
> +
> +	for (pg = ftrace_pages_start; pg; last_pg = pg, pg = pg->next) {
> +		if (ip >= (pg->records[pg->index - 1].ip + MCOUNT_INSN_SIZE))
> +			break;
> +
> +		/*
> +		 * Do the first record manually, as we need to check
> +		 * the previous record from the previous page
> +		 */
> +		if (ip < pg->records[0].ip) {
> +			/* First page? Then we found our record! */
> +			if (!last_pg)
> +				return pg->records[0].ip;
> +
> +			rec = &last_pg->records[last_pg->index - 1];
> +			if (rec->ip < ip)
> +				return pg->records[0].ip;
> +
> +			/* Not found */
> +			return 0;
> +		}
> +
> +		rec = bsearch(&key, pg->records + 1, pg->index - 1,
> +			      sizeof(struct dyn_ftrace),
> +			      ftrace_find_ip);
> +		if (rec)
> +			return rec->ip;
> +	}
> +
> +	return 0;
> +}
> +
>  static int ftrace_cmp_recs(const void *a, const void *b)
>  {
>  	const struct dyn_ftrace *key = a;
> @@ -4211,6 +4277,43 @@ struct notifier_block ftrace_module_exit_nb = {
>  	.priority = INT_MIN,	/* Run after anything that can remove kprobes */
>  };
>  
> +extern struct ftrace_func_finder *__start_ftrace_unsafe_rcu[];
> +extern struct ftrace_func_finder *__stop_ftrace_unsafe_rcu[];
> +
> +static struct ftrace_hash *ftrace_unsafe_rcu;
> +
> +static void __init create_unsafe_rcu_hash(void)
> +{
> +	struct ftrace_func_finder *finder;
> +	struct ftrace_func_finder **p;
> +	unsigned long ip;
> +	char str[KSYM_SYMBOL_LEN];
> +	int count;
> +
> +	count = __stop_ftrace_unsafe_rcu - __start_ftrace_unsafe_rcu;
> +	if (!count)
> +		return;
> +
> +	ftrace_unsafe_rcu = alloc_ftrace_hash(count);
> +
> +	for (p = __start_ftrace_unsafe_rcu;
> +	     p < __stop_ftrace_unsafe_rcu;
> +	     p++) {
> +		finder = *p;
> +
> +		ip = ftrace_mcount_from_func(finder->ip);
> +		if (WARN_ON_ONCE(!ip))
> +			continue;
> +
> +		/* Make sure this is our ip */
> +		kallsyms_lookup(ip, NULL, NULL, NULL, str);
> +		if (WARN_ON_ONCE(strcmp(str, finder->name) != 0))
> +			continue;
> +
> +		add_hash_entry(ftrace_unsafe_rcu, ip);
> +	}
> +}
> +
>  extern unsigned long __start_mcount_loc[];
>  extern unsigned long __stop_mcount_loc[];
>  
> @@ -4250,6 +4353,8 @@ void __init ftrace_init(void)
>  	if (ret)
>  		pr_warning("Failed to register trace ftrace module exit notifier\n");
>  
> +	create_unsafe_rcu_hash();
> +
>  	set_ftrace_early_filters();
>  
>  	return;

