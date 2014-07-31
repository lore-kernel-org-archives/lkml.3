Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751779AbaGaL5z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 07:57:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9724 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751470AbaGaL5D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 07:57:03 -0400
Message-ID: <53DA2EFA.9060602@redhat.com>
Date: Thu, 31 Jul 2014 13:56:42 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Andy Lutomirski <luto@amacapital.net>, kvm@vger.kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, "Theodore Ts'o" <tytso@mit.edu>,
        linux-kernel@vger.kernel.org, Kees Cook <keescook@chromium.org>,
        x86@kernel.org
CC: Daniel Borkmann <dborkman@redhat.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        Gleb Natapov <gleb@kernel.org>, bsd@redhat.com,
        Andrew Honig <ahonig@google.com>
Subject: Re: [PATCH v5 5/5] x86,kaslr: Use MSR_KVM_GET_RNG_SEED for KASLR
 if available
References: <cover.1406177531.git.luto@amacapital.net> <3aa0b464e9aba9609de4d4118e4be7526f6dbab9.1406177531.git.luto@amacapital.net>
In-Reply-To: <3aa0b464e9aba9609de4d4118e4be7526f6dbab9.1406177531.git.luto@amacapital.net>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 24/07/2014 06:57, Andy Lutomirski ha scritto:
> It's considerably better than any of the alternatives on KVM.
> 
> Rather than reinventing all of the cpu feature query code, this fixes
> native_cpuid to work in PIC objects.
> 
> I haven't combined it with boot/cpuflags.c's cpuid implementation:
> including asm/processor.h from boot/cpuflags.c results in a flood of
> unrelated errors, and fixing it might be messy.
> 
> Reviewed-by: Kees Cook <keescook@chromium.org>
> Signed-off-by: Andy Lutomirski <luto@amacapital.net>
> ---
>  arch/x86/boot/compressed/aslr.c  | 27 +++++++++++++++++++++++++++
>  arch/x86/include/asm/processor.h | 21 ++++++++++++++++++---
>  2 files changed, 45 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/boot/compressed/aslr.c b/arch/x86/boot/compressed/aslr.c
> index fc6091a..8583f0e 100644
> --- a/arch/x86/boot/compressed/aslr.c
> +++ b/arch/x86/boot/compressed/aslr.c
> @@ -5,6 +5,8 @@
>  #include <asm/archrandom.h>
>  #include <asm/e820.h>
>  
> +#include <uapi/asm/kvm_para.h>
> +
>  #include <generated/compile.h>
>  #include <linux/module.h>
>  #include <linux/uts.h>
> @@ -15,6 +17,22 @@
>  static const char build_str[] = UTS_RELEASE " (" LINUX_COMPILE_BY "@"
>  		LINUX_COMPILE_HOST ") (" LINUX_COMPILER ") " UTS_VERSION;
>  
> +static bool kvm_para_has_feature(unsigned int feature)
> +{
> +	u32 kvm_base;
> +	u32 features;
> +
> +	if (!has_cpuflag(X86_FEATURE_HYPERVISOR))
> +		return false;
> +
> +	kvm_base = hypervisor_cpuid_base("KVMKVMKVM\0\0\0", KVM_CPUID_FEATURES);
> +	if (!kvm_base)
> +		return false;
> +
> +	features = cpuid_eax(kvm_base | KVM_CPUID_FEATURES);
> +	return features & (1UL << feature);
> +}
> +
>  #define I8254_PORT_CONTROL	0x43
>  #define I8254_PORT_COUNTER0	0x40
>  #define I8254_CMD_READBACK	0xC0
> @@ -81,6 +99,15 @@ static unsigned long get_random_long(void)
>  		}
>  	}
>  
> +	if (kvm_para_has_feature(KVM_FEATURE_GET_RNG_SEED)) {
> +		u64 seed;
> +
> +		debug_putstr(" MSR_KVM_GET_RNG_SEED");
> +		rdmsrl(MSR_KVM_GET_RNG_SEED, seed);
> +		random ^= (unsigned long)seed;
> +		use_i8254 = false;
> +	}
> +
>  	if (has_cpuflag(X86_FEATURE_TSC)) {
>  		debug_putstr(" RDTSC");
>  		rdtscll(raw);
> diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
> index a4ea023..6096f3c 100644
> --- a/arch/x86/include/asm/processor.h
> +++ b/arch/x86/include/asm/processor.h
> @@ -189,10 +189,25 @@ static inline int have_cpuid_p(void)
>  static inline void native_cpuid(unsigned int *eax, unsigned int *ebx,
>  				unsigned int *ecx, unsigned int *edx)
>  {
> -	/* ecx is often an input as well as an output. */
> -	asm volatile("cpuid"
> +	/*
> +	 * This function can be used from the boot code, so it needs
> +	 * to avoid using EBX in constraints in PIC mode.
> +	 *
> +	 * ecx is often an input as well as an output.
> +	 */
> +	asm volatile(".ifnc %%ebx,%1 ; .ifnc %%rbx,%1           \n\t"
> +		     "movl  %%ebx,%1                            \n\t"
> +		     ".endif ; .endif                           \n\t"
> +		     "cpuid					\n\t"
> +		     ".ifnc %%ebx,%1 ; .ifnc %%rbx,%1           \n\t"
> +		     "xchgl %%ebx,%1                            \n\t"
> +		     ".endif ; .endif"
>  	    : "=a" (*eax),
> -	      "=b" (*ebx),
> +#if defined(__i386__) && defined(__PIC__)
> +	      "=r" (*ebx),	/* gcc won't let us use ebx */
> +#else
> +	      "=b" (*ebx),	/* ebx is okay */
> +#endif
>  	      "=c" (*ecx),
>  	      "=d" (*edx)
>  	    : "0" (*eax), "2" (*ecx)
> 

Acked-by: Paolo Bonzini <pbonzini@redhat.com>
