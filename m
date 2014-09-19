Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757443AbaISQYV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 12:24:21 -0400
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:39940 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756738AbaISQYT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 12:24:19 -0400
Message-ID: <541C58B0.4060704@hurleysoftware.com>
Date: Fri, 19 Sep 2014 12:24:16 -0400
From: Peter Hurley <peter@hurleysoftware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.1
MIME-Version: 1.0
To: Mike Galbraith <umgwanakikbuti@gmail.com>,
        Josh Boyer <jwboyer@fedoraproject.org>,
        Len Brown <len.brown@intel.com>
CC: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>,
        Ian Malone <ibmalone@gmail.com>,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
Subject: Re: Kernel bug 60770
References: <CA+5PVA4Ld3-VfPN6NWk=uqiuG2p99dL8Ro_X08NFb33_UtnWMA@mail.gmail.com>	 <CA+5PVA5XxcQe+Coy-OdMRsAxSCH=3B7QdsdXO2GqRkFDcAt0iA@mail.gmail.com> <1409234000.5212.7.camel@marge.simpson.net>
In-Reply-To: <1409234000.5212.7.camel@marge.simpson.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-ID: 8FA290C2A27252AACF65DBC4A42F3CE3735FB2A4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/28/2014 09:53 AM, Mike Galbraith wrote:
> On Thu, 2014-08-28 at 09:23 -0400, Josh Boyer wrote: 
>> On Sat, Aug 16, 2014 at 10:33 AM, Josh Boyer <jwboyer@fedoraproject.org> wrote:
>>> Hi Len,
>>>
>>> Kernel bug https://bugzilla.kernel.org/show_bug.cgi?id=60770 is marked
>>> as closed, but there is a patch that at least one user seems to need
>>> to get things booting properly.  It was sent upstream a while ago:
>>>
>>> http://marc.info/?l=linux-kernel&m=138976439211647&w=2
>>>
>>> but has never made it into the kernel.  Do you know why this is or
>>> what happened to the patch?
>>
>> Adding Peter and Ingo.  Len seems to be MIA or otherwise occupied.
>>
>> Peter and Ingo, and thoughts on the bug/thread above?
> 
> That patch needs some bend adjustment, now looks like below here.
> 
> Patch also has a secondary benefit for core2 boxen, when booted
> processor.max_cstate=1, box can still use mwait.
> 
> Subject: [PATCH REGRESSION FIX] x86 idle: restore mwait_idle()
> From: Len Brown <lenb@kernel.org>
> Date: Wed, 15 Jan 2014 00:37:34 -0500
> 
> From: Len Brown <len.brown@intel.com>
> 
> In Linux-3.9 we removed the mwait_idle() loop:
> 'x86 idle: remove mwait_idle() and "idle=mwait" cmdline param'
> (69fb3676df3329a7142803bb3502fa59dc0db2e3)
> 
> The reasoning was that modern machines should be sufficiently
> happy during the boot process using the default_idle() HALT loop,
> until cpuidle loads and either acpi_idle or intel_idle
> invoke the newer MWAIT-with-hints idle loop.
> 
> But two machines reported problems:
> 1. Certain Core2-era machines support MWAIT-C1 and HALT only.
>    MWAIT-C1 is preferred for optimal power and performance.
>    But if they support just C1, cpuidle never loads and
>    so they use the boot-time default idle loop forever.
> 
> 2. Some laptops will boot-hang if HALT is used,
>    but will boot successfully if MWAIT is used.
>    This appears to be a hidden assumption in BIOS SMI,
>    that is presumably valid on the proprietary OS
>    where the BIOS was validated.
> 
>    https://bugzilla.kernel.org/show_bug.cgi?id=60770
> 
> So here we effectively revert the patch above, restoring
> the mwait_idle() loop.  However, we don't bother restoring
> the idle=mwait cmdline parameter, since it appears to add
> no value.
> 
> Maintainer notes:
> For 3.9, simply revert 69fb3676df
> for 3.10, patch -F3 applies, fuzz needed due to __cpuinit use in context
> For 3.11, 3.12, 3.13, this patch applies cleanly
> 
> Mike: add clflush barriers and resched IPI avoidance.

Mike,

The changes for clflush don't build prior to 3.17-rcX;
X86_BUG_CLFLUSH_MONITOR was X86_FEATURE_CLFLUSH_MONITOR prior to
commit 9b13a93df267af681a66a6a738bf1af10102da7d,
'x86, cpufeature: Convert more "features" to bugs'.

