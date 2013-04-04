Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761834Ab3DDOa7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 10:30:59 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:48282 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761158Ab3DDOa6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 10:30:58 -0400
Date: Thu, 4 Apr 2013 19:55:22 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Steven Rostedt <rostedt@goodmis.org>, Anton Arapov <anton@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Subject: Re: [PATCH 3/4] uprobes/tracing: Kill the pointless
 local_save_flags/preempt_count calls
Message-ID: <20130404142522.GC8986@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20130329181520.GA20670@redhat.com>
 <20130329181545.GA20697@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20130329181545.GA20697@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13040414-5806-0000-0000-000020987F64
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Oleg Nesterov <oleg@redhat.com> [2013-03-29 19:15:45]:

> uprobe_trace_func() is never called with irqs or preemption
> disabled, no need to ask preempt_count() or local_save_flags().
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>

Acked-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>

Adding Masami in the Cc.

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
> -- 
> 1.5.5.1
> 

-- 
Thanks and Regards
Srikar Dronamraju

