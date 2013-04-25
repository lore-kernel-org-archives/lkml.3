Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755278Ab3DYJAo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 05:00:44 -0400
Received: from ozlabs.org ([203.10.76.45]:47921 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754700Ab3DYJAm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 05:00:42 -0400
From: Michael Neuling <mikey@neuling.org>
To: Chen Gang <gang.chen@asianux.com>
cc: Mike Qiu <qiudayu@linux.vnet.ibm.com>,
        Michael Ellerman <michael@ellerman.id.au>,
        linuxppc-dev@lists.ozlabs.org, sfr@canb.auug.org.au, matt@ozlabs.org,
        linux-kernel@vger.kernel.org, paulus@samba.org,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH] PowerPC: kernel: compiling issue, make additional room in exception vector area
In-reply-to: <5178E6C3.4060603@asianux.com>
References: <5177965D.9090406@linux.vnet.ibm.com> <20130424083142.GB26834@concordia> <51779941.8080403@linux.vnet.ibm.com> <30651.1366799858@ale.ozlabs.ibm.com> <1366807638.5911.2.camel@localhost> <5178816D.3000309@asianux.com> <5178ABA2.4030109@linux.vnet.ibm.com> <5178E6C3.4060603@asianux.com>
Comments: In-reply-to Chen Gang <gang.chen@asianux.com>
   message dated "Thu, 25 Apr 2013 16:18:11 +0800."
X-Mailer: MH-E 8.2; nmh 1.5; GNU Emacs 23.4.1
Date: Thu, 25 Apr 2013 19:00:40 +1000
Message-ID: <1659.1366880440@ale.ozlabs.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chen Gang <gang.chen@asianux.com> wrote:

> 
> When CONFIG_KVM_BOOK3S_64_PR is enabled,
> MASKABLE_EXCEPTION_PSERIES(0x900 ...) will includes __KVMTEST, it will
> exceed 0x980 which STD_EXCEPTION_HV(0x980 ...) will use, it will cause
> compiling issue.
> 
> The related errors:
> arch/powerpc/kernel/exceptions-64s.S: Assembler messages:
> arch/powerpc/kernel/exceptions-64s.S:258: Error: attempt to move .org backwards
> make[1]: *** [arch/powerpc/kernel/head_64.o] Error 1

This doesn't work at all.  It might compile but it's never going to
actually work.

Comments below.

> 
> 
> Signed-off-by: Chen Gang <gang.chen@asianux.com>
> ---
>  arch/powerpc/include/asm/kvm_asm.h   |    2 +-
>  arch/powerpc/kernel/exceptions-64s.S |    6 +++---
>  2 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/powerpc/include/asm/kvm_asm.h b/arch/powerpc/include/asm/kvm_asm.h
> index b9dd382..2c65bae 100644
> --- a/arch/powerpc/include/asm/kvm_asm.h
> +++ b/arch/powerpc/include/asm/kvm_asm.h
> @@ -86,7 +86,7 @@
>  #define BOOK3S_INTERRUPT_PROGRAM	0x700
>  #define BOOK3S_INTERRUPT_FP_UNAVAIL	0x800
>  #define BOOK3S_INTERRUPT_DECREMENTER	0x900
> -#define BOOK3S_INTERRUPT_HV_DECREMENTER	0x980
> +#define BOOK3S_INTERRUPT_HV_DECREMENTER	0x988

This is hardwird in the architecture.. you can't just move it

>  #define BOOK3S_INTERRUPT_SYSCALL	0xc00
>  #define BOOK3S_INTERRUPT_TRACE		0xd00
>  #define BOOK3S_INTERRUPT_H_DATA_STORAGE	0xe00
> diff --git a/arch/powerpc/kernel/exceptions-64s.S b/arch/powerpc/kernel/exceptions-64s.S
> index e789ee7..bb0e677 100644
> --- a/arch/powerpc/kernel/exceptions-64s.S
> +++ b/arch/powerpc/kernel/exceptions-64s.S
> @@ -255,7 +255,7 @@ hardware_interrupt_hv:
>  	KVM_HANDLER_PR(PACA_EXGEN, EXC_STD, 0x800)
>  
>  	MASKABLE_EXCEPTION_PSERIES(0x900, 0x900, decrementer)
> -	STD_EXCEPTION_HV(0x980, 0x982, hdecrementer)
> +	STD_EXCEPTION_HV(0x988, 0x982, hdecrementer)

Same here

>  
>  	MASKABLE_EXCEPTION_PSERIES(0xa00, 0xa00, doorbell_super)
>  	KVM_HANDLER_PR(PACA_EXGEN, EXC_STD, 0xa00)
> @@ -698,7 +698,7 @@ machine_check_common:
>  
>  	STD_EXCEPTION_COMMON_ASYNC(0x500, hardware_interrupt, do_IRQ)
>  	STD_EXCEPTION_COMMON_ASYNC(0x900, decrementer, .timer_interrupt)
> -	STD_EXCEPTION_COMMON(0x980, hdecrementer, .hdec_interrupt)
> +	STD_EXCEPTION_COMMON(0x988, hdecrementer, .hdec_interrupt)

... and here

>  #ifdef CONFIG_PPC_DOORBELL
>  	STD_EXCEPTION_COMMON_ASYNC(0xa00, doorbell_super, .doorbell_exception)
>  #else
> @@ -802,7 +802,7 @@ hardware_interrupt_relon_hv:
>  	STD_RELON_EXCEPTION_PSERIES(0x4700, 0x700, program_check)
>  	STD_RELON_EXCEPTION_PSERIES(0x4800, 0x800, fp_unavailable)
>  	MASKABLE_RELON_EXCEPTION_PSERIES(0x4900, 0x900, decrementer)
> -	STD_RELON_EXCEPTION_HV(0x4980, 0x982, hdecrementer)
> +	STD_RELON_EXCEPTION_HV(0x4988, 0x982, hdecrementer)

... and here

>  	MASKABLE_RELON_EXCEPTION_PSERIES(0x4a00, 0xa00, doorbell_super)
>  	STD_RELON_EXCEPTION_PSERIES(0x4b00, 0xb00, trap_0b)
>  
> -- 
> 1.7.7.6
> 
