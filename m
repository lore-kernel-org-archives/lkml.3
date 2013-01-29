Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755099Ab3A2QhD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 11:37:03 -0500
Received: from mx1.redhat.com ([209.132.183.28]:57188 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754484Ab3A2QhA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 11:37:00 -0500
Date: Tue, 29 Jan 2013 18:36:03 +0200
From: Gleb Natapov <gleb@redhat.com>
To: Emil Goode <emilgoode@gmail.com>
Cc: mtosatti@redhat.com, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        avi@redhat.com, mst@redhat.com, perex@perex.cz, tiwai@suse.de,
        crimsun@ubuntu.com, wfp5p@virginia.edu, peter.senna@gmail.com,
        x86@kernel.org, kvm@vger.kernel.org, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 1/3] x86: KVM: Fix warnings by returning bool
Message-ID: <20130129163603.GD627@redhat.com>
References: <1359304802-28240-1-git-send-email-emilgoode@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=cp1255
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <1359304802-28240-1-git-send-email-emilgoode@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 27, 2013 at 05:40:00PM +0100, Emil Goode wrote:
> The function pointer x2apic_available in struct hypervisor_x86 is
> supposed to point to functions that return bool. This patch changes
> the return type of the kvm_para_available function to bool.
> 
> Sparse warnings:
> 
> arch/x86/kernel/kvm.c:508:35: warning:
> 	incorrect type in initializer (different signedness)
> 	arch/x86/kernel/kvm.c:508:35:
> 	expected bool ( *x2apic_available )( ... )
> 	arch/x86/kernel/kvm.c:508:35:
> 	got int ( static inline [toplevel] *<noident> )( ... )
> 
> arch/x86/kernel/kvm.c:508:2: warning:
> 	initialization from incompatible pointer type [enabled by default]
> 
> arch/x86/kernel/kvm.c:508:2: warning:
> 	(near initialization for ‘x86_hyper_kvm.x2apic_available’)
> 	[enabled by default]
> 
The breakage was in tip x86/apic tree only and it was fixed by
3b4a505821 there.

> Signed-off-by: Emil Goode <emilgoode@gmail.com>
> ---
>  arch/x86/include/asm/kvm_para.h |    8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_para.h b/arch/x86/include/asm/kvm_para.h
> index 0be7039..695399f 100644
> --- a/arch/x86/include/asm/kvm_para.h
> +++ b/arch/x86/include/asm/kvm_para.h
> @@ -85,13 +85,13 @@ static inline long kvm_hypercall4(unsigned int nr, unsigned long p1,
>  	return ret;
>  }
>  
> -static inline int kvm_para_available(void)
> +static inline bool kvm_para_available(void)
>  {
>  	unsigned int eax, ebx, ecx, edx;
>  	char signature[13];
>  
>  	if (boot_cpu_data.cpuid_level < 0)
> -		return 0;	/* So we don't blow up on old processors */
> +		return false;	/* So we don't blow up on old processors */
>  
>  	if (cpu_has_hypervisor) {
>  		cpuid(KVM_CPUID_SIGNATURE, &eax, &ebx, &ecx, &edx);
> @@ -101,10 +101,10 @@ static inline int kvm_para_available(void)
>  		signature[12] = 0;
>  
>  		if (strcmp(signature, "KVMKVMKVM") == 0)
> -			return 1;
> +			return true;
>  	}
>  
> -	return 0;
> +	return false;
>  }
>  
>  static inline unsigned int kvm_arch_para_features(void)
> -- 
> 1.7.10.4

--
			Gleb.
