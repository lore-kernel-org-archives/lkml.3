Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753542Ab3HVOQD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 10:16:03 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:2950 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752563Ab3HVOQA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 10:16:00 -0400
X-Authority-Analysis: v=2.0 cv=aqMw+FlV c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=A-pA2CLq-tIA:10 a=5SG0PmZfjMsA:10 a=kj9zAlcOel0A:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=KqF6K2BpPhUA:10 a=x30EXVXcAAAA:8 a=8CxoyVhc2cJKf4PcUR0A:9 a=CjuIK1q_8ugA:10 a=2F0HLYTCHDIA:10 a=zOKkMAa9M6Yre32m:21 a=RypF-ho35HIZraQ8:21 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Date: Thu, 22 Aug 2013 10:15:57 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Seiji Aguchi <seiji.aguchi@hds.com>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, hpa@zytor.com, mingo@elte.hu,
        bp@alien8.de, tglx@linutronix.de, fdeslaur@gmail.com,
        raphael.beamonte@gmail.com, dle-develop@lists.sourceforge.net,
        tomoki.sekiyama@hds.com
Subject: Re: [RFC][PATCH] Introduce page fault tracepoint
Message-ID: <20130822101557.2a6efae0@gandalf.local.home>
In-Reply-To: <51F843B1.4050609@hds.com>
References: <51F843B1.4050609@hds.com>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Jul 2013 18:52:33 -0400
Seiji Aguchi <seiji.aguchi@hds.com> wrote:

 /* IOAPIC */
>  #define IO_APIC_IRQ(x) (((x) >= NR_IRQS_LEGACY) || ((1<<(x)) & io_apic_irqs))
> diff --git a/arch/x86/include/asm/trace/exceptions.h b/arch/x86/include/asm/trace/exceptions.h
> new file mode 100644
> index 0000000..660fcf1
> --- /dev/null
> +++ b/arch/x86/include/asm/trace/exceptions.h
> @@ -0,0 +1,51 @@
> +#undef TRACE_SYSTEM
> +#define TRACE_SYSTEM exceptions
> +
> +#if !defined(_TRACE_PAGE_FAULT_H) || defined(TRACE_HEADER_MULTI_READ)
> +#define _TRACE_PAGE_FAULT_H
> +
> +#include <linux/tracepoint.h>
> +
> +extern void trace_irq_vector_regfunc(void);
> +extern void trace_irq_vector_unregfunc(void);
> +
> +DECLARE_EVENT_CLASS(x86_exceptions,
> +
> +	TP_PROTO(unsigned long address, struct pt_regs *regs,
> +		 unsigned long error_code),
> +
> +	TP_ARGS(address, regs, error_code),
> +
> +	TP_STRUCT__entry(
> +		__field(		unsigned long, address	)
> +		__field(		struct pt_regs *, regs	)
> +		__field(		unsigned long, error_code )
> +	),
> +
> +	TP_fast_assign(
> +		__entry->address = address;
> +		__entry->regs = regs;
> +		__entry->error_code = error_code;
> +	),
> +
> +	TP_printk("address=0x%lx regs=0x%p error_code=0x%lx",
> +		  __entry->address, __entry->regs, __entry->error_code) );

Printing the regs pointer is rather useless. This is specific for x86,
why not print the ip of where it happened and the faulting address
itself? Note, you only need to change the TP_printk() to do that. For
efficiency reasons, only pass in regs.

-- Steve
