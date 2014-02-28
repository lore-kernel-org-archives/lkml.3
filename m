Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752749AbaB1PrU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 10:47:20 -0500
Received: from merlin.infradead.org ([205.233.59.134]:33436 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752287AbaB1PrU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 10:47:20 -0500
Date: Fri, 28 Feb 2014 16:47:08 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: linux-kernel@vger.kernel.org, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        "H. Peter Anvin" <hpa@zytor.com>, Seiji Aguchi <seiji.aguchi@hds.com>
Subject: Re: [PATCH] x86 trace: Fix page fault tracing bug
Message-ID: <20140228154708.GI9987@twins.programming.kicks-ass.net>
References: <1393601620-13117-1-git-send-email-jolsa@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1393601620-13117-1-git-send-email-jolsa@redhat.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 28, 2014 at 04:33:40PM +0100, Jiri Olsa wrote:

While I like the idea of just pushing up the CR2 read; the below does
the read too late still, exception_enter() also has a tracepoint in.

> @@ -1267,9 +1269,18 @@ dotraplinkage void __kprobes
>  trace_do_page_fault(struct pt_regs *regs, unsigned long error_code)
>  {
>  	enum ctx_state prev_state;
> +	unsigned long address;
>  
>  	prev_state = exception_enter();
> +
> +	/*
> +	 * The tracepoint processing could trigger another page
> +	 * fault (user space callchain reading) and destroy the
> +	 * original cr2 value, so read the faulting address now.
> +	 */
> +	address = read_cr2();
> +
>  	trace_page_fault_entries(regs, error_code);
> -	__do_page_fault(regs, error_code);
> +	__do_page_fault(regs, error_code, address);
>  	exception_exit(prev_state);
>  }
> -- 
> 1.7.11.7
> 
