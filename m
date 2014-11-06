Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752484AbaKFWq3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 17:46:29 -0500
Received: from mail-pa0-f42.google.com ([209.85.220.42]:53848 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752359AbaKFWqG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 17:46:06 -0500
Message-ID: <545BFA2A.5010504@amacapital.net>
Date: Thu, 06 Nov 2014 14:46:02 -0800
From: Andy Lutomirski <luto@amacapital.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Ben Hutchings <ben@decadent.org.uk>, x86@kernel.org
CC: linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH] x86: Make x32 syscall support conditional on a kernel
 parameter
References: <1415245982.3398.53.camel@decadent.org.uk>
In-Reply-To: <1415245982.3398.53.camel@decadent.org.uk>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/05/2014 07:53 PM, Ben Hutchings wrote:
> Enabling x32 in a distribution default kernel increases its attack
> surface while providing no benefit to the vast majority of its users.
> No-one seems interested in regularly checking for vulnerabilities
> specific to x32 (at least no-one with a white hat).
> 
> Still, requiring a separate or custom configuration just to turn on
> x32 seems wasteful.  And the only differences on syscall entry are
> two instructions (mask out the x32 flag and compare the syscall
> number).
> 
> So pad the standard comparison with a nop and add a kernel parameter
> "syscall.x32" which controls whether this is replaced with the x32
> version at boot time.  Add a Kconfig parameter to set the default.
> 
> Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
> ---
> This is currently used in Debian, where x32 is an unofficial port that
> can be installed in parallel with amd64 (multiarch).  I acknowledge the
> patch is a bit hacky, e.g. it has several magic numbers.  I'm sending
> this to find out whether anything like this would be acceptable
> upstream.
> 
> Ben.
> 
>  Documentation/kernel-parameters.txt |  4 ++++
>  arch/x86/Kconfig                    |  8 +++++++
>  arch/x86/include/asm/elf.h          |  8 ++++++-
>  arch/x86/kernel/entry_64.S          | 26 ++++++++++++++++++----
>  arch/x86/kernel/syscall_64.c        | 43 +++++++++++++++++++++++++++++++++++++
>  5 files changed, 84 insertions(+), 5 deletions(-)
> 
> diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
> index 4c81a86..1e161b0 100644
> --- a/Documentation/kernel-parameters.txt
> +++ b/Documentation/kernel-parameters.txt
> @@ -3397,6 +3397,10 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
>  
>  	switches=	[HW,M68k]
>  
> +	syscall.x32=	[KNL,x86_64] Enable/disable use of x32 syscalls on
> +			an x86_64 kernel where CONFIG_X86_X32 is enabled.
> +			Default depends on CONFIG_X86_X32_DISABLED.
> +
>  	sysfs.deprecated=0|1 [KNL]
>  			Enable/disable old style sysfs layout for old udev
>  			on older distributions. When this option is enabled
> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> index ded8a67..9627922 100644
> --- a/arch/x86/Kconfig
> +++ b/arch/x86/Kconfig
> @@ -2455,6 +2455,14 @@ config X86_X32
>  	  elf32_x86_64 support enabled to compile a kernel with this
>  	  option set.
>  
> +config X86_X32_DISABLED
> +	bool "x32 ABI disabled by default"
> +	depends on X86_X32
> +	default n
> +	help
> +	  Disable the x32 ABI unless explicitly enabled using the
> +	  kernel paramter "syscall.x32=y".
> +
>  config COMPAT
>  	def_bool y
>  	depends on IA32_EMULATION || X86_X32
> diff --git a/arch/x86/include/asm/elf.h b/arch/x86/include/asm/elf.h
> index ca3347a..2a8b89a 100644
> --- a/arch/x86/include/asm/elf.h
> +++ b/arch/x86/include/asm/elf.h
> @@ -154,6 +154,12 @@ do {						\
>  
>  #else /* CONFIG_X86_32 */
>  
> +#ifdef CONFIG_X86_X32_ABI
> +extern bool x32_enabled;
> +#else
> +#define x32_enabled 0
> +#endif
> +
>  /*
>   * This is used to ensure we don't load something for the wrong architecture.
>   */
> @@ -162,7 +168,7 @@ do {						\
>  
>  #define compat_elf_check_arch(x)					\
>  	(elf_check_arch_ia32(x) ||					\
> -	 (IS_ENABLED(CONFIG_X86_X32_ABI) && (x)->e_machine == EM_X86_64))
> +	 (x32_enabled && (x)->e_machine == EM_X86_64))
>  
>  #if __USER32_DS != __USER_DS
>  # error "The following code assumes __USER32_DS == __USER_DS"
> diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
> index df088bb..50b265a 100644
> --- a/arch/x86/kernel/entry_64.S
> +++ b/arch/x86/kernel/entry_64.S
> @@ -414,8 +414,12 @@ system_call_fastpath:
>  #if __SYSCALL_MASK == ~0
>  	cmpq $__NR_syscall_max,%rax
>  #else
> -	andl $__SYSCALL_MASK,%eax
> -	cmpl $__NR_syscall_max,%eax
> +	.globl system_call_fast_compare
> +	.globl system_call_fast_compare_end
> +system_call_fast_compare:
> +	cmpq $511,%rax			/* x32 syscalls start at 512 */
> +	.byte P6_NOP4
> +system_call_fast_compare_end:
>  #endif
>  	ja ret_from_sys_call  /* and return regs->ax */
>  	movq %r10,%rcx
> @@ -520,8 +524,12 @@ tracesys_phase2:
>  #if __SYSCALL_MASK == ~0
>  	cmpq $__NR_syscall_max,%rax
>  #else
> -	andl $__SYSCALL_MASK,%eax
> -	cmpl $__NR_syscall_max,%eax
> +	.globl system_call_trace_compare
> +	.globl system_call_trace_compare_end
> +system_call_trace_compare:
> +	cmpq $511,%rax			/* x32 syscalls start at 512 */
> +	.byte P6_NOP4
> +system_call_trace_compare_end:

I think that, if x32 is disabled, that andl $__SYSCALL_MASK,%rax should
be nopped out.  Can this, and the comparison, use the standard
alternatives mechanism?

And why are there extra syscall numbers in x32 land?  There's an x32 bit
*and* extra numbers.  I'm confused.

That magic number is bad.  I would make it a real #define and put an
appropriate assertion into whatever generates syscalls_64.h.

Also, if you do this, can you change all four instances of %eax in there
to %rax?  %eax is just wrong AFAICT.

Also, as a heads up to anyone who actually uses this: I was confused
about the audit situation on x32-enabled kernels.  I thought that this
patch had been applied:

https://www.redhat.com/archives/linux-audit/2014-May/msg00099.html

but it wasn't.  As a result, the commit message for this fix is wrong:

81f49a8fd708 x86, x32, audit: Fix x32's AUDIT_ARCH wrt audit

It *is* a user-visible fix and should possibly go to -stable, especially
if anyone actually uses this *!$@ thing.  Of course, audit is royally
screwed up on x32-enabled kernels anyway.  I admit that I find myself
barely caring.

--Andy
