Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756380Ab3GVO4B (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 10:56:01 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:3472 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755767Ab3GVOz7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 10:55:59 -0400
X-Authority-Analysis: v=2.0 cv=aqMw+FlV c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=q-5KwEyaYmUA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=PzHPlaRu3OEA:10 a=20KFwNOVAAAA:8 a=Ny4cfmCJqYbE91WEEmwA:9 a=QEXdDO2ut3YA:10 a=jEp0ucaQiEUA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-ID: <1374504957.3356.91.camel@gandalf.local.home>
Subject: Re: [PATCH 1/7] tracing: Introduce trace_create_cpu_file() and
 tracing_get_cpu()
From: Steven Rostedt <rostedt@goodmis.org>
To: Oleg Nesterov <oleg@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Alexander Z Lam <azl@google.com>, David Sharp <dhsharp@google.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>,
        Vaibhav Nagarnaik <vnagarnaik@google.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        linux-kernel@vger.kernel.org
Date: Mon, 22 Jul 2013 10:55:57 -0400
In-Reply-To: <20130722134342.GA18355@redhat.com>
References: <20130722134342.GA18355@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Al,

I would like to get your opinion on this patch. Let me bring you up to
speed to what we are doing. Note, we are using the debugfs file system
here.

There was an incorrect assumption about the use of i_private. When a
file is created, the i_private would be set to some allocated object.
After the file is removed, the object would be deleted.

The problem is that there's a slight race where a process may have
opened the file, up the ref count of the dentry, and even though the
file was deleted, it's not really because it still has a reference
opened. When the object that i_private points to is freed, that leaves
the race where the process that has the file opened might still access
that object and crash.

Funny thing is, part of the use had this already covered. The
trace_array (tr) object has its own ref count. There's also a global
list of all trace_arrays. The get_trace_array(tr) will search for the tr
in the global list (under lock) and if it is found, it will up the ref
count. If not, it returns false and the "open()" call will fail. When
trace_array_get() succeeds, the ref count is incremented and any attempt
to delete it will fail. Thus, the trace_array (tr) part is not a
problem.

The problem is that some files only references the tr for a certain CPU.
Another data structure was created when the file was opened called
trace_cpu (tc), which maps a CPU and a trace_array. As there is no
global list of trace_cpus, this is susceptible to the above race
condition. Accessing tc->tr can happen after tc has been freed.

Now here's why I'm emailing you.  What Oleg is doing here is instead of
creating this extra trace_cpu structure, he's using the inode->i_cdev to
store the CPU information (he's wrapped this with helper functions so we
can use any inode structure). He sets inode->i_cdev to CPU+1 or to
RING_BUFFER_ALL_CPUS (when all CPU info is needed). This also means that
if we set i_cdev = 0, it can be known that the file is in the process of
being deleted, and we wont even have to search the global trace_array
list. This patch still does the search, but that could be eliminated in
the future.

What's your thoughts on this?

Thanks!

-- Steve


On Mon, 2013-07-22 at 15:43 +0200, Oleg Nesterov wrote:
> Every "file_operations" used by tracing_init_debugfs_percpu is buggy.
> f_op->open/etc does:
> 
> 	1. struct trace_cpu *tc = inode->i_private;
> 	   struct trace_array *tr = tc->tr;
> 
> 	2. trace_array_get(tr) or fail;
> 
> 	3. do_something(tc);
> 
> But tc (and tr) can be already freed before trace_array_get() is called.
> And it doesn't matter whether this file is per-cpu or it was created by
> init_tracer_debugfs(), free_percpu() or kfree() are equally bad.
> 
> Note that even 1. is not safe, the freed memory can be unmapped. But even
> if it was safe trace_array_get() can wrongly succeed if we also race with
> the next new_instance_create() which can re-allocate the same tr, or tc
> was overwritten and ->tr points to the valid tr. In this case 3. uses the
> freed/reused memory.
> 
> Add the new trivial helper, trace_create_cpu_file() which simply calls
> trace_create_file() and encodes "cpu" in "struct inode". Another helper,
> tracing_get_cpu() will be used to read cpu_nr-or-RING_BUFFER_ALL_CPUS.
> 
> The patch abuses ->i_cdev to encode the number, it is never used unless
> the file is S_ISCHR(). But we could use something else, say, i_bytes or
> even ->d_fsdata. In any case this hack is hidden inside these 2 helpers,
> it would be trivial to change them if needed.
> 
> This patch only changes tracing_init_debugfs_percpu() to use the new
> trace_create_cpu_file(), the next patches will change file_operations.
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>
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
>  
> -	trace_create_file("snapshot_raw", 0444, d_cpu,
> -			(void *)&data->trace_cpu, &snapshot_raw_fops);
> +	trace_create_cpu_file("snapshot_raw", 0444, d_cpu,
> +				&data->trace_cpu, cpu, &snapshot_raw_fops);
>  #endif
>  }
>  


