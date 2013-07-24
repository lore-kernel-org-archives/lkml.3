Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754188Ab3GXUOB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 16:14:01 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:7935 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754007Ab3GXUNS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 16:13:18 -0400
X-Authority-Analysis: v=2.0 cv=P6i4d18u c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Qu6ugZQ4bf4A:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=HnnTJNGInn0A:10 a=20KFwNOVAAAA:8 a=A-5jg6PAATL5xQ1MlGkA:9 a=QEXdDO2ut3YA:10 a=jEp0ucaQiEUA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-ID: <1374696796.3356.162.camel@gandalf.local.home>
Subject: Re: [PATCH 1/6] tracing: Turn event/id->i_private into
 call->event.type
From: Steven Rostedt <rostedt@goodmis.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Alexander Z Lam <azl@google.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        David Sharp <dhsharp@google.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Vaibhav Nagarnaik <vnagarnaik@google.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        linux-kernel@vger.kernel.org
Date: Wed, 24 Jul 2013 16:13:16 -0400
In-Reply-To: <20130723205909.GA9055@redhat.com>
References: <20130723205909.GA9055@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-07-23 at 22:59 +0200, Oleg Nesterov wrote:
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
> but we are going to change event_remove/rmdir to clear ->i_mutex.

We are changing i_mutex or i_private?

Anyway, this still looks too complex for the id. Just pass the id number
to the filp->private_data, and use that. It should never be cleared, and
as we are not using any pointers it will always return what the id
is/was.

Keep tracing_open_generic() and have:

event_id_read(struct file *filp, char __user *ubuf, size_t cnt, loff_t
*ppos)
{
	int id = (int)(unsigned long)filp->private_data;
	char buf[32];
	int len;

	if (*ppos)
		return 0;

	len = sprintf(buf, "%d\n", id);
	return simple_read_from_buffer(ubuf, cnt, ppos, buf, len);
}

No need for accessing the inode->i_private.

-- Steve
 
> 
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


