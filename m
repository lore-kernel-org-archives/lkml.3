Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762634Ab3DKKTH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 06:19:07 -0400
Received: from mail4.hitachi.co.jp ([133.145.228.5]:41902 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753670Ab3DKKTG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 06:19:06 -0400
Message-ID: <51668E16.9000904@hitachi.com>
Date: Thu, 11 Apr 2013 19:19:02 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.2; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Steven Rostedt <rostedt@goodmis.org>, Anton Arapov <anton@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        "yrl.pp-manager.tt@hitachi.com" <yrl.pp-manager.tt@hitachi.com>
Subject: Re: [PATCH 1/1] uprobes/tracing: Don't pass addr=ip to perf_trace_buf_submit()
References: <20130329181520.GA20670@redhat.com> <20130329181545.GA20697@redhat.com> <20130404142522.GC8986@linux.vnet.ibm.com> <515E4938.6090809@hitachi.com> <20130405150110.GA31300@redhat.com> <51628DF8.6030102@hitachi.com> <20130410145818.GA30670@redhat.com> <20130410145844.GB30670@redhat.com>
In-Reply-To: <20130410145844.GB30670@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/04/10 23:58), Oleg Nesterov wrote:
> uprobe_perf_print() passes addr=ip to perf_trace_buf_submit() for
> no reason. This sets perf_sample_data->addr for PERF_SAMPLE_ADDR,
> we already have perf_sample_data->ip initialized if PERF_SAMPLE_IP.
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>

Acked-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>

Thank you!

> ---
>  kernel/trace/trace_uprobe.c |    8 +++-----
>  1 files changed, 3 insertions(+), 5 deletions(-)
> 
> diff --git a/kernel/trace/trace_uprobe.c b/kernel/trace/trace_uprobe.c
> index 2d08bea..37ccb72 100644
> --- a/kernel/trace/trace_uprobe.c
> +++ b/kernel/trace/trace_uprobe.c
> @@ -811,7 +811,6 @@ static void uprobe_perf_print(struct trace_uprobe *tu,
>  	struct ftrace_event_call *call = &tu->call;
>  	struct uprobe_trace_entry_head *entry;
>  	struct hlist_head *head;
> -	unsigned long ip;
>  	void *data;
>  	int size, rctx, i;
>  
> @@ -825,13 +824,12 @@ static void uprobe_perf_print(struct trace_uprobe *tu,
>  	if (!entry)
>  		goto out;
>  
> -	ip = instruction_pointer(regs);
>  	if (is_ret_probe(tu)) {
>  		entry->vaddr[0] = func;
> -		entry->vaddr[1] = ip;
> +		entry->vaddr[1] = instruction_pointer(regs);
>  		data = DATAOF_TRACE_ENTRY(entry, true);
>  	} else {
> -		entry->vaddr[0] = ip;
> +		entry->vaddr[0] = instruction_pointer(regs);
>  		data = DATAOF_TRACE_ENTRY(entry, false);
>  	}
>  
> @@ -839,7 +837,7 @@ static void uprobe_perf_print(struct trace_uprobe *tu,
>  		call_fetch(&tu->args[i].fetch, regs, data + tu->args[i].offset);
>  
>  	head = this_cpu_ptr(call->perf_events);
> -	perf_trace_buf_submit(entry, size, rctx, ip, 1, regs, head, NULL);
> +	perf_trace_buf_submit(entry, size, rctx, 0, 1, regs, head, NULL);
>   out:
>  	preempt_enable();
>  }
> 


-- 
Masami HIRAMATSU
IT Management Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


