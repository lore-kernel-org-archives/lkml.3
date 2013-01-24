Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752301Ab3AXIs0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 03:48:26 -0500
Received: from nat28.tlf.novell.com ([130.57.49.28]:41668 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751716Ab3AXIsU convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:10:1>);
	Thu, 24 Jan 2013 03:48:20 -0500
Message-Id: <5101035D02000078000B8FFD@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.1 
Date: Thu, 24 Jan 2013 08:48:13 +0000
From: "Jan Beulich" <JBeulich@suse.com>
To: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: <olaf@aepfle.de>, <bp@alien8.de>, <apw@canonical.com>, <x86@kernel.org>,
        <tglx@linutronix.de>, <devel@linuxdriverproject.org>,
        <gregkh@linuxfoundation.org>, <jasowang@redhat.com>,
        <linux-kernel@vger.kernel.org>, <hpa@zytor.com>
Subject: Re: [PATCH RESEND 1/1] X86: Handle Hyper-V vmbus interrupts as
 special hypervisor interrupts
References: <1358990259-22551-1-git-send-email-kys@microsoft.com>
In-Reply-To: <1358990259-22551-1-git-send-email-kys@microsoft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 24.01.13 at 02:17, "K. Y. Srinivasan" <kys@microsoft.com> wrote:
> @@ -69,6 +74,11 @@ static void __init ms_hyperv_init_platform(void)
>  	       ms_hyperv.features, ms_hyperv.hints);
>  
>  	clocksource_register_hz(&hyperv_cs, NSEC_PER_SEC/100);
> +
> +	/*
> +	 * Setup the IDT for hypervisor callback.
> +	 */
> +	alloc_intr_gate(HYPERVISOR_CALLBACK_VECTOR, hyperv_callback_vector);

Isn't doing this unconditionally here as problematic as the call to
clocksource_register_hz() turned out to be when Xen's Hyper-V
shim reacts to the CPUID inquiry above?

> @@ -77,3 +87,32 @@ const __refconst struct hypervisor_x86 x86_hyper_ms_hyperv = {
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
> +#ifdef CONFIG_X86
> +	exit_idle();
> +#endif

This being in a file underneath arch/x86 - why the conditional?

Jan

