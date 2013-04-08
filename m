Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936855Ab3DHP6s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 11:58:48 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:13790 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936790Ab3DHP6o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 11:58:44 -0400
X-Authority-Analysis: v=2.0 cv=F+XVh9dN c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Nx0--Y5ztT8A:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=YNzZoMN0o1AA:10 a=20KFwNOVAAAA:8 a=4Wk4pbNsMDjp0sokTBEA:9 a=QEXdDO2ut3YA:10 a=jEp0ucaQiEUA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1365436722.25498.14.camel@gandalf.local.home>
Subject: Re: [PATCH 3/4] uprobes/tracing: Kill the pointless
 local_save_flags/preempt_count calls
From: Steven Rostedt <rostedt@goodmis.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Anton Arapov <anton@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org
Date: Mon, 08 Apr 2013 11:58:42 -0400
In-Reply-To: <20130329181545.GA20697@redhat.com>
References: <20130329181545.GA20697@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-03-29 at 19:15 +0100, Oleg Nesterov wrote:
> uprobe_trace_func() is never called with irqs or preemption
> disabled, no need to ask preempt_count() or local_save_flags().
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>
> ---
>  kernel/trace/trace_uprobe.c |   10 +++-------
>  1 files changed, 3 insertions(+), 7 deletions(-)
> 
> diff --git a/kernel/trace/trace_uprobe.c b/kernel/trace/trace_uprobe.c
> index 8e00901..43d258d 100644
> --- a/kernel/trace/trace_uprobe.c
> +++ b/kernel/trace/trace_uprobe.c
> @@ -492,17 +492,13 @@ static int uprobe_trace_func(struct trace_uprobe *tu, struct pt_regs *regs)
>  	struct ring_buffer_event *event;
>  	struct ring_buffer *buffer;
>  	u8 *data;
> -	int size, i, pc;
> -	unsigned long irq_flags;
> +	int size, i;
>  	struct ftrace_event_call *call = &tu->call;
>  
> -	local_save_flags(irq_flags);
> -	pc = preempt_count();

How about instead, just change the above two and have:

	/* uprobes are never called with preemption disabled */
	pc = 0;
	irq_flags = 0;

and leave the rest the same. This will help in future reviewers of the
code to not have to look up what that "0, 0" is for, and then wonder if
it should be that way. gcc should optimize it to be exactly the same as
this patch.

-- Steve

> -
>  	size = sizeof(*entry) + tu->size;
>  
>  	event = trace_current_buffer_lock_reserve(&buffer, call->event.type,
> -						  size, irq_flags, pc);
> +						  size, 0, 0);
>  	if (!event)
>  		return 0;
>  
> @@ -513,7 +509,7 @@ static int uprobe_trace_func(struct trace_uprobe *tu, struct pt_regs *regs)
>  		call_fetch(&tu->args[i].fetch, regs, data + tu->args[i].offset);
>  
>  	if (!filter_current_check_discard(buffer, call, entry, event))
> -		trace_buffer_unlock_commit(buffer, event, irq_flags, pc);
> +		trace_buffer_unlock_commit(buffer, event, 0, 0);
>  
>  	return 0;
>  }


