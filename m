Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754036Ab3IFQtj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Sep 2013 12:49:39 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:28982 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753710Ab3IFQth (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Sep 2013 12:49:37 -0400
X-Authority-Analysis: v=2.0 cv=V4T/IJbi c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=5u97P__wDp4A:10 a=5SG0PmZfjMsA:10 a=kj9zAlcOel0A:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=wwVyTIy_TgkA:10 a=x30EXVXcAAAA:8 a=xX3u5zqAvFF5Vm0ijvQA:9 a=CjuIK1q_8ugA:10 a=2F0HLYTCHDIA:10 a=bg6uiF8QNTDWW317:21 a=vw5g4ycSO8sMfzGf:21 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Date: Fri, 6 Sep 2013 12:49:35 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Seiji Aguchi <seiji.aguchi@hds.com>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, hpa@zytor.com, mingo@elte.hu,
        bp@alien8.de, tglx@linutronix.de, fdeslaur@gmail.com,
        raphael.beamonte@gmail.com, dle-develop@lists.sourceforge.net,
        tomoki.sekiyama@hds.com
Subject: Re: [PATCH v2] Introduce page fault tracepoint
Message-ID: <20130906124935.3b4aa870@gandalf.local.home>
In-Reply-To: <521781C7.3050906@hds.com>
References: <521781C7.3050906@hds.com>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 23 Aug 2013 11:37:43 -0400
Seiji Aguchi <seiji.aguchi@hds.com> wrote:


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
> +	TP_printk("address=0x%lx ip=0x%lx error_code=0x%lx",
> +		  __entry->address, __entry->regs->ip, __entry->error_code) );

This is sure to crash the kernel.

You just saved the address of a pointer to some task's stack in the
ring buffer. And then on output (which can happen a long time from when
it was recorded), you are dereferencing that same address!

That __entry->regs->ip *will* crash the kernel!

What you want is to save ip in the fast_assign:

	__entry->ip = regs->ip

And then print that. Never dereference a pointer directly from the ring
buffer unless it's a constant value (like a global string).

-- Steve


> +
