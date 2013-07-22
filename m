Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932292Ab3GVLJF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 07:09:05 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:43151 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932170Ab3GVLJE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 07:09:04 -0400
Message-ID: <51ED12CC.4090609@hitachi.com>
Date: Mon, 22 Jul 2013 20:09:00 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.2; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Tom Zanussi <tom.zanussi@linux.intel.com>
Cc: rostedt@goodmis.org, jovi.zhangwei@huawei.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 3/9] tracing: add 'traceon' and 'traceoff' event trigger
 commands
References: <cover.1374245042.git.tom.zanussi@linux.intel.com> <b7c13bebddf866d94b0af206238d627b05d45c3f.1374245042.git.tom.zanussi@linux.intel.com>
In-Reply-To: <b7c13bebddf866d94b0af206238d627b05d45c3f.1374245042.git.tom.zanussi@linux.intel.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/07/20 0:09), Tom Zanussi wrote:
> Add 'traceon' and 'traceoff' ftrace_func_command commands.  traceon
> and traceoff event triggers are added by the user via these commands
> in a similar way and using practically the same syntax as the
> analagous 'traceon' and 'traceoff' ftrace function commands, but
> instead of writing to the set_ftrace_filter file, the traceon and
> traceoff triggers are written to the per-event 'trigger' files:
> 
>     echo 'traceon' > .../tracing/events/somesys/someevent/trigger
>     echo 'traceoff' > .../tracing/events/somesys/someevent/trigger
> 
> The above command will turn tracing on or off whenever someevent is
> hit.
> 
> This also adds a 'count' version that limits the number of times the
> command will be invoked:
> 
>     echo 'traceon:N' > .../tracing/events/somesys/someevent/trigger
>     echo 'traceoff:N' > .../tracing/events/somesys/someevent/trigger
> 
> Where N is the number of times the command will be invoked.
> 
> The above commands will will turn tracing on or off whenever someevent
> is hit, but only N times.
> 
> The event_trigger_init() and event_trigger_free() are meant to be
> common implementations of the event_trigger_ops init() and free() ops.
> Most trigger_ops implementations will use these, but some will
> override and possibly reuse them.

Please add a comment in the code. (perhaps, a separator comment is enough)

event_trigger_callback(), register_trigger and unregister_trigger in 2/9
are common for event_command func(), reg() and unreg() too.
I think it is better to move those common code in this or previous patch.

Thank you,

