Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755048Ab3IMUBF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 16:01:05 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:22915 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754269Ab3IMUBE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 16:01:04 -0400
X-Authority-Analysis: v=2.0 cv=fJG7LOme c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=RZAKnY_hAFgA:10 a=5SG0PmZfjMsA:10 a=kj9zAlcOel0A:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=3NymGdysGKUA:10 a=QyXUC8HyAAAA:8 a=To9iOH5azGrx4TUw8MQA:9 a=CjuIK1q_8ugA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Date: Fri, 13 Sep 2013 16:01:00 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Tom Zanussi <tom.zanussi@linux.intel.com>
Cc: masami.hiramatsu.pt@hitachi.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v9 04/10] tracing: Add 'snapshot' event trigger command
Message-ID: <20130913160100.30686d60@gandalf.local.home>
In-Reply-To: <c1245b886d62b5154f20480c63d41a368af7cffa.1378565610.git.tom.zanussi@linux.intel.com>
References: <cover.1378565610.git.tom.zanussi@linux.intel.com>
	<c1245b886d62b5154f20480c63d41a368af7cffa.1378565610.git.tom.zanussi@linux.intel.com>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat,  7 Sep 2013 10:29:00 -0500
Tom Zanussi <tom.zanussi@linux.intel.com> wrote:


> --- a/kernel/trace/trace_events_trigger.c
> +++ b/kernel/trace/trace_events_trigger.c
> @@ -696,6 +696,74 @@ static struct event_command trigger_traceoff_cmd = {
>  	.get_trigger_ops	= onoff_get_trigger_ops,
>  };
>  
> +static void
> +snapshot_trigger(struct event_trigger_data *data)
> +{
> +	tracing_snapshot();
> +}

If CONFIG_TRACER_SNAPSHOT is not defined, then we should not bother
implementing the snapshot trigger. This should be encapsulated around
ifdefs.

> +
> +static void
> +snapshot_count_trigger(struct event_trigger_data *data)
> +{
> +	if (!data->count)
> +		return;
> +
> +	if (data->count != -1)
> +		(data->count)--;
> +
> +	snapshot_trigger(data);
> +}
> +
> +static int
> +register_snapshot_trigger(char *glob, struct event_trigger_ops *ops,
> +			  struct event_trigger_data *data,
> +			  struct ftrace_event_file *file)
> +{
> +	int ret = register_trigger(glob, ops, data, file);
> +
> +	if (ret > 0)
> +		ftrace_alloc_snapshot();
> +
> +	return ret;
> +}
> +
> +static int
> +snapshot_trigger_print(struct seq_file *m, struct event_trigger_ops *ops,
> +		       struct event_trigger_data *data)
> +{
> +	return event_trigger_print("snapshot", m, (void *)data->count,
> +				   data->filter_str);
> +}
> +
> +static struct event_trigger_ops snapshot_trigger_ops = {
> +	.func			= snapshot_trigger,
> +	.print			= snapshot_trigger_print,
> +	.init			= event_trigger_init,
> +	.free			= event_trigger_free,
> +};
> +
> +static struct event_trigger_ops snapshot_count_trigger_ops = {
> +	.func			= snapshot_count_trigger,
> +	.print			= snapshot_trigger_print,
> +	.init			= event_trigger_init,
> +	.free			= event_trigger_free,
> +};
> +
> +static struct event_trigger_ops *
> +snapshot_get_trigger_ops(char *cmd, char *param)
> +{
> +	return param ? &snapshot_count_trigger_ops : &snapshot_trigger_ops;
> +}
> +
> +static struct event_command trigger_snapshot_cmd = {
> +	.name			= "snapshot",
> +	.trigger_type		= ETT_SNAPSHOT,
> +	.func			= event_trigger_callback,
> +	.reg			= register_snapshot_trigger,
> +	.unreg			= unregister_trigger,
> +	.get_trigger_ops	= snapshot_get_trigger_ops,
> +};
> +
>  static __init void unregister_trigger_traceon_traceoff_cmds(void)
>  {
>  	unregister_event_command(&trigger_traceon_cmd);
> @@ -726,5 +794,11 @@ __init int register_trigger_cmds(void)
>  		return ret;
>  	}
>  
> +	ret = register_event_command(&trigger_snapshot_cmd);
> +	if (WARN_ON(ret < 0)) {
> +		unregister_trigger_traceon_traceoff_cmds();

If the snapshot trigger fails, why remove the traceon_traceoff trigger
if it succeeded? Is there some dependency that we should be worried
about?

Or is this just saying "if once trigger fails, they all fail!"?

-- Steve

> +		return ret;
> +	}
> +
>  	return 0;
>  }

