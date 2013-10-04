Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751641Ab3JDW1p (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 18:27:45 -0400
Received: from mail-we0-f181.google.com ([74.125.82.181]:58452 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750842Ab3JDW1o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 18:27:44 -0400
Date: Sat, 5 Oct 2013 00:27:36 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Andi Kleen <andi@firstfloor.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@kernel.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, peterz@infradead.org,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 6/6] x86: Allow disabling HW_BREAKPOINTS and PERF_EVENTS
Message-ID: <20131004222731.GA28647@localhost.localdomain>
References: <1380922788-23112-1-git-send-email-andi@firstfloor.org>
 <1380922788-23112-7-git-send-email-andi@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1380922788-23112-7-git-send-email-andi@firstfloor.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 04, 2013 at 02:39:48PM -0700, Andi Kleen wrote:
> From: Andi Kleen <ak@linux.intel.com>
> 
> As suggested by Ingo.
> 
> Make HW_BREAKPOINTS a config option. HW_BREAKPOINTS depends
> on perf. This allows disabling PERF_EVENTS for systems that
> don't need it (e.g. anything not used for development)
> 
> Disabling PERF_EVENTS saves over 700k of kernel text (~5% of my config)
> and significant data/bss:
> 
>    text	   data	    bss	    dec	    hex	filename
> 13692640	1922416	1478656	17093712	104d450	obj/vmlinux
> 12980092	1787544	1470464	16238100	 f7c614	obj-noperf/vmlinux
> 
> I didn't make it depend on CONFIG_EXPERT for now, as the system
> should be very usable even without it. To actually disable perf
> a couple of options depending on it need to be disabled, including
> KVM and HW_BREAKPOINTS.
> 
> Longer term it would be probably nice to have modular perf.

I'm personally not against the idea of allowing hw breakpoint support
to be disabled but hpa did not like much the idea. I must say he had
valid concerns though, see the thread of this patchset: https://lkml.org/lkml/2011/7/14/163

IMHO, a better solution would be to make the hw breakpoint subsystem work
without using perf.

I mean, perf should use the hw breakpoint, but hw breakpoint shouldn't use perf,
(in fact that's what we agreed on with hpa IIRC).
But right now there is a kind of circular dependency between both that makes
perf always built-in in x86. I'm all for solving that by making hw breakpoint independant
from perf, but I think Ingo had mixed feelings about doing it that way. And he had valid
concerns on that as well.

So we are a bit stuck :)

Also some comments below:

> 
> Cc: fweisbec@gmail.com
> Cc: peterz@infradead.org
> Signed-off-by: Andi Kleen <ak@linux.intel.com>
> ---
>  arch/x86/Kconfig         | 11 ++++++++---
>  arch/x86/kernel/Makefile |  3 ++-
>  arch/x86/kvm/Kconfig     |  1 +
>  3 files changed, 11 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> index c9d2b81..a8418ed 100644
> --- a/arch/x86/Kconfig
> +++ b/arch/x86/Kconfig
> @@ -67,9 +67,6 @@ config X86
>  	select HAVE_KERNEL_XZ
>  	select HAVE_KERNEL_LZO
>  	select HAVE_KERNEL_LZ4
> -	select HAVE_HW_BREAKPOINT
> -	select HAVE_MIXED_BREAKPOINTS_REGS

I really wish we stick the HAVE_*
Kconfig symbols to the simple role of expressing a
constant arch ability, not a variable user choice...

The user choice itself is CONFIG_HW_BREAKPOINT, the frontend,
which depends on the arch ability that is CONFIG_HAVE_HW_BREAKPOINT,
the backend.

ie, that's what I did in this patchset
https://lkml.org/lkml/2011/7/14/163

Thanks.


> -	select PERF_EVENTS
>  	select HAVE_PERF_EVENTS_NMI
>  	select HAVE_PERF_REGS
>  	select HAVE_PERF_USER_STACK_DUMP
> @@ -602,6 +599,14 @@ config SCHED_OMIT_FRAME_POINTER
>  
>  	  If in doubt, say "Y".
>  
> +config HW_BREAKPOINTS
> +	bool "Enable hardware breakpoints support"
> +	select HAVE_HW_BREAKPOINT
> +	select HAVE_MIXED_BREAKPOINTS_REGS
> +	---help---
> +	  Enable support for x86 hardware breakpoints for debuggers
> +	  and perf.  This will implicitly enable perf-events.
> +
>  menuconfig HYPERVISOR_GUEST
>  	bool "Linux guest support"
>  	---help---
> diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
> index a5408b9..1b09567 100644
> --- a/arch/x86/kernel/Makefile
> +++ b/arch/x86/kernel/Makefile
> @@ -31,7 +31,7 @@ obj-$(CONFIG_X86_64)	+= vsyscall_64.o
>  obj-$(CONFIG_X86_64)	+= vsyscall_emu_64.o
>  obj-y			+= bootflag.o e820.o
>  obj-y			+= pci-dma.o quirks.o topology.o kdebugfs.o
> -obj-y			+= alternative.o i8253.o pci-nommu.o hw_breakpoint.o
> +obj-y			+= alternative.o i8253.o pci-nommu.o
>  obj-y			+= tsc.o io_delay.o rtc.o
>  obj-y			+= pci-iommu_table.o
>  obj-y			+= resource.o
> @@ -73,6 +73,7 @@ obj-$(CONFIG_DOUBLEFAULT)	+= doublefault.o
>  obj-$(CONFIG_KGDB)		+= kgdb.o
>  obj-$(CONFIG_VM86)		+= vm86_32.o
>  obj-$(CONFIG_EARLY_PRINTK)	+= early_printk.o
> +obj-$(CONFIG_HW_BREAKPOINTS) 	+= hw_breakpoint.o
>  
>  obj-$(CONFIG_HPET_TIMER) 	+= hpet.o
>  obj-$(CONFIG_APB_TIMER)		+= apb_timer.o
> diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
> index a47a3e5..de4190a 100644
> --- a/arch/x86/kvm/Kconfig
> +++ b/arch/x86/kvm/Kconfig
> @@ -36,6 +36,7 @@ config KVM
>  	select TASKSTATS
>  	select TASK_DELAY_ACCT
>  	select PERF_EVENTS
> +	select HW_BREAKPOINTS
>  	select HAVE_KVM_MSI
>  	select HAVE_KVM_CPU_RELAX_INTERCEPT
>  	---help---
> -- 
> 1.8.3.1
> 
