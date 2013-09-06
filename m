Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750786Ab3IFFBL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Sep 2013 01:01:11 -0400
Received: from mail.windriver.com ([147.11.1.11]:37903 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750720Ab3IFFBJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Sep 2013 01:01:09 -0400
Message-ID: <5229615A.90203@windriver.com>
Date: Fri, 6 Sep 2013 00:00:10 -0500
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
Subject: Re: [PATCH 7/9] KGDB/KDB: add new system NMI entry code to KDB
References: <20130905225032.879120272@asylum.americas.sgi.com> <20130905225034.036339770@asylum.americas.sgi.com>
In-Reply-To: <20130905225034.036339770@asylum.americas.sgi.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/05/2013 05:50 PM, Mike Travis wrote:
> This patch adds a new "KDB_REASON" code (KDB_REASON_SYSTEM_NMI).  This
> is purely cosmetic to distinguish it from the other various reasons that
> NMI may occur and are usually after an error occurred.  Also the dumping
> of registers is not done to more closely match what is displayed when KDB
> is entered manually via the sysreq 'g' key.


This patch is not quite right.   See below.


> 
> Signed-off-by: Mike Travis <travis@sgi.com>
> Reviewed-by: Dimitri Sivanich <sivanich@sgi.com>
> Reviewed-by: Hedi Berriche <hberrich@sgi.com>
> ---
>  include/linux/kdb.h             |    1 +
>  include/linux/kgdb.h            |    1 +
>  kernel/debug/debug_core.c       |    5 +++++
>  kernel/debug/kdb/kdb_debugger.c |    5 ++++-
>  kernel/debug/kdb/kdb_main.c     |    3 +++
>  5 files changed, 14 insertions(+), 1 deletion(-)
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
> @@ -52,6 +52,7 @@ extern int kgdb_connected;
>  extern int kgdb_io_module_registered;
>  
>  extern atomic_t			kgdb_setting_breakpoint;
> +extern atomic_t			kgdb_system_nmi;


We don't need extra atomics.  You should add another variable to the kgdb_state which is processor specific in this case.

Better yet, just set the ks->err_code properly in your kgdb_nmicallin() or in the origination call to kgdb_nmicallback() from your nmi handler (remember I still have the question pending if we actually need kgdb_nmicallin() in the first place.  You already did the work of adding another NMI type to the enum.  We just need to use the ks->err_code variable as well.


>  extern atomic_t			kgdb_cpu_doing_single_step;
>  
>  extern struct task_struct	*kgdb_usethread;
> --- linux.orig/kernel/debug/debug_core.c
> +++ linux/kernel/debug/debug_core.c
> @@ -125,6 +125,7 @@ static atomic_t			masters_in_kgdb;
>  static atomic_t			slaves_in_kgdb;
>  static atomic_t			kgdb_break_tasklet_var;
>  atomic_t			kgdb_setting_breakpoint;
> +atomic_t			kgdb_system_nmi;
>  
>  struct task_struct		*kgdb_usethread;
>  struct task_struct		*kgdb_contthread;
> @@ -760,7 +761,11 @@ int kgdb_nmicallin(int cpu, int trapnr,
>  
>  		/* Indicate there are slaves waiting */
>  		kgdb_info[cpu].send_ready = send_ready;
> +
> +		/* Use new reason code "SYSTEM_NMI" */
> +		atomic_inc(&kgdb_system_nmi);
>  		kgdb_cpu_enter(ks, regs, DCPU_WANT_MASTER);
> +		atomic_dec(&kgdb_system_nmi);
>  		kgdb_do_roundup = save_kgdb_do_roundup;
>  		kgdb_info[cpu].send_ready = NULL;
>  
> --- linux.orig/kernel/debug/kdb/kdb_debugger.c
> +++ linux/kernel/debug/kdb/kdb_debugger.c
> @@ -69,7 +69,10 @@ int kdb_stub(struct kgdb_state *ks)
>  	if (atomic_read(&kgdb_setting_breakpoint))
>  		reason = KDB_REASON_KEYBOARD;
>  
> -	if (in_nmi())
> +	if (atomic_read(&kgdb_system_nmi))
> +		reason = KDB_REASON_SYSTEM_NMI;


This would get changed to if (ks->err == KDB_REASON_SYSNMI && ks->signo == SIGTRAP) ....

Cheers,
Jason.

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

