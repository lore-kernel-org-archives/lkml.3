Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754728AbaAGXfG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 18:35:06 -0500
Received: from mga01.intel.com ([192.55.52.88]:13053 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754675AbaAGXe6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 18:34:58 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,621,1384329600"; 
   d="scan'208";a="461650632"
Message-ID: <1389137696.3040.145.camel@empanada>
Subject: Re: [RFC][PATCH] tracing: Show available event triggers when no
 trigger is set
From: Tom Zanussi <tom.zanussi@linux.intel.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Date: Tue, 07 Jan 2014 17:34:56 -0600
In-Reply-To: <20140107103548.0a84536d@gandalf.local.home>
References: <20140107103548.0a84536d@gandalf.local.home>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5 (3.8.5-2.fc19) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-01-07 at 10:35 -0500, Steven Rostedt wrote:
> Currently there's no way to know what triggers exist on a kernel without
> looking at the source of the kernel or randomly trying out triggers.
> Instead of creating another file in the debugfs system, simply show
> what available triggers are there when cat'ing the trigger file when
> it has no events:
> 
>  [root /sys/kernel/debug/tracing]# cat events/sched/sched_switch/trigger
>  # Available triggers:
>  # disable_event enable_event stacktrace snapshot traceoff traceon
> 
> This stays consistent with other debugfs files where meta data like
> this is always proceeded with a '#' at the start of the line so that
> tools can strip these out.

Nice idea - very helpful and makes use of that 'unused space'.  ;-)

Even better might be printing the full event formats and examples as in
tracing/README, but that would probably mean adding a new event-specific
description function to event_command, and it might get unwieldy with
too many events.  Just a thought...

Tom

> 
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> ---
>  kernel/trace/trace_events_trigger.c | 20 ++++++++++++++++++++
>  1 file changed, 20 insertions(+)
> 
> diff --git a/kernel/trace/trace_events_trigger.c b/kernel/trace/trace_events_trigger.c
> index a53e0da..90cf83c 100644
> --- a/kernel/trace/trace_events_trigger.c
> +++ b/kernel/trace/trace_events_trigger.c
> @@ -115,10 +115,15 @@ event_triggers_post_call(struct ftrace_event_file *file,
>  }
>  EXPORT_SYMBOL_GPL(event_triggers_post_call);
>  
> +#define SHOW_AVAILABLE_TRIGGERS	(void *)(1UL)
> +
>  static void *trigger_next(struct seq_file *m, void *t, loff_t *pos)
>  {
>  	struct ftrace_event_file *event_file = event_file_data(m->private);
>  
> +	if (t == SHOW_AVAILABLE_TRIGGERS)
> +		return NULL;
> +
>  	return seq_list_next(t, &event_file->triggers, pos);
>  }
>  
> @@ -132,6 +137,9 @@ static void *trigger_start(struct seq_file *m, loff_t *pos)
>  	if (unlikely(!event_file))
>  		return ERR_PTR(-ENODEV);
>  
> +	if (list_empty(&event_file->triggers))
> +		return *pos == 0 ? SHOW_AVAILABLE_TRIGGERS : NULL;
> +
>  	return seq_list_start(&event_file->triggers, *pos);
>  }
>  
> @@ -143,6 +151,18 @@ static void trigger_stop(struct seq_file *m, void *t)
>  static int trigger_show(struct seq_file *m, void *v)
>  {
>  	struct event_trigger_data *data;
> +	struct event_command *p;
> +
> +	if (v == SHOW_AVAILABLE_TRIGGERS) {
> +		seq_puts(m, "# Available triggers:\n");
> +		seq_putc(m, '#');
> +		mutex_lock(&trigger_cmd_mutex);
> +		list_for_each_entry(p, &trigger_commands, list)
> +			seq_printf(m, " %s", p->name);
> +		seq_putc(m, '\n');
> +		mutex_unlock(&trigger_cmd_mutex);
> +		return 0;
> +	}
>  
>  	data = list_entry(v, struct event_trigger_data, list);
>  	data->ops->print(m, data->ops, data);


