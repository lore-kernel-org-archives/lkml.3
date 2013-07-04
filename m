Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756568Ab3GDMMg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jul 2013 08:12:36 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:59680 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756151Ab3GDMMf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jul 2013 08:12:35 -0400
Message-ID: <51D566A9.5090406@hitachi.com>
Date: Thu, 04 Jul 2013 21:12:25 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.2; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Oleg Nesterov <oleg@redhat.com>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Andrew Morton <akpm@linux-foundation.org>, jovi.zhangwei@huawei.com,
        Jiri Olsa <jolsa@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Subject: Re: [RFC PATCH] tracing: Atomically get refcounts of event_call and
 trace_array
References: <51D4F885.3040105@hitachi.com> <20130704115554.21507.60284.stgit@mhiramat-M0-7522>
In-Reply-To: <20130704115554.21507.60284.stgit@mhiramat-M0-7522>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven, Oleg,

I think your patches are OK, but not enough.
Here is an additional patch to fix the unsafe case which I found.
Could you review this too?

(2013/07/04 20:55), Masami Hiramatsu wrote:
> Currently ftrace_open_generic_file gets an event_file from
> inode->i_private, and then locks event_mutex and gets refcount.
> However, this can cause a race as below scenario;
> 
> CPU0                              CPU1
> open(kprobe_events)
>   trace_remove_event_call()    open(enable)
>     lock event_mutex             get event_file from inode->i_private
>       event_remove()             wait for unlock event_mutex
>         ...
>         free event_file
>     unlock event_mutex
>                                  lock event_mutex
>                                  add refcount of event_file->call (*)
> 
> So, at (*) point, the event_file is already freed and we
> may access the corrupted object.
> The same thing could happen on trace_array because it is also
> directly accessed from event_file.
> 
> To avoid this, when opening events/*/*/enable, we must atomically
> do; ensure the ftrace_event_file object still exists on a trace_array,
> and get refcounts of event_file->call and the trace_array.
> 
> 
> CPU0                              CPU1
> open(kprobe_events)
>   trace_remove_event_call()    open(enable)
>     lock event_mutex             get event_file from inode->i_private
>       event_remove()             wait for unlock event_mutex
>         ...
>         free event_file
>     unlock event_mutex
>                                  lock event_mutex
>                                  search the event_file and failed
>                                  unlock event_mutex
>                                  return -ENODEV
> 
> Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
> ---
>  kernel/trace/trace_events.c |   58 +++++++++++++++++++++++++++++++++----------
>  1 file changed, 45 insertions(+), 13 deletions(-)
> 
> diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
> index 1a5547e..db6b107 100644
> --- a/kernel/trace/trace_events.c
> +++ b/kernel/trace/trace_events.c
> @@ -391,15 +391,24 @@ static void __get_system_dir(struct ftrace_subsystem_dir *dir)
>  	__get_system(dir->subsystem);
>  }
>  
> -static int ftrace_event_call_get(struct ftrace_event_call *call)
> +static int __ftrace_event_call_get(struct ftrace_event_call *call)
>  {
>  	int ret = 0;
>  
> -	mutex_lock(&event_mutex);
>  	if ((call->flags & TRACE_EVENT_FL_REF_MASK) == TRACE_EVENT_FL_REF_MAX - 1)
>  		ret = -EBUSY;
>  	else
>  		call->flags++;
> +
> +	return ret;
> +}
> +
> +static int ftrace_event_call_get(struct ftrace_event_call *call)
> +{
> +	int ret = 0;
> +
> +	mutex_lock(&event_mutex);
> +	ret = __ftrace_event_call_get(call);
>  	mutex_unlock(&event_mutex);
>  
>  	return ret;
> @@ -413,6 +422,35 @@ static void ftrace_event_call_put(struct ftrace_event_call *call)
>  	mutex_unlock(&event_mutex);
>  }
>  
> +static int ftrace_event_file_get(struct ftrace_event_file *this_file)
> +{
> +	struct ftrace_event_file *file;
> +	struct trace_array *tr;
> +	int ret = -ENODEV;
> +
> +	mutex_lock(&event_mutex);
> +	do_for_each_event_file(tr, file) {
> +		if (file == this_file) {
> +			ret = __ftrace_event_call_get(file->event_call);
> +			if (!ret)
> +				tr->ref++;
> +			goto out_unlock;
> +		}
> +	} while_for_each_event_file();
> + out_unlock:
> +	mutex_unlock(&event_mutex);
> +
> +	return ret;
> +}
> +
> +static void ftrace_event_file_put(struct ftrace_event_file *file)
> +{
> +	struct trace_array *tr = file->tr;
> +
> +	ftrace_event_call_put(file->event_call);
> +	trace_array_put(tr);
> +}
> +
>  static void __put_system_dir(struct ftrace_subsystem_dir *dir)
>  {
>  	WARN_ON_ONCE(dir->ref_count == 0);
> @@ -438,33 +476,27 @@ static void put_system(struct ftrace_subsystem_dir *dir)
>  static int tracing_open_generic_file(struct inode *inode, struct file *filp)
>  {
>  	struct ftrace_event_file *file = inode->i_private;
> -	struct trace_array *tr = file->tr;
>  	int ret;
>  
> -	if (trace_array_get(tr) < 0)
> -		return -ENODEV;
> -
> -	ret = tracing_open_generic(inode, filp);
> +	ret = ftrace_event_file_get(file);
>  	if (ret < 0)
> -		goto fail;
> +		return ret;
>  
> -	ret = ftrace_event_call_get(file->event_call);
> +	ret = tracing_open_generic(inode, filp);
>  	if (ret < 0)
>  		goto fail;
>  
>  	return 0;
>   fail:
> -	trace_array_put(tr);
> +	ftrace_event_file_put(file);
>  	return ret;
>  }
>  
>  static int tracing_release_generic_file(struct inode *inode, struct file *filp)
>  {
>  	struct ftrace_event_file *file = inode->i_private;
> -	struct trace_array *tr = file->tr;
>  
> -	ftrace_event_call_put(file->event_call);
> -	trace_array_put(tr);
> +	ftrace_event_file_put(file);
>  
>  	return 0;
>  }

-- 
Masami HIRAMATSU
IT Management Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


