Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755723Ab3FQEdo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 00:33:44 -0400
Received: from mail4.hitachi.co.jp ([133.145.228.5]:48403 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750937Ab3FQEdn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 00:33:43 -0400
Message-ID: <51BE91A4.6020003@hitachi.com>
Date: Mon, 17 Jun 2013 13:33:40 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.2; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] tracing/kprobes: Avoid perf_trace_buf_*() if ->perf_events
 is empty
References: <20130616172146.GA8533@redhat.com>
In-Reply-To: <20130616172146.GA8533@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/06/17 2:21), Oleg Nesterov wrote:
> perf_trace_buf_prepare() + perf_trace_buf_submit() make no sense
> if this task/CPU has no active counters. Change kprobe_perf_func()
> and kretprobe_perf_func() to check call->perf_events beforehand
> and return if this list is empty.
> 
> For example, "perf record -e some_probe -p1". Only /sbin/init will
> report, all other threads which hit the same probe will do
> perf_trace_buf_prepare/perf_trace_buf_submit just to realize that
> nobody wants perf_swevent_event().
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>

Looks good :) Thank you!

Acked-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>

> ---
>  kernel/trace/trace_kprobe.c |   12 ++++++++----
>  1 files changed, 8 insertions(+), 4 deletions(-)
> 
> diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
> index 9f46e98..c0af476 100644
> --- a/kernel/trace/trace_kprobe.c
> +++ b/kernel/trace/trace_kprobe.c
> @@ -1157,6 +1157,10 @@ kprobe_perf_func(struct trace_probe *tp, struct pt_regs *regs)
>  	int size, __size, dsize;
>  	int rctx;
>  
> +	head = this_cpu_ptr(call->perf_events);
> +	if (hlist_empty(head))
> +		return;
> +
>  	dsize = __get_data_size(tp, regs);
>  	__size = sizeof(*entry) + tp->size + dsize;
>  	size = ALIGN(__size + sizeof(u32), sizeof(u64));
> @@ -1172,8 +1176,6 @@ kprobe_perf_func(struct trace_probe *tp, struct pt_regs *regs)
>  	entry->ip = (unsigned long)tp->rp.kp.addr;
>  	memset(&entry[1], 0, dsize);
>  	store_trace_args(sizeof(*entry), tp, regs, (u8 *)&entry[1], dsize);
> -
> -	head = this_cpu_ptr(call->perf_events);
>  	perf_trace_buf_submit(entry, size, rctx,
>  					entry->ip, 1, regs, head, NULL);
>  }
> @@ -1189,6 +1191,10 @@ kretprobe_perf_func(struct trace_probe *tp, struct kretprobe_instance *ri,
>  	int size, __size, dsize;
>  	int rctx;
>  
> +	head = this_cpu_ptr(call->perf_events);
> +	if (hlist_empty(head))
> +		return;
> +
>  	dsize = __get_data_size(tp, regs);
>  	__size = sizeof(*entry) + tp->size + dsize;
>  	size = ALIGN(__size + sizeof(u32), sizeof(u64));
> @@ -1204,8 +1210,6 @@ kretprobe_perf_func(struct trace_probe *tp, struct kretprobe_instance *ri,
>  	entry->func = (unsigned long)tp->rp.kp.addr;
>  	entry->ret_ip = (unsigned long)ri->ret_addr;
>  	store_trace_args(sizeof(*entry), tp, regs, (u8 *)&entry[1], dsize);
> -
> -	head = this_cpu_ptr(call->perf_events);
>  	perf_trace_buf_submit(entry, size, rctx,
>  					entry->ret_ip, 1, regs, head, NULL);
>  }
> 


-- 
Masami HIRAMATSU
IT Management Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