Len,

FWIW, I tested this patch on a dual-socket Xeon E5420, and nothing died :)
The change in core temps was not statistically significant though,
and I don't have more accurate testing gear for monitoring cpu power
consumption.

Regards,
Peter Hurley


> Cc: Mike Galbraith <bitbucket@online.de>
> Cc: Ian Malone <ibmalone@gmail.com>
> Cc: Josh Boyer <jwboyer@redhat.com>
> Cc: <stable@vger.kernel.org> # 3.9, 3.10, 3.11, 3.12, 3.13
> Signed-off-by: Len Brown <len.brown@intel.com>
> Signed-off-by: Mike Galbraith <bitbucket@online.de>
> ---
>  arch/x86/include/asm/mwait.h |    8 ++++++
>  arch/x86/kernel/process.c    |   50 +++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 58 insertions(+)
> 
> --- a/arch/x86/include/asm/mwait.h
> +++ b/arch/x86/include/asm/mwait.h
> @@ -30,6 +30,14 @@ static inline void __mwait(unsigned long
>  		     :: "a" (eax), "c" (ecx));
>  }
>  
> +static inline void __sti_mwait(unsigned long eax, unsigned long ecx)
> +{
> +	trace_hardirqs_on();
> +	/* "mwait %eax, %ecx;" */
> +	asm volatile("sti; .byte 0x0f, 0x01, 0xc9;"
> +		     :: "a" (eax), "c" (ecx));
> +}
> +
>  /*
>   * This uses new MONITOR/MWAIT instructions on P4 processors with PNI,
>   * which can obviate IPI to trigger checking of need_resched.
> --- a/arch/x86/kernel/process.c
> +++ b/arch/x86/kernel/process.c
> @@ -28,6 +28,7 @@
>  #include <asm/fpu-internal.h>
>  #include <asm/debugreg.h>
>  #include <asm/nmi.h>
> +#include <asm/mwait.h>
>  
>  /*
>   * per-CPU TSS segments. Threads are completely 'soft' on Linux,
> @@ -396,6 +397,52 @@ static void amd_e400_idle(void)
>  		default_idle();
>  }
>  
> +/*
> + * Intel Core2 and older machines prefer MWAIT over HALT for C1.
> + * We can't rely on cpuidle installing MWAIT, because it will not load
> + * on systems that support only C1 -- so the boot default must be MWAIT.
> + *
> + * Some AMD machines are the opposite, they depend on using HALT.
> + *
> + * So for default C1, which is used during boot until cpuidle loads,
> + * use MWAIT-C1 on Intel HW that has it, else use HALT.
> + */
> +static int prefer_mwait_c1_over_halt(const struct cpuinfo_x86 *c)
> +{
> +	if (c->x86_vendor != X86_VENDOR_INTEL)
> +		return 0;
> +
> +	if (!cpu_has(c, X86_FEATURE_MWAIT))
> +		return 0;
> +
> +	return 1;
> +}
> +
> +/*
> + * MONITOR/MWAIT with no hints, used for default default C1 state.
> + * This invokes MWAIT with interrutps enabled and no flags,
> + * which is backwards compatible with the original MWAIT implementation.
> + */
> +
> +static void mwait_idle(void)
> +{
> +	if (!current_set_polling_and_test()) {
> +		if (static_cpu_has_bug(X86_BUG_CLFLUSH_MONITOR)) {
> +			mb();
> +			clflush((void *)&current_thread_info()->flags);
> +			mb();
> +		}
> +
> +		__monitor((void *)&current_thread_info()->flags, 0, 0);
> +		if (!need_resched())
> +			__sti_mwait(0, 0);
> +		else
> +			local_irq_enable();
> +	} else
> +		local_irq_enable();
> +	current_clr_polling();
> +}
> +
>  void select_idle_routine(const struct cpuinfo_x86 *c)
>  {
>  #ifdef CONFIG_SMP
> @@ -409,6 +456,9 @@ void select_idle_routine(const struct cp
>  		/* E400: APIC timer interrupt does not wake up CPU from C1e */
>  		pr_info("using AMD E400 aware idle routine\n");
>  		x86_idle = amd_e400_idle;
> +	} else if (prefer_mwait_c1_over_halt(c)) {
> +		pr_info("using mwait in idle threads\n");
> +		x86_idle = mwait_idle;
>  	} else
>  		x86_idle = default_idle;
>  }


