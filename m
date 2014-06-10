Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754794AbaFJFZY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 01:25:24 -0400
Received: from lgeamrelo04.lge.com ([156.147.1.127]:52948 "EHLO
	lgeamrelo04.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751113AbaFJFZX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 01:25:23 -0400
X-Original-SENDERIP: 10.177.220.181
X-Original-MAILFROM: namhyung@gmail.com
From: Namhyung Kim <namhyung@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
Subject: Re: [for-next][PATCH 6/6] tracing: Fix leak of ring buffer data when new instances creation fails
References: <20140606163034.516780857@goodmis.org>
	<20140606172105.000489056@goodmis.org>
Date: Tue, 10 Jun 2014 14:25:21 +0900
In-Reply-To: <20140606172105.000489056@goodmis.org> (Steven Rostedt's message
	of "Fri, 06 Jun 2014 12:30:40 -0400")
Message-ID: <87k38pbake.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 06 Jun 2014 12:30:40 -0400, Steven Rostedt wrote:
> From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>
>
> Yoshihiro Yunomae reported that the ring buffer data for a trace
> instance does not get properly cleaned up when it fails. He proposed
> a patch that manually cleaned the data up and addad a bunch of labels.
> The labels are not needed because all trace array is allocated with
> a kzalloc which initializes it to 0 and all kfree()s can take a NULL
> pointer and will ignore it.
>
> Adding a new helper function free_trace_buffers() that can also take
> null buffers to free the buffers that were allocated by
> allocate_trace_buffers().
>
> Link: http://lkml.kernel.org/r/20140605223522.32311.31664.stgit@yunodevel
>
> Reported-by: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> ---
>  kernel/trace/trace.c | 22 ++++++++++++++++++++--
>  1 file changed, 20 insertions(+), 2 deletions(-)
>
> diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
> index e29edee1542a..26cfff38e2ab 100644
> --- a/kernel/trace/trace.c
> +++ b/kernel/trace/trace.c
> @@ -6232,6 +6232,25 @@ static int allocate_trace_buffers(struct trace_array *tr, int size)
>  	return 0;
>  }
>  
> +static void free_trace_buffers(struct trace_array *tr)
> +{
> +	if (!tr)
> +		return;
> +
> +	if (tr->trace_buffer.buffer) {
> +		ring_buffer_free(tr->trace_buffer.buffer);
> +		tr->trace_buffer.buffer = NULL;
> +		free_percpu(tr->trace_buffer.data);
> +	}
> +
> +#ifdef CONFIG_TRACER_MAX_TRACE
> +	if (tr->max_buffer.buffer) {
> +		ring_buffer_free(tr->max_buffer.buffer);
> +		tr->max_buffer.buffer = NULL;

Hmm.. why doesn't it free tr->max_buffer.data here?  And I think it's
better to reset *_buffer.data to NULL also - maybe by adding another
helper function free_trace_buffer()..

Thanks,
Namhyung


> +	}
> +#endif
> +}
> +
>  static int new_instance_create(const char *name)
>  {
>  	struct trace_array *tr;
> @@ -6290,8 +6309,7 @@ static int new_instance_create(const char *name)
>  	return 0;
>  
>   out_free_tr:
> -	if (tr->trace_buffer.buffer)
> -		ring_buffer_free(tr->trace_buffer.buffer);
> +	free_trace_buffers(tr);
>  	free_cpumask_var(tr->tracing_cpumask);
>  	kfree(tr->name);
>  	kfree(tr);
