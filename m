Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932526AbaBDUWC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 15:22:02 -0500
Received: from www.linutronix.de ([62.245.132.108]:49167 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932067AbaBDUV6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 15:21:58 -0500
Date: Tue, 4 Feb 2014 21:22:03 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Steven Rostedt <rostedt@goodmis.org>
cc: LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Subject: Re: [PATCH] x86: Use preempt_disable_notrace() in cycles_2_ns()
In-Reply-To: <20140204141315.2a968a72@gandalf.local.home>
Message-ID: <alpine.DEB.2.02.1402042121480.24986@ionos.tec.linutronix.de>
References: <20140204141315.2a968a72@gandalf.local.home>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 4 Feb 2014, Steven Rostedt wrote:

> When debug preempt is enabled, preempt_disable() can be traced by
> function and function graph tracing.
> 
> There's a place in the function graph tracer that calls trace_clock()
> which eventually calls cycles_2_ns() outside of the recursion
> protection. When cycles_2_ns() calls preempt_disable() it gets traced
> and the graph tracer will go into a recursive loop causing a crash or
> worse, a triple fault.
> 
> Simple fix is to use preempt_disable_notrace() in cycles_2_ns, which
> makes sense because the preempt_disable() tracing may use that code
> too, and it tracing it, even with recursion protection is rather
> pointless.
> 
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

Acked-by-me

> diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
> index 19e5adb..acb3b60 100644
> --- a/arch/x86/kernel/tsc.c
> +++ b/arch/x86/kernel/tsc.c
> @@ -209,7 +209,7 @@ static inline unsigned long long cycles_2_ns(unsigned long long cyc)
>  	 * dance when its actually needed.
>  	 */
>  
> -	preempt_disable();
> +	preempt_disable_notrace();
>  	data = this_cpu_read(cyc2ns.head);
>  	tail = this_cpu_read(cyc2ns.tail);
>  
> @@ -229,7 +229,7 @@ static inline unsigned long long cycles_2_ns(unsigned long long cyc)
>  		if (!--data->__count)
>  			this_cpu_write(cyc2ns.tail, data);
>  	}
> -	preempt_enable();
> +	preempt_enable_notrace();
>  
>  	return ns;
>  }
> 
