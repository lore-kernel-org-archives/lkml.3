Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750745Ab3IFEie (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Sep 2013 00:38:34 -0400
Received: from mail1.windriver.com ([147.11.146.13]:43522 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750705Ab3IFEic (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Sep 2013 00:38:32 -0400
Message-ID: <52295BD0.3000602@windriver.com>
Date: Thu, 5 Sep 2013 23:36:32 -0500
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
Subject: Re: [PATCH 5/9] KGDB/KDB: add support for external NMI handler to
 call KGDB/KDB.
References: <20130905225032.879120272@asylum.americas.sgi.com> <20130905225033.730379071@asylum.americas.sgi.com>
In-Reply-To: <20130905225033.730379071@asylum.americas.sgi.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/05/2013 05:50 PM, Mike Travis wrote:
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

It should have been ok to have more than one master if this was some kind of watch dog.  The raw spin lock for the dbg_master_lock should have ensured that only a single CPU is in fact the master.  If it is the case that we cannot send a nested IPI at this point, the UV machine type should have replaced the kgdb_roundup_cpus() routine with something that will work, such as looking at the exception type on the way in and perhaps skipping the IPI send.

Also if there is no possibility of restarting the machine from this state it would have been possible to simply turn off kgdb_do_roundup in the custom kgdb_roundup_cpus().

The patch you created appears that it will work, but it comes at the cost of some complexity because you are also checking on the state of "kgdb_info[cpu].send_ready" in some other location in the NMI handler.  It might be better to consider not sending a nested NMI if all the CPUs are going to enter anyway in the master state.


>
> The new argument "send_ready" was added for KGDB to signal the NMI handler
> to release the slave CPUs for entry into KGDB.
>
> Signed-off-by: Mike Travis <travis@sgi.com>
> Reviewed-by: Dimitri Sivanich <sivanich@sgi.com>
> Reviewed-by: Hedi Berriche <hberrich@sgi.com>
> ---
>  include/linux/kgdb.h      |    1 +
>  kernel/debug/debug_core.c |   41 +++++++++++++++++++++++++++++++++++++++++
>  kernel/debug/debug_core.h |    1 +
>  3 files changed, 43 insertions(+)
>
> --- linux.orig/include/linux/kgdb.h
> +++ linux/include/linux/kgdb.h
> @@ -310,6 +310,7 @@ extern int
>  kgdb_handle_exception(int ex_vector, int signo, int err_code,
>                struct pt_regs *regs);
>  extern int kgdb_nmicallback(int cpu, void *regs);
> +extern int kgdb_nmicallin(int cpu, int trapnr, void *regs, atomic_t *snd_rdy);
>  extern void gdbstub_exit(int status);
> 
>  extern int            kgdb_single_step;
> --- linux.orig/kernel/debug/debug_core.c
> +++ linux/kernel/debug/debug_core.c
> @@ -578,6 +578,10 @@ return_normal:
>      /* Signal the other CPUs to enter kgdb_wait() */
>      if ((!kgdb_single_step) && kgdb_do_roundup)
>          kgdb_roundup_cpus(flags);
> +
> +    /* If optional send ready pointer, signal CPUs to proceed */
> +    if (kgdb_info[cpu].send_ready)
> +        atomic_set(kgdb_info[cpu].send_ready, 1);
>  #endif
> 
>      /*
> @@ -729,6 +733,43 @@ int kgdb_nmicallback(int cpu, void *regs
>          return 0;
>      }
>  #endif
> +    return 1;
> +}
> +
> +int kgdb_nmicallin(int cpu, int trapnr, void *regs, atomic_t *send_ready)
> +{
> +#ifdef CONFIG_SMP
> +    if (!kgdb_io_ready(0))
> +        return 1;
> +
> +    if (kgdb_info[cpu].enter_kgdb == 0) {
> +        struct kgdb_state kgdb_var;
> +        struct kgdb_state *ks = &kgdb_var;
> +        int save_kgdb_do_roundup = kgdb_do_roundup;
> +
> +        memset(ks, 0, sizeof(struct kgdb_state));
> +        ks->cpu            = cpu;
> +        ks->ex_vector        = trapnr;
> +        ks->signo        = SIGTRAP;
> +        ks->err_code        = 0;
> +        ks->kgdb_usethreadid    = 0;
> +        ks->linux_regs        = regs;
> +
> +        /* Do not broadcast NMI */
> +        kgdb_do_roundup = 0;
> +
> +        /* Indicate there are slaves waiting */
> +        kgdb_info[cpu].send_ready = send_ready;
> +        kgdb_cpu_enter(ks, regs, DCPU_WANT_MASTER);

This is the one part of the patch I don't quite understand.  Why does the kgdb_nmicallin() desire to be the master core?

It was not obvious the circumstance as to why this is called.  Is it some kind of watch dog where you really do want to enter the debugger or is it more to deal with nested slave interrupts were the round up would have possibly hung on this hardware.  If it is the later, I would have thought this should be a slave and not the master.

Perhaps a comment in the code can clear this up?

Thanks,
Jason.


