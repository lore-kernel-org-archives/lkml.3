Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758766Ab3FCXxI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 19:53:08 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:26659 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754821Ab3FCXxF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 19:53:05 -0400
X-Authority-Analysis: v=2.0 cv=fZsvOjsF c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=8UkHzMSrflQA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=ITzkURZ2-D4A:10 a=X_fZRB_91hZS_PbnhDYA:9 a=QEXdDO2ut3YA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1370303581.26799.109.camel@gandalf.local.home>
Subject: Re: [PATCH v13 3/3] trace,x86: Add irq vector tracepoints
From: Steven Rostedt <rostedt@goodmis.org>
To: Seiji Aguchi <seiji.aguchi@hds.com>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, hpa@zytor.com,
        tglx@linutronix.de, mingo@elte.hu, bp@alien8.de,
        linux-edac@vger.kernel.org, tony.luck@intel.com,
        dle-develop@lists.sourceforge.net, tomoki.sekiyama@hds.com
Date: Mon, 03 Jun 2013 19:53:01 -0400
In-Reply-To: <51ACEEB4.1010302@hds.com>
References: <51ACEDBB.6040706@hds.com> <51ACEEB4.1010302@hds.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-06-03 at 15:29 -0400, Seiji Aguchi wrote:

Yeah, I believe this does work. But you probably should add a comment
like the following:

/*
 * The current_idt_descr_ptr can only be set out of interrupt context
 * to avoid races. Once set, the load_current_idt() is called by
interrupt
 * context either by NMI, debug, or via a smp_call_function(). That way
 * the IDT will always be set back to the expected descriptor.
 */
>  
> +extern atomic_long_t current_idt_descr_ptr;
> +static inline void load_current_idt(void)
> +{
> +	if (atomic_long_read(&current_idt_descr_ptr))

Also, we should probably add here:
		unsigned long new_idt = atomic_long_read(&current_idt_descr_ptr);

		if (WARN_ON_ONCE(!validate_idt(new_idt))
			return;
		load_idt((const struct desc_ptr *)new_idt);

> +		load_idt((const struct desc_ptr *)
> +			 atomic_long_read(&current_idt_descr_ptr));
> +	else
> +		load_idt((const struct desc_ptr *)&idt_descr);
> +}
> +

Then have 

bool validate_idt(unsigned long idt)
{
	switch(idt) {
	case (unsigned long)&trace_idt_descr:
	case (unsigned long)&idt_descr:
		return 0;
	}
	return -1;
}

This way we wont be opening up any easy root holes where if a process
finds a way to modify some arbitrary kernel memory, we can prevent it
from modifying the current_idt_descr_ptr and have a nice way to exploit
the IDT. Sure, one can argue that if they can modify arbitrary kernel
memory, we may already be lost, but lets not make it easier for them
than need be.

-- Steve


