Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752757Ab3KKIaG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 03:30:06 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:56126 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751533Ab3KKI37 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 03:29:59 -0500
Date: Mon, 11 Nov 2013 09:29:55 +0100
From: Ingo Molnar <mingo@kernel.org>
To: hpa@zytor.com, linux-kernel@vger.kernel.org, seiji.aguchi@hds.com,
        tglx@linutronix.de, hpa@linux.intel.com
Cc: linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/trace] x86, trace: Add page fault tracepoints
Message-ID: <20131111082955.GB12405@gmail.com>
References: <52716E67.6090705@hds.com>
 <tip-d34603b07c4255b2b00a546d34f297ccd50ae4c6@git.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tip-d34603b07c4255b2b00a546d34f297ccd50ae4c6@git.kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* tip-bot for Seiji Aguchi <tipbot@zytor.com> wrote:

> Commit-ID:  d34603b07c4255b2b00a546d34f297ccd50ae4c6
> Gitweb:     http://git.kernel.org/tip/d34603b07c4255b2b00a546d34f297ccd50ae4c6
> Author:     Seiji Aguchi <seiji.aguchi@hds.com>
> AuthorDate: Wed, 30 Oct 2013 16:39:03 -0400
> Committer:  H. Peter Anvin <hpa@linux.intel.com>
> CommitDate: Fri, 8 Nov 2013 14:15:49 -0800
> 
> x86, trace: Add page fault tracepoints
> 
> This patch introduces page fault tracepoints to x86 architecture
> by switching IDT.
> 
>   Two events, for user and kernel spaces, are introduced at the beginning
>   of page fault handler for tracing.
> 
>   - User space event
>     There is a request of page fault event for user space as below.
> 
>     https://lkml.kernel.org/r/1368079520-11015-2-git-send-email-fdeslaur+()+gmail+!+com
>     https://lkml.kernel.org/r/1368079520-11015-1-git-send-email-fdeslaur+()+gmail+!+com
> 
>   - Kernel space event:
>     When we measure an overhead in kernel space for investigating performance
>     issues, we can check if it comes from the page fault events.
> 
> Signed-off-by: Seiji Aguchi <seiji.aguchi@hds.com>
> Link: http://lkml.kernel.org/r/52716E67.6090705@hds.com
> Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
> ---
>  arch/x86/include/asm/trace/exceptions.h | 52 +++++++++++++++++++++++++++++++++
>  arch/x86/mm/Makefile                    |  2 ++
>  arch/x86/mm/fault.c                     | 13 +++++++++
>  3 files changed, 67 insertions(+)
> 
> diff --git a/arch/x86/include/asm/trace/exceptions.h b/arch/x86/include/asm/trace/exceptions.h
> new file mode 100644
> index 0000000..86540c0
> --- /dev/null
> +++ b/arch/x86/include/asm/trace/exceptions.h
> @@ -0,0 +1,52 @@
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
> +		__field(		unsigned long, ip	)
> +		__field(		unsigned long, error_code )
> +	),
> +
> +	TP_fast_assign(
> +		__entry->address = address;
> +		__entry->ip = regs->ip;
> +		__entry->error_code = error_code;
> +	),
> +
> +	TP_printk("address=%pf ip=%pf error_code=0x%lx",
> +		  (void *)__entry->address, (void *)__entry->ip,
> +		  __entry->error_code) );
> +
> +#define DEFINE_PAGE_FAULT_EVENT(name)				\
> +DEFINE_EVENT_FN(x86_exceptions, name,				\
> +	TP_PROTO(unsigned long address,	struct pt_regs *regs,	\
> +		 unsigned long error_code),			\
> +	TP_ARGS(address, regs, error_code),			\
> +	trace_irq_vector_regfunc,				\
> +	trace_irq_vector_unregfunc);
> +
> +DEFINE_PAGE_FAULT_EVENT(user_page_fault);
> +DEFINE_PAGE_FAULT_EVENT(kernel_page_fault);

Nice!

It would be nice to change this to hierarchical naming:

   page_fault_user
   page_fault_kernel

I.e. the higher level concept named first and go to the left, details go 
to the right.

(That way x86_exceptions.page_fault_user has the names ordered correctly 
as well.)

Thanks,

	Ingo
