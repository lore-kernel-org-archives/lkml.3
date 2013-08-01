Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754017Ab3HADkF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 23:40:05 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:29759 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752594Ab3HADkD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 23:40:03 -0400
X-Authority-Analysis: v=2.0 cv=e9yEuNV/ c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=DwKIpjyhPi4A:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=-mLxqvm8HbQA:10 a=B-78knU2oVyhkjsiwUkA:9 a=QEXdDO2ut3YA:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-ID: <1375328400.5418.51.camel@gandalf.local.home>
Subject: Re: [RFC][PATCH 4/4] tracing/uprobes: Fail to unregister if probe
 event files are open
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Oleg Nesterov <oleg@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        Jiri Olsa <jolsa@redhat.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
Date: Wed, 31 Jul 2013 23:40:00 -0400
In-Reply-To: <20130704034038.991525256@goodmis.org>
References: <20130704033347.807661713@goodmis.org>
	 <20130704034038.991525256@goodmis.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Srikar,

Can you give your Acked-by to this patch.

Thanks!

-- Steve


On Wed, 2013-07-03 at 23:33 -0400, Steven Rostedt wrote:
> plain text document attachment
> (0004-tracing-uprobes-Fail-to-unregister-if-probe-event-fi.patch)
> From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>
> 
> When one of the event files is opened, we need to prevent them from
> being removed. Modules do with with the module owner set (automated
> from the VFS layer).  The ftrace buffer instances have a ref count added
> to the trace_array when the enabled file is opened (the others are not
> that big of a deal, as they only reference the event calls which
> still exist when an instance disappears). But kprobes and uprobes
> do not have any protection.
> 
> Have the unregister probe fail when the event files are open, in use
> are used by perf.
> 
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> ---
>  kernel/trace/trace_uprobe.c |   48 ++++++++++++++++++++++++++++++++-----------
>  1 file changed, 36 insertions(+), 12 deletions(-)
> 
> diff --git a/kernel/trace/trace_uprobe.c b/kernel/trace/trace_uprobe.c
> index d5d0cd3..4916da5 100644
> --- a/kernel/trace/trace_uprobe.c
> +++ b/kernel/trace/trace_uprobe.c
> @@ -70,7 +70,7 @@ struct trace_uprobe {
>  	(sizeof(struct probe_arg) * (n)))
>  
>  static int register_uprobe_event(struct trace_uprobe *tu);
> -static void unregister_uprobe_event(struct trace_uprobe *tu);
> +static int unregister_uprobe_event(struct trace_uprobe *tu);
>  
>  static DEFINE_MUTEX(uprobe_lock);
>  static LIST_HEAD(uprobe_list);
> @@ -164,11 +164,17 @@ static struct trace_uprobe *find_probe_event(const char *event, const char *grou
>  }
>  
>  /* Unregister a trace_uprobe and probe_event: call with locking uprobe_lock */
> -static void unregister_trace_uprobe(struct trace_uprobe *tu)
> +static int unregister_trace_uprobe(struct trace_uprobe *tu)
>  {
> +	int ret;
> +
> +	ret = unregister_uprobe_event(tu);
> +	if (ret)
> +		return ret;
> +
>  	list_del(&tu->list);
> -	unregister_uprobe_event(tu);
>  	free_trace_uprobe(tu);
> +	return 0;
>  }
>  
>  /* Register a trace_uprobe and probe_event */
> @@ -181,9 +187,12 @@ static int register_trace_uprobe(struct trace_uprobe *tu)
>  
>  	/* register as an event */
>  	old_tp = find_probe_event(tu->call.name, tu->call.class->system);
> -	if (old_tp)
> +	if (old_tp) {
>  		/* delete old event */
> -		unregister_trace_uprobe(old_tp);
> +		ret = unregister_trace_uprobe(old_tp);
> +		if (ret)
> +			goto end;
> +	}
>  
>  	ret = register_uprobe_event(tu);
>  	if (ret) {
> @@ -256,6 +265,8 @@ static int create_trace_uprobe(int argc, char **argv)
>  		group = UPROBE_EVENT_SYSTEM;
>  
>  	if (is_delete) {
> +		int ret;
> +
>  		if (!event) {
>  			pr_info("Delete command needs an event name.\n");
>  			return -EINVAL;
> @@ -269,9 +280,9 @@ static int create_trace_uprobe(int argc, char **argv)
>  			return -ENOENT;
>  		}
>  		/* delete an event */
> -		unregister_trace_uprobe(tu);
> +		ret = unregister_trace_uprobe(tu);
>  		mutex_unlock(&uprobe_lock);
> -		return 0;
> +		return ret;
>  	}
>  
>  	if (argc < 2) {
> @@ -408,16 +419,20 @@ fail_address_parse:
>  	return ret;
>  }
>  
> -static void cleanup_all_probes(void)
> +static int cleanup_all_probes(void)
>  {
>  	struct trace_uprobe *tu;
> +	int ret = 0;
>  
>  	mutex_lock(&uprobe_lock);
>  	while (!list_empty(&uprobe_list)) {
>  		tu = list_entry(uprobe_list.next, struct trace_uprobe, list);
> -		unregister_trace_uprobe(tu);
> +		ret = unregister_trace_uprobe(tu);
> +		if (ret)
> +			break;
>  	}
>  	mutex_unlock(&uprobe_lock);
> +	return ret;
>  }
>  
>  /* Probes listing interfaces */
> @@ -462,8 +477,12 @@ static const struct seq_operations probes_seq_op = {
>  
>  static int probes_open(struct inode *inode, struct file *file)
>  {
> +	int ret = 0;
> +
>  	if ((file->f_mode & FMODE_WRITE) && (file->f_flags & O_TRUNC))
> -		cleanup_all_probes();
> +		ret = cleanup_all_probes();
> +	if (ret)
> +		return ret;
>  
>  	return seq_open(file, &probes_seq_op);
>  }
> @@ -970,12 +989,17 @@ static int register_uprobe_event(struct trace_uprobe *tu)
>  	return ret;
>  }
>  
> -static void unregister_uprobe_event(struct trace_uprobe *tu)
> +static int unregister_uprobe_event(struct trace_uprobe *tu)
>  {
> +	int ret;
> +
>  	/* tu->event is unregistered in trace_remove_event_call() */
> -	trace_remove_event_call(&tu->call);
> +	ret = trace_remove_event_call(&tu->call);
> +	if (ret)
> +		return ret;
>  	kfree(tu->call.print_fmt);
>  	tu->call.print_fmt = NULL;
> +	return 0;
>  }
>  
>  /* Make a trace interface for controling probe points */


