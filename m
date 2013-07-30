Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756691Ab3G3Ber (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 21:34:47 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:50385 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752664Ab3G3Beq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 21:34:46 -0400
Message-ID: <51F71832.2080009@hitachi.com>
Date: Tue, 30 Jul 2013 10:34:42 +0900
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
Subject: Re: [PATCH v2 3/6] tracing: Change event_filter_read/write to verify
 i_private != NULL
References: <20130726172540.GA3619@redhat.com>
In-Reply-To: <20130726172540.GA3619@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/07/27 2:25), Oleg Nesterov wrote:
> event_filter_read/write() are racy, ftrace_event_call can be already
> freed by trace_remove_event_call() callers.
> 
> 1. Shift mutex_lock(event_mutex) from print/apply_event_filter to
>    the callers.
> 
> 2. Change the callers, event_filter_read() and event_filter_write()
>    to read i_private under this mutex and abort if it is NULL.
> 
> This fixes nothing, but now we can change debugfs_remove("filter")
> callers to nullify ->i_private and fix the the problem.

Looks good for me. (Note: this also has some cosmetic changes)

Reviewed-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>

Thanks!

> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>
> ---
>  kernel/trace/trace_events.c        |   28 +++++++++++++++++++---------
>  kernel/trace/trace_events_filter.c |   17 ++++++-----------
>  2 files changed, 25 insertions(+), 20 deletions(-)
> 
> diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
> index 39cb049..b5144c4 100644
> --- a/kernel/trace/trace_events.c
> +++ b/kernel/trace/trace_events.c
> @@ -978,24 +978,30 @@ static ssize_t
>  event_filter_read(struct file *filp, char __user *ubuf, size_t cnt,
>  		  loff_t *ppos)
>  {
> -	struct ftrace_event_call *call = filp->private_data;
> +	struct ftrace_event_call *call;
>  	struct trace_seq *s;
> -	int r;
> +	int r = -ENODEV;
>  
>  	if (*ppos)
>  		return 0;
>  
>  	s = kmalloc(sizeof(*s), GFP_KERNEL);
> +
>  	if (!s)
>  		return -ENOMEM;
>  
>  	trace_seq_init(s);
>  
> -	print_event_filter(call, s);
> -	r = simple_read_from_buffer(ubuf, cnt, ppos, s->buffer, s->len);
> +	mutex_lock(&event_mutex);
> +	call = event_file_data(filp);
> +	if (call)
> +		print_event_filter(call, s);
> +	mutex_unlock(&event_mutex);
>  
> -	kfree(s);
> +	if (call)
> +		r = simple_read_from_buffer(ubuf, cnt, ppos, s->buffer, s->len);
>  
> +	kfree(s);
>  	return r;
>  }
>  
> @@ -1003,9 +1009,9 @@ static ssize_t
>  event_filter_write(struct file *filp, const char __user *ubuf, size_t cnt,
>  		   loff_t *ppos)
>  {
> -	struct ftrace_event_call *call = filp->private_data;
> +	struct ftrace_event_call *call;
>  	char *buf;
> -	int err;
> +	int err = -ENODEV;
>  
>  	if (cnt >= PAGE_SIZE)
>  		return -EINVAL;
> @@ -1020,13 +1026,17 @@ event_filter_write(struct file *filp, const char __user *ubuf, size_t cnt,
>  	}
>  	buf[cnt] = '\0';
>  
> -	err = apply_event_filter(call, buf);
> +	mutex_lock(&event_mutex);
> +	call = event_file_data(filp);
> +	if (call)
> +		err = apply_event_filter(call, buf);
> +	mutex_unlock(&event_mutex);
> +
>  	free_page((unsigned long) buf);
>  	if (err < 0)
>  		return err;
>  
>  	*ppos += cnt;
> -
>  	return cnt;
>  }
>  
> diff --git a/kernel/trace/trace_events_filter.c b/kernel/trace/trace_events_filter.c
> index 0c7b75a..97daa8c 100644
> --- a/kernel/trace/trace_events_filter.c
> +++ b/kernel/trace/trace_events_filter.c
> @@ -637,17 +637,15 @@ static void append_filter_err(struct filter_parse_state *ps,
>  	free_page((unsigned long) buf);
>  }
>  
> +/* caller must hold event_mutex */
>  void print_event_filter(struct ftrace_event_call *call, struct trace_seq *s)
>  {
> -	struct event_filter *filter;
> +	struct event_filter *filter = call->filter;
>  
> -	mutex_lock(&event_mutex);
> -	filter = call->filter;
>  	if (filter && filter->filter_string)
>  		trace_seq_printf(s, "%s\n", filter->filter_string);
>  	else
>  		trace_seq_puts(s, "none\n");
> -	mutex_unlock(&event_mutex);
>  }
>  
>  void print_subsystem_event_filter(struct event_subsystem *system,
> @@ -1841,23 +1839,22 @@ static int create_system_filter(struct event_subsystem *system,
>  	return err;
>  }
>  
> +/* caller must hold event_mutex */
>  int apply_event_filter(struct ftrace_event_call *call, char *filter_string)
>  {
>  	struct event_filter *filter;
> -	int err = 0;
> -
> -	mutex_lock(&event_mutex);
> +	int err;
>  
>  	if (!strcmp(strstrip(filter_string), "0")) {
>  		filter_disable(call);
>  		filter = call->filter;
>  		if (!filter)
> -			goto out_unlock;
> +			return 0;
>  		RCU_INIT_POINTER(call->filter, NULL);
>  		/* Make sure the filter is not being used */
>  		synchronize_sched();
>  		__free_filter(filter);
> -		goto out_unlock;
> +		return 0;
>  	}
>  
>  	err = create_filter(call, filter_string, true, &filter);
> @@ -1884,8 +1881,6 @@ int apply_event_filter(struct ftrace_event_call *call, char *filter_string)
>  			__free_filter(tmp);
>  		}
>  	}
> -out_unlock:
> -	mutex_unlock(&event_mutex);
>  
>  	return err;
>  }
> 


-- 
Masami HIRAMATSU
IT Management Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


