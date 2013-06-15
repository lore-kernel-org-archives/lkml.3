Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754132Ab3FORNn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Jun 2013 13:13:43 -0400
Received: from mail-qe0-f51.google.com ([209.85.128.51]:51478 "EHLO
	mail-qe0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751837Ab3FORNl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Jun 2013 13:13:41 -0400
Message-ID: <51BCA0BC.5080900@redhat.com>
Date: Sat, 15 Jun 2013 13:13:32 -0400
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: David Daney <ddaney.cavm@gmail.com>
CC: linux-mips@linux-mips.org, ralf@linux-mips.org, kvm@vger.kernel.org,
        Sanjay Lal <sanjayl@kymasys.com>, linux-kernel@vger.kernel.org,
        David Daney <david.daney@cavium.com>
Subject: Re: [PATCH 17/31] MIPS: Quit exposing Kconfig symbols in uapi headers.
References: <1370646215-6543-1-git-send-email-ddaney.cavm@gmail.com> <1370646215-6543-18-git-send-email-ddaney.cavm@gmail.com>
In-Reply-To: <1370646215-6543-18-git-send-email-ddaney.cavm@gmail.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 07/06/2013 19:03, David Daney ha scritto:
> From: David Daney <david.daney@cavium.com>
> 
> The kernel's struct pt_regs has many fields conditional on various
> Kconfig variables, we cannot be exporting this garbage to user-space.
> 
> Move the kernel's definition to asm/ptrace.h, and put a uapi only
> version in uapi/asm/ptrace.h gated by #ifndef __KERNEL__
> 
> Signed-off-by: David Daney <david.daney@cavium.com>
> ---
>  arch/mips/include/asm/ptrace.h      | 32 ++++++++++++++++++++++++++++++++
>  arch/mips/include/uapi/asm/ptrace.h | 17 ++---------------
>  2 files changed, 34 insertions(+), 15 deletions(-)
> 
> diff --git a/arch/mips/include/asm/ptrace.h b/arch/mips/include/asm/ptrace.h
> index a3186f2..5e6cd09 100644
> --- a/arch/mips/include/asm/ptrace.h
> +++ b/arch/mips/include/asm/ptrace.h
> @@ -16,6 +16,38 @@
>  #include <asm/isadep.h>
>  #include <uapi/asm/ptrace.h>
>  
> +/*
> + * This struct defines the way the registers are stored on the stack during a
> + * system call/exception. As usual the registers k0/k1 aren't being saved.
> + */
> +struct pt_regs {
> +#ifdef CONFIG_32BIT
> +	/* Pad bytes for argument save space on the stack. */
> +	unsigned long pad0[6];
> +#endif
> +
> +	/* Saved main processor registers. */
> +	unsigned long regs[32];
> +
> +	/* Saved special registers. */
> +	unsigned long cp0_status;
> +	unsigned long hi;
> +	unsigned long lo;
> +#ifdef CONFIG_CPU_HAS_SMARTMIPS
> +	unsigned long acx;
> +#endif
> +	unsigned long cp0_badvaddr;
> +	unsigned long cp0_cause;
> +	unsigned long cp0_epc;
> +#ifdef CONFIG_MIPS_MT_SMTC
> +	unsigned long cp0_tcstatus;
> +#endif /* CONFIG_MIPS_MT_SMTC */
> +#ifdef CONFIG_CPU_CAVIUM_OCTEON
> +	unsigned long long mpl[3];	  /* MTM{0,1,2} */
> +	unsigned long long mtp[3];	  /* MTP{0,1,2} */
> +#endif
> +} __aligned(8);
> +
>  struct task_struct;
>  
>  extern int ptrace_getregs(struct task_struct *child, __s64 __user *data);
> diff --git a/arch/mips/include/uapi/asm/ptrace.h b/arch/mips/include/uapi/asm/ptrace.h
> index 4d58d84..b26f7e3 100644
> --- a/arch/mips/include/uapi/asm/ptrace.h
> +++ b/arch/mips/include/uapi/asm/ptrace.h
> @@ -22,16 +22,12 @@
>  #define DSP_CONTROL	77
>  #define ACX		78
>  
> +#ifndef __KERNEL__
>  /*
>   * This struct defines the way the registers are stored on the stack during a
>   * system call/exception. As usual the registers k0/k1 aren't being saved.
>   */
>  struct pt_regs {
> -#ifdef CONFIG_32BIT
> -	/* Pad bytes for argument save space on the stack. */
> -	unsigned long pad0[6];
> -#endif
> -

Out of curiosity, how has this ever worked (and how will this work) on
32-bit arches? :)  I can see that maybe no one uses pt_regs beyond .lo,
but these are at the beginning.  Maybe for the uapi version you can use
the __mips__ preprocessor symbol?

Paolo

>  	/* Saved main processor registers. */
>  	unsigned long regs[32];
>  
> @@ -39,20 +35,11 @@ struct pt_regs {
>  	unsigned long cp0_status;
>  	unsigned long hi;
>  	unsigned long lo;
> -#ifdef CONFIG_CPU_HAS_SMARTMIPS
> -	unsigned long acx;
> -#endif
>  	unsigned long cp0_badvaddr;
>  	unsigned long cp0_cause;
>  	unsigned long cp0_epc;
> -#ifdef CONFIG_MIPS_MT_SMTC
> -	unsigned long cp0_tcstatus;
> -#endif /* CONFIG_MIPS_MT_SMTC */
> -#ifdef CONFIG_CPU_CAVIUM_OCTEON
> -	unsigned long long mpl[3];	  /* MTM{0,1,2} */
> -	unsigned long long mtp[3];	  /* MTP{0,1,2} */
> -#endif
>  } __attribute__ ((aligned (8)));
> +#endif /* __KERNEL__ */
>  
>  /* Arbitrarily choose the same ptrace numbers as used by the Sparc code. */
>  #define PTRACE_GETREGS		12
> 

