Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933510Ab3DJBrF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 21:47:05 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:27438 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751300Ab3DJBrD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 21:47:03 -0400
X-Authority-Analysis: v=2.0 cv=C51rOHz+ c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=i53ZzN_X_rgA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=NxKs5EB5JOMA:10 a=57SyGIRnAAAA:8 a=VwQbUJbxAAAA:8 a=VyHSx0iAlL1JR8HDaVEA:9 a=QEXdDO2ut3YA:10 a=TIV7c6GJmisA:10 a=jeBq3FmKZ4MA:10 a=LI9Vle30uBYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1365558422.25498.93.camel@gandalf.local.home>
Subject: Re: [PATCH 3/3] tracing: Check cpu file on tracing_release()
From: Steven Rostedt <rostedt@goodmis.org>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Namhyung Kim <namhyung.kim@lge.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Date: Tue, 09 Apr 2013 21:47:02 -0400
In-Reply-To: <878v4rtbog.fsf@sejong.aot.lge.com>
References: <1365553093-10180-1-git-send-email-namhyung@kernel.org>
	 <1365553093-10180-3-git-send-email-namhyung@kernel.org>
	 <1365553863.25498.84.camel@gandalf.local.home> <5164B3F0.2030506@lge.com>
	 <1365554787.25498.88.camel@gandalf.local.home>
	 <878v4rtbog.fsf@sejong.aot.lge.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-04-10 at 10:30 +0900, Namhyung Kim wrote:

> >From 7ba245dba217ef858b467552019acd49f7fdce7e Mon Sep 17 00:00:00 2001
> From: Namhyung Kim <namhyung.kim@lge.com>
> Date: Wed, 10 Apr 2013 09:10:44 +0900
> Subject: [PATCH] tracing: Check result of ring_buffer_read_prepare()
> 
> The ring_buffer_read_prepare() can return NULL if memory allocation
> fails.  Fail out in this case instead of succedding and then having
> no output.
> 
> Suggested-by: Steven Rostedt <rostedt@goodmis.org>
> Signed-off-by: Namhyung Kim <namhyung@kernel.org>
> ---
>  kernel/trace/trace.c | 25 +++++++++++++++++++++++++
>  1 file changed, 25 insertions(+)
> 
> diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
> index 7270460cfe3c..3b3514dc8e5e 100644
> --- a/kernel/trace/trace.c
> +++ b/kernel/trace/trace.c
> @@ -2826,6 +2826,8 @@ __tracing_open(struct inode *inode, struct file *file, bool snapshot)
>  		for_each_tracing_cpu(cpu) {
>  			iter->buffer_iter[cpu] =
>  				ring_buffer_read_prepare(iter->trace_buffer->buffer, cpu);
> +			if (!iter->buffer_iter[cpu])
> +				goto free;
>  		}
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
> @@ -2847,6 +2852,26 @@ __tracing_open(struct inode *inode, struct file *file, bool snapshot)
>  
>  	return iter;
>  
> +free:
> +	if (iter->cpu_file == RING_BUFFER_ALL_CPUS) {
> +		for_each_tracing_cpu(cpu) {
> +			if (iter->buffer_iter[cpu])
> +				ring_buffer_read_finish(iter->buffer_iter[cpu]);
> +		}
> +	} else {
> +		cpu = iter->cpu_file;
> +		if (iter->buffer_iter[cpu])
> +			ring_buffer_read_finish(iter->buffer_iter[cpu]);
> +	}

As I said I would consider updating the release code, but here, it's an
error path that is extremely unlikely to be hit. Please just keep the
single loop, and leave out the cpu_file compare.

Thanks,

-- Steve

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


