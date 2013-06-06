Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753194Ab3FFTSX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 15:18:23 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:5085 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751818Ab3FFTSW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 15:18:22 -0400
X-Authority-Analysis: v=2.0 cv=fZsvOjsF c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=MWvAT0ojoM8A:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=ITzkURZ2-D4A:10 a=U7ibqblIsD4McFB2XyEA:9 a=QEXdDO2ut3YA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1370546299.9844.40.camel@gandalf.local.home>
Subject: Re: [PATCH v14 3/3] trace,x86: Add irq vector tracepoints
From: Steven Rostedt <rostedt@goodmis.org>
To: Seiji Aguchi <seiji.aguchi@hds.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, tglx@linutronix.de,
        mingo@elte.hu, bp@alien8.de, linux-edac@vger.kernel.org,
        tony.luck@intel.com, dle-develop@lists.sourceforge.net,
        tomoki.sekiyama@hds.com
Date: Thu, 06 Jun 2013 15:18:19 -0400
In-Reply-To: <51B0A9B4.4080703@hds.com>
References: <51B0A90F.7030309@hds.com> <51B0A9B4.4080703@hds.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-06-06 at 11:24 -0400, Seiji Aguchi wrote:

> --- a/arch/x86/include/asm/desc.h
> +++ b/arch/x86/include/asm/desc.h
> @@ -36,8 +36,8 @@ static inline void fill_ldt(struct desc_struct *desc, const struct user_desc *in
>  
>  extern struct desc_ptr idt_descr;
>  extern gate_desc idt_table[];
> -extern struct desc_ptr nmi_idt_descr;
> -extern gate_desc nmi_idt_table[];
> +extern struct desc_ptr debug_idt_descr;
> +extern gate_desc debug_idt_table[];
>  
>  struct gdt_page {
>  	struct desc_struct gdt[GDT_ENTRIES];
> @@ -316,7 +316,20 @@ static inline void set_nmi_gate(int gate, void *addr)
>  	gate_desc s;
>  
>  	pack_gate(&s, GATE_INTERRUPT, (unsigned long)addr, 0, 0, __KERNEL_CS);
> -	write_idt_entry(nmi_idt_table, gate, &s);
> +	write_idt_entry(debug_idt_table, gate, &s);
> +}
> +#endif
> +
> +#ifdef CONFIG_TRACING
> +extern struct desc_ptr trace_idt_descr;
> +extern gate_desc trace_idt_table[];
> +static inline void write_trace_idt_entry(int entry, const gate_desc *gate)
> +{
> +	write_idt_entry(trace_idt_table, entry, gate);
> +}
> +#else
> +static inline void write_trace_idt_entry(int entry, const gate_desc *gate)
> +{
>  }
>  #endif

Since we are basically down to cosmetic changes, can you make the
renames of these variables into a separate patch. As they are now more
about the debug IDT than a NMI idt, it should have been done before, and
is a separate change to what you are doing here.


>  
> @@ -331,6 +344,7 @@ static inline void _set_gate(int gate, unsigned type, void *addr,
>  	 * setup time
>  	 */
>  	write_idt_entry(idt_table, gate, &s);
> +	write_trace_idt_entry(gate, &s);
>  }
>  
>  /*
> @@ -360,12 +374,39 @@ static inline void alloc_system_vector(int vector)
>  	}
>  }
>  

-- Steve


