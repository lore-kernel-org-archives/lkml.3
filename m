Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754192Ab3IZUq0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 16:46:26 -0400
Received: from mail.windriver.com ([147.11.1.11]:61156 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754078Ab3IZUqN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 16:46:13 -0400
Message-ID: <52449CED.803@windriver.com>
Date: Thu, 26 Sep 2013 15:45:33 -0500
From: Jason Wessel <jason.wessel@windriver.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Mike Travis <travis@sgi.com>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dimitri Sivanich <sivanich@sgi.com>, Hedi Berriche <hedi@sgi.com>,
        <x86@kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 5/7] KGDB/KDB: add support for external NMI handler to
 call KGDB/KDB.
References: <20130923212459.544517569@asylum.americas.sgi.com> <20130923212500.866318244@asylum.americas.sgi.com>
In-Reply-To: <20130923212500.866318244@asylum.americas.sgi.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/23/2013 04:25 PM, Mike Travis wrote:
> This patch adds a kgdb_nmicallin() interface that can be used by
> external NMI handlers to call the KGDB/KDB handler.  The primary need
> for this is for those types of NMI interrupts where all the CPUs
> have already received the NMI signal.  Therefore no send_IPI(NMI)
> is required, and in fact it will cause a 2nd unhandled NMI to occur.
> This generates the "Dazed and Confuzed" messages.
> 
> Since all the CPUs are getting the NMI at roughly the same time, it's not
> guaranteed that the first CPU that hits the NMI handler will manage to
> enter KGDB and set the dbg_master_lock before the slaves start entering.
> The new argument "send_ready" was added for KGDB to signal the NMI handler
> to release the slave CPUs for entry into KGDB.
> 
> Signed-off-by: Mike Travis <travis@sgi.com>
> Reviewed-by: Dimitri Sivanich <sivanich@sgi.com>
> Reviewed-by: Hedi Berriche <hedi@sgi.com>


One problem that I pointed out before and then you can add 

Acked-by: Jason Wessel <jason.wessel@windriver.com>


