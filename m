Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757128Ab3JKIeX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 04:34:23 -0400
Received: from lgeamrelo02.lge.com ([156.147.1.126]:55096 "EHLO
	LGEAMRELO02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752139Ab3JKIeU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 04:34:20 -0400
X-AuditID: 9c93017e-b7c75ae00000230e-53-5257b80b9c9e
From: Namhyung Kim <namhyung@kernel.org>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: Re: [RFC/PATCH] ftrace: add set_graph_notrace filter
References: <1378184708-31385-1-git-send-email-namhyung@kernel.org>
	<20131011001717.26b92150@gandalf.local.home>
	<20131011072156.GC4154@osiris>
Date: Fri, 11 Oct 2013 17:34:19 +0900
In-Reply-To: <20131011072156.GC4154@osiris> (Heiko Carstens's message of "Fri,
	11 Oct 2013 09:21:56 +0200")
Message-ID: <871u3scik4.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Heiko,

On Fri, 11 Oct 2013 09:21:56 +0200, Heiko Carstens wrote:
> On Fri, Oct 11, 2013 at 12:17:17AM -0400, Steven Rostedt wrote:
>> Isn't there a way we could pass the state? Hmm, I think we could use
>> depth to do that. As depth is a pointer to trace.depth and not used
>> before then. We could make it negative and then check that.
>> 
>> /me looks at other archs.
>> 
>> Darn it, s390 calls ftrace_push_return_trace() before
>> ftrace_graph_entry(). They got fancy, as they must have noticed that
>> trace.depth is set by ftrace_push_return_trace() and they just figured
>> to let the ftrace_push_return_trace() do the work.
>> 
>> Hmm, we could add a config to do the check on one side or the other
>> depending on how the arch handles it.
>> 
>> It needs to be well commented though.
>
> I don't remember I why decided to do that more than four years ago, however
> on the other hand I really don't think we need a config for this.
> So I just committed the patch below... it compiles and doesn't crash
> immediately, so must be good.
> It will be merged during the next merge window.

Nice!

>
> From 8c539d10400ee2efe000d324497a0661a2143dbf Mon Sep 17 00:00:00 2001
> From: Heiko Carstens <heiko.carstens@de.ibm.com>
> Date: Fri, 11 Oct 2013 08:55:57 +0200
> Subject: [PATCH] s390/ftrace: prepare_ftrace_return() function call order
>
> Steven Rostedt noted that s390 is the only architecture which calls
> ftrace_push_return_trace() before ftrace_graph_entry() and therefore has
> the small advantage that trace.depth gets initialized automatically.

Well, this is not true.  AFAICS arm, x86 and powerpc have same order, and
other archs have different (inverted) order.  And it'd really great if
all archs agreed on a single ordering.

Thanks,
Namhyung

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
>  	parent = (unsigned long) return_to_handler;
>  out:
>  	return parent;
