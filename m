Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756665Ab3G3B3j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 21:29:39 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:43449 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756631Ab3G3B3h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 21:29:37 -0400
Message-ID: <51F716FD.5070500@hitachi.com>
Date: Tue, 30 Jul 2013 10:29:33 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.2; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Alexander Z Lam <azl@google.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        David Sharp <dhsharp@google.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Vaibhav Nagarnaik <vnagarnaik@google.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/6] tracing: Turn event/id->i_private into call->event.type
References: <20130726172532.GA3605@redhat.com>
In-Reply-To: <20130726172532.GA3605@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/07/27 2:25), Oleg Nesterov wrote:
> event_id_read() is racy, ftrace_event_call can be already freed
> by trace_remove_event_call() callers.
> 
> Change event_create_dir() to pass "data = call->event.type", this
> is all event_id_read() needs. ftrace_event_id_fops no longer needs
> tracing_open_generic().
> 
> We add the new helper, event_file_data(), to read ->i_private, it
> will have more users.
> 
> Note: currently ACCESS_ONCE() and "id != 0" check are not needed,
> but we are going to change event_remove/rmdir to clear ->i_private.
> 

Looks OK for me.

Reviewed-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>

> Signed-off-by: Oleg Nesterov <oleg@redhat.com>
> ---
>  kernel/trace/trace_events.c |   17 ++++++++++++-----
>  1 files changed, 12 insertions(+), 5 deletions(-)
> 
> diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
> index 76eed53..77990c4 100644
> --- a/kernel/trace/trace_events.c
> +++ b/kernel/trace/trace_events.c
> @@ -409,6 +409,11 @@ static void put_system(struct ftrace_subsystem_dir *dir)
>  	mutex_unlock(&event_mutex);
>  }
>  
> +static void *event_file_data(struct file *filp)
> +{
> +	return ACCESS_ONCE(file_inode(filp)->i_private);
> +}
> +
>  /*
>   * Open and update trace_array ref count.
>   * Must have the current trace_array passed to it.
> @@ -946,14 +951,17 @@ static int trace_format_open(struct inode *inode, struct file *file)
>  static ssize_t
>  event_id_read(struct file *filp, char __user *ubuf, size_t cnt, loff_t *ppos)
>  {
> -	struct ftrace_event_call *call = filp->private_data;
> +	int id = (long)event_file_data(filp);
>  	char buf[32];
>  	int len;
>  
>  	if (*ppos)
>  		return 0;
>  
> -	len = sprintf(buf, "%d\n", call->event.type);
> +	if (unlikely(!id))
> +		return -ENODEV;
> +
> +	len = sprintf(buf, "%d\n", id);
>  	return simple_read_from_buffer(ubuf, cnt, ppos, buf, len);
>  }
>  
> @@ -1240,7 +1248,6 @@ static const struct file_operations ftrace_event_format_fops = {
>  };
>  
>  static const struct file_operations ftrace_event_id_fops = {
> -	.open = tracing_open_generic,
>  	.read = event_id_read,
>  	.llseek = default_llseek,
>  };
> @@ -1488,8 +1495,8 @@ event_create_dir(struct dentry *parent,
>  
>  #ifdef CONFIG_PERF_EVENTS
>  	if (call->event.type && call->class->reg)
> -		trace_create_file("id", 0444, file->dir, call,
> -		 		  id);
> +		trace_create_file("id", 0444, file->dir,
> +				  (void *)(long)call->event.type, id);
>  #endif
>  
>  	/*
> 


-- 
Masami HIRAMATSU
IT Management Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


