Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752690Ab3DMDAc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Apr 2013 23:00:32 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:14402 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751132Ab3DMDAb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Apr 2013 23:00:31 -0400
X-Authority-Analysis: v=2.0 cv=F+XVh9dN c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=oqVj-M9wSccA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=Zlg-9MSaqskA:10 a=57SyGIRnAAAA:8 a=VwQbUJbxAAAA:8 a=CREopYG9h5VJQnoNUA8A:9 a=QEXdDO2ut3YA:10 a=TIV7c6GJmisA:10 a=jeBq3FmKZ4MA:10 a=LI9Vle30uBYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1365822030.9609.111.camel@gandalf.local.home>
Subject: Re: [PATCH] tracing: Check result of ring_buffer_read_prepare()
From: Steven Rostedt <rostedt@goodmis.org>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>
Date: Fri, 12 Apr 2013 23:00:30 -0400
In-Reply-To: <1365558929-11211-1-git-send-email-namhyung@kernel.org>
References: <1365558422.25498.93.camel@gandalf.local.home>
	 <1365558929-11211-1-git-send-email-namhyung@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-04-10 at 10:55 +0900, Namhyung Kim wrote:
> From: Namhyung Kim <namhyung.kim@lge.com>
> 
> The ring_buffer_read_prepare() can return NULL if memory allocation
> fails.  Fail out in this case instead of succedding and then having
> no output.
> 
> Suggested-by: Steven Rostedt <rostedt@goodmis.org>
> Signed-off-by: Namhyung Kim <namhyung@kernel.org>
> ---
>  kernel/trace/trace.c | 22 ++++++++++++++++++++++
>  1 file changed, 22 insertions(+)
> 
> diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
> index 7270460cfe3c..13200de31f0b 100644
> --- a/kernel/trace/trace.c
> +++ b/kernel/trace/trace.c
> @@ -2826,6 +2826,8 @@ __tracing_open(struct inode *inode, struct file *file, bool snapshot)
>  		for_each_tracing_cpu(cpu) {
>  			iter->buffer_iter[cpu] =
>  				ring_buffer_read_prepare(iter->trace_buffer->buffer, cpu);
> +			if (!iter->buffer_iter[cpu])
> +				goto free;
>  		}

OK, this totally fails. I guess we need to allow
ring_buffer_read_prepare() to return NULL, as it will return NULL if a
cpu is offline or the tracing_cpumask has a CPU down.

I'll just pull this patch out of my queue for now.

-- Steve

>  		ring_buffer_read_prepare_sync();
>  		for_each_tracing_cpu(cpu) {
> @@ -2836,6 +2838,9 @@ __tracing_open(struct inode *inode, struct file *file, bool snapshot)
>  		cpu = iter->cpu_file;
>  		iter->buffer_iter[cpu] =
>  			ring_buffer_read_prepare(iter->trace_buffer->buffer, cpu);
> +		if (!iter->buffer_iter[cpu])
> +			goto free;
> +
>  		ring_buffer_read_prepare_sync();
>  		ring_buffer_read_start(iter->buffer_iter[cpu]);
>  		tracing_iter_reset(iter, cpu);
> @@ -2847,6 +2852,23 @@ __tracing_open(struct inode *inode, struct file *file, bool snapshot)
>  
>  	return iter;
>  
> +free:
> +	/*
> +	 * For simplicity, just keep single loop without comparing cpu_file.
> +	 */
> +	for_each_tracing_cpu(cpu) {
> +		if (iter->buffer_iter[cpu])
> +			ring_buffer_read_finish(iter->buffer_iter[cpu]);
> +	}
> +
> +	if (iter->trace && iter->trace->close)
> +		iter->trace->close(iter);
> +
> +	if (!iter->snapshot)
> +		tracing_start_tr(tr);
> +
> +	mutex_destroy(&iter->mutex);
> +	free_cpumask_var(iter->started);
>   fail:
>  	mutex_unlock(&trace_types_lock);
>  	kfree(iter->trace);


