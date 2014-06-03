Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754867AbaFCXu5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 19:50:57 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.228]:36117 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753180AbaFCXu4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 19:50:56 -0400
Date: Tue, 3 Jun 2014 19:50:50 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
Cc: linux-kernel@vger.kernel.org,
        Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Ingo Molnar <mingo@redhat.com>, yrl.pp-manager.tt@hitachi.com
Subject: Re: [PATCH ftrace/core 1/2] [BUGFIX] ftrace: Avoid panic when
 allocation of max_buffer is failed
Message-ID: <20140603195050.18bdbc15@gandalf.local.home>
In-Reply-To: <20140603042803.27308.30956.stgit@yunodevel>
References: <20140603042800.27308.48050.stgit@yunodevel>
	<20140603042803.27308.30956.stgit@yunodevel>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 03 Jun 2014 13:28:03 +0900
Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com> wrote:

> When allocation of max_buffer is failed, the kernel frees tr->trace_buffer.data
> per CPU and return -ENOMEM in allocate_trace_buffers(). However,
> tracer_alloc_buffers() calling allocate_trace_buffers() also frees the data
> per CPU for -ENOMEM by allocate_trace_buffers(). Therefore, the allocation
> failure induces double free.
> 
> For the out_free_mask path in tracer_alloc_buffers(),
> global_trace.trace_buffer.data and global_trace.max_buffer.data are
> not allocated yet, so free_percpu of those are not needed.
> 
> Signed-off-by: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: linux-kernel@vger.kernel.org
> ---
>  kernel/trace/trace.c |    4 ----
>  1 file changed, 4 deletions(-)
> 
> diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
> index 626dbfd..135af32 100644
> --- a/kernel/trace/trace.c
> +++ b/kernel/trace/trace.c
> @@ -6671,10 +6671,6 @@ __init static int tracer_alloc_buffers(void)
>  out_free_temp_buffer:
>  	ring_buffer_free(temp_buffer);
>  out_free_cpumask:
> -	free_percpu(global_trace.trace_buffer.data);
> -#ifdef CONFIG_TRACER_MAX_TRACE
> -	free_percpu(global_trace.max_buffer.data);
> -#endif
>  	free_cpumask_var(global_trace.tracing_cpumask);
>  out_free_buffer_mask:
>  	free_cpumask_var(tracing_buffer_mask);

OK, so this is a double free on an error path at boot up. As it is
highly unlikely, I'll just add it for my 3.16 queue. It doesn't need to
go to stable.

-- Steve