> Signed-off-by: Tom Zanussi <tom.zanussi@linux.intel.com>
> ---
>  include/linux/ftrace_event.h        |   1 +
>  kernel/trace/trace_events_trigger.c | 313 ++++++++++++++++++++++++++++++++++++
>  2 files changed, 314 insertions(+)
> 
> diff --git a/include/linux/ftrace_event.h b/include/linux/ftrace_event.h
> index 6cd5bbc..c794686 100644
> --- a/include/linux/ftrace_event.h
> +++ b/include/linux/ftrace_event.h
> @@ -316,6 +316,7 @@ struct ftrace_event_file {
>  
>  enum trigger_mode {
>  	TM_NONE			= (0),
> +	TM_TRACE_ONOFF		= (1 << 0),
>  };
>  
>  extern void destroy_preds(struct ftrace_event_call *call);
> diff --git a/kernel/trace/trace_events_trigger.c b/kernel/trace/trace_events_trigger.c
> index 1f0565c..f2b97b6 100644
> --- a/kernel/trace/trace_events_trigger.c
> +++ b/kernel/trace/trace_events_trigger.c
> @@ -355,7 +355,320 @@ static void unregister_trigger(char *glob, struct event_trigger_ops *ops,
>  		data->ops->free(data->ops, (void **)&data);
>  }
>  
> +int
> +event_trigger_print(const char *name, struct seq_file *m,
> +		    void *data, char *filter_str)
> +{
> +	long count = (long)data;
> +
> +	seq_printf(m, "%s", name);
> +
> +	if (count == -1)
> +		seq_puts(m, ":unlimited");
> +	else
> +		seq_printf(m, ":count=%ld", count);
> +
> +	if (filter_str)
> +		seq_printf(m, " if %s\n", filter_str);
> +	else
> +		seq_puts(m, "\n");
> +
> +	return 0;
> +}
> +
> +static int
> +event_trigger_init(struct event_trigger_ops *ops, void **_data)
> +{
> +	struct event_trigger_data **p = (struct event_trigger_data **)_data;
> +	struct event_trigger_data *data = *p;
> +
> +	data->ref++;
> +	return 0;
> +}
> +
> +static void
> +event_trigger_free(struct event_trigger_ops *ops, void **_data)
> +{
> +	struct event_trigger_data **p = (struct event_trigger_data **)_data;
> +	struct event_trigger_data *data = *p;
> +
> +	if (WARN_ON_ONCE(data->ref <= 0))
> +		return;
> +
> +	data->ref--;
> +	if (!data->ref)
> +		kfree(data);
> +}
> +
> +static int
> +event_trigger_callback(struct event_command *cmd_ops, void *cmd_data,
> +		       char *glob, char *cmd, char *param, int enabled)
> +{
> +	struct event_trigger_ops *trigger_ops;
> +	struct event_trigger_data *trigger_data;
> +	char *trigger = NULL;
> +	char *number;
> +	int ret;
> +
> +	if (!enabled)
> +		return -EINVAL;
> +
> +	/* separate the trigger from the filter (t:n [if filter]) */
> +	if (param && isdigit(param[0]))
> +		trigger = strsep(&param, " \t");
> +
> +	mutex_lock(&event_mutex);
> +
> +	trigger_ops = cmd_ops->get_trigger_ops(cmd, trigger);
> +
> +	ret = -ENOMEM;
> +	trigger_data = kzalloc(sizeof(*trigger_data), GFP_KERNEL);
> +	if (!trigger_data)
> +		goto out;
> +
> +	trigger_data->count = -1;
> +	trigger_data->ops = trigger_ops;
> +	trigger_data->mode = cmd_ops->trigger_mode;
> +	INIT_LIST_HEAD(&trigger_data->list);
> +
> +	if (glob[0] == '!') {
> +		cmd_ops->unreg(glob+1, trigger_ops, trigger_data, cmd_data);
> +		kfree(trigger_data);
> +		ret = 0;
> +		goto out;
> +	}
> +
> +	if (trigger) {
> +		number = strsep(&trigger, ":");
> +
> +		ret = -EINVAL;
> +		if (!strlen(number))
> +			goto out_free;
> +
> +		/*
> +		 * We use the callback data field (which is a pointer)
> +		 * as our counter.
> +		 */
> +		ret = kstrtoul(number, 0, &trigger_data->count);
> +		if (ret)
> +			goto out_free;
> +	}
> +
> +	if (!param) /* if param is non-empty, it's supposed to be a filter */
> +		goto out_reg;
> +
> +	if (!cmd_ops->set_filter)
> +		goto out_reg;
> +
> +	ret = cmd_ops->set_filter(param, trigger_data, cmd_data);
> +	if (ret < 0)
> +		goto out_free;
> +
> + out_reg:
> +	ret = cmd_ops->reg(glob, trigger_ops, trigger_data, cmd_data);
> +	/*
> +	 * The above returns on success the # of functions enabled,
> +	 * but if it didn't find any functions it returns zero.
> +	 * Consider no functions a failure too.
> +	 */
> +	if (!ret) {
> +		ret = -ENOENT;
> +		goto out_free;
> +	} else if (ret < 0)
> +		goto out_free;
> +	ret = 0;
> + out:
> +	mutex_unlock(&event_mutex);
> +	return ret;
> +
> + out_free:
> +	kfree(trigger_data);
> +	goto out;
> +}
> +
> +static void
> +traceon_trigger(void **_data)
> +{
> +	struct event_trigger_data **p = (struct event_trigger_data **)_data;
> +	struct event_trigger_data *data = *p;
> +
> +	if (!data)
> +		return;
> +
> +	if (tracing_is_on())
> +		return;
> +
> +	tracing_on();
> +}
> +
> +static void
> +traceon_count_trigger(void **_data)
> +{
> +	struct event_trigger_data **p = (struct event_trigger_data **)_data;
> +	struct event_trigger_data *data = *p;
> +
> +	if (!data)
> +		return;
> +
> +	if (!data->count)
> +		return;
> +
> +	if (data->count != -1)
> +		(data->count)--;
> +
> +	traceon_trigger(_data);
> +}
> +
> +static void
> +traceoff_trigger(void **_data)
> +{
> +	struct event_trigger_data **p = (struct event_trigger_data **)_data;
> +	struct event_trigger_data *data = *p;
> +
> +	if (!data)
> +		return;
> +
> +	if (!tracing_is_on())
> +		return;
> +
> +	tracing_off();
> +}
> +
> +static void
> +traceoff_count_trigger(void **_data)
> +{
> +	struct event_trigger_data **p = (struct event_trigger_data **)_data;
> +	struct event_trigger_data *data = *p;
> +
> +	if (!data)
> +		return;
> +
> +	if (!data->count)
> +		return;
> +
> +	if (data->count != -1)
> +		(data->count)--;
> +
> +	traceoff_trigger(_data);
> +}
> +
> +static int
> +traceon_trigger_print(struct seq_file *m, struct event_trigger_ops *ops,
> +		      void *_data)
> +{
> +	struct event_trigger_data *data = _data;
> +
> +	return event_trigger_print("traceon", m, (void *)data->count,
> +				   data->filter_str);
> +}
> +
> +static int
> +traceoff_trigger_print(struct seq_file *m, struct event_trigger_ops *ops,
> +		       void *_data)
> +{
> +	struct event_trigger_data *data = _data;
> +
> +	return event_trigger_print("traceoff", m, (void *)data->count,
> +				   data->filter_str);
> +}
> +
> +static struct event_trigger_ops traceon_trigger_ops = {
> +	.func			= traceon_trigger,
> +	.print			= traceon_trigger_print,
> +	.init			= event_trigger_init,
> +	.free			= event_trigger_free,
> +};
> +
> +static struct event_trigger_ops traceon_count_trigger_ops = {
> +	.func			= traceon_count_trigger,
> +	.print			= traceon_trigger_print,
> +	.init			= event_trigger_init,
> +	.free			= event_trigger_free,
> +};
> +
> +static struct event_trigger_ops traceoff_trigger_ops = {
> +	.func			= traceoff_trigger,
> +	.print			= traceoff_trigger_print,
> +	.init			= event_trigger_init,
> +	.free			= event_trigger_free,
> +};
> +
> +static struct event_trigger_ops traceoff_count_trigger_ops = {
> +	.func			= traceoff_count_trigger,
> +	.print			= traceoff_trigger_print,
> +	.init			= event_trigger_init,
> +	.free			= event_trigger_free,
> +};
> +
> +static struct event_trigger_ops *
> +onoff_get_trigger_ops(char *cmd, char *param)
> +{
> +	struct event_trigger_ops *ops;
> +
> +	/* we register both traceon and traceoff to this callback */
> +	if (strcmp(cmd, "traceon") == 0)
> +		ops = param ? &traceon_count_trigger_ops :
> +			&traceon_trigger_ops;
> +	else
> +		ops = param ? &traceoff_count_trigger_ops :
> +			&traceoff_trigger_ops;
> +
> +	return ops;
> +}
> +
> +static struct event_command trigger_traceon_cmd = {
> +	.name			= "traceon",
> +	.trigger_mode		= TM_TRACE_ONOFF,
> +	.func			= event_trigger_callback,
> +	.reg			= register_trigger,
> +	.unreg			= unregister_trigger,
> +	.get_trigger_ops	= onoff_get_trigger_ops,
> +};
> +
> +static struct event_command trigger_traceoff_cmd = {
> +	.name			= "traceoff",
> +	.trigger_mode		= TM_TRACE_ONOFF,
> +	.func			= event_trigger_callback,
> +	.reg			= register_trigger,
> +	.unreg			= unregister_trigger,
> +	.get_trigger_ops	= onoff_get_trigger_ops,
> +};
> +
> +static __init void unregister_trigger_traceon_traceoff_cmds(void)
> +{
> +	unregister_event_command(&trigger_traceon_cmd,
> +				 &trigger_commands,
> +				 &trigger_cmd_mutex);
> +	unregister_event_command(&trigger_traceoff_cmd,
> +				 &trigger_commands,
> +				 &trigger_cmd_mutex);
> +}
> +
> +static __init int register_trigger_traceon_traceoff_cmds(void)
> +{
> +	int ret;
> +
> +	ret = register_event_command(&trigger_traceon_cmd, &trigger_commands,
> +				     &trigger_cmd_mutex);
> +	if (WARN_ON(ret < 0))
> +		return ret;
> +	ret = register_event_command(&trigger_traceoff_cmd, &trigger_commands,
> +				     &trigger_cmd_mutex);
> +	if (WARN_ON(ret < 0))
> +		unregister_trigger_traceon_traceoff_cmds();
> +
> +	return ret;
> +}
> +
>  __init int register_trigger_cmds(void)
>  {
> +	int ret;
> +
> +	ret = register_trigger_traceon_traceoff_cmds();
> +	if (ret) {
> +		unregister_trigger_traceon_traceoff_cmds();
> +		return ret;
> +	}
> +
>  	return 0;
>  }
> 


-- 
Masami HIRAMATSU
IT Management Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


