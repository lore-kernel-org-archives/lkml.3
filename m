Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754013AbaKKLm5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 06:42:57 -0500
Received: from mail.skyhub.de ([78.46.96.112]:49913 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752721AbaKKLmy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 06:42:54 -0500
Date: Tue, 11 Nov 2014 12:42:48 +0100
From: Borislav Petkov <bp@alien8.de>
To: linux-kernel@vger.kernel.org
Cc: "Chen, Gong" <gong.chen@linux.intel.com>, tony.luck@intel.com,
        x86@kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Oleg Nesterov <oleg@redhat.com>, Andy Lutomirski <luto@amacapital.net>
Subject: Re: [PATCH v2 4/5] x86/mce: Simplify flow when handling recoverable
 memory errors
Message-ID: <20141111114248.GD31490@pd.tnic>
References: <1407998986-1834-1-git-send-email-gong.chen@linux.intel.com>
 <1407998986-1834-5-git-send-email-gong.chen@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1407998986-1834-5-git-send-email-gong.chen@linux.intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Let me CC some more people:

So guys, we would like to mark a task as to-be-killed if it has
encountered an uncorrectable error during processing.

The current code is nasty (see Tony's patch and commit message below)
and we would like to be able to say:

	current->restartable = true/false;

in the machine check handler and then, when we get back to userspace but
*before* we sched in the task, to check whether it is restartable and if
not, to kill it and poison the memory it has been utilizing so that we
can contain the error instead of killing the whole system.

Currently, we're piggybacking on
do_notify_resume()->mce_notify_process() but I hear this is not that
clean and nice so I'd be open to suggestions on how to do this in a
nicer/cleaner way.

Roughly speaking, we want to be able to mark a task with the sign of
death and to kill it, if needed. The important part is *before* it
gets to run again. And the approach with adding two-more fields to
task_struct seems cleaner than what we have currently.

Any suggestion is appreciated,
thanks!

Oh, and btw, sorry for the top-posting - leaving in the whole mail for
reference.

On Thu, Aug 14, 2014 at 02:49:45AM -0400, Chen, Gong wrote:
> From: Tony Luck <tony.luck@intel.com>
> 
> Handling of uncorrected, but s/w recoverable, errors is a two phase process:
> 
> 1) In the machine check handler we identify the signature of a recoverable
>    error and use TIF_MCE_NOTIFY to mark the process so that we will not
>    return to ring3 and re-execute the instruction that accessed the failed
>    memory location.
> 2) In process context we see TIF_MCE_NOTIFY set and call mce_notify_process()
>    to do all the recovery work that we could not do in machine check context.
> 
> We need to pass the memory address and a flag to say whether the faulting
> instruction can be continued from stage "1" to stage "2".  The existing
> code to do this is baroque.  We hunt through a fixed sized array of
> "mce_info" structures and use atomic_cmpxchg to claim a free one (we
> panic if all are busy). Then in phase 2 we scan back through the mce_info
> array looking for the one that matches the current process.
> 
> We can do much better by admitting that the failing address found in
> phase 1 is a property of the current task. We can only recover from
> errors detected while trying to retire an instruction in ring3 (s/w
> limitation). So we know that MCE_AR_SEVERITY means that we are running
> on the cpu that was executing user code and hit an error that triggered
> this machine check.  This is the reason why TIF_MCE_NOTIFY has been set,
> and the memory error must be dealt with before we can either allow this
> process to continue (if we can replace the page) or not (signalling the
> process if the memory has been lost).
> 
> So we add two fields to the task structure to be saved in phase 1 and
> retrieved in phase 2.  The mce_info[] array and routines to add/find/clear
> entried from it can all be deleted.
> 
> Gong: Add missed CONFIG_MEMORY_FAILURE & '\n' to the end of printk
> message, while at it.
> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> Signed-off-by: Chen, Gong <gong.chen@linux.intel.com>
> Acked-by: Borislav Petkov <bp@suse.de>
> ---
>  arch/x86/include/asm/mce.h       |  2 ++
>  arch/x86/kernel/cpu/mcheck/mce.c | 67 +++++++---------------------------------
>  arch/x86/kernel/signal.c         |  2 +-
>  include/linux/sched.h            |  4 +++
>  4 files changed, 19 insertions(+), 56 deletions(-)
> 
> diff --git a/arch/x86/include/asm/mce.h b/arch/x86/include/asm/mce.h
> index a713dabd000b..76e706767655 100644
> --- a/arch/x86/include/asm/mce.h
> +++ b/arch/x86/include/asm/mce.h
> @@ -187,7 +187,9 @@ enum mcp_flags {
>  void machine_check_poll(enum mcp_flags flags, mce_banks_t *b);
>  
>  int mce_notify_irq(void);
> +#ifdef CONFIG_MEMORY_FAILURE
>  void mce_notify_process(void);
> +#endif
>  
>  DECLARE_PER_CPU(struct mce, injectm);
>  
> diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
> index 0e64a3c69b2b..b0a25d5f7185 100644
> --- a/arch/x86/kernel/cpu/mcheck/mce.c
> +++ b/arch/x86/kernel/cpu/mcheck/mce.c
> @@ -928,51 +928,6 @@ static void mce_clear_state(unsigned long *toclear)
>  }
>  
>  /*
> - * Need to save faulting physical address associated with a process
> - * in the machine check handler some place where we can grab it back
> - * later in mce_notify_process()
> - */
> -#define	MCE_INFO_MAX	16
> -
> -struct mce_info {
> -	atomic_t		inuse;
> -	struct task_struct	*t;
> -	__u64			paddr;
> -	int			restartable;
> -} mce_info[MCE_INFO_MAX];
> -
> -static void mce_save_info(__u64 addr, int c)
> -{
> -	struct mce_info *mi;
> -
> -	for (mi = mce_info; mi < &mce_info[MCE_INFO_MAX]; mi++) {
> -		if (atomic_cmpxchg(&mi->inuse, 0, 1) == 0) {
> -			mi->t = current;
> -			mi->paddr = addr;
> -			mi->restartable = c;
> -			return;
> -		}
> -	}
> -
> -	mce_panic("Too many concurrent recoverable errors", NULL, NULL);
> -}
> -
> -static struct mce_info *mce_find_info(void)
> -{
> -	struct mce_info *mi;
> -
> -	for (mi = mce_info; mi < &mce_info[MCE_INFO_MAX]; mi++)
> -		if (atomic_read(&mi->inuse) && mi->t == current)
> -			return mi;
> -	return NULL;
> -}
> -
> -static void mce_clear_info(struct mce_info *mi)
> -{
> -	atomic_set(&mi->inuse, 0);
> -}
> -
> -/*
>   * The actual machine check handler. This only handles real
>   * exceptions when something got corrupted coming in through int 18.
>   *
> @@ -1121,11 +1076,15 @@ void do_machine_check(struct pt_regs *regs, long error_code)
>  	if (cfg->tolerant < 3) {
>  		if (no_way_out)
>  			mce_panic("Fatal machine check on current CPU", &m, msg);
> +#ifdef CONFIG_MEMORY_FAILURE
>  		if (worst == MCE_AR_SEVERITY) {
>  			/* schedule action before return to userland */
> -			mce_save_info(m.addr, m.mcgstatus & MCG_STATUS_RIPV);
> +			current->paddr = m.addr;
> +			current->restartable = !!(m.mcgstatus & MCG_STATUS_RIPV);
>  			set_thread_flag(TIF_MCE_NOTIFY);
> -		} else if (kill_it) {
> +		} else
> +#endif
> +		if (kill_it) {
>  			force_sig(SIGBUS, current);
>  		}
>  	}
> @@ -1159,33 +1118,31 @@ int memory_failure(unsigned long pfn, int vector, int flags)
>   * process any corrupted pages, and kill/signal current process if required.
>   * Action required errors are handled here.
>   */
> +#ifdef CONFIG_MEMORY_FAILURE
>  void mce_notify_process(void)
>  {
>  	unsigned long pfn;
> -	struct mce_info *mi = mce_find_info();
>  	int flags = MF_ACTION_REQUIRED;
>  
> -	if (!mi)
> -		mce_panic("Lost physical address for unconsumed uncorrectable error", NULL, NULL);
> -	pfn = mi->paddr >> PAGE_SHIFT;
> +	pfn = current->paddr >> PAGE_SHIFT;
>  
>  	clear_thread_flag(TIF_MCE_NOTIFY);
>  
> -	pr_err("Uncorrected hardware memory error in user-access at %llx",
> -		 mi->paddr);
> +	pr_err("Uncorrected hardware memory error in user-access at %llx\n",
> +		 current->paddr);
>  	/*
>  	 * We must call memory_failure() here even if the current process is
>  	 * doomed. We still need to mark the page as poisoned and alert any
>  	 * other users of the page.
>  	 */
> -	if (!mi->restartable)
> +	if (!current->restartable)
>  		flags |= MF_MUST_KILL;
>  	if (memory_failure(pfn, MCE_VECTOR, flags) < 0) {
>  		pr_err("Memory error not recovered");
>  		force_sig(SIGBUS, current);
>  	}
> -	mce_clear_info(mi);
>  }
> +#endif
>  
>  /*
>   * Action optional processing happens here (picking up
> diff --git a/arch/x86/kernel/signal.c b/arch/x86/kernel/signal.c
> index 2851d63c1202..28fd70560b96 100644
> --- a/arch/x86/kernel/signal.c
> +++ b/arch/x86/kernel/signal.c
> @@ -735,7 +735,7 @@ do_notify_resume(struct pt_regs *regs, void *unused, __u32 thread_info_flags)
>  {
>  	user_exit();
>  
> -#ifdef CONFIG_X86_MCE
> +#ifdef CONFIG_MEMORY_FAILURE
>  	/* notify userspace of pending MCEs */
>  	if (thread_info_flags & _TIF_MCE_NOTIFY)
>  		mce_notify_process();
> diff --git a/include/linux/sched.h b/include/linux/sched.h
> index 857ba40426ba..b41e839b9e1e 100644
> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -1645,6 +1645,10 @@ struct task_struct {
>  	unsigned int	sequential_io;
>  	unsigned int	sequential_io_avg;
>  #endif
> +#ifdef CONFIG_MEMORY_FAILURE
> +	__u64	paddr;
> +	int	restartable;
> +#endif
>  };
>  
>  /* Future-safe accessor for struct task_struct's cpus_allowed. */
> -- 
> 2.0.0.rc2
> 
> 

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
