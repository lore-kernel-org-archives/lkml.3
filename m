Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760442Ab3GSMKo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 08:10:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60604 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760341Ab3GSMKm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 08:10:42 -0400
Message-ID: <51E92CAB.7020906@redhat.com>
Date: Fri, 19 Jul 2013 14:10:19 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Jason Wang <jasowang@redhat.com>
CC: gleb@redhat.com, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vadim Rozenfeld <vrozenfe@redhat.com>,
        "K. Y. Srinivasan" <kys@microsoft.com>
Subject: Re: [PATCH] x86: properly handle KVM emulation of hyperv
References: <1374229505-19470-1-git-send-email-jasowang@redhat.com>
In-Reply-To: <1374229505-19470-1-git-send-email-jasowang@redhat.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 19/07/2013 12:25, Jason Wang ha scritto:
> Recent kvm has some basic support of hyperv, this will cause the guest to
> identify itself running on top of hyperv instead of kvm which will disable kvm
> pv functionality. Solve this by check kvm para platform first and also check
> KVM_CPUID_SIGNATURE_NEXT which were set when kvm emulate hyperv.
> 
> Cc: Gleb Natapov <gleb@redhat.com>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Vadim Rozenfeld <vrozenfe@redhat.com>
> Cc: K. Y. Srinivasan <kys@microsoft.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: "H. Peter Anvin" <hpa@zytor.com>
> Signed-off-by: Jason Wang <jasowang@redhat.com>
> ---
>  arch/x86/include/asm/kvm_para.h      |   25 +++++++++++++++++--------
>  arch/x86/include/uapi/asm/kvm_para.h |    1 +
>  arch/x86/kernel/cpu/hypervisor.c     |    2 +-
>  3 files changed, 19 insertions(+), 9 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_para.h b/arch/x86/include/asm/kvm_para.h
> index 695399f..aa8f3a7 100644
> --- a/arch/x86/include/asm/kvm_para.h
> +++ b/arch/x86/include/asm/kvm_para.h
> @@ -85,22 +85,31 @@ static inline long kvm_hypercall4(unsigned int nr, unsigned long p1,
>  	return ret;
>  }
>  
> -static inline bool kvm_para_available(void)
> +static inline bool kvm_para_available_function(unsigned int function)
>  {
>  	unsigned int eax, ebx, ecx, edx;
>  	char signature[13];
>  
> +	cpuid(function, &eax, &ebx, &ecx, &edx);
> +	memcpy(signature + 0, &ebx, 4);
> +	memcpy(signature + 4, &ecx, 4);
> +	memcpy(signature + 8, &edx, 4);
> +	signature[12] = 0;
> +
> +	if (strcmp(signature, "KVMKVMKVM") == 0)
> +		return true;
> +
> +	return false;
> +}
> +
> +static inline bool kvm_para_available(void)
> +{
>  	if (boot_cpu_data.cpuid_level < 0)
>  		return false;	/* So we don't blow up on old processors */
>  
>  	if (cpu_has_hypervisor) {
> -		cpuid(KVM_CPUID_SIGNATURE, &eax, &ebx, &ecx, &edx);
> -		memcpy(signature + 0, &ebx, 4);
> -		memcpy(signature + 4, &ecx, 4);
> -		memcpy(signature + 8, &edx, 4);
> -		signature[12] = 0;
> -
> -		if (strcmp(signature, "KVMKVMKVM") == 0)
> +		if (kvm_para_available_function(KVM_CPUID_SIGNATURE) ||
> +		    kvm_para_available_function(KVM_CPUID_SIGNATURE_NEXT))
>  			return true;
>  	}

Nice catch.  Just one small thing, you should loop until 0x40010000, as
done in arch/x86/include/asm/xen/hypervisor.h, in case one day a third
hypervisor implements three extensions (Hyper-V, KVM and its own set).

Paolo

