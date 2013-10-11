Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757842Ab3JKMWM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 08:22:12 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:9409 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752338Ab3JKMWL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 08:22:11 -0400
Date: Fri, 11 Oct 2013 08:22:04 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Namhyung Kim <namhyung@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: Re: [RFC/PATCH] ftrace: add set_graph_notrace filter
Message-ID: <20131011082204.5c6de75d@gandalf.local.home>
In-Reply-To: <20131011072156.GC4154@osiris>
References: <1378184708-31385-1-git-send-email-namhyung@kernel.org>
	<20131011001717.26b92150@gandalf.local.home>
	<20131011072156.GC4154@osiris>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 Oct 2013 09:21:56 +0200
Heiko Carstens <heiko.carstens@de.ibm.com> wrote:

> 
> Steven Rostedt noted that s390 is the only architecture which calls
> ftrace_push_return_trace() before ftrace_graph_entry() and therefore has

I don't know if s390 is the only arch. I didn't finish reading all the
arch specific code to make sure.

> the small advantage that trace.depth gets initialized automatically.
> 
> However this small advantage isn't worth the difference and possible subtle
> breakage that may result from this.
> So change s390 to have the same function call order like all other
> architectures: first ftrace_graph_entry(), then ftrace_push_return_trace()
> 
> Reported-by: Steven Rostedt <rostedt@goodmis.org>
> Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
> ---
>  arch/s390/kernel/ftrace.c | 9 ++++-----
>  1 file changed, 4 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/s390/kernel/ftrace.c b/arch/s390/kernel/ftrace.c
> index 1014ad5..224db03 100644
> --- a/arch/s390/kernel/ftrace.c
> +++ b/arch/s390/kernel/ftrace.c
> @@ -151,14 +151,13 @@ unsigned long __kprobes prepare_ftrace_return(unsigned long parent,
>  	if (unlikely(atomic_read(&current->tracing_graph_pause)))
>  		goto out;
>  	ip = (ip & PSW_ADDR_INSN) - MCOUNT_INSN_SIZE;
> -	if (ftrace_push_return_trace(parent, ip, &trace.depth, 0) == -EBUSY)
> -		goto out;
>  	trace.func = ip;
> +	trace.depth = current->curr_ret_stack + 1;
>  	/* Only trace if the calling function expects to. */
> -	if (!ftrace_graph_entry(&trace)) {
> -		current->curr_ret_stack--;
> +	if (!ftrace_graph_entry(&trace))
> +		goto out;
> +	if (ftrace_push_return_trace(parent, ip, &trace.depth, 0) == -EBUSY)
>  		goto out;
> -	}

Hmm, if this code is so identical among the archs, I may create a
generic inline function to do the work. That way any change to the flow
can be done for all archs in one place.

Thanks!

-- Steve

>  	parent = (unsigned long) return_to_handler;
>  out:
>  	return parent;

