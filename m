Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757270Ab3GVPXl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 11:23:41 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:5953 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756539Ab3GVPXj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 11:23:39 -0400
X-Authority-Analysis: v=2.0 cv=P6i4d18u c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=q-5KwEyaYmUA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=PzHPlaRu3OEA:10 a=_uMv2_K2-rDsBSEv57oA:9 a=QEXdDO2ut3YA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-ID: <1374506617.3356.97.camel@gandalf.local.home>
Subject: Re: [PATCH 1/7] tracing: Introduce trace_create_cpu_file() and
 tracing_get_cpu()
From: Steven Rostedt <rostedt@goodmis.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Alexander Z Lam <azl@google.com>, David Sharp <dhsharp@google.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>,
        Vaibhav Nagarnaik <vnagarnaik@google.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        linux-kernel@vger.kernel.org
Date: Mon, 22 Jul 2013 11:23:37 -0400
In-Reply-To: <20130722134342.GA18355@redhat.com>
References: <20130722134342.GA18355@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-07-22 at 15:43 +0200, Oleg Nesterov wrote:

Checkpatch nits...

> ---
>  kernel/trace/trace.c |   46 ++++++++++++++++++++++++++++++++--------------
>  1 files changed, 32 insertions(+), 14 deletions(-)
> 
> diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
> index 3f24777..1e0fae9 100644
> --- a/kernel/trace/trace.c
> +++ b/kernel/trace/trace.c
> @@ -2843,6 +2843,13 @@ static int s_show(struct seq_file *m, void *v)
>  	return 0;
>  }
>  
> +static inline int tracing_get_cpu(struct inode *inode)
> +{
> +	if (inode->i_cdev) /* See trace_create_cpu_file() */
> +		return (long)inode->i_cdev - 1;
> +	return RING_BUFFER_ALL_CPUS;
> +}
> +
>  static const struct seq_operations tracer_seq_ops = {
>  	.start		= s_start,
>  	.next		= s_next,
> @@ -5529,6 +5536,17 @@ static struct dentry *tracing_dentry_percpu(struct trace_array *tr, int cpu)
>  	return tr->percpu_dir;
>  }
>  
> +static struct dentry *
> +trace_create_cpu_file(const char *name, umode_t mode, struct dentry *parent,
> +		      void *data, long cpu, const struct file_operations *fops)
> +{
> +	struct dentry *ret = trace_create_file(name, mode, parent, data, fops);
> +
> +	if (ret) /* See tracing_get_cpu() */
> +		ret->d_inode->i_cdev = (void*)(cpu + 1);

 (void *)(cpu + 1)
      ^
    space needed


> +	return ret;
> +}
> +
>  static void
>  tracing_init_debugfs_percpu(struct trace_array *tr, long cpu)
>  {
> @@ -5548,28 +5566,28 @@ tracing_init_debugfs_percpu(struct trace_array *tr, long cpu)
>  	}
>  
>  	/* per cpu trace_pipe */
> -	trace_create_file("trace_pipe", 0444, d_cpu,
> -			(void *)&data->trace_cpu, &tracing_pipe_fops);
> +	trace_create_cpu_file("trace_pipe", 0444, d_cpu,
> +				&data->trace_cpu, cpu, &tracing_pipe_fops);
>  
>  	/* per cpu trace */
> -	trace_create_file("trace", 0644, d_cpu,
> -			(void *)&data->trace_cpu, &tracing_fops);
> +	trace_create_cpu_file("trace", 0644, d_cpu,
> +				&data->trace_cpu, cpu, &tracing_fops);
>  
> -	trace_create_file("trace_pipe_raw", 0444, d_cpu,
> -			(void *)&data->trace_cpu, &tracing_buffers_fops);
> +	trace_create_cpu_file("trace_pipe_raw", 0444, d_cpu,
> +				&data->trace_cpu, cpu, &tracing_buffers_fops);
>  
> -	trace_create_file("stats", 0444, d_cpu,
> -			(void *)&data->trace_cpu, &tracing_stats_fops);
> +	trace_create_cpu_file("stats", 0444, d_cpu,
> +				&data->trace_cpu, cpu, &tracing_stats_fops);
>  
> -	trace_create_file("buffer_size_kb", 0444, d_cpu,
> -			(void *)&data->trace_cpu, &tracing_entries_fops);
> +	trace_create_cpu_file("buffer_size_kb", 0444, d_cpu,
> +				&data->trace_cpu, cpu, &tracing_entries_fops);
>  
>  #ifdef CONFIG_TRACER_SNAPSHOT
> -	trace_create_file("snapshot", 0644, d_cpu,
> -			  (void *)&data->trace_cpu, &snapshot_fops);
> +	trace_create_cpu_file("snapshot", 0644, d_cpu,
> +			  	&data->trace_cpu, cpu, &snapshot_fops);

Whitespace damage above. There's spaces in between the tabs.

If no other changes are needed to this patchset (waiting on word from
Al), I'll fix this up. Otherwise, you might want to fix them if you need
to send a follow up patch set.

-- Steve


>  
> -	trace_create_file("snapshot_raw", 0444, d_cpu,
> -			(void *)&data->trace_cpu, &snapshot_raw_fops);
> +	trace_create_cpu_file("snapshot_raw", 0444, d_cpu,
> +				&data->trace_cpu, cpu, &snapshot_raw_fops);
>  #endif
>  }
>  


