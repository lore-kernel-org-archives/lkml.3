Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932794Ab3GWNtH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 09:49:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36192 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757510Ab3GWNtF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 09:49:05 -0400
Date: Tue, 23 Jul 2013 16:48:55 +0300
From: Gleb Natapov <gleb@redhat.com>
To: Jason Wang <jasowang@redhat.com>
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        pbonzini@redhat.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] x86: introduce hypervisor_cpuid_base()
Message-ID: <20130723134855.GA6029@redhat.com>
References: <1374572465-15278-1-git-send-email-jasowang@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1374572465-15278-1-git-send-email-jasowang@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 23, 2013 at 05:41:02PM +0800, Jason Wang wrote:
> This patch introduce hypervisor_cpuid_base() which loop test the hypervisor
> existence function until the signature match and check the number of leaves if
> required. This could be used by Xen/KVM guest to detect the existence of
> hypervisor.
> 
Looks good to me.

Since this touches common code, kvm and xen I expect this to be taken
via the tip tree, correct?

> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: "H. Peter Anvin" <hpa@zytor.com>
> Cc: "Paolo Bonzini" <pbonzini@redhat.com>
> Cc: Gleb Natapov <gleb@redhat.com>
> Cc: x86@kernel.org
> Signed-off-by: Jason Wang <jasowang@redhat.com>
> ---
>  arch/x86/include/asm/processor.h |   20 ++++++++++++++++++++
>  1 files changed, 20 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
> index 24cf5ae..a8136d0 100644
> --- a/arch/x86/include/asm/processor.h
> +++ b/arch/x86/include/asm/processor.h
> @@ -971,6 +971,26 @@ unsigned long calc_aperfmperf_ratio(struct aperfmperf *old,
>  	return ratio;
>  }
>  
> +static inline uint32_t hypervisor_cpuid_base(const char *sig, uint32_t leaves)
> +{
> +	uint32_t base, eax, ebx, ecx, edx;
> +	char signature[13];
> +
> +	for (base = 0x40000000; base < 0x40010000; base += 0x100) {
> +		cpuid(base, &eax, &ebx, &ecx, &edx);
> +		*(uint32_t *)(signature + 0) = ebx;
> +		*(uint32_t *)(signature + 4) = ecx;
> +		*(uint32_t *)(signature + 8) = edx;
> +		signature[12] = 0;
> +
> +		if (!strcmp(sig, signature) &&
> +		    (leaves == 0 || ((eax - base) >= leaves)))
> +			return base;
> +	}
> +
> +	return 0;
> +}
> +
>  extern unsigned long arch_align_stack(unsigned long sp);
>  extern void free_init_pages(char *what, unsigned long begin, unsigned long end);
>  
> -- 
> 1.7.1

--
			Gleb.
