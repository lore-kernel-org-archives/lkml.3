Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751209AbaK0VXD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 16:23:03 -0500
Received: from www.linutronix.de ([62.245.132.108]:58862 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750836AbaK0VXB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 16:23:01 -0500
Date: Thu, 27 Nov 2014 22:22:50 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Emmanuel Berthier <emmanuel.berthier@intel.com>
cc: "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, robert.jarzmik@intel.com,
        LKML <linux-kernel@vger.kernel.org>,
        Andy Lutomirski <luto@amacapital.net>
Subject: Re: [PATCH v2] [LBR] Dump LBRs on Exception
In-Reply-To: <1417099205-13309-1-git-send-email-emmanuel.berthier@intel.com>
Message-ID: <alpine.DEB.2.11.1411271609510.3961@nanos>
References: <65CD3FC07F3BF942ABE211646D72D770356EACA5@IRSMSX110.ger.corp.intel.com> <1417099205-13309-1-git-send-email-emmanuel.berthier@intel.com>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 Nov 2014, Emmanuel Berthier wrote:
> diff --git a/arch/x86/kernel/cpu/perf_event_intel_lbr.c b/arch/x86/kernel/cpu/perf_event_intel_lbr.c
> index 45fa730..0a69365 100644
> --- a/arch/x86/kernel/cpu/perf_event_intel_lbr.c
> +++ b/arch/x86/kernel/cpu/perf_event_intel_lbr.c
> @@ -4,7 +4,7 @@
>  #include <asm/perf_event.h>
>  #include <asm/msr.h>
>  #include <asm/insn.h>
> -

This newline is intentional to seperate asm includes from the local
one.

>  static void __intel_pmu_lbr_enable(void)
>  {
>  	u64 debugctl;
>  	struct cpu_hw_events *cpuc = this_cpu_ptr(&cpu_hw_events);
>  
> +	lbr_set_used_by_perf(true);

This cannot work.

CPU0					CPU1

__intel_pmu_lbr_enable()
   lbr_set_used_by_perf(true);
					__intel_pmu_lbr_disable()
					  lbr_set_used_by_perf(false);

This is a per cpu property.

And there is more to that. Let's look at a single CPU.

lbr for oops is enabled

context switch()
   __intel_pmu_lbr_enable()	-> LBR used by perf, oops dumper disabled

context switch()
   __intel_pmu_lbr_disable()	-> LBR not longer used by perf, oops
   				   dumper enabled

So after that context switch we crash in the kernel and LBR is empty
because we did disable it at the context switch.

So you need per cpu state, which handles the LBR dumper state:

#define LBR_OOPS_DISABLED 0x01
#define LBR_PERF_USAGE	  0x02

DEFINE_PER_CPU(unsigned long, lbr_dump_state) = LBR_OOPS_DISABLED;

lbr_perf_enable()
	this_cpu_add(lbr_dump_state, LBR_PERF_USAGE);

lbr_perf_disable()
	if (!this_cpu_sub_return(lbr_dump_state, LBR_PERF_USAGE))
	   	enable_lbr_oops();

Now of course you need to handle this in the exception path per cpu as
well.

>  /*
>   * Exception entry points.
>   */
> @@ -1063,6 +1103,8 @@ ENTRY(\sym)
>  	subq $ORIG_RAX-R15, %rsp
>  	CFI_ADJUST_CFA_OFFSET ORIG_RAX-R15
>  
> +	STOP_LBR

We really cannot do this unconditionally for every exception. This
wants to be conditional, i.e.

       .if \stop_lbr
       cond_stop_lbr
       .endif

So we can select which exceptions actually get that treatment.
do_page_fault is probably the only one which is interesting
here.

Now looking at your macro maze, I really wonder whether we can do it a
little bit less convoluted. We need to push/pop registers. error_entry
saves the registers already and has a (admitedly convoluted)
kernel/user space check. But we might be able to do something sane
there. Cc'ing Andy as he is the master of that universe.

Thanks,

	tglx



