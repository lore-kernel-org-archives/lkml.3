Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753911AbaF0OU3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 10:20:29 -0400
Received: from cantor2.suse.de ([195.135.220.15]:59749 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753200AbaF0OU2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 10:20:28 -0400
Date: Fri, 27 Jun 2014 16:20:25 +0200
From: Petr =?iso-8859-1?Q?Ml=E1dek?= <pmladek@suse.cz>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jiri Kosina <jkosina@suse.cz>, Michal Hocko <mhocko@suse.cz>,
        Jan Kara <jack@suse.cz>, Frederic Weisbecker <fweisbec@gmail.com>,
        Dave Anderson <anderson@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Konstantin Khlebnikov <koct9i@gmail.com>
Subject: Re: [RFC][PATCH 4/5 v2] printk: Add per_cpu printk func to allow
 printk to be diverted
Message-ID: <20140627142025.GD23205@pathway.suse.cz>
References: <20140626214901.596791200@goodmis.org>
 <20140626220130.356038089@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140626220130.356038089@goodmis.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2014-06-26 17:49:05, Steven Rostedt wrote:
> From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>
> 
> Being able to divert printk to call another function besides the normal
> logging is useful for such things like NMI handling. If some functions
> are to be called from NMI that does printk() it is possible to lock up
> the box if the nmi handler triggers when another printk is happening.
> 
> One example of this use is to perform a stack trace on all CPUs via NMI.
> But if the NMI is to do the printk() it can cause the system to lock up.
> By allowing the printk to be diverted to another function that can safely
> record the printk output and then print it when it in a safe context
> then NMIs will be safe to call these functions like show_regs().
> 
> Link: http://lkml.kernel.org/p/20140619213952.209176403@goodmis.org
> 
> Acked-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

It is nice trick and works very well from the backtrace stuff.

Tested-by: Petr Mladek <pmladek@suse.cz>

See one comment below.

> ---
>  include/linux/percpu.h |  3 +++
>  include/linux/printk.h |  2 ++
>  kernel/printk/printk.c | 38 +++++++++++++++++++++++++++++---------
>  3 files changed, 34 insertions(+), 9 deletions(-)
> 
> diff --git a/include/linux/percpu.h b/include/linux/percpu.h
> index 8419053d0f2e..9997c92ce3bd 100644
> --- a/include/linux/percpu.h
> +++ b/include/linux/percpu.h
> @@ -802,4 +802,7 @@ do { __this_cpu_preempt_check("or");					\
>  	(__this_cpu_preempt_check("cmpxchg_double"),__pcpu_double_call_return_bool(raw_cpu_cmpxchg_double_, (pcp1), (pcp2), (oval1), (oval2), (nval1), (nval2)))
>  #endif
>  
> +/* To avoid include hell, as printk can not declare this, we declare it here */
> +DECLARE_PER_CPU(printk_func_t, printk_func);
> +
>  #endif /* __LINUX_PERCPU_H */
> diff --git a/include/linux/printk.h b/include/linux/printk.h
> index 319ff7e53efb..e26310b2d2fd 100644
> --- a/include/linux/printk.h
> +++ b/include/linux/printk.h
> @@ -159,6 +159,8 @@ extern int kptr_restrict;
>  
>  extern void wake_up_klogd(void);
>  
> +typedef int(*printk_func_t)(const char *fmt, va_list args);
> +
>  void log_buf_kexec_setup(void);
>  void __init setup_log_buf(int early);
>  void dump_stack_set_arch_desc(const char *fmt, ...);
> diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
> index ea2d5f6962ed..e3581f95ba5c 100644
> --- a/kernel/printk/printk.c
> +++ b/kernel/printk/printk.c
> @@ -1764,6 +1764,30 @@ asmlinkage int printk_emit(int facility, int level,
>  }
>  EXPORT_SYMBOL(printk_emit);
>  
> +int vprintk_default(const char *fmt, va_list args)
> +{
> +	int r;
> +
> +#ifdef CONFIG_KGDB_KDB
> +	if (unlikely(kdb_trap_printk)) {
> +		r = vkdb_printf(fmt, args);
> +		return r;
> +	}
> +#endif
> +	r = vprintk_emit(0, -1, NULL, 0, fmt, args);
> +
> +	return r;
> +}
> +EXPORT_SYMBOL_GPL(vprintk_default);
> +
> +/*
> + * This allows printk to be diverted to another function per cpu.
> + * This is useful for calling printk functions from within NMI
> + * without worrying about race conditions that can lock up the
> + * box.
> + */
> +DEFINE_PER_CPU(printk_func_t, printk_func) = vprintk_default;
> +
>  /**
>   * printk - print a kernel message
>   * @fmt: format string
> @@ -1787,19 +1811,15 @@ EXPORT_SYMBOL(printk_emit);
>   */
>  asmlinkage __visible int printk(const char *fmt, ...)
>  {
> +	printk_func_t vprintk_func;
>  	va_list args;
>  	int r;
>  
> -#ifdef CONFIG_KGDB_KDB
> -	if (unlikely(kdb_trap_printk)) {
> -		va_start(args, fmt);
> -		r = vkdb_printf(fmt, args);
> -		va_end(args);
> -		return r;
> -	}
> -#endif
>  	va_start(args, fmt);
> -	r = vprintk_emit(0, -1, NULL, 0, fmt, args);
> +	preempt_disable();

I think that it is too late to disable the preemption here.
It has to be done by the printk() caller if it wants to be sure
that the requested function is used.

> +	vprintk_func = this_cpu_read(printk_func);
> +	r = vprintk_func(fmt, args);
> +	preempt_enable();
>  	va_end(args);
>  
>  	return r;

Best Regards,
Petr
