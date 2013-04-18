Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967282Ab3DRPQn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 11:16:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34040 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966917Ab3DRPQm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 11:16:42 -0400
Date: Thu, 18 Apr 2013 17:17:48 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, olaf@aepfle.de, apw@canonical.com,
        jasowang@redhat.com, JBeulich@suse.com, hpa@zytor.com
Subject: Re: [PATCH 1/1] X86: Handle Xen emulation of Hyper-V more gracefully
Message-ID: <20130418141748.GA21146@redhat.com>
References: <1366299886-6399-1-git-send-email-kys@microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1366299886-6399-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 18, 2013 at 08:44:46AM -0700, K. Y. Srinivasan wrote:
> Install the Hyper-V specific interrupt handler only when needed. This would
> permit us to get rid of the Xen check. Note that when the vmbus drivers invokes
> the call to register its handler, we are sure to be running on Hyper-V.
> 
> Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>

Looks good to me, this will address the concern. FWIW

Acked-by: Michael S. Tsirkin <mst@redhat.com>

Any chance we can fast-path this patch into 3.9 so that we don't release
a kernel with hyper-v on Xen completely disabled?

> ---
>  arch/x86/kernel/cpu/mshyperv.c |   18 +++++-------------
>  1 files changed, 5 insertions(+), 13 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/mshyperv.c b/arch/x86/kernel/cpu/mshyperv.c
> index a7d26d8..8f4be53 100644
> --- a/arch/x86/kernel/cpu/mshyperv.c
> +++ b/arch/x86/kernel/cpu/mshyperv.c
> @@ -35,13 +35,6 @@ static bool __init ms_hyperv_platform(void)
>  	if (!boot_cpu_has(X86_FEATURE_HYPERVISOR))
>  		return false;
>  
> -	/*
> -	 * Xen emulates Hyper-V to support enlightened Windows.
> -	 * Check to see first if we are on a Xen Hypervisor.
> -	 */
> -	if (xen_cpuid_base())
> -		return false;
> -
>  	cpuid(HYPERV_CPUID_VENDOR_AND_MAX_FUNCTIONS,
>  	      &eax, &hyp_signature[0], &hyp_signature[1], &hyp_signature[2]);
>  
> @@ -82,12 +75,6 @@ static void __init ms_hyperv_init_platform(void)
>  
>  	if (ms_hyperv.features & HV_X64_MSR_TIME_REF_COUNT_AVAILABLE)
>  		clocksource_register_hz(&hyperv_cs, NSEC_PER_SEC/100);
> -#if IS_ENABLED(CONFIG_HYPERV)
> -	/*
> -	 * Setup the IDT for hypervisor callback.
> -	 */
> -	alloc_intr_gate(HYPERVISOR_CALLBACK_VECTOR, hyperv_callback_vector);
> -#endif
>  }
>  
>  const __refconst struct hypervisor_x86 x86_hyper_ms_hyperv = {
> @@ -103,6 +90,11 @@ static irq_handler_t vmbus_isr;
>  
>  void hv_register_vmbus_handler(int irq, irq_handler_t handler)
>  {
> +	/*
> +	 * Setup the IDT for hypervisor callback.
> +	 */
> +	alloc_intr_gate(HYPERVISOR_CALLBACK_VECTOR, hyperv_callback_vector);
> +
>  	vmbus_irq = irq;
>  	vmbus_isr = handler;
>  }
> -- 
> 1.7.4.1