> ---
>  include/linux/kdb.h             |    1 +
>  include/linux/kgdb.h            |    1 +
>  kernel/debug/debug_core.c       |   30 +++++++++++++++++++++++++++++-
>  kernel/debug/debug_core.h       |    1 +
>  kernel/debug/kdb/kdb_debugger.c |    5 ++++-
>  kernel/debug/kdb/kdb_main.c     |    3 +++
>  6 files changed, 39 insertions(+), 2 deletions(-)
> 
> --- linux.orig/include/linux/kdb.h
> +++ linux/include/linux/kdb.h
> @@ -109,6 +109,7 @@ typedef enum {
>  	KDB_REASON_RECURSE,	/* Recursive entry to kdb;
>  				 * regs probably valid */
>  	KDB_REASON_SSTEP,	/* Single Step trap. - regs valid */
> +	KDB_REASON_SYSTEM_NMI,	/* In NMI due to SYSTEM cmd; regs valid */
>  } kdb_reason_t;
>  
>  extern int kdb_trap_printk;
> --- linux.orig/include/linux/kgdb.h
> +++ linux/include/linux/kgdb.h
> @@ -310,6 +310,7 @@ extern int
>  kgdb_handle_exception(int ex_vector, int signo, int err_code,
>  		      struct pt_regs *regs);
>  extern int kgdb_nmicallback(int cpu, void *regs);
> +extern int kgdb_nmicallin(int cpu, int trapnr, void *regs, atomic_t *snd_rdy);
>  extern void gdbstub_exit(int status);
>  
>  extern int			kgdb_single_step;
> --- linux.orig/kernel/debug/debug_core.c
> +++ linux/kernel/debug/debug_core.c
> @@ -575,8 +575,12 @@ return_normal:
>  		raw_spin_lock(&dbg_slave_lock);
>  
>  #ifdef CONFIG_SMP
> +	/* If SYSTEM_NMI, slaves are already waiting */
> +	if (ks->err_code == KDB_REASON_SYSTEM_NMI)
> +		atomic_set(ks->send_ready, 1);
> +
>  	/* Signal the other CPUs to enter kgdb_wait() */
> -	if ((!kgdb_single_step) && kgdb_do_roundup)
> +	else if ((!kgdb_single_step) && kgdb_do_roundup)
>  		kgdb_roundup_cpus(flags);
>  #endif
>  
> @@ -729,6 +733,30 @@ int kgdb_nmicallback(int cpu, void *regs
>  		return 0;
>  	}
>  #endif
> +	return 1;
> +}
> +
> +int kgdb_nmicallin(int cpu, int trapnr, void *regs, atomic_t *send_ready)
> +{
> +#ifdef CONFIG_SMP
> +	if (!kgdb_io_ready(0) || !send_ready)
> +		return 1;
> +
> +	if (kgdb_info[cpu].enter_kgdb == 0) {
> +		struct kgdb_state kgdb_var;
> +		struct kgdb_state *ks = &kgdb_var;
> +
> +		memset(ks, 0, sizeof(struct kgdb_state));
> +		ks->cpu			= cpu;
> +		ks->ex_vector		= trapnr;
> +		ks->signo		= SIGTRAP;
> +		ks->err_code		= KDB_REASON_SYSTEM_NMI;
> +		ks->linux_regs		= regs;
> +		ks->send_ready		= send_ready;
> +		kgdb_cpu_enter(ks, regs, DCPU_WANT_MASTER);
> +		return 0;
> +	}
> +#endif
>  	return 1;
>  }
>  
> --- linux.orig/kernel/debug/debug_core.h
> +++ linux/kernel/debug/debug_core.h
> @@ -26,6 +26,7 @@ struct kgdb_state {
>  	unsigned long		threadid;
>  	long			kgdb_usethreadid;
>  	struct pt_regs		*linux_regs;
> +	atomic_t		*send_ready;
>  };
>  
>  /* Exception state values */
> --- linux.orig/kernel/debug/kdb/kdb_debugger.c
> +++ linux/kernel/debug/kdb/kdb_debugger.c
> @@ -69,7 +69,10 @@ int kdb_stub(struct kgdb_state *ks)
>  	if (atomic_read(&kgdb_setting_breakpoint))
>  		reason = KDB_REASON_KEYBOARD;
>  
> -	if (in_nmi())
> +	if (ks->err_code == KDB_REASON_SYSTEM_NMI)


This should be:

(ks->err == KDB_REASON_SYSNMI && ks->signo == SIGTRAP)

Other arch's in their arch specific handling code may set ks->err differently.  The err code is signal specific.  For example:

arch/hexagon/kernel/kgdb.c:  if (kgdb_handle_exception(args->trapnr & 0xff, args->signr, args->err,

The error passed in will be different for other signals and we do not want it to collide.

Cheers,
Jason.


> +		reason = KDB_REASON_SYSTEM_NMI;
> +
> +	else if (in_nmi())
>  		reason = KDB_REASON_NMI;
>  
>  	for (i = 0, bp = kdb_breakpoints; i < KDB_MAXBPT; i++, bp++) {
> --- linux.orig/kernel/debug/kdb/kdb_main.c
> +++ linux/kernel/debug/kdb/kdb_main.c
> @@ -1200,6 +1200,9 @@ static int kdb_local(kdb_reason_t reason
>  			   instruction_pointer(regs));
>  		kdb_dumpregs(regs);
>  		break;
> +	case KDB_REASON_SYSTEM_NMI:
> +		kdb_printf("due to System NonMaskable Interrupt\n");
> +		break;
>  	case KDB_REASON_NMI:
>  		kdb_printf("due to NonMaskable Interrupt @ "
>  			   kdb_machreg_fmt "\n",
> 
> -- 
> 

