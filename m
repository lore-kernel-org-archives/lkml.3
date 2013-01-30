Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753342Ab3A3I66 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 03:58:58 -0500
Received: from nat28.tlf.novell.com ([130.57.49.28]:55157 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752953Ab3A3I64 convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:10:1>);
	Wed, 30 Jan 2013 03:58:56 -0500
Message-Id: <5108EEDD02000078000BAA22@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.1 
Date: Wed, 30 Jan 2013 08:58:53 +0000
From: "Jan Beulich" <JBeulich@suse.com>
To: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: <olaf@aepfle.de>, <bp@alien8.de>, <apw@canonical.com>, <x86@kernel.org>,
        <tglx@linutronix.de>, <devel@linuxdriverproject.org>,
        <gregkh@linuxfoundation.org>, <jasowang@redhat.com>,
        <linux-kernel@vger.kernel.org>, <hpa@zytor.com>
Subject: Re: [PATCH 3/3] X86: Handle Hyper-V vmbus interrupts as
 special hypervisor interrupts
References: <1359507077-26050-1-git-send-email-kys@microsoft.com>
 <1359507108-26091-1-git-send-email-kys@microsoft.com>
 <1359507108-26091-3-git-send-email-kys@microsoft.com>
In-Reply-To: <1359507108-26091-3-git-send-email-kys@microsoft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 30.01.13 at 01:51, "K. Y. Srinivasan" <kys@microsoft.com> wrote:
> --- a/arch/x86/kernel/cpu/mshyperv.c
> +++ b/arch/x86/kernel/cpu/mshyperv.c
> @@ -14,10 +14,15 @@
>  #include <linux/time.h>
>  #include <linux/clocksource.h>
>  #include <linux/module.h>
> +#include <linux/hardirq.h>
> +#include <linux/interrupt.h>
>  #include <asm/processor.h>
>  #include <asm/hypervisor.h>
>  #include <asm/hyperv.h>
>  #include <asm/mshyperv.h>
> +#include <asm/desc.h>
> +#include <asm/idle.h>
> +#include <asm/irq_regs.h>
>  
>  struct ms_hyperv_info ms_hyperv;
>  EXPORT_SYMBOL_GPL(ms_hyperv);
> @@ -77,6 +82,12 @@ static void __init ms_hyperv_init_platform(void)
>  
>  	if (ms_hyperv.features & HV_X64_MSR_TIME_REF_COUNT_AVAILABLE)
>  		clocksource_register_hz(&hyperv_cs, NSEC_PER_SEC/100);
> +#if IS_ENABLED(CONFIG_HYPERV)
> +	/*
> +	 * Setup the IDT for hypervisor callback.
> +	 */
> +	alloc_intr_gate(HYPERVISOR_CALLBACK_VECTOR, hyperv_callback_vector);
> +#endif
>  }
>  
>  const __refconst struct hypervisor_x86 x86_hyper_ms_hyperv = {
> @@ -85,3 +96,30 @@ const __refconst struct hypervisor_x86 x86_hyper_ms_hyperv = {
>  	.init_platform		= ms_hyperv_init_platform,
>  };
>  EXPORT_SYMBOL(x86_hyper_ms_hyperv);
> +
> +static int vmbus_irq = -1;
> +static irq_handler_t vmbus_isr;
> +
> +void hv_register_vmbus_handler(int irq, irq_handler_t handler)
> +{
> +	vmbus_irq = irq;
> +	vmbus_isr = handler;
> +}
> +EXPORT_SYMBOL_GPL(hv_register_vmbus_handler);
> +
> +void hyperv_vector_handler(struct pt_regs *regs)
> +{
> +	struct pt_regs *old_regs = set_irq_regs(regs);
> +	struct irq_desc *desc;
> +
> +	irq_enter();
> +	exit_idle();
> +
> +	desc = irq_to_desc(vmbus_irq);
> +
> +	if (desc)
> +		generic_handle_irq_desc(vmbus_irq, desc);
> +
> +	irq_exit();
> +	set_irq_regs(old_regs);
> +}

This function appears to be dead code when !CONFIG_HYPERV,
because ...

> --- a/arch/x86/kernel/entry_32.S
> +++ b/arch/x86/kernel/entry_32.S
> @@ -1046,11 +1046,18 @@ ENTRY(xen_failsafe_callback)
>  	_ASM_EXTABLE(4b,9b)
>  ENDPROC(xen_failsafe_callback)
>  
> -BUILD_INTERRUPT3(xen_hvm_callback_vector, XEN_HVM_EVTCHN_CALLBACK,
> +BUILD_INTERRUPT3(xen_hvm_callback_vector, HYPERVISOR_CALLBACK_VECTOR,
>  		xen_evtchn_do_upcall)
>  
>  #endif	/* CONFIG_XEN */
>  
> +#if IS_ENABLED(CONFIG_HYPERV)
> +
> +BUILD_INTERRUPT3(hyperv_callback_vector, HYPERVISOR_CALLBACK_VECTOR,
> +	hyperv_vector_handler)
> +
> +#endif /* CONFIG_HYPERV */
> +
>  #ifdef CONFIG_FUNCTION_TRACER
>  #ifdef CONFIG_DYNAMIC_FTRACE
>  

... the consumers here and below are conditional.

I also wonder why arch/x86/kernel/cpu/mshyperv.c is being built
at all when !CONFIG_HYPERV (which would eliminate the need
for the conditional the patch adds to ms_hyperv_init_platform()).

Jan

> diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
> index d5113c3..c1d01e6 100644
> --- a/arch/x86/kernel/entry_64.S
> +++ b/arch/x86/kernel/entry_64.S
> @@ -1446,11 +1446,16 @@ ENTRY(xen_failsafe_callback)
>  	CFI_ENDPROC
>  END(xen_failsafe_callback)
>  
> -apicinterrupt XEN_HVM_EVTCHN_CALLBACK \
> +apicinterrupt HYPERVISOR_CALLBACK_VECTOR \
>  	xen_hvm_callback_vector xen_evtchn_do_upcall
>  
>  #endif /* CONFIG_XEN */
>  
> +#if IS_ENABLED(CONFIG_HYPERV)
> +apicinterrupt HYPERVISOR_CALLBACK_VECTOR \
> +	hyperv_callback_vector hyperv_vector_handler
> +#endif /* CONFIG_HYPERV */
> +
>  /*
>   * Some functions should be protected against kprobes
>   */


