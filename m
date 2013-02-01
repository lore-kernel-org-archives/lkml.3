Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757537Ab3BAVDj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 16:03:39 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:19115 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757463Ab3BAVDg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 16:03:36 -0500
X-Authority-Analysis: v=2.0 cv=bJmU0YCZ c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=_-1zCJSF_OMA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=vw99MyFtH44A:10 a=x30EXVXcAAAA:8 a=yfaZswo77PCnbOibShsA:9 a=PUjeQqilurYA:10 a=2F0HLYTCHDIA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1359752614.5642.49.camel@gandalf.local.home>
Subject: Re: [RFC][PATCH v8 2/3] trace,x86: add x86 irq vector tracepoints
From: Steven Rostedt <rostedt@goodmis.org>
To: Seiji Aguchi <seiji.aguchi@hds.com>
Cc: "x86@kernel.org" <x86@kernel.org>,
        "H. Peter Anvin (hpa@zytor.com)" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Thomas Gleixner (tglx@linutronix.de)" <tglx@linutronix.de>,
        "'mingo@elte.hu' (mingo@elte.hu)" <mingo@elte.hu>,
        "Borislav Petkov (bp@alien8.de)" <bp@alien8.de>,
        Satoru Moriya <satoru.moriya@hds.com>,
        "dle-develop@lists.sourceforge.net" 
	<dle-develop@lists.sourceforge.net>,
        "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
        "Luck, Tony (tony.luck@intel.com)" <tony.luck@intel.com>
Date: Fri, 01 Feb 2013 16:03:34 -0500
In-Reply-To: <A5ED84D3BB3A384992CBB9C77DEDA4D414A508CE@USINDEM103.corp.hds.com>
References: <A5ED84D3BB3A384992CBB9C77DEDA4D414A508CE@USINDEM103.corp.hds.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-01-21 at 22:14 +0000, Seiji Aguchi wrote:

> --- /dev/null
> +++ b/arch/x86/kernel/tracepoint.c
> @@ -0,0 +1,61 @@
> +/*
> + * Code for supporting irq vector tracepoints.
> + *
> + * Copyright (C) 2013 Seiji Aguchi <seiji.aguchi@hds.com>
> + *
> + */
> +#include <asm/hw_irq.h>
> +#include <asm/desc.h>
> +
> +static struct desc_ptr trace_idt_descr = { NR_VECTORS * 16 - 1,
> +				    (unsigned long) trace_idt_table };
> +
> +#ifndef CONFIG_X86_64
> +gate_desc trace_idt_table[NR_VECTORS] __page_aligned_data
> +					= { { { { 0, 0 } } }, };
> +#endif
> +
> +static struct desc_ptr orig_idt_descr[NR_CPUS];

BTW, this should be:

static DEFINE_PER_CPU(struct desc_ptr, orig_idt_descr);

And look at the patch I made about the NMI/DEBUG trap handling to see
how to use it.

Thanks,

-- Steve

> +static int trace_irq_vector_refcount;
> +
> +static void switch_to_trace_idt(void *arg)
> +{
> +	store_idt(&orig_idt_descr[smp_processor_id()]);
> +	load_idt(&trace_idt_descr);
> +
> +	return;
> +}
> +
> +static void restore_original_idt(void *arg)
> +{
> +	if (orig_idt_descr[smp_processor_id()].address) {
> +		load_idt(&orig_idt_descr[smp_processor_id()]);
> +		memset(&orig_idt_descr[smp_processor_id()], 0,
> +		       sizeof(struct desc_ptr));
> +	}
> +
> +	return;
> +}
> +
> +void trace_irq_vector_regfunc(void)
> +{
> +	if (!trace_irq_vector_refcount) {
> +		smp_call_function(switch_to_trace_idt, NULL, 0);
> +		local_irq_disable();
> +		switch_to_trace_idt(NULL);
> +		local_irq_enable();
> +	}
> +	trace_irq_vector_refcount++;
> +}
> +
> +void trace_irq_vector_unregfunc(void)
> +{
> +	trace_irq_vector_refcount--;
> +	if (!trace_irq_vector_refcount) {
> +		smp_call_function(restore_original_idt, NULL, 0);
> +		local_irq_disable();
> +		restore_original_idt(NULL);
> +		local_irq_enable();
> +	}
> +}
> +
> diff --git a/include/xen/events.h b/include/xen/events.h
> index c6bfe01..9216d07 100644
> --- a/include/xen/events.h
> +++ b/include/xen/events.h
> @@ -76,6 +76,9 @@ unsigned irq_from_evtchn(unsigned int evtchn);
>  
>  /* Xen HVM evtchn vector callback */
>  void xen_hvm_callback_vector(void);
> +#ifdef CONFIG_TRACING
> +#define trace_xen_hvm_callback_vector xen_hvm_callback_vector
> +#endif
>  extern int xen_have_vector_callback;
>  int xen_set_callback_via(uint64_t via);
>  void xen_evtchn_do_upcall(struct pt_regs *regs);


