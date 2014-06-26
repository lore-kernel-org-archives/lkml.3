Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756892AbaFZPR4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 11:17:56 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.230]:37177 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752751AbaFZPRx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 11:17:53 -0400
Date: Thu, 26 Jun 2014 11:17:49 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Christopher Covington <cov@codeaurora.org>
Cc: Ingo Molnar <mingo@redhat.com>, Tom Zanussi <tom.zanussi@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Vagin <avagin@openvz.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Vaibhav Nagarnaik <vnagarnaik@google.com>,
        linux-kernel@vger.kernel.org, Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH] RFC: Add signal command to trace events
Message-ID: <20140626111749.3234d4d4@gandalf.local.home>
In-Reply-To: <1403791044-2214-1-git-send-email-cov@codeaurora.org>
References: <1403791044-2214-1-git-send-email-cov@codeaurora.org>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ Added Oleg who is the guru of signals ;-) ]

On Thu, 26 Jun 2014 09:57:21 -0400
Christopher Covington <cov@codeaurora.org> wrote:

> This stops a process after an event has been triggered a given
> number of times. For example:
> 
> [[ -d /sys/kernel/debug/tracing ]] || \
>   mount -t debugfs none /sys/kernel/debug
> echo "p:myevent $(which myapp):0x700" > /sys/kernel/debug/tracing/uprobe_events
> echo 1 > /sys/kernel/debug/tracing/events/uprobes/myevent/enable
> echo 'signal:3' > /sys/kernel/debug/tracing/events/uprobes/myevent/trigger
> myapp
> myapp
> myapp &
> 
> Here, the 0x700 offset is the entry to main(). On the third
> invocation of the program, the process is stopped.
> 

Interesting trigger. I can see this being useful.

> Signed-off-by: Christopher Covington <cov@codeaurora.org>
> ---
>  include/linux/ftrace_event.h        |  1 +
>  kernel/trace/trace_events_trigger.c | 73 +++++++++++++++++++++++++++++++++++++
>  2 files changed, 74 insertions(+)
> 
> diff --git a/include/linux/ftrace_event.h b/include/linux/ftrace_event.h
> index cff3106..7bca0df 100644
> --- a/include/linux/ftrace_event.h
> +++ b/include/linux/ftrace_event.h
> @@ -402,6 +402,7 @@ enum event_trigger_type {
>  	ETT_SNAPSHOT		= (1 << 1),
>  	ETT_STACKTRACE		= (1 << 2),
>  	ETT_EVENT_ENABLE	= (1 << 3),
> +	ETT_SIGNAL		= (1 << 4),
>  };
>  
>  extern void destroy_preds(struct ftrace_event_file *file);
> diff --git a/kernel/trace/trace_events_trigger.c b/kernel/trace/trace_events_trigger.c
> index 4747b47..d0599fa 100644
> --- a/kernel/trace/trace_events_trigger.c
> +++ b/kernel/trace/trace_events_trigger.c
> @@ -1042,6 +1042,78 @@ static __init int register_trigger_stacktrace_cmd(void)
>  static __init int register_trigger_stacktrace_cmd(void) { return 0; }
>  #endif /* CONFIG_STACKTRACE */
>  
> +//ifdef CONFIG_TRACER_SIGNAL
> +static void
> +signal_trigger(struct event_trigger_data *data)
> +{
> +	force_sig(SIGSTOP, current);

Here's the issue though. Events can happen most anywhere. An event
context you need to be very careful what you do. force_sig() is not a
light weight function by any means. Basically, anything that grabs
spinlocks must be extremely careful, because you can have an event in
most functions and you may have just introduced a inverse locking
order. Can you take the signal spinlock when holding the rq lock?
There's several tracepoints that are called while holding the rq lock.

But don't fret. All is not lost.

What can be done is use irq_work instead. This is very useful as well.
Although it will have a delayed effect. Maybe you can do the following:

	if (irqs_disabled())
		irq_work_queue(...);
	else
		force_sig(...);

That is, if interrupts are enabled, it is pretty much guaranteed that
calling force_sig() is safe. Heck, interrupts can do it. If not, then
we need to delay the action, because it may not be safe. Unfortunately,
I believe uprobe tracepoints are called with interrupts diasbled (at
least it shows that in my trace of a uprobe).

-- Steve

> +}
> +
> +static void
> +signal_count_trigger(struct event_trigger_data *data)
> +{
> +	switch(data->count) {
> +	case 0:
> +		return;
> +	case 1:
> +		signal_trigger(data);
> +		// fall through
> +	default:
> +		(data->count)--;
> +	}
> +}
> +
> +static int
> +signal_trigger_print(struct seq_file *m, struct event_trigger_ops *ops,
> +		       struct event_trigger_data *data)
> +{
> +	return event_trigger_print("signal", m, (void *)data->count,
> +				   data->filter_str);
> +}
> +
> +static struct event_trigger_ops signal_trigger_ops = {
> +	.func			= signal_trigger,
> +	.print			= signal_trigger_print,
> +	.init			= event_trigger_init,
> +	.free			= event_trigger_free,
> +};
> +
> +static struct event_trigger_ops signal_count_trigger_ops = {
> +	.func			= signal_count_trigger,
> +	.print			= signal_trigger_print,
> +	.init			= event_trigger_init,
> +	.free			= event_trigger_free,
> +};
> +
> +static struct event_trigger_ops *
> +signal_get_trigger_ops(char *cmd, char *param)
> +{
> +	return param ? &signal_count_trigger_ops : &signal_trigger_ops;
> +}
> +
> +static struct event_command trigger_signal_cmd = {
> +	.name			= "signal",
> +	.trigger_type		= ETT_SIGNAL,
> +	.func			= event_trigger_callback,
> +	.reg			= register_trigger,
> +	.unreg			= unregister_trigger,
> +	.get_trigger_ops	= signal_get_trigger_ops,
> +	.set_filter		= set_trigger_filter,
> +};
> +
> +static __init int register_trigger_signal_cmd(void)
> +{
> +	int ret;
> +
> +	ret = register_event_command(&trigger_signal_cmd);
> +	WARN_ON(ret < 0);
> +
> +	return ret;
> +}
> +/* else
> +static __init int register_trigger_signal_cmd(void) { return 0; }
> +endif CONFIG_TRACER_SIGNAL */
> +
>  static __init void unregister_trigger_traceon_traceoff_cmds(void)
>  {
>  	unregister_event_command(&trigger_traceon_cmd);
> @@ -1432,6 +1504,7 @@ __init int register_trigger_cmds(void)
>  	register_trigger_snapshot_cmd();
>  	register_trigger_stacktrace_cmd();
>  	register_trigger_enable_disable_cmds();
> +	register_trigger_signal_cmd();
>  
>  	return 0;
>  }

